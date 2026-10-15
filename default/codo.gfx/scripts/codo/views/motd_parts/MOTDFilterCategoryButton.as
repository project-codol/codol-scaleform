package codo.views.motd_parts
{
   import codo.common.CFunctionContainer;
   import codo.component.core.UIInteractiveComponent;
   import codo.component.filter.FilterCategoryButton;
   import codo.objects.FilterObj;
   import codo.objects.MOTDMessageObj;
   import flash.display.DisplayObjectContainer;
   import flash.text.TextFieldAutoSize;
   import scaleform.gfx.TextFieldEx;
   
   public class MOTDFilterCategoryButton extends FilterCategoryButton
   {
      
      public static const MAX_LIST_HEIGHT:int = 446;
      
      public static const OPTION_WIDTH_IF_SCROLL_ENABLED:int = 432;
      
      public var mySubCategoryScrollList:MOTDFilterCategoryButtonScrollList;
      
      private var mSubCategoryMount:DisplayObjectContainer;
      
      private var mItemData:FilterObj;
      
      public function MOTDFilterCategoryButton()
      {
         super();
         this.mSubCategoryMount = this.mySubCategoryScrollList.getChildByName("mySubCategoryMount") as DisplayObjectContainer;
         listHeightMax = MAX_LIST_HEIGHT;
         styleAlternateRows = true;
         this.mySubCategoryScrollList.listMaxHeight = MAX_LIST_HEIGHT;
         this.mySubCategoryScrollList.width = myListBackground.width;
         TextFieldEx.setVerticalAlign(myNewTag.myLabelTF,TextFieldEx.VALIGN_CENTER);
         myNewTag.y = (myBackground.height - myNewTag.height) * 0.5;
         this.draw();
      }
      
      override public function setData(data:*) : void
      {
         super.setData(data);
         this.mItemData = data as FilterObj;
         enabled = data.enabled;
         if(!enabled)
         {
            myLabel.alpha = 0.3;
         }
         this.updateMessageCount();
      }
      
      public function updateMessageCount() : void
      {
         var i:int = 0;
         var numItemsInCategory:int = 0;
         var motdItems:Array = null;
         var len:int = 0;
         var motdItemData:MOTDMessageObj = null;
         if(this.mItemData.child != null && this.mItemData.child.length > 0)
         {
            i = 0;
            numItemsInCategory = 0;
            motdItems = this.mItemData.child;
            for(len = int(motdItems.length); i < len; )
            {
               motdItemData = motdItems[i];
               if(!motdItemData.beViewed)
               {
                  numItemsInCategory++;
               }
               i++;
            }
            this.newItemCount = numItemsInCategory;
         }
      }
      
      public function setSelectedItemViewed() : void
      {
         var selectedItem:MOTDFilterOption = null;
         var data:MOTDMessageObj = this.selectedItemData;
         if(!data.beViewed)
         {
            CFunctionContainer.AS_SetMOTDMessageViewed(data.id);
            data.beViewed = true;
            selectedItem = mItems[selectedIndex] as MOTDFilterOption;
            if(selectedItem != null)
            {
               selectedItem.myNewTag.visible = false;
            }
         }
      }
      
      public function get selectedItemData() : MOTDMessageObj
      {
         return this.mItemData.child[selectedIndex];
      }
      
      override protected function get filterCategoryOptionClassPath() : String
      {
         return "codo.shared.motd.MOTDFilterOption";
      }
      
      override public function draw() : void
      {
         super.draw();
         var PADDING:int = 10;
         myNewTag.x = myBackground.width - (myNewTag.width + PADDING);
         myLabel.autoSize = TextFieldAutoSize.NONE;
         myLabel.width = myNewTag.x - myLabel.x - PADDING;
         myFocusLine.scaleX = 0;
      }
      
      public function set newItemCount(val:int) : void
      {
         isNewCategory = val > 0 ? true : false;
         myNewTag.myLabelTF.text = val.toString();
      }
      
      override public function set subCategories(data:Array) : void
      {
         var item:UIInteractiveComponent = null;
         super.subCategories = data;
         this.mySubCategoryScrollList.height = this.mSubCategoryMount.height;
         if(this.mySubCategoryScrollList.visible)
         {
            for each(item in mItems)
            {
               item.width = OPTION_WIDTH_IF_SCROLL_ENABLED;
            }
         }
      }
      
      override public function get optionListAnimTarget() : DisplayObjectContainer
      {
         return this.mySubCategoryScrollList;
      }
      
      override public function get subCategoryMount() : DisplayObjectContainer
      {
         return this.mSubCategoryMount;
      }
   }
}

