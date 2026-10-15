package codo.views
{
   import codo.base.PopupView;
   import codo.component.ScrollGrid;
   import codo.component.TextField;
   import codo.component.factory.ButtonFactory;
   import codo.localization.Dict;
   import codo.objects.ScrollGridSettings;
   import codo.objects.ScrollListSettings;
   import codo.style.GlobalGuide;
   import codo.utils.LocalizeUtil;
   import flash.text.TextFormat;
   
   public class ItemRestrictionWarningPopup extends PopupView
   {
      
      private static const POPUP_WIDTH:Number = 885;
      
      private static const NUM_COLUMNS:uint = 4;
      
      public var myDescription:TextField;
      
      public var myScrollGrid:ScrollGrid;
      
      public function ItemRestrictionWarningPopup()
      {
         super();
         myPopup.width = POPUP_WIDTH;
         myPopup.header.setErrorMode(Dict.RESTRICTED_ITEMS_EQUIPPED);
         var fmt:TextFormat = myPopup.header.getTextFormat();
         fmt.size = 30;
         myPopup.header.setTextFormat(fmt);
         myPopup.configConfirmButton(Dict.CONTINUE,this.onConfirm);
         this.myDescription.textStyle = GlobalGuide.styleTextDescription;
         this.myDescription.width = POPUP_WIDTH - 60;
         this.myDescription.text = LocalizeUtil.localize(Dict.RESTRICTED_ITEMS_WARNING);
         this.myScrollGrid.y = this.myDescription.y + this.myDescription.textHeight + 20;
      }
      
      override public function set routeData(data:*) : void
      {
         super.routeData = data;
         var itemList:Vector.<Object> = data;
         var numRows:int = Math.ceil(itemList.length / NUM_COLUMNS);
         numRows = Math.min(numRows,3);
         numRows = Math.max(numRows,1);
         var gridSettings:ScrollGridSettings = new ScrollGridSettings();
         gridSettings.orientation = ScrollListSettings.SCROLL_VERTICAL;
         gridSettings.useNavArrows = false;
         gridSettings.buildGridItemRenderMethod = ButtonFactory.BUILD_RESTRICTION_PREVIEW_ITEM;
         this.myScrollGrid.initGrid(gridSettings,numRows,false,NUM_COLUMNS);
         this.myScrollGrid.addItemsByVector(itemList);
         var popupDefaultHeight:int = 105;
         myPopup.height = popupDefaultHeight + this.myDescription.textHeight + this.myScrollGrid.height;
      }
      
      private function onConfirm() : void
      {
         closePopupView();
      }
   }
}

