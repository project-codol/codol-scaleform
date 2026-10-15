package codo.views.marketplace_parts
{
   import codo.component.Button;
   import codo.constants.BCEvent;
   import codo.localization.DictMarket;
   import codo.manager.EventManager;
   import codo.objects.ProductObj;
   import codo.utils.LocalizeUtil;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import scaleform.gfx.TextFieldEx;
   
   public class MarketplaceFeaturedAdTemplate extends Sprite
   {
      
      public var myTitleTF:TextField;
      
      public var myDescriptionTF:TextField;
      
      public var myBuyBtn:Button;
      
      private var mItemData:ProductObj;
      
      private var mAddCallback:Function;
      
      public function MarketplaceFeaturedAdTemplate()
      {
         super();
         TextFieldEx.setVerticalAlign(this.myTitleTF,TextFieldEx.VALIGN_CENTER);
         this.myTitleTF.autoSize = TextFieldAutoSize.LEFT;
         this.myDescriptionTF.width = this.myTitleTF.width = 370;
         this.myBuyBtn.stopClickEventPropagation = true;
         this.myBuyBtn.label = DictMarket.BUY;
         this.myBuyBtn.width = 140;
         this.myBuyBtn.height = 36;
      }
      
      public function setFeatureAdData(data:*, clickCallback:Function) : void
      {
         var LOCALIZE:Function = null;
         this.mAddCallback = clickCallback;
         if(data is ProductObj)
         {
            this.mItemData = data;
            LOCALIZE = LocalizeUtil.localize;
            this.myTitleTF.text = LOCALIZE(data.name).toUpperCase();
            this.myDescriptionTF.text = LOCALIZE(data.description);
            this.myBuyBtn.setClickCallback(this.onBuyButtonClick);
         }
      }
      
      private function onBuyButtonClick() : void
      {
         EventManager.getInstance().broadcast(BCEvent.EVT_MARKET_PURCHASE_POPUP,{"itemData":this.mItemData});
      }
   }
}

