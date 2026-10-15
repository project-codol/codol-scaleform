package codo.views.friend_parts
{
   import codo.base.BaseSubElement;
   import codo.component.ContentContainer;
   import codo.component.social.PageListSelector;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.constants.MsgBtnCount;
   import codo.localization.Dict;
   import codo.objects.PageListSettings;
   import codo.objects.PlayerBasicInfoObj;
   import codo.objects.QQMemberDataPacketObj;
   import codo.objects.QQUser;
   import codo.utils.LocalizeUtil;
   import codo.utils.PlayerBasicInfoQueryUtil;
   import codo.views.FriendView;
   
   public class QQMemberListPanel extends BaseSubElement
   {
      
      private static const QQ_ITEM_LINKAGE:String = "codo.friend.qqMemberSelector";
      
      private static const MEMBER_PANEL_WIDTH:int = 714;
      
      private static const MEMBER_PANEL_HEIGHT:int = 715;
      
      private static const ITEMS_PER_PAGE:int = 14;
      
      public var myContentContainer:ContentContainer;
      
      public var myPageList:QQPlayerPageList;
      
      private var mQQFriendData:QQMemberDataPacketObj;
      
      private var mNearbyPlayerData:QQMemberDataPacketObj;
      
      private var mCategory:int;
      
      private var mPlayerBasicInfoQueryUtil:PlayerBasicInfoQueryUtil;
      
      public function QQMemberListPanel()
      {
         super();
         this.myContentContainer.width = MEMBER_PANEL_WIDTH;
         this.myContentContainer.height = MEMBER_PANEL_HEIGHT;
         var pageListSetting:PageListSettings = new PageListSettings();
         pageListSetting.itemCountPerPage = 14;
         pageListSetting.itemPadding = 10;
         pageListSetting.renderLinkName = QQ_ITEM_LINKAGE;
         pageListSetting.customPageSelectorHandler = this.onPageSelectorClicked;
         pageListSetting.itemClickHandler = this.actionButtonClicked;
         this.myPageList.settings = pageListSetting;
         this.myPageList.dataProvider = [];
         this.mPlayerBasicInfoQueryUtil = new PlayerBasicInfoQueryUtil();
         this.mPlayerBasicInfoQueryUtil.registerPlayerBasicInfoHandler(this.onPlayerBasicInfo);
         this.mPlayerBasicInfoQueryUtil.registerCompleteHandler(this.onPlayerBasicInfoComplete);
      }
      
      public function setCategory(category:int) : void
      {
         this.mCategory = category;
      }
      
      override public function active() : void
      {
         super.active();
         bind(DataID.GET_QQ_MEMBER_DATA,this.bindQQMemberData);
         if(this.mCategory == FriendView.QQ_FRIEND_INDEX)
         {
            if(this.mQQFriendData == null)
            {
               this.myPageList.dataProvider = [];
               this.myPageList.hasPrevBtn = false;
               this.myPageList.hasNextBtn = false;
               this.requestData(this.mCategory,0,ITEMS_PER_PAGE);
            }
            else
            {
               this.myPageList.dataProvider = this.mQQFriendData.data;
               this.myPageList.hasPrevBtn = this.mQQFriendData.hasPrev;
               this.myPageList.hasNextBtn = this.mQQFriendData.hasNext;
            }
         }
         else if(this.mCategory == FriendView.QQ_NEARBY_INDEX)
         {
            if(this.mNearbyPlayerData == null)
            {
               this.myPageList.dataProvider = [];
               this.myPageList.hasPrevBtn = false;
               this.myPageList.hasNextBtn = false;
               this.requestData(this.mCategory,0,ITEMS_PER_PAGE);
            }
            else
            {
               this.myPageList.dataProvider = this.mNearbyPlayerData.data;
               this.myPageList.hasPrevBtn = this.mNearbyPlayerData.hasPrev;
               this.myPageList.hasNextBtn = this.mNearbyPlayerData.hasNext;
            }
         }
      }
      
      override public function deactive() : void
      {
         super.deactive();
         unbind(DataID.GET_QQ_MEMBER_DATA,this.bindQQMemberData);
      }
      
      private function requestData(category:int, startIndex:int, numRequest:int) : void
      {
         if(!getDP(DataID.IS_QT_ENABLED))
         {
            showMsg("LOGIN WITH TCLS ONLY!",MsgBtnCount.ONE);
            return;
         }
         broadcast(BCEvent.EVT_REQUEST_QQ_PLAYER_DATA,{
            "category":category,
            "startIndex":startIndex,
            "numRequest":numRequest
         });
      }
      
      private function onPageSelectorClicked(whichBtn:int) : void
      {
         var data:QQMemberDataPacketObj = this.getCachedData();
         if(data == null)
         {
            return;
         }
         if(whichBtn == PageListSelector.NEXT_BTN_INDEX && data.hasNext)
         {
            this.requestData(data.category,data.currentIndex + ITEMS_PER_PAGE,ITEMS_PER_PAGE);
         }
         else if(whichBtn == PageListSelector.PREV_BTN_INDEX && data.hasPrev)
         {
            this.requestData(data.category,data.currentIndex - ITEMS_PER_PAGE,ITEMS_PER_PAGE);
         }
      }
      
      private function bindQQMemberData(cRes:Object) : void
      {
         var category:int = 0;
         var userIdsArray:Array = null;
         var i:int = 0;
         var result:QQMemberDataPacketObj = cRes.data as QQMemberDataPacketObj;
         if(result != null)
         {
            category = result.category;
            userIdsArray = new Array();
            if(category == FriendView.QQ_FRIEND_INDEX)
            {
               this.mQQFriendData = result;
            }
            else if(category == FriendView.QQ_NEARBY_INDEX)
            {
               this.mNearbyPlayerData = result;
               for(i = 0; i < result.data.length; i++)
               {
                  userIdsArray.push(result.data[i].userID);
               }
            }
            this.myPageList.dataProvider = result.data;
            this.myPageList.hasNextBtn = result.hasNext;
            this.myPageList.hasPrevBtn = result.hasPrev;
            if(category == FriendView.QQ_NEARBY_INDEX)
            {
               this.mPlayerBasicInfoQueryUtil.queryPlayerBasicInfo(userIdsArray);
            }
         }
      }
      
      private function getCachedData() : QQMemberDataPacketObj
      {
         if(this.mCategory == FriendView.QQ_FRIEND_INDEX)
         {
            return this.mQQFriendData;
         }
         return this.mNearbyPlayerData;
      }
      
      private function onPlayerBasicInfo(info:PlayerBasicInfoObj) : void
      {
         var singleData:QQUser = null;
         for(var i:int = 0; i < this.myPageList.dataProvider.length; i++)
         {
            singleData = this.myPageList.dataProvider[i] as QQUser;
            if(singleData.userID == info.entityID)
            {
               if(info.available)
               {
                  singleData.userName = info.entityName;
                  singleData.wargodScore = info.wargodScore;
                  singleData.wargodSeason = info.wargodSeason;
               }
               else
               {
                  singleData.userName = LocalizeUtil.param(Dict.NEARBYNAME_ALTERNATIVE,[singleData.qqName]);
               }
               break;
            }
         }
      }
      
      private function onPlayerBasicInfoComplete() : void
      {
         this.myPageList.refresh();
      }
      
      private function actionButtonClicked(user:QQUser) : void
      {
         var isQQFriend:Boolean = user.userID == "0";
         if(!isQQFriend)
         {
            broadcast(BCEvent.VIEW_PLAYER_DETAIL_INFO,{
               "id":user.userID,
               "name":user.userName
            });
         }
         else
         {
            broadcast(BCEvent.EVT_SEND_GAME_RECOMMENDATION,{"id":user.qqNumber});
         }
      }
   }
}

