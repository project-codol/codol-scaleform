package codo.views.wargod_parts
{
   import codo.constants.BCEvent;
   import codo.constants.MarketMenuData;
   import codo.manager.EventManager;
   import codo.objects.ProductObj;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import fsg.util.FsgImageHolder;
   
   public class SimpleItemImage extends MovieClip
   {
      
      public var myAltText:TextField;
      
      public var myAltTextShadow:TextField;
      
      public var myAnimatedEmblemMount:MovieClip;
      
      public var myAnimatedBackgroundMount:MovieClip;
      
      public var myItemImageHolder:FsgImageHolder;
      
      private var mProductData:ProductObj;
      
      public function SimpleItemImage()
      {
         super();
      }
      
      public function setData(productData:ProductObj) : void
      {
         var animatedBackgroundLoadData:Object = null;
         var animatedIconLoadData:Object = null;
         this.mProductData = productData;
         var isAnimatedBackground:Boolean = this.mProductData.isAnimatedBackground();
         var isAnimatedEmblem:Boolean = this.mProductData.isAnimatedEmblem();
         this.myItemImageHolder.visible = this.myAltText.visible = this.myAltTextShadow.visible = false;
         while(this.myAnimatedBackgroundMount.numChildren > 0)
         {
            this.myAnimatedBackgroundMount.removeChildAt(0);
         }
         while(this.myAnimatedEmblemMount.numChildren > 0)
         {
            this.myAnimatedEmblemMount.removeChildAt(0);
         }
         if(productData.type == MarketMenuData.TYPE_CALLSIGN_TITLE)
         {
            this.myAltText.text = productData.name;
            this.myAltTextShadow.text = productData.name;
            this.myItemImageHolder.visible = false;
            this.myAltText.visible = true;
            this.myAltTextShadow.visible = this.myAltText.visible;
         }
         else if(isAnimatedBackground)
         {
            animatedBackgroundLoadData = {
               "name":productData.imageURL,
               "holder":this.myAnimatedBackgroundMount
            };
            EventManager.getInstance().broadcast(BCEvent.EVT_LOAD_ANIMATED_PRODUCT,animatedBackgroundLoadData);
         }
         else if(isAnimatedEmblem)
         {
            animatedIconLoadData = {
               "name":productData.imageURL,
               "holder":this.myAnimatedEmblemMount
            };
            EventManager.getInstance().broadcast(BCEvent.EVT_LOAD_ANIMATED_PRODUCT,animatedIconLoadData);
         }
         else
         {
            this.myItemImageHolder.visible = true;
            this.myItemImageHolder.setImage(productData.imageURL);
         }
      }
   }
}

