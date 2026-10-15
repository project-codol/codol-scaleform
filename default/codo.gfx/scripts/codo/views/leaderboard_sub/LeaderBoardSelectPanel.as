package codo.views.leaderboard_sub
{
   import codo.base.BaseSubElement;
   import codo.common.CFunctionCommonContainer;
   import codo.component.ScrollGrid;
   import codo.component.social.SocialSimpleContainer;
   import codo.component.social.SocialTabButton;
   import codo.localization.Dict;
   import codo.objects.ScrollListSettings;
   import codo.objects.SocialTabSetting;
   import codo.views.leaderboard_sub.selection_sub.LeaderBoardMainTab;
   import flash.display.MovieClip;
   
   public class LeaderBoardSelectPanel extends BaseSubElement
   {
      
      private static const ITEM_LINKAGE:String = "codo.social.leaderboard.LeaderBoardItemSelect";
      
      private static const PVP_INDEX:int = 0;
      
      private static const PVE_INDEX:int = 1;
      
      private static const CONTAINER_WIDTH:int = 390;
      
      private static const CONTAINER_HEIGHT:int = 506;
      
      public var myLeaderBoardSelectTab:LeaderBoardMainTab;
      
      public var myScrollGrid:ScrollGrid;
      
      public var myDivisor:MovieClip;
      
      public var myContainer:SocialSimpleContainer;
      
      private var mNavigateData:SocialTabSetting;
      
      private var mSetting:ScrollListSettings;
      
      private var mCurrentLB:Vector.<Object>;
      
      private var mPvPLB:Vector.<Object>;
      
      private var mPvELB:Vector.<Object>;
      
      private var mCurrentGroupIndex:int = 0;
      
      private var mLBSelectionChangeHandler:Function;
      
      private var mLBSelectionKeeper:Vector.<int> = new Vector.<int>();
      
      public function LeaderBoardSelectPanel()
      {
         super();
         this.initStage();
      }
      
      private function initStage() : void
      {
         this.mNavigateData = new SocialTabSetting();
         this.mNavigateData.needBg = false;
         this.mNavigateData.tabSelectedCallback = this.onTabSelectedCallback;
         this.mNavigateData.labels = [Dict.MATCH_SELECT_MENU_OPTION_PVP,Dict.MATCH_SELECT_MENU_OPTION_PVE];
         this.mNavigateData.padding = 10;
         this.myLeaderBoardSelectTab.setTabType(SocialTabButton.TYPE_SMALL);
         this.myLeaderBoardSelectTab.setData(this.mNavigateData);
         this.myLeaderBoardSelectTab.selectTab(0);
         this.mSetting = new ScrollListSettings();
         this.mSetting.orientation = ScrollListSettings.SCROLL_VERTICAL;
         this.mSetting.useNavArrows = false;
         this.mSetting.itemLinkage = ITEM_LINKAGE;
         this.mSetting.itemPadding = 2;
         this.mSetting.autoSize = false;
         this.myScrollGrid.initGrid(this.mSetting,13,false,1);
         this.myContainer.width = CONTAINER_WIDTH;
         this.myContainer.height = CONTAINER_HEIGHT;
         this.myScrollGrid.selectionChangeCallback = this.onLBSelectionChanged;
      }
      
      override public function active() : void
      {
         super.active();
         this.myScrollGrid.myScrollBar.setPosition(0,false);
      }
      
      override public function deactive() : void
      {
         super.deactive();
      }
      
      public function setData(pvpLB:Vector.<Object>, pveLB:Vector.<Object>) : void
      {
         this.mPvPLB = pvpLB;
         this.mPvELB = pveLB;
         this.mLBSelectionKeeper[PVP_INDEX] = 0;
         this.mLBSelectionKeeper[PVE_INDEX] = 0;
         this.refresh();
      }
      
      private function refresh() : void
      {
         if(this.mCurrentGroupIndex == PVP_INDEX)
         {
            this.mCurrentLB = this.mPvPLB;
         }
         else if(this.mCurrentGroupIndex == PVE_INDEX)
         {
            this.mCurrentLB = this.mPvELB;
         }
         if(Boolean(this.mCurrentLB))
         {
            this.myScrollGrid.addItemsByVector(this.mCurrentLB);
            this.myScrollGrid.width = 377;
            this.myScrollGrid.refreshVisuals();
            this.selectLeaderBoardByIndex(0);
         }
      }
      
      private function selectLeaderBoardByIndex(index:int) : void
      {
         if(Boolean(this.mCurrentLB) && index < this.mCurrentLB.length)
         {
            this.myScrollGrid.selectedIndex = index;
         }
      }
      
      private function onTabSelectedCallback(index:int) : void
      {
         this.mCurrentGroupIndex = index;
         this.refresh();
      }
      
      public function registerLBSelectionChangeHandler(handler:Function) : void
      {
         this.mLBSelectionChangeHandler = handler;
      }
      
      private function onLBSelectionChanged() : void
      {
         if(this.mLBSelectionChangeHandler != null && this.mCurrentLB != null)
         {
            CFunctionCommonContainer.Assert(this.mCurrentGroupIndex < this.mLBSelectionKeeper.length,new Error());
            CFunctionCommonContainer.Assert(this.mCurrentLB.length >= 1,new Error());
            this.mLBSelectionKeeper[this.mCurrentGroupIndex] = this.myScrollGrid.selectedIndex;
            this.mLBSelectionChangeHandler(this.myScrollGrid.selectedData);
         }
      }
   }
}

