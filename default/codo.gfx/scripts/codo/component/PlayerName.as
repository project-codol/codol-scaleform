package codo.component
{
   import codo.constants.BCEvent;
   import codo.manager.EventManager;
   import codo.objects.PlayerBasicInfoObj;
   import codo.objects.PlayerNameSettings;
   import codo.objects.RightClickCustomData;
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   import codo.utils.CursorUtil;
   import codo.utils.ScaleformUtil;
   import codo.utils.StringUtil;
   import flash.display.MovieClip;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import scaleform.gfx.MouseEventEx;
   
   public class PlayerName extends MovieClip
   {
      
      private var mSetting:PlayerNameSettings;
      
      private var mName:String;
      
      private var mID:String;
      
      private var mIsOver:Boolean = false;
      
      private var mInteractible:Boolean = true;
      
      private var mCustomData:RightClickCustomData;
      
      private var mOverWrittenBasicInfo:PlayerBasicInfoObj;
      
      public var myTextField:TextField;
      
      public function PlayerName()
      {
         super();
      }
      
      public function set settings(newSettings:PlayerNameSettings) : void
      {
         this.mSetting = newSettings;
         this.bundleEvent();
         this.myTextField.font = GlobalGuide.FONT_FACE_MEDIUM;
         this.myTextField.alignment = TextStyle.HALIGN_LEFT;
         this.myTextField.alignmentVertical = TextStyle.VALIGN_MIDDLE;
         this.myTextField.multiline = false;
         this.myTextField.wordWrap = false;
         this.myTextField.width = this.mSetting.textWidth;
         this.myTextField.height = this.mSetting.textHeight;
         this.myTextField.fontSize = this.mSetting.fontSize;
         this.myTextField.fontColor = this.mSetting.textColor;
         if(newSettings.fitSizeMethod == PlayerNameSettings.FIT_SIZE_METHOD_TRUNCATE)
         {
            this.myTextField.enableTruncate(true);
            this.myTextField.autoSize = TextFieldAutoSize.NONE;
         }
         else if(newSettings.fitSizeMethod == PlayerNameSettings.FIT_SIZE_METHOD_EXTEND)
         {
            this.myTextField.enableTruncate(false);
            this.myTextField.autoSize = TextFieldAutoSize.LEFT;
         }
         else if(newSettings.fitSizeMethod == PlayerNameSettings.FIT_SIZE_METHOD_SMALL_FONT)
         {
            this.myTextField.enableTruncate(false);
            this.myTextField.autoSize = TextFieldAutoSize.NONE;
         }
      }
      
      public function setData(name:String, id:String, overWrittenBasicInfo:PlayerBasicInfoObj = null, showTeamTag:Boolean = false) : void
      {
         if(!showTeamTag)
         {
            this.myTextField.myTextClip.width = this.mSetting.textWidth;
         }
         else
         {
            this.myTextField.myTextClip.width = this.mSetting.textWidth - 55;
         }
         this.mName = name;
         this.mID = id;
         this.mOverWrittenBasicInfo = overWrittenBasicInfo;
         this.myTextField.text = this.mName;
         if(this.mSetting.fitSizeMethod == PlayerNameSettings.FIT_SIZE_METHOD_SMALL_FONT)
         {
            StringUtil.fitTextField(this.myTextField.myTextClip);
         }
         this.myTextField.myTextClip.width = this.myTextField.myTextClip.textWidth + 10;
         this.interactible = this.mID != "" && this.mID != "0";
         this.unhighlight();
      }
      
      public function get textField() : TextField
      {
         return this.myTextField;
      }
      
      public function set customData(data:RightClickCustomData) : void
      {
         this.mCustomData = data;
      }
      
      public function dispose() : void
      {
         if(this.mSetting.mode == PlayerNameSettings.MODE_DIRECT)
         {
            this.myTextField.myTextClip.removeEventListener(MouseEvent.ROLL_OVER,this.onMouseRollOverHandler);
            this.myTextField.myTextClip.removeEventListener(MouseEvent.ROLL_OUT,this.onMouseRollOutHandler);
            this.myTextField.myTextClip.removeEventListener(MouseEvent.CLICK,this.onMouseClickHandler);
         }
         else if(this.mSetting.mode == PlayerNameSettings.MODE_INDIRECT)
         {
            this.unbindStageEvent(stage);
            removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
            removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         }
      }
      
      public function set interactible(value:Boolean) : void
      {
         this.mInteractible = value;
      }
      
      private function bundleEvent() : void
      {
         if(this.mSetting.mode == PlayerNameSettings.MODE_DIRECT)
         {
            this.myTextField.myTextClip.addEventListener(MouseEvent.ROLL_OVER,this.onMouseRollOverHandler);
            this.myTextField.myTextClip.addEventListener(MouseEvent.ROLL_OUT,this.onMouseRollOutHandler);
            this.myTextField.myTextClip.addEventListener(MouseEvent.CLICK,this.onMouseClickHandler);
         }
         else if(this.mSetting.mode == PlayerNameSettings.MODE_INDIRECT)
         {
            this.bindStageEvent(stage);
            addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
            addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         }
      }
      
      private function highlight() : void
      {
         if(this.mSetting.customHighlight)
         {
            return;
         }
         var tfm:TextFormat = this.myTextField.myTextClip.getTextFormat();
         tfm.underline = true;
         this.myTextField.myTextClip.setTextFormat(tfm);
         CursorUtil.BeginCursor(CursorUtil.CURSOR_OVER_BUTTON);
      }
      
      private function unhighlight() : void
      {
         if(this.mSetting.customHighlight)
         {
            return;
         }
         var tfm:TextFormat = this.myTextField.myTextClip.getTextFormat();
         tfm.underline = false;
         this.myTextField.myTextClip.setTextFormat(tfm);
         CursorUtil.EndCursor(CursorUtil.CURSOR_OVER_BUTTON);
      }
      
      private function onMouseRollOverHandler(e:MouseEvent) : void
      {
         var anchor1:Point = null;
         var anchor2:Point = null;
         if(this.mInteractible)
         {
            this.mIsOver = true;
            anchor1 = localToGlobal(new Point(this.myTextField.x,this.myTextField.y));
            anchor2 = localToGlobal(new Point(this.myTextField.x + this.myTextField.textWidth,this.myTextField.y + this.myTextField.textHeight));
            EventManager.getInstance().broadcast(BCEvent.EVT_SHOW_PLAYER_CARD,[this.mID,this.mName,anchor1,anchor2,this.mOverWrittenBasicInfo]);
            this.highlight();
         }
      }
      
      private function onMouseRollOutHandler(e:MouseEvent) : void
      {
         if(this.mInteractible)
         {
            this.mIsOver = false;
            EventManager.getInstance().broadcast(BCEvent.EVT_HIDE_PLAYER_CARD);
            this.unhighlight();
         }
      }
      
      private function onMouseClickHandler(e:MouseEvent) : void
      {
         var evtEx:MouseEventEx = null;
         var anchor1:Point = null;
         var anchor2:Point = null;
         if(this.mID != "" && this.mInteractible && this.mIsOver)
         {
            if(ScaleformUtil.isScaleform)
            {
               evtEx = e as MouseEventEx;
               if(evtEx.buttonIdx == MouseEventEx.LEFT_BUTTON || evtEx.buttonIdx == MouseEventEx.RIGHT_BUTTON)
               {
                  e.stopPropagation();
                  anchor1 = localToGlobal(new Point(this.myTextField.x,this.myTextField.y));
                  anchor2 = localToGlobal(new Point(this.myTextField.x + this.myTextField.textWidth,this.myTextField.y + this.myTextField.textHeight));
                  EventManager.getInstance().broadcast(BCEvent.EVT_SHOW_PLAYER_CONTEXT_MENU,[this.mSetting.rightClickType,this.mID,this.mName,anchor1,anchor2,this.mCustomData]);
               }
            }
         }
      }
      
      private function onAddedToStage(e:Event) : void
      {
         var stageObj:Stage = this.stage;
         this.bindStageEvent(stageObj);
      }
      
      private function onRemovedFromStage(e:Event) : void
      {
         var stageObj:Stage = this.stage;
         this.unbindStageEvent(stageObj);
      }
      
      private function bindStageEvent(myStage:Stage) : void
      {
         if(Boolean(myStage))
         {
            myStage.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMoveHandler);
            myStage.addEventListener(MouseEvent.CLICK,this.onMouseClickHandler);
         }
      }
      
      private function unbindStageEvent(myStage:Stage) : void
      {
         if(Boolean(myStage))
         {
            myStage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMoveHandler);
            myStage.removeEventListener(MouseEvent.CLICK,this.onMouseClickHandler);
         }
      }
      
      private function onMouseMoveHandler(e:MouseEvent) : void
      {
         var newIsOver:Boolean = this.myTextField.myTextClip.hitTestPoint(e.stageX,e.stageY,false);
         if(this.mIsOver != newIsOver)
         {
            this.mIsOver = newIsOver;
            if(this.mIsOver)
            {
               this.highlight();
            }
            else
            {
               this.unhighlight();
            }
         }
      }
   }
}

