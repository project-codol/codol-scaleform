package codo.manager
{
   import codo.base.PageManagerBase;
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionInGameContainer;
   import codo.constants.BCInGameEvent;
   import codo.constants.CodoInGamePageDB;
   import codo.constants.DataInGameID;
   import codo.constants.ViewState;
   import codo.objects.CodoPageLayerObj;
   import codo.objects.CodoPageObj;
   import codo.objects.CodoViewObj;
   import codo.services.InGameService;
   import codo.utils.ClashPvpUtil;
   import codo.utils.InGameTokenUtil;
   import codo.utils.ScaleformUtil;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.KeyboardEvent;
   
   public class PageInGameManager extends PageManagerBase
   {
      
      private static var _instance:PageInGameManager;
      
      public var isPauseMenuOpen:Boolean = false;
      
      protected var mCurrentFocusedPage:CodoPageObj = null;
      
      public function PageInGameManager()
      {
         super();
         this._pageLayers = [CodoInGamePageDB.PAGE_LAYER_MAIN,CodoInGamePageDB.PAGE_LAYER_CHATTING,CodoInGamePageDB.PAGE_LAYER_KICK,CodoInGamePageDB.PAGE_LAYER_LOADOUT,CodoInGamePageDB.PAGE_LAYER_QUICKCHAT,CodoInGamePageDB.PAGE_LAYER_RESPAWN,CodoInGamePageDB.PAGE_LAYER_COOP_EOG,CodoInGamePageDB.PAGE_LAYER_PLAYER_CARD,CodoInGamePageDB.PAGE_LAYER_HUD,CodoInGamePageDB.PAGE_LAYER_SPLASH,CodoInGamePageDB.PAGE_LAYER_HUD_POPUP,CodoInGamePageDB.PAGE_LAYER_TOP_HUD,CodoInGamePageDB.PAGE_LAYER_TOP_SPLASH,CodoInGamePageDB.PAGE_LAYER_SUMMARY,CodoInGamePageDB.PAGE_LAYER_SCOREBOARD,CodoInGamePageDB.PAGE_LAYER_PAUSE,CodoInGamePageDB.PAGE_LAYER_HELP,CodoInGamePageDB.PAGE_LAYER_POPUP,CodoInGamePageDB.PAGE_LAYER_NOTIFICATION,CodoInGamePageDB.PAGE_LAYER_GVOICE_SETTINGS,CodoInGamePageDB.PAGE_LAYER_GVOICE_CHAT_PANEL,CodoInGamePageDB.PAGE_LAYER_SERVER];
      }
      
      public static function getInstance() : PageInGameManager
      {
         if(_instance == null)
         {
            _instance = new PageInGameManager();
         }
         return _instance;
      }
      
      override public function init(cContainer:Sprite) : void
      {
         super.init(cContainer);
         cContainer.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onStageKeyboardEvent);
      }
      
      public function get pageLayers() : Array
      {
         return _pageLayers;
      }
      
      public function get currentFocusedPage() : CodoPageObj
      {
         return this.mCurrentFocusedPage;
      }
      
      public function updateCurrentFocusedPage() : void
      {
         var pageLayer:CodoPageLayerObj = null;
         this.mCurrentFocusedPage = null;
         var layerNum:int = int(PageInGameManager.getInstance().pageLayers.length);
         for(var i:int = 0; i < layerNum; i++)
         {
            pageLayer = PageInGameManager.getInstance().pageLayers[layerNum - i - 1];
            if(pageLayer.currentPageObj != null && pageLayer.currentPageObj.ingameSupportKeyEvent)
            {
               this.mCurrentFocusedPage = pageLayer.currentPageObj;
               break;
            }
         }
      }
      
      override public function startUI(cParams:Object) : void
      {
         super.startUI(cParams);
         if(!CFunctionInGameContainer.IsSpectator())
         {
            this.showPage(CodoInGamePageDB.PAGE_SERVER,false,ViewState.BACKGROUND);
         }
         this.showPage(CodoInGamePageDB.PAGE_CHATTING);
         this.showPage(CodoInGamePageDB.PAGE_GVOICE_CHAT_PANEL);
         if(CFunctionCommonContainer.Dvar_GetBool("ui_enable_hudkit") == true)
         {
            this.loadHUDKitPages();
         }
         if(!ScaleformUtil.isScaleform)
         {
            this.broadcast(BCInGameEvent.GOTO_FIRST_PAGE);
         }
      }
      
      public function showScoreboard(show:Boolean) : void
      {
         var isCyborg:Boolean = this.getDP(DataInGameID.IS_ZM);
         if(show)
         {
            this.showPage(isCyborg ? CodoInGamePageDB.PAGE_SCOREBOARD_CYBORGS : CodoInGamePageDB.PAGE_SCOREBOARD,true);
         }
         else
         {
            this.cleanPageLayer(isCyborg ? CodoInGamePageDB.PAGE_SCOREBOARD_CYBORGS.owner : CodoInGamePageDB.PAGE_SCOREBOARD.owner);
         }
      }
      
      public function showRevivePrompt(show:Boolean) : void
      {
         var gametype:String = null;
         var purchaseConfirm:DisplayObject = null;
         var purchaseProgress:DisplayObject = null;
         var inGamePurchasingEnabled:Boolean = InGameTokenUtil.InGamePurchaseAllowed();
         var promptPageObj:CodoPageObj = null;
         if(inGamePurchasingEnabled)
         {
            gametype = this.getDP(DataInGameID.GAME_TYPE);
            if(gametype == "zhunt" && !InGameTokenUtil.RampageTokenEnabled())
            {
               promptPageObj = CodoInGamePageDB.PAGE_ZHUNT_PURCHASE_ENABLED_TOKEN_PROMPT;
            }
            else
            {
               promptPageObj = CodoInGamePageDB.PAGE_PURCHASE_ENABLED_TOKEN_PROMPT;
            }
         }
         else
         {
            promptPageObj = CodoInGamePageDB.PAGE_CYBORG_TOKENS_FSG;
         }
         if(show)
         {
            this.showPage(promptPageObj);
         }
         else
         {
            if(!this.isPauseMenuOpen)
            {
               CFunctionInGameContainer.BindUIKeyCatcher(false);
            }
            this.cleanPageLayer(promptPageObj.owner);
            if(inGamePurchasingEnabled)
            {
               CodoInGamePageDB.PAGE_LAYER_RESPAWN.instance.visible = true;
               purchaseConfirm = CodoViewObj(CodoInGamePageDB.PAGE_ADV_POPUP_PURCHASE_ADD_TO_CART.views[0]).instance as DisplayObject;
               purchaseProgress = CodoViewObj(CodoInGamePageDB.PAGE_SYS_MSG_FSG.views[0]).instance as DisplayObject;
               this.cleanPageLayer(CodoInGamePageDB.PAGE_ADV_POPUP_PURCHASE_ADD_TO_CART.owner);
               this.cleanPageLayer(CodoInGamePageDB.PAGE_SYS_MSG_FSG.owner);
               if(purchaseConfirm != null)
               {
                  purchaseConfirm.visible = false;
               }
               if(purchaseProgress != null)
               {
                  purchaseProgress.visible = false;
               }
            }
         }
      }
      
      public function showTop3Players(show:Boolean) : void
      {
         var gametype:String = this.getDP(DataInGameID.GAME_TYPE);
         if(show)
         {
            if(gametype == "spy")
            {
               this.showPage(CodoInGamePageDB.PAGE_SPY_TOP_3_PLAYERS);
            }
            else if(gametype == "dmz")
            {
               this.showPage(CodoInGamePageDB.PAGE_DMZ_TOP_3_PLAYERS);
            }
            else
            {
               this.showPage(CodoInGamePageDB.PAGE_TOP_3_PLAYERS);
            }
         }
         else if(gametype == "spy")
         {
            this.cleanPageLayer(CodoInGamePageDB.PAGE_SPY_TOP_3_PLAYERS.owner);
         }
         else if(gametype == "dmz")
         {
            this.cleanPageLayer(CodoInGamePageDB.PAGE_DMZ_TOP_3_PLAYERS.owner);
         }
         else
         {
            this.cleanPageLayer(CodoInGamePageDB.PAGE_TOP_3_PLAYERS.owner);
         }
      }
      
      public function showHelpMenu() : void
      {
         if(CFunctionCommonContainer.Dvar_GetString("ui_gametype") == "zhunt")
         {
            this.showPage(CodoInGamePageDB.PAGE_HELP_ZHUNT);
         }
         else if(CFunctionCommonContainer.Dvar_GetString("ui_gametype") == "td")
         {
            this.showPage(CodoInGamePageDB.PAGE_HELP_TD);
         }
         else
         {
            this.showPage(CodoInGamePageDB.PAGE_HELP);
         }
      }
      
      public function closeHelpMenu() : void
      {
         if(Boolean(CodoInGamePageDB.PAGE_LAYER_HELP.currentPageObj))
         {
            this.cleanPageLayer(CodoInGamePageDB.PAGE_LAYER_HELP);
         }
      }
      
      public function showTutorialOverlay(step:int, stepData:int) : void
      {
         showPage(CodoInGamePageDB.PAGE_UI_TUTORIAL_INGAME,false,ViewState.ACTIVATED,{
            "step":step,
            "stepData":stepData
         });
      }
      
      public function closeTutorialOverlay() : void
      {
         cleanPageLayer(CodoInGamePageDB.PAGE_UI_TUTORIAL_INGAME.owner);
      }
      
      private function loadHUDKitPages() : void
      {
         var gametype:String = this.getDP(DataInGameID.GAME_TYPE);
         if(Boolean(CFunctionCommonContainer.GametypeUsesAsymRobots(gametype)))
         {
            this.showPage(CodoInGamePageDB.PAGE_ASYM_HUD);
         }
         else if(gametype == "sr")
         {
            this.showPage(CodoInGamePageDB.PAGE_SANDR_HUD);
         }
         else if(gametype == "sd" || gametype == "sdp" || gametype == "sdc" || gametype == "hostage")
         {
            this.showPage(CodoInGamePageDB.PAGE_SANDD_HUD);
         }
         else if(gametype == ClashPvpUtil.MODE_ID)
         {
            this.showPage(CodoInGamePageDB.PAGE_CLASH_HUD);
         }
         else if(Boolean(CFunctionInGameContainer.IsZombieMPGametype(gametype)) && Boolean(gametype != "zhunt") && gametype != "td")
         {
            this.showPage(CodoInGamePageDB.PAGE_ZOMBIE_ARENA_HUD);
         }
         else if(InGameService.getInstance().isSurvival())
         {
            this.showPage(CodoInGamePageDB.PAGE_SURVIVAL_HUD);
         }
         else if(gametype == "ph")
         {
            this.showPage(CodoInGamePageDB.PAGE_PROP_HUNT_HUD);
         }
         else if(gametype == "spy")
         {
            this.showPage(CodoInGamePageDB.PAGE_SPY_HUD);
         }
         else if(gametype == "dmz" || gametype == "tdmz")
         {
            this.showPage(CodoInGamePageDB.PAGE_DMZ_HUD);
         }
         else
         {
            this.showPage(CodoInGamePageDB.PAGE_HUD);
            this.showPage(CodoInGamePageDB.PAGE_TOP_HUD);
         }
         this.showPage(CodoInGamePageDB.PAGE_PLAYERCARD_HUD);
         this.showPage(CodoInGamePageDB.PAGE_VOTE_POPUP);
      }
      
      protected function onStageKeyboardEvent(cEvt:KeyboardEvent) : void
      {
         var i:int = 0;
         var focusedPage:CodoPageObj = this.currentFocusedPage;
         if(focusedPage != null)
         {
            for(i = 0; i < focusedPage.views.length; i++)
            {
               if(focusedPage.views[i].instance != null && Boolean(focusedPage.views[i].instance.visible))
               {
                  focusedPage.views[i].instance.onKeyboardEvent(cEvt);
               }
            }
         }
      }
   }
}

