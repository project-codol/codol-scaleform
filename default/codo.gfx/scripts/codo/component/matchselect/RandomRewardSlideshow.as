package codo.component.matchselect
{
   import codo.component.MarketplaceItemIcon;
   import codo.component.PaginationTabList;
   import codo.component.TextField;
   import codo.component.core.UIInteractiveComponent;
   import codo.event.ParaEvent;
   import codo.objects.ProductObj;
   import codo.style.GlobalGuide;
   import codo.style.MarketGuide;
   import codo.utils.LocalizeUtil;
   import com.greensock.TweenLite;
   import com.greensock.easing.Linear;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class RandomRewardSlideshow extends UIInteractiveComponent
   {
      
      public var myPaginationList:PaginationTabList;
      
      public var myRandomRewardIcon:MarketplaceItemIcon;
      
      public var myItemTierBG:Sprite;
      
      public var myItemTierBGCap:Sprite;
      
      public var myBackground:Sprite;
      
      public var myItemName:TextField;
      
      private var mItems:Vector.<ProductObj>;
      
      public function RandomRewardSlideshow()
      {
         super();
         isInteractiveEnabled = true;
         this.myItemName.width = 370;
         this.myItemName.fontColor = GlobalGuide.CODO_BLACK;
         this.myPaginationList.scaleX = this.myPaginationList.scaleY = 0.85;
         this.myPaginationList.addEventListener(Event.CHANGE,this.onPageChanged);
         this.myPaginationList.visible = false;
         this.myRandomRewardIcon.setData(null);
         this.myRandomRewardIcon.alpha = 0;
         this.myItemTierBG.alpha = 0;
         this.myItemTierBGCap.alpha = 0;
         this.myItemName.alpha = 0;
      }
      
      override public function setData(data:*) : void
      {
         super.setData(data);
         this.mItems = data;
         if(this.mItems.length > 1)
         {
            this.myPaginationList.setNumPages(this.mItems.length);
            this.myPaginationList.x = this.myBackground.x + this.myBackground.width - this.myPaginationList.width - GlobalGuide.COMPONENT_PADDING;
            this.myPaginationList.y = this.myBackground.y + this.myBackground.height - this.myPaginationList.height - 6;
            this.myPaginationList.visible = true;
         }
         else
         {
            this.myPaginationList.visible = false;
            this.myPaginationList.stopTimer();
            this.updateContent(true);
         }
      }
      
      public function get currentItem() : ProductObj
      {
         return this.mItems[this.myPaginationList.currentPage];
      }
      
      private function updateContent(doAnim:Boolean) : void
      {
         if(doAnim)
         {
            TweenLite.to(this.myItemName,0.3,{
               "alpha":0,
               "ease":Linear.easeInOut
            });
            TweenLite.to(this.myItemTierBG,0.3,{
               "alpha":0,
               "ease":Linear.easeInOut
            });
            TweenLite.to(this.myItemTierBGCap,0.3,{
               "alpha":0,
               "ease":Linear.easeInOut
            });
            TweenLite.to(this.myRandomRewardIcon,0.3,{
               "alpha":0,
               "ease":Linear.easeInOut,
               "onComplete":this.onImageFadedOut
            });
         }
         else
         {
            this.refresh();
            TweenLite.killTweensOf(this.myItemName);
            TweenLite.killTweensOf(this.myItemTierBG);
            TweenLite.killTweensOf(this.myItemTierBGCap);
            TweenLite.killTweensOf(this.myRandomRewardIcon);
            this.myItemName.alpha = this.myItemTierBG.alpha = this.myItemTierBGCap.alpha = this.myRandomRewardIcon.alpha = 1;
         }
      }
      
      private function onImageFadedOut() : void
      {
         this.refresh();
         TweenLite.to(this.myRandomRewardIcon,0.3,{
            "alpha":1,
            "ease":Linear.easeInOut
         });
         TweenLite.to(this.myItemName,0.3,{
            "alpha":1,
            "ease":Linear.easeInOut
         });
         TweenLite.to(this.myItemTierBG,0.3,{
            "alpha":1,
            "ease":Linear.easeInOut
         });
         TweenLite.to(this.myItemTierBGCap,0.3,{
            "alpha":1,
            "ease":Linear.easeInOut
         });
      }
      
      private function refresh() : void
      {
         if(this.myPaginationList.currentPage >= this.mItems.length)
         {
            this.myPaginationList.updateCurrentPage(0);
         }
         var product:ProductObj = this.mItems[this.myPaginationList.currentPage];
         this.myRandomRewardIcon.setData(product);
         this.myItemName.text = LocalizeUtil.localize(product.name);
         GlobalGuide.formatComponentsByTier(MarketGuide.COLOR_BY_TIER[product.tier],new <DisplayObject>[this.myItemTierBG]);
         this.myItemTierBG.width = this.myItemName.textWidth + this.myItemTierBGCap.width + 15;
         this.myItemTierBGCap.x = this.myItemTierBG.x + this.myItemTierBG.width - this.myItemTierBGCap.width;
      }
      
      private function onPageChanged(e:ParaEvent) : void
      {
         var bListReset:Boolean = Boolean(e.myPara.bListReset);
         this.updateContent(!bListReset);
      }
   }
}

