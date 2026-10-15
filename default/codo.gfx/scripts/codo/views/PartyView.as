package codo.views
{
   import codo.base.BaseSubElement;
   import codo.base.BaseView;
   import codo.component.CloseButton;
   import codo.component.TextField;
   import codo.component.social.SocialSimpleContainer;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.localization.Dict;
   import codo.style.PartyGuide;
   import components.fsgSocialPanel_part.FsgPartyPanel;
   import components.fsgSocialPanel_part.FsgPartySettingPanel;
   
   public class PartyView extends BaseView
   {
      
      private static const WIDTH:int = 559;
      
      private static const HEIGHT:int = 660;
      
      public var myContentContainer:SocialSimpleContainer;
      
      public var myTitle:TextField;
      
      public var myCloseBtn:CloseButton;
      
      public var mySettingPanel:FsgPartySettingPanel;
      
      public var myInPartyPanel:FsgPartyPanel;
      
      private var mCurrentPanel:BaseSubElement = null;
      
      public function PartyView()
      {
         super();
         this.initStage();
      }
      
      private function initStage() : void
      {
         this.myContentContainer.width = WIDTH;
         this.myContentContainer.height = HEIGHT;
         this.myTitle.textStyle = PartyGuide.stylePartyHeader;
         this.myTitle.text = Dict.MAIN_MENU_LABEL_PARTY;
         this.myCloseBtn.registerClickEvent(this.onCloseButtonClicked);
         this.mySettingPanel.visible = this.myInPartyPanel.visible = false;
         x = 111;
         y = 230;
      }
      
      override protected function showView() : void
      {
         super.showView();
         if(this.mCurrentPanel == null)
         {
            this.onPartyStateChangeHandler();
         }
      }
      
      override protected function hideView() : void
      {
         super.hideView();
         if(Boolean(this.mCurrentPanel))
         {
            this.mCurrentPanel.deactive();
            this.mCurrentPanel = null;
         }
      }
      
      override protected function enableData() : void
      {
         super.enableData();
         listen(BCEvent.PARTY_STATE_CHANGED,this.onPartyStateChangeHandler);
      }
      
      override protected function disableData() : void
      {
         super.disableData();
         unlisten(BCEvent.PARTY_STATE_CHANGED,this.onPartyStateChangeHandler);
      }
      
      private function onCloseButtonClicked() : void
      {
         broadcast(BCEvent.EVT_CLOSE_PARTY);
      }
      
      private function onPartyStateChangeHandler() : void
      {
         if(this.mCurrentPanel != null)
         {
            this.mCurrentPanel.deactive();
         }
         if(getDP(DataID.IS_IN_PARTY) == true)
         {
            this.mCurrentPanel = this.myInPartyPanel;
         }
         else
         {
            this.mCurrentPanel = this.mySettingPanel;
         }
         this.mCurrentPanel.active();
      }
   }
}

