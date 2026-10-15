package codo.views.hud.popups.HudTdTurretUpgradeView_parts
{
   import codo.common.CFunctionCommonContainer;
   import codo.component.Button;
   import codo.component.CloseButton;
   import codo.localization.DictTD;
   import codo.utils.LocalizeUtil;
   import codo.views.hud.popups.HudTdTurretManageView_parts.HudTdTurretManageTurretInfo;
   import flash.display.MovieClip;
   import flash.events.KeyboardEvent;
   import flash.text.TextField;
   
   public class HudTdTurretUpgradePanel extends MovieClip
   {
      
      private const DEFAULT_FRAME:int = 1;
      
      private const ONE_UPGRADE_FRAME:int = 2;
      
      private const NO_UPGRADE_FRAME:int = 3;
      
      private const MOVE_BTN_WIDTH:Number = 138;
      
      private const MOVE_BTN_HEIGHT:Number = 43;
      
      private const DESTROY_BTN_WIDTH:Number = 112;
      
      private const DESTROY_BTN_HEIGHT:Number = 35;
      
      private const BASE_DESC_FILE_HEIGHT:Number = 80;
      
      private const MOVE_KEY_COMMAND:String = "+activate";
      
      public var myMoveBtn:Button;
      
      public var myDestroyBtn:Button;
      
      public var myMaxLvlHint:TextField;
      
      public var myCloseBtn:CloseButton;
      
      public var myUpgradeTarget0:HudTdTurretUpgradeTargetPanel;
      
      public var myUpgradeTarget1:HudTdTurretUpgradeTargetPanel;
      
      public var myBaseTurretDesc:TextField;
      
      public var myBaseTurretInfo:HudTdTurretManageTurretInfo;
      
      public function HudTdTurretUpgradePanel()
      {
         super();
         this.myMoveBtn.width = this.MOVE_BTN_WIDTH;
         this.myMoveBtn.height = this.MOVE_BTN_HEIGHT;
         this.myMoveBtn.label = LocalizeUtil.localize(DictTD.TURRET_MOVE) + "[" + LocalizeUtil.localizeFirstKeyBindingForCommand(this.MOVE_KEY_COMMAND) + "]";
         this.myMoveBtn.registerClickEvent(this.onMoveBtnClick);
         this.myDestroyBtn.width = this.DESTROY_BTN_WIDTH;
         this.myDestroyBtn.height = this.DESTROY_BTN_HEIGHT;
         this.myDestroyBtn.label = DictTD.DESTROY;
         this.myMaxLvlHint.text = DictTD.TURRET_MAX_LVL_HINT;
         this.myUpgradeTarget0.targetIndex = 0;
         this.myUpgradeTarget1.targetIndex = 1;
      }
      
      public function setFocusTurret(turretInfo:Object) : void
      {
         this.myBaseTurretInfo.setData(turretInfo);
         this.myBaseTurretDesc.text = turretInfo.desc;
         this.myBaseTurretDesc.y = this.myBaseTurretInfo.y + (this.BASE_DESC_FILE_HEIGHT - this.myBaseTurretDesc.textHeight) * 0.5;
      }
      
      public function setUpgradeTargets(turrets:Array) : void
      {
         this.myUpgradeTarget0.visible = this.myUpgradeTarget1.visible = false;
         if(turrets == null || turrets.length == 0)
         {
            gotoAndStop(this.NO_UPGRADE_FRAME);
            this.myUpgradeTarget0.visible = this.myUpgradeTarget1.visible = false;
            this.myMaxLvlHint.visible = true;
         }
         else
         {
            gotoAndStop(turrets.length == 2 ? this.DEFAULT_FRAME : this.ONE_UPGRADE_FRAME);
            this.myMaxLvlHint.visible = false;
            if(turrets.length > 0)
            {
               this.myUpgradeTarget0.visible = true;
               this.myUpgradeTarget0.setData(turrets[0]);
            }
            if(turrets.length > 1)
            {
               this.myUpgradeTarget1.visible = true;
               this.myUpgradeTarget1.setData(turrets[1]);
            }
         }
      }
      
      public function onKeyboardEvent(cEvt:KeyboardEvent) : void
      {
         if(CFunctionCommonContainer.GetKeyBindingValuesFromCommand(this.MOVE_KEY_COMMAND).indexOf(cEvt.charCode) != -1)
         {
            this.onMoveBtnClick();
         }
         else if(this.myUpgradeTarget0.visible && this.myUpgradeTarget0.bindingKey == cEvt.keyCode)
         {
            this.myUpgradeTarget0.onButtonClick();
         }
         else if(this.myUpgradeTarget1.visible && this.myUpgradeTarget1.bindingKey == cEvt.keyCode)
         {
            this.myUpgradeTarget1.onButtonClick();
         }
      }
      
      public function setPlayerCash(cash:int) : void
      {
         this.myUpgradeTarget0.playerCash = this.myUpgradeTarget1.playerCash = cash;
      }
      
      private function onMoveBtnClick() : void
      {
         CFunctionCommonContainer.ScriptMenuResponse("td_turret_upgrade","move");
      }
   }
}

