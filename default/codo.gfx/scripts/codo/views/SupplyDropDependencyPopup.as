package codo.views
{
   import codo.base.PopupView;
   import codo.component.TextField;
   import codo.component.factory.MarketFactory;
   import codo.component.marketplaceitem.MarketplaceItem;
   import codo.constants.BCEvent;
   import codo.localization.DictSystem;
   import codo.objects.ProductObj;
   import codo.style.GlobalGuide;
   import codo.utils.LocalizeUtil;
   import codo.utils.ScaleformUtil;
   import flash.display.MovieClip;
   
   public class SupplyDropDependencyPopup extends PopupView
   {
      
      private static const POPUP_HEIGHT:Number = 400;
      
      private static const PADDING:uint = 20;
      
      private static const ITEM_PADDING:uint = 27;
      
      public var myItemHolder:MovieClip;
      
      public var myArrow:MovieClip;
      
      public var myDescription:TextField;
      
      private var myRewardItem:MarketplaceItem;
      
      private var myDependency:MarketplaceItem;
      
      public function SupplyDropDependencyPopup()
      {
         super();
         this.myRewardItem = MarketFactory.BUILD_MARKET_ITEM_MEDIUM_CARD() as MarketplaceItem;
         this.myRewardItem.withDiscountTag = false;
         this.myRewardItem.isInteractiveEnabled = true;
         this.myRewardItem.withCallToArms = false;
         this.myItemHolder.addChild(this.myRewardItem);
         this.myDependency = MarketFactory.BUILD_MARKET_ITEM_MEDIUM_CARD() as MarketplaceItem;
         this.myDependency.withDiscountTag = false;
         this.myDependency.isInteractiveEnabled = true;
         this.myDependency.withCallToArms = false;
         this.myItemHolder.addChild(this.myDependency);
         this.myDependency.x = this.myArrow.x + this.myArrow.width + ITEM_PADDING;
         this.myDescription.textStyle = GlobalGuide.styleTextDescription;
         var offset:uint = myPopup.popupWidth - this.myDescription.x;
         this.myDescription.width = offset - PADDING;
         myPopup.configConfirmButton(DictSystem.CONFIRM,this.onConfirm,true);
         myPopup.configCancelButton(DictSystem.CANCEL,this.onCancel);
         myPopup.height = POPUP_HEIGHT;
      }
      
      override public function set routeData(data:*) : void
      {
         var rewardItem:ProductObj = data.rewardItem as ProductObj;
         var dependency:ProductObj = data.dependency as ProductObj;
         this.myRewardItem.setData(rewardItem);
         this.myDependency.setData(dependency);
         var itemName:String = LocalizeUtil.localize(dependency.name);
         myPopup.header.setErrorMode(LocalizeUtil.replaceConversionString(LocalizeUtil.localize("@UI_MARKET_SUPPLY_DROP_DEPENDENCY_TITLE"),[itemName]));
         var desc:String = LocalizeUtil.replaceConversionString(LocalizeUtil.localize("@UI_MARKET_SUPPLY_DROP_DEPENDENCY_DESC"),[itemName]);
         if(ScaleformUtil.IsLogItemIDEnabled())
         {
            desc = rewardItem.id.toString() + ": " + desc;
         }
         this.myDescription.text = desc;
      }
      
      private function onConfirm() : void
      {
         closePopupView();
         broadcast(BCEvent.EVT_MARKET_PURCHASE_POPUP,{"itemData":new ProductObj(this.myDependency.getData())});
      }
      
      private function onCancel() : void
      {
         closePopupView();
      }
   }
}

