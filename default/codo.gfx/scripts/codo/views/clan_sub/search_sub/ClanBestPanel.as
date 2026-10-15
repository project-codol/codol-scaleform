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
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class ClanBestPanel extends BaseSubElement
   {
      
      private static const BEST_ITEM_RENDER:String = "codo.social.clanSearchResultItemWithRank";
      
      private static const BEST_CLAN_COOL_DOWN:int = 600000;
      
      public var myPageList:ClanSearchPageList;
      
      public var myNoDataHint:MovieClip;
      
      public var myHeader:MovieClip;
      
      private var mPageListSetting:PageListSettings;
      
      private var mData:Object;
      
      private var mOffset:int;
      
      private var mSearching:Boolean = false;
      
      private var mEnableJoinButton:Boolean = true;
      
      private var mBestClanDataCoolDownComplete:Boolean = true;
      
      public function ClanBestPanel()
      {
         super();
         this.initStage();
      }
      
      private function initStage() : void
      {
         this.myHeader.myClanLevel.textStyle = ClanGuide.styleClanTableHeader;
         this.myHeader.myClanLevel.width = 100;
         this.myHeader.myClanLevel.text = DictClan.CLAN_LEVEL_LABEL;
         this.myHeader.myClanRank.textStyle = ClanGuide.styleClanTableHeader;
         this.myHeader.myClanRank.width = 100;
         this.myHeader.myClanRank.text = DictClan.CLAN_RANK_LABEL;
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
         this.mPageListSetting.renderLinkName = BEST_ITEM_RENDER;
         this.mPageListSetting.itemClickHandler = this.searchItemClicked;
         this.mPageListSetting.itemInteractiveHandler = this.searchItemInteractived;
         this.mPageListSetting.extraHandler = this.isClanApplicationEverSent;
         this.mPageListSetting.customPageSelectorHandler = this.onPageSelectorClicked;
         this.myPageList.settings = this.mPageListSetting;
      }
      
      override public function active() : void
      {
         super.active();
         bind(DataID.BEST_CLAN_LIST,this.onBindBestClanList);
         listen(BCEvent.PENDING_CLAN_APPLICATION_CHANGED,this.onPendingClanApplicationChanged);
      }
      
      override public function deactive() : void
      {
         unbind(DataID.BEST_CLAN_LIST,this.onBindBestClanList);
         unlisten(BCEvent.PENDING_CLAN_APPLICATION_CHANGED,this.onPendingClanApplicationChanged);
         super.deactive();
      }
      
      public function switchShowJoinBtn(enable:Boolean) : void
      {
         this.mEnableJoinButton = enable;
         this.myPageList.switchShowJoinBtn(this.mEnableJoinButton);
      }
      
      public function startNewSearch() : void
      {
         var request:ClanSearchRequestObj;
         var timeoutHandler:uint = 0;
         var onNewSearchSessionCoolDownComplete:Function = null;
         onNewSearchSessionCoolDownComplete = function():void
         {
            clearTimeout(timeoutHandler);
            mBestClanDataCoolDownComplete = true;
         };
         if(!this.mBestClanDataCoolDownComplete)
         {
            return;
         }
         request = new ClanSearchRequestObj();
         request.type = Boolean(getDP(DataID.BEST_CLAN_DATA_FROM_TENCENT)) ? ClanSearchRequestObj.CLAN_SEARCH_TYPE_TENCENT_BEST : ClanSearchRequestObj.CLAN_SEARCH_TYPE_BEST;
         request.offset = 0;
         request.count = this.mPageListSetting.itemCountPerPage;
         request.isNewSearch = true;
         request.keyword = "";
         broadcast(BCEvent.GET_SEARCH_CLAN,request);
         this.myNoDataHint.myText.text = DictClan.SEARCHING_BEST_CLAN;
         this.mBestClanDataCoolDownComplete = false;
         timeoutHandler = setTimeout(onNewSearchSessionCoolDownComplete,BEST_CLAN_COOL_DOWN);
      }
      
      private function onBindBestClanList(cRes:Object) : void
      {
         this.mSearching = false;
         this.mData = cRes.data;
         var data:Array = this.mData.dp as Array;
         this.myPageList.dataProvider = data;
         this.myNoDataHint.visible = data.length <= 0;
         this.myNoDataHint.myText.text = DictClan.NO_BEST_CLAN;
         this.myPageList.hasPrevBtn = cRes.data.hasPrev;
         this.myPageList.hasNextBtn = cRes.data.hasNext;
         this.mOffset = cRes.data.requestOffset;
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
      
      private function searchItemInteractived(data:Object, whichBehaviour:int) : void
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
      
      private function onPageSelectorClicked(whichBtn:int) : void
      {
         if(this.mSearching)
         {
            return;
         }
         var request:ClanSearchRequestObj = new ClanSearchRequestObj();
         request.type = Boolean(getDP(DataID.BEST_CLAN_DATA_FROM_TENCENT)) ? ClanSearchRequestObj.CLAN_SEARCH_TYPE_TENCENT_BEST : ClanSearchRequestObj.CLAN_SEARCH_TYPE_BEST;
         request.count = this.mPageListSetting.itemCountPerPage;
         request.keyword = "";
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

