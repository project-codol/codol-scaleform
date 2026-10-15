package codo.component.loadout
{
   import codo.common.CFunctionCommonContainer;
   import codo.component.ItemPreviewBox;
   import codo.component.ScrollGrid;
   import codo.component.ScrollList;
   import codo.component.factory.MarketFactory;
   import codo.constants.ItemType;
   import codo.objects.ProductObj;
   import codo.objects.SDPItemObj;
   import codo.objects.SDPSubGroupObj;
   import codo.objects.ScrollGridSettings;
   import codo.objects.ScrollListSettings;
   import codo.utils.SDPlusPvpUtil;
   import flash.display.MovieClip;
   
   public class SDPlusItemSelector extends MovieClip
   {
      
      private static const MASK_SIZE_Y:Number = 548;
      
      public var myItemPreviewBox:ItemPreviewBox;
      
      public var myScrollGrid:ScrollGrid;
      
      public var myFilterList:ScrollList;
      
      public var myFilterBackground:MovieClip;
      
      public var myBackground:MovieClip;
      
      private var mComparePrimaryWeapon:Boolean = false;
      
      private var mGroup:String = "";
      
      public function SDPlusItemSelector()
      {
         var gridSettings:ScrollGridSettings = null;
         super();
         this.myScrollGrid.listItemFocusCallback = this.onListItemFocused;
         this.myScrollGrid.listItemUnfocusCallback = this.onListItemUnfocused;
         gridSettings = new ScrollGridSettings();
         gridSettings.orientation = ScrollListSettings.SCROLL_VERTICAL;
         gridSettings.useNavArrows = false;
         gridSettings.buildGridItemRenderMethod = MarketFactory.BUILD_SDPLUS_WEAPON_CARD;
         this.myScrollGrid.initGrid(gridSettings,MASK_SIZE_Y,true,2);
         this.initFilterList();
      }
      
      private function initFilterList() : void
      {
         var listSettings:ScrollListSettings = new ScrollListSettings();
         listSettings.orientation = ScrollListSettings.SCROLL_VERTICAL;
         listSettings.useNavArrows = false;
         listSettings.itemLinkage = "codo.shared.loadout.sDPlusFilterItem";
         listSettings.autoSize = false;
         listSettings.itemPadding = 3;
         listSettings.useMask = false;
         this.myFilterList.settings = listSettings;
         this.myFilterList.width = 170;
         this.myFilterList.height = 555;
         this.myFilterList.listItemClickCallback = this.onFilterItemClicked;
      }
      
      public function comparePrimaryWeapon(compare:Boolean) : void
      {
         this.mComparePrimaryWeapon = compare;
      }
      
      public function setData(group:String, selectSubGroup:String = null) : void
      {
         var subGroups:Vector.<Object> = null;
         var filterIdx:uint = 0;
         var subGroup:SDPSubGroupObj = null;
         var i:uint = 0;
         if(this.mGroup != group)
         {
            this.mGroup = group;
            this.myScrollGrid.resetList();
         }
         var items:Vector.<Object> = new Vector.<Object>();
         subGroups = SDPlusPvpUtil.instance.getSubGroups(group);
         var numSubGroups:uint = subGroups.length;
         if(numSubGroups > 0)
         {
            filterIdx = this.myFilterList.selectedIndex;
            if(selectSubGroup != null)
            {
               filterIdx = 0;
               if(selectSubGroup.length > 0)
               {
                  for(i = 0; i < numSubGroups; i++)
                  {
                     subGroup = subGroups[i] as SDPSubGroupObj;
                     if(selectSubGroup == subGroup.name)
                     {
                        filterIdx = i;
                        break;
                     }
                  }
               }
            }
            subGroup = subGroups[filterIdx] as SDPSubGroupObj;
            items = SDPlusPvpUtil.instance.getItems(subGroup.name,true);
            this.myFilterList.addItemsByVector(subGroups);
            this.myFilterList.selectedIndex = filterIdx;
            this.myFilterList.visible = true;
            this.myFilterBackground.visible = true;
            this.myBackground.x = this.myFilterBackground.x + 190;
            this.myScrollGrid.x = this.myBackground.x + 10;
         }
         else
         {
            items = SDPlusPvpUtil.instance.getItems(group,false);
            this.myFilterList.visible = false;
            this.myFilterBackground.visible = false;
            this.myScrollGrid.x = 10;
            this.myBackground.x = 0;
         }
         this.myScrollGrid.addItemsByVector(items);
      }
      
      private function onListItemFocused(item:Object) : void
      {
         var sdpItem:SDPItemObj = null;
         var prodData:ProductObj = null;
         if(null != item)
         {
            sdpItem = item as SDPItemObj;
            if(sdpItem.group == ItemType.KIS)
            {
               return;
            }
            prodData = sdpItem.group != SDPlusPvpUtil.GROUP_BOMBKITS ? CFunctionCommonContainer.GetItemInfo(sdpItem.id) : SDPlusPvpUtil.instance.getItemDataByIndex(sdpItem.index);
            this.myItemPreviewBox.setItemData(prodData);
            this.myItemPreviewBox.showBox();
         }
      }
      
      private function onListItemUnfocused(item:Object) : void
      {
         this.myItemPreviewBox.hideBox();
      }
      
      private function onFilterItemClicked(filter:SDPlusFilterItem) : void
      {
         var subGroup:SDPSubGroupObj = filter.getData() as SDPSubGroupObj;
         var items:Vector.<Object> = SDPlusPvpUtil.instance.getItems(subGroup.name,true);
         this.myScrollGrid.addItemsByVector(items);
      }
   }
}

