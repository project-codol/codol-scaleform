package codo.views.hud.popups
{
   import codo.common.CFunctionCommonContainer;
   import codo.constants.BCInGameEvent;
   import codo.constants.GameInfo;
   import codo.constants.HUDPopupComponentTypes;
   import codo.event.ParaEvent;
   import codo.localization.DictTD;
   import codo.utils.LocalizeUtil;
   import codo.views.hud.HUDPopupComponent;
   import codo.views.hud.popups.HudTdTurretUpgradeView_parts.HudTdTurretDestroyPanel;
   import codo.views.hud.popups.HudTdTurretUpgradeView_parts.HudTdTurretUpgradePanel;
   import flash.display.MovieClip;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   
   public class HudTdTurretUpgradeView extends HUDPopupComponent
   {
      
      private const UPGRADE_PANEL_WIDTH:Number = 706;
      
      private const UPGRADE_PANEL_HEIGHT:Number = 650;
      
      private const DETAIL_BG_MARGIN:Number = 16;
      
      public var myUpgradePanel:HudTdTurretUpgradePanel;
      
      public var myDestroyPanel:HudTdTurretDestroyPanel;
      
      public var myMaterialDetail:MovieClip;
      
      private var mActivePanel:MovieClip;
      
      public function HudTdTurretUpgradeView()
      {
         super();
         this.myDestroyPanel.myCancelBtn.registerClickEvent(this.inactivatedDestroyPanel);
         this.myUpgradePanel.myDestroyBtn.registerClickEvent(this.activatedDestroyPanel);
         this.myMaterialDetail.mouseEnabled = this.myMaterialDetail.mouseChildren = false;
      }
      
      override public function get CompType() : int
      {
         return HUDPopupComponentTypes.TD_TURRET_UPGRADE;
      }
      
      override protected function showView() : void
      {
         super.showView();
         this.myMaterialDetail.visible = false;
         this.myUpgradePanel.x = GameInfo.stagePosition.x + (GameInfo.stageSize.x - this.UPGRADE_PANEL_WIDTH) * 0.5;
         this.myUpgradePanel.y = GameInfo.stagePosition.y + (GameInfo.stageSize.y - this.UPGRADE_PANEL_HEIGHT) * 0.5;
         this.myUpgradePanel.myCloseBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.onCloseBtnClicked);
         this.myDestroyPanel.x = GameInfo.stagePosition.x + (GameInfo.stageSize.x - this.myDestroyPanel.width) * 0.5;
         this.myDestroyPanel.y = GameInfo.stagePosition.y + (GameInfo.stageSize.y - this.myDestroyPanel.height) * 0.5;
         this.setPanelActive(this.myUpgradePanel);
         listen(BCInGameEvent.EVT_TD_SHOW_UPGARDE_MATERIAL_DETAIL,this.onShowMaterialDetail);
         listen(BCInGameEvent.EVT_TD_HIDE_UPGARDE_MATERIAL_DETAIL,this.onHideMaterialDetail);
      }
      
      override protected function hideView() : void
      {
         super.hideView();
         this.myUpgradePanel.myCloseBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.onCloseBtnClicked);
         unlisten(BCInGameEvent.EVT_TD_SHOW_UPGARDE_MATERIAL_DETAIL,this.onShowMaterialDetail);
         unlisten(BCInGameEvent.EVT_TD_HIDE_UPGARDE_MATERIAL_DETAIL,this.onHideMaterialDetail);
      }
      
      override public function onKeyboardEvent(cEvt:KeyboardEvent) : void
      {
         if(this.mActivePanel == this.myUpgradePanel)
         {
            if(cEvt.keyCode == Keyboard.ESCAPE)
            {
               this.closeView();
            }
            else
            {
               this.myUpgradePanel.onKeyboardEvent(cEvt);
            }
         }
         else if(cEvt.keyCode == Keyboard.ESCAPE)
         {
            this.inactivatedDestroyPanel();
         }
      }
      
      private function onCloseBtnClicked(cEvt:MouseEvent) : void
      {
         this.closeView();
      }
      
      private function setPanelActive(panel:MovieClip) : void
      {
         this.mActivePanel = panel;
         if(this.mActivePanel == this.myUpgradePanel)
         {
            this.myUpgradePanel.visible = true;
            this.myDestroyPanel.visible = false;
         }
         else
         {
            this.myUpgradePanel.visible = false;
            this.myDestroyPanel.visible = true;
         }
      }
      
      private function inactivatedDestroyPanel() : void
      {
         this.setPanelActive(this.myUpgradePanel);
      }
      
      private function activatedDestroyPanel() : void
      {
         this.setPanelActive(this.myDestroyPanel);
      }
      
      public function closeView() : void
      {
         CFunctionCommonContainer.ScriptMenuResponse("td_turret_upgrade","quit");
      }
      
      public function setPlayerCash(cash:int) : void
      {
         this.myUpgradePanel.setPlayerCash(cash);
      }
      
      public function setFocusTurret(turretInfo:Object) : void
      {
         this.myUpgradePanel.setFocusTurret(turretInfo);
         this.myDestroyPanel.setData(turretInfo);
      }
      
      public function setUpgradeTargetTurrets(turretInfo:Array) : void
      {
         this.myUpgradePanel.setUpgradeTargets(turretInfo);
      }
      
      public function onShowMaterialDetail(evt:ParaEvent) : void
      {
         var lootItemData:Object = null;
         if(evt.myPara != null)
         {
            lootItemData = evt.myPara;
            this.myMaterialDetail.myItemName.text = lootItemData.name;
            this.myMaterialDetail.myItemOwned.text = LocalizeUtil.localize(DictTD.CURRENTLY_OWNED) + ":" + lootItemData.ownedNum;
            this.myMaterialDetail.myItemDesc.text = lootItemData.desc;
            this.myMaterialDetail.myBg.height = this.myMaterialDetail.myItemDesc.y + this.myMaterialDetail.myItemDesc.textHeight + this.DETAIL_BG_MARGIN;
         }
         this.myMaterialDetail.visible = true;
         this.myMaterialDetail.x = stage.mouseX;
         this.myMaterialDetail.y = stage.mouseY;
      }
      
      public function onHideMaterialDetail(evt:ParaEvent) : void
      {
         this.myMaterialDetail.visible = false;
      }
   }
}

