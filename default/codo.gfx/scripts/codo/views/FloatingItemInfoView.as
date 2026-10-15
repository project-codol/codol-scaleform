package codo.views
{
   import codo.base.BaseView;
   import codo.common.CFunctionContainer;
   import codo.component.ItemPreviewBox;
   import codo.constants.BCEvent;
   import codo.constants.MarketMenuData;
   import codo.event.ParaEvent;
   import codo.objects.ProductObj;
   import codo.services.WeaponLoadoutService;
   
   public class FloatingItemInfoView extends BaseView
   {
      
      private static const SLOT_PRIMARY:int = 0;
      
      private static const SLOT_SECONDARY:int = 1;
      
      private static const SLOT_SWORD:int = 2;
      
      public var myItemPreview:ItemPreviewBox;
      
      public function FloatingItemInfoView()
      {
         super();
      }
      
      override protected function enableData() : void
      {
         super.enableData();
         listen(BCEvent.EVT_SHOW_ITEM_INFO_PREVIEW,this.onShowItemInfoPreview);
         listen(BCEvent.EVT_HIDE_ITEM_INFO_PREVIEW,this.onHideItemInfoPreview);
      }
      
      override protected function disableData() : void
      {
         super.disableData();
         unlisten(BCEvent.EVT_SHOW_ITEM_INFO_PREVIEW,this.onShowItemInfoPreview);
         unlisten(BCEvent.EVT_HIDE_ITEM_INFO_PREVIEW,this.onHideItemInfoPreview);
      }
      
      private function onShowItemInfoPreview(e:ParaEvent) : void
      {
         var compare:ProductObj = null;
         var product:ProductObj = e.myPara.product as ProductObj;
         var hasCompare:Boolean = e.myPara.compare as Boolean;
         if(product == null)
         {
            return;
         }
         mouseEnabled = mouseChildren = false;
         if(hasCompare)
         {
            compare = this.tryGetComparision(product);
         }
         this.myItemPreview.setItemData(product,compare);
         this.myItemPreview.showBox();
      }
      
      private function onHideItemInfoPreview(e:ParaEvent) : void
      {
         this.myItemPreview.hideBox(false);
      }
      
      private function tryGetComparision(product:ProductObj) : ProductObj
      {
         var slot:String = null;
         if(product == null || product.type != MarketMenuData.TYPE_WEAPON)
         {
            return null;
         }
         var weaponType:int = CFunctionContainer.WL_GetWeaponType(product.id);
         switch(weaponType)
         {
            case SLOT_PRIMARY:
               slot = "primary";
               break;
            case SLOT_SECONDARY:
               slot = "secondary";
               break;
            case SLOT_SWORD:
               slot = "sword";
         }
         return WeaponLoadoutService.getInstance().getPreviewCompareItem(product,slot);
      }
   }
}

