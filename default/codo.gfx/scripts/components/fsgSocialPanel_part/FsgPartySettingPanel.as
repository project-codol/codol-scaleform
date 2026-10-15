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
   
   public class FsgPartySettingPanel extends BaseSubElement
   {
      
      private static const ITEM_LINKAGE:String = "codo.party.friendItemForParty";
      
      private static const ITEM_WIDTH:int = 520;
      
      public var myNoFriendIcon:MovieClip;
      
      public var myInviteFriendIntroduction:TextField;
      
      public var myInviteLimit:TextField;
      
      public var myFriendList:PartyInviteScrollGrid;
      
      public var myCreatePartyBtn:Button;
      
      private var mFriendData:Array;
      
      private var mRecentMateData:Array;
      
      private var mItemData:Vector.<Object> = new Vector.<Object>();
      
      public function FsgPartySettingPanel()
      {
         super();
         this.myInviteFriendIntroduction.textStyle = PartyGuide.styleInviteFriendIntroduction;
         this.myInviteFriendIntroduction.width = 500;
         this.myInviteFriendIntroduction.height = 50;
         this.myInviteFriendIntroduction.x = 18;
         this.myInviteFriendIntroduction.y = 23;
         this.myInviteLimit.textStyle = PartyGuide.styleInviteFriendIntroduction;
         this.myInviteLimit.width = 500;
         this.myInviteLimit.height = 50;
         this.myInviteLimit.x = 18;
         this.myInviteLimit.y = 610;
         var gridSettings:ScrollGridSettings = new ScrollGridSettings();
         gridSettings.orientation = ScrollListSettings.SCROLL_VERTICAL;
         gridSettings.buildGridItemRenderMethod = this.buildFriendItemRender;
         gridSettings.useNavArrows = false;
         gridSettings.barOffsetX = 4;
         this.myFriendList.initGrid(gridSettings,12,false,1);
         this.myFriendList.addItemsByVector(new Vector.<Object>());
         this.myFriendList.x = 18;
         this.myFriendList.y = 55;
         this.myCreatePartyBtn.width = 180;
         this.myCreatePartyBtn.height = 31;
         this.myCreatePartyBtn.label = DictParty.CREATE_PARTY;
         this.myCreatePartyBtn.registerClickEvent(this.onCreatePartyCallback);
         this.myCreatePartyBtn.x = this.myFriendList.x + ITEM_WIDTH - this.myCreatePartyBtn.width;
         this.myCreatePartyBtn.y = 610;
         var xpBuff:String = MathUtil.percentValue(getDP(DataID.GET_PARTY_XP_BUFF));
         this.myNoFriendIcon.myIndication.text = LocalizeUtil.param(DictParty.PARTY_NO_INVITATION_DIRECTION,[xpBuff]);
         this.myInviteFriendIntroduction.text = LocalizeUtil.param(DictParty.PARTY_BENEFIT_SENTENCE,[xpBuff]);
      }
      
      override public function active() : void
      {
         super.active();
         this.myFriendList.cleanAllCheckBox();
         broadcast(BCEvent.EVT_CLEAN_ALL_SELECT_PARTY_PLAYER);
         bind(DataID.FILTERED_FRIEND,this.bindFriendDP);
         bind(DataID.FILTERED_PLAYMATE,this.bindRecentPlaymateDP);
         bind(DataID.PARTY_SELECTED_CANDIDATE,this.bindPartySelectedCandidate);
      }
      
      override public function deactive() : void
      {
         super.deactive();
         unbind(DataID.FILTERED_FRIEND,this.bindFriendDP);
         unbind(DataID.FILTERED_PLAYMATE,this.bindRecentPlaymateDP);
         unbind(DataID.PARTY_SELECTED_CANDIDATE,this.bindPartySelectedCandidate);
      }
      
      private function buildFriendItemRender() : UIInteractiveComponent
      {
         var cls:Class = getDefinitionByName(ITEM_LINKAGE) as Class;
         var item:FriendItemForParty = new cls() as FriendItemForParty;
         item.friendSelectionChanged = this.onFriendSelectionChangedHandler;
         return item;
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
      
      private function bindPartySelectedCandidate(cRes:Object) : void
      {
         var maxPartyCandidateAllowed:int = getDP(DataID.MAX_PARTY_CANDIDATE_ALLOWED);
         this.myFriendList.enableCheckBox(cRes.data.length < maxPartyCandidateAllowed);
         this.showInviteHint(maxPartyCandidateAllowed,cRes.data.length);
      }
      
      private function showInviteHint(max:int, current:int) : void
      {
         this.myInviteLimit.text = LocalizeUtil.param(DictParty.PARTY_INVITATION_DIRECTION,[max,current]);
      }
      
      private function tryFillScrollGrid() : void
      {
         var tempFriendArray:Array = null;
         var i:int = 0;
         var tempRecentMateArray:Array = null;
         var removedMemberList:Array = [];
         if(Boolean(this.mFriendData) && Boolean(this.mRecentMateData))
         {
            tempFriendArray = this.mFriendData.concat();
            for(i = tempFriendArray.length - 1; i >= 0; i--)
            {
               if(!this.isOnline(tempFriendArray[i]))
               {
                  removedMemberList.push(tempFriendArray[i]);
                  tempFriendArray.splice(i,1);
               }
            }
            tempRecentMateArray = this.mRecentMateData.concat();
            for(i = tempRecentMateArray.length - 1; i >= 0; i--)
            {
               if(!this.isOnline(tempRecentMateArray[i]))
               {
                  removedMemberList.push(tempRecentMateArray[i]);
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
         this.myFriendList.addItemsByVector(this.mItemData);
         this.myNoFriendIcon.visible = this.mItemData.length <= 0;
         this.myInviteLimit.visible = this.myInviteFriendIntroduction.visible = this.mItemData.length > 0;
      }
      
      private function onCreatePartyCallback() : void
      {
         broadcast(BCEvent.PARTY_CREATE);
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
      
      private function isOnline(obj:Object) : Boolean
      {
         return obj.friendStatus > Common.CODO_BASIC_PRESENCE_OFFLINE;
      }
   }
}

