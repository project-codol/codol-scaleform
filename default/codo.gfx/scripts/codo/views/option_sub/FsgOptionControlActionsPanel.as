package codo.views.option_sub
{
   import codo.constants.DataID;
   import codo.event.ParaEvent;
   import codo.localization.DictSetting;
   import fsg.shared.CheckBox;
   
   public class FsgOptionControlActionsPanel extends FsgOptionControlBase
   {
      
      private static const KB_FIRE_WEAPON:uint = 0;
      
      private static const KB_AIM_DOWN_SIGHT:uint = 1;
      
      private static const KB_RELOAD:uint = 2;
      
      private static const KB_SWITCH_WEAPON:uint = 3;
      
      private static const KB_SWITCH_WEAPON_2:uint = 4;
      
      private static const KB_MELEE:uint = 5;
      
      private static const KB_USE:uint = 6;
      
      private static const KB_THROW_LETHAL_GRENADE:uint = 7;
      
      private static const KB_USE_EQUIPMENT:uint = 8;
      
      private static const KB_WEAPON_ATTACHMENT:uint = 9;
      
      private static const KB_INVENTORY:uint = 10;
      
      private static const KB_SECOND_INVENTORY:uint = 11;
      
      private static const KB_USE_KILL_STREAK:uint = 12;
      
      private static const KB_SHOW_OBJECTIVE:uint = 13;
      
      private static const KB_SWAP_WEAPON:uint = 14;
      
      private static const KB_SWITCH_SCOPE:uint = 15;
      
      private static const SRC_NAME_CONTROL_BTN:String = "myKB_";
      
      private static var CONTROL_BTN_NUM:int = 16;
      
      private static var CONTROL_CMD:Array = ["+attack","+toggleads_throw","+reload","weapnext","weapprev","+melee","+activate","+frag","+tact","weapalt","+actionslot 2","+actionslot 3","+actionslot 4","+actionslot 1","+scores","+switchscope"];
      
      private static var CONTROL_CMD_2:Array = ["+speed_throw"];
      
      public var myCBAimDownSight:CheckBox;
      
      public function FsgOptionControlActionsPanel()
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
         this.myKB[KB_FIRE_WEAPON].label = DictSetting.CONTROL_FIRE_WEAPON;
         this.myKB[KB_AIM_DOWN_SIGHT].label = DictSetting.CONTROL_AIM_DOWN_SIGHT;
         this.myKB[KB_RELOAD].label = DictSetting.CONTROL_RELOAD;
         this.myKB[KB_SWITCH_WEAPON].label = DictSetting.CONTROL_SWITCH_WEAPON_1;
         this.myKB[KB_SWITCH_WEAPON_2].label = DictSetting.CONTROL_SWITCH_WEAPON_2;
         this.myKB[KB_MELEE].label = DictSetting.CONTROL_MELEE;
         this.myKB[KB_USE].label = DictSetting.CONTROL_USE;
         this.myKB[KB_THROW_LETHAL_GRENADE].label = DictSetting.CONTROL_THROW_LETHAL_GRENADE;
         this.myKB[KB_USE_EQUIPMENT].label = DictSetting.CONTROL_USE_EQUIPMENT;
         this.myKB[KB_WEAPON_ATTACHMENT].label = DictSetting.CONTROL_WEAPON_ATTACHMENT;
         this.myKB[KB_INVENTORY].label = DictSetting.CONTROL_KILL_STREAK_0;
         this.myKB[KB_SECOND_INVENTORY].label = DictSetting.CONTROL_KILL_STREAK_1;
         this.myKB[KB_USE_KILL_STREAK].label = DictSetting.CONTROL_KILL_STREAK_2;
         this.myKB[KB_SHOW_OBJECTIVE].label = DictSetting.CONTROL_KILL_STREAK_3;
         this.myKB[KB_SWAP_WEAPON].label = DictSetting.CONTROL_SHOW_OBJECTIVE;
         this.myKB[KB_SWITCH_SCOPE].label = DictSetting.CONTROL_SWITCH_SCOPE;
         this.myCBAimDownSight.setText(DictSetting.CONTROL_NEED_LONG_PRESS,null);
      }
      
      override protected function onInitListener() : void
      {
         super.onInitListener();
         for(var i:int = 0; i < CONTROL_BTN_NUM; i++)
         {
            this.addBtnListener(this.myKB[i]);
         }
         this.myCBAimDownSight.addCheckedCallback(this.onCBClickHandle,this.myCBAimDownSight);
         this.myCBAimDownSight.addUncheckedCallback(this.onCBClickHandle,this.myCBAimDownSight);
      }
      
      override protected function onResetControlsHandle(cEvt:ParaEvent) : void
      {
         super.onResetControlsHandle(cEvt);
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
      
      override protected function refreshCBState() : void
      {
         this.myCBAimDownSight.checked = this.getDP(DataID.KEY_BINDING_COUNT_ON_COMMAND,[CONTROL_CMD_2[0]]) > 0;
      }
      
      override protected function refreshAllCommands() : void
      {
         super.refreshAllCommands();
         for(var i:int = 0; i < CONTROL_BTN_NUM; i++)
         {
            if(i == 1 && this.myCBAimDownSight.checked)
            {
               this.myKB[i].value = this.getDP(DataID.KEY_BINDING_NAMES_ON_COMMAND,[CONTROL_CMD_2[0]]);
            }
         }
      }
      
      private function onCBClickHandle(userData:Object) : void
      {
         var cb:CheckBox = userData as CheckBox;
         switch(cb)
         {
            case this.myCBAimDownSight:
               this.setCBBind(cb.checked,CONTROL_CMD_2[0],CONTROL_CMD[1]);
         }
      }
      
      override protected function bindKeyToCmd(keyNum:uint, cmd:String, bMouse:Boolean = false) : void
      {
         if(this._currentBtnIndex == 1 && this.myCBAimDownSight.checked)
         {
            cmd = CONTROL_CMD_2[0];
         }
         super.bindKeyToCmd(keyNum,cmd,bMouse);
      }
   }
}

