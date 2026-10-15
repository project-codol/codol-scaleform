package codo.views.clan_sub.management_sub
{
   import codo.base.BaseSubElement;
   import codo.component.ScrollGrid;
   import codo.component.core.UIInteractiveComponent;
   import codo.component.social.ClanFriendItem;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.event.ParaEvent;
   import codo.localization.Dict;
   import codo.objects.ScrollGridSettings;
   import codo.objects.ScrollListHeaderObj;
   import codo.objects.ScrollListSettings;
   import flash.utils.getDefinitionByName;
   
   public class ClanInvitationPanel extends BaseSubElement
   {
      
      private static const FRIEND_ITEM_RENDER:String = "codo.social.clanFriendItem";
      
      private static const NUM_ROWS:int = 12;
      
      private static const NUM_COLUMNS:int = 1;
      
      public var myFriendList:ScrollGrid;
      
      private var mFriendData:Array;
      
      private var mRecentMateData:Array;
      
      private var mItemData:Vector.<Object> = new Vector.<Object>();
      
      public function ClanInvitationPanel()
      {
         super();
         this.initStage();
      }
      
      private function initStage() : void
      {
         var gridSettings:ScrollGridSettings = new ScrollGridSettings();
         gridSettings.orientation = ScrollListSettings.SCROLL_VERTICAL;
         gridSettings.buildGridItemRenderMethod = this.buildFriendItemRender;
         gridSettings.useNavArrows = false;
         this.myFriendList.initGrid(gridSettings,NUM_ROWS,false,NUM_COLUMNS);
      }
      
      override public function active() : void
      {
         super.active();
         bind(DataID.CLAN_MEMBER,this.bindClanDP);
         bind(DataID.FILTERED_FRIEND,this.bindFriendDP);
         bind(DataID.FILTERED_PLAYMATE,this.bindRecentPlaymateDP);
         listen(BCEvent.CLAN_MEMBER_LEFT,this.onClanMemberLeftHandler);
      }
      
      override public function deactive() : void
      {
         unbind(DataID.CLAN_MEMBER,this.bindClanDP);
         unbind(DataID.FILTERED_FRIEND,this.bindFriendDP);
         unbind(DataID.FILTERED_PLAYMATE,this.bindRecentPlaymateDP);
         super.deactive();
      }
      
      private function bindClanDP(cRes:Object) : void
      {
         this.tryFillScrollGrid();
      }
      
      private function bindFriendDP() : void
      {
         this.mFriendData = getDP(DataID.FILTERED_FRIEND_INFO,[true]);
         this.tryFillScrollGrid();
      }
      
      private function bindRecentPlaymateDP() : void
      {
         this.mRecentMateData = getDP(DataID.FILTERED_PLAYMATE_INFO,[true]);
         this.tryFillScrollGrid();
      }
      
      private function onClanMemberLeftHandler(cEvt:ParaEvent) : void
      {
         if(Boolean(getDP(DataID.IS_IN_CLAN)))
         {
            this.tryFillScrollGrid();
         }
      }
      
      private function tryFillScrollGrid() : void
      {
         var tempFriendArray:Array = null;
         var i:int = 0;
         var tempRecentMateArray:Array = null;
         if(Boolean(this.mFriendData) && Boolean(this.mRecentMateData))
         {
            tempFriendArray = this.mFriendData.concat();
            for(i = tempFriendArray.length - 1; i >= 0; i--)
            {
               if(Boolean(getDP(DataID.IS_IN_MY_CLAN,[tempFriendArray[i]])))
               {
                  tempFriendArray.splice(i,1);
               }
            }
            tempRecentMateArray = this.mRecentMateData.concat();
            for(i = tempRecentMateArray.length - 1; i >= 0; i--)
            {
               if(Boolean(getDP(DataID.IS_IN_MY_CLAN,[tempRecentMateArray[i]])))
               {
                  tempRecentMateArray.splice(i,1);
               }
            }
            this.setItemData(tempFriendArray,tempRecentMateArray);
         }
      }
      
      private function buildFriendItemRender() : UIInteractiveComponent
      {
         var cls:Class = getDefinitionByName(FRIEND_ITEM_RENDER) as Class;
         var itm:ClanFriendItem = new cls() as ClanFriendItem;
         itm.buttonClickHandler = this.onClanInvitationBtnClicked;
         return itm;
      }
      
      private function onClanInvitationBtnClicked(data:Object, whichButtonClicked:int) : void
      {
         switch(whichButtonClicked)
         {
            case ClanFriendItem.DETAIL_BTN_INDEX:
               this.broadcast(BCEvent.VIEW_PLAYER_DETAIL_INFO,{
                  "id":data.id,
                  "name":data.name
               });
               break;
            case ClanFriendItem.INVITE_BTN_INDEX:
               broadcast(BCEvent.INVITE_USERS_TO_CLAN,{"users":[data]});
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
      }
   }
}

