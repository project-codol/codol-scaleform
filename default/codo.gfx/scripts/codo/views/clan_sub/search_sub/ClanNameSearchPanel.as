package codo.views.clan_sub.search_sub
{
   import codo.base.BaseSubElement;
   import codo.component.social.ClanSearchPageList;
   import codo.component.social.ClanSearchResultItem;
   import codo.component.social.PageListSelector;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.event.ParaEvent;
   import codo.localization.DictClan;
   import codo.objects.ClanSearchRequestObj;
   import codo.objects.PageListSettings;
   import codo.style.ClanGuide;
   import flash.display.MovieClip;
   
   public class ClanNameSearchPanel extends BaseSubElement
   {
      
      protected static const SEARCH_ITEM_RENDER:String = "codo.social.clanSearchResultItem";
      
      private static const MAX_SEARCH_TIME_THRESHOLD:int = 2000;
      
      private static const MAX_SEARCH_THRESOLD:int = 3;
      
      public var myPageList:ClanSearchPageList;
      
      public var myNoDataHint:MovieClip;
      
      public var myHeader:MovieClip;
      
      protected var mPageListSetting:PageListSettings;
      
      private var mData:Object;
      
      private var mKeyword:String;
      
      private var mOffset:int;
      
      private var mTailedObj:Object;
      
      private var mSearching:Boolean = false;
      
      private var mSearchCount:int = 0;
      
      private var mSearchTimeStamp:int = 0;
      
      public function ClanNameSearchPanel()
      {
         super();
         this.initStage();
      }
      
      protected function initStage() : void
      {
         this.myHeader.myClanLevel.textStyle = ClanGuide.styleClanTableHeader;
         this.myHeader.myClanLevel.width = 100;
         this.myHeader.myClanLevel.text = DictClan.CLAN_LEVEL_LABEL;
         this.myHeader.myClanName.textStyle = ClanGuide.styleClanTableHeader;
         this.myHeader.myClanName.width = 100;
         this.myHeader.myClanName.text = DictClan.CLAN_NAME_LABEL;
         this.myHeader.myClanTags.textStyle = ClanGuide.styleClanTableHeader;
         this.myHeader.myClanTags.width = 100;
         this.myHeader.myClanTags.text = DictClan.CLAN_TAG_LABEL;
         this.myHeader.myLeaderName.textStyle = ClanGuide.styleClanTableHeader;
         this.myHeader.myLeaderName.width = 100;
         this.myHeader.myLeaderName.text = DictClan.CLAN_LEADER_LABEL;
         this.myHeader.myMemberCount.textStyle = ClanGuide.styleClanTableHeader;
         this.myHeader.myMemberCount.width = 100;
         this.myHeader.myMemberCount.text = DictClan.CLAN_MEMBER_SIZE_LABEL;
         this.myHeader.myCTP.textStyle = ClanGuide.styleClanTableHeader;
         this.myHeader.myCTP.width = 100;
         this.myHeader.myCTP.text = DictClan.CLAN_CTP_LABEL;
         this.myHeader.myRecruiteState.textStyle = ClanGuide.styleClanTableHeader;
         this.myHeader.myRecruiteState.width = 100;
         this.myHeader.myRecruiteState.text = DictClan.CLAN_RECRUIT_STATE_LABEL;
         this.myHeader.myLevelRestrict.textStyle = ClanGuide.styleClanTableHeader;
         this.myHeader.myLevelRestrict.width = 100;
         this.myHeader.myLevelRestrict.text = DictClan.CLAN_LEVEL_RESTRICT_LABEL;
         this.mPageListSetting = new PageListSettings();
         this.mPageListSetting.itemCountPerPage = 11;
         this.mPageListSetting.itemPadding = 0;
         this.mPageListSetting.renderLinkName = SEARCH_ITEM_RENDER;
         this.mPageListSetting.itemClickHandler = this.searchItemClicked;
         this.mPageListSetting.itemInteractiveHandler = this.searchItemInteractived;
         this.myPageList.settings = this.mPageListSetting;
         this.mPageListSetting.extraHandler = this.isClanApplicationEverSent;
         this.mPageListSetting.customPageSelectorHandler = this.onPageSelectorClicked;
         this.myNoDataHint.myText.text = "@SF_UI_START_NAME_SEARCH_HINT";
      }
      
      override public function active() : void
      {
         super.active();
         bind(DataID.SEARCH_CLAN_LIST,this.onBindSearchClanList);
         listen(BCEvent.PENDING_CLAN_APPLICATION_CHANGED,this.onPendingClanApplicationChanged);
      }
      
      override public function deactive() : void
      {
         unbind(DataID.SEARCH_CLAN_LIST,this.onBindSearchClanList);
         unlisten(BCEvent.PENDING_CLAN_APPLICATION_CHANGED,this.onPendingClanApplicationChanged);
         super.deactive();
      }
      
      public function startNewSearch(keyword:String) : void
      {
         if(!this.frequencyCheck())
         {
            return;
         }
         this.mKeyword = keyword;
         this.mOffset = 0;
         this.mTailedObj = null;
         var request:ClanSearchRequestObj = new ClanSearchRequestObj();
         request.type = ClanSearchRequestObj.CLAN_SEARCH_TYPE_BY_NAME;
         request.offset = 0;
         request.count = this.mPageListSetting.itemCountPerPage;
         request.keyword = this.mKeyword;
         request.isNewSearch = true;
         this.mSearching = true;
         this.myNoDataHint.myText.text = DictClan.SEARCHING_NAME_CLAN;
         broadcast(BCEvent.GET_SEARCH_CLAN,request);
      }
      
      private function frequencyCheck() : Boolean
      {
         var date:Date = null;
         var currentTimeStamp:int = 0;
         date = new Date();
         if(this.mSearchCount == 0)
         {
            this.mSearchTimeStamp = date.time;
            ++this.mSearchCount;
         }
         else
         {
            ++this.mSearchCount;
            currentTimeStamp = date.time;
            if(currentTimeStamp - this.mSearchTimeStamp > MAX_SEARCH_TIME_THRESHOLD)
            {
               this.mSearchCount = 1;
               this.mSearchTimeStamp = currentTimeStamp;
            }
            else if(this.mSearchCount >= MAX_SEARCH_THRESOLD)
            {
               this.showMsg(DictClan.SEARCH_CLAN_TOO_FREQUENT,1);
               this.mSearchCount = 0;
               return false;
            }
         }
         return true;
      }
      
      private function onBindSearchClanList(cRes:Object) : void
      {
         if(cRes.data == null)
         {
            this.myPageList.dataProvider = [];
            this.myPageList.hasPrevBtn = false;
            this.myPageList.hasNextBtn = false;
            this.mOffset = 0;
            this.mTailedObj = null;
            this.myNoDataHint.visible = true;
            this.myNoDataHint.myText.text = "@SF_UI_START_NAME_SEARCH_HINT";
            return;
         }
         this.mSearching = false;
         this.mData = cRes.data;
         var data:Array = this.mData.dp as Array;
         if(Boolean(this.mTailedObj))
         {
            data.unshift(this.mTailedObj);
         }
         this.myPageList.dataProvider = data;
         this.myNoDataHint.visible = data.length <= 0;
         this.myNoDataHint.myText.text = DictClan.NO_NAME_CLAN;
         this.myPageList.hasPrevBtn = cRes.data.hasPrev;
         this.myPageList.hasNextBtn = cRes.data.hasNext;
         this.mOffset = cRes.data.requestOffset;
         if(data.length > this.mPageListSetting.itemCountPerPage)
         {
            this.mTailedObj = data[this.mPageListSetting.itemCountPerPage];
         }
      }
      
      private function onPendingClanApplicationChanged(e:ParaEvent) : void
      {
         this.myPageList.refreshAllRenderJoinBtnState();
      }
      
      private function isClanApplicationEverSent(id:String) : Boolean
      {
         return getDP(DataID.APPLICATION_PENDING,[id]);
      }
      
      private function searchItemClicked(data:Object, whichButtonClicked:int) : void
      {
         broadcast(BCEvent.EVT_APPLY_FOR_CLAN,data);
      }
      
      protected function searchItemInteractived(data:Object, whichBehaviour:int) : void
      {
         if(whichBehaviour == ClanSearchResultItem.ROLL_OVER_INDEX)
         {
            broadcast(BCEvent.SHOW_DETAIL_CLAN_INFO,data);
         }
         else
         {
            broadcast(BCEvent.HIDE_DETAIL_CLAN_INFO,data);
         }
      }
      
      protected function onPageSelectorClicked(whichBtn:int) : void
      {
         if(this.mSearching)
         {
            return;
         }
         var request:ClanSearchRequestObj = new ClanSearchRequestObj();
         request.type = ClanSearchRequestObj.CLAN_SEARCH_TYPE_BY_NAME;
         request.count = this.mPageListSetting.itemCountPerPage;
         request.keyword = this.mKeyword;
         request.isNewSearch = false;
         if(whichBtn == PageListSelector.NEXT_BTN_INDEX)
         {
            request.offset = this.mOffset + this.mPageListSetting.itemCountPerPage;
         }
         else
         {
            request.offset = this.mOffset - this.mPageListSetting.itemCountPerPage;
         }
         this.mSearching = true;
         broadcast(BCEvent.GET_SEARCH_CLAN,request);
      }
   }
}

