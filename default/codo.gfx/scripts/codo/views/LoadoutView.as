package codo.views
{
   import codo.base.BaseView;
   import codo.common.CFunctionCommonContainer;
   import codo.component.IconButton;
   import codo.component.factory.ButtonFactory;
   import codo.component.loadout.LoadoutViewGearPanel;
   import codo.component.loadout.LoadoutViewHomePanel;
   import codo.component.loadout.LoadoutViewLockerPanel;
   import codo.component.loadout.LoadoutViewPanelBase;
   import codo.component.loadout.LoadoutViewPlayerCardPanel;
   import codo.component.loadout.LoadoutViewRequisitionsPanel;
   import codo.component.loadout.LoadoutViewScorestreaksPanel;
   import codo.component.navigation.NavigationMenu;
   import codo.component.object.NavigationObj;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.constants.PageID;
   import codo.cpp.UiCppNewItems;
   import codo.cpp.UiCppOnboarding;
   import codo.event.ParaEvent;
   import codo.localization.Dict;
   import codo.localization.DictMarket;
   import codo.objects.VideoPlayerObj;
   import codo.style.GlobalGuide;
   import codo.utils.InventoryUtil;
   import codo.utils.ScaleformUtil;
   import flash.display.Bitmap;
   import flash.geom.Point;
   
   public class LoadoutView extends BaseView
   {
      
      public var myTabNavigation:NavigationMenu;
      
      public var myHomePanel:LoadoutViewHomePanel;
      
      public var myRequisitionsPanel:LoadoutViewRequisitionsPanel;
      
      public var myPlayerCardPanel:LoadoutViewPlayerCardPanel;
      
      public var myScorestreaksPanel:LoadoutViewScorestreaksPanel;
      
      public var myGearPanel:LoadoutViewGearPanel;
      
      public var myLockerPanel:LoadoutViewLockerPanel;
      
      public var myOpenPick10VideoButton:IconButton;
      
      private var mPanels:Vector.<LoadoutViewPanelBase>;
      
      private var mPick10VideoConfigObj:VideoPlayerObj;
      
      public function LoadoutView()
      {
         super();
         this.initStage();
         InventoryUtil.changeLoadoutTab = this.onTabChanged;
      }
      
      private function initStage() : void
      {
         var secondaryButtons:Vector.<NavigationObj> = null;
         this.configVideoPlaybackButton();
         if(true == ScaleformUtil.isScaleform)
         {
            secondaryButtons = new Vector.<NavigationObj>(InventoryUtil.NUM_TABS);
            secondaryButtons[InventoryUtil.HOME_TAB] = new NavigationObj(InventoryUtil.HOME_TAB,Dict.LOADOUT_CATEGORY_LOADOUTS);
            secondaryButtons[InventoryUtil.REQUISITION_TAB] = new NavigationObj(InventoryUtil.REQUISITION_TAB,Dict.LOADOUT_CATEGORY_REQUISITIONS);
            secondaryButtons[InventoryUtil.SCORESTREAKS_TAB] = new NavigationObj(InventoryUtil.SCORESTREAKS_TAB,Dict.LOADOUT_CATEGORY_SCORESTREAKS);
            secondaryButtons[InventoryUtil.GEAR_TAB] = new NavigationObj(InventoryUtil.GEAR_TAB,Dict.LOADOUT_CATEGORY_GEAR);
            secondaryButtons[InventoryUtil.PLAYERCARD_TAB] = new NavigationObj(InventoryUtil.PLAYERCARD_TAB,DictMarket.CATEGORY_PLAYERCARD);
            secondaryButtons[InventoryUtil.CRAFTING_TAB] = new NavigationObj(InventoryUtil.CRAFTING_TAB,DictMarket.CATEGORY_CRAFTING,true,null,null,false,null,false);
            secondaryButtons[InventoryUtil.STORAGE_TAB] = new NavigationObj(InventoryUtil.STORAGE_TAB,Dict.LOADOUT_CATEGORY_STORAGE);
         }
         else
         {
            secondaryButtons = new <NavigationObj>[new NavigationObj(InventoryUtil.HOME_TAB,"LOADOUTS"),new NavigationObj(InventoryUtil.REQUISITION_TAB,"REQUISITIONS"),new NavigationObj(InventoryUtil.SCORESTREAKS_TAB,"SCORESTREAKS"),new NavigationObj(InventoryUtil.GEAR_TAB,"GEAR"),new NavigationObj(InventoryUtil.PLAYERCARD_TAB,"PLAYER CARD"),new NavigationObj(InventoryUtil.STORAGE_TAB,"STORAGE_TAB")];
         }
         secondaryButtons[InventoryUtil.HOME_TAB].breadcrumb = UiCppNewItems.CRUMB_LOADOUT;
         secondaryButtons[InventoryUtil.REQUISITION_TAB].breadcrumb = UiCppNewItems.CRUMB_REQUISITIONS;
         secondaryButtons[InventoryUtil.SCORESTREAKS_TAB].breadcrumb = UiCppNewItems.CRUMB_STREAKS;
         secondaryButtons[InventoryUtil.GEAR_TAB].breadcrumb = UiCppNewItems.CRUMB_GEAR;
         secondaryButtons[InventoryUtil.PLAYERCARD_TAB].breadcrumb = UiCppNewItems.CRUMB_PLAYERCARD;
         secondaryButtons[InventoryUtil.REQUISITION_TAB].lockLevel = CFunctionCommonContainer.GetOnboardUnlockLevel(UiCppOnboarding.FEATURE_REQUISITIONS);
         secondaryButtons[InventoryUtil.SCORESTREAKS_TAB].lockLevel = CFunctionCommonContainer.GetOnboardUnlockLevel(UiCppOnboarding.FEATURE_STREAKS);
         secondaryButtons[InventoryUtil.GEAR_TAB].lockLevel = CFunctionCommonContainer.GetOnboardUnlockLevel(UiCppOnboarding.FEATURE_GEAR);
         secondaryButtons[InventoryUtil.PLAYERCARD_TAB].lockLevel = CFunctionCommonContainer.GetOnboardUnlockLevel(UiCppOnboarding.FEATURE_PLAYERCARD);
         this.myTabNavigation.navButtonRenderMethod = ButtonFactory.BUILD_SECONDARY_MENU_BUTTON;
         this.myTabNavigation.listItemClickCallback = this.onTabClicked;
         this.myTabNavigation.setData(secondaryButtons);
         this.myTabNavigation.selectedIndex = InventoryUtil.getCurrentTab();
         this.mPanels = new Vector.<LoadoutViewPanelBase>(InventoryUtil.NUM_TABS);
         this.mPanels[InventoryUtil.HOME_TAB] = this.myHomePanel;
         this.mPanels[InventoryUtil.REQUISITION_TAB] = this.myRequisitionsPanel;
         this.mPanels[InventoryUtil.SCORESTREAKS_TAB] = this.myScorestreaksPanel;
         this.mPanels[InventoryUtil.GEAR_TAB] = this.myGearPanel;
         this.mPanels[InventoryUtil.PLAYERCARD_TAB] = this.myPlayerCardPanel;
         this.mPanels[InventoryUtil.STORAGE_TAB] = this.myLockerPanel;
      }
      
      private function configVideoPlaybackButton() : void
      {
         this.mPick10VideoConfigObj = new VideoPlayerObj("tutorial_pick10",new Point(1280,720),new Bitmap(new uiInventoryPick10Cover()));
         this.myOpenPick10VideoButton.label = Dict.PICK_10_TUTORIAL;
         this.myOpenPick10VideoButton.customIconButtonSize = new Point(this.myOpenPick10VideoButton.width,32);
         this.myOpenPick10VideoButton.setImage("information_icon.tga");
         this.myOpenPick10VideoButton.registerClickEvent(this.openPick10Video);
         this.myOpenPick10VideoButton.setMarketReadyMode(true);
         this.myOpenPick10VideoButton.visible = false;
         this.myOpenPick10VideoButton.x = 944 - this.myOpenPick10VideoButton.width - GlobalGuide.COMPONENT_PADDING * 2;
         this.myOpenPick10VideoButton.y = 220;
         this.myHomePanel.addChild(this.myOpenPick10VideoButton);
      }
      
      private function onTabChanged(prev:int, tab:int) : void
      {
         this.mPanels[prev].hidePanel();
         this.myTabNavigation.selectedIndex = tab;
         if(visible)
         {
            this.showPanel();
         }
      }
      
      override protected function showView() : void
      {
         super.showView();
         this.showPanel();
         this.myTabNavigation.showMenu();
         listen(BCEvent.EVT_MARKET_UPDATE_PREVIEW_LIST,this.onUpdatePreviewList);
         bind(DataID.IS_PICK_10_TUTORIAL_VISIBILITY,this.onPick10TutorialVisibilityChanged);
      }
      
      override protected function hideView() : void
      {
         super.hideView();
         this.mPanels[InventoryUtil.getCurrentTab()].hidePanel();
         this.myTabNavigation.hideMenu();
         unlisten(BCEvent.EVT_MARKET_UPDATE_PREVIEW_LIST,this.onUpdatePreviewList);
         unbind(DataID.IS_PICK_10_TUTORIAL_VISIBILITY,this.onPick10TutorialVisibilityChanged);
      }
      
      private function openPick10Video() : void
      {
         broadcast(BCEvent.EVT_ROUTE_TO_PAGE,{
            "page":PageID.VIDEO_PLAYER,
            "routeData":this.mPick10VideoConfigObj
         });
      }
      
      private function onTabClicked(tab:NavigationObj) : void
      {
         broadcast(BCEvent.EVT_END_TUTORIAL,_pageID);
         InventoryUtil.setCurrentTab(tab.index);
      }
      
      private function showPanel() : void
      {
         var tab:int = 0;
         tab = InventoryUtil.getCurrentTab();
         this.myOpenPick10VideoButton.visible = false;
         this.mPanels[tab].showPanel();
      }
      
      private function onUpdatePreviewList(e:ParaEvent) : void
      {
         var gearPanel:LoadoutViewGearPanel = null;
         var curTab:int = InventoryUtil.getCurrentTab();
         if(curTab == InventoryUtil.GEAR_TAB)
         {
            gearPanel = this.mPanels[curTab] as LoadoutViewGearPanel;
            if(gearPanel != null)
            {
               gearPanel.updatePreviewList();
            }
         }
      }
      
      private function onPick10TutorialVisibilityChanged(res:Object) : void
      {
         if(res.data == null)
         {
            this.myOpenPick10VideoButton.visible = false;
            return;
         }
         this.myOpenPick10VideoButton.visible = res.data as Boolean;
      }
   }
}

