package codo.views.clan_sub.search_sub
{
   import codo.component.Button;
   import codo.component.social.InputBox;
   import codo.localization.DictClan;
   import codo.objects.InputBoxSettings;
   import codo.objects.PageListSettings;
   import codo.style.ClanGuide;
   import codo.style.GlobalGuide;
   import codo.utils.StringUtil;
   
   public class ClanNameSearchPanel2 extends ClanNameSearchPanel
   {
      
      public var mySearchInputBox:InputBox;
      
      public var mySearchClanBtn:Button;
      
      public function ClanNameSearchPanel2()
      {
         super();
      }
      
      override protected function initStage() : void
      {
         myHeader.myClanLevel.textStyle = ClanGuide.styleClanTableHeader;
         myHeader.myClanLevel.width = 100;
         myHeader.myClanLevel.text = DictClan.CLAN_LEVEL_LABEL;
         myHeader.myClanName.textStyle = ClanGuide.styleClanTableHeader;
         myHeader.myClanName.width = 100;
         myHeader.myClanName.text = DictClan.CLAN_NAME_LABEL;
         myHeader.myClanTags.textStyle = ClanGuide.styleClanTableHeader;
         myHeader.myClanTags.width = 100;
         myHeader.myClanTags.text = DictClan.CLAN_TAG_LABEL;
         myHeader.myLeaderName.textStyle = ClanGuide.styleClanTableHeader;
         myHeader.myLeaderName.width = 100;
         myHeader.myLeaderName.text = DictClan.CLAN_LEADER_LABEL;
         myHeader.myMemberCount.textStyle = ClanGuide.styleClanTableHeader;
         myHeader.myMemberCount.width = 100;
         myHeader.myMemberCount.text = DictClan.CLAN_MEMBER_SIZE_LABEL;
         myHeader.myCTP.textStyle = ClanGuide.styleClanTableHeader;
         myHeader.myCTP.width = 100;
         myHeader.myCTP.text = DictClan.CLAN_CTP_LABEL;
         myHeader.myRecruiteState.textStyle = ClanGuide.styleClanTableHeader;
         myHeader.myRecruiteState.width = 100;
         myHeader.myRecruiteState.text = DictClan.CLAN_RECRUIT_STATE_LABEL;
         myHeader.myLevelRestrict.textStyle = ClanGuide.styleClanTableHeader;
         myHeader.myLevelRestrict.width = 100;
         myHeader.myLevelRestrict.text = DictClan.CLAN_LEVEL_RESTRICT_LABEL;
         mPageListSetting = new PageListSettings();
         mPageListSetting.itemCountPerPage = 10;
         mPageListSetting.itemPadding = 0;
         mPageListSetting.renderLinkName = SEARCH_ITEM_RENDER;
         mPageListSetting.itemInteractiveHandler = searchItemInteractived;
         mPageListSetting.customPageSelectorHandler = onPageSelectorClicked;
         myPageList.settings = mPageListSetting;
         myPageList.switchShowJoinBtn(false);
         myNoDataHint.myText.text = "@SF_UI_START_NAME_SEARCH_HINT";
         var searchInputSetting:InputBoxSettings = new InputBoxSettings();
         searchInputSetting.width = 1012;
         searchInputSetting.height = 30;
         searchInputSetting.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         searchInputSetting.hintText = DictClan.CLAN_SEARCH_INPUT_HINT;
         searchInputSetting.highlightAsDefault = true;
         this.mySearchInputBox.settings = searchInputSetting;
         this.mySearchClanBtn.width = 134;
         this.mySearchClanBtn.height = 32;
         this.mySearchClanBtn.label = DictClan.SEARCH_CLAN;
         this.mySearchClanBtn.registerClickEvent(this.onSearchClanConfirm);
      }
      
      private function onSearchClanConfirm() : void
      {
         var keyword:String = StringUtil.trim(this.mySearchInputBox.text);
         if(keyword == "")
         {
            this.mySearchInputBox.warningUser();
            return;
         }
         startNewSearch(keyword);
      }
   }
}

