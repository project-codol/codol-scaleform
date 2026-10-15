package codo.views.hud.popups.HudTdTurretUpgradeView_parts
{
   import codo.common.CFunctionCommonContainer;
   import codo.component.Button;
   import codo.localization.DictInGame;
   import codo.localization.DictTD;
   import codo.views.hud.popups.HudTdTurretManageView_parts.HudTdTurretManageTurretInfo;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class HudTdTurretDestroyPanel extends MovieClip
   {
      
      private const BUTTON_WIDTH:Number = 138;
      
      private const BUTTON_HEIGHT:Number = 43;
      
      private const GAIN_ELEMENTS_GAP:Number = 8;
      
      public var myConfirmText:TextField;
      
      public var myGainText:TextField;
      
      public var myCancelBtn:Button;
      
      public var myConfirmBtn:Button;
      
      public var myTurretInfo:HudTdTurretManageTurretInfo;
      
      public var myGain:HudTdTurretMaterialsMount;
      
      public function HudTdTurretDestroyPanel()
      {
         super();
         this.myConfirmText.text = DictTD.WHETHER_TO_DESTROY;
         this.myGainText.text = DictTD.WILL_GAIN;
         this.myCancelBtn.width = this.BUTTON_WIDTH;
         this.myCancelBtn.height = this.BUTTON_HEIGHT;
         this.myCancelBtn.label = DictInGame.Cancel;
         this.myConfirmBtn.registerClickEvent(this.OnConfirmBtnClick);
         this.myConfirmBtn.width = this.BUTTON_WIDTH;
         this.myConfirmBtn.height = this.BUTTON_HEIGHT;
         this.myConfirmBtn.label = DictTD.TURRET_DESTROY_CONFIRM;
         this.myGain.elementGap = this.GAIN_ELEMENTS_GAP;
         this.myGain.showLackColor = false;
      }
      
      private function OnConfirmBtnClick() : void
      {
         CFunctionCommonContainer.ScriptMenuResponse("td_turret_upgrade","destroy");
      }
      
      public function setData(turretInfo:Object) : void
      {
         this.myTurretInfo.setData(turretInfo);
         this.myGain.setData(turretInfo.dropCash,0,turretInfo.dropItems);
      }
   }
}

