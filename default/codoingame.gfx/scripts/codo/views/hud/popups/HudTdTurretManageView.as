package codo.views.hud.popups
{
   import codo.common.CFunctionCommonContainer;
   import codo.component.CloseButton;
   import codo.constants.GameInfo;
   import codo.constants.HUDPopupComponentTypes;
   import codo.views.hud.HUDPopupComponent;
   import codo.views.hud.popups.HudTdTurretManageView_parts.HudTdTurretManagePanel;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   
   public class HudTdTurretManageView extends HUDPopupComponent
   {
      
      public var myCloseBtn:CloseButton;
      
      public var myPanel:HudTdTurretManagePanel;
      
      public function HudTdTurretManageView()
      {
         super();
      }
      
      override public function get CompType() : int
      {
         return HUDPopupComponentTypes.TD_TURRET_MANAGE;
      }
      
      override protected function showView() : void
      {
         super.showView();
         this.myPanel.x = GameInfo.stagePosition.x + (GameInfo.stageSize.x - this.myPanel.width) * 0.52;
         this.myPanel.y = GameInfo.stagePosition.y + (GameInfo.stageSize.y - this.myPanel.height) * 0.5;
         this.myCloseBtn.x = this.myPanel.x + this.myPanel.width - this.myCloseBtn.width / 2;
         this.myCloseBtn.y = this.myPanel.y - this.myCloseBtn.height / 2;
         this.myCloseBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.onCloseBtnClicked);
      }
      
      override protected function hideView() : void
      {
         super.hideView();
         this.myCloseBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.onCloseBtnClicked);
      }
      
      private function onCloseBtnClicked(cEvt:MouseEvent) : void
      {
         CFunctionCommonContainer.ScriptMenuResponse("td_turret_manage","quit");
      }
      
      override public function onKeyboardEvent(cEvt:KeyboardEvent) : void
      {
         if(cEvt.keyCode == Keyboard.ESCAPE)
         {
            CFunctionCommonContainer.ScriptMenuResponse("td_turret_manage","quit");
         }
      }
   }
}

