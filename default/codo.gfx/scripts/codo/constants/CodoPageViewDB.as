package codo.constants
{
   import codo.battlecity.battleCityLeagueAward;
   import codo.battlecity.battlecityleaguereward;
   import codo.friend.friendView;
   import codo.gvoice.gVoiceChatBarView;
   import codo.gvoice.gVoiceSettingsView;
   import codo.mail.mailView;
   import codo.mail.newMailNotification;
   import codo.matchresult.zhunt.zhuntMatchRewardView;
   import codo.objects.CodoPageLayerObj;
   import codo.objects.CodoPageObj;
   import codo.objects.CodoViewObj;
   import codo.party.notificationStackView;
   import codo.party.partyView;
   import codo.persistent.matchMakingStripView;
   import codo.popups.activityRewardPopup;
   import codo.popups.challengeInfoPopup;
   import codo.popups.clanCreateConfirm;
   import codo.popups.gamemodeImagePopupView;
   import codo.popups.itemRestrictionPreviewPopup;
   import codo.popups.itemRestrictionWarningPopup;
   import codo.popups.killstreakSwapPopupView;
   import codo.popups.loadoutFullPopupView;
   import codo.popups.loadoutSlotLockedPopupView;
   import codo.popups.marketplacePurchaseAddToCartPopupView;
   import codo.popups.onboardingReturnReminderPopup;
   import codo.popups.pinChallengePopup;
   import codo.popups.recommendationPopup;
   import codo.popups.renameConfirm;
   import codo.popups.supplyDropDependencyPopup;
   import codo.reward.rewardpopup;
   import codo.shared.marketplacePurchaseBundleAddToCartPopupView;
   import codo.systemMsg.serverMessageView;
   import codo.views.fsgQuestionaireView;
   import codo.views.onboarding.ClaimOnboardingRewardView;
   import codo.views.onboarding.OnboardingUIChallengeCompleteView;
   import codo.views.persistentView.socialNavigationMenu;
   import codo.views.quit.QuitGameSummaryView;
   import codo.wargod.startMatchPopup;
   import codo.wargod.wargodseasonendreward;
   import fsg.onboarding.fsgCharacterSelectView;
   import fsg.onboarding.fsgGmrtgPopupView;
   import fsg.popups.fsgPrestigeUnlockedView;
   import fsg.popups.gamemodeTutorialPopupView;
   
   public class CodoPageViewDB
   {
      
      public static const TAG_PAGE_LAYER:String = "instance_pageLayer_";
      
      public static const PAGE_LAYER_BG:CodoPageLayerObj = new CodoPageLayerObj({
         "depth":1,
         "name":TAG_PAGE_LAYER + "bg"
      });
      
      public static const PAGE_LAYER_MAIN:CodoPageLayerObj = new CodoPageLayerObj({
         "depth":2,
         "name":TAG_PAGE_LAYER + "main"
      });
      
      public static const PAGE_LAYER_PERSISTENT:CodoPageLayerObj = new CodoPageLayerObj({
         "depth":3,
         "name":TAG_PAGE_LAYER + "persistent"
      });
      
      public static const PAGE_LAYER_MENU:CodoPageLayerObj = new CodoPageLayerObj({
         "depth":4,
         "name":TAG_PAGE_LAYER + "menu"
      });
      
      public static const PAGE_LAYER_BACKGROUND_POPUP:CodoPageLayerObj = new CodoPageLayerObj({
         "depth":11,
         "name":TAG_PAGE_LAYER + "background_popup"
      });
      
      public static const PAGE_LAYER_POPUP:CodoPageLayerObj = new CodoPageLayerObj({
         "depth":12,
         "name":TAG_PAGE_LAYER + "popup",
         "queue":true
      });
      
      public static const PAGE_LAYER_UI_TUTORIAL:CodoPageLayerObj = new CodoPageLayerObj({
         "depth":13,
         "name":TAG_PAGE_LAYER + "ui_tutorial"
      });
      
      public static const PAGE_LAYER_ADV_POPUP:CodoPageLayerObj = new CodoPageLayerObj({
         "depth":14,
         "name":TAG_PAGE_LAYER + "adv_popup"
      });
      
      public static const PAGE_LAYER_WEBIMG:CodoPageLayerObj = new CodoPageLayerObj({
         "depth":15,
         "name":TAG_PAGE_LAYER + "webimg"
      });
      
      public static const PAGE_LAYER_FLOATING_ELEMENT:CodoPageLayerObj = new CodoPageLayerObj({
         "depth":16,
         "name":TAG_PAGE_LAYER + "player_info"
      });
      
      public static const PAGE_LAYER_SYS_MSG:CodoPageLayerObj = new CodoPageLayerObj({
         "depth":25,
         "name":TAG_PAGE_LAYER + "sys_msg"
      });
      
      public static const PAGE_LAYER_GVOICE_CHAT_PANEL:CodoPageLayerObj = new CodoPageLayerObj({
         "depth":26,
         "name":TAG_PAGE_LAYER + "gvoice_chat_panel"
      });
      
      public static const PAGE_LAYER_GVOICE_SETTINGS:CodoPageLayerObj = new CodoPageLayerObj({
         "depth":27,
         "name":TAG_PAGE_LAYER + "gvoice_settings"
      });
      
      public static const PAGE_LAYER_QUIT_GAME_CONFIRM_POPUP:CodoPageLayerObj = new CodoPageLayerObj({
         "depth":28,
         "name":TAG_PAGE_LAYER + "quit_game_confirm"
      });
      
      public static const PAGE_LAYER_LANG_BAR:CodoPageLayerObj = new CodoPageLayerObj({
         "depth":29,
         "name":TAG_PAGE_LAYER + "lang_bar"
      });
      
      public static const PAGE_LAYER_TIP:CodoPageLayerObj = new CodoPageLayerObj({
         "depth":30,
         "name":TAG_PAGE_LAYER + "tip"
      });
      
      public static const PAGE_LAYER_LETTERBOX:CodoPageLayerObj = new CodoPageLayerObj({
         "depth":99,
         "name":TAG_PAGE_LAYER + "letterbox"
      });
      
      public static const VIEW_BACKGROUND:CodoViewObj = new CodoViewObj({"src":backgroundView});
      
      public static const VIEW_LETTERBOX:CodoViewObj = new CodoViewObj({"src":letterboxView});
      
      public static const VIEW_FSG_LOADOUT:CodoViewObj = new CodoViewObj({"src":loadoutView});
      
      public static const VIEW_LOADOUT_FULL_POPUP:CodoViewObj = new CodoViewObj({"src":loadoutFullPopupView});
      
      public static const VIEW_LOADOUT_SLOT_LOCKED_POPUP:CodoViewObj = new CodoViewObj({"src":loadoutSlotLockedPopupView});
      
      public static const VIEW_IN_ROOM:CodoViewObj = new CodoViewObj({
         "src":gameLobbyView,
         "historyAble":false
      });
      
      public static const VIEW_RECOMMENDED_LOADOUT_POPUP:CodoViewObj = new CodoViewObj({"src":fsgRecommendedLoadoutPopupView});
      
      public static const VIEW_QUESTION:CodoViewObj = new CodoViewObj({"src":fsgQuestionaireView});
      
      public static const VIEW_CAREER_TABS:CodoViewObj = new CodoViewObj({"src":careerTabsView});
      
      public static const VIEW_CAREER_BATTLE_EXPERIENCE:CodoViewObj = new CodoViewObj({"src":careerBattleExperienceView});
      
      public static const VIEW_CAREER_CHALLENGES:CodoViewObj = new CodoViewObj({"src":careerChallengesView});
      
      public static const VIEW_ACTIVITY_POPUP:CodoViewObj = new CodoViewObj({"src":activityRewardPopup});
      
      public static const VIEW_RECOMMENDATION_POPUP:CodoViewObj = new CodoViewObj({"src":recommendationPopup});
      
      public static const VIEW_WARGOD_SEASON_REWARD:CodoViewObj = new CodoViewObj({"src":wargodseasonendreward});
      
      public static const VIEW_SYSTEMNOTIFY_FSG:CodoViewObj = new CodoViewObj({"src":fsgPopupsView});
      
      public static const VIEW_ASYM_PURCHASE:CodoViewObj = new CodoViewObj({"src":asymPurchasePopupView});
      
      public static const VIEW_FSG_OPTIONS:CodoViewObj = new CodoViewObj({"src":fsgOptionsView});
      
      public static const VIEW_FSG_CREATEROOMOPTIONS:CodoViewObj = new CodoViewObj({"src":createRoomOptionsView});
      
      public static const VIEW_LANGBAR:CodoViewObj = new CodoViewObj({"src":languageBarView});
      
      public static const VIEW_LOGIN_FSG:CodoViewObj = new CodoViewObj({"src":fsgGmrtgPopupView});
      
      public static const VIEW_TIP:CodoViewObj = new CodoViewObj({"src":tipView});
      
      public static const VIEW_JOIN_ROOM_PASSWORD:CodoViewObj = new CodoViewObj({"src":fsgRoomPasswordPopupView});
      
      public static const VIEW_VIDEO_PLAYER:CodoViewObj = new CodoViewObj({"src":videoPlayerView});
      
      public static const VIEW_MARKET:CodoViewObj = new CodoViewObj({"src":marketplaceView});
      
      public static const VIEW_LOADOUT_SELECTION:CodoViewObj = new CodoViewObj({"src":loadoutSelectionView});
      
      public static const VIEW_MARKET_PURCHASE_ADD_TO_CART:CodoViewObj = new CodoViewObj({"src":marketplacePurchaseAddToCartPopupView});
      
      public static const VIEW_MARKET_PURCHASE_BUNDLE_ADD_TO_CART:CodoViewObj = new CodoViewObj({"src":marketplacePurchaseBundleAddToCartPopupView});
      
      public static const VIEW_RECOMMENDED_LOADOUT_PURCHASE_REMAINDER_ITEMS_POPUP_VIEW:CodoViewObj = new CodoViewObj({"src":recommendedLoadoutPurchaseRemainderItemsPopupView});
      
      public static const VIEW_MARKET_ITEM_DETAILS:CodoViewObj = new CodoViewObj({"src":marketplaceItemDetailsView});
      
      public static const VIEW_CHARACTER_SELECT_DETAILS:CodoViewObj = new CodoViewObj({"src":characterSelectDetailsView});
      
      public static const VIEW_SHOPPING_CART:CodoViewObj = new CodoViewObj({"src":shoppingCartView});
      
      public static const VIEW_MARKET_COMPARE:CodoViewObj = new CodoViewObj({"src":marketplaceCompareView});
      
      public static const VIEW_FSG_MP_GAME_MODES_TUTORIAL:CodoViewObj = new CodoViewObj({"src":gamemodeTutorialPopupView});
      
      public static const VIEW_GAME_MODES_IMAGE:CodoViewObj = new CodoViewObj({"src":gamemodeImagePopupView});
      
      public static const VIEW_ONBOARD_WELCOME_NEW_PLAYER:CodoViewObj = new CodoViewObj({"src":PlayerWelcomeView});
      
      public static const VIEW_ONBOARD_EXPERIENCE_SELECT:CodoViewObj = new CodoViewObj({"src":PlayerOnboardTrainingIntroView});
      
      public static const VIEW_ONBOARD_PLAYER_TRAINING_INTRO:CodoViewObj = new CodoViewObj({"src":PlayerOnboardTrainingIntroView});
      
      public static const VIEW_ONBOARD_RETURN_REWARDED_POPUP:CodoViewObj = new CodoViewObj({"src":onboardingReturnReminderPopup});
      
      public static const VIEW_ONBOARD_KEYBOARD_SELECT:CodoViewObj = new CodoViewObj({"src":onboardingKeyboardSelectView});
      
      public static const VIEW_CHARACTER_SELECT:CodoViewObj = new CodoViewObj({"src":fsgCharacterSelectView});
      
      public static const VIEW_UI_TUTORIAL_AAR:CodoViewObj = new CodoViewObj({"src":UITutorialAARView});
      
      public static const VIEW_UI_TUTORIAL_LANDING:CodoViewObj = new CodoViewObj({"src":UITutorialLandingView});
      
      public static const VIEW_UI_TUTORIAL_INVENTORY:CodoViewObj = new CodoViewObj({"src":UITutorialInventoryView});
      
      public static const VIEW_UI_TUTORIAL_ITEM_DETAILS:CodoViewObj = new CodoViewObj({"src":UITutorialMarketDetailsView});
      
      public static const VIEW_UI_TUTORIAL_LOADOUT_SELECT:CodoViewObj = new CodoViewObj({"src":UITutorialLoadoutSelectView});
      
      public static const VIEW_UI_TUTORIAL_MARKET:CodoViewObj = new CodoViewObj({"src":UITutorialPersistentView});
      
      public static const VIEW_UI_TUTORIAL_MATCH_SELECT:CodoViewObj = new CodoViewObj({"src":UITutorialPersistentView});
      
      public static const VIEW_UI_TUTORIAL_CLAN:CodoViewObj = new CodoViewObj({"src":UITutorialClanView});
      
      public static const VIEW_UI_TUTORIAL_PERSISTENT:CodoViewObj = new CodoViewObj({"src":UITutorialPersistentView});
      
      public static const VIEW_UI_TUTORIAL_LOGIN_REWARDS:CodoViewObj = new CodoViewObj({"src":UITutorialPersistentView});
      
      public static const VIEW_UI_TUTORIAL_CAREER:CodoViewObj = new CodoViewObj({"src":UITutorialPersistentView});
      
      public static const VIEW_UI_TUTORIAL_SOCIAL:CodoViewObj = new CodoViewObj({"src":UITutorialSocialView});
      
      public static const VIEW_FSG_PRESTIGE_UNLOCKED_POPUP:CodoViewObj = new CodoViewObj({"src":fsgPrestigeUnlockedView});
      
      public static const VIEW_MOTD_NOTIFICATIONS:CodoViewObj = new CodoViewObj({"src":MOTDNotificationsPopup});
      
      public static const VIEW_MOTD_CHECKIN_REWARDS:CodoViewObj = new CodoViewObj({"src":MOTDCheckinRewards});
      
      public static const VIEW_CHALLENGE_INFO_POPUP:CodoViewObj = new CodoViewObj({"src":challengeInfoPopup});
      
      public static const VIEW_MATCH_SELECT:CodoViewObj = new CodoViewObj({"src":matchSelectView});
      
      public static const VIEW_TOKEN_BUY_POPUP:CodoViewObj = new CodoViewObj({"src":TokenBuyPopupView});
      
      public static const VIEW_LAUNCH_TRAINING_POPUP:CodoViewObj = new CodoViewObj({"src":launchTrainingPopupView});
      
      public static const VIEW_LEADERBOARD:CodoViewObj = new CodoViewObj({"src":leaderBoardView});
      
      public static const VIEW_PERSISTENT:CodoViewObj = new CodoViewObj({"src":persistentView});
      
      public static const VIEW_CHAT:CodoViewObj = new CodoViewObj({"src":chatView});
      
      public static const VIEW_SOCIAL_BAR:CodoViewObj = new CodoViewObj({"src":socialNavigationMenu});
      
      public static const VIEW_SYS_MESSAGE:CodoViewObj = new CodoViewObj({"src":serverMessageView});
      
      public static const VIEW_MODEL_ROTATION:CodoViewObj = new CodoViewObj({"src":modelRotationView});
      
      public static const VIEW_FSG_QVIDEO_PANEL:CodoViewObj = new CodoViewObj({"src":fsgQVideoMask});
      
      public static const VIEW_FSG_LANDING_CHARACTER_SETUP:CodoViewObj = new CodoViewObj({"src":fsgCharacterSelectLoadoutView});
      
      public static const VIEW_HOME:CodoViewObj = new CodoViewObj({"src":homeView});
      
      public static const VIEW_FSG_QUIT_GAME_SUMMARY:CodoViewObj = new CodoViewObj({"src":QuitGameSummaryView});
      
      public static const VIEW_FSG_MATCH_RESULT:CodoViewObj = new CodoViewObj({"src":fsgMatchResultsPopup});
      
      public static const VIEW_FSG_MATCH_RESULT_REWARD:CodoViewObj = new CodoViewObj({"src":fsgMatchResultsReward});
      
      public static const VIEW_CHARACTER_ROSTER:CodoViewObj = new CodoViewObj({"src":characterRosterView});
      
      public static const VIEW_LOGIN_QUEUE:CodoViewObj = new CodoViewObj({"src":fsgServerFullView});
      
      public static const VIEW_MAP_SPECIFIC_REWARDS:CodoViewObj = new CodoViewObj({"src":fsgGameModesMapRewardsView});
      
      public static const VIEW_RENAME_LOADOUT:CodoViewObj = new CodoViewObj({"src":fsgChangeLoadoutNamePopupView});
      
      public static const VIEW_EDIT_CLAN_MOTTO:CodoViewObj = new CodoViewObj({"src":fsgEditClanMottoPopUp});
      
      public static const VIEW_EDIT_CLAN_MSG:CodoViewObj = new CodoViewObj({"src":fsgEditClanMsgPopUp});
      
      public static const TOP_VIEW_WEBIMG:CodoViewObj = new CodoViewObj({"src":fsgWebImgView});
      
      public static const VIEW_CHANGE_NAME:CodoViewObj = new CodoViewObj({"src":renameConfirm});
      
      public static const VIEW_CHARACTER_SWAP:CodoViewObj = new CodoViewObj({"src":fsgCharacterSwapView});
      
      public static const VIEW_KILLSTREAK_SWAP:CodoViewObj = new CodoViewObj({"src":fsgKillstreakSwapView});
      
      public static const VIEW_KILLSTREAK_SELECT_SWAP:CodoViewObj = new CodoViewObj({"src":killstreakSwapPopupView});
      
      public static const VIEW_COMPLAINT_WINDOW:CodoViewObj = new CodoViewObj({"src":fsgComplaintView});
      
      public static const VIEW_CHALLENGE_AWARD:CodoViewObj = new CodoViewObj({"src":fsgChallengeAwardPopupView});
      
      public static const VIEW_ITEM_RESTRICTION_WARNING_POPUP:CodoViewObj = new CodoViewObj({"src":itemRestrictionWarningPopup});
      
      public static const VIEW_ITEM_RESTRICTION_PREVIEW_POPUP:CodoViewObj = new CodoViewObj({"src":itemRestrictionPreviewPopup});
      
      public static const VIEW_PIN_CHALLENGE_POPUP:CodoViewObj = new CodoViewObj({"src":pinChallengePopup});
      
      public static const VIEW_ONBOARDING_UI_CHALLENGE_COMPLETE:CodoViewObj = new CodoViewObj({"src":OnboardingUIChallengeCompleteView});
      
      public static const VIEW_SUPPLY_DROP:CodoViewObj = new CodoViewObj({"src":supplyDropView});
      
      public static const VIEW_SUPPLY_DROP_ITEMS_TO_WIN_POPUP:CodoViewObj = new CodoViewObj({"src":SupplyDropItemsToWinPopup});
      
      public static const VIEW_SUPPLY_DROP_REWARD_SELECTION:CodoViewObj = new CodoViewObj({"src":supplyDropRewardSelectionView});
      
      public static const VIEW_SUPPLY_DROP_DEPENDENCY_POPUP:CodoViewObj = new CodoViewObj({"src":supplyDropDependencyPopup});
      
      public static const VIEW_FRIEND:CodoViewObj = new CodoViewObj({"src":friendView});
      
      public static const VIEW_CLAN:CodoViewObj = new CodoViewObj({"src":clanView});
      
      public static const VIEW_PARTY:CodoViewObj = new CodoViewObj({"src":partyView});
      
      public static const VIEW_MAIL:CodoViewObj = new CodoViewObj({"src":mailView});
      
      public static const VIEW_CREATE_CLAN_POPUP:CodoViewObj = new CodoViewObj({"src":clanCreateConfirm});
      
      public static const VIEW_PLAYER_DETAIL_POPUP:CodoViewObj = new CodoViewObj({"src":playerDetailInfoView});
      
      public static const VIEW_NEW_MAIL_NOTIFICATION:CodoViewObj = new CodoViewObj({"src":newMailNotification});
      
      public static const VIEW_NOTIFICATION_STACK:CodoViewObj = new CodoViewObj({"src":notificationStackView});
      
      public static const VIEW_CLAIM_ONBOARDING_REWARD_VIEW:CodoViewObj = new CodoViewObj({"src":ClaimOnboardingRewardView});
      
      public static const VIEW_FLOATING_PLAYER_INFO_VIEW:CodoViewObj = new CodoViewObj({"src":floatingPlayerInfoView});
      
      public static const VIEW_FLOATING_ITEM_INFO_VIEW:CodoViewObj = new CodoViewObj({"src":floatingItemInfoView});
      
      public static const VIEW_MATCHMAKING_STRIP_VIEW:CodoViewObj = new CodoViewObj({"src":matchMakingStripView});
      
      public static const VIEW_MATCH_START_POPUP_VIEW:CodoViewObj = new CodoViewObj({"src":startMatchPopup});
      
      public static const VIEW_REWARD_POPUP_VIEW:CodoViewObj = new CodoViewObj({"src":rewardpopup});
      
      public static const VIEW_BATTLECITYLEAGUE_REWARD_VIEW:CodoViewObj = new CodoViewObj({"src":battlecityleaguereward});
      
      public static const VIEW_BATTLECITYLEAGUE_AWARD_VIEW:CodoViewObj = new CodoViewObj({"src":battleCityLeagueAward});
      
      public static const VIEW_ZHUNT_REWARD_VIEW:CodoViewObj = new CodoViewObj({"src":zhuntMatchRewardView});
      
      public static const VIEW_PERSISTEMT_SIDE_BLACK_MASK:CodoViewObj = new CodoViewObj({"src":sideBlackMask});
      
      public static const VIEW_GVOICE_SETTINGS:CodoViewObj = new CodoViewObj({"src":gVoiceSettingsView});
      
      public static const VIEW_GVOICE_CHAT_PANEL:CodoViewObj = new CodoViewObj({"src":gVoiceChatBarView});
      
      public static const PAGE_BG:CodoPageObj = new CodoPageObj({
         "id":PageID.BG,
         "owner":PAGE_LAYER_BG,
         "views":[VIEW_BACKGROUND]
      });
      
      public static const PAGE_LETTERBOX:CodoPageObj = new CodoPageObj({
         "id":PageID.LETTERBOX,
         "owner":PAGE_LAYER_LETTERBOX,
         "views":[VIEW_LETTERBOX]
      });
      
      public static const PAGE_PERSISTENT:CodoPageObj = new CodoPageObj({
         "id":PageID.PERSISTENT,
         "owner":PAGE_LAYER_PERSISTENT,
         "views":[VIEW_FSG_LANDING_CHARACTER_SETUP,VIEW_CHAT,VIEW_SOCIAL_BAR,VIEW_PERSISTENT,VIEW_SYS_MESSAGE,VIEW_NEW_MAIL_NOTIFICATION,VIEW_NOTIFICATION_STACK,VIEW_MATCHMAKING_STRIP_VIEW,VIEW_PERSISTEMT_SIDE_BLACK_MASK],
         "tutorialView":VIEW_UI_TUTORIAL_PERSISTENT
      });
      
      public static const PAGE_SYS_MSG_FSG:CodoPageObj = new CodoPageObj({
         "id":PageID.SYS_MSG,
         "owner":PAGE_LAYER_SYS_MSG,
         "views":[VIEW_SYSTEMNOTIFY_FSG]
      });
      
      public static const PAGE_HIDDEN_ROOM_MATCH_START_MSG:CodoPageObj = new CodoPageObj({
         "id":PageID.HIDDEN_ROOM_MATCH_START_MSG,
         "owner":PAGE_LAYER_SYS_MSG,
         "views":[VIEW_MATCH_START_POPUP_VIEW]
      });
      
      public static const PAGE_ACTIVITY_MSG_FSG:CodoPageObj = new CodoPageObj({
         "id":PageID.ACTIVITY_MSG,
         "owner":PAGE_LAYER_SYS_MSG,
         "views":[VIEW_ACTIVITY_POPUP]
      });
      
      public static const PAGE_WARGOD_SEASON_REWARD:CodoPageObj = new CodoPageObj({
         "id":PageID.WARGOD_SEASON_REWARD,
         "owner":PAGE_LAYER_SYS_MSG,
         "views":[VIEW_WARGOD_SEASON_REWARD]
      });
      
      public static const PAGE_RECOMMENDATION_MSG_FSG:CodoPageObj = new CodoPageObj({
         "id":PageID.RECOMMENDATION_MSG,
         "owner":PAGE_LAYER_SYS_MSG,
         "views":[VIEW_RECOMMENDATION_POPUP]
      });
      
      public static const PAGE_FLOATING_ELEMENT:CodoPageObj = new CodoPageObj({
         "id":PageID.FLOATING_PLAYER_INFO,
         "owner":PAGE_LAYER_FLOATING_ELEMENT,
         "views":[VIEW_FLOATING_PLAYER_INFO_VIEW,VIEW_FLOATING_ITEM_INFO_VIEW]
      });
      
      public static const PAGE_LANG_BAR:CodoPageObj = new CodoPageObj({
         "id":PageID.LANG_BAR,
         "owner":PAGE_LAYER_LANG_BAR,
         "views":[VIEW_LANGBAR]
      });
      
      public static const PAGE_TIP:CodoPageObj = new CodoPageObj({
         "id":PageID.TIP,
         "owner":PAGE_LAYER_TIP,
         "views":[VIEW_TIP]
      });
      
      public static const PAGE_MAIN_LOGIN:CodoPageObj = new CodoPageObj({
         "id":PageID.LOGIN,
         "owner":PAGE_LAYER_POPUP,
         "views":[VIEW_LOGIN_FSG]
      });
      
      public static const PAGE_HOME:CodoPageObj = new CodoPageObj({
         "id":PageID.HOME,
         "owner":PAGE_LAYER_MAIN,
         "views":[VIEW_MODEL_ROTATION,VIEW_HOME],
         "tutorialView":VIEW_UI_TUTORIAL_LANDING
      });
      
      public static const PAGE_SUPPLY_DROP:CodoPageObj = new CodoPageObj({
         "id":PageID.SUPPLY_DROP,
         "owner":PAGE_LAYER_MAIN,
         "views":[VIEW_SUPPLY_DROP],
         "enableCloseByESC":true
      });
      
      public static const PAGE_SUPPLY_DROP_ITEMS_TO_WIN_POPUP:CodoPageObj = new CodoPageObj({
         "id":PageID.SUPPLY_DROP_ITEMS_TO_WIN_POPUP,
         "owner":PAGE_LAYER_POPUP,
         "views":[VIEW_SUPPLY_DROP_ITEMS_TO_WIN_POPUP],
         "enableCloseByESC":true
      });
      
      public static const PAGE_SUPPLY_DROP_REWARD_SELECTION:CodoPageObj = new CodoPageObj({
         "id":PageID.SUPPLY_DROP_REWARD_SELECTION,
         "owner":PAGE_LAYER_MAIN,
         "views":[VIEW_SUPPLY_DROP_REWARD_SELECTION]
      });
      
      public static const PAGE_SUPPLY_DROP_DEPENDENCY_POPUP:CodoPageObj = new CodoPageObj({
         "id":PageID.SUPPLY_DROP_DEPENDENCY_POPUP,
         "owner":PAGE_LAYER_POPUP,
         "views":[VIEW_SUPPLY_DROP_DEPENDENCY_POPUP]
      });
      
      public static const PAGE_GAMEMODES_TUTORIAL:CodoPageObj = new CodoPageObj({
         "id":PageID.FSG_GAME_MODES_TUTORIAL_POPUP,
         "owner":PAGE_LAYER_POPUP,
         "views":[VIEW_FSG_MP_GAME_MODES_TUTORIAL],
         "enableCloseByESC":true
      });
      
      public static const PAGE_GAMEMODES_IMAGES:CodoPageObj = new CodoPageObj({
         "id":PageID.GAME_MODES_IMAGES_POPUP,
         "owner":PAGE_LAYER_POPUP,
         "views":[VIEW_GAME_MODES_IMAGE]
      });
      
      public static const PAGE_VIDEO_PLAYER:CodoPageObj = new CodoPageObj({
         "id":PageID.VIDEO_PLAYER,
         "owner":PAGE_LAYER_POPUP,
         "views":[VIEW_VIDEO_PLAYER],
         "enableCloseByEsc":true
      });
      
      public static const PAGE_MATCH_SELECT:CodoPageObj = new CodoPageObj({
         "id":PageID.MATCH_SELECT,
         "owner":PAGE_LAYER_MAIN,
         "views":[VIEW_MODEL_ROTATION,VIEW_MATCH_SELECT],
         "tutorialView":VIEW_UI_TUTORIAL_MATCH_SELECT
      });
      
      public static const PAGE_LAUNCH_TRAINING_POPUP:CodoPageObj = new CodoPageObj({
         "id":PageID.LAUNCH_TRAINING,
         "owner":PAGE_LAYER_POPUP,
         "views":[VIEW_LAUNCH_TRAINING_POPUP]
      });
      
      public static const PAGE_LEADERBOARD:CodoPageObj = new CodoPageObj({
         "id":PageID.LEADERBOARD,
         "owner":PAGE_LAYER_POPUP,
         "views":[VIEW_LEADERBOARD,VIEW_SOCIAL_BAR],
         "tutorialView":VIEW_UI_TUTORIAL_SOCIAL,
         "enableCloseByESC":true
      });
      
      public static const PAGE_MAIN_IN_ROOM:CodoPageObj = new CodoPageObj({
         "id":PageID.INROOM,
         "owner":PAGE_LAYER_MAIN,
         "views":[VIEW_IN_ROOM,VIEW_SOCIAL_BAR,VIEW_CHAT,VIEW_SYS_MESSAGE,VIEW_NEW_MAIL_NOTIFICATION,VIEW_NOTIFICATION_STACK,VIEW_PERSISTEMT_SIDE_BLACK_MASK]
      });
      
      public static const PAGE_CAREER_BATTLE_EXPERIENCE:CodoPageObj = new CodoPageObj({
         "id":PageID.CAREER_BATTLE_EXPERIENCE,
         "owner":PAGE_LAYER_MAIN,
         "views":[VIEW_MODEL_ROTATION,VIEW_CAREER_BATTLE_EXPERIENCE,VIEW_CAREER_TABS],
         "tutorialView":VIEW_UI_TUTORIAL_CAREER
      });
      
      public static const PAGE_CAREER_CHALLENGES:CodoPageObj = new CodoPageObj({
         "id":PageID.CAREER_CHALLENGES,
         "owner":PAGE_LAYER_MAIN,
         "views":[VIEW_MODEL_ROTATION,VIEW_CAREER_CHALLENGES,VIEW_CAREER_TABS]
      });
      
      public static const PAGE_MAIN_MARKET:CodoPageObj = new CodoPageObj({
         "id":PageID.MARKET,
         "owner":PAGE_LAYER_MAIN,
         "views":[VIEW_MODEL_ROTATION,VIEW_MARKET],
         "tutorialView":VIEW_UI_TUTORIAL_MARKET
      });
      
      public static const PAGE_MARKET_ITEM_DETAILS:CodoPageObj = new CodoPageObj({
         "id":PageID.MARKET_ITEM_DETAILS,
         "owner":PAGE_LAYER_MAIN,
         "views":[VIEW_MARKET_ITEM_DETAILS],
         "enableCloseByESC":true,
         "onboardingESC":true,
         "tutorialView":VIEW_UI_TUTORIAL_ITEM_DETAILS
      });
      
      public static const PAGE_CHARACTER_ROSTER:CodoPageObj = new CodoPageObj({
         "id":PageID.CHARACTER_ROSTER,
         "owner":PAGE_LAYER_POPUP,
         "views":[VIEW_CHARACTER_ROSTER]
      });
      
      public static const PAGE_MAIN_MARKET_COMPARE:CodoPageObj = new CodoPageObj({
         "id":PageID.MARKET_COMPARE,
         "owner":PAGE_LAYER_POPUP,
         "views":[VIEW_MARKET_COMPARE]
      });
      
      public static const PAGE_SHOPPING_CART:CodoPageObj = new CodoPageObj({
         "id":PageID.SHOPPING_CART,
         "owner":PAGE_LAYER_MAIN,
         "views":[VIEW_SHOPPING_CART]
      });
      
      public static const PAGE_FSG_LOADOUT:CodoPageObj = new CodoPageObj({
         "id":PageID.FSG_LOADOUT,
         "owner":PAGE_LAYER_MAIN,
         "views":[VIEW_MODEL_ROTATION,VIEW_FSG_LOADOUT],
         "tutorialView":VIEW_UI_TUTORIAL_INVENTORY
      });
      
      public static const PAGE_LOADOUT_SELECTION:CodoPageObj = new CodoPageObj({
         "id":PageID.LOADOUT_SELECTION,
         "owner":PAGE_LAYER_MAIN,
         "views":[VIEW_MODEL_ROTATION,VIEW_LOADOUT_SELECTION],
         "tutorialView":VIEW_UI_TUTORIAL_LOADOUT_SELECT,
         "enableCloseByESC":true
      });
      
      public static const PAGE_ONBOARD_WELCOME_NEW_PLAYER:CodoPageObj = new CodoPageObj({
         "id":PageID.ONBOARDING_WELCOME_NEW_PLAYER,
         "owner":PAGE_LAYER_MAIN,
         "views":[VIEW_ONBOARD_WELCOME_NEW_PLAYER]
      });
      
      public static const PAGE_ONBOARD_EXPERIENCE_SELECT:CodoPageObj = new CodoPageObj({
         "id":PageID.ONBOARDING_EXPERIENCE_SELECT,
         "owner":PAGE_LAYER_MAIN,
         "views":[VIEW_ONBOARD_EXPERIENCE_SELECT]
      });
      
      public static const PAGE_ONBOARD_PLAYER_TRAINING_INTRO:CodoPageObj = new CodoPageObj({
         "id":PageID.ONBOARDING_PLAYER_TRAINING_INTRO,
         "owner":PAGE_LAYER_MAIN,
         "views":[VIEW_ONBOARD_PLAYER_TRAINING_INTRO]
      });
      
      public static const PAGE_ONBOARD_KEYBOARD_SELECT:CodoPageObj = new CodoPageObj({
         "id":PageID.ONBOARDING_KEYBOARD_SELECT,
         "owner":PAGE_LAYER_MAIN,
         "views":[VIEW_ONBOARD_KEYBOARD_SELECT]
      });
      
      public static const PAGE_ONBOARDING_UI_CHALLENGE_COMPLETE:CodoPageObj = new CodoPageObj({
         "id":PageID.ONBOARDING_UI_CHALLENGE_COMPLETE,
         "owner":PAGE_LAYER_POPUP,
         "views":[VIEW_ONBOARDING_UI_CHALLENGE_COMPLETE],
         "enableCloseByESC":true
      });
      
      public static const PAGE_MOTD_NOTIFICATIONS_POPUP:CodoPageObj = new CodoPageObj({
         "id":PageID.MOTD_NOTIFICATIONS_POPUP,
         "owner":PAGE_LAYER_ADV_POPUP,
         "views":[VIEW_MOTD_NOTIFICATIONS]
      });
      
      public static const PAGE_MOTD_CHECKIN_REWARDS:CodoPageObj = new CodoPageObj({
         "id":PageID.MOTD_CHECKIN_REWARDS,
         "owner":PAGE_LAYER_MAIN,
         "views":[VIEW_MOTD_CHECKIN_REWARDS],
         "tutorialView":VIEW_UI_TUTORIAL_LOGIN_REWARDS,
         "enableCloseByESC":true,
         "onboardingESC":true
      });
      
      public static const PAGE_CHARACTER_SELECT:CodoPageObj = new CodoPageObj({
         "id":PageID.CHARACTER_SELECT,
         "owner":PAGE_LAYER_MAIN,
         "views":[VIEW_CHARACTER_SELECT]
      });
      
      public static const PAGE_CHARACTER_SELECT_DETAILS:CodoPageObj = new CodoPageObj({
         "id":PageID.CHARACTER_SELECT_DETAILS,
         "owner":PAGE_LAYER_MAIN,
         "views":[VIEW_CHARACTER_SELECT_DETAILS],
         "enableCloseByESC":true,
         "onboardingESC":true
      });
      
      public static const PAGE_FSG_OPTIONS:CodoPageObj = new CodoPageObj({
         "id":PageID.FSG_OPTIONS,
         "owner":PAGE_LAYER_POPUP,
         "views":[VIEW_FSG_OPTIONS],
         "enableCloseByESC":true
      });
      
      public static const PAGE_FSG_CREATEROOMOPTIONS:CodoPageObj = new CodoPageObj({
         "id":PageID.FSG_CREATEROOMOPTIONS,
         "owner":PAGE_LAYER_POPUP,
         "views":[VIEW_FSG_CREATEROOMOPTIONS],
         "enableCloseByESC":true
      });
      
      public static const PAGE_POPUP_FSG_SUMMARY:CodoPageObj = new CodoPageObj({
         "id":PageID.SUMMARY,
         "owner":PAGE_LAYER_QUIT_GAME_CONFIRM_POPUP,
         "views":[VIEW_FSG_QUIT_GAME_SUMMARY],
         "enableCloseByESC":true,
         "onboardingESC":true
      });
      
      public static const PAGE_POPUP_JOIN_ROOM_PASSWORD:CodoPageObj = new CodoPageObj({
         "id":PageID.JOIN_ROOM_PASSWORD,
         "owner":PAGE_LAYER_ADV_POPUP,
         "views":[VIEW_JOIN_ROOM_PASSWORD],
         "enableCloseByESC":true
      });
      
      public static const PAGE_POPUP_FSG_QVIDEO:CodoPageObj = new CodoPageObj({
         "id":PageID.FSG_QVIDEO,
         "owner":PAGE_LAYER_POPUP,
         "views":[VIEW_FSG_QVIDEO_PANEL],
         "enableCloseByESC":false
      });
      
      public static const PAGE_POPUP_ONBOARD_RETURN_REWARDED:CodoPageObj = new CodoPageObj({
         "id":PageID.ONBOARDING_RETURN_REWARDED_POPUP,
         "owner":PAGE_LAYER_POPUP,
         "views":[VIEW_ONBOARD_RETURN_REWARDED_POPUP],
         "enableCloseByESC":true
      });
      
      public static const PAGE_POPUP_REWARD:CodoPageObj = new CodoPageObj({
         "id":PageID.REWARD_POPUP,
         "owner":PAGE_LAYER_SYS_MSG,
         "views":[VIEW_REWARD_POPUP_VIEW],
         "enableCloseByESC":true
      });
      
      public static const PAGE_POPUP_BATTLECITY_LEAGUE:CodoPageObj = new CodoPageObj({
         "id":PageID.BATTLECITY_LEAGUE_REWARD,
         "owner":PAGE_LAYER_POPUP,
         "views":[VIEW_BATTLECITYLEAGUE_REWARD_VIEW],
         "enableCloseByESC":true
      });
      
      public static const PAGE_POPUP_QUESTION:CodoPageObj = new CodoPageObj({
         "id":PageID.QUESTION,
         "owner":PAGE_LAYER_POPUP,
         "views":[VIEW_QUESTION]
      });
      
      public static const PAGE_POPUP_CHARACTER_SWAP:CodoPageObj = new CodoPageObj({
         "id":PageID.FSG_CHARACTERSWAP,
         "owner":PAGE_LAYER_POPUP,
         "views":[VIEW_CHARACTER_SWAP],
         "enableCloseByESC":false
      });
      
      public static const PAGE_POPUP_KILLSTREAK_SWAP:CodoPageObj = new CodoPageObj({
         "id":PageID.FSG_KILLSTREAKSWAP,
         "owner":PAGE_LAYER_BACKGROUND_POPUP,
         "views":[VIEW_KILLSTREAK_SWAP],
         "enableCloseByESC":false
      });
      
      public static const PAGE_POPUP_KILLSTREAK__SELECT_SWAP:CodoPageObj = new CodoPageObj({
         "id":PageID.FSG_KILLSTREAKSELECTSWAP,
         "owner":PAGE_LAYER_BACKGROUND_POPUP,
         "views":[VIEW_KILLSTREAK_SELECT_SWAP],
         "enableCloseByESC":false
      });
      
      public static const PAGE_POPUP_COMPLAINT_WINDOW:CodoPageObj = new CodoPageObj({
         "id":PageID.FSG_COMPLAINTWINDOW,
         "owner":PAGE_LAYER_ADV_POPUP,
         "views":[VIEW_COMPLAINT_WINDOW],
         "enableCloseByESC":true
      });
      
      public static const PAGE_POPUP_CHALLENGE_AWARD:CodoPageObj = new CodoPageObj({
         "id":PageID.FSG_CHALLENGEAWARD,
         "owner":PAGE_LAYER_POPUP,
         "views":[VIEW_CHALLENGE_AWARD],
         "enableCloseByESC":false
      });
      
      public static const PAGE_POPUP_ITEM_RESTRICTION_WARNING:CodoPageObj = new CodoPageObj({
         "id":PageID.ITEM_RESTRICTION_WARNING_POPUP,
         "owner":PAGE_LAYER_POPUP,
         "views":[VIEW_ITEM_RESTRICTION_WARNING_POPUP],
         "enableCloseByESC":true
      });
      
      public static const PAGE_POPUP_ITEM_RESTRICTION_PREVIEW:CodoPageObj = new CodoPageObj({
         "id":PageID.ITEM_RESTRICTION_PREVIEW_POPUP,
         "owner":PAGE_LAYER_POPUP,
         "views":[VIEW_ITEM_RESTRICTION_PREVIEW_POPUP],
         "enableCloseByESC":true
      });
      
      public static const PAGE_POPUP_PIN_CHALLENGE:CodoPageObj = new CodoPageObj({
         "id":PageID.PIN_CHALLENGE_POPUP,
         "owner":PAGE_LAYER_POPUP,
         "views":[VIEW_PIN_CHALLENGE_POPUP],
         "enableCloseByESC":true
      });
      
      public static const PAGE_CLAN:CodoPageObj = new CodoPageObj({
         "id":PageID.CLAN,
         "owner":PAGE_LAYER_POPUP,
         "views":[VIEW_CLAN,VIEW_SOCIAL_BAR],
         "tutorialView":VIEW_UI_TUTORIAL_CLAN,
         "enableCloseByESC":true
      });
      
      public static const PAGE_PARTY:CodoPageObj = new CodoPageObj({
         "id":PageID.PARTY,
         "owner":PAGE_LAYER_POPUP,
         "views":[VIEW_PARTY,VIEW_SOCIAL_BAR],
         "tutorialView":VIEW_UI_TUTORIAL_SOCIAL,
         "enableCloseByESC":true
      });
      
      public static const PAGE_CREATE_CLAN_POPUP:CodoPageObj = new CodoPageObj({
         "id":PageID.CREATE_CLAN_POPUP,
         "owner":PAGE_LAYER_ADV_POPUP,
         "views":[VIEW_CREATE_CLAN_POPUP],
         "enableCloseByESC":true
      });
      
      public static const PAGE_FRIEND:CodoPageObj = new CodoPageObj({
         "id":PageID.FRIEND,
         "owner":PAGE_LAYER_POPUP,
         "views":[VIEW_FRIEND,VIEW_SOCIAL_BAR],
         "tutorialView":VIEW_UI_TUTORIAL_SOCIAL,
         "enableCloseByESC":true
      });
      
      public static const PAGE_MAIL:CodoPageObj = new CodoPageObj({
         "id":PageID.MAIL,
         "owner":PAGE_LAYER_POPUP,
         "views":[VIEW_MAIL,VIEW_SOCIAL_BAR],
         "enableCloseByESC":true
      });
      
      public static const PAGE_GVOICE_SETTINGS:CodoPageObj = new CodoPageObj({
         "id":PageID.GVOICE_SETTINGS,
         "owner":PAGE_LAYER_GVOICE_SETTINGS,
         "views":[VIEW_GVOICE_SETTINGS],
         "enableCloseByESC":true
      });
      
      public static const PAGE_GVOICE_CHAT_PANEL:CodoPageObj = new CodoPageObj({
         "id":PageID.GVOICE_CHAT,
         "owner":PAGE_LAYER_GVOICE_CHAT_PANEL,
         "views":[VIEW_GVOICE_CHAT_PANEL],
         "enableCloseByESC":false
      });
      
      public static const PAGE_POPUP_FSG_PRESTIGE_UNLOCKED:CodoPageObj = new CodoPageObj({
         "id":PageID.FSG_PRESTIGE_UNLOCKED_POPUP,
         "owner":PAGE_LAYER_POPUP,
         "views":[VIEW_FSG_PRESTIGE_UNLOCKED_POPUP],
         "enableCloseByESC":false
      });
      
      public static const PAGE_POPUP_CHALLENGE_INFO:CodoPageObj = new CodoPageObj({
         "id":PageID.CHALLENGE_INFO_POPUP,
         "owner":PAGE_LAYER_POPUP,
         "views":[VIEW_CHALLENGE_INFO_POPUP],
         "enableCloseByESC":true
      });
      
      public static const PAGE_POPUP_TOKEN_BUY:CodoPageObj = new CodoPageObj({
         "id":PageID.TOKEN_BUY,
         "owner":PAGE_LAYER_POPUP,
         "views":[VIEW_TOKEN_BUY_POPUP],
         "enableCloseByESC":false
      });
      
      public static const PAGE_ADV_POPUP_PURCHASE_ADD_TO_CART:CodoPageObj = new CodoPageObj({
         "id":PageID.MARKET_PURCHASE_ADD_TO_CART,
         "owner":PAGE_LAYER_ADV_POPUP,
         "views":[VIEW_MARKET_PURCHASE_ADD_TO_CART],
         "enableCloseByESC":true
      });
      
      public static const PAGE_ADV_POPUP_PURCHASE_BUNDLE_ADD_TO_CART:CodoPageObj = new CodoPageObj({
         "id":PageID.MARKET_PURCHASE_ADD_TO_CART,
         "owner":PAGE_LAYER_ADV_POPUP,
         "views":[VIEW_MARKET_PURCHASE_BUNDLE_ADD_TO_CART],
         "enableCloseByESC":true
      });
      
      public static const PAGE_RECOMMENDED_LOADOUT_PURCHASE_REMAINDER_ITEMS:CodoPageObj = new CodoPageObj({
         "id":PageID.MARKET_PURCHASE_ADD_TO_CART,
         "owner":PAGE_LAYER_ADV_POPUP,
         "views":[VIEW_RECOMMENDED_LOADOUT_PURCHASE_REMAINDER_ITEMS_POPUP_VIEW],
         "enableCloseByESC":true
      });
      
      public static const PAGE_ADV_POPUP_LOADOUT_FULL:CodoPageObj = new CodoPageObj({
         "id":PageID.LOADOUT_FULL_POPUP,
         "owner":PAGE_LAYER_POPUP,
         "views":[VIEW_LOADOUT_FULL_POPUP],
         "enableCloseByESC":true
      });
      
      public static const PAGE_ADV_POPUP_SLOT_LOCKED:CodoPageObj = new CodoPageObj({
         "id":PageID.LOADOUT_SLOT_LOCKED_POPUP,
         "owner":PAGE_LAYER_POPUP,
         "views":[VIEW_LOADOUT_SLOT_LOCKED_POPUP],
         "enableCloseByESC":true
      });
      
      public static const PAGE_ADV_POPUP_RECOMMENDED_LOADOUT:CodoPageObj = new CodoPageObj({
         "id":PageID.RECOMMENDED_LOADOUT_POPUP,
         "owner":PAGE_LAYER_BACKGROUND_POPUP,
         "views":[VIEW_RECOMMENDED_LOADOUT_POPUP],
         "enableCloseByESC":true
      });
      
      public static const PAGE_POPUP_ASYM_PURCHASE:CodoPageObj = new CodoPageObj({
         "id":PageID.ASYM_PURCHASE_POPUP,
         "owner":PAGE_LAYER_POPUP,
         "views":[VIEW_ASYM_PURCHASE],
         "enableCloseByESC":true
      });
      
      public static const PAGE_POPUP_CLAIM_ONBOARDING_REWARD:CodoPageObj = new CodoPageObj({
         "id":PageID.ONBOARDING_CLAIM_CHALLENGE_REWARD,
         "owner":PAGE_LAYER_SYS_MSG,
         "views":[VIEW_CLAIM_ONBOARDING_REWARD_VIEW]
      });
      
      public static const PAGE_ADV_FSG_MATCH_RESULT:CodoPageObj = new CodoPageObj({
         "id":PageID.FSG_MATCHRESULT,
         "owner":PAGE_LAYER_BACKGROUND_POPUP,
         "views":[VIEW_ZHUNT_REWARD_VIEW,VIEW_BATTLECITYLEAGUE_AWARD_VIEW,VIEW_FSG_MATCH_RESULT],
         "tutorialView":VIEW_UI_TUTORIAL_AAR,
         "enableCloseByESC":true,
         "bypassDrawMask":true
      });
      
      public static const PAGE_ADV_FSG_MATCH_RESULT_REWARD:CodoPageObj = new CodoPageObj({
         "id":PageID.FSG_MATCHRESULT_REWARD,
         "owner":PAGE_LAYER_BACKGROUND_POPUP,
         "views":[VIEW_FSG_MATCH_RESULT_REWARD],
         "enableCloseByESC":false
      });
      
      public static const PAGE_LOGIN_QUEUE:CodoPageObj = new CodoPageObj({
         "id":PageID.LOGIN_QUEUE,
         "owner":PAGE_LAYER_ADV_POPUP,
         "views":[VIEW_LOGIN_QUEUE]
      });
      
      public static const PAGE_ADV_RENAME_LOADOUT:CodoPageObj = new CodoPageObj({
         "id":PageID.RENAME_LOADOUT,
         "owner":PAGE_LAYER_ADV_POPUP,
         "views":[VIEW_RENAME_LOADOUT],
         "enableCloseByESC":true
      });
      
      public static const PAGE_ADV_EDIT_CLAN_MOTTO:CodoPageObj = new CodoPageObj({
         "id":PageID.CLAN_MOTTO,
         "owner":PAGE_LAYER_ADV_POPUP,
         "views":[VIEW_EDIT_CLAN_MOTTO],
         "enableCloseByESC":true
      });
      
      public static const PAGE_ADV_EDIT_CLAN_MSG:CodoPageObj = new CodoPageObj({
         "id":PageID.CLAN_MSG,
         "owner":PAGE_LAYER_ADV_POPUP,
         "views":[VIEW_EDIT_CLAN_MSG],
         "enableCloseByESC":true
      });
      
      public static const PAGE_QUIT:CodoPageObj = new CodoPageObj();
      
      public static const PAGE_POPUP_MAP_SPECIFIC_REWARDS:CodoPageObj = new CodoPageObj({
         "id":PageID.MAP_SPECIFIC_REWARDS,
         "owner":PAGE_LAYER_POPUP,
         "views":[VIEW_MAP_SPECIFIC_REWARDS],
         "enableCloseByEsc":false
      });
      
      public static const PAGE_WEB_IMG:CodoPageObj = new CodoPageObj({
         "id":PageID.WEB_IMG,
         "owner":PAGE_LAYER_WEBIMG,
         "views":[TOP_VIEW_WEBIMG],
         "enableCloseByEsc":false
      });
      
      public static const PAGE_CHANGE_NAME:CodoPageObj = new CodoPageObj({
         "id":PageID.CHANGE_NAME,
         "owner":PAGE_LAYER_ADV_POPUP,
         "views":[VIEW_CHANGE_NAME],
         "enableCloseByESC":true
      });
      
      public static const PAGE_PLAYER_DETAIL_INFO:CodoPageObj = new CodoPageObj({
         "id":PageID.PLAYER_DETAIL_INFO,
         "owner":PAGE_LAYER_ADV_POPUP,
         "views":[VIEW_PLAYER_DETAIL_POPUP],
         "enableCloseByESC":false
      });
      
      public static const PAGES:Array = [PAGE_ACTIVITY_MSG_FSG,PAGE_SYS_MSG_FSG,PAGE_MAIL,PAGE_WARGOD_SEASON_REWARD,PAGE_POPUP_REWARD,PAGE_RECOMMENDATION_MSG_FSG];
      
      public function CodoPageViewDB()
      {
         super();
      }
   }
}

