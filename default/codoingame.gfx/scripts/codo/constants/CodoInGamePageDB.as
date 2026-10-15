package codo.constants
{
   import codo.common.CFunctionCommonContainer;
   import codo.gvoice.gVoiceChatBarView;
   import codo.gvoice.gVoiceSettingsView;
   import codo.helpmenu.fsgHelpMenuTD;
   import codo.helpmenu.fsgHelpMenuZhuntView;
   import codo.hud.hudZHuntBossResultPopup;
   import codo.hud.hudZHuntShoppingPopup;
   import codo.hud.popups.hudVIPSelectVIPCharacterPopup;
   import codo.hud.popups.hudVIPVoteInfoPopup;
   import codo.hud.popups.hudVotePopup;
   import codo.hud.shared.hudQuickChatView;
   import codo.hud.td.hudTdLoadoutView;
   import codo.objects.CodoPageLayerObj;
   import codo.objects.CodoPageObj;
   import codo.objects.CodoViewObj;
   import codo.pausemenu.pauseMenuHostageView;
   import codo.pausemenu.pauseMenuSDPlusView;
   import codo.pausemenu.pauseMenuSpyView;
   import codo.pausemenu.pauseMenuZombieSurvivalView;
   import codo.pausemenu.spy.pauseMenuDMZView;
   import codo.pausemenu.td.hudTdPauseMenuView;
   import codo.pausemenu.zhunt.pauseMenuZHuntView;
   import codo.services.InGameService;
   import codo.shared.hud.hudDMZTop3PlayersView;
   import codo.shared.hud.popup.hudSplashPopup;
   import codo.shared.hudSpyWantedPopup;
   import codo.utils.AsymPvpUtil;
   import codo.utils.ClashPvpUtil;
   import codo.views.dmz.hudDMZLoadoutView;
   import codo.views.hud.HUDTopView;
   import codo.views.hud.HUDView;
   import fsg.pausemenu.fsgPauseMenuView;
   import fsg.pausemenu.pauseMenuAsymView;
   import fsg.pausemenu.pauseMenuClashView;
   import fsg.popups.fsgQuitGameWarningPopupView;
   import hud.popups.td.hudTdInventoryView;
   
   public class CodoInGamePageDB
   {
      
      public static const TAG_PAGE_LAYER:String = "instance_pageLayer_";
      
      public static const PAGE_LAYER_MAIN:CodoPageLayerObj = new CodoPageLayerObj({
         "depth":1,
         "name":TAG_PAGE_LAYER + "in_game"
      });
      
      public static const PAGE_LAYER_RESPAWN:CodoPageLayerObj = new CodoPageLayerObj({
         "depth":2,
         "name":TAG_PAGE_LAYER + "respawn"
      });
      
      public static const PAGE_LAYER_COOP_EOG:CodoPageLayerObj = new CodoPageLayerObj({
         "depth":3,
         "name":TAG_PAGE_LAYER + "coop_eog"
      });
      
      public static const PAGE_LAYER_PLAYER_CARD:CodoPageLayerObj = new CodoPageLayerObj({
         "depth":4,
         "name":TAG_PAGE_LAYER + "playercard"
      });
      
      public static const PAGE_LAYER_HUD:CodoPageLayerObj = new CodoPageLayerObj({
         "depth":5,
         "name":TAG_PAGE_LAYER + "hud"
      });
      
      public static const PAGE_LAYER_SUMMARY:CodoPageLayerObj = new CodoPageLayerObj({
         "depth":6,
         "name":TAG_PAGE_LAYER + "summary"
      });
      
      public static const PAGE_LAYER_CHATTING:CodoPageLayerObj = new CodoPageLayerObj({
         "depth":7,
         "name":TAG_PAGE_LAYER + "chatting"
      });
      
      public static const PAGE_LAYER_LOADOUT:CodoPageLayerObj = new CodoPageLayerObj({
         "depth":8,
         "name":TAG_PAGE_LAYER + "loadout"
      });
      
      public static const PAGE_LAYER_QUICKCHAT:CodoPageLayerObj = new CodoPageLayerObj({
         "depth":9,
         "name":TAG_PAGE_LAYER + "quick_chat"
      });
      
      public static const PAGE_LAYER_KICK:CodoPageLayerObj = new CodoPageLayerObj({
         "depth":10,
         "name":TAG_PAGE_LAYER + "kick"
      });
      
      public static const PAGE_LAYER_SCOREBOARD:CodoPageLayerObj = new CodoPageLayerObj({
         "depth":11,
         "name":TAG_PAGE_LAYER + "scoreboard"
      });
      
      public static const PAGE_LAYER_SPLASH:CodoPageLayerObj = new CodoPageLayerObj({
         "depth":12,
         "name":TAG_PAGE_LAYER + "hud_splash"
      });
      
      public static const PAGE_LAYER_HUD_POPUP:CodoPageLayerObj = new CodoPageLayerObj({
         "depth":13,
         "name":TAG_PAGE_LAYER + "hud_popup"
      });
      
      public static const PAGE_LAYER_TOP_HUD:CodoPageLayerObj = new CodoPageLayerObj({
         "depth":14,
         "name":TAG_PAGE_LAYER + "top_hud"
      });
      
      public static const PAGE_LAYER_TOP_SPLASH:CodoPageLayerObj = new CodoPageLayerObj({
         "depth":15,
         "name":TAG_PAGE_LAYER + "hud_top_splash"
      });
      
      public static const PAGE_LAYER_GVOICE_CHAT_PANEL:CodoPageLayerObj = new CodoPageLayerObj({
         "depth":16,
         "name":TAG_PAGE_LAYER + "gvoice_chat_panel"
      });
      
      public static const PAGE_LAYER_PAUSE:CodoPageLayerObj = new CodoPageLayerObj({
         "depth":17,
         "name":TAG_PAGE_LAYER + "pause"
      });
      
      public static const PAGE_LAYER_GVOICE_SETTINGS:CodoPageLayerObj = new CodoPageLayerObj({
         "depth":18,
         "name":TAG_PAGE_LAYER + "gvoice_settings"
      });
      
      public static const PAGE_LAYER_HELP:CodoPageLayerObj = new CodoPageLayerObj({
         "depth":19,
         "name":TAG_PAGE_LAYER + "help"
      });
      
      public static const PAGE_LAYER_POPUP:CodoPageLayerObj = new CodoPageLayerObj({
         "depth":20,
         "name":TAG_PAGE_LAYER + "popup"
      });
      
      public static const PAGE_LAYER_NOTIFICATION:CodoPageLayerObj = new CodoPageLayerObj({
         "depth":99,
         "name":TAG_PAGE_LAYER + "notification"
      });
      
      public static const PAGE_LAYER_SERVER:CodoPageLayerObj = new CodoPageLayerObj({
         "depth":100,
         "name":TAG_PAGE_LAYER + "server"
      });
      
      public static const VIEW_CHATTING:CodoViewObj = new CodoViewObj({"src":hudChattingView});
      
      public static const VIEW_SCOREBOARD:CodoViewObj = new CodoViewObj({"src":fsgHudScoreboardView});
      
      public static const VIEW_SCOREBOARD_CYBORGS:CodoViewObj = new CodoViewObj({"src":fsgHudCyborgsView});
      
      public static const VIEW_CYBORG_TOKENS_FSG:CodoViewObj = new CodoViewObj({"src":fsgTokenUiView});
      
      public static const VIEW_PURCHASE_ENABLED_TOKEN_POPUP:CodoViewObj = new CodoViewObj({"src":inGamePurchaseTokenPopupView});
      
      public static const VIEW_MARKET_PURCHASE_ADD_TO_CART:CodoViewObj = new CodoViewObj({"src":inGamePurchaseConfirmView});
      
      public static const VIEW_SYSTEMNOTIFY_FSG:CodoViewObj = new CodoViewObj({"src":inGameSystemPopupView});
      
      public static const VIEW_ZHUNT_PURCHASE_ENABLED_TOKEN_POPUP:CodoViewObj = new CodoViewObj({"src":inGameZHuntPurchaseTokenPopupView});
      
      public static const VIEW_PAUSE:CodoViewObj = new CodoViewObj({"src":fsgPauseMenuView});
      
      public static const VIEW_PAUSE_ASYM:CodoViewObj = new CodoViewObj({"src":pauseMenuAsymView});
      
      public static const VIEW_PAUSE_CLASH:CodoViewObj = new CodoViewObj({"src":pauseMenuClashView});
      
      public static const VIEW_PAUSE_SDPLUS:CodoViewObj = new CodoViewObj({"src":pauseMenuSDPlusView});
      
      public static const VIEW_PAUSE_ZOMBIE_SURVIVAL:CodoViewObj = new CodoViewObj({"src":pauseMenuZombieSurvivalView});
      
      public static const VIEW_PAUSE_SPY:CodoViewObj = new CodoViewObj({"src":pauseMenuSpyView});
      
      public static const VIEW_PAUSE_HOSTAGE:CodoViewObj = new CodoViewObj({"src":pauseMenuHostageView});
      
      public static const VIEW_PAUSE_DMZ:CodoViewObj = new CodoViewObj({"src":pauseMenuDMZView});
      
      public static const VIEW_PAUSE_ZHUNT:CodoViewObj = new CodoViewObj({"src":pauseMenuZHuntView});
      
      public static const VIEW_PAUSE_TD:CodoViewObj = new CodoViewObj({"src":hudTdPauseMenuView});
      
      public static const VIEW_QUIT_GAME_WARNING_POPUP:CodoViewObj = new CodoViewObj({"src":fsgQuitGameWarningPopupView});
      
      public static const VIEW_HELP:CodoViewObj = new CodoViewObj({"src":fsgHelpMenuView});
      
      public static const VIEW_HELP_ZHUNT:CodoViewObj = new CodoViewObj({"src":fsgHelpMenuZhuntView});
      
      public static const VIEW_HELP_TD:CodoViewObj = new CodoViewObj({"src":fsgHelpMenuTD});
      
      public static const VIEW_UI_TUTORIAL_IN_GAME:CodoViewObj = new CodoViewObj({"src":uiTutorialInGameView});
      
      public static const VIEW_RETRY_TRAINING:CodoViewObj = new CodoViewObj({"src":fsgTrainingCompleteView});
      
      public static const VIEW_TRAINING_REWARDS:CodoViewObj = new CodoViewObj({"src":fsgTrainingRewardsView});
      
      public static const VIEW_TRAINING_REWARDS_POPUP:CodoViewObj = new CodoViewObj({"src":fsgTrainingRewardsVideoPopupView});
      
      public static const VIEW_ASYM_HUD:CodoViewObj = new CodoViewObj({"src":hudAsym});
      
      public static const VIEW_ASYM_SCORE:CodoViewObj = new CodoViewObj({"src":hudScore});
      
      public static const VIEW_CLASH_HUD:CodoViewObj = new CodoViewObj({"src":hudClash});
      
      public static const VIEW_SANDR_HUD:CodoViewObj = new CodoViewObj({"src":hudSandR});
      
      public static const VIEW_SANDD_HUD:CodoViewObj = new CodoViewObj({"src":hudSandD});
      
      public static const VIEW_ZOMBIE_ARENA_HUD:CodoViewObj = new CodoViewObj({"src":hudZombieArena});
      
      public static const VIEW_SURVIVAL_HUD:CodoViewObj = new CodoViewObj({"src":hudSurvival});
      
      public static const VIEW_SPY_HUD:CodoViewObj = new CodoViewObj({"src":hudSpy});
      
      public static const VIEW_PROP_HUNT_HUD:CodoViewObj = new CodoViewObj({"src":hudPropHunt});
      
      public static const VIEW_DMZ_HUD:CodoViewObj = new CodoViewObj({"src":hudDMZ});
      
      public static const VIEW_PLAYER_CARD_HUD:CodoViewObj = new CodoViewObj({"src":hudPlayerCard});
      
      public static const VIEW_HUD:CodoViewObj = new CodoViewObj({"src":HUDView});
      
      public static const VIEW_TOP_HUD:CodoViewObj = new CodoViewObj({"src":HUDTopView});
      
      public static const VIEW_DMZ_LOADOUT:CodoViewObj = new CodoViewObj({"src":hudDMZLoadoutView});
      
      public static const VIEW_QUICK_CHAT:CodoViewObj = new CodoViewObj({"src":hudQuickChatView});
      
      public static const VIEW_ZHUNT_SHOPPING_POPUP:CodoViewObj = new CodoViewObj({"src":hudZHuntShoppingPopup});
      
      public static const VIEW_ZHUNT_BOSS_RESULT_POPUP:CodoViewObj = new CodoViewObj({"src":hudZHuntBossResultPopup});
      
      public static const VIEW_FULL_SCREEN_BINK_PLAYER:CodoViewObj = new CodoViewObj({"src":hudFullScreenBinkPlayer});
      
      public static const VIEW_SPY_WANTED_POPUP:CodoViewObj = new CodoViewObj({"src":hudSpyWantedPopup});
      
      public static const VIEW_VIP_VOTE_INFO_POPUP:CodoViewObj = new CodoViewObj({"src":hudVIPVoteInfoPopup});
      
      public static const VIEW_VIP_SELECT_CHARACTER_POPUP:CodoViewObj = new CodoViewObj({"src":hudVIPSelectVIPCharacterPopup});
      
      public static const VIEW_VOTE_POPUP:CodoViewObj = new CodoViewObj({"src":hudVotePopup});
      
      public static const VIEW_TD_LOADOUT:CodoViewObj = new CodoViewObj({"src":hudTdLoadoutView});
      
      public static const VIEW_TD_INVENTORY:CodoViewObj = new CodoViewObj({"src":hudTdInventoryView});
      
      public static const VIEW_TD_TURRET_MANAGE:CodoViewObj = new CodoViewObj({"src":hudTdTurretManageView});
      
      public static const VIEW_TD_TURRET_UPGRADE:CodoViewObj = new CodoViewObj({"src":hudTdTurretUpgradeView});
      
      public static const VIEW_SPLASH_POPUP:CodoViewObj = new CodoViewObj({"src":hudSplashPopup});
      
      public static const VIEW_GVOICE_SETTINGS:CodoViewObj = new CodoViewObj({"src":gVoiceSettingsView});
      
      public static const VIEW_GVOICE_CHAT_PANEL:CodoViewObj = new CodoViewObj({"src":gVoiceChatBarView});
      
      public static const VIEW_SERVER_MSG:CodoViewObj = new CodoViewObj({"src":hudServerMessageView});
      
      public static const VIEW_COMPLAINT_WINDOW:CodoViewObj = new CodoViewObj({"src":fsgComplaintView});
      
      public static const VIEW_TOP_3_PLAYERS:CodoViewObj = new CodoViewObj({"src":fsgHudTop3PlayersView});
      
      public static const VIEW_SPY_TOP_3_PLAYERS:CodoViewObj = new CodoViewObj({"src":hudSpyTop3PlayersView});
      
      public static const VIEW_DMZ_TOP_3_PLAYERS:CodoViewObj = new CodoViewObj({"src":hudDMZTop3PlayersView});
      
      public static const PAGE_CHATTING:CodoPageObj = new CodoPageObj({
         "id":PageID.BG,
         "owner":PAGE_LAYER_CHATTING,
         "views":[VIEW_CHATTING]
      });
      
      public static const PAGE_SCOREBOARD:CodoPageObj = new CodoPageObj({
         "id":PageID.SCOREBOARD,
         "owner":PAGE_LAYER_SCOREBOARD,
         "views":[VIEW_SCOREBOARD]
      });
      
      public static const PAGE_SCOREBOARD_CYBORGS:CodoPageObj = new CodoPageObj({
         "id":PageID.SCOREBOARD,
         "owner":PAGE_LAYER_SCOREBOARD,
         "views":[VIEW_SCOREBOARD_CYBORGS]
      });
      
      public static const PAGE_PURCHASE_ENABLED_TOKEN_PROMPT:CodoPageObj = new CodoPageObj({
         "id":PageID.PURCHASE_ENABLED_TOKEN_PROMPT,
         "owner":PAGE_LAYER_RESPAWN,
         "views":[VIEW_PURCHASE_ENABLED_TOKEN_POPUP]
      });
      
      public static const PAGE_CYBORG_TOKENS_FSG:CodoPageObj = new CodoPageObj({
         "id":PageID.QUESTION,
         "owner":PAGE_LAYER_RESPAWN,
         "views":[VIEW_CYBORG_TOKENS_FSG]
      });
      
      public static const PAGE_SYS_MSG_FSG:CodoPageObj = new CodoPageObj({
         "id":PageID.SYS_MSG,
         "owner":PAGE_LAYER_NOTIFICATION,
         "views":[VIEW_SYSTEMNOTIFY_FSG],
         "ingameSupportKeyEvent":true
      });
      
      public static const PAGE_ZHUNT_PURCHASE_ENABLED_TOKEN_PROMPT:CodoPageObj = new CodoPageObj({
         "id":PageID.PURCHASE_ENABLED_TOKEN_PROMPT,
         "owner":PAGE_LAYER_RESPAWN,
         "views":[VIEW_ZHUNT_PURCHASE_ENABLED_TOKEN_POPUP]
      });
      
      public static const PAGE_RETRY_TRAINING:CodoPageObj = new CodoPageObj({
         "id":PageID.COOP_EOG,
         "owner":PAGE_LAYER_COOP_EOG,
         "views":[VIEW_RETRY_TRAINING],
         "ingameSupportKeyEvent":true
      });
      
      public static const PAGE_TRAINING_REWARDS:CodoPageObj = new CodoPageObj({
         "id":PageID.FSG_ONBOARDING_TRAINING_REWARDS,
         "owner":PAGE_LAYER_COOP_EOG,
         "views":[VIEW_TRAINING_REWARDS],
         "ingameSupportKeyEvent":true
      });
      
      public static const PAGE_TRAINING_REWARDS_POPUP:CodoPageObj = new CodoPageObj({
         "id":PageID.FSG_ONBOARDING_TRAINING_REWARDS_POPUP,
         "owner":PAGE_LAYER_PAUSE,
         "views":[VIEW_TRAINING_REWARDS_POPUP],
         "bypassDrawMask":false,
         "enableCloseByESC":false
      });
      
      private static const PAGE_PAUSE:CodoPageObj = new CodoPageObj({
         "id":PageID.BG,
         "owner":PAGE_LAYER_PAUSE,
         "views":[VIEW_PAUSE],
         "ingameSupportKeyEvent":true
      });
      
      private static const PAGE_PAUSE_ASYM:CodoPageObj = new CodoPageObj({
         "id":PageID.BG,
         "owner":PAGE_LAYER_PAUSE,
         "views":[VIEW_PAUSE_ASYM],
         "ingameSupportKeyEvent":true
      });
      
      private static const PAGE_PAUSE_CLASH:CodoPageObj = new CodoPageObj({
         "id":PageID.BG,
         "owner":PAGE_LAYER_PAUSE,
         "views":[VIEW_PAUSE_CLASH],
         "ingameSupportKeyEvent":true
      });
      
      private static const PAGE_PAUSE_SDPLUS:CodoPageObj = new CodoPageObj({
         "id":PageID.BG,
         "owner":PAGE_LAYER_PAUSE,
         "views":[VIEW_PAUSE_SDPLUS],
         "ingameSupportKeyEvent":true
      });
      
      private static const PAGE_PAUSE_ZOMBIE_SURVIVAL:CodoPageObj = new CodoPageObj({
         "id":PageID.BG,
         "owner":PAGE_LAYER_PAUSE,
         "views":[VIEW_PAUSE_ZOMBIE_SURVIVAL],
         "ingameSupportKeyEvent":true
      });
      
      private static const PAGE_PAUSE_SPY:CodoPageObj = new CodoPageObj({
         "id":PageID.BG,
         "owner":PAGE_LAYER_PAUSE,
         "views":[VIEW_PAUSE_SPY],
         "ingameSupportKeyEvent":true
      });
      
      private static const PAGE_PAUSE_HOSTAGE:CodoPageObj = new CodoPageObj({
         "id":PageID.BG,
         "owner":PAGE_LAYER_PAUSE,
         "views":[VIEW_PAUSE_HOSTAGE],
         "ingameSupportKeyEvent":true
      });
      
      private static const PAGE_PAUSE_DMZ:CodoPageObj = new CodoPageObj({
         "id":PageID.BG,
         "owner":PAGE_LAYER_PAUSE,
         "views":[VIEW_PAUSE_DMZ],
         "ingameSupportKeyEvent":true
      });
      
      private static const PAGE_PAUSE_ZHUNT:CodoPageObj = new CodoPageObj({
         "id":PageID.BG,
         "owner":PAGE_LAYER_PAUSE,
         "views":[VIEW_PAUSE_ZHUNT],
         "ingameSupportKeyEvent":true
      });
      
      private static const PAGE_PAUSE_TD:CodoPageObj = new CodoPageObj({
         "id":PageID.BG,
         "owner":PAGE_LAYER_PAUSE,
         "views":[VIEW_PAUSE_TD],
         "ingameSupportKeyEvent":true
      });
      
      public static const PAGE_QUIT_GAME_WARNING_POPUP:CodoPageObj = new CodoPageObj({
         "id":PageID.QUIT_GAME_WARNING_POPUP,
         "owner":PAGE_LAYER_NOTIFICATION,
         "views":[VIEW_QUIT_GAME_WARNING_POPUP],
         "enableCloseByESC":true,
         "ingameSupportKeyEvent":true
      });
      
      public static const PAGE_ADV_POPUP_PURCHASE_ADD_TO_CART:CodoPageObj = new CodoPageObj({
         "id":PageID.MARKET_PURCHASE_ADD_TO_CART,
         "owner":PAGE_LAYER_POPUP,
         "views":[VIEW_MARKET_PURCHASE_ADD_TO_CART],
         "enableCloseByESC":true,
         "ingameSupportKeyEvent":true
      });
      
      public static const PAGE_HELP:CodoPageObj = new CodoPageObj({
         "id":PageID.BG,
         "owner":PAGE_LAYER_HELP,
         "views":[VIEW_HELP]
      });
      
      public static const PAGE_HELP_ZHUNT:CodoPageObj = new CodoPageObj({
         "id":PageID.BG,
         "owner":PAGE_LAYER_HELP,
         "views":[VIEW_HELP_ZHUNT]
      });
      
      public static const PAGE_HELP_TD:CodoPageObj = new CodoPageObj({
         "id":PageID.BG,
         "owner":PAGE_LAYER_HELP,
         "views":[VIEW_HELP_TD]
      });
      
      public static const PAGE_POPUP_COMPLAINT_WINDOW:CodoPageObj = new CodoPageObj({
         "id":PageID.FSG_COMPLAINTWINDOW,
         "owner":PAGE_LAYER_NOTIFICATION,
         "views":[VIEW_COMPLAINT_WINDOW],
         "enableCloseByESC":true,
         "ingameSupportKeyEvent":true
      });
      
      public static const PAGE_UI_TUTORIAL_INGAME:CodoPageObj = new CodoPageObj({
         "id":PageID.UI_TUTORIAL_INGAME,
         "owner":PAGE_LAYER_HUD,
         "views":[VIEW_UI_TUTORIAL_IN_GAME]
      });
      
      public static const PAGE_SERVER:CodoPageObj = new CodoPageObj({
         "id":PageID.BG,
         "owner":PAGE_LAYER_SERVER,
         "views":[VIEW_SERVER_MSG]
      });
      
      public static const PAGE_TOP_3_PLAYERS:CodoPageObj = new CodoPageObj({
         "id":PageID.BG,
         "owner":PAGE_LAYER_SUMMARY,
         "views":[VIEW_TOP_3_PLAYERS],
         "ingameSupportKeyEvent":true
      });
      
      public static const PAGE_SPY_TOP_3_PLAYERS:CodoPageObj = new CodoPageObj({
         "id":PageID.BG,
         "owner":PAGE_LAYER_SUMMARY,
         "views":[VIEW_SPY_TOP_3_PLAYERS],
         "ingameSupportKeyEvent":true
      });
      
      public static const PAGE_DMZ_TOP_3_PLAYERS:CodoPageObj = new CodoPageObj({
         "id":PageID.BG,
         "owner":PAGE_LAYER_SUMMARY,
         "views":[VIEW_DMZ_TOP_3_PLAYERS],
         "ingameSupportKeyEvent":true
      });
      
      public static const PAGE_ASYM_HUD:CodoPageObj = new CodoPageObj({
         "id":PageID.BG,
         "owner":PAGE_LAYER_HUD,
         "views":[VIEW_ASYM_HUD,VIEW_ASYM_SCORE]
      });
      
      public static const PAGE_CLASH_HUD:CodoPageObj = new CodoPageObj({
         "id":PageID.BG,
         "owner":PAGE_LAYER_HUD,
         "views":[VIEW_CLASH_HUD]
      });
      
      public static const PAGE_SANDR_HUD:CodoPageObj = new CodoPageObj({
         "id":PageID.BG,
         "owner":PAGE_LAYER_HUD,
         "views":[VIEW_SANDR_HUD]
      });
      
      public static const PAGE_SANDD_HUD:CodoPageObj = new CodoPageObj({
         "id":PageID.BG,
         "owner":PAGE_LAYER_HUD,
         "views":[VIEW_SANDD_HUD]
      });
      
      public static const PAGE_ZOMBIE_ARENA_HUD:CodoPageObj = new CodoPageObj({
         "id":PageID.BG,
         "owner":PAGE_LAYER_HUD,
         "views":[VIEW_ZOMBIE_ARENA_HUD]
      });
      
      public static const PAGE_SURVIVAL_HUD:CodoPageObj = new CodoPageObj({
         "id":PageID.BG,
         "owner":PAGE_LAYER_HUD,
         "views":[VIEW_SURVIVAL_HUD]
      });
      
      public static const PAGE_SPY_HUD:CodoPageObj = new CodoPageObj({
         "id":PageID.BG,
         "owner":PAGE_LAYER_HUD,
         "views":[VIEW_SPY_HUD]
      });
      
      public static const PAGE_PROP_HUNT_HUD:CodoPageObj = new CodoPageObj({
         "id":PageID.BG,
         "owner":PAGE_LAYER_HUD,
         "views":[VIEW_PROP_HUNT_HUD]
      });
      
      public static const PAGE_DMZ_HUD:CodoPageObj = new CodoPageObj({
         "id":PageID.BG,
         "owner":PAGE_LAYER_HUD,
         "views":[VIEW_DMZ_HUD]
      });
      
      public static const PAGE_HUD:CodoPageObj = new CodoPageObj({
         "id":PageID.BG,
         "owner":PAGE_LAYER_HUD,
         "views":[VIEW_HUD]
      });
      
      public static const PAGE_TOP_HUD:CodoPageObj = new CodoPageObj({
         "id":PageID.BG,
         "owner":PAGE_LAYER_TOP_HUD,
         "views":[VIEW_TOP_HUD]
      });
      
      public static const PAGE_ZHUNT_SHOPPING_POPUP:CodoPageObj = new CodoPageObj({
         "id":PageID.BG,
         "owner":PAGE_LAYER_HUD_POPUP,
         "views":[VIEW_ZHUNT_SHOPPING_POPUP],
         "ingameSupportKeyEvent":true
      });
      
      public static const PAGE_ZHUNT_BOSS_RESULT_POPUP:CodoPageObj = new CodoPageObj({
         "id":PageID.BG,
         "owner":PAGE_LAYER_HUD_POPUP,
         "views":[VIEW_ZHUNT_BOSS_RESULT_POPUP]
      });
      
      public static const PAGE_FULL_SCREEN_BINK_PLAYER_POPUP:CodoPageObj = new CodoPageObj({
         "id":PageID.BG,
         "owner":PAGE_LAYER_HUD_POPUP,
         "views":[VIEW_FULL_SCREEN_BINK_PLAYER]
      });
      
      public static const PAGE_SPY_WANTED_POPUP:CodoPageObj = new CodoPageObj({
         "id":PageID.BG,
         "owner":PAGE_LAYER_HUD_POPUP,
         "views":[VIEW_SPY_WANTED_POPUP],
         "ingameSupportKeyEvent":true
      });
      
      public static const PAGE_VIP_VOTE_INFO_POPUP:CodoPageObj = new CodoPageObj({
         "id":PageID.BG,
         "owner":PAGE_LAYER_HUD_POPUP,
         "views":[VIEW_VIP_VOTE_INFO_POPUP],
         "ingameSupportKeyEvent":true
      });
      
      public static const PAGE_VIP_SELECT_CHARACTER_POPUP:CodoPageObj = new CodoPageObj({
         "id":PageID.BG,
         "owner":PAGE_LAYER_HUD_POPUP,
         "views":[VIEW_VIP_SELECT_CHARACTER_POPUP],
         "ingameSupportKeyEvent":true
      });
      
      public static const PAGE_VOTE_POPUP:CodoPageObj = new CodoPageObj({
         "id":PageID.BG,
         "owner":PAGE_LAYER_KICK,
         "views":[VIEW_VOTE_POPUP],
         "ingameSupportKeyEvent":false
      });
      
      public static const PAGE_SPLASH_POPUP:CodoPageObj = new CodoPageObj({
         "id":PageID.BG,
         "owner":PAGE_LAYER_SPLASH,
         "views":[VIEW_SPLASH_POPUP]
      });
      
      public static const PAGE_TOP_SPLASH_POPUP:CodoPageObj = new CodoPageObj({
         "id":PageID.BG,
         "owner":PAGE_LAYER_TOP_SPLASH,
         "views":[VIEW_SPLASH_POPUP]
      });
      
      public static const PAGE_PLAYERCARD_HUD:CodoPageObj = new CodoPageObj({
         "id":PageID.BG,
         "owner":PAGE_LAYER_PLAYER_CARD,
         "views":[VIEW_PLAYER_CARD_HUD]
      });
      
      public static const PAGE_DMZ_LOADOUT:CodoPageObj = new CodoPageObj({
         "id":PageID.BG,
         "owner":PAGE_LAYER_LOADOUT,
         "views":[VIEW_DMZ_LOADOUT],
         "ingameSupportKeyEvent":true
      });
      
      public static const PAGE_TD_LOADOUT:CodoPageObj = new CodoPageObj({
         "id":PageID.BG,
         "owner":PAGE_LAYER_LOADOUT,
         "views":[VIEW_TD_LOADOUT],
         "ingameSupportKeyEvent":true
      });
      
      public static const PAGE_TD_INVENTORY:CodoPageObj = new CodoPageObj({
         "id":PageID.BG,
         "owner":PAGE_LAYER_LOADOUT,
         "views":[VIEW_TD_INVENTORY],
         "ingameSupportKeyEvent":true
      });
      
      public static const PAGE_TD_TURRET_MANAGE:CodoPageObj = new CodoPageObj({
         "id":PageID.BG,
         "owner":PAGE_LAYER_LOADOUT,
         "views":[VIEW_TD_TURRET_MANAGE],
         "ingameSupportKeyEvent":true
      });
      
      public static const PAGE_TD_TURRET_UPGRADE:CodoPageObj = new CodoPageObj({
         "id":PageID.BG,
         "owner":PAGE_LAYER_LOADOUT,
         "views":[VIEW_TD_TURRET_UPGRADE],
         "ingameSupportKeyEvent":true
      });
      
      public static const PAGE_GVOICE_SETTINGS:CodoPageObj = new CodoPageObj({
         "id":PageID.GVOICE_SETTINGS,
         "owner":PAGE_LAYER_GVOICE_SETTINGS,
         "views":[VIEW_GVOICE_SETTINGS],
         "enableCloseByESC":false
      });
      
      public static const PAGE_GVOICE_CHAT_PANEL:CodoPageObj = new CodoPageObj({
         "id":PageID.GVOICE_CHAT,
         "owner":PAGE_LAYER_GVOICE_CHAT_PANEL,
         "views":[VIEW_GVOICE_CHAT_PANEL],
         "enableCloseByESC":false
      });
      
      public static const PAGE_QUICK_CHAT:CodoPageObj = new CodoPageObj({
         "id":PageID.BG,
         "owner":PAGE_LAYER_QUICKCHAT,
         "views":[VIEW_QUICK_CHAT]
      });
      
      public function CodoInGamePageDB()
      {
         super();
      }
      
      public static function GetPausePage(isLoadoutOnly:Boolean) : CodoPageObj
      {
         var gametype:String = InGameService.getInstance().getGameType() as String;
         if(Boolean(CFunctionCommonContainer.GametypeUsesAsymRobots(gametype)) && AsymPvpUtil.instance.isAsymMonster)
         {
            return PAGE_PAUSE_ASYM;
         }
         if(gametype == "sdp")
         {
            return PAGE_PAUSE_SDPLUS;
         }
         if(ClashPvpUtil.instance != null && !ClashPvpUtil.isClashHardcore())
         {
            return PAGE_PAUSE_CLASH;
         }
         if(gametype == "zchamp")
         {
            return PAGE_PAUSE_ZOMBIE_SURVIVAL;
         }
         if(gametype == "spy")
         {
            return PAGE_PAUSE_SPY;
         }
         if(gametype == "hostage")
         {
            return PAGE_PAUSE_HOSTAGE;
         }
         if(gametype == "dmz")
         {
            return PAGE_PAUSE_DMZ;
         }
         if(gametype == "zhunt" && !isLoadoutOnly)
         {
            return PAGE_PAUSE_ZHUNT;
         }
         if(gametype == "td")
         {
            return PAGE_PAUSE_TD;
         }
         return PAGE_PAUSE;
      }
   }
}

