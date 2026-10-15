package codo.component.lobby
{
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.component.TabNavigation;
   import codo.component.loadout.LoadoutViewPanelBase;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.cpp.UiCppOnboarding;
   import codo.event.ParaEvent;
   import codo.manager.DataManager;
   import codo.manager.EventManager;
   import codo.objects.CustomObject;
   import codo.objects.ProductObj;
   import codo.objects.RoomMemberObj;
   import codo.services.WeaponLoadoutService;
   import flash.display.Sprite;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   
   public class LobbyMainPanel extends LoadoutViewPanelBase
   {
      
      private static const LOADOUT_TAB_BG_WIDTH:Number = 638;
      
      private static const EQUIPPABLES_TAB_BG_WIDTH:Number = 780;
      
      private static const BUTTON_FRAME_WIDTH:Number = 234;
      
      private static const SUPPLY_DROPS_BUTTON_FRAME_HEIGHT:Number = 311;
      
      public var myMarketPanel:LobbyMarketPanel;
      
      public var myLoadoutItemSelectPanel:LobbyLoadoutSelectItemPanel;
      
      public var myLoadoutPanel:NewLobbyLoadoutPanel;
      
      public var myScorestreaksPanel:LobbyLoadoutViewScorestreaksPanel;
      
      public var myRequisitionsPanel:LobbyLoadoutViewRequisitionsPanel;
      
      private var myLoadoutTabs:TabNavigation;
      
      private var myTabsBG:Sprite;
      
      private var mCurrentPanel:LoadoutViewPanelBase;
      
      private var mMktDataIsReady:Boolean = true;
      
      private var mItemSelectVisibilityChanged:Function;
      
      private var mOnPanelClosedCallback:Function;
      
      protected var _loadoutInited:Boolean;
      
      public function LobbyMainPanel()
      {
         super();
         this.myMarketPanel.myCloseButton.visible = false;
         this.myLoadoutItemSelectPanel.myCloseButton.visible = false;
         this.myLoadoutPanel.registerItemSelectedCallback(this.onLoadoutItemSelected);
         this.myLoadoutPanel.myLoadout.registerLoadoutCopiedCb(this.onLoadoutCopied);
         this.myRequisitionsPanel.myFrame.width = EQUIPPABLES_TAB_BG_WIDTH;
         this.myLoadoutTabs = this.myLoadoutPanel.myLoadoutTabs;
         this.myTabsBG = this.myLoadoutPanel.myLoadout["myTabsBG"];
      }
      
      public function resetNavigation() : void
      {
         this.myLoadoutTabs.visible = false;
         this.myTabsBG.visible = false;
         this.showNavButtons(true);
      }
      
      override protected function onInit() : void
      {
         super.onInit();
         this.resetNavigation();
      }
      
      override protected function enableData() : void
      {
         super.enableData();
         this._loadoutInited = false;
         EventManager.getInstance().listen(BCEvent.EVT_EQUIPPED,this.onEquip);
         EventManager.getInstance().listen(BCEvent.EVT_SET_DEFAULT_CHARACTER,this.onCharacterChange);
         EventManager.getInstance().listen(BCEvent.EVT_REFRESH_UI_AFTER_INVENTORY_CHANGE,this.refreshTabs);
         stage.addEventListener(KeyboardEvent.KEY_UP,this.onStageKeyHandle);
         DataManager.getInstance().bind(DataID.CURRENTLY_SELECTED_TEAM_MEMBER,this.bind_onSetCurrentlySelectedTeamMember,null,true,true,false);
      }
      
      override protected function disableData() : void
      {
         super.disableData();
         EventManager.getInstance().unlisten(BCEvent.EVT_EQUIPPED,this.onEquip);
         EventManager.getInstance().unlisten(BCEvent.EVT_SET_DEFAULT_CHARACTER,this.onCharacterChange);
         EventManager.getInstance().unlisten(BCEvent.EVT_REFRESH_UI_AFTER_INVENTORY_CHANGE,this.refreshTabs);
         stage.removeEventListener(KeyboardEvent.KEY_UP,this.onStageKeyHandle);
         DataManager.getInstance().unbind(DataID.CURRENTLY_SELECTED_TEAM_MEMBER,this.bind_onSetCurrentlySelectedTeamMember);
      }
      
      public function setMarketReadyMode(value:Boolean) : void
      {
         this.mMktDataIsReady = value;
         this.myTabsBG.visible = false;
         if(null != this.mCurrentPanel)
         {
            this.mCurrentPanel.hidePanel();
            this.mCurrentPanel = null;
         }
         this.updateTabVisibility();
      }
      
      private function showNavButtons(show:Boolean) : void
      {
         if(!this.mMktDataIsReady)
         {
            return;
         }
         this.myTabsBG.visible = show;
         if(true == show && null != this.mCurrentPanel)
         {
            this.mCurrentPanel.hidePanel();
            this.mCurrentPanel = null;
            this.mOnPanelClosedCallback();
         }
      }
      
      private function gotoPanel(panel:LoadoutViewPanelBase) : void
      {
         this.showNavButtons(false);
         if(null != this.mCurrentPanel)
         {
            this.mCurrentPanel.hidePanel();
         }
         this.mCurrentPanel = panel;
         this.mCurrentPanel.showPanel();
         this.updateTabVisibility();
      }
      
      private function onPanelClosed(panel:LoadoutViewPanelBase) : void
      {
         switch(panel)
         {
            case this.myMarketPanel:
               this.showNavButtons(true);
               this.updateTabVisibility();
               break;
            case this.myLoadoutPanel:
               this.showNavButtons(true);
               this.updateTabVisibility();
               break;
            case this.myLoadoutItemSelectPanel:
               this.showNavButtons(false);
               this.gotoPanel(this.myLoadoutPanel);
               if(this.mItemSelectVisibilityChanged != null)
               {
                  this.mItemSelectVisibilityChanged(false);
               }
               break;
            case this.myScorestreaksPanel:
               this.showNavButtons(true);
               this.updateTabVisibility();
               break;
            case this.myRequisitionsPanel:
               this.showNavButtons(true);
               this.updateTabVisibility();
         }
      }
      
      private function updateTabVisibility() : void
      {
         var dataManager:DataManager = null;
         var roomMemberObj:RoomMemberObj = null;
         if(this.mCurrentPanel == this.myLoadoutPanel)
         {
            this.refreshTabs();
            if(!this._loadoutInited)
            {
               this._loadoutInited = true;
               this.refreshLoadoutAndModel(CFunctionCommonContainer.WL_GetCurrentWeaponLoadoutIndex());
               this.myLoadoutTabs.SetSelectedIndexById(CFunctionCommonContainer.WL_GetCurrentWeaponLoadoutIndex());
            }
            dataManager = DataManager.getInstance();
            if(dataManager == null)
            {
               return;
            }
            roomMemberObj = dataManager.getDP(DataID.CURRENT_SELECTED_MEMBER_MEMBER_OBJ);
            if(roomMemberObj == null)
            {
               return;
            }
            this.myLoadoutTabs.visible = roomMemberObj.isMe;
            this.myTabsBG.visible = roomMemberObj.isMe;
         }
         else
         {
            this.myLoadoutTabs.visible = false;
            this.myTabsBG.visible = false;
         }
      }
      
      public function onGotoSupplyDrop() : void
      {
         EventManager.getInstance().broadcast(BCEvent.EVT_GOTO_SUPPLY_DROP);
      }
      
      public function onGotoLoadout() : void
      {
         this.gotoPanel(this.myLoadoutPanel);
      }
      
      public function onGotoMarket() : void
      {
         this.myMarketPanel.setMode(LobbyMarketPanel.TAB_GAMEMODE);
         this.gotoPanel(this.myMarketPanel);
      }
      
      public function onGotoKillstreaks() : void
      {
         this.gotoPanel(this.myScorestreaksPanel);
      }
      
      public function onGotoRequisitions() : void
      {
         this.gotoPanel(this.myRequisitionsPanel);
      }
      
      public function registerOnItemSelectVisibilityChanged(callback:Function) : void
      {
         this.mItemSelectVisibilityChanged = callback;
      }
      
      public function registerOnPanelClosedCallback(callback:Function) : void
      {
         this.mOnPanelClosedCallback = callback;
      }
      
      private function onLoadoutItemSelected(data:Object) : void
      {
         this.myLoadoutItemSelectPanel.setCategories(data.categories);
         this.myLoadoutItemSelectPanel.setIsPrimaryWeapon(data.isPrimary);
         this.gotoPanel(this.myLoadoutItemSelectPanel);
         if(this.mItemSelectVisibilityChanged != null)
         {
            this.mItemSelectVisibilityChanged(true);
         }
      }
      
      private function refreshTabs() : void
      {
         var loadoutIndex:int = 0;
         var locked:Boolean = false;
         if(!this.mMktDataIsReady)
         {
            return;
         }
         var currentCharacterIdx:int = CFunctionCommonContainer.CL_GetCurrentCharacterLoadoutIndex();
         var tabs:Array = new Array();
         var maxNumSlots:int = CFunctionCommonContainer.WL_GetMaxNumLoadouts();
         for(var i:int = 0; i < maxNumSlots; i++)
         {
            loadoutIndex = currentCharacterIdx * maxNumSlots + i;
            locked = !(CFunctionCommonContainer.WL_GetIsLoadoutSlotUnlocked(i) as Boolean);
            tabs.push({
               "id":i.toString(),
               "label":CFunctionContainer.WL_GetLoadoutName(loadoutIndex,i),
               "lockedForPurchase":locked
            });
         }
         tabs[1].onboardLock = CFunctionCommonContainer.GetOnboardUnlockLevel(UiCppOnboarding.FEATURE_LOADOUT_2);
         tabs[2].onboardLock = CFunctionCommonContainer.GetOnboardUnlockLevel(UiCppOnboarding.FEATURE_LOADOUT_3);
         var tabData:CustomObject = new CustomObject();
         tabData.tabClickedCallback = this.onTabClicked;
         tabData.tabs = tabs;
         tabData.tabPadding = 5;
         tabData.tabLinkage = "codo.shared.ScrollListTabButton";
         tabData.truncateText = true;
         this.myLoadoutTabs.setData(tabData);
         var loadoutIdx:int = CFunctionCommonContainer.WL_GetCurrentWeaponLoadoutIndex();
         this.myLoadoutTabs.SetSelectedIndexById(loadoutIdx);
         this.refreshLoadoutAndModel(loadoutIdx);
      }
      
      private function onCharacterChange(evt:ParaEvent) : void
      {
         this.refreshTabs();
      }
      
      private function onStageKeyHandle(e:KeyboardEvent) : void
      {
         if(e.type == KeyboardEvent.KEY_UP)
         {
            switch(e.keyCode)
            {
               case Keyboard.ESCAPE:
                  if(null != this.mCurrentPanel)
                  {
                     this.onPanelClosed(this.mCurrentPanel);
                  }
            }
         }
      }
      
      private function refreshLoadoutAndModel(loadoutId:int) : void
      {
         WeaponLoadoutService.getInstance().changeLoadout(loadoutId);
         EventManager.getInstance().broadcast(BCEvent.LOBBY_CHANGE_WEAPON_LOADOUT);
      }
      
      protected function checkPurchaseLoadout(loadoutIndex:int) : Boolean
      {
         var data:ProductObj = null;
         var isUnlocked:Boolean = CFunctionCommonContainer.WL_GetIsLoadoutSlotUnlocked(loadoutIndex) as Boolean;
         if(!isUnlocked)
         {
            data = CFunctionCommonContainer.GetItemInfo(CFunctionCommonContainer.WL_GetMarketItemIdForLoadoutIndex(loadoutIndex));
            EventManager.getInstance().broadcast(BCEvent.EVT_MARKET_PURCHASE_POPUP,{"itemData":data});
            return true;
         }
         return false;
      }
      
      private function onTabClicked(id:int) : void
      {
         if(!this.checkPurchaseLoadout(id))
         {
            this.refreshLoadoutAndModel(id);
         }
         else
         {
            this.myLoadoutTabs.SetSelectedIndexById(CFunctionCommonContainer.WL_GetCurrentWeaponLoadoutIndex());
         }
      }
      
      protected function onEquip(evt:ParaEvent) : void
      {
         if(this.myLoadoutItemSelectPanel.isShown())
         {
            this.onPanelClosed(this.myLoadoutItemSelectPanel);
            this.refreshLoadoutAndModel(CFunctionCommonContainer.WL_GetCurrentWeaponLoadoutIndex());
         }
      }
      
      private function bind_onSetCurrentlySelectedTeamMember(cRes:Object) : void
      {
         var selectedTeamMemberID:String = null;
         var roomMemberObj:RoomMemberObj = null;
         if(this.mCurrentPanel != this.myLoadoutPanel)
         {
            return;
         }
         var dataManager:DataManager = DataManager.getInstance();
         if(dataManager != null)
         {
            selectedTeamMemberID = cRes.data;
            roomMemberObj = dataManager.getDP(DataID.ROOM_MEMBER_OBJ_BY_ID,[selectedTeamMemberID]);
            if(Boolean(roomMemberObj))
            {
               this.myLoadoutTabs.visible = roomMemberObj.isMe;
               this.myTabsBG.visible = roomMemberObj.isMe;
            }
         }
      }
      
      private function onLoadoutCopied() : void
      {
         this.refreshTabs();
      }
   }
}

