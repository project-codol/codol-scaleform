package codo.component
{
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.manager.DataManager;
   import codo.manager.EventManager;
   import codo.objects.ProductObj;
   import codo.objects.ScrollListHeaderObj;
   import codo.utils.DataUtil;
   
   public class MarketScrollGrid extends ScrollGrid
   {
      
      private var mItemsData:Array;
      
      public function MarketScrollGrid()
      {
         super();
      }
      
      public static function initSplitList(grid:ScrollGrid, needHeader:Boolean, list1:Array, list2:Array, list1TextFirst:Boolean, list1Text:String = "@UI_MARKET_OWNED_ITEMS", list2Text:String = "@UI_MARKET_UNOWNED_ITEMS") : Array
      {
         var header:ScrollListHeaderObj = null;
         var headers:Vector.<ScrollListHeaderObj> = new Vector.<ScrollListHeaderObj>(0);
         if(needHeader)
         {
            if(list1.length > 0)
            {
               header = new ScrollListHeaderObj();
               header.beforeIndex = 0;
               header.count = list1.length;
               header.label = list1TextFirst ? list1Text : list2Text;
               headers.push(header);
            }
            if(list2.length > 0)
            {
               header = new ScrollListHeaderObj();
               header.beforeIndex = list1.length;
               header.count = list2.length;
               header.label = list1TextFirst ? list2Text : list1Text;
               headers.push(header);
            }
         }
         grid.setHeaders(headers);
         return list1.concat(list2);
      }
      
      public function setItemsData(list1:Array, list2:Array, list1First:Boolean, needHeader:Boolean = true, listHeader1:String = "@UI_MARKET_OWNED_ITEMS", listHeader2:String = "@UI_MARKET_UNOWNED_ITEMS") : void
      {
         this.mItemsData = initSplitList(this,needHeader,list1,list2,list1First,listHeader1,listHeader2);
      }
      
      public function setItemsDataCustom(itemListArray:Array, needHeader:Boolean = true) : void
      {
         var header:ScrollListHeaderObj = null;
         var itemListObj:Object = null;
         var list:Array = null;
         this.mItemsData = [];
         var headers:Vector.<ScrollListHeaderObj> = new Vector.<ScrollListHeaderObj>(0);
         for each(itemListObj in itemListArray)
         {
            list = itemListObj.list;
            if(list.length > 0)
            {
               if(needHeader)
               {
                  header = new ScrollListHeaderObj();
                  header.beforeIndex = this.mItemsData.length;
                  header.count = list.length;
                  header.label = itemListObj.label;
                  headers.push(header);
               }
               this.mItemsData = this.mItemsData.concat(list);
            }
         }
         setHeaders(headers);
      }
      
      public function refresh() : void
      {
         var product:ProductObj = null;
         var newCompareItem:ProductObj = null;
         var j:int = 0;
         if(this.mItemsData == null)
         {
            return;
         }
         var marketItemsData:Vector.<Object> = new Vector.<Object>();
         var compareItem:ProductObj = DataManager.getInstance().getDP(DataID.MARKET_COMPARE_ITEM) as ProductObj;
         var previewItems:Array = DataManager.getInstance().getDP(DataID.MARKET_PREVIEW_ITEMS);
         var numPreviewItems:int = int(previewItems.length);
         var numItems:int = int(this.mItemsData.length);
         for(var itemIdx:int = 0; itemIdx < numItems; itemIdx++)
         {
            product = this.mItemsData[itemIdx];
            product.beingPreviewed = false;
            for(j = 0; j < numPreviewItems; j++)
            {
               if(product.id == previewItems[j].id)
               {
                  product.beingPreviewed = true;
                  break;
               }
            }
            if(compareItem != null && compareItem.id == product.id)
            {
               product.beingCompared = true;
               newCompareItem = product;
            }
            else
            {
               product.beingCompared = false;
            }
            marketItemsData.push(product);
         }
         EventManager.getInstance().broadcast(BCEvent.EVT_MARKET_SET_COMPARE_ITEM,newCompareItem);
         this.addItemsByVector(marketItemsData);
      }
      
      override public function addItemsByVector(content:Vector.<Object>) : void
      {
         var siblings:Vector.<ProductObj> = null;
         var i:int = 0;
         if(content.length > 0 && content[0] is ProductObj)
         {
            siblings = DataUtil.copyElems(new Vector.<ProductObj>(0),content);
            for(i = 0; i < content.length; i++)
            {
               (content[i] as ProductObj).listSiblings = siblings;
            }
         }
         super.addItemsByVector(content);
      }
      
      public function previewItemUpdated() : void
      {
         if(!parent.visible)
         {
            return;
         }
         this.refresh();
      }
   }
}

