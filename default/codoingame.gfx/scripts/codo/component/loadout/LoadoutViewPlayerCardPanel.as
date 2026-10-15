package codo.component.loadout
{
   import codo.component.ItemFooterButton;
   import codo.component.MarketScrollGrid;
   import codo.component.PlayerCard;
   import codo.component.ScrollGrid;
   import codo.component.factory.MarketFactory;
   import codo.component.filter.Filter;
   import codo.component.marketplaceitem.parts.MarketplaceItemTools;
   import codo.constants.BCEvent;
   import codo.constants.MarketMenuData;
   import codo.cpp.IUiCppItemListView;
   import codo.cpp.UiCppItemListView;
   import codo.cpp.UiCppView;
   import codo.localization.Dict;
   import codo.localization.DictCareer;
   import codo.manager.EventManager;
   import codo.objects.CallSignObj;
   import codo.objects.PlayerObj;
   import codo.objects.ProductObj;
   import codo.objects.ScrollGridSettings;
   import codo.objects.ScrollListSettings;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   import flash.utils.Dictionary;
   import fsg.util.FsgUtil;
   
   public class LoadoutViewPlayerCardPanel extends LoadoutViewPanelBase implements IUiCppItemListView
   {
      
      public static const CONTAINER_WIDTH:Number = 778;
      
      public static const CONTAINER_HEIGHT:Number = 791;
      
      private static const INSTRUCTIONS_WIDTH:Number = 180;
      
      private static const INSTRUCTIONS_HEIGHT:Number = 124;
      
      private static const MASK_SIZE_Y:Number = 627;
      
      public var myFilter:Filter;
      
      public var myFrame:MovieClip;
      
      public var myScrollGrid:ScrollGrid;
      
      public var myPlayerCard:PlayerCard;
      
      protected var _itemsData:Array;
      
      protected var _itemsPreviewed:Dictionary;
      
      protected var _currentCallSign:CallSignObj;
      
      public function LoadoutViewPlayerCardPanel()
      {
         super();
         this._itemsPreviewed = new Dictionary();
         this.clearPreviewCache();
         this.initStage();
      }
      
      public function initStage() : void
      {
         this.myFrame.width = CONTAINER_WIDTH;
         this.myFrame.height = CONTAINER_HEIGHT;
         this.myScrollGrid.setFrame(this.myFrame,164);
         this.myFilter.singleOptionMode = true;
         var gridSettings:ScrollGridSettings = new ScrollGridSettings();
         gridSettings.orientation = ScrollListSettings.SCROLL_VERTICAL;
         gridSettings.buildGridItemRenderMethod = MarketFactory.BUILD_MARKET_ITEM_SMALL_CARD_WITH_MARKET_TOOLS;
         gridSettings.useNavArrows = false;
         this.myScrollGrid.listItemFooterClickCallback = this.onItemFooterClicked;
         this.myScrollGrid.initGrid(gridSettings,MASK_SIZE_Y,true,3);
         myInstructions.width = INSTRUCTIONS_WIDTH;
         myInstructions.height = INSTRUCTIONS_HEIGHT;
         myInstructions.text = LocalizeUtil.localize(Dict.LOADOUT_PLAYERCARD_INSTRUCTIONS);
         myHeaderTitle.width = INSTRUCTIONS_WIDTH;
         myHeaderTitle.text = LocalizeUtil.localize(DictCareer.CAREER_CALLSIGN);
      }
      
      override protected function enableData() : void
      {
         super.enableData();
         this.onCareerInfoUpdate();
         EventManager.getInstance().listen(BCEvent.EVT_ON_CAREER_INFO_UPDATED,this.onCareerInfoUpdate);
         EventManager.getInstance().listen(BCEvent.EVT_CALLSIGN_REFRESH,this.onCareerInfoUpdate);
      }
      
      override protected function disableData() : void
      {
         super.disableData();
         EventManager.getInstance().unlisten(BCEvent.EVT_ON_CAREER_INFO_UPDATED,this.onCareerInfoUpdate);
         EventManager.getInstance().unlisten(BCEvent.EVT_CALLSIGN_REFRESH,this.onCareerInfoUpdate);
      }
      
      private function onCareerInfoUpdate() : void
      {
         this.clearPreviewCache();
         this.setPlayerCardData(PlayerObj.getObj());
      }
      
      override protected function makeUiCpp() : UiCppView
      {
         return new UiCppItemListView(this,null,null,this.myFilter.getUiCpp());
      }
      
      override protected function onInit() : void
      {
         super.onInit();
         var categoryArr:Array = [MarketMenuData.CATEGORY_PLAYER];
         UiCppItemListView(_uiCpp).SetInitData(categoryArr,true);
      }
      
      public function uiCppSetItems(list1:Array, list2:Array, ownedFirst:Boolean) : void
      {
         this._itemsData = MarketScrollGrid.initSplitList(this.myScrollGrid,true,list1,list2,ownedFirst);
         this.refresh();
      }
      
      private function clearPreviewCache() : void
      {
         this._itemsPreviewed[MarketMenuData.TYPE_CALLSIGN_BKG] = null;
         this._itemsPreviewed[MarketMenuData.TYPE_CALLSIGN_TITLE] = null;
         this._itemsPreviewed[MarketMenuData.TYPE_CALLSIGN_EMBLEM] = null;
         this._itemsPreviewed[MarketMenuData.TYPE_CALLSIGN_NAMEPLATE] = null;
         this._itemsPreviewed[MarketMenuData.TYPE_CALLSIGN_FRAME] = null;
      }
      
      private function refresh() : void
      {
         var product:ProductObj = null;
         var item:Object = null;
         var gridItems:Vector.<Object> = new Vector.<Object>();
         for(var itemIdx:int = 0; itemIdx < this._itemsData.length; itemIdx++)
         {
            product = this._itemsData[itemIdx];
            product.beingPreviewed = false;
            for each(item in this._itemsPreviewed)
            {
               if(product.id == item)
               {
                  product.beingPreviewed = true;
                  break;
               }
            }
            gridItems.push(product);
         }
         this.myScrollGrid.addItemsByVector(gridItems);
      }
      
      private function setPlayerCardData(cDat:PlayerObj) : void
      {
         var prestigeLevel:String = null;
         if(cDat != null)
         {
            if(cDat.name != null)
            {
               this.myPlayerCard.setName(cDat.name);
            }
            else
            {
               this.myPlayerCard.setName("");
            }
            if(cDat.clanName != null)
            {
               this.myPlayerCard.setClanName(cDat.clanName);
            }
            else
            {
               this.myPlayerCard.setClanName("");
            }
            if(cDat.careerData != null)
            {
               this.myPlayerCard.setRank(cDat.careerData.currentLevel);
               prestigeLevel = cDat.careerData.prestige == 0 ? "" : cDat.careerData.prestige.toString();
               this.myPlayerCard.setPrestige(prestigeLevel);
               this.myPlayerCard.setPrestigeIcon(FsgUtil.getPrestigeIcon(cDat.careerData.prestige));
            }
            else
            {
               this.myPlayerCard.setRank("");
               this.myPlayerCard.setPrestige("");
            }
            if(cDat.callSignObj != null)
            {
               if(cDat.callSignObj.cardTitle != null)
               {
                  this.myPlayerCard.setTitle(cDat.callSignObj.cardTitle);
               }
               this.myPlayerCard.setBackground(cDat.callSignObj.cardBackgroundURL);
               this.myPlayerCard.setEmblem(cDat.callSignObj.cardIconURL);
               this.myPlayerCard.setNameplate(cDat.callSignObj.cardNameplateColor);
               this.myPlayerCard.setFrame(cDat.callSignObj.cardFrameURL);
            }
            this._currentCallSign = cDat.callSignObj;
         }
      }
      
      protected function updatePreview(prod:ProductObj, equipDefault:Boolean = false) : void
      {
         if(prod.type == MarketMenuData.TYPE_CALLSIGN_TITLE)
         {
            this.myPlayerCard.setTitle(equipDefault ? this._currentCallSign.cardTitle : prod.name);
         }
         else if(prod.type == MarketMenuData.TYPE_CALLSIGN_EMBLEM)
         {
            this.myPlayerCard.setEmblem(equipDefault ? this._currentCallSign.cardIconURL : prod.imageURL);
         }
         else if(prod.type == MarketMenuData.TYPE_CALLSIGN_BKG)
         {
            this.myPlayerCard.setBackground(equipDefault ? this._currentCallSign.cardBackgroundURL : prod.imageURL);
         }
         else if(prod.type == MarketMenuData.TYPE_CALLSIGN_NAMEPLATE)
         {
            this.myPlayerCard.setNameplate(equipDefault ? this._currentCallSign.cardNameplateColor : prod.color);
         }
         else if(prod.type == MarketMenuData.TYPE_CALLSIGN_FRAME)
         {
            this.myPlayerCard.setFrame(equipDefault ? this._currentCallSign.cardFrameURL : prod.imageURL);
         }
      }
      
      private function onItemFooterClicked(selectedFooterItem:ItemFooterButton) : void
      {
         var data:ProductObj = selectedFooterItem.getData() as ProductObj;
         switch(selectedFooterItem.index)
         {
            case MarketplaceItemTools.MARKET_TOOL_PREVIEW:
               this.updatePreview(data,this.updatePreviewCache(data));
         }
      }
      
      private function updatePreviewCache(item:ProductObj) : Boolean
      {
         var result:Boolean = false;
         if(this._itemsPreviewed[item.type] == item.id)
         {
            this._itemsPreviewed[item.type] = null;
            result = true;
         }
         else
         {
            result = false;
            this._itemsPreviewed[item.type] = item.id;
         }
         this.refresh();
         return result;
      }
   }
}

