package codo.views.hud.popups.HudTdTurretUpgradeView_parts
{
   import codo.common.CFunctionCommonContainer;
   import codo.component.Button;
   import codo.localization.DictTD;
   import codo.utils.LocalizeUtil;
   import codo.views.hud.popups.HudTdTurretManageView_parts.HudTdTurretManageTurretInfo;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.ui.Keyboard;
   
   public class HudTdTurretUpgradeTargetPanel extends MovieClip
   {
      
      private const BUTTON_WIDTH:Number = 138;
      
      private const BUTTON_HEIGHT:Number = 43;
      
      private const DESC_FILE_HEIGHT:Number = 80;
      
      private const HOTKEYS:Array = [Keyboard.NUMBER_1,Keyboard.NUMBER_2];
      
      public var myDesc:TextField;
      
      public var myTurretInfo:HudTdTurretManageTurretInfo;
      
      public var myBtn:Button;
      
      public var myDisabledBtn:Button;
      
      public var myCosts:HudTdTurretMaterialsMount;
      
      private var mTargetIndex:int;
      
      private var mPlayerCash:int;
      
      public function HudTdTurretUpgradeTargetPanel()
      {
         super();
         this.myDisabledBtn.width = this.myBtn.width = this.BUTTON_WIDTH;
         this.myDisabledBtn.height = this.myBtn.height = this.BUTTON_HEIGHT;
         this.myDisabledBtn.label = DictTD.MATERIAL_LACK;
         this.myDisabledBtn.enabled = false;
         this.myBtn.registerClickEvent(this.onButtonClick);
         this.myCosts.showLackColor = true;
      }
      
      public function set targetIndex(value:int) : void
      {
         this.mTargetIndex = value;
         this.myBtn.label = LocalizeUtil.localize(DictTD.UPGRADE_BTN_LABEL) + "[" + (value + 1) + "]";
      }
      
      public function get bindingKey() : uint
      {
         return this.HOTKEYS[this.mTargetIndex];
      }
      
      public function set playerCash(value:int) : void
      {
         this.mPlayerCash = value;
         this.buttonEnabled = this.myCosts.refreshRequirements(this.playerCash);
      }
      
      public function get playerCash() : int
      {
         return this.mPlayerCash;
      }
      
      public function setData(turretInfo:Object) : void
      {
         this.myTurretInfo.setData(turretInfo);
         this.myDesc.text = turretInfo.upgradeDesc;
         this.myDesc.y = this.myTurretInfo.y + (this.DESC_FILE_HEIGHT - this.myDesc.textHeight) * 0.5;
         this.buttonEnabled = this.myCosts.setData(turretInfo.costCash,this.playerCash,turretInfo.costItems);
      }
      
      public function onButtonClick() : void
      {
         if(this.buttonEnabled)
         {
            CFunctionCommonContainer.ScriptMenuResponse("td_turret_upgrade","upgrade|" + this.mTargetIndex);
         }
      }
      
      private function get buttonEnabled() : Boolean
      {
         return this.myBtn.visible;
      }
      
      private function set buttonEnabled(enabled:Boolean) : void
      {
         this.myBtn.visible = enabled;
         this.myDisabledBtn.visible = !enabled;
      }
   }
}

