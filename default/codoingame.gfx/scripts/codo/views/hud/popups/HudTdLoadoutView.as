package codo.views.hud.popups
{
   import codo.common.CFunctionInGameContainer;
   import codo.component.CloseButton;
   import codo.constants.GameInfo;
   import codo.constants.HUDPopupComponentTypes;
   import codo.localization.DictTD;
   import codo.views.hud.HUDPopupComponent;
   import codo.views.hud.popups.hudTdLoadoutView_parts.HudTdLoadoutPanel;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.ui.Keyboard;
   
   public class HudTdLoadoutView extends HUDPopupComponent
   {
      
      public var myTitle:TextField;
      
      public var myCloseBtn:CloseButton;
      
      public var myPanel:HudTdLoadoutPanel;
      
      public function HudTdLoadoutView()
      {
         super();
         this.myTitle.text = DictTD.PACKAGE;
      }
      
      override public function get CompType() : int
      {
         return HUDPopupComponentTypes.TD_LOADOUT;
      }
      
      override protected function showView() : void
      {
         super.showView();
         this.myPanel.x = GameInfo.stagePosition.x + (GameInfo.stageSize.x - this.myPanel.myBackground.width) / 2;
         this.myPanel.y = GameInfo.stagePosition.y + (GameInfo.stageSize.y - this.myPanel.myBackground.height) / 2;
         this.myPanel.show();
         this.myTitle.x = this.myPanel.x;
         this.myTitle.y = this.myPanel.y - this.myTitle.textHeight - 5;
         this.myCloseBtn.x = this.myPanel.x + this.myPanel.myBackground.width - this.myCloseBtn.width / 2;
         this.myCloseBtn.y = this.myPanel.y - this.myCloseBtn.height / 2;
         this.myCloseBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.onCloseBtnClicked);
      }
      
      override protected function hideView() : void
      {
         super.hideView();
         this.myPanel.hide();
         this.myCloseBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.onCloseBtnClicked);
      }
      
      override public function onKeyboardEvent(cEvt:KeyboardEvent) : void
      {
         if(cEvt.keyCode == Keyboard.ESCAPE || cEvt.keyCode == Keyboard.B)
         {
            CFunctionInGameContainer.AS_ToggleLoadoutMenu();
         }
      }
      
      private function onCloseBtnClicked(cEvt:MouseEvent) : void
      {
         CFunctionInGameContainer.AS_ToggleLoadoutMenu();
      }
   }
}

