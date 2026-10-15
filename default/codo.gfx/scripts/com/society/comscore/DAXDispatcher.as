package com.society.comscore
{
   import codo.common.CFunctionCommonContainer;
   import codo.constants.DataID;
   import codo.constants.PlayListType;
   import codo.constants.QuickMatchType;
   import codo.constants.table.Mode;
   import codo.manager.DataManager;
   import codo.utils.Logger;
   import codo.utils.TableUtil;
   import flash.events.TimerEvent;
   import flash.net.*;
   import flash.utils.Timer;
   
   public class DAXDispatcher
   {
      
      private static var BAD_USER_ID:Number;
      
      private static var USER_ID:String;
      
      private static var GP_BALANCE:int;
      
      private static var CP_BALANCE:int;
      
      private static var QQVIP_STATUS:String;
      
      private static var NETCAFE_STATUS:String;
      
      private static var TGP_STATUS:String;
      
      private static var CLAN_ID:int;
      
      private static var BUILD_NUMBER:int;
      
      private static var DURATION_TOTAL:int;
      
      private static var RECOMMENDED_ITEMS:String;
      
      private static var SESSION_ID:String;
      
      public static var CURRENT_GAME_VARIANT:String;
      
      public static var CURRENT_GAME_MODE:String;
      
      public static var DIFFICULTY_LEVEL:String;
      
      public static var sendScreensTimer:Timer;
      
      private static var COMSCORE_SSL_URL:String = "https://sb.scorecardresearch.com/p2?c1=19&c2=14880931&ns_site=dev&site=codol-dev";
      
      private static var INITIAL_TIMESTAMP:Number = getCurrentTime();
      
      private static var SAMPLE_RATE:int = 0;
      
      private static var PREV_SCREEN_VIEW:String = "";
      
      private static var CURRENT_SCREEN_VIEW:String = "";
      
      private static var buffer:Object = new Object();
      
      private static var isScreenBufferInit:Boolean = false;
      
      private static var screenCount:int = 0;
      
      private static var screenBuffer:Object = new Object();
      
      private static var lastScreenViewed:String = "";
      
      private static var lastScreenIdViewed:String = "";
      
      private static var SCREEN_DURATION:Number = 0;
      
      private static var SCREEN_START_TIME:Number = getCurrentTime();
      
      private static var SCREEN_NAME_LEVELS:Array = [];
      
      public static var IS_READY:Boolean = false;
      
      public function DAXDispatcher()
      {
         super();
      }
      
      public static function daxInitialise(sampleRate:int, startScreenTimer:Boolean) : void
      {
         var badUserId:Number = NaN;
         var userId:String = null;
         var comScoreURL:String = null;
         var sessionId:String = null;
         var buildNumber:int = 0;
         var clanInfo:Object = null;
         var clanId:Number = NaN;
         try
         {
            badUserId = Number(CFunctionCommonContainer.GetPlayerID());
            userId = CFunctionCommonContainer.GetPlayerID();
            comScoreURL = CFunctionCommonContainer.Dvar_GetString("dax_comscore_url");
            sessionId = CFunctionCommonContainer.GetDWConnectionID();
            buildNumber = CFunctionCommonContainer.GetBuildNumber();
            clanInfo = CFunctionCommonContainer.GetClanInfo();
            Logger.print("DAXDispatcher: dax_comscore_url - " + comScoreURL);
            Logger.print("DAXDispatcher: dax_sample_rate - " + sampleRate);
            if(clanInfo == null)
            {
               clanId = 0;
            }
            else
            {
               clanId = Number(clanInfo.id);
            }
            DAXDispatcher.setComScoreUrl(comScoreURL);
            DAXDispatcher.setSessionId(sessionId);
            DAXDispatcher.setUserId(userId,badUserId);
            DAXDispatcher.setSampleRate(sampleRate);
            DAXDispatcher.setClanId(clanId);
            DAXDispatcher.setBuildNumber(buildNumber);
            if(startScreenTimer)
            {
               DAXDispatcher.startTimer();
            }
            if(comScoreURL != "" && sampleRate != 0)
            {
               DAXDispatcher.setIsReady(true);
            }
            else
            {
               DAXDispatcher.setIsReady(false);
            }
         }
         catch(e:Error)
         {
            Logger.print("!!! DAXDispatcher: " + e.message);
         }
      }
      
      public static function startTimer() : void
      {
         sendScreensTimer = new Timer(300000,0);
         sendScreensTimer.addEventListener("timer",timerHandler);
         sendScreensTimer.start();
      }
      
      private static function timerHandler(event:TimerEvent) : void
      {
         if(screenCount > 0)
         {
            Logger.print("*** DAXDispatcher: Timer is dispatching " + screenCount + " screens.");
            dispatchScreens("time");
         }
      }
      
      public static function dispatch() : void
      {
         var additionalQueryParams:String = null;
         try
         {
            if(!IS_READY || COMSCORE_SSL_URL == "")
            {
               buffer = new Object();
               return;
            }
            if(!isInSamplePool())
            {
               buffer = new Object();
               return;
            }
            additionalQueryParams = constructQueryParams(buffer);
            performURLRequest(additionalQueryParams);
            buffer = new Object();
         }
         catch(e:Error)
         {
            Logger.print("*** DAXDispatcher: " + e.message);
         }
      }
      
      private static function performURLRequest(additionalQueryParams:String) : void
      {
         if(!IS_READY || COMSCORE_SSL_URL == "")
         {
            return;
         }
         var request:URLRequest = new URLRequest(COMSCORE_SSL_URL);
         request.url += additionalQueryParams + "&ns_ts=" + getCurrentTime() + "&visitorid=" + BAD_USER_ID + "&new_visitorid=" + USER_ID + "&session_id=" + SESSION_ID + "&gp_balance=" + GP_BALANCE + "&cp_balance=" + CP_BALANCE + "&clan_id=" + CLAN_ID + "&game_version=" + BUILD_NUMBER + "&recommended_items=" + RECOMMENDED_ITEMS;
         Logger.print("*** DAXDispatcher: ComScore Request: " + request.url);
         var loader:URLLoader = new URLLoader();
         loader.load(request);
      }
      
      public static function OnMatchStart() : void
      {
         var page:String = null;
         if(screenCount == 0)
         {
            page = DataManager.getInstance().getDP(DataID.CURRENT_PAGE_ID_AT_HIGHEST_DEPTH);
            setScreenAtLevel(page);
            page = DAXDispatcher.getScreenString();
            queueScreen(page);
         }
         var cacheMe:String = screenCount > 0 ? constructScreenParams(screenBuffer) : "";
         CFunctionCommonContainer.AS_CacheComScoreScreenBuffer(cacheMe);
      }
      
      private static function dispatchScreensOnMatchStart() : void
      {
         var cachedScreenBuffer:String = CFunctionCommonContainer.AS_RetreiveComScoreScreenBuffer();
         if(cachedScreenBuffer != "")
         {
            performURLRequest(cachedScreenBuffer);
         }
      }
      
      public static function dispatchScreens(triggeredBy:String) : void
      {
         var additionalQueryParams:String = constructScreenParams(screenBuffer);
         additionalQueryParams += "&triggered_by=" + triggeredBy;
         performURLRequest(additionalQueryParams);
         screenBuffer = new Object();
         screenBuffer["name"] = "";
         screenBuffer["screen_duration"] = "";
         screenCount = 0;
      }
      
      public static function setGameVariant(variant:String) : void
      {
         CURRENT_GAME_VARIANT = variant;
      }
      
      public static function setGameModeByType(gameModeType:uint) : void
      {
         var matchType:QuickMatchType = null;
         var modeName:String = "";
         if(gameModeType == PlayListType.RANKED)
         {
            modeName = "ranked";
         }
         else if(gameModeType == PlayListType.COMBAT)
         {
            modeName = "combat";
         }
         else if(gameModeType == PlayListType.TUTORIAL)
         {
            modeName = "tutorial";
         }
         else if(PlayListType.isPveType(gameModeType))
         {
            matchType = QuickMatchType.fromPlaylistType(gameModeType);
            modeName = matchType.getCoopModeID();
         }
         else
         {
            modeName = "none";
         }
         setScreenAtLevel(modeName,true);
         queueScreen(getScreenString());
         CURRENT_GAME_MODE = modeName;
      }
      
      public static function setGameVariantByType(gameModeType:QuickMatchType) : void
      {
         var modeName:String = "";
         if(gameModeType.isPvp())
         {
            modeName = "mp";
         }
         else if(gameModeType.isCoopMap())
         {
            modeName = gameModeType.getCoopModeID();
         }
         else
         {
            modeName = "none";
         }
         setGameVariant(modeName);
      }
      
      public static function setScreenAtLevel(screenName:String, isLobby:Boolean = false) : void
      {
         var level:int = 0;
         var newValue:String = "";
         lastScreenIdViewed = screenName;
         switch(screenName)
         {
            case "market":
               level = 0;
               newValue = "market";
               break;
            case "home_new":
               level = 0;
               newValue = "main_menu";
               break;
            case "fsg_career":
               level = 0;
               newValue = "career";
               break;
            case "fsg_loadout":
               level = 0;
               newValue = "inventory";
               break;
            case "fsg_social":
               level = 0;
               newValue = "social";
               break;
            case "fsg_playercard":
               level = 0;
               newValue = "profile";
               break;
            case "fsg_options":
               level = 0;
               newValue = "settings";
               break;
            case "summary":
               level = 0;
               newValue = "quit_summary";
               break;
            case "inroom":
               level = 0;
               newValue = "lobby";
               break;
            case "fsg_matchresult":
               level = 1;
               newValue = "match_result";
               break;
            case "fsg_mp_gamemodes_training":
               level = 1;
               newValue = "recruit_training";
               break;
            case "quick_match_coop":
               level = 1;
               newValue = "coop";
               break;
            case "fsg_mp_gamemodes_quickmatch":
               level = 1;
               newValue = "mp";
               break;
            case "fsg_mp_gamemodes_createroom":
               level = 1;
               newValue = "mp";
               break;
            case "fsg_career_challenges":
               level = 1;
               newValue = "career.challenges";
               break;
            case "fsg_career_map":
               level = 1;
               newValue = "career.map";
               break;
            case "market.primary":
               level = 1;
               newValue = screenName;
               break;
            case "market.secondary":
               level = 1;
               newValue = screenName;
               break;
            case "market.equipment":
               level = 1;
               newValue = screenName;
               break;
            case "market.perk":
               level = 1;
               newValue = screenName;
               break;
            case "market.kis":
               level = 1;
               newValue = "market.killstreak";
               break;
            case "market.character":
               level = 1;
               newValue = "market.character";
               break;
            case "market.cha":
               level = 1;
               newValue = "market.callsign";
               break;
            case "@SF_UI_MAIN_MENU_LABEL_MESSAGEBOX_SHORT_NAME":
               level = 0;
               newValue = "messages";
               break;
            case "@SF_UI_MAIN_MENU_LABEL_LEADERBOARD":
               level = 0;
               newValue = "leaderboard";
               break;
            case "@SF_UI_MAIN_MENU_LABEL_CONTACT":
               level = 0;
               newValue = "friends";
               break;
            case "@SF_UI_MAIN_MENU_LABEL_CLAN":
               level = 0;
               newValue = "clan";
               break;
            case "@SF_UI_MAIN_MENU_LABEL_QT":
               level = 0;
               newValue = "QT";
               break;
            case "@SF_UI_MAIN_MENU_LABEL_QVideo_SHORT_NAME":
               level = 0;
               newValue = "QTVideo";
               break;
            default:
               if(isLobby)
               {
                  level = 0;
                  newValue = "gamelobby." + screenName;
               }
               else
               {
                  newValue = screenName;
               }
         }
         SCREEN_NAME_LEVELS[0] = newValue;
         lastScreenViewed = newValue;
      }
      
      public static function getScreenString() : String
      {
         var s:String = "codol.";
         return s + SCREEN_NAME_LEVELS.join(".");
      }
      
      private static function isInSamplePool() : Boolean
      {
         if(USER_ID.length < 2)
         {
            Logger.print("*** DAXDispatcher: UserID is NOT in sample pool.  NOT sending values to DAX.");
            return false;
         }
         var lastTwoDigits:String = USER_ID.substr(USER_ID.length - 2,2);
         var lastTwoDigitsAsInt:int = parseInt(lastTwoDigits);
         if(SAMPLE_RATE > lastTwoDigitsAsInt)
         {
            Logger.print("*** DAXDispatcher: UserID is in sample pool.  Sending values to DAX.");
            return true;
         }
         Logger.print("*** DAXDispatcher: UserID is NOT in sample pool.  NOT sending values to DAX.");
         return false;
      }
      
      private static function constructQueryParams(params:Object) : String
      {
         var key:String = null;
         var pattern:RegExp = null;
         var value:String = null;
         var additionalQueryParams:String = "";
         var clientConnectionTime:int = CFunctionCommonContainer.GetDWConnectionTime();
         queue("duration_total",String(clientConnectionTime));
         var screen_id:String = lastScreenIdViewed;
         var screen_name:String = lastScreenViewed;
         var actionType:String = buffer["action_type"];
         var name:String = buffer["name"];
         if(actionType != null && actionType != "")
         {
            if(screen_id == "")
            {
               screen_id = actionType;
            }
            if(screen_name == "")
            {
               screen_name = actionType;
            }
            if(name == "")
            {
               name = actionType;
            }
         }
         queue("screen_id",screen_id);
         queue("screen_name",screen_name);
         queue("name",name);
         for(key in params)
         {
            pattern = /@/;
            value = params[key].replace(pattern,"");
            additionalQueryParams += "&" + key + "=" + value;
         }
         return additionalQueryParams + ("&ns_type=hidden" + "&qqvip_status=" + QQVIP_STATUS + "&netcafe_status=" + NETCAFE_STATUS + "&tgp_status=" + TGP_STATUS);
      }
      
      private static function constructScreenParams(params:Object) : String
      {
         var screenNameParam:String = screenBuffer["name"];
         screenNameParam = screenNameParam.slice(0,-1);
         var screenTimeParam:String = screenBuffer["screen_duration"];
         screenTimeParam = screenTimeParam.slice(0,-1);
         var retParam:String = "&name=" + screenNameParam + "&screen_duration=" + screenTimeParam + "&action_type=screen_view";
         return retParam + ("&screen_count=" + screenCount + "&ns_type=view");
      }
      
      public static function queueScreen(key:String) : void
      {
         var bufferTooBig:Boolean = false;
         var additionalQueryParams:String = null;
         try
         {
            if(!isScreenNameIsNew(key))
            {
               return;
            }
            if(isScreenBufferInit == false)
            {
               screenBuffer["name"] = "";
               screenBuffer["screen_duration"] = "";
               isScreenBufferInit = true;
            }
            screenBuffer["name"] += PREV_SCREEN_VIEW + ",";
            screenBuffer["screen_duration"] += SCREEN_DURATION + ",";
            screenCount += 1;
            bufferTooBig = false;
            if(screenCount > 20)
            {
               additionalQueryParams = constructScreenParams(screenBuffer);
               if(additionalQueryParams.length + 300 > 1400)
               {
                  Logger.print("*** DAXDispatcher: ComScore Screen parameter url getting too large at: " + (additionalQueryParams.length + 300));
                  bufferTooBig = true;
                  dispatchScreens("queue_full");
               }
            }
         }
         catch(e:Error)
         {
            Logger.print("*** DAXDispatcher: Error adding to screenBuffer " + e.message);
         }
      }
      
      public static function queue(key:String, value:String) : void
      {
         try
         {
            buffer[key] = value;
            if(value == "match_start")
            {
               dispatchScreensOnMatchStart();
            }
            else if(value == "match_end" || value == "game_exit")
            {
               dispatchScreens("critical_event");
            }
         }
         catch(e:Error)
         {
            Logger.print("*** DAXDispatcher: " + e.message);
         }
      }
      
      public static function isScreenNameIsNew(screenName:String) : Boolean
      {
         var c_time:Number = NaN;
         if(CURRENT_SCREEN_VIEW == "")
         {
            CURRENT_SCREEN_VIEW = screenName;
            return false;
         }
         if(screenName != CURRENT_SCREEN_VIEW)
         {
            c_time = getCurrentTime();
            SCREEN_DURATION = c_time - SCREEN_START_TIME;
            SCREEN_START_TIME = c_time;
            PREV_SCREEN_VIEW = CURRENT_SCREEN_VIEW;
            CURRENT_SCREEN_VIEW = screenName;
            return true;
         }
         return false;
      }
      
      public static function setUserId(id:String, badID:Number) : void
      {
         try
         {
            USER_ID = id;
            BAD_USER_ID = badID;
         }
         catch(e:Error)
         {
            Logger.print("*** DAXDispatcher: " + e.message);
         }
      }
      
      public static function setComScoreUrl(url:String) : void
      {
         try
         {
            COMSCORE_SSL_URL = url;
         }
         catch(e:Error)
         {
            Logger.print("*** DAXDispatcher: " + e.message);
         }
      }
      
      public static function setSampleRate(rate:int) : void
      {
         try
         {
            SAMPLE_RATE = rate;
         }
         catch(e:Error)
         {
            Logger.print("*** DAXDispatcher: " + e.message);
         }
      }
      
      public static function getCurrentTime() : Number
      {
         var date:Date = new Date();
         return date.getTime();
      }
      
      public static function setGP(amount:int) : void
      {
         try
         {
            GP_BALANCE = amount;
         }
         catch(e:Error)
         {
            Logger.print("*** DAXDispatcher: " + e.message);
         }
      }
      
      public static function setCP(amount:int) : void
      {
         try
         {
            if(amount > CP_BALANCE)
            {
               queue("cp_added",String(amount - CP_BALANCE));
            }
            CP_BALANCE = amount;
         }
         catch(e:Error)
         {
            Logger.print("*** DAXDispatcher: " + e.message);
         }
      }
      
      public static function setClanId(value:int) : void
      {
         try
         {
            CLAN_ID = value;
         }
         catch(e:Error)
         {
            Logger.print("*** DAXDispatcher: " + e.message);
         }
      }
      
      public static function setSessionId(value:String) : void
      {
         try
         {
            SESSION_ID = value;
         }
         catch(e:Error)
         {
            Logger.print("*** DAXDispatcher: " + e.message);
         }
      }
      
      public static function setBuildNumber(value:int) : void
      {
         try
         {
            BUILD_NUMBER = value;
         }
         catch(e:Error)
         {
            Logger.print("*** DAXDispatcher: " + e.message);
         }
      }
      
      public static function setRecommendedItems(value:String) : void
      {
         try
         {
            RECOMMENDED_ITEMS = value;
         }
         catch(e:Error)
         {
            Logger.print("*** DAXDispatcher: " + e.message);
         }
      }
      
      public static function setIsReady(value:Boolean) : void
      {
         try
         {
            IS_READY = value;
         }
         catch(e:Error)
         {
            Logger.print("*** DAXDispatcher: " + e.message);
         }
      }
      
      public static function getDurationTotal() : int
      {
         return DURATION_TOTAL;
      }
      
      public static function setQQIV(value:String) : void
      {
         try
         {
            QQVIP_STATUS = value;
         }
         catch(e:Error)
         {
            Logger.print("*** DAXDispatcher: " + e.message);
         }
      }
      
      public static function setTGP(value:String) : void
      {
         try
         {
            TGP_STATUS = value;
         }
         catch(e:Error)
         {
            Logger.print("*** DAXDispatcher: " + e.message);
         }
      }
      
      public static function setNetCafe(value:String) : void
      {
         try
         {
            NETCAFE_STATUS = value;
         }
         catch(e:Error)
         {
            Logger.print("*** DAXDispatcher: " + e.message);
         }
      }
      
      public static function calculateDurationTotal() : void
      {
         try
         {
            DURATION_TOTAL = (getCurrentTime() - INITIAL_TIMESTAMP) / 1000;
         }
         catch(e:Error)
         {
            Logger.print("*** DAXDispatcher: " + e.message);
         }
      }
      
      public static function getGameVariantAndMode(type:String) : Array
      {
         var tableType:String = null;
         var gameDescriptorStrings:Array = ["",""];
         if(type == QuickMatchType.ID_FUTURE_CYBORGS)
         {
            gameDescriptorStrings[0] = "zm";
         }
         else
         {
            tableType = TableUtil.lookup(Mode.PATH,Mode.ID,type,Mode.TYPE);
            gameDescriptorStrings[0] = tableType == Mode.TYPE_PVP ? "mp" : "coop";
         }
         gameDescriptorStrings[1] = type;
         return gameDescriptorStrings;
      }
   }
}

