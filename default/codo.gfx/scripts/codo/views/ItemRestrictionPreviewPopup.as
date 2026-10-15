package codo.views
{
   import codo.base.PopupView;
   import codo.common.CFunctionContainer;
   import codo.component.ScrollGrid;
   import codo.component.TextField;
   import codo.component.factory.ButtonFactory;
   import codo.constants.Common;
   import codo.localization.Dict;
   import codo.objects.ItemBanCategoryObj;
   import codo.objects.ItemBanObj;
   import codo.objects.ScrollGridSettings;
   import codo.objects.ScrollListHeaderObj;
   import codo.objects.ScrollListSettings;
   import codo.style.GlobalGuide;
   import codo.utils.LocalizeUtil;
   import codo.utils.MarketItemUtil;
   import flash.text.TextFormat;
   
   public class ItemRestrictionPreviewPopup extends PopupView
   {
      
      private static const POPUP_WIDTH:Number = 885;
      
      private static const LIST_HEIGHT:Number = 445;
      
      public var myDescription:TextField;
      
      public var myScrollGrid:ScrollGrid;
      
      public function ItemRestrictionPreviewPopup()
      {
         super();
         myPopup.width = POPUP_WIDTH;
         myPopup.header.setErrorMode(Dict.ITEM_RESTRICTIONS);
         var fmt:TextFormat = myPopup.header.getTextFormat();
         fmt.size = 30;
         myPopup.header.setTextFormat(fmt);
         myPopup.configConfirmButton("@SF_UI_CLOSE_SETTING",this.onConfirm);
         this.myDescription.textStyle = GlobalGuide.styleTextDescription;
         this.myDescription.width = POPUP_WIDTH - 60;
         this.myDescription.text = LocalizeUtil.localize(Dict.RESTRICTED_ITEMS_PREVIEW);
         var gridSettings:ScrollGridSettings = new ScrollGridSettings();
         gridSettings.orientation = ScrollListSettings.SCROLL_VERTICAL;
         gridSettings.useNavArrows = false;
         gridSettings.buildGridItemRenderMethod = ButtonFactory.BUILD_RESTRICTION_PREVIEW_ITEM;
         this.myScrollGrid.initGrid(gridSettings,LIST_HEIGHT,true,4);
         this.myScrollGrid.y = this.myDescription.y + this.myDescription.textHeight + 20;
      }
      
      override public function set routeData(data:*) : void
      {
         var header:ScrollListHeaderObj = null;
         var restrictionGroup:ItemBanCategoryObj = null;
         var restrictedItems:Vector.<ItemBanObj> = null;
         var listLen:int = 0;
         var j:int = 0;
         super.routeData = data;
         var headers:Vector.<ScrollListHeaderObj> = new Vector.<ScrollListHeaderObj>(0);
         var itemBans:Vector.<ItemBanCategoryObj> = CFunctionContainer.GetItemBanList(Common.ITEM_BAN_FILTER_ALL,true);
         var restrictionList:Vector.<Object> = new Vector.<Object>();
         var startIndex:int = 0;
         var len:int = int(itemBans.length);
         for(var i:int = 0; i < len; i++)
         {
            restrictionGroup = itemBans[i];
            restrictedItems = restrictionGroup.items;
            header = new ScrollListHeaderObj();
            header.beforeIndex = startIndex;
            header.count = restrictedItems.length;
            header.label = MarketItemUtil.GET_ITEM_CATEGORY_BY_GROUP(restrictionGroup.name);
            headers.push(header);
            startIndex += header.count;
            listLen = int(restrictedItems.length);
            for(j = 0; j < listLen; j++)
            {
               restrictionList.push(restrictedItems[j]);
            }
         }
         this.myScrollGrid.setHeaders(headers);
         this.myScrollGrid.addItemsByVector(restrictionList);
         var popupDefaultHeight:int = 105;
         myPopup.height = popupDefaultHeight + this.myDescription.textHeight + this.myScrollGrid.height;
      }
      
      private function onConfirm() : void
      {
         closePopupView();
      }
   }
}

