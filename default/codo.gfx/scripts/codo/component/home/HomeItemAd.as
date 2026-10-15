package codo.component.home
{
   import codo.component.CallToActionButton;
   import codo.component.TextField;
   import codo.component.core.UIInteractiveComponent;
   import codo.constants.BCEvent;
   import codo.localization.DictMarket;
   import codo.manager.EventManager;
   import codo.objects.ProductObj;
   import codo.style.GlobalGuide;
   import codo.style.MarketGuide;
   import flash.display.MovieClip;
   import flash.filters.DropShadowFilter;
   import flash.utils.getDefinitionByName;
   import fsg.util.FsgImageHolder;
   
   public class HomeItemAd extends UIInteractiveComponent
   {
      
      private static const AD_WIDTH:Number = 740;
      
      public var myAnimatedEmblemMount:MovieClip;
      
      public var myBuyButton:CallToActionButton;
      
      public var myImage:FsgImageHolder;
      
      public var myBackground:MovieClip;
      
      public var myItemName:TextField;
      
      public var myItemDescription:TextField;
      
      public function HomeItemAd()
      {
         super();
         this.myItemName.font = GlobalGuide.FONT_FACE_BOLD;
         this.myItemName.fontSize = GlobalGuide.FONT_SIZE_GIGANTIC;
         this.myItemName.width = AD_WIDTH - this.myItemDescription.x;
         this.myItemName.height = 75;
         this.myItemDescription.fontSize = GlobalGuide.FONT_SIZE_MEDIUM_SMALL;
         this.myItemDescription.width = this.myItemName.width;
         this.myBuyButton.registerClickEvent(this.onBuyClicked);
         this.myBuyButton.width = 148;
         this.myBuyButton.height = 36;
      }
      
      override public function setData(data:*) : void
      {
         var isAnimatedEmblem:Boolean;
         var tierColor:uint;
         var dropShadow:DropShadowFilter;
         var itemData:ProductObj = null;
         var emblem:Class = null;
         var emblemClip:MovieClip = null;
         var multiplier:Number = NaN;
         super.setData(data);
         itemData = data as ProductObj;
         isAnimatedEmblem = itemData.isAnimatedEmblem();
         this.myItemName.text = itemData.name;
         this.myItemDescription.text = itemData.description;
         tierColor = uint(MarketGuide.COLOR_BY_TIER[itemData.tier]);
         dropShadow = new DropShadowFilter(5,113,tierColor,0.75,25,25);
         this.myItemName.filters = [dropShadow];
         this.myItemDescription.filters = [dropShadow];
         this.myBackground.gotoAndStop(itemData.tier + 1);
         while(this.myAnimatedEmblemMount.numChildren > 0)
         {
            this.myAnimatedEmblemMount.removeChildAt(0);
         }
         if(!isAnimatedEmblem)
         {
            this.myImage.setImage(itemData.imageURL);
            this.myImage.filters = [dropShadow];
         }
         else
         {
            try
            {
               emblem = getDefinitionByName(itemData.imageURL.toUpperCase()) as Class;
            }
            catch(e:ReferenceError)
            {
               trace(e);
            }
            if(emblem != null)
            {
               emblemClip = new emblem();
               multiplier = this.myImage.width / emblemClip.width;
               emblemClip.scaleX *= multiplier;
               emblemClip.scaleY *= multiplier;
               this.myAnimatedEmblemMount.addChild(emblemClip);
               if(Boolean(emblemClip.mySize))
               {
                  this.myAnimatedEmblemMount.x = this.myBackground.x + (this.myImage.width / 2.5 - emblemClip.mySize.width / 2);
                  this.myAnimatedEmblemMount.y = this.myBackground.y + (this.myImage.height / 2.5 - emblemClip.mySize.height / 2);
               }
            }
         }
         this.myBuyButton.label = itemData.isOwnedRental() ? DictMarket.EXTEND : DictMarket.BUY;
      }
      
      override public function get width() : Number
      {
         return AD_WIDTH;
      }
      
      private function onBuyClicked() : void
      {
         EventManager.getInstance().broadcast(BCEvent.EVT_MARKET_PURCHASE_POPUP,{"itemData":new ProductObj(mData)});
      }
   }
}

