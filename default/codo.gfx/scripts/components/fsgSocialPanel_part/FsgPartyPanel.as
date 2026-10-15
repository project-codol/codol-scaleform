package components.fsgSocialPanel_part
{
   import codo.base.BaseSubElement;
   import codo.component.social.SocialMainTab;
   import codo.component.social.SocialTabButton;
   import codo.localization.DictInvitation;
   import codo.localization.DictParty;
   import codo.objects.SocialTabSetting;
   
   public class FsgPartyPanel extends BaseSubElement
   {
      
      public var myMainTab:SocialMainTab;
      
      public var myPartyStatusPanel:FsgPartyStatusPanel;
      
      public var myPartyInvitePanel:FsgPartyInvitePanel;
      
      private var m_currentSelectedIndex:int = -1;
      
      private var mPanels:Array;
      
      public function FsgPartyPanel()
      {
         super();
         var mainTabSetting:SocialTabSetting = new SocialTabSetting();
         mainTabSetting.needBg = false;
         mainTabSetting.tabSelectedCallback = this.onTabSelectedCallback;
         mainTabSetting.labels = [DictParty.PARTY_MEMBER,DictInvitation.INVITE_PARTY];
         mainTabSetting.padding = 10;
         this.myMainTab.setTabType(SocialTabButton.TYPE_SMALL);
         this.myMainTab.setData(mainTabSetting);
         this.mPanels = [this.myPartyStatusPanel,this.myPartyInvitePanel];
         this.myPartyStatusPanel.visible = this.myPartyInvitePanel.visible = false;
      }
      
      override public function active() : void
      {
         super.active();
         this.myMainTab.selectTab(0);
      }
      
      public function onTabSelectedCallback(index:int) : void
      {
         if(this.m_currentSelectedIndex == index)
         {
            return;
         }
         if(this.m_currentSelectedIndex != -1)
         {
            this.mPanels[this.m_currentSelectedIndex].deactive();
         }
         this.m_currentSelectedIndex = index;
         this.mPanels[this.m_currentSelectedIndex].active();
      }
   }
}

