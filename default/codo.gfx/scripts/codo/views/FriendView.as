package codo.views
{
   import codo.base.BaseSubElement;
   import codo.base.BaseView;
   import codo.component.CloseButton;
   import codo.component.TextField;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.event.ParaEvent;
   import codo.localization.Dict;
   import codo.style.FriendGuide;
   import codo.views.friend_parts.MemberListPanel;
   import codo.views.friend_parts.QQMemberListPanel;
   import codo.views.friend_parts.SelectorPanel;
   
   public class FriendView extends BaseView
   {
      
      public static const NONE_INDEX:int = -1;
      
      public static const FRIEND_INDEX:int = 0;
      
      public static const RECENT_INDEX:int = 1;
      
      public static const CLAN_INDEX:int = 2;
      
      public static const BLACKLIST_INDEX:int = 3;
      
      public static const MAX_GAME_RELATION:int = 4;
      
      public static const QQ_FRIEND_INDEX:int = 4;
      
      public static const QQ_NEARBY_INDEX:int = 5;
      
      public var myTitle:TextField;
      
      public var myQQMemberListPanel:QQMemberListPanel;
      
      public var myMemberListPanel:MemberListPanel;
      
      public var mySelectorPanel:SelectorPanel;
      
      public var myCloseBtn:CloseButton;
      
      private var mFriendRawData:Array;
      
      private var mRecentRawData:Array;
      
      private var mClanMemberRawData:Array;
      
      private var mCurrentMemberListPanel:BaseSubElement;
      
      private var mFilteredFriend:Vector.<Object> = new Vector.<Object>();
      
      private var mFilteredRecent:Vector.<Object> = new Vector.<Object>();
      
      private var mFilteredClanMember:Vector.<Object> = new Vector.<Object>();
      
      private var mBlacklist:Vector.<Object> = new Vector.<Object>();
      
      private var mCurrentCategory:int = -1;
      
      private var mMembers:Array = [this.mFilteredFriend,this.mFilteredRecent,this.mFilteredClanMember,this.mBlacklist];
      
      public function FriendView()
      {
         super();
         this.initStage();
      }
      
      private function initStage() : void
      {
         this.myTitle.textStyle = FriendGuide.styleTitle;
         this.myTitle.text = Dict.CONTACT_FRIEND;
         this.myCloseBtn.registerClickEvent(this.onCloseBtnClicked);
         this.mySelectorPanel.registerCategoryChangedCallback(this.onCategoryChangeHandler);
         this.myMemberListPanel.visible = false;
         this.myQQMemberListPanel.visible = false;
      }
      
      override protected function enableData() : void
      {
         super.enableData();
         bind(DataID.FRIENDS,this.bindFriend);
         bind(DataID.RECENT_PLAYMATES,this.bindRecentPlayMate);
         bind(DataID.CLAN_MEMBER,this.bindClanMember);
         bind(DataID.LIST_BLACKLIST,this.bindBlackList);
         bind(DataID.UPDATE_FRIEND_RICH_PRESENCE,this.bindFriendRichPresenceUpdated);
         listen(BCEvent.EVT_WARGOD_OPENING_STATE_CHANGED,this.onWarGodOpenStateChanged);
         this.mySelectorPanel.active();
      }
      
      override protected function disableData() : void
      {
         this.mySelectorPanel.deactive();
         this.myMemberListPanel.deactive();
         this.myQQMemberListPanel.deactive();
         this.mCurrentMemberListPanel = null;
         super.disableData();
         unbind(DataID.FRIENDS,this.bindFriend);
         unlisten(BCEvent.EVT_WARGOD_OPENING_STATE_CHANGED,this.onWarGodOpenStateChanged);
      }
      
      private function onCloseBtnClicked() : void
      {
         broadcast(BCEvent.EVT_CLOSE_FRIEND);
      }
      
      private function onCategoryChangeHandler(category:int) : void
      {
         if(category < MAX_GAME_RELATION)
         {
            if(this.mCurrentMemberListPanel != this.myMemberListPanel)
            {
               this.myMemberListPanel.active();
               this.myQQMemberListPanel.deactive();
               this.mCurrentMemberListPanel = this.myMemberListPanel;
            }
            this.myMemberListPanel.setData(this.mMembers[category]);
         }
         else
         {
            if(this.mCurrentMemberListPanel != this.myQQMemberListPanel)
            {
               this.myMemberListPanel.deactive();
               this.mCurrentMemberListPanel = this.myQQMemberListPanel;
            }
            this.myQQMemberListPanel.setCategory(category);
            this.myQQMemberListPanel.active();
         }
         this.mCurrentCategory = category;
      }
      
      private function bindFriend(cRes:Object) : void
      {
         this.mFriendRawData = cRes.data;
         this.filterBlackList(this.mFriendRawData,this.mFilteredFriend);
         this.tryRefreshCurrentList(FRIEND_INDEX);
      }
      
      private function bindRecentPlayMate(cRes:Object) : void
      {
         this.mRecentRawData = cRes.data;
         this.filterBlackList(this.mRecentRawData,this.mFilteredRecent);
         this.tryRefreshCurrentList(RECENT_INDEX);
      }
      
      private function bindClanMember(cRes:Object) : void
      {
         this.mClanMemberRawData = cRes.data;
         this.filterBlackList(this.mClanMemberRawData,this.mFilteredClanMember);
         this.tryRefreshCurrentList(CLAN_INDEX);
      }
      
      private function bindBlackList(cRes:Object) : void
      {
         var blacklistData:Array = cRes.data;
         var blacklistLen:int = int(blacklistData.length);
         this.mBlacklist.splice(0,this.mBlacklist.length);
         for(var i:int = 0; i < blacklistLen; i++)
         {
            this.mBlacklist.push(blacklistData[i]);
         }
         this.filterBlackList(this.mFriendRawData,this.mFilteredFriend);
         this.filterBlackList(this.mRecentRawData,this.mFilteredRecent);
         this.filterBlackList(this.mClanMemberRawData,this.mFilteredClanMember);
         this.tryRefreshCurrentList(this.mCurrentCategory);
      }
      
      private function bindFriendRichPresenceUpdated(cRes:Object) : void
      {
         var aFriendRP:Object = null;
         var j:int = 0;
         var rpArrays:Array = cRes.data;
         var hasChanges:Boolean = false;
         for(var i:int = 0; i < rpArrays.length; i++)
         {
            aFriendRP = rpArrays[i];
            for(j = 0; j < this.mFilteredClanMember.length; j++)
            {
               if(this.mFilteredClanMember[j].id == aFriendRP.id)
               {
                  this.mFilteredClanMember[j].friendStatus = aFriendRP.friendStatus;
                  this.mFilteredClanMember[j].qqMembershipBits = aFriendRP.qqMembershipBits;
                  this.mFilteredClanMember[j].netCafePrivileges = aFriendRP.netcafePriviligeBits;
                  hasChanges = true;
               }
            }
         }
         this.tryRefreshCurrentList(CLAN_INDEX);
      }
      
      private function filterBlackList(rawData:Array, filteredData:Vector.<Object>) : void
      {
         var isBlackList:Boolean = false;
         var j:int = 0;
         if(rawData == null)
         {
            return;
         }
         var rawDataLen:int = int(rawData.length);
         var blacklistLen:int = Boolean(this.mBlacklist) ? int(this.mBlacklist.length) : 0;
         filteredData.splice(0,filteredData.length);
         for(var i:int = 0; i < rawDataLen; i++)
         {
            isBlackList = false;
            for(j = 0; j < blacklistLen; j++)
            {
               if(this.mBlacklist[j].id == rawData[i].id)
               {
                  isBlackList = true;
                  break;
               }
            }
            if(!isBlackList)
            {
               filteredData.push(rawData[i]);
            }
         }
      }
      
      private function tryRefreshCurrentList(changedCategory:int) : void
      {
         if(changedCategory == this.mCurrentCategory && this.mCurrentCategory != NONE_INDEX)
         {
            this.onCategoryChangeHandler(changedCategory);
         }
      }
      
      public function onWarGodOpenStateChanged(cEvt:ParaEvent) : void
      {
         if(this.mCurrentCategory != NONE_INDEX)
         {
            this.onCategoryChangeHandler(this.mCurrentCategory);
         }
      }
   }
}

