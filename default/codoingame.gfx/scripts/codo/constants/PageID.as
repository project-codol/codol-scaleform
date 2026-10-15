package codo.constants
{
   import codo.common.CFunctionCommonContainer;
   import codo.utils.Logger;
   import flash.utils.Dictionary;
   import flash.utils.describeType;
   
   public class PageID
   {
      
      private static var _socialPopups:Object;
      
      public static const BG:String = "bg";
      
      public static const SYS_MSG:String = "sys_msg";
      
      public static const ACTIVITY_MSG:String = "activity_msg";
      
      public static const WARGOD_SEASON_REWARD:String = "wargod_season_reward";
      
      public static const RECOMMENDATION_MSG:String = "recommendation_msg";
      
      public static const LANG_BAR:String = "lang_bar";
      
      public static const TIP:String = "tip";
      
      public static const LETTERBOX:String = "letterbox";
      
      public static const CHARACTER_CREATION:String = "charactercreation";
      
      public static const HOME:String = "home";
      
      public static const HOME_CHARACTER:String = "home_character";
      
      public static const HOME_WEAPON:String = "home_weapon";
      
      public static const WEAPON:String = "weapon";
      
      public static const MARKET_CALLSIGN:String = "market_callsign";
      
      public static const ITEM:String = "item";
      
      public static const INROOM:String = "inroom";
      
      public static const MARKET:String = "market";
      
      public static const MARKET_OLD:String = "market_old";
      
      public static const MARKET_ITEM_DETAILS:String = "market_item_details";
      
      public static const CHARACTER_SELECT_DETAILS:String = "character_select_details";
      
      public static const MARKET_COMPARE:String = "market_compare";
      
      public static const SHOPPING_CART:String = "shopping_cart";
      
      public static const SHOPPING_CART_CONFIRM_POPUP:String = "shopping_cart_confirm_popup";
      
      public static const CAREER:String = "user_careerinfo";
      
      public static const FSG_PLAYERCARD:String = "fsg_playercard";
      
      public static const CAREER_TABS:String = "career_tabs";
      
      public static const CAREER_BATTLE_EXPERIENCE:String = "career_battle_experience";
      
      public static const CAREER_CHALLENGES:String = "career_challenges";
      
      public static const SCOREBOARD:String = "scoreboard";
      
      public static const TOKEN_BUY:String = "token_buy";
      
      public static const SUMMARY:String = "summary";
      
      public static const COOP_EOG:String = "coop_eog";
      
      public static const QUESTION:String = "question";
      
      public static const PURCHASE_ENABLED_TOKEN_PROMPT:String = "purchase_enabled_prompt";
      
      public static const JOIN_ROOM_PASSWORD:String = "join_room_password";
      
      public static const MARKET_PURCHASE_CONFIRM:String = "market_purchase_confirm";
      
      public static const MARKET_PURCHASE_ADD_TO_CART:String = "market_purchase_add_to_cart";
      
      public static const MARKET_ADD_TO_CART_CONFIRM:String = "market_add_to_cart_confirm";
      
      public static const LOADOUT_FULL_POPUP:String = "loadout_full_popup";
      
      public static const LOADOUT_SLOT_LOCKED_POPUP:String = "loadout_slot_locked_popup";
      
      public static const RECOMMENDED_LOADOUT_POPUP:String = "recommended_loadout_popup";
      
      public static const ASYM_PURCHASE_POPUP:String = "asym_purchase_popup";
      
      public static const LOADOUT_SELECTION:String = "loadout_selection";
      
      public static const LOGIN:String = "login";
      
      public static const CHARACTER_SELECT:String = "character_select";
      
      public static const CHARACTER_ROSTER:String = "character_roster";
      
      public static const ONBOARDING_WELCOME_NEW_PLAYER:String = "onboard_welcome_new_player";
      
      public static const ONBOARDING_EXPERIENCE_SELECT:String = "onboard_experience_select";
      
      public static const ONBOARDING_PLAYER_TRAINING_INTRO:String = "onboard_player_training_intro";
      
      public static const ONBOARDING_RETURN_REWARDED_POPUP:String = "onboard_return_rewarded_popup";
      
      public static const ONBOARDING_KEYBOARD_SELECT:String = "onboard_keyboard_select_view";
      
      public static const ONBOARDING_CLAIM_CHALLENGE_REWARD:String = "onboard_claim_challenge_reward_view";
      
      public static const ONBOARDING_UI_CHALLENGE_COMPLETE:String = "onboard_ui_challenge_complete";
      
      public static const MOTD_NOTIFICATIONS_POPUP:String = "motd_notifications_popup";
      
      public static const MOTD_CHECKIN_REWARDS:String = "motd_checkin_rewards";
      
      public static const FSG_PRESTIGE_UNLOCKED_POPUP:String = "fsg_prestige_unlocked_popup";
      
      public static const FSG_ONBOARDING_CHALLENGE_TOUR:String = "fsg_onboard_challenge_tour";
      
      public static const FSG_ONBOARDING_TRAINING_REWARDS:String = "fsg_onboarding_training_rewards";
      
      public static const FSG_ONBOARDING_TRAINING_REWARDS_POPUP:String = "fsg_onboarding_training_rewards_popup";
      
      public static const PERSISTENT:String = "persistent";
      
      public static const FSG_LOADOUT:String = "fsg_loadout";
      
      public static const FSG_OPTIONS:String = "fsg_options";
      
      public static const FSG_CREATEROOMOPTIONS:String = "fsg_createroomoptions";
      
      public static const CLAN:String = "clan";
      
      public static const PARTY:String = "party";
      
      public static const FRIEND:String = "friend";
      
      public static const MAIL:String = "mail";
      
      public static const CREATE_CLAN_POPUP:String = "create_clan_popup";
      
      public static const CHALLENGE_INFO_POPUP:String = "challenge_info_popup";
      
      public static const DAILY_CHALLENGE_STATUS_POPUP:String = "daily_challenge_status_popup";
      
      public static const ITEM_RESTRICTION_WARNING_POPUP:String = "item_restriction_warning_popup";
      
      public static const ITEM_RESTRICTION_PREVIEW_POPUP:String = "item_restriction_preview_popup";
      
      public static const PIN_CHALLENGE_POPUP:String = "pin_challenge_popup";
      
      public static const GVOICE_SETTINGS:String = "gvoice_settings";
      
      public static const GVOICE_CHAT:String = "gvoice_chat";
      
      public static const FSG_GAME_MODES_TUTORIAL_POPUP:String = "fsg_game_modes_tutorial_popup";
      
      public static const GAME_MODES_IMAGES_POPUP:String = "game_modes_images_popup";
      
      public static const VIDEO_PLAYER:String = "video_player";
      
      public static const MATCH_SELECT:String = "match_select";
      
      public static const LAUNCH_TRAINING:String = "launch_training";
      
      public static const LEADERBOARD:String = "leaderboard";
      
      public static const FSG_MATCHRESULT:String = "fsg_matchresult";
      
      public static const FSG_MATCHRESULT_REWARD:String = "fsg_matchresult_reward";
      
      public static const FSG_SOCIAL:String = "fsg_social";
      
      public static const FSG_QVIDEO:String = "fsg_qvideo";
      
      public static const LOGIN_QUEUE:String = "login_queue";
      
      public static const MAP_SPECIFIC_REWARDS:String = "map_specific_rewards_popup";
      
      public static const RENAME_LOADOUT:String = "rename_loadout";
      
      public static const CLAN_MOTTO:String = "clan_motto";
      
      public static const CLAN_MSG:String = "clan_msg";
      
      public static const WEB_IMG:String = "web_img";
      
      public static const CHANGE_NAME:String = "change_name";
      
      public static const PLAYER_DETAIL_INFO:String = "player_detail_info";
      
      public static const NEW_MAIL_NOTIFICATION:String = "new_mail_notification";
      
      public static const FSG_CHARACTERSWAP:String = "character_swap";
      
      public static const FSG_KILLSTREAKSWAP:String = "killstreak_swap";
      
      public static const FSG_KILLSTREAKSELECTSWAP:String = "killstreak__select_swap";
      
      public static const FSG_CHALLENGEAWARD:String = "challenge_award";
      
      public static const FSG_COMPLAINTWINDOW:String = "complaint_window";
      
      public static const HUD_ASYM:String = "HudAsym";
      
      public static const HUD_CLASH:String = "HudClash";
      
      public static const HUD_SandR:String = "HudSandR";
      
      public static const HUD_Survival:String = "HudSurvival";
      
      public static const SUPPLY_DROP:String = "supply_drop";
      
      public static const SUPPLY_DROP_REWARD_SELECTION:String = "supply_drop_reward_selection";
      
      public static const SUPPLY_DROP_DEPENDENCY_POPUP:String = "supply_drop_dependency_popup";
      
      public static const SUPPLY_DROP_ITEMS_TO_WIN_POPUP:String = "supply_drop_items_to_win_popup";
      
      public static const QUIT_GAME_WARNING_POPUP:String = "fsg_quit_game_warning_popup";
      
      public static const UI_TUTORIAL_INGAME:String = "ui_tutorial_ingame";
      
      public static const FLOATING_PLAYER_INFO:String = "floating_player_info";
      
      public static const HIDDEN_ROOM_MATCH_START_MSG:String = "hidden_room_match_start_msg";
      
      public static const REWARD_POPUP:String = "reward_popup";
      
      public static const BATTLECITY_LEAGUE_REWARD:String = "battlecity_league_reward";
      
      private static var TLogPageID:Object = {
         "bg":1,
         "sys_msg":2,
         "activity_msg":3,
         "lang_bar":4,
         "tip":5,
         "charactercreation":6,
         "home":7,
         "home_character":10,
         "home_weapon":11,
         "weapon":12,
         "character":13,
         "market_callsign":14,
         "item":16,
         "inroom":17,
         "market":18,
         "user_careerinfo":19,
         "fsg_playercard":20,
         "user_careerinfo_level":25,
         "scoreboard":26,
         "token_buy":29,
         "summary":30,
         "video_player":31,
         "coop_eog":32,
         "question":33,
         "join_room_password":34,
         "purchase_cofirm":36,
         "login":37,
         "character_select":41,
         "fsg_onboard_gamemode_select":43,
         "fsg_onboard_rewards":44,
         "fsg_onboard_character_inventory":45,
         "fsg_onboard_ui_tour_welcome":46,
         "fsg_ui_stencils_landing":47,
         "fsg_ui_stencils_prestige_welcome":48,
         "fsg_ui_stencils_prestige":49,
         "fsg_prestige_unlocked_popup":50,
         "fsg_ui_stencils_loadut":51,
         "fsg_ui_stencils_customisation":52,
         "fsg_onboard_challenge_tour":54,
         "fsg_onboarding_training_rewards":56,
         "fsg_onboarding_training_rewards_popup":57,
         "fsg_persistent":58,
         "fsg_loadout":59,
         "fsg_options":60,
         "fsg_matchresult":66,
         "fsg_matchresult_reward":67,
         "fsg_social":68,
         "fsg_qvideo":69,
         "login_queue":71,
         "map_specific_rewards_popup":72,
         "rename_loadout":73,
         "clan_motto":74,
         "clan_msg":75,
         "web_img":81,
         "change_name":82,
         "character_swap":83,
         "killstreak_swap":84,
         "challenge_award":85,
         "complaint_window":86,
         "fsg_quit_game_warning_popup":87,
         "HudAsym":88,
         "fsg_game_modes_tutorial_popup":89,
         "purchase_enabled_prompt":90,
         "asym_purchase_popup":91,
         "HudClash":92,
         "market_item_details":93,
         "market_old":94,
         "market_compare":95,
         "HudSandR":96,
         "loadout_customization_selection":98,
         "market_purchase_confirm":99,
         "market_add_to_cart_confirm":100,
         "loadout_full_popup":101,
         "loadout_slot_locked_popup":102,
         "shopping_cart":103,
         "shopping_cart_confirm_popup":104,
         "market_purchase_add_to_cart":105,
         "persistent":106,
         "loadout_selection":107,
         "character_roster":108,
         "killstreak__select_swap":110,
         "supply_drop":111,
         "supply_drop_reward_selection":112,
         "supply_drop_dependency_popup":113,
         "supply_drop_duplicate_item_popup":114,
         "onboard_welcome_new_player":116,
         "character_select_details":117,
         "onboard_player_training_intro":118,
         "clan":119,
         "create_clan_popup":120,
         "match_select":121,
         "challenge_info_popup":122,
         "ui_tutorial_ingame":123,
         "player_detail_info":124,
         "onboard_return_rewarded_popup":126,
         "leaderboard":127,
         "fsg_createroomoptions":128,
         "career_tabs":129,
         "career_battle_experience":130,
         "career_challenges":131,
         "supply_drop_items_to_win_popup":132,
         "daily_challenge_status_popup":133,
         "friend":134,
         "mail":135,
         "party":136,
         "new_mail_notification":137,
         "item_restriction_warning_popup":139,
         "item_restriction_preview_popup":140,
         "pin_challenge_popup":141,
         "motd_notifications_popup":142,
         "motd_checkin_rewards":143,
         "wargod_season_reward":144,
         "onboard_experience_select":145,
         "onboard_keyboard_select_view":146,
         "HudSurvival":147,
         "onboard_claim_challenge_reward_view":148,
         "letterbox":149,
         "onboard_ui_challenge_complete":150,
         "floating_player_info":151,
         "recommended_loadout_popup":152,
         "game_modes_images_popup":153,
         "launch_training":154,
         "hidden_room_match_start_msg":155,
         "reward_popup":156,
         "battlecity_league_reward":157,
         "recommendation_msg":158,
         "gvoice_settings":159,
         "gvoice_chat":160
      };
      
      private static var validated:Boolean = false;
      
      public function PageID()
      {
         super();
      }
      
      public static function getSocialPopups() : Object
      {
         if(_socialPopups == null)
         {
            _socialPopups = {};
            _socialPopups[CLAN] = true;
            _socialPopups[LEADERBOARD] = true;
            _socialPopups[FRIEND] = true;
            _socialPopups[PARTY] = true;
            _socialPopups[MAIL] = true;
         }
         return _socialPopups;
      }
      
      public static function Validate() : void
      {
         var constant:XML = null;
         var ids:Dictionary = null;
         var key:String = null;
         if(validated == true)
         {
            return;
         }
         var constants:XMLList = describeType(PageID)..constant;
         for each(constant in constants)
         {
            Logger.print(constant.@name,PageID[constant.@name]);
            if(TLogPageID[PageID[constant.@name]] == undefined)
            {
               CFunctionCommonContainer.Assert(false,new Error("TLogPageID is missing the field \'" + PageID[constant.@name] + "\'.  Please add it in PageID.as"));
            }
         }
         ids = new Dictionary();
         for(key in TLogPageID)
         {
            if(Boolean(ids[TLogPageID[key]]))
            {
               CFunctionCommonContainer.Assert(false,new Error("TLogPageID has duplicate ID " + TLogPageID[key]));
            }
            else
            {
               ids[TLogPageID[key]] = true;
            }
         }
         validated = true;
      }
      
      public static function GetTLogPageID(pageID:String) : int
      {
         if(Boolean(CFunctionCommonContainer.IsDevelopmentBuild()))
         {
            Validate();
         }
         return int(TLogPageID[pageID]);
      }
   }
}

