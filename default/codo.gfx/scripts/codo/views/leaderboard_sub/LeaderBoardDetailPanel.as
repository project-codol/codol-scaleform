package codo.views.leaderboard_sub
{
   import codo.base.BaseSubElement;
   import codo.component.ComboBox;
   import codo.component.ContentContainer;
   import codo.component.TextField;
   import codo.component.social.PageListSelector;
   import codo.component.social.SocialDropDown;
   import codo.component.social.SocialHamburgerButton;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.constants.RightClickMenuType;
   import codo.event.ParaEvent;
   import codo.localization.Dict;
   import codo.localization.DictLeaderBoard;
   import codo.objects.PageListSettings;
   import codo.objects.PlayerBasicInfoObj;
   import codo.objects.RightClickMenuItemObj;
   import codo.style.LeaderBoardGuide;
   import codo.utils.PlayerBasicInfoQueryUtil;
   import codo.views.leaderboard_sub.detail_sub.LeaderBoardItem;
   import codo.views.leaderboard_sub.detail_sub.LeaderBoardPageList;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.getDefinitionByName;
   
   public class LeaderBoardDetailPanel extends BaseSubElement
   {
      
      private static const LEADERBOARD_ITEM_LINKAGE:String = "codo.social.leaderboard.leaderBoardItem";
      
      private static const DROP_DOWN_PANEL_LINK:String = "codo.social.socialDropDown";
      
      private static const PAGE_SIZE:int = 16;
      
      public static const LB_PEOPLE_RANGE_TYPE_FRIEND:uint = 0;
      
      public static const LB_PEOPLE_RANGE_TYPE_CLAN:uint = 1;
      
      public static const LB_PEOPLE_RANGE_TYPE_WHOLE:uint = 2;
      
      public static const LB_TIME_RANGE_TYPE_WHOLE:uint = 0;
      
      public static const LB_TIME_RANGE_TYPE_WEEKLY:uint = 1;
      
      private static const CONTAINER_WIDTH:int = 915;
      
      private static const CONTAINER_HEIGHT:int = 745;
      
      public var myValueCB:ComboBox;
      
      public var myFriendCB:ComboBox;
      
      public var myWeekCB:ComboBox;
      
      public var myPageList:LeaderBoardPageList;
      
      public var myHeader:MovieClip;
      
      public var mySelf:LeaderBoardItem;
      
      public var myDataFailHint:MovieClip;
      
      public var myContainer:ContentContainer;
      
      public var myNotice:TextField;
      
      private var mPageListSetting:PageListSettings;
      
      private var mRequestInProgress:Boolean = false;
      
      private var mRequestedLBName:String = "";
      
      private var mDataSet:Boolean = false;
      
      private var mCurPage:int = 0;
      
      private var mDropDownMenu:SocialDropDown;
      
      private var mPlayerBasicInfoQueryUtil:PlayerBasicInfoQueryUtil;
      
      public function LeaderBoardDetailPanel()
      {
         super();
         this.initStage();
      }
      
      private function initStage() : void
      {
         this.myHeader.myRank.textStyle = LeaderBoardGuide.styleHeader;
         this.myHeader.myRank.text = Dict.LEADERBOARD_INDEX;
         this.myHeader.myLevel.textStyle = LeaderBoardGuide.styleHeader;
         this.myHeader.myLevel.text = Dict.LEADERBOARD_LEVEL;
         this.myHeader.myName.textStyle = LeaderBoardGuide.styleHeader;
         this.myHeader.myName.text = Dict.LEADERBOARD_USER_NAME;
         this.myHeader.myValue.textStyle = LeaderBoardGuide.styleHeader;
         this.myHeader.myWargodTier.text = Dict.LEADERBOARD_WAR_GOD_RANKING;
         this.myHeader.myWargodTier.textStyle = LeaderBoardGuide.styleHeader;
         this.myDataFailHint.myText.text = DictLeaderBoard.DOWNLOAD_FAIL;
         this.myNotice.textStyle = LeaderBoardGuide.styleNotice;
         this.myNotice.text = this.getDP(DataID.LEADERBOARD_NOTICE);
         this.myContainer.width = CONTAINER_WIDTH;
         this.myContainer.height = CONTAINER_HEIGHT;
         this.myContainer.showText = true;
         this.myFriendCB.singleOptionMode = true;
         this.myFriendCB.width = 120;
         this.myFriendCB.addEventListener(ComboBox.EVT_CHANGE,this.onFriendStateChanged);
         this.myWeekCB.singleOptionMode = true;
         this.myWeekCB.width = 120;
         this.myWeekCB.addEventListener(ComboBox.EVT_CHANGE,this.onWeekStateChanged);
         this.myWeekCB.dataProvider = [{
            "id":LB_TIME_RANGE_TYPE_WHOLE,
            "enabled":true,
            "label":Dict.LEADERBOARD_WHOLE_TIME
         },{
            "id":LB_TIME_RANGE_TYPE_WEEKLY,
            "enabled":true,
            "label":Dict.LEADERBOARD_WEEKLY
         }];
         LeaderBoardItem.setShowHamburgerButtonClickedHandler(this.onShowHamburgerButton);
         this.mPageListSetting = new PageListSettings();
         this.mPageListSetting.itemCountPerPage = PAGE_SIZE;
         this.mPageListSetting.itemPadding = 0;
         this.mPageListSetting.renderLinkName = LEADERBOARD_ITEM_LINKAGE;
         this.mPageListSetting.customPageSelectorHandler = this.onPageSelectorClicked;
         this.myPageList.settings = this.mPageListSetting;
         this.myPageList.setShowHamburgerButton(this.onShowHamburgerButton);
         this.myWeekCB.selectedIndex = LB_TIME_RANGE_TYPE_WHOLE;
         bind(DataID.LEADERBOARD_DATA_RESPONDED,this.onLeaderBoardDataResponded);
         var cls:Class = getDefinitionByName(DROP_DOWN_PANEL_LINK) as Class;
         this.mDropDownMenu = new cls() as SocialDropDown;
         this.mPlayerBasicInfoQueryUtil = new PlayerBasicInfoQueryUtil();
         this.mPlayerBasicInfoQueryUtil.registerPlayerBasicInfoHandler(this.onPlayerBasicInfo);
         this.mPlayerBasicInfoQueryUtil.registerCompleteHandler(this.onPlayerBasicInfoComplete);
      }
      
      override public function active() : void
      {
         super.active();
         listen(BCEvent.EVT_WARGOD_OPENING_STATE_CHANGED,this.onWarGodOpenStateChanged);
      }
      
      override public function deactive() : void
      {
         super.deactive();
         unlisten(BCEvent.EVT_WARGOD_OPENING_STATE_CHANGED,this.onWarGodOpenStateChanged);
      }
      
      public function onWarGodOpenStateChanged(cEvt:ParaEvent) : void
      {
         this.myPageList.refresh();
         this.mySelf.setData(this.mySelf.getData());
      }
      
      public function refreshFilters() : void
      {
         var inClan:Boolean = this.getDP(DataID.IS_IN_CLAN);
         this.myFriendCB.dataProvider = [{
            "id":LB_PEOPLE_RANGE_TYPE_FRIEND,
            "enabled":true,
            "label":Dict.LEADERBOARD_FRIEND
         },{
            "id":LB_PEOPLE_RANGE_TYPE_CLAN,
            "enabled":inClan,
            "label":Dict.LEADERBOARD_CLAN
         },{
            "id":LB_PEOPLE_RANGE_TYPE_WHOLE,
            "enabled":true,
            "label":Dict.LEADERBOARD_WHOLE_ZONE
         }];
         if(this.myFriendCB.selectedIndex < 0)
         {
            this.myFriendCB.selectedIndex = LB_PEOPLE_RANGE_TYPE_FRIEND;
         }
         else
         {
            this.myFriendCB.selectedIndex = this.myFriendCB.selectedIndex;
         }
      }
      
      public function onPlayerBasicInfo(info:PlayerBasicInfoObj) : void
      {
         if(!info.available)
         {
            return;
         }
         for(var j:uint = 0; j < this.myPageList.dataProvider.length; j++)
         {
            if(this.myPageList.dataProvider[j].entityID == info.entityID)
            {
               this.myPageList.dataProvider[j].level = info.level;
               this.myPageList.dataProvider[j].prestige = info.prestige;
               this.myPageList.dataProvider[j].wargodScore = info.wargodScore;
               this.myPageList.dataProvider[j].wargodSeason = info.wargodSeason;
               break;
            }
         }
         var selfData:Object = this.mySelf.getData();
         if(selfData.entityID == info.entityID)
         {
            selfData.level = info.level;
            selfData.prestige = info.prestige;
            selfData.wargodScore = info.wargodScore;
            selfData.wargodSeason = info.wargodSeason;
            this.mySelf.setData(selfData);
            this.mySelf.isSelfMode(true);
         }
      }
      
      public function onPlayerBasicInfoComplete() : void
      {
         this.myPageList.refresh();
      }
      
      private function onValueFilterChanged(e:ParaEvent) : void
      {
         var itemData:Object = this.myValueCB.selectedData;
         this.myValueCB.label = itemData.label;
         this.myHeader.myValue.text = itemData.label;
         this.leaderBoardFilterChanged();
      }
      
      private function onFriendStateChanged(e:ParaEvent) : void
      {
         var itemData:Object = this.myFriendCB.selectedData;
         var itemLabel:String = itemData.label;
         this.myFriendCB.label = itemLabel;
         this.leaderBoardFilterChanged();
      }
      
      private function onWeekStateChanged(e:ParaEvent) : void
      {
         var itemData:Object = this.myWeekCB.selectedData;
         var itemLabel:String = itemData.label;
         this.myWeekCB.label = itemLabel;
         this.leaderBoardFilterChanged();
      }
      
      private function leaderBoardFilterChanged() : void
      {
         if(!this.mDataSet)
         {
            return;
         }
         var valueData:Object = this.myValueCB.selectedData;
         var lbName:String = this.myWeekCB.selectedIndex == LB_TIME_RANGE_TYPE_WHOLE ? valueData.lb : valueData.wlb;
         var openMode:int = this.myFriendCB.selectedIndex;
         this.requestLeaderBoard(lbName,openMode,0);
      }
      
      public function showLeaderBoard(lbObj:Object) : void
      {
         this.myValueCB.width = 180;
         this.myValueCB.singleOptionMode = true;
         this.myValueCB.addEventListener(ComboBox.EVT_CHANGE,this.onValueFilterChanged);
         this.myValueCB.dataProvider = lbObj.options;
         this.mDataSet = true;
         this.myValueCB.selectedIndex = 0;
      }
      
      private function requestLeaderBoard(lbName:String, openMode:int, page:int) : void
      {
         this.mRequestedLBName = lbName;
         var para:Object = {
            "name":lbName,
            "page":page,
            "size":PAGE_SIZE,
            "openMode":openMode,
            "sourceType":0
         };
         broadcast(BCEvent.EVT_REQUEST_LEADERBOARD,para);
         this.myDataFailHint.visible = false;
         this.switchInertPanel(true);
      }
      
      public function leaderBoardRespond(data:Object) : void
      {
         var openMode:int = 0;
         this.switchInertPanel(false);
         if(this.mRequestedLBName != "" && data.name != this.mRequestedLBName)
         {
            openMode = this.myFriendCB.selectedIndex;
            this.requestLeaderBoard(this.mRequestedLBName,openMode,0);
            return;
         }
         this.myPageList.selfEntityId = data.selfStats.entityID;
         this.myPageList.dataProvider = data.statsList;
         this.myPageList.hasPrevBtn = data.hasPrev;
         this.myPageList.hasNextBtn = data.hasNext;
         this.mCurPage = data.page;
         var selfStats:Object = data.selfStats;
         this.mySelf.setData(selfStats);
         this.mySelf.isSelfMode(true);
         var playersIdArray:Array = [];
         for(var i:uint = 0; i < data.statsList.length; i++)
         {
            playersIdArray.push(data.statsList[i].entityID);
         }
         playersIdArray.push(data.selfStats.entityID);
         this.mPlayerBasicInfoQueryUtil.queryPlayerBasicInfo(playersIdArray);
      }
      
      private function switchLeaderBoardFail(isFail:Boolean) : void
      {
         this.switchInertPanel(false);
         this.myDataFailHint.visible = isFail;
         this.myPageList.visible = !isFail;
      }
      
      public function onLeaderBoardDataResponded(cRes:Object) : void
      {
         var data:Object = cRes.data;
         this.switchLeaderBoardFail(!data.success);
         if(Boolean(data.success))
         {
            this.leaderBoardRespond(data);
         }
      }
      
      private function switchInertPanel(inert:Boolean) : void
      {
         this.myHeader.visible = !inert;
         this.mySelf.visible = !inert;
         this.myPageList.visible = !inert;
      }
      
      private function onPageSelectorClicked(whichBtn:int) : void
      {
         if(this.mRequestInProgress)
         {
            return;
         }
         var valueData:Object = this.myValueCB.selectedData;
         var lbName:String = this.myWeekCB.selectedIndex == LB_TIME_RANGE_TYPE_WHOLE ? valueData.lb : valueData.wlb;
         var openMode:int = this.myFriendCB.selectedIndex;
         var page:int = 0;
         if(whichBtn == PageListSelector.NEXT_BTN_INDEX)
         {
            page = this.mCurPage + 1;
         }
         else
         {
            page = this.mCurPage - 1;
         }
         this.requestLeaderBoard(lbName,openMode,page);
      }
      
      private function onShowHamburgerButton(button:SocialHamburgerButton) : void
      {
         var globalPoint:Point;
         var localPoint:Point;
         var onStageClicked:Function = null;
         onStageClicked = function(evt:MouseEvent):void
         {
            var hitObj:Object = evt.target;
            if(!hitObj.parent || !(hitObj.parent is SocialHamburgerButton))
            {
               removeChild(mDropDownMenu);
               stage.removeEventListener(MouseEvent.CLICK,onStageClicked);
            }
         };
         var optionMenu:Vector.<RightClickMenuItemObj> = getDP(DataID.RIGHT_CLICK_MENU,[RightClickMenuType.DETAIL_ONLY,button.getData()]);
         this.mDropDownMenu.setOptionMenu(optionMenu,button.getData());
         addChild(this.mDropDownMenu);
         globalPoint = button.localToGlobal(new Point(button.width,button.height));
         localPoint = this.globalToLocal(globalPoint);
         this.mDropDownMenu.visible = true;
         this.mDropDownMenu.x = localPoint.x - this.mDropDownMenu.width + 10;
         this.mDropDownMenu.y = localPoint.y + 10;
         if(globalPoint.y + this.mDropDownMenu.height > 1080)
         {
            this.mDropDownMenu.y = localPoint.y - this.mDropDownMenu.height;
         }
         stage.addEventListener(MouseEvent.CLICK,onStageClicked);
      }
   }
}

