package codo.views.playerDetailInfo_parts
{
   import codo.base.BaseSubElement;
   import codo.common.CFunctionCommonContainer;
   import codo.component.CloseButton;
   import codo.component.ContentContainer;
   import codo.component.PlayerCard;
   import codo.component.factory.ButtonFactory;
   import codo.component.navigation.NavigationMenu;
   import codo.component.object.NavigationObj;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.localization.Dict;
   import codo.utils.LocalizeUtil;
   import fsg.util.FsgUtil;
   
   public class PlayerDetailInfoContent extends BaseSubElement
   {
      
      public static const TAB_IDX_OVERALL:int = 0;
      
      public static const TAB_IDX_RECENT:int = 1;
      
      public var myCloseBtn:CloseButton;
      
      public var myContentContainer:ContentContainer;
      
      public var myPlayerCard:PlayerCard;
      
      public var myPlayerOverallInfo:PlayerOverallInfo;
      
      public var myPlayerRecentInfo:PlayerRecentInfo;
      
      public var myNavigationMenu:NavigationMenu;
      
      private var mCurrentTabIndex:int = -1;
      
      public function PlayerDetailInfoContent()
      {
         super();
         this.initStage();
      }
      
      public function setData(data:*) : void
      {
         var isFullVersion:Boolean = Boolean(getDP(DataID.IS_CLAN_OWNER)) && Boolean(getDP(DataID.IS_CLAN_MEMBER,[data])) || Boolean(getDP(DataID.IS_FRIEND,[data])) || Boolean(data.isMe);
         this.myPlayerOverallInfo.IsFullVersion = isFullVersion;
         this.myPlayerOverallInfo.setData(data);
         this.myPlayerRecentInfo.IsFullVersion = isFullVersion;
         this.myPlayerRecentInfo.setData(data);
         var playerCardData:Object = data.playerCard;
         this.myPlayerCard.setName(getDP(DataID.REQUESTED_DETAIL_PLAYER_NAME));
         this.myPlayerCard.setRank(CFunctionCommonContainer.GetDisplayLevel(data.rank));
         this.myPlayerCard.setPrestige(data.prestige > 0 ? data.prestige : "");
         this.myPlayerCard.setPrestigeIcon(FsgUtil.getPrestigeIcon(data.prestige));
         this.myPlayerCard.setTitle(LocalizeUtil.localize("@" + playerCardData.cardTitle.name));
         this.myPlayerCard.setBackground(playerCardData.background.imageURL);
         this.myPlayerCard.setEmblem(playerCardData.cardIcon.imageURL);
         this.myPlayerCard.setNameplate(playerCardData.cardNameplate.color);
         this.myPlayerCard.setFrame(playerCardData.cardFrame.imageURL);
      }
      
      public function setPlayerBasicInfoData(data:*) : void
      {
         this.myPlayerCard.setClanName(data.clanName);
      }
      
      private function initStage() : void
      {
         var data:Object = null;
         this.myContentContainer.width = 890;
         this.myContentContainer.height = 780;
         this.myContentContainer.showText = true;
         this.myContentContainer.showAccents = true;
         var tabs:Array = new Array();
         for(var i:int = 0; i < 4; i++)
         {
            data = {
               "id":i,
               "label":String(i)
            };
            tabs.push(data);
         }
         var tabButtons:Vector.<NavigationObj> = new <NavigationObj>[new NavigationObj(TAB_IDX_OVERALL,Dict.PLAYER_INFO_NAVIGATION_OVERALL),new NavigationObj(TAB_IDX_RECENT,Dict.PLAYER_INFO_NAVIGATION_RECENT)];
         this.myNavigationMenu.navButtonRenderMethod = ButtonFactory.BUILD_SECONDARY_MENU_BUTTON;
         this.myNavigationMenu.setData(tabButtons);
         this.myNavigationMenu.listItemClickCallback = this.onNavigationMenuClick;
         this.myNavigationMenu.showMenu();
         this.myNavigationMenu.visible = true;
         this.myCloseBtn.registerClickEvent(this.onCloseBtnClicked);
         this.resetView();
      }
      
      private function resetView() : void
      {
         this.myPlayerRecentInfo.visible = false;
         this.myPlayerOverallInfo.visible = true;
         this.myPlayerCard.setClanName("");
      }
      
      override public function active() : void
      {
         super.active();
         this.myPlayerOverallInfo.deactive();
         this.myPlayerRecentInfo.deactive();
         this.myNavigationMenu.selectedIndex = 0;
         this.setPlayerInfoTab(0);
      }
      
      override public function deactive() : void
      {
         super.deactive();
         this.resetView();
      }
      
      private function onCloseBtnClicked() : void
      {
         broadcast(BCEvent.EVT_CLOSE_DETAIL);
      }
      
      private function onNavigationMenuClick(btnData:NavigationObj) : void
      {
         this.setPlayerInfoTab(btnData.index);
      }
      
      private function setPlayerInfoTab(idx:int) : void
      {
         var currentTab:BaseSubElement = this.getTab(this.mCurrentTabIndex);
         if(currentTab != null)
         {
            currentTab.deactive();
         }
         this.getTab(idx).active();
         this.mCurrentTabIndex = idx;
      }
      
      private function getTab(idx:int) : BaseSubElement
      {
         var tab:BaseSubElement = null;
         switch(idx)
         {
            case TAB_IDX_OVERALL:
               tab = this.myPlayerOverallInfo;
               break;
            case TAB_IDX_RECENT:
               tab = this.myPlayerRecentInfo;
         }
         return tab;
      }
   }
}

