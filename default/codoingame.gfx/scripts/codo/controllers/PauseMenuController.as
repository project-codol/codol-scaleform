package codo.controllers
{
   import codo.base.BaseController;
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionInGameContainer;
   import codo.constants.BCCommonEvent;
   import codo.constants.BCInGameEvent;
   import codo.constants.CodoInGamePageDB;
   import codo.constants.DataID;
   import codo.constants.DataInGameID;
   import codo.constants.ViewState;
   import codo.event.ParaEvent;
   import codo.manager.PageInGameManager;
   import codo.objects.AsymPvpLoadoutObj;
   import codo.objects.ClashLoadoutObj;
   import codo.objects.CodoPageObj;
   import codo.services.InGameService;
   import codo.utils.AsymPvpUtil;
   import codo.utils.ClashPvpUtil;
   import codo.utils.Logger;
   import codo.utils.PauseUtil;
   import codo.utils.ScaleformUtil;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class PauseMenuController extends BaseController
   {
      
      private static const CUSTOM_LOADOUT_NUM:int = 3;
      
      private var _currentMap:String;
      
      private var _isLeavingRoom:Boolean = false;
      
      private var _characterInfo:Object;
      
      private var _characterWeapons:Array;
      
      private var _overrideLoadoutIdx:int = -1;
      
      private var _isLoadoutOnly:Boolean = false;
      
      private var _isPausePageOpened:Boolean = false;
      
      private var _timerOpenShoutcastMenu:Timer = null;
      
      private var _isOpenedByServerCommand:Boolean = false;
      
      private var ___TGA_Init:Boolean = false;
      
      public function PauseMenuController()
      {
         super();
      }
      
      override protected function onInitialized() : void
      {
         this.addDP(DataInGameID.CHARACTER_INFO,this.getCharacterInfo);
         this.addDP(DataInGameID.CHARACTER_WEAPON_LOADOUTS,this.getCharacterWeaponLoadouts);
         this.addDP(DataInGameID.OVERRIDE_WEAPON_LOADOUT_IDX,this.getOverrideLoadoutIdx);
         this.addDP(DataInGameID.HIDE_OPTION_MENU,this.hideOptionMenu);
         this.addDP(DataInGameID.HIDE_CLASS_SELECTION_MENU,this.hideClassSelectionMenu);
         this.addDP(DataInGameID.HAS_POPUP,this.hasPopup);
         this.addDP(DataInGameID.IS_PAUSEMENU_OPENED_BY_SERVER_COMMAND,this.isPauseMenuOpenedByServerCommand);
         this.listen(BCInGameEvent.SELECT_WEAPON_LOADOUT,this.onSelectWeaponLoadoutHandle);
         this.listen(BCInGameEvent.BACK_TO_GAME,this.onBackToGameHandle);
         this.listen(BCInGameEvent.BACK_TO_MAIN_MENU,this.onBackToMainMenuHandle);
         this.listen(BCCommonEvent.EVT_CLOSE_SUMMARY,this.onCloseSummaryHandle);
         this.listen(BCCommonEvent.EVT_QUIT_GAME,this.onQuitGameHandle);
         this.listen(BCInGameEvent.GOTO_FIRST_PAGE,this.onGoToFirstPage);
         this.listen(BCInGameEvent.SHOW_NOTIFICATION_POPUP,this.onNotificationPopupStateChangeHandle);
         this.listen(BCInGameEvent.HIDE_NOTIFICATION_POPUP,this.onNotificationPopupStateChangeHandle);
         this.listen(BCInGameEvent.RELOAD_CHARACTER_LOADOUT,this.onReloadCharacterLoadoutHandle);
         this.listen(BCInGameEvent.EVT_OPEN_QUIT_GAME_WARNING_POPUP,this.onOpenQuitGameWarningPopup);
         this.listen(BCCommonEvent.EVT_GOTO_SHOW_PUNISH_TIP,this.onShowPunishTip);
         this.listen(BCInGameEvent.EVT_SET_PAUSEMENU_TO_CLOSE,this.onClosePauseMenu);
         this.initCharacterLoadout();
         if(this._currentMap == null)
         {
            this._currentMap = CFunctionCommonContainer.Dvar_GetString("mapname");
         }
         this.___TGA_Init = false;
      }
      
      private function initCharacterLoadout(syncFromProfile:Boolean = false, replaced:Boolean = false) : void
      {
         var i:int = 0;
         var currentCharacterIdx:int = CFunctionCommonContainer.CL_GetCurrentCharacterLoadoutIndex();
         Logger.print("PauseMenuController:::initCharacterLoadout currentCharacterIdx: " + currentCharacterIdx);
         var cl:Object = CFunctionCommonContainer.WL_GetCharacterWeaponLoadouts(currentCharacterIdx,syncFromProfile,replaced);
         if(Boolean(cl))
         {
            this._characterInfo = cl.character;
            this._characterWeapons = cl.weaponLoadouts;
            if(Boolean(cl.overrideLoadout))
            {
               this._overrideLoadoutIdx = this._characterWeapons.push(cl.overrideLoadout) - 1;
            }
            else
            {
               this._overrideLoadoutIdx = -1;
            }
            if(Boolean(this._characterWeapons))
            {
               for(i = 0; i < this._characterWeapons.length; i++)
               {
                  this.changeToSmallIcons(this._characterWeapons[i].primaryAttachments);
                  this.changeToSmallIcons(this._characterWeapons[i].secondaryAttachments);
                  this.changeToSmallIcons(this._characterWeapons[i].equipments);
                  this.changeToSmallIcons(this._characterWeapons[i].perks);
                  this.changeToSmallIcons(this._characterWeapons[i].killstreaks);
                  this.changeToSmallIcon(this._characterWeapons[i].deathstreak);
                  if(ClashPvpUtil.isClashHardcore())
                  {
                     this._characterWeapons[i].primary.isBanned = true;
                     if(this._characterWeapons[i].secondary.id == 28096 || this._characterWeapons[i].secondary.id == 11755 || CFunctionCommonContainer.GetItemGroup(this._characterWeapons[i].secondary.id) != "swd")
                     {
                        this._characterWeapons[i].secondary.isBanned = true;
                     }
                     this.setBannedInClashHardcore(this._characterWeapons[i].primaryAttachments);
                     this.setBannedInClashHardcore(this._characterWeapons[i].secondaryAttachments);
                     this.setBannedInClashHardcore(this._characterWeapons[i].equipments);
                  }
               }
            }
         }
         currentCharacterIdx = this.getProp(["currentCharacterIndex"]);
         if(syncFromProfile || replaced)
         {
            this.broadcast(BCInGameEvent.CHARACTER_LOADOUT_RELOADED);
         }
         Logger.print("PauseMenuController:::initCharacterLoadout currentCharacterIdx in profile: " + currentCharacterIdx);
      }
      
      private function setBannedInClashHardcore(items:Array) : void
      {
         var i:int = 0;
         if(Boolean(items) && items.length > 0)
         {
            for(i = 0; i < items.length; i++)
            {
               items[i].isBanned = true;
            }
         }
      }
      
      private function changeToSmallIcons(icons:Array) : void
      {
         var i:int = 0;
         if(Boolean(icons) && icons.length > 0)
         {
            for(i = 0; i < icons.length; i++)
            {
               this.changeToSmallIcon(icons[i]);
            }
         }
      }
      
      private function changeToSmallIcon(icon:Object) : void
      {
      }
      
      private function getCharacterInfo() : Object
      {
         return Boolean(this._characterInfo) ? this._characterInfo : {
            "name":"Character Name",
            "description":"",
            "imageURL":""
         };
      }
      
      private function getCharacterWeaponLoadouts() : Array
      {
         var i:uint = 0;
         var gametype:String = this.getDP(DataInGameID.GAME_TYPE);
         if(Boolean(CFunctionCommonContainer.GametypeUsesAsymRobots(gametype)) && AsymPvpUtil.instance.isAsymMonster)
         {
            return AsymPvpUtil.instance.loadoutCategories;
         }
         if(getDP(DataInGameID.GAME_TYPE) == ClashPvpUtil.MODE_ID && !ClashPvpUtil.isClashHardcore())
         {
            return ClashPvpUtil.instance.getLoadoutCategories();
         }
         if(!ScaleformUtil.isScaleform)
         {
            this._characterWeapons = [];
            for(i = 0; i < CUSTOM_LOADOUT_NUM; i++)
            {
               this._characterWeapons.push({
                  "name":"custom" + i,
                  "id":"custom" + String(i + 1)
               });
            }
         }
         return Boolean(this._characterWeapons) ? this._characterWeapons : [];
      }
      
      private function getOverrideLoadoutIdx() : int
      {
         return this._overrideLoadoutIdx;
      }
      
      private function onGoToFirstPage(cEvt:ParaEvent) : void
      {
         Logger.print("PauseMenuController:::onGoToFirstPage");
         this.openPauseMenu();
      }
      
      public function openPauseMenu(loadoutOnly:int = 0) : void
      {
         this._isLoadoutOnly = Boolean(loadoutOnly);
         var gametype:String = InGameService.getInstance().getGameType() as String;
         var showFadeIn:Boolean = gametype != "spy" && gametype != "dmz" && gametype != "tdmz";
         if(showFadeIn)
         {
            CodoInGamePageDB.PAGE_LAYER_PAUSE.instance.setFadeIn(true);
            CodoInGamePageDB.PAGE_LAYER_PAUSE.instance.showATField();
         }
         else
         {
            CodoInGamePageDB.PAGE_LAYER_PAUSE.instance.setFadeIn(false);
            CodoInGamePageDB.PAGE_LAYER_PAUSE.instance.hideATField();
         }
         CFunctionCommonContainer.setdvar("cl_paused","1");
         CFunctionCommonContainer.setdvar("ui_pasuemenu_for_vip","0");
         if(Boolean(getDP(DataInGameID.IS_DMZ)) || Boolean(getDP(DataInGameID.IS_TDMZ)))
         {
            PauseUtil.hidePauseMap(true);
         }
         else
         {
            PauseUtil.hidePauseMap(Boolean(loadoutOnly) ? true : false);
         }
         var shouldHideLoadout:Boolean = InGameService.getInstance().curMapIsFiringrangetTrain() && CFunctionCommonContainer.Dvar_GetInt("ui_played_playlist") > 0;
         if(Boolean(getDP(DataInGameID.IS_DMZ)) || Boolean(getDP(DataInGameID.IS_SPY)) || Boolean(getDP(DataInGameID.IS_PH)))
         {
            shouldHideLoadout = true;
         }
         if(Boolean(getDP(DataInGameID.IS_VIP)))
         {
            if(CFunctionInGameContainer.AS_VIPGetCurrentPlayerVIPSelectionIndex() > 0)
            {
               shouldHideLoadout = true;
               CFunctionCommonContainer.setdvar("ui_pasuemenu_for_vip","1");
            }
         }
         PauseUtil.hideLoadout(shouldHideLoadout);
         CFunctionCommonContainer.setdvar("ui_hide_pausemenu_options",Boolean(loadoutOnly) ? "1" : "0");
         CFunctionCommonContainer.setdvar("ui_hide_pausemenu_minimap_player","0");
         if(!this.isSpectator())
         {
            this.broadcast(BCInGameEvent.BIND_UI_KEY_CATCHER,true);
         }
         var pausePage:CodoPageObj = CodoInGamePageDB.GetPausePage(this._isLoadoutOnly);
         PageInGameManager.getInstance().showPage(pausePage,false,ViewState.ACTIVATED,loadoutOnly == 1);
         this._isPausePageOpened = true;
         if(this.isSpectator())
         {
            CFunctionCommonContainer.setdvar("cl_hideShoutcastForPausemenu","1");
         }
      }
      
      public function closePauseMenu() : void
      {
         if(Boolean(getDP(DataID.PUNISH_POPUP_SHOWING)))
         {
            return;
         }
         this.broadcast(BCInGameEvent.COMPLAINT_FORCED_EXIT);
         this._isPausePageOpened = false;
         PageInGameManager.getInstance().cleanPageLayer(CodoInGamePageDB.GetPausePage(this._isLoadoutOnly).owner);
         CFunctionCommonContainer.setdvar("cl_paused","0");
         PauseUtil.hidePauseMap(true);
         if(!this.isSpectator())
         {
            this.broadcast(BCInGameEvent.BIND_UI_KEY_CATCHER,false);
         }
         if(this.isSpectator())
         {
            CFunctionCommonContainer.setdvar("cl_hideShoutcastForPausemenu","0");
            this.tryShowShoutcastAndUpdateBypassMouseInput(null);
         }
         this.broadcast(BCCommonEvent.TRY_FORCE_CLOSE_GVOICE_SETTING);
         PageInGameManager.getInstance().isPauseMenuOpen = false;
      }
      
      private function tryShowShoutcastAndUpdateBypassMouseInput(cEvt:TimerEvent) : void
      {
         if(this._timerOpenShoutcastMenu != null)
         {
            this._timerOpenShoutcastMenu.removeEventListener(TimerEvent.TIMER_COMPLETE,this.tryShowShoutcastAndUpdateBypassMouseInput);
            this._timerOpenShoutcastMenu = null;
         }
         if(!CFunctionInGameContainer.AS_ShowShoutcastAndUpdateBypassMouseInput())
         {
            this._timerOpenShoutcastMenu = new Timer(1000,1);
            this._timerOpenShoutcastMenu.addEventListener(TimerEvent.TIMER_COMPLETE,this.tryShowShoutcastAndUpdateBypassMouseInput);
            this._timerOpenShoutcastMenu.start();
         }
      }
      
      private function isSpectator() : Boolean
      {
         return CFunctionInGameContainer.IsSpectator() as Boolean;
      }
      
      private function hideOptionMenu() : Boolean
      {
         return this.getDvarBool("ui_hide_pausemenu_options");
      }
      
      private function hideClassSelectionMenu() : Boolean
      {
         return PauseUtil.getLoadoutHidden() || this.isSpectator();
      }
      
      private function onOpenQuitGameWarningPopup(cEvt:ParaEvent) : void
      {
         PageInGameManager.getInstance().showPage(CodoInGamePageDB.PAGE_QUIT_GAME_WARNING_POPUP,false,ViewState.ACTIVATED,cEvt.myPara);
      }
      
      private function onShowPunishTip(cEvt:ParaEvent) : void
      {
         CFunctionInGameContainer.RequestRaisePauseMenu();
      }
      
      private function onClosePauseMenu(cEvt:ParaEvent) : void
      {
         this.closePauseMenu();
      }
      
      private function onNotificationPopupStateChangeHandle(cEvt:ParaEvent) : void
      {
         var gameType:String = null;
         switch(cEvt.type)
         {
            case BCInGameEvent.SHOW_NOTIFICATION_POPUP:
               PauseUtil.hidePauseMap(true);
               break;
            case BCInGameEvent.HIDE_NOTIFICATION_POPUP:
               gameType = CFunctionCommonContainer.Dvar_GetString("g_gametype");
               PauseUtil.hidePauseMap(this._isPausePageOpened == false || this._isLoadoutOnly && gameType != "dmz" && gameType != "tdmz" || !this._isLoadoutOnly && gameType == "zhunt");
         }
      }
      
      private function onReloadCharacterLoadoutHandle(cEvt:ParaEvent) : void
      {
         this.initCharacterLoadout(true);
      }
      
      private function getProp(params:Array, bSecureProfile:Boolean = false) : *
      {
         return CFunctionCommonContainer.GetPlayerData(params,bSecureProfile);
      }
      
      private function isInRoom() : Boolean
      {
         return Boolean(CFunctionCommonContainer.IsInRoom());
      }
      
      private function onSelectWeaponLoadoutHandle(cEvt:ParaEvent) : void
      {
         var selectedIdx:int = 0;
         var classId:String = null;
         var gametype:String = null;
         var loadoutObj:AsymPvpLoadoutObj = null;
         var loadoutObjclash:ClashLoadoutObj = null;
         if(!this.isSpectator())
         {
            selectedIdx = cEvt.myPara;
            gametype = this.getDP(DataInGameID.GAME_TYPE);
            if(Boolean(CFunctionCommonContainer.GametypeUsesAsymRobots(gametype)) && AsymPvpUtil.instance.isAsymMonster)
            {
               AsymPvpUtil.instance.setCachedClassIdx(selectedIdx);
               loadoutObj = AsymPvpUtil.instance.getSelectedLoadoutObj(selectedIdx);
               classId = loadoutObj.id;
            }
            else if(getDP(DataInGameID.GAME_TYPE) == ClashPvpUtil.MODE_ID && !ClashPvpUtil.isClashHardcore())
            {
               loadoutObjclash = ClashPvpUtil.instance.getSelectedLoadoutObj(selectedIdx);
               classId = "default" + loadoutObjclash.index;
            }
            else
            {
               classId = this._characterWeapons[selectedIdx].id;
            }
            Logger.print("PauseMenuController:::onSelectWeaponLoadoutHandle selectedIdx: " + selectedIdx + " class: " + classId + "isOpenedByServerCommand: " + this._isOpenedByServerCommand);
            if(Boolean(getDP(DataInGameID.IS_ZHUNT)) && !this._isOpenedByServerCommand)
            {
               CFunctionCommonContainer.ScriptMenuResponse("changeclass","quit");
            }
            else
            {
               CFunctionCommonContainer.ScriptMenuResponse("changeclass",classId);
               if(this._overrideLoadoutIdx == -1)
               {
                  CFunctionCommonContainer.WL_SetCurrentWeaponLoadoutIndex(selectedIdx);
               }
            }
         }
         this.closePauseMenu();
      }
      
      private function onBackToGameHandle(cEvt:ParaEvent) : void
      {
         if(CodoInGamePageDB.GetPausePage(this._isLoadoutOnly).owner.currentPageObj != null)
         {
            CFunctionCommonContainer.ScriptMenuResponse("class","back");
            this.closePauseMenu();
         }
         else if(!ScaleformUtil.isScaleform)
         {
            this.openPauseMenu();
         }
      }
      
      private function onBackToMainMenuHandle(cEvt:ParaEvent) : void
      {
         broadcast(BCInGameEvent.EVT_REQUEST_LEAVE_INGAME);
      }
      
      private function onCloseSummaryHandle(cEvt:ParaEvent) : void
      {
         PageInGameManager.getInstance().showPage(CodoInGamePageDB.GetPausePage(this._isLoadoutOnly));
      }
      
      private function setNotified(notificationRef:String) : void
      {
         if(Boolean(notificationRef) && notificationRef.length > 0)
         {
            CFunctionCommonContainer.AS_SetNotified(notificationRef);
         }
      }
      
      private function onQuitGameHandle() : void
      {
         CFunctionCommonContainer.execnow("quit");
      }
      
      private function hasPopup() : Boolean
      {
         return CodoInGamePageDB.PAGE_LAYER_NOTIFICATION.currentPageObj != null;
      }
      
      private function isPauseMenuOpenedByServerCommand() : Boolean
      {
         return this._isOpenedByServerCommand;
      }
      
      public function set isOpenedByServerCommand(val:Boolean) : void
      {
         this._isOpenedByServerCommand = val;
      }
      
      public function get isLoadoutOnly() : Boolean
      {
         return this._isLoadoutOnly;
      }
      
      override public function update(deltaTime:Number) : void
      {
         if(this._currentMap == "coop_training_mp_cargoship" && !this._isLeavingRoom && this.getDvarBool("ui_skip_mission_success"))
         {
            this._isLeavingRoom = true;
            CFunctionCommonContainer.LeaveRoom(false,false);
         }
         if(this.___TGA_Init == false)
         {
            if(CFunctionCommonContainer.Dvar_GetInt("tencent_e3_loadout") != -1)
            {
               this.initCharacterLoadout(true);
               this.___TGA_Init = true;
            }
         }
         if(this._isPausePageOpened)
         {
            if(this.getDvarString("ui_ingame_replaced_loadout") != "")
            {
               Logger.print("PauseMenuController:::update received ui_ingame_replaced_loadout from DS");
               this.initCharacterLoadout(false,true);
            }
         }
      }
   }
}

