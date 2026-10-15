package codo.component
{
   import codo.constants.BCEvent;
   import codo.constants.MarketMenuData;
   import codo.manager.EventManager;
   import codo.objects.ProductObj;
   import codo.utils.MarketItemUtil;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.text.TextField;
   import fsg.util.FsgImageHolder;
   import fsg.util.ImageHolderSimple;
   
   public class MarketplaceItemIcon extends MovieClip
   {
      
      public var myAltText:flash.text.TextField;
      
      public var myAltTextShadow:flash.text.TextField;
      
      public var myIconHolder:ImageHolderSimple;
      
      public var myImageHolder:FsgImageHolder;
      
      public var myAnimatedEmblemMount:MovieClip;
      
      public var myAnimatedBackgroundMount:MovieClip;
      
      public function MarketplaceItemIcon()
      {
         super();
      }
      
      public function setData(productObj:ProductObj) : void
      {
         var ANIMATED_FRAME_WIDTH:int = 0;
         var ANIMATED_FRAME_HEIGHT:int = 0;
         var size:Point = null;
         var animatedBackgroundLoadData:Object = null;
         var animatedIconLoadData:Object = null;
         this.myImageHolder.visible = false;
         this.myAltText.visible = false;
         this.myIconHolder.visible = false;
         this.myAltTextShadow.visible = false;
         this.myAnimatedBackgroundMount.visible = false;
         this.myAnimatedEmblemMount.visible = false;
         if(productObj == null)
         {
            return;
         }
         var useIconHolderForImage:Boolean = productObj.useIconHolderForImage();
         var isAnimatedBackground:Boolean = productObj.isAnimatedBackground();
         var isAnimatedEmblem:Boolean = productObj.isAnimatedEmblem();
         var isAnimatedFrame:Boolean = productObj.isAnimatedFrame();
         if(productObj.type == MarketMenuData.TYPE_CALLSIGN_TITLE)
         {
            this.myAltText.text = productObj.name;
            this.myAltTextShadow.text = productObj.name;
            this.myImageHolder.visible = false;
            this.myAltTextShadow.y = this.myAltText.y = this.myImageHolder.y + this.myImageHolder.height * 0.5 - this.myAltText.textHeight * 0.5;
            this.myAltText.visible = true;
            this.myAltTextShadow.visible = this.myAltText.visible;
         }
         else if(useIconHolderForImage)
         {
            this.myIconHolder.visible = true;
            this.myIconHolder.addEventListener(Event.COMPLETE,this.onIconImageLoaded);
            this.myIconHolder.setImage(productObj.imageURL);
         }
         else if(isAnimatedBackground || isAnimatedFrame)
         {
            ANIMATED_FRAME_WIDTH = 382;
            ANIMATED_FRAME_HEIGHT = 29;
            if(isAnimatedFrame)
            {
               size = new Point(ANIMATED_FRAME_WIDTH,ANIMATED_FRAME_HEIGHT);
            }
            animatedBackgroundLoadData = {
               "name":productObj.imageURL,
               "holder":this.myAnimatedBackgroundMount,
               "size":size
            };
            EventManager.getInstance().broadcast(BCEvent.EVT_LOAD_ANIMATED_PRODUCT,animatedBackgroundLoadData);
            this.myAnimatedBackgroundMount.visible = true;
         }
         else if(isAnimatedEmblem)
         {
            animatedIconLoadData = {
               "name":productObj.imageURL,
               "holder":this.myAnimatedEmblemMount
            };
            EventManager.getInstance().broadcast(BCEvent.EVT_LOAD_ANIMATED_PRODUCT,animatedIconLoadData);
            this.myAnimatedEmblemMount.visible = true;
         }
         else
         {
            this.myImageHolder.visible = true;
            this.myImageHolder.setImage(productObj.imageURL);
         }
      }
      
      protected function onIconImageLoaded(e:Event) : void
      {
         this.myIconHolder.removeEventListener(Event.COMPLETE,this.onIconImageLoaded);
         var bmpImage:DisplayObject = this.myIconHolder.loadedAsset;
         var MAX_HEIGHT:uint = 115;
         if(currentFrame == MarketItemUtil.ITEM_CARD_LARGE_FRAME)
         {
            bmpImage.scaleX = bmpImage.scaleY = 1.3;
         }
         else
         {
            bmpImage.height = Math.min(MAX_HEIGHT,bmpImage.height);
            bmpImage.scaleX = bmpImage.scaleY;
         }
         bmpImage.x = (this.myImageHolder.width - bmpImage.width) * 0.5;
         bmpImage.y = (this.myImageHolder.height - bmpImage.height) * 0.5;
      }
   }
}

