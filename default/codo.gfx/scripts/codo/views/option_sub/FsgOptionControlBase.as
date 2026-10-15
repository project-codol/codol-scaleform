package codo.views.option_sub
{
   import codo.common.CFunctionCommonContainer;
   import codo.constants.BCEvent;
   import codo.constants.CODOVirtualKey;
   import codo.constants.Common;
   import codo.constants.DataID;
   import codo.event.ParaEvent;
   import codo.localization.DictSetting;
   import codo.utils.Logger;
   import components.option_part.FsgKeyBoxButton;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.Dictionary;
   import scaleform.gfx.MouseEventEx;
   
   public class FsgOptionControlBase extends FsgOptionPanel
   {
      
      protected var _currentBtnIndex:uint = 0;
      
      protected var _isChangingBind:Boolean = false;
      
      protected var _isMouseDownDuringBind:Boolean = false;
      
      public var myTFChangeBindHint:TextField;
      
      public var myKB:Array;
      
      private var m_bindings:Dictionary;
      
      public function FsgOptionControlBase()
      {
         super();
      }
      
      override public function active() : void
      {
         super.active();
         this.stage.addEventListener(KeyboardEvent.KEY_UP,this.onStageKeyUpHandle);
         this.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onStageKeyDownHandle);
         this.refreshAllCommands();
      }
      
      override public function deactive() : void
      {
         super.deactive();
         if(this.stage != null)
         {
            this.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onStageKeyDownHandle);
         }
      }
      
      override protected function onInit() : void
      {
         this.myTFChangeBindHint.text = DictSetting.CONTROL_BINDING_HINT_1;
      }
      
      override public function showView() : void
      {
         super.showView();
         this.storeBindings();
         this.listen(BCEvent.EVT_CLOSING_GAME,this.onClosingGameHandle);
      }
      
      override public function hideView() : void
      {
         super.hideView();
         if(this.getDP(DataID.VITAL_COMMANDS_BOUNDED,[false]) == false)
         {
            this.restoreBindings();
         }
         this.unlisten(BCEvent.EVT_CLOSING_GAME,this.onClosingGameHandle);
      }
      
      override protected function onInitListener() : void
      {
         this.listen(BCEvent.EVT_OPTION_COMMANDS_UNBOUND,this.onUnbondHandle);
         this.listen(BCEvent.EVT_BIND_KEY_FINISH,this.finishKeyBinding);
         this.listen(BCEvent.EVT_RESET_CONTROLSHANDLE,this.onResetControlsHandle);
         this.listen(BCEvent.EVT_REFRESH_CONTROL_VIEW,this.onRefreshControlViewHandle);
      }
      
      protected function onResetControlsHandle(cEvt:ParaEvent) : void
      {
      }
      
      protected function onRefreshControlViewHandle() : void
      {
         this.refreshAllCommands();
         this.storeBindings();
      }
      
      protected function onUnbondHandle(cEvt:ParaEvent) : void
      {
      }
      
      protected function addBtnListener(cBtn:FsgKeyBoxButton) : void
      {
         cBtn.registerClickEvent(this.onBtnClickHandle,cBtn);
      }
      
      protected function onBtnClickHandle(userData:Object) : void
      {
         this.broadcast(BCEvent.EVT_TOGGLE_GLOBAL_KEY_CATCH,false);
         if(this._isChangingBind)
         {
            return;
         }
         if(this._isMouseDownDuringBind)
         {
            this._isMouseDownDuringBind = false;
            return;
         }
         var btn:FsgKeyBoxButton = userData as FsgKeyBoxButton;
         btn.value = "???";
         this._isChangingBind = true;
         this._currentBtnIndex = btn.name.split("_")[1];
         this.myTFChangeBindHint.text = DictSetting.CONTROL_BINDING_HINT_2;
         this.stage.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDownHandle,true);
         this.stage.addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheelHandle,true);
      }
      
      protected function setCBBind(bBind:Boolean, command:String, associatedCommand:String) : void
      {
         this.broadcast(BCEvent.EVT_BIND_KEY_TO_HOLD_COMMAND,{
            "cmd0":(bBind ? associatedCommand : command),
            "cmd1":(bBind ? command : associatedCommand)
         });
      }
      
      protected function bindKeyToCmd(keyNum:uint, cmd:String, bMouse:Boolean = false) : void
      {
         keyNum = bMouse ? keyNum : uint(this.getDP(DataID.MAPPING_KEY,[keyNum]));
         this.broadcast(BCEvent.EVT_BIND_KEY_TO_COMMAND,{
            "key":keyNum,
            "cmd":cmd
         });
         this.refreshAllCommands();
         this.stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDownHandle,true);
         this.stage.removeEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheelHandle,true);
         this.myTFChangeBindHint.text = DictSetting.CONTROL_BINDING_HINT_1;
         this._isChangingBind = false;
         this.broadcast(BCEvent.EVT_TOGGLE_GLOBAL_KEY_CATCH,true);
      }
      
      private function resetBindings() : void
      {
         this.m_bindings = new Dictionary(true);
      }
      
      private function storeBindings() : void
      {
         var cmd:String = null;
         this.resetBindings();
         for(var i:int = 0; i < this.myKB.length; i++)
         {
            cmd = this.mapBtnToCmd(i);
            this.m_bindings[cmd] = CFunctionCommonContainer.GetKeyBindingValuesFromCommand(cmd);
         }
      }
      
      protected function finishKeyBinding(cEvt:Event) : void
      {
         this.refreshAllCommands();
      }
      
      protected function refreshCBState() : void
      {
      }
      
      override public function onCancelSettings() : void
      {
         this.restoreBindings();
         super.onCancelSettings();
         if(!this.getDP(DataID.VITAL_COMMANDS_BOUNDED,[false]))
         {
            this.refreshAllCommands();
         }
      }
      
      protected function refreshAllCommands() : void
      {
         for(var i:int = 0; i < this.myKB.length; i++)
         {
            this.myKB[i].value = this.getDP(DataID.KEY_BINDING_NAMES_ON_COMMAND,[this.mapBtnToCmd(i)]);
         }
         this.refreshCBState();
      }
      
      protected function onClosingGameHandle() : void
      {
         this.restoreBindings();
      }
      
      protected function restoreBindings() : void
      {
         var cmd:* = undefined;
         var keys:Array = null;
         var i:int = 0;
         var key:uint = 0;
         for(cmd in this.m_bindings)
         {
            if(this.keyBindingHasChanged(cmd) == true)
            {
               CFunctionCommonContainer.ClearKeyBindingForCommand(cmd);
            }
         }
         for(cmd in this.m_bindings)
         {
            if(this.keyBindingHasChanged(cmd) == true)
            {
               keys = this.m_bindings[cmd];
               for(i = 0; i < keys.length; i++)
               {
                  key = uint(keys[i]);
                  this.broadcast(BCEvent.EVT_BIND_KEY_TO_COMMAND,{
                     "key":key,
                     "cmd":cmd
                  });
               }
            }
         }
      }
      
      protected function keyBindingHasChanged(cmd:String) : Boolean
      {
         var i:int = 0;
         var boundKey:uint = 0;
         var previousKey:uint = 0;
         var boundKeys:Array = CFunctionCommonContainer.GetKeyBindingValuesFromCommand(cmd);
         var previousKeys:Array = this.m_bindings[cmd];
         if(boundKeys.length != previousKeys.length)
         {
            return true;
         }
         for(i = 0; i < boundKeys.length; i++)
         {
            boundKey = uint(boundKeys[i]);
            previousKey = uint(previousKeys[i]);
            if(boundKey != previousKey)
            {
               return true;
            }
         }
         return false;
      }
      
      protected function onMouseDownHandle(cEvt:MouseEvent) : void
      {
         if(!(cEvt is MouseEventEx) || !this._isChangingBind)
         {
            return;
         }
         var keyNum:uint = 0;
         var evt:MouseEventEx = cEvt as MouseEventEx;
         this._isMouseDownDuringBind = evt.buttonIdx == MouseEventEx.LEFT_BUTTON || evt.buttonIdx == MouseEventEx.RIGHT_BUTTON || evt.buttonIdx == Common.MOUSEBUTTON_SIDE1 || evt.buttonIdx == Common.MOUSEBUTTON_SIDE2;
         switch(evt.buttonIdx)
         {
            case 0:
               keyNum = uint(CODOVirtualKey.K_MOUSE1);
               break;
            case 1:
               keyNum = uint(CODOVirtualKey.K_MOUSE2);
               break;
            case 2:
               keyNum = uint(CODOVirtualKey.K_MOUSE3);
               break;
            case 3:
               keyNum = uint(CODOVirtualKey.K_MOUSE4);
               break;
            case 4:
               keyNum = uint(CODOVirtualKey.K_MOUSE5);
         }
         this.bindKeyToCmd(keyNum,this.mapBtnToCmd(this._currentBtnIndex),true);
      }
      
      protected function mapBtnToCmd(cBtn:uint) : String
      {
         return "invalid";
      }
      
      protected function onMouseWheelHandle(cEvt:MouseEvent) : void
      {
         if(!this._isChangingBind)
         {
            return;
         }
         var keyNum:uint = cEvt.delta < 0 ? uint(CODOVirtualKey.K_MWHEELDOWN) : uint(CODOVirtualKey.K_MWHEELUP);
         this.bindKeyToCmd(keyNum,this.mapBtnToCmd(this._currentBtnIndex),true);
      }
      
      protected function onStageKeyDownHandle(cEvt:KeyboardEvent) : void
      {
         if(!this._isChangingBind)
         {
            return;
         }
         this.bindKeyToCmd(cEvt.keyCode,this.mapBtnToCmd(this._currentBtnIndex));
      }
      
      protected function onStageKeyUpHandle(cEvt:KeyboardEvent) : void
      {
         if(!this._isChangingBind)
         {
            return;
         }
         if(cEvt.keyCode == 44)
         {
            Logger.print("Print Screen pressed");
            this.bindKeyToCmd(cEvt.keyCode,this.mapBtnToCmd(this._currentBtnIndex));
         }
      }
   }
}

