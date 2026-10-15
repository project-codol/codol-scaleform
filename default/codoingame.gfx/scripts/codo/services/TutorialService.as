package codo.services
{
   import codo.base.ServiceBase;
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.component.tutorial.UITourToolTip;
   import codo.constants.DataID;
   import codo.constants.PageID;
   import codo.constants.ServiceID;
   import codo.constants.UITutorialFlags;
   import codo.constants.table.UINotifications;
   import codo.cpp.UiCppOnboarding;
   import codo.manager.DataManager;
   import codo.objects.ClanGlobalConfig;
   import codo.objects.GamemodeTutorialContentObj;
   import codo.objects.ProductObj;
   import codo.objects.uitour.UITourToolTipObj;
   import codo.utils.InventoryUtil;
   import codo.utils.ScaleformUtil;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   
   public class TutorialService extends ServiceBase
   {
      
      private static var _instance:TutorialService;
      
      private static const TUTORIAL_DATA_PATH:String = "mp/gamemodeTutorialContent.csv";
      
      public static const LOBBY_TIP_ID:String = "lobby_tip_id";
      
      private var mUITourToolTipDict:Dictionary;
      
      private var mDisabledTips:Dictionary = new Dictionary();
      
      private var mPendingInventoryTutorial:UITourToolTipObj;
      
      private var mClanTutorialWatcher:Timer;
      
      public function TutorialService()
      {
         super(ServiceID.TUTORIAL);
         this.watchClanTutorial();
      }
      
      public static function getInstance() : TutorialService
      {
         if(TutorialService._instance == null)
         {
            TutorialService._instance = new TutorialService();
         }
         return TutorialService._instance;
      }
      
      public function enableToolTip(onboardNotif:String, enabled:Boolean) : void
      {
         this.mDisabledTips[onboardNotif] = !enabled;
      }
      
      public function getUITourContentByPageID(id:String, tips:Vector.<UITourToolTipObj>) : void
      {
         var i:uint = 0;
         var notif:String = null;
         if(this.mUITourToolTipDict == null)
         {
            this.setUITourToolTipContent();
         }
         var src:Vector.<UITourToolTipObj> = this.mUITourToolTipDict[id];
         if(src != null)
         {
            for(i = 0; i < src.length; i++)
            {
               notif = src[i].onboardNotif;
               if(!this.mDisabledTips[notif])
               {
                  tips.push(src[i]);
               }
            }
         }
      }
      
      public function discardToolTip(tip:UITourToolTipObj) : void
      {
         var tips:Vector.<UITourToolTipObj> = this.mUITourToolTipDict[tip.pageID];
         for(var i:uint = 0; i < tips.length; i++)
         {
            if(tips[i] == tip)
            {
               tip.acknowledged = true;
               tips.splice(i,1);
               return;
            }
         }
      }
      
      public function initTutorialFlagByPageID(id:String) : uint
      {
         if(id == PageID.PERSISTENT)
         {
            return UITutorialFlags.NULL;
         }
         UITutorialFlags.advanceOnboardingStep();
         var onboardStep:uint = UITutorialFlags.getOnboardingStep();
         if(onboardStep != UITutorialFlags.NULL)
         {
            return onboardStep;
         }
         if(id == PageID.HOME)
         {
            if(Boolean(CFunctionContainer.WL_ResetClearedLoadoutFlag()))
            {
               UITutorialFlags.setNextPick10Step(UITutorialFlags.UI_TOUR_LANDING_PICK10_INTRO_VIEWED);
            }
         }
         UITutorialFlags.advancePick10Step();
         return UITutorialFlags.getPick10Step();
      }
      
      public function getPendingInventoryTutorial() : UITourToolTipObj
      {
         return this.mPendingInventoryTutorial;
      }
      
      public function setPendingInventoryTutorial(tip:UITourToolTipObj) : void
      {
         this.mPendingInventoryTutorial = tip;
      }
      
      private function setUITourToolTipContent() : void
      {
         var tip:UITourToolTipObj = null;
         var inOnboarding:Boolean = false;
         var pageTips:Vector.<UITourToolTipObj> = null;
         var insertIdx:int = 0;
         this.mUITourToolTipDict = new Dictionary(true);
         var killswitchedTips:Object = CFunctionCommonContainer.GetDisabledOnboardHelp();
         if(Boolean(killswitchedTips["all"]))
         {
            return;
         }
         var supplyDrops:UITourToolTipObj = new UITourToolTipObj(PageID.PERSISTENT,UITutorialFlags.NULL,"@UI_TUTORIAL_UI_TOUR_TOOL_TIP_SUPPLY_DROPS_TITLE","@UI_TUTORIAL_UI_TOUR_TOOL_TIP_SUPPLY_DROPS_DESC",new Point(1300,-10),false,UINotifications.ONBOARD_HELP_SUPPLY_DROPS,PageID.SUPPLY_DROP,UiCppOnboarding.FEATURE_SUPPLY_DROPS);
         var goToWpn:UITourToolTipObj = new UITourToolTipObj(PageID.FSG_LOADOUT,UITutorialFlags.NULL,"@UI_TUTORIAL_UI_TOUR_TOOL_TIP_PRIMARY_WEAPON_TITLE","@UI_TUTORIAL_UI_TOUR_TOOL_TIP_PRIMARY_WEAPON_DESC",new Point(820,415),true,UINotifications.ONBOARD_HELP_LOADOUT_WEAPON,null,UiCppOnboarding.FEATURE_INVENTORY_MARKET,UITourToolTip.STYLE_0_BTN);
         var equipWpn:UITourToolTipObj = new UITourToolTipObj(PageID.LOADOUT_SELECTION,UITutorialFlags.UI_TOUR_INVENTORY_SELECT_WEAPON,"@UI_TUTORIAL_UI_TOUR_TOOL_TIP_WEAPON_FILTERS_TITLE","@UI_TUTORIAL_UI_TOUR_TOOL_TIP_WEAPON_FILTERS_DESC",new Point(361,318),true,UINotifications.ONBOARD_HELP_SELECT_WEAPON,null,UiCppOnboarding.FEATURE_INVENTORY_MARKET,UITourToolTip.STYLE_1_BTN);
         var goToAttach:UITourToolTipObj = new UITourToolTipObj(PageID.FSG_LOADOUT,UITutorialFlags.NULL,"@UI_TUTORIAL_UI_TOUR_TOOL_TIP_ATTACHMENT_TITLE","@UI_TUTORIAL_UI_TOUR_TOOL_TIP_ATTACHMENT_DESC",new Point(935,285),true,UINotifications.ONBOARD_HELP_LOADOUT_ATTACHMENT,null,UiCppOnboarding.FEATURE_INVENTORY_MARKET,UITourToolTip.STYLE_0_BTN);
         var equipAttach:UITourToolTipObj = new UITourToolTipObj(PageID.MARKET_ITEM_DETAILS,UITutorialFlags.UI_TOUR_INVENTORY_SELECT_ATTACHMENT,"@UI_TUTORIAL_UI_TOUR_TOOL_TIP_MARKET_DETAILS_STATS_DESC","@UI_TUTORIAL_UI_TOUR_TOOL_TIP_MARKET_DETAILS_STATS_DESC",new Point(901,462),true,UINotifications.ONBOARD_HELP_SELECT_ATTACHMENT,null,UiCppOnboarding.FEATURE_INVENTORY_MARKET,UITourToolTip.STYLE_1_BTN,UITourToolTip.ARROW_DOWN);
         var goToAttach2:UITourToolTipObj = new UITourToolTipObj(PageID.FSG_LOADOUT,UITutorialFlags.NULL,"@UI_TUTORIAL_UI_TOUR_TOOL_TIP_ATTACH2_TITLE","@UI_TUTORIAL_UI_TOUR_TOOL_TIP_ATTACH2_DESC",new Point(935,388),true,UINotifications.ONBOARD_HELP_LOADOUT_ATTACHMENT_2,null,UiCppOnboarding.FEATURE_INVENTORY_MARKET,UITourToolTip.STYLE_0_BTN);
         var equipAttach2:UITourToolTipObj = new UITourToolTipObj(PageID.MARKET_ITEM_DETAILS,UITutorialFlags.NULL,"@UI_TUTORIAL_UI_TOUR_TOOL_TIP_SELECT_ATTACHMENT_TITLE","@UI_TUTORIAL_UI_TOUR_TOOL_TIP_SELECT_ATTACHMENT_DESC",new Point(600,406),true,UINotifications.ONBOARD_HELP_SELECT_ATTACHMENT_2,null,UiCppOnboarding.FEATURE_INVENTORY_MARKET,UITourToolTip.STYLE_0_BTN);
         var requis:UITourToolTipObj = new UITourToolTipObj(PageID.FSG_LOADOUT,UITutorialFlags.NULL,"@UI_TUTORIAL_UI_TOUR_TOOL_TIP_REQUIS_TITLE","@UI_TUTORIAL_UI_TOUR_TOOL_TIP_REQUIS_DESC",new Point(492,58),false,UINotifications.ONBOARD_HELP_REQUISITIONS,PageID.FSG_LOADOUT,UiCppOnboarding.FEATURE_REQUISITIONS,UITourToolTip.STYLE_1_BTN);
         var streaks:UITourToolTipObj = new UITourToolTipObj(PageID.FSG_LOADOUT,UITutorialFlags.NULL,"@UI_TUTORIAL_UI_TOUR_TOOL_TIP_STREAKS_TITLE","@UI_TUTORIAL_UI_TOUR_TOOL_TIP_STREAKS_DESC",new Point(410,58),false,UINotifications.ONBOARD_HELP_STREAKS,PageID.FSG_LOADOUT,UiCppOnboarding.FEATURE_STREAKS,UITourToolTip.STYLE_1_BTN);
         var perks:UITourToolTipObj = new UITourToolTipObj(PageID.FSG_LOADOUT,UITutorialFlags.NULL,"@UI_TUTORIAL_UI_TOUR_TOOL_TIP_EDIT_PERKS_TITLE","@UI_TUTORIAL_UI_TOUR_TOOL_TIP_EDIT_PERKS_DESC",new Point(1270,340),false,UINotifications.ONBOARD_HELP_EDIT_PERKS,null,UiCppOnboarding.FEATURE_PERKS,UITourToolTip.STYLE_1_BTN);
         var wildcards:UITourToolTipObj = new UITourToolTipObj(PageID.FSG_LOADOUT,UITutorialFlags.NULL,"@UI_TUTORIAL_UI_TOUR_TOOL_TIP_WILDCARDS_TITLE","@UI_TUTORIAL_UI_TOUR_TOOL_TIP_WILDCARDS_DESC",new Point(943,460),false,UINotifications.ONBOARD_HELP_WILDCARDS,null,UiCppOnboarding.FEATURE_WILDCARDS,UITourToolTip.STYLE_1_BTN,UITourToolTip.ARROW_DOWN);
         var gear:UITourToolTipObj = new UITourToolTipObj(PageID.FSG_LOADOUT,UITutorialFlags.NULL,"@UI_TUTORIAL_UI_TOUR_TOOL_TIP_GEAR_TITLE","@UI_TUTORIAL_UI_TOUR_TOOL_TIP_GEAR_DESC",new Point(295,58),false,UINotifications.ONBOARD_HELP_GEAR,PageID.FSG_LOADOUT,UiCppOnboarding.FEATURE_GEAR,UITourToolTip.STYLE_1_BTN);
         var inventory:UITourToolTipObj = new UITourToolTipObj(PageID.PERSISTENT,UITutorialFlags.NULL,"@UI_TUTORIAL_UI_TOUR_TOOL_TIP_INVENTORY_TITLE","@UI_TUTORIAL_UI_TOUR_TOOL_TIP_INVENTORY_DESC",new Point(855,0),true,UINotifications.ONBOARD_HELP_INVENTORY,PageID.FSG_LOADOUT,UiCppOnboarding.FEATURE_INVENTORY_MARKET);
         var lobbyInventory:UITourToolTipObj = new UITourToolTipObj(LOBBY_TIP_ID,UITutorialFlags.NULL,"@UI_TUTORIAL_UI_TOUR_TOOL_TIP_LOBBY_INVENTORY_TITLE","@UI_TUTORIAL_UI_TOUR_TOOL_TIP_LOBBY_INVENTORY_DESC",new Point(570,0),true,UINotifications.ONBOARD_HELP_INVENTORY,PageID.FSG_LOADOUT,UiCppOnboarding.FEATURE_INVENTORY_MARKET);
         var loadout:UITourToolTipObj = new UITourToolTipObj(PageID.FSG_LOADOUT,UITutorialFlags.UI_TOUR_INVENTORY,"@UI_TUTORIAL_UI_TOUR_TOOL_TIP_INVENTORY_CHARACTER_LOADOUTS_TITLE","@UI_TUTORIAL_UI_TOUR_TOOL_TIP_INVENTORY_CHARACTER_LOADOUTS_DESC",new Point(370,287),true,UINotifications.ONBOARD_HELP_EDIT_LOADOUT,null,UiCppOnboarding.FEATURE_INVENTORY_MARKET);
         var market:UITourToolTipObj = new UITourToolTipObj(PageID.PERSISTENT,UITutorialFlags.UI_TOUR_MARKETPLACE,"@UI_TUTORIAL_UI_TOUR_TOOL_TIP_MARKETPLACE_TITLE","@UI_TUTORIAL_UI_TOUR_TOOL_TIP_MARKETPLACE_DESC",new Point(765,0),true,UINotifications.ONBOARD_HELP_MARKETPLACE,PageID.MARKET,UiCppOnboarding.FEATURE_INVENTORY_MARKET);
         var loginRewards:UITourToolTipObj = new UITourToolTipObj(PageID.PERSISTENT,UITutorialFlags.UI_TOUR_LOGIN_REWARDS,"@UI_TUTORIAL_UI_TOUR_TOOL_TIP_LOGIN_REWARDS_TITLE","@UI_TUTORIAL_UI_TOUR_TOOL_TIP_LOGIN_REWARDS_DESC",new Point(1200,-10),false,UINotifications.ONBOARD_HELP_LOGIN_REWARDS,PageID.MOTD_CHECKIN_REWARDS);
         var career:UITourToolTipObj = new UITourToolTipObj(PageID.PERSISTENT,UITutorialFlags.UI_TOUR_CAREER,"@UI_TUTORIAL_UI_TOUR_TOOL_TIP_CAREER_TITLE","@UI_TUTORIAL_UI_TOUR_TOOL_TIP_CAREER_DESC",new Point(680,0),true,UINotifications.ONBOARD_HELP_CAREER,PageID.CAREER_BATTLE_EXPERIENCE);
         var matchSelect:UITourToolTipObj = new UITourToolTipObj(PageID.PERSISTENT,UITutorialFlags.UI_TOUR_MATCH_SELECT,"@UI_TUTORIAL_UI_TOUR_TOOL_TIP_MATCH_SELECT_TITLE","@UI_TUTORIAL_UI_TOUR_TOOL_TIP_MATCH_SELECT_DESC",new Point(590,0),true,UINotifications.ONBOARD_HELP_PLAY,PageID.MATCH_SELECT);
         var clan:UITourToolTipObj = new UITourToolTipObj(PageID.PERSISTENT,UITutorialFlags.UI_TOUR_CLANS,"@UI_TUTORIAL_UI_TOUR_TOOL_TIP_CLANS_TITLE","@UI_TUTORIAL_UI_TOUR_TOOL_TIP_CLANS_DESC",new Point(70,695),true,UINotifications.ONBOARD_HELP_CLANS,PageID.CLAN,UiCppOnboarding.FEATURE_CLANS);
         var leaderboard:UITourToolTipObj = new UITourToolTipObj(PageID.PERSISTENT,UITutorialFlags.UI_TOUR_LEADERBOARD,"@UI_TUTORIAL_UI_TOUR_TOOL_TIP_LEADERBOARD_TITLE","@UI_TUTORIAL_UI_TOUR_TOOL_TIP_LEADERBOARD_DESC",new Point(70,584),true,UINotifications.ONBOARD_HELP_LEADERBOARD,PageID.LEADERBOARD,UiCppOnboarding.FEATURE_LEADERBOARDS);
         var wargod:UITourToolTipObj = new UITourToolTipObj(PageID.PERSISTENT,UITutorialFlags.UI_TOUR_WARGOD,"@UI_TUTORIAL_UI_TOUR_TOOL_TIP_WARGOD_TITLE",null,null,false,UINotifications.ONBOARD_HELP_WARGOD,PageID.MATCH_SELECT);
         var friends:UITourToolTipObj = new UITourToolTipObj(PageID.PERSISTENT,UITutorialFlags.UI_TOUR_FRIENDS,"@UI_TUTORIAL_UI_TOUR_TOOL_TIP_FRIENDS_TITLE","@UI_TUTORIAL_UI_TOUR_TOOL_TIP_FRIENDS_DESC",new Point(70,639),true,UINotifications.ONBOARD_HELP_FRIENDS,PageID.FRIEND,UiCppOnboarding.FEATURE_LOADOUT_2);
         var party:UITourToolTipObj = new UITourToolTipObj(PageID.PERSISTENT,UITutorialFlags.UI_TOUR_PARTY,"@UI_TUTORIAL_UI_TOUR_TOOL_TIP_PARTY_TITLE","@UI_TUTORIAL_UI_TOUR_TOOL_TIP_PARTY_DESC",new Point(70,751),true,UINotifications.ONBOARD_HELP_PARTY,PageID.PARTY,UiCppOnboarding.FEATURE_LOADOUT_2);
         requis.destinationTab = InventoryUtil.REQUISITION_TAB;
         streaks.destinationTab = InventoryUtil.SCORESTREAKS_TAB;
         gear.destinationTab = InventoryUtil.GEAR_TAB;
         inventory.destinationTab = InventoryUtil.HOME_TAB;
         lobbyInventory.destinationTab = InventoryUtil.HOME_TAB;
         lobbyInventory.linkedTip = inventory;
         var tips:Vector.<UITourToolTipObj> = new <UITourToolTipObj>[wargod,leaderboard,clan,supplyDrops,goToWpn,equipWpn,goToAttach,equipAttach,goToAttach2,equipAttach2,loadout,wildcards,perks,requis,streaks,gear,loginRewards,career,inventory,lobbyInventory,market,friends,party,matchSelect];
         var isNewPlayer:Boolean = CFunctionCommonContainer.GetPlayerOnboardType() != UiCppOnboarding.TYPE_PRE_MR5;
         for(var i:int = 0; i < tips.length; i++)
         {
            tip = tips[i];
            if(tip.featureIsUnlocked() && !killswitchedTips[tip.onboardNotif])
            {
               tip.notified = CFunctionCommonContainer.AS_IsNotified(tip.onboardNotif) as Boolean;
               inOnboarding = isNewPlayer && !tip.notified;
               if(!tip.onboardOnly || inOnboarding)
               {
                  if(this.mUITourToolTipDict[tip.pageID] == undefined)
                  {
                     this.mUITourToolTipDict[tip.pageID] = new Vector.<UITourToolTipObj>(0);
                  }
                  pageTips = this.mUITourToolTipDict[tip.pageID];
                  insertIdx = int(pageTips.length);
                  if(!tip.notified)
                  {
                     while(insertIdx > 0 && pageTips[insertIdx - 1].notified)
                     {
                        insertIdx--;
                     }
                  }
                  pageTips.splice(insertIdx,0,tip);
               }
            }
         }
      }
      
      private function watchClanTutorial() : void
      {
         this.enableToolTip(UINotifications.ONBOARD_HELP_CLANS,false);
         this.mClanTutorialWatcher = new Timer(1000);
         this.mClanTutorialWatcher.addEventListener(TimerEvent.TIMER,this.onClanTutorialWatcherKicked);
         this.mClanTutorialWatcher.start();
      }
      
      private function onClanTutorialWatcherKicked(event:TimerEvent) : void
      {
         if(!CFunctionContainer.HaveClanInfo() || !MarketService.getInstance().isGameDataReady() || !CFunctionCommonContainer.OnboardIntroDone())
         {
            return;
         }
         this.mClanTutorialWatcher.stop();
         this.mClanTutorialWatcher.removeEventListener(TimerEvent.TIMER,this.onClanTutorialWatcherKicked);
         this.enableToolTip(UINotifications.ONBOARD_HELP_CLANS,true);
      }
      
      public function getClanOnboardingReward() : ProductObj
      {
         var CLAN_ITEM_ID:int = int((DataManager.getInstance().getDP(DataID.CLAN_GLOBAL_CONFIG) as ClanGlobalConfig).joinRewardItemId);
         var CLAN_ITEM_DURATION:int = int((DataManager.getInstance().getDP(DataID.CLAN_GLOBAL_CONFIG) as ClanGlobalConfig).joinRewardItemDuration);
         var prod:ProductObj = CFunctionCommonContainer.GetItemInfo(CLAN_ITEM_ID);
         prod.isBought = true;
         prod.remainSecond = 24 * 3600 * CLAN_ITEM_DURATION;
         return prod;
      }
      
      public function getContentByGameType(type:String) : Vector.<GamemodeTutorialContentObj>
      {
         var modeID:String = null;
         var dataObj:GamemodeTutorialContentObj = null;
         if(!ScaleformUtil.isScaleform)
         {
            return this.fakeData;
         }
         var COL_ID:int = 0;
         var COL_TITLE:int = 1;
         var COL_DESCRIPTION:int = 2;
         var COL_IMAGEPATH:int = 3;
         var COL_VIDEOPATH:int = 4;
         var COL_ISACTIVE:int = 5;
         var tableRows:int = CFunctionCommonContainer.StringTableRowCount(TUTORIAL_DATA_PATH) as int;
         var data:Vector.<GamemodeTutorialContentObj> = new Vector.<GamemodeTutorialContentObj>(0);
         var i:int = 0;
         for(var isActive:Boolean = true; i < tableRows; )
         {
            modeID = CFunctionCommonContainer.StringTableLookupByRow(TUTORIAL_DATA_PATH,i,COL_ID);
            if(modeID == type)
            {
               dataObj = new GamemodeTutorialContentObj();
               isActive = Number(CFunctionCommonContainer.StringTableLookupByRow(TUTORIAL_DATA_PATH,i,COL_ISACTIVE)) == 1 ? true : false;
               if(isActive)
               {
                  dataObj = new GamemodeTutorialContentObj(modeID,"@".concat(CFunctionCommonContainer.StringTableLookupByRow(TUTORIAL_DATA_PATH,i,COL_TITLE)),"@".concat(CFunctionCommonContainer.StringTableLookupByRow(TUTORIAL_DATA_PATH,i,COL_DESCRIPTION)),CFunctionCommonContainer.StringTableLookupByRow(TUTORIAL_DATA_PATH,i,COL_IMAGEPATH),CFunctionCommonContainer.StringTableLookupByRow(TUTORIAL_DATA_PATH,i,COL_VIDEOPATH));
                  data.push(dataObj);
               }
            }
            i++;
         }
         return data;
      }
      
      public function getTutorialPopupModes() : Vector.<String>
      {
         return new <String>["sdp","zchamp","hostage","ph","dmz","zhunt"];
      }
      
      private function get fakeData() : Vector.<GamemodeTutorialContentObj>
      {
         var dataObj:GamemodeTutorialContentObj = null;
         var i:uint = 0;
         var len:uint = 19;
         for(var data:Vector.<GamemodeTutorialContentObj> = new Vector.<GamemodeTutorialContentObj>(0); i < len; )
         {
            dataObj = new GamemodeTutorialContentObj("TITLE " + i,"SUBTITLE " + i,"test.tga","");
            if(i == 0)
            {
               dataObj.videoPath = "test";
            }
            data[i] = dataObj;
            i++;
         }
         return data;
      }
   }
}

