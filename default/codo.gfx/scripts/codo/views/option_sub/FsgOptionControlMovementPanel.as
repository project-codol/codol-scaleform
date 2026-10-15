package codo.views.option_sub
{
   import codo.constants.DataID;
   import codo.event.ParaEvent;
   import codo.localization.DictSetting;
   import fsg.shared.CheckBox;
   
   public class FsgOptionControlMovementPanel extends FsgOptionControlBase
   {
      
      private static const KB_MOVE_FORWARD:uint = 0;
      
      private static const KB_MOVE_BACK:uint = 1;
      
      private static const KB_STRAFE_LEFT:uint = 2;
      
      private static const KB_STRAFE_RIGHT:uint = 3;
      
      private static const KB_STAND_JUMP:uint = 4;
      
      private static const KB_CROUCH:uint = 5;
      
      private static const KB_PRONE:uint = 6;
      
      private static const KB_SPRINT_HOLD_BREATH:uint = 7;
      
      private static const KB_TOGGLE_STANCE:uint = 8;
      
      private static const KB_SPRINT:uint = 9;
      
      private static const KB_HOLD_BREATH:uint = 10;
      
      private static const KB_TURN_LEFT:uint = 11;
      
      private static const KB_TURN_RIGHT:uint = 12;
      
      private static const KB_HOLD_STRAFE:uint = 13;
      
      private static const SRC_NAME_CONTROL_BTN:String = "myKB_";
      
      private static var CONTROL_BTN_NUM:int = 14;
      
      private static var CONTROL_CMD:Array = ["+forward","+back","+moveleft","+moveright","+gostand","togglecrouch","toggleprone","+breath_sprint","+stance","+sprint","+holdbreath","+left","+right","+strafe"];
      
      private static var CONTROL_CMD_2:Array = ["+movedown","+prone"];
      
      public var myCBCrouch:CheckBox;
      
      public var myCBProne:CheckBox;
      
      public function FsgOptionControlMovementPanel()
      {
         super();
         myKB = new Array(CONTROL_BTN_NUM);
         for(var i:uint = 0; i < CONTROL_BTN_NUM; i++)
         {
            myKB[i] = this[SRC_NAME_CONTROL_BTN + i];
         }
      }
      
      override protected function onInit() : void
      {
         super.onInit();
         this.myKB[KB_MOVE_FORWARD].label = DictSetting.CONTROL_MOVE_FORWARD;
         this.myKB[KB_MOVE_BACK].label = DictSetting.CONTROL_MOVE_BACK;
         this.myKB[KB_STRAFE_LEFT].label = DictSetting.CONTROL_MOVE_LEFT;
         this.myKB[KB_STRAFE_RIGHT].label = DictSetting.CONTROL_MOVE_RIGHT;
         this.myKB[KB_STAND_JUMP].label = DictSetting.CONTROL_STAND_JUMP;
         this.myKB[KB_CROUCH].label = DictSetting.CONTROL_CROUCH;
         this.myKB[KB_PRONE].label = DictSetting.CONTROL_PRONE;
         this.myKB[KB_SPRINT_HOLD_BREATH].label = DictSetting.CONTROL_SPRINT_HOLD_BREATH;
         this.myKB[KB_TOGGLE_STANCE].label = DictSetting.CONTROL_CHANGE_STANCE;
         this.myKB[KB_SPRINT].label = DictSetting.CONTROL_SPRINT;
         this.myKB[KB_HOLD_BREATH].label = DictSetting.CONTROL_HOLD_BREATH;
         this.myKB[KB_TURN_LEFT].label = DictSetting.CONTROL_TURN_LEFT;
         this.myKB[KB_TURN_RIGHT].label = DictSetting.CONTROL_TURN_RIGHT;
         this.myKB[KB_HOLD_STRAFE].label = DictSetting.CONTROL_HOLD_STRAFE;
         this.myCBCrouch.setText(DictSetting.CONTROL_NEED_LONG_PRESS,null);
         this.myCBProne.setText(DictSetting.CONTROL_NEED_LONG_PRESS,null);
      }
      
      override protected function onInitListener() : void
      {
         super.onInitListener();
         this.myCBCrouch.addCheckedCallback(this.onCBClickHandle,this.myCBCrouch);
         this.myCBCrouch.addUncheckedCallback(this.onCBClickHandle,this.myCBCrouch);
         this.myCBProne.addCheckedCallback(this.onCBClickHandle,this.myCBProne);
         this.myCBProne.addUncheckedCallback(this.onCBClickHandle,this.myCBProne);
         for(var i:int = 0; i < CONTROL_BTN_NUM; i++)
         {
            this.addBtnListener(this.myKB[i]);
         }
      }
      
      override public function active() : void
      {
         super.active();
         this.myCBCrouch.checked = this.getDP(DataID.KEY_BINDING_COUNT_ON_COMMAND,[CONTROL_CMD_2[0]]) > 0;
         this.myCBProne.checked = this.getDP(DataID.KEY_BINDING_COUNT_ON_COMMAND,[CONTROL_CMD_2[1]]) > 0;
      }
      
      override protected function onResetControlsHandle(cEvt:ParaEvent) : void
      {
         super.onResetControlsHandle(cEvt);
         this.myCBCrouch.checked = false;
         this.myCBProne.checked = false;
      }
      
      override protected function onUnbondHandle(cEvt:ParaEvent) : void
      {
         var j:int = 0;
         super.onUnbondHandle(cEvt);
         var keyArray:Array = cEvt.myPara;
         for(var i:int = 0; i < CONTROL_CMD.length; i++)
         {
            this.myKB[i].warn = false;
            for(j = 0; j < keyArray.length; j++)
            {
               if(CONTROL_CMD[i] == keyArray[j])
               {
                  this.myKB[i].warn = true;
               }
            }
         }
      }
      
      override protected function mapBtnToCmd(cBtn:uint) : String
      {
         return CONTROL_CMD[cBtn];
      }
      
      override public function onAcceptSettings() : void
      {
         super.onAcceptSettings();
         this.setCBBind(this.myCBCrouch.checked,CONTROL_CMD_2[0],CONTROL_CMD[5]);
         this.setCBBind(this.myCBProne.checked,CONTROL_CMD_2[1],CONTROL_CMD[6]);
      }
      
      override protected function refreshAllCommands() : void
      {
         super.refreshAllCommands();
         for(var i:int = 0; i < CONTROL_BTN_NUM; i++)
         {
            if(i == 5 && this.myCBCrouch.checked)
            {
               this.myKB[i].value = this.getDP(DataID.KEY_BINDING_NAMES_ON_COMMAND,[CONTROL_CMD_2[0]]);
            }
            else if(i == 6 && this.myCBProne.checked)
            {
               this.myKB[i].value = this.getDP(DataID.KEY_BINDING_NAMES_ON_COMMAND,[CONTROL_CMD_2[1]]);
            }
         }
      }
      
      private function onCBClickHandle(userData:Object) : void
      {
         var cb:CheckBox = userData as CheckBox;
         switch(cb)
         {
            case this.myCBCrouch:
            case this.myCBProne:
         }
      }
      
      override protected function bindKeyToCmd(keyNum:uint, cmd:String, bMouse:Boolean = false) : void
      {
         if(this._currentBtnIndex == 5 && this.myCBCrouch.checked)
         {
            cmd = CONTROL_CMD_2[0];
         }
         else if(this._currentBtnIndex == 6 && this.myCBProne.checked)
         {
            cmd = CONTROL_CMD_2[1];
         }
         super.bindKeyToCmd(keyNum,cmd,bMouse);
      }
   }
}

