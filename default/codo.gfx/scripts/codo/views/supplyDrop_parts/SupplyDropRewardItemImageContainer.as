package codo.views.supplyDrop_parts
{
   import codo.component.core.UIInteractiveComponent;
   import codo.constants.MarketMenuData;
   import codo.objects.ProductObj;
   import codo.utils.ItemUtil;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.text.TextField;
   import fsg.util.FsgImageHolder;
   
   public class SupplyDropRewardItemImageContainer extends UIInteractiveComponent
   {
      
      public var myTitle:TextField;
      
      public var myImageIcon:FsgImageHolder;
      
      public var myPlayerTitleBG:Sprite;
      
      private var mItemScale:Number;
      
      private var mNewImageLoadedCallback:Function;
      
      public function SupplyDropRewardItemImageContainer()
      {
         super();
         this.mItemScale = 1;
      }
      
      public function registerNewImageLoadedCallback(callback:Function) : void
      {
         this.mNewImageLoadedCallback = callback;
      }
      
      public function get itemScale() : Number
      {
         return this.mItemScale;
      }
      
      public function resetData() : void
      {
         this.myTitle.visible = false;
         this.myTitle.visible = false;
         this.myImageIcon.visible = false;
      }
      
      override public function setData(data:*) : void
      {
         super.setData(data);
         var prod:ProductObj = data as ProductObj;
         if(prod.type == MarketMenuData.TYPE_CALLSIGN_TITLE)
         {
            this.myTitle.text = prod.name;
            this.myTitle.visible = true;
            this.myImageIcon.visible = false;
            this.onNewImageLoaded(null);
         }
         else
         {
            this.myImageIcon.addEventListener(Event.COMPLETE,this.onNewImageLoaded);
            ItemUtil.setItemImage(this.myImageIcon,prod);
            this.myImageIcon.visible = true;
            this.myTitle.visible = false;
         }
      }
      
      private function onNewImageLoaded(e:Event) : void
      {
         var prod:ProductObj = getData() as ProductObj;
         if(prod.type != MarketMenuData.TYPE_CALLSIGN_TITLE)
         {
            this.myImageIcon.removeEventListener(Event.COMPLETE,this.onNewImageLoaded);
         }
         this.positionImage();
         if(this.mNewImageLoadedCallback != null)
         {
            this.mNewImageLoadedCallback();
         }
      }
      
      public function positionImage() : void
      {
         this.myPlayerTitleBG.visible = false;
         this.mItemScale = 1;
         x = 0;
         y = 0;
         this.myImageIcon.x = 0;
         this.myImageIcon.y = 0;
         var prod:ProductObj = getData() as ProductObj;
         switch(prod.type)
         {
            case MarketMenuData.TYPE_CALLSIGN_BKG:
               if(!prod.isAnimatedBackground())
               {
                  this.mItemScale = 0.7;
                  x = 100;
                  y = 100;
               }
               else
               {
                  this.mItemScale = 0.8;
                  x = 115;
                  y = 15;
               }
               break;
            case MarketMenuData.TYPE_CALLSIGN_TITLE:
               this.myPlayerTitleBG.visible = true;
               break;
            case MarketMenuData.TYPE_CHARACTER:
               this.mItemScale = 0.8;
               x = 110;
               y = 10;
               break;
            case MarketMenuData.TYPE_WEAPON:
               x = 40;
               y = -10;
               break;
            default:
               x = 260 - this.myImageIcon.loadedAsset.width / 2 - this.myImageIcon.loadedAsset.x;
               y = 130 - this.myImageIcon.loadedAsset.height / 2 - this.myImageIcon.loadedAsset.y;
         }
      }
   }
}

