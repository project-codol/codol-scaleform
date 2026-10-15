package components.fsgSocialPanel_part
{
   import codo.base.BaseSubElement;
   import codo.component.Button;
   import codo.component.PartyInviteScrollGrid;
   import codo.component.TextField;
   import codo.component.core.UIInteractiveComponent;
   import codo.constants.BCEvent;
   import codo.constants.Common;
   import codo.constants.DataID;
   import codo.localization.Dict;
   import codo.localization.DictParty;
   import codo.objects.ScrollGridSettings;
   import codo.objects.ScrollListHeaderObj;
   import codo.objects.ScrollListSettings;
   import codo.style.PartyGuide;
   import codo.utils.LocalizeUtil;
   import codo.utils.MathUtil;
   import codo.views.party_parts.FriendItemForParty;
   import flash.display.MovieClip;
   import flash.utils.getDefinitionByName;
   
   public class FsgPartyInvitePanel extends BaseSubElement
   {
      
      private static const ITEM_LINKAGE:String = "codo.party.friendItemForParty";
      
      private static const ITEM_WIDTH:int = 520;
      
      public var myFriendList:PartyInviteScrollGrid;
      
      public var myInviteBtn:Button;
      
      public var myInviteLimit:TextField;
      
      public var myNoFriendIcon:MovieClip;
      
      private var mFriendData:Array;
      
      private var mRecentMateData:Array;
      
      private var mPendingPartyMember:Array;
      
      private var mItemData:Vector.<Object> = new Vector.<Object>();
      
      public function FsgPartyInvitePanel()
      {
         super();
         var gridSettings:ScrollGridSettings = new ScrollGridSettings();
         gridSettings.orientation = ScrollListSettings.SCROLL_VERTICAL;
         gridSettings.buildGridItemRenderMethod = this.buildFriendItemRender;
         gridSettings.useNavArrows = false;
         gridSettings.barOffsetX = 4;
         this.myFriendList.initGrid(gridSettings,12,false,1);
         this.myInviteBtn.width = 180;
         this.myInviteBtn.height = 31;
         this.myInviteBtn.label = DictParty.INVITE_MEMBER;
         this.myInviteBtn.registerClickEvent(this.onInvitePartyCallback);
         this.myInviteBtn.x = this.myFriendList.x + ITEM_WIDTH - this.myInviteBtn.width;
         this.myInviteLimit.textStyle = PartyGuide.styleInviteFriendIntroduction;
         this.myInviteLimit.width = 500;
         this.myInviteLimit.height = 50;
         this.myInviteLimit.x = this.myFriendList.x;
         var xpBuff:String = MathUtil.percentValue(getDP(DataID.GET_PARTY_XP_BUFF));
         this.myNoFriendIcon.myIndication.text = LocalizeUtil.param(DictParty.PARTY_NO_INVITATION_DIRECTION,[xpBuff]);
      }
      
      override public function active() : void
      {
         super.active();
         this.myFriendList.cleanAllCheckBox();
         broadcast(BCEvent.EVT_CLEAN_ALL_SELECT_PARTY_PLAYER);
         bind(DataID.FILTERED_FRIEND,this.bindFriendDP);
         bind(DataID.FILTERED_PLAYMATE,this.bindRecentPlaymateDP);
         bind(DataID.PARTY_PENDING_MEMBER,this.bindPartyPendingMember);
         bind(DataID.PARTY_SELECTED_CANDIDATE,this.bindPartySelectedCandidate);
      }
      
      override public function deactive() : void
      {
         super.deactive();
         unbind(DataID.FILTERED_FRIEND,this.bindFriendDP);
         unbind(DataID.FILTERED_PLAYMATE,this.bindRecentPlaymateDP);
         unbind(DataID.PARTY_PENDING_MEMBER,this.bindPartyPendingMember);
         unbind(DataID.PARTY_SELECTED_CANDIDATE,this.bindPartySelectedCandidate);
      }
      
      private function onInvitePartyCallback() : void
      {
         broadcast(BCEvent.EVT_PROPOSE_PARTY_MEMBERSHIP);
      }
      
      private function buildFriendItemRender() : UIInteractiveComponent
      {
         var cls:Class = getDefinitionByName(ITEM_LINKAGE) as Class;
         var item:FriendItemForParty = new cls() as FriendItemForParty;
         item.friendSelectionChanged = this.onFriendSelectionChangedHandler;
         return item;
      }
      
      private function onFriendSelectionChangedHandler(user:Object, selected:Boolean) : void
      {
         if(selected)
         {
            broadcast(BCEvent.EVT_ADD_SELECT_PARTY_PLAYER,[user]);
         }
         else
         {
            broadcast(BCEvent.EVT_REMOVE_SELECT_PARTY_PLAYER,[user]);
         }
      }
      
      private function bindFriendDP(cRes:Object) : void
      {
         this.mFriendData = getDP(DataID.FILTERED_FRIEND_INFO,[true]);
         this.tryFillScrollGrid();
      }
      
      private function bindRecentPlaymateDP(cRes:Object) : void
      {
         this.mRecentMateData = getDP(DataID.FILTERED_PLAYMATE_INFO,[true]);
         this.tryFillScrollGrid();
      }
      
      private function bindPartyPendingMember(cRes:Object) : void
      {
         this.mPendingPartyMember = cRes.data as Array;
         this.tryFillScrollGrid();
      }
      
      private function bindPartySelectedCandidate(cRes:Object) : void
      {
         var maxPartyCandidateAllowed:int = getDP(DataID.MAX_PARTY_CANDIDATE_ALLOWED);
         this.myFriendList.enableCheckBox(cRes.data.length < maxPartyCandidateAllowed);
         this.showInviteHint(maxPartyCandidateAllowed,cRes.data.length);
      }
      
      private function tryFillScrollGrid() : void
      {
         var tempFriendArray:Array = null;
         var i:int = 0;
         var tempRecentMateArray:Array = null;
         var friendObj:Object = null;
         var recentMateObj:Object = null;
         var removedMemberList:Array = [];
         if(Boolean(this.mFriendData) && Boolean(this.mRecentMateData))
         {
            tempFriendArray = this.mFriendData.concat();
            for(i = tempFriendArray.length - 1; i >= 0; i--)
            {
               friendObj = tempFriendArray[i];
               if(!this.isOnline(friendObj) || this.isInPendingPartyMember(friendObj.id) || Boolean(getDP(DataID.IS_IN_MY_PARTY,[friendObj])))
               {
                  removedMemberList.push(friendObj);
                  tempFriendArray.splice(i,1);
               }
            }
            tempRecentMateArray = this.mRecentMateData.concat();
            for(i = tempRecentMateArray.length - 1; i >= 0; i--)
            {
               recentMateObj = tempRecentMateArray[i];
               if(!this.isOnline(recentMateObj) || this.isInPendingPartyMember(recentMateObj.id) || Boolean(getDP(DataID.IS_IN_MY_PARTY,[recentMateObj])))
               {
                  removedMemberList.push(recentMateObj);
                  tempRecentMateArray.splice(i,1);
               }
            }
            this.setItemData(tempFriendArray,tempRecentMateArray);
            broadcast(BCEvent.EVT_REMOVE_SELECT_PARTY_PLAYER,removedMemberList);
         }
      }
      
      private function setItemData(friends:Array, recentMat:Array) : void
      {
         var header:ScrollListHeaderObj = null;
         var friend:Object = null;
         var recentMate:Object = null;
         var headers:Vector.<ScrollListHeaderObj> = new Vector.<ScrollListHeaderObj>(0);
         if(friends.length > 0)
         {
            header = new ScrollListHeaderObj();
            header.beforeIndex = 0;
            header.count = friends.length;
            header.label = Dict.CONTACT_FRIEND;
            headers.push(header);
         }
         if(recentMat.length > 0)
         {
            header = new ScrollListHeaderObj();
            header.beforeIndex = friends.length;
            header.count = recentMat.length;
            header.label = Dict.CONTACT_RECENT;
            headers.push(header);
         }
         this.myFriendList.setHeaders(headers);
         this.mItemData.splice(0,this.mItemData.length);
         for each(friend in friends)
         {
            this.mItemData.push(friend);
         }
         for each(recentMate in recentMat)
         {
            this.mItemData.push(recentMate);
         }
         this.myNoFriendIcon.visible = this.mItemData.length <= 0;
         this.myInviteBtn.visible = this.mItemData.length > 0;
         this.myInviteLimit.visible = this.mItemData.length > 0;
         this.myFriendList.addItemsByVector(this.mItemData);
      }
      
      private function isInPendingPartyMember(id:String) : Boolean
      {
         if(null == this.mPendingPartyMember)
         {
            return false;
         }
         var len:int = int(this.mPendingPartyMember.length);
         for(var i:int = 0; i < len; i++)
         {
            if(this.mPendingPartyMember[i].id == id)
            {
               return true;
            }
         }
         return false;
      }
      
      private function showInviteHint(max:int, current:int) : void
      {
         this.myInviteLimit.text = LocalizeUtil.param(DictParty.PARTY_INVITATION_DIRECTION,[max,current]);
      }
      
      private function isOnline(obj:Object) : Boolean
      {
         return obj.friendStatus > Common.CODO_BASIC_PRESENCE_OFFLINE;
      }
   }
}

