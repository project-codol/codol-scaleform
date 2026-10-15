package codo.views.clan_sub.search_sub
{
   import codo.base.BaseSubElement;
   import codo.component.CheckBox;
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
   import codo.utils.Logger;
   import flash.display.MovieClip;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class ClanNewPanel extends BaseSubElement
   {
      
      private static const SEARCH_ITEM_RENDER:String = "codo.social.clanSearchResultItem";
      
      private static const NEW_CLAN_COOL_DOWN:int = 600000;
      
      public var myPageList:ClanSearchPageList;
      
      public var myNoDataHint:MovieClip;
      
      public var myHeader:MovieClip;
      
      public var myJoinable:CheckBox;
      
      private var mPageListSetting:PageListSettings;
      
      private var mData:Object;
      
      private var mJoinableData:Object;
      
      private var mOffset:int;
      
      private var mJoinableOffset:int;
      
      private var mSearching:Boolean = false;
      
      private var mEnableJoinButton:Boolean = true;
      
      private var mViewingType:int;
      
      private var mNewClanDataCoolDownComplete:Boolean = true;
      
      private var mNewClanDataJoinableCoolDownComplete:Boolean = true;
      
      public function ClanNewPanel()
      {
         super();
         this.initStage();
      }
      
      private function initStage() : void
      {
         this.mViewingType = ClanSearchRequestObj.CLAN_SEARCH_TYPE_NEW;
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
         this.myJoinable.label = DictClan.SHOW_JOINABLE_ClAN_ONLY;
         this.myJoinable.addCheckedCallback(this.onCheckedStateChanged,true);
         this.myJoinable.addUncheckedCallback(this.onCheckedStateChanged,false);
         this.myNoDataHint.myText.text = DictClan.NO_NEW_CLAN;
         this.mPageListSetting = new PageListSettings();
         this.mPageListSetting.itemCountPerPage = 11;
         this.mPageListSetting.itemPadding = 0;
         this.mPageListSetting.renderLinkName = SEARCH_ITEM_RENDER;
         this.mPageListSetting.itemClickHandler = this.searchItemClicked;
         this.mPageListSetting.itemInteractiveHandler = this.searchItemInteractived;
         this.mPageListSetting.customPageSelectorHandler = this.onPageSelectorClicked;
         this.myPageList.settings = this.mPageListSetting;
         this.mPageListSetting.extraHandler = this.isClanApplicationEverSent;
      }
      
      override public function active() : void
      {
         super.active();
         bind(DataID.NEW_CLAN_LIST,this.onBindSearchClanList);
         bind(DataID.NEW_JOINABLE_CLAN_LIST,this.onBindJoinableClanList);
         listen(BCEvent.PENDING_CLAN_APPLICATION_CHANGED,this.onPendingClanApplicationChanged);
      }
      
      override public function deactive() : void
      {
         unbind(DataID.NEW_CLAN_LIST,this.onBindSearchClanList);
         unbind(DataID.NEW_JOINABLE_CLAN_LIST,this.onBindJoinableClanList);
         unlisten(BCEvent.PENDING_CLAN_APPLICATION_CHANGED,this.onPendingClanApplicationChanged);
         super.deactive();
      }
      
      public function switchShowJoinBtn(enable:Boolean) : void
      {
         this.myJoinable.visible = enable;
         this.mEnableJoinButton = enable;
         this.myPageList.switchShowJoinBtn(this.mEnableJoinButton);
      }
      
      public function startNewSearch() : void
      {
         if(this.mNewClanDataCoolDownComplete)
         {
            this.mData = null;
         }
         if(this.mNewClanDataJoinableCoolDownComplete)
         {
            this.mJoinableData = null;
         }
         this.realSearch();
      }
      
      public function realSearch() : void
      {
         var request:ClanSearchRequestObj;
         var joinable:Boolean = false;
         var timeoutHandler:uint = 0;
         var onNewSearchSessionCoolDownComplete:Function = null;
         onNewSearchSessionCoolDownComplete = function():void
         {
            clearTimeout(timeoutHandler);
            if(!joinable)
            {
               Logger.print("New clan data session reset.");
               mNewClanDataCoolDownComplete = true;
            }
            else
            {
               Logger.print("New joinable clan data session reset.");
               mNewClanDataJoinableCoolDownComplete = true;
            }
         };
         joinable = this.myJoinable.checked;
         if(!joinable && (Boolean(!this.mNewClanDataCoolDownComplete) || Boolean(this.mData)))
         {
            return;
         }
         if(joinable && (Boolean(!this.mNewClanDataJoinableCoolDownComplete) || Boolean(this.mJoinableData)))
         {
            return;
         }
         this.mOffset = 0;
         request = new ClanSearchRequestObj();
         request.type = !joinable ? ClanSearchRequestObj.CLAN_SEARCH_TYPE_NEW : ClanSearchRequestObj.CLAN_SEARCH_TYPE_NEW_JOINABLE;
         request.offset = 0;
         request.count = this.mPageListSetting.itemCountPerPage;
         request.isNewSearch = true;
         this.mSearching = true;
         this.myNoDataHint.myText.text = DictClan.SEARCHING_NAME_CLAN;
         broadcast(BCEvent.GET_SEARCH_CLAN,request);
         if(!joinable)
         {
            this.mNewClanDataCoolDownComplete = false;
         }
         else
         {
            this.mNewClanDataJoinableCoolDownComplete = false;
         }
         timeoutHandler = setTimeout(onNewSearchSessionCoolDownComplete,NEW_CLAN_COOL_DOWN);
      }
      
      public function switchCheckJoinable(checked:Boolean) : void
      {
         this.myJoinable.checked = checked;
      }
      
      private function onBindSearchClanList(cRes:Object) : void
      {
         this.mData = cRes.data;
         this.mOffset = this.mData.requestOffset;
         this.showData();
      }
      
      private function onBindJoinableClanList(cRes:Object) : void
      {
         this.mJoinableData = cRes.data;
         this.mJoinableOffset = this.mJoinableData.requestOffset;
         this.showData();
      }
      
      private function showData() : void
      {
         if(this.mViewingType == ClanSearchRequestObj.CLAN_SEARCH_TYPE_NEW && !this.mData)
         {
            return;
         }
         if(this.mViewingType == ClanSearchRequestObj.CLAN_SEARCH_TYPE_NEW_JOINABLE && !this.mJoinableData)
         {
            return;
         }
         this.mSearching = false;
         var selectedData:Object = this.myJoinable.checked ? this.mJoinableData : this.mData;
         this.myPageList.dataProvider = selectedData.dp;
         this.myNoDataHint.visible = selectedData.dp.length <= 0;
         this.myNoDataHint.myText.text = this.myJoinable.checked ? DictClan.NO_JOINABLE_NEW_CLAN : DictClan.NO_NEW_CLAN;
         this.myPageList.hasPrevBtn = selectedData.hasPrev;
         this.myPageList.hasNextBtn = selectedData.hasNext;
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
         request.type = this.myJoinable.checked ? ClanSearchRequestObj.CLAN_SEARCH_TYPE_NEW_JOINABLE : ClanSearchRequestObj.CLAN_SEARCH_TYPE_NEW;
         request.count = this.mPageListSetting.itemCountPerPage;
         request.isNewSearch = false;
         if(whichBtn == PageListSelector.NEXT_BTN_INDEX)
         {
            request.offset = (this.myJoinable.checked ? this.mJoinableOffset : this.mOffset) + this.mPageListSetting.itemCountPerPage;
         }
         else
         {
            request.offset = (this.myJoinable.checked ? this.mJoinableOffset : this.mOffset) - this.mPageListSetting.itemCountPerPage;
         }
         this.mSearching = true;
         broadcast(BCEvent.GET_SEARCH_CLAN,request);
      }
      
      private function onPendingClanApplicationChanged(e:ParaEvent) : void
      {
         this.myPageList.refreshAllRenderJoinBtnState();
      }
      
      private function isClanApplicationEverSent(id:String) : Boolean
      {
         return getDP(DataID.APPLICATION_PENDING,[id]);
      }
      
      private function onCheckedStateChanged(checked:Boolean) : void
      {
         var buffer:Object = null;
         if(!checked)
         {
            this.mViewingType = ClanSearchRequestObj.CLAN_SEARCH_TYPE_NEW;
            buffer = this.mData;
         }
         else
         {
            this.mViewingType = ClanSearchRequestObj.CLAN_SEARCH_TYPE_NEW_JOINABLE;
            buffer = this.mJoinableData;
         }
         if(!buffer)
         {
            this.realSearch();
         }
         else
         {
            this.showData();
         }
      }
   }
}

