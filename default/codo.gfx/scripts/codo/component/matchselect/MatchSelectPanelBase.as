package codo.component.matchselect
{
   import codo.component.ScrollList;
   import codo.component.TextField;
   import codo.component.ViewPanelBase;
   import codo.component.factory.ButtonFactory;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.manager.DataManager;
   import codo.manager.EventManager;
   import codo.objects.ScrollListSettings;
   import flash.display.Sprite;
   
   public class MatchSelectPanelBase extends ViewPanelBase
   {
      
      protected static const LEFT_LIST_BACKGROUND_WIDTH:Number = 389;
      
      protected static const LEFT_LIST_WIDTH:Number = 349;
      
      protected static const LIST_WIDTH:Number = 639;
      
      protected static const LIST_BACKGROUND_HEIGHT:Number = 769;
      
      protected static const LIST_HEIGHT:Number = 692;
      
      public var myLeftList:ScrollList;
      
      public var myMiddleList:ScrollList;
      
      public var myLeftListBackground:Sprite;
      
      public var myMiddleListBackground:Sprite;
      
      public var myHeader:TextField;
      
      public var myModeInfo:MatchSelectModeInfo;
      
      public function MatchSelectPanelBase()
      {
         super();
         this.initStage();
         if(typeof this != typeof MatchSelectTheatrePanel)
         {
            this.myModeInfo.registerItemRestrictionCallback(this.onShowItemRestrictions);
         }
      }
      
      protected function initStage() : void
      {
         var leftListSettings:ScrollListSettings = null;
         leftListSettings = new ScrollListSettings();
         leftListSettings.orientation = ScrollListSettings.SCROLL_VERTICAL;
         leftListSettings.useNavArrows = false;
         leftListSettings.autoSize = false;
         leftListSettings.autoSizeItems = true;
         leftListSettings.buildGridItemRenderMethod = ButtonFactory.BUILD_MATCH_SELECT_MODE_OPTION;
         leftListSettings.itemPadding = 0;
         this.myLeftList.settings = leftListSettings;
         var rightListSettings:ScrollListSettings = new ScrollListSettings();
         rightListSettings.orientation = ScrollListSettings.SCROLL_VERTICAL;
         rightListSettings.useNavArrows = false;
         rightListSettings.autoSize = false;
         rightListSettings.autoSizeItems = true;
         rightListSettings.buildGridItemRenderMethod = ButtonFactory.BUILD_MATCH_SELECT_OPTION;
         rightListSettings.itemPadding = 0;
         this.myMiddleList.settings = rightListSettings;
         this.myMiddleList.listItemDoubleClickCallback = this.onStartMatch;
         this.myLeftList.width = LEFT_LIST_WIDTH;
         this.myMiddleList.width = LIST_WIDTH;
         this.myLeftList.height = this.myMiddleList.height = LIST_HEIGHT;
         this.myLeftListBackground.width = LEFT_LIST_BACKGROUND_WIDTH;
         this.myMiddleListBackground.width = LIST_WIDTH;
         this.myLeftListBackground.height = this.myMiddleListBackground.height = LIST_BACKGROUND_HEIGHT;
      }
      
      override protected function enableData() : void
      {
         super.enableData();
         DataManager.getInstance().bind(DataID.DATA_RECEIVE,this.checkReadyFlags,null,false);
         DataManager.getInstance().bind(DataID.MARKETPLACE_MAINTAIN_STATE,this.checkReadyFlags,null,false);
         this.checkReadyFlags();
      }
      
      override protected function disableData() : void
      {
         super.disableData();
         DataManager.getInstance().unbind(DataID.DATA_RECEIVE,this.checkReadyFlags);
         DataManager.getInstance().unbind(DataID.MARKETPLACE_MAINTAIN_STATE,this.checkReadyFlags);
      }
      
      protected function checkReadyFlags(cRes:Object = null) : void
      {
         var isMarketplaceReady:Boolean = DataManager.getInstance().getDP(DataID.IS_MARKETPLACE_READY);
         var isMarketplaceMaintain:Boolean = DataManager.getInstance().getDP(DataID.IS_MARKETPLACE_MAINTAIN);
         this.setMarketReady(isMarketplaceReady && !isMarketplaceMaintain);
      }
      
      protected function setMarketReady(ready:Boolean) : void
      {
      }
      
      protected function playerRangeString(minPlayers:int, maxPlayers:int) : String
      {
         return minPlayers + " ~ " + maxPlayers;
      }
      
      protected function playerNumString(curPlayers:int, maxPlayers:int) : String
      {
         return curPlayers + " / " + maxPlayers;
      }
      
      protected function onStartMatch() : void
      {
      }
      
      protected function onShowItemRestrictions() : void
      {
         var itemList:Vector.<Object> = new Vector.<Object>();
         EventManager.getInstance().broadcast(BCEvent.SHOW_MATCH_ITEM_RESTRICTIONS,itemList);
      }
   }
}

