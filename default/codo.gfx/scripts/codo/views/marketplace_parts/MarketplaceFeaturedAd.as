package codo.views.marketplace_parts
{
   import codo.constants.ItemType;
   import codo.event.ImageLoaderEvent;
   import codo.event.ParaEvent;
   import codo.objects.ProductObj;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import fsg.shared.BehaviourClickable;
   import fsg.util.FsgImageHolder;
   
   public class MarketplaceFeaturedAd extends FsgImageHolder
   {
      
      public var myLoading:MovieClip;
      
      public var myImageContainer:Sprite;
      
      public var myAdTemplate:MarketplaceFeaturedAdTemplate;
      
      public var myRarityBkg:MovieClip;
      
      private var mClickable:BehaviourClickable;
      
      private var mClickCallback:Function;
      
      private var mData:*;
      
      private var mPromoType:int = -1;
      
      private var mIsTencentWebAd:Boolean = false;
      
      public function MarketplaceFeaturedAd()
      {
         super();
         this.mClickable = new BehaviourClickable(this);
         this.mClickable.setEnabled(false);
         this.myImageContainer.visible = this.myRarityBkg.visible = this.myAdTemplate.visible = false;
      }
      
      override protected function onImageLoaded(e:ImageLoaderEvent) : void
      {
         var m_scale:Number = NaN;
         var bmpImage:DisplayObject = e.m_displayObject;
         bmpImage.width = 786;
         bmpImage.height = 350;
         if(m_keepRatio == true)
         {
            m_scale = m_aspectMax == false ? Math.min(bmpImage.scaleX,bmpImage.scaleY) : Math.max(bmpImage.scaleX,bmpImage.scaleY);
            bmpImage.scaleY = bmpImage.scaleX = m_scale;
            bmpImage.x = 0;
            bmpImage.y = (m_imageHeight - bmpImage.height) * 0.5;
         }
         else
         {
            bmpImage.x = bmpImage.y = 0;
         }
         if(this.myImageContainer.visible)
         {
            bmpImage.width = this.myImageContainer.width;
            bmpImage.height = this.myImageContainer.height;
            this.myImageContainer.addChild(bmpImage);
         }
         else
         {
            addChild(bmpImage);
         }
         this.myLoading.stop();
         this.myLoading.visible = false;
         if(this.mClickCallback != null)
         {
            this.mClickable.setEnabled(true);
         }
         dispatchEvent(new ParaEvent(Event.COMPLETE,{"status":e.m_status}));
      }
      
      public function buildAdDisplay(callback:Function, data:*) : void
      {
         var prodData:ProductObj = null;
         this.mClickCallback = callback;
         this.mData = data;
         if(data is ProductObj)
         {
            prodData = data as ProductObj;
            this.itemTier = prodData.tier;
         }
         this.mClickable.addClickCallback(this.mClickCallback,data);
         this.myAdTemplate.setFeatureAdData(data,this.mClickCallback);
         if(this.myAdTemplate.visible)
         {
            if(this.mData.type != ItemType.WEAPON)
            {
               this.myImageContainer.y = this.height - this.myImageContainer.height;
            }
         }
      }
      
      public function set useItemImageHolder(value:Boolean) : void
      {
         this.myImageContainer.visible = value;
      }
      
      public function get featuredAdDataID() : int
      {
         return this.mData.id;
      }
      
      public function set promoType(templateID:int) : void
      {
         this.mPromoType = templateID;
      }
      
      public function get promoType() : int
      {
         return this.mPromoType;
      }
      
      private function set itemTier(tier:int) : void
      {
         var tierFrame:uint = 0;
         tierFrame = tier + 1;
         this.myRarityBkg.visible = true;
         this.myRarityBkg.gotoAndStop(tierFrame);
      }
      
      public function set isTencentWebAd(isTCAd:Boolean) : void
      {
         this.mIsTencentWebAd = isTCAd;
         this.myAdTemplate.visible = !isTCAd;
      }
      
      public function get isTencentWebAd() : Boolean
      {
         return this.mIsTencentWebAd;
      }
   }
}

