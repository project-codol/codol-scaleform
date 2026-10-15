package codo.component.loadout
{
   import codo.common.CFunctionCommonContainer;
   import codo.component.ScrollGrid;
   import codo.component.TextField;
   import codo.component.ViewPanelBase;
   import codo.component.core.UIInteractiveComponent;
   import codo.constants.BCEvent;
   import codo.manager.EventManager;
   import codo.objects.ProductObj;
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   
   public class LoadoutViewPanelBase extends ViewPanelBase
   {
      
      public var myInstructions:TextField;
      
      public var myLoadoutName:TextField;
      
      public var myHeaderTitle:TextField;
      
      public function LoadoutViewPanelBase()
      {
         super();
         if(null != this.myLoadoutName)
         {
            this.myLoadoutName.alignment = TextStyle.HALIGN_LEFT;
            this.myLoadoutName.fontSize = GlobalGuide.FONT_SIZE_SMALL;
            this.myLoadoutName.fontColor = GlobalGuide.WHITE;
            this.myLoadoutName.font = GlobalGuide.FONT_FACE_BOLD;
         }
         if(null != this.myInstructions)
         {
            this.myInstructions.alignment = TextStyle.HALIGN_LEFT;
            this.myInstructions.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
            this.myInstructions.fontColor = GlobalGuide.CODO_INSTRUCTION_GREY;
            this.myInstructions.font = GlobalGuide.FONT_FACE_MEDIUM;
         }
         if(null != this.myHeaderTitle)
         {
            this.myHeaderTitle.alignment = TextStyle.HALIGN_LEFT;
            this.myHeaderTitle.fontSize = GlobalGuide.FONT_SIZE_SMALL;
            this.myHeaderTitle.fontColor = GlobalGuide.WHITE;
            this.myHeaderTitle.font = GlobalGuide.FONT_FACE_BOLD;
         }
      }
      
      override protected function disableData() : void
      {
         super.disableData();
         EventManager.getInstance().broadcast(BCEvent.EVT_HIDE_ITEM_INFO_PREVIEW);
      }
      
      protected function onLoadoutSlotFocused(item:UIInteractiveComponent) : void
      {
         var slotItemID:int = Boolean(item.getData().item_id) ? int(item.getData().item_id) : int(item.getData().id);
         var data:ProductObj = slotItemID > 0 ? CFunctionCommonContainer.GetItemInfo(slotItemID) : null;
         if(Boolean(data))
         {
            EventManager.getInstance().broadcast(BCEvent.EVT_SHOW_ITEM_INFO_PREVIEW,{
               "product":data,
               "compare":true
            });
         }
      }
      
      protected function onLoadoutSlotUnfocused() : void
      {
         EventManager.getInstance().broadcast(BCEvent.EVT_HIDE_ITEM_INFO_PREVIEW);
      }
      
      protected function repopulateList(grid:ScrollGrid) : void
      {
         var item:ProductObj = null;
         var listData:Vector.<Object> = grid.listData;
         var newData:Vector.<Object> = new Vector.<Object>();
         for(var j:int = 0; j < listData.length; j++)
         {
            item = CFunctionCommonContainer.GetItemInfo(listData[j].id);
            newData.push(item);
         }
         grid.addItemsByVector(newData);
      }
   }
}

