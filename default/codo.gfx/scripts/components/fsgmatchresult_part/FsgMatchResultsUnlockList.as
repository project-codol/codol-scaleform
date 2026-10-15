package components.fsgmatchresult_part
{
   import codo.component.factory.MarketFactory;
   import codo.component.marketplaceitem.MarketplaceItem;
   import codo.constants.GameInfo;
   import codo.event.ParaEvent;
   import com.greensock.TweenLite;
   import components.fsgimgswitcher_part.ImgSwitcher;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.utils.getDefinitionByName;
   import flash.utils.setTimeout;
   
   public class FsgMatchResultsUnlockList extends FsgMatchResultsListBase
   {
      
      private static const ITEM_WIDTH:Number = 231;
      
      private static const ITEM_ANIM_DELAY:Number = 0.1;
      
      private static const MOUNT_START_X:Number = 179;
      
      private static const ITEM_SLIDE_DURATION:Number = 0.17;
      
      private static const ITEM_SLIDE_DISTANCE:Number = 200;
      
      private static const BG_FADE_DURATION:Number = 1000;
      
      private static const END_FRAME:String = "end";
      
      public var myItemMount:MovieClip;
      
      public var myMask:MovieClip;
      
      public var myPagination:ImgSwitcher;
      
      private var mVecItems:Vector.<DisplayObject>;
      
      private var mPageIndices:Array;
      
      private var mCurrentPageIndex:int;
      
      public function FsgMatchResultsUnlockList()
      {
         super();
         this.mCurrentPageIndex = 0;
         this.mVecItems = new Vector.<DisplayObject>();
      }
      
      public function setData(data:Object) : void
      {
         var numPages:int = 0;
         var clip:MovieClip = null;
         var itemData:Object = null;
         numPages = 1;
         var pageWidth:Number = 0;
         this.mPageIndices = new Array();
         var numItems:int = int(data.unlockAttachment.length);
         for(var i:int = 0; i < numItems; i++)
         {
            itemData = data.unlockAttachment[i];
            if(itemData.gp == true)
            {
               clip = this.getUnlockedItemClip();
            }
            else
            {
               clip = MarketFactory.BUILD_MARKET_ITEM_SMALL_CARD();
               (clip as MarketplaceItem).withDiscountTag = false;
               clip.isInteractiveEnabled = false;
            }
            clip.setData(itemData);
            this.myItemMount.addChild(clip);
            this.mVecItems.push(clip);
            clip.x = i * ITEM_WIDTH;
            clip.alpha = 0;
            pageWidth += ITEM_WIDTH;
            if(i == 0)
            {
               this.mPageIndices.push(i);
            }
            if(pageWidth > this.myMask.width)
            {
               this.mPageIndices.push(i);
               pageWidth = 0;
               numPages++;
            }
         }
         if(numPages > 1)
         {
            this.myPagination.visible = true;
            this.myPagination.addEventListener(ImgSwitcher.EVT_CHANGED,this.onPaginationChange);
            this.myPagination.imgCount = numPages;
            this.myPagination.selectedIndex = this.mCurrentPageIndex;
            this.myPagination.x = GameInfo.gameWidth * 0.5 - this.myPagination.width * 0.5;
            this.myPagination.autoPageFlipEnable = false;
         }
         else
         {
            this.myPagination.visible = false;
         }
      }
      
      public function clearData() : void
      {
         for(var i:int = 0; i < this.mVecItems.length; i++)
         {
            this.myItemMount.removeChild(this.mVecItems[i]);
         }
         this.mVecItems = new Vector.<DisplayObject>();
      }
      
      override public function startAnimation() : void
      {
         super.startAnimation();
         this.gotoAndPlay(2);
         setTimeout(this.startItemAnimation,BG_FADE_DURATION);
      }
      
      private function startItemAnimation() : void
      {
         var clip:DisplayObject = null;
         for(var i:int = 0; i < this.mVecItems.length; i++)
         {
            clip = this.mVecItems[i];
            clip.alpha = 1;
            TweenLite.from(clip,ITEM_SLIDE_DURATION,{
               "alpha":0,
               "x":clip.x + ITEM_SLIDE_DISTANCE,
               "delay":ITEM_ANIM_DELAY * i
            });
         }
         TweenLite.to(this.myPagination,0.1,{"alpha":1});
         setTimeout(this.startAutoPageAnimation,ITEM_SLIDE_DURATION * this.mVecItems.length);
      }
      
      override public function skipAnimation() : void
      {
         gotoAndStop(END_FRAME);
         for(var i:int = 0; i < this.mVecItems.length; i++)
         {
            this.mVecItems[i].alpha = 1;
         }
         if(this.mPageIndices != null && this.mPageIndices.length > 1)
         {
            this.myPagination.alpha = 1;
            this.myPagination.autoPageFlipEnable = true;
         }
      }
      
      private function startAutoPageAnimation() : void
      {
         this.myPagination.autoPageFlipEnable = true;
         if(null != mOnCompleteCallback)
         {
            mOnCompleteCallback();
         }
      }
      
      private function onPaginationChange(cEvt:ParaEvent) : void
      {
         this.mCurrentPageIndex = cEvt.myPara.index;
         TweenLite.to(this.myItemMount,0.3,{"x":MOUNT_START_X + -this.mPageIndices[this.mCurrentPageIndex] * ITEM_WIDTH});
      }
      
      private function getUnlockedItemClip() : FsgMatchResultsUnlockListItem
      {
         var itemClass:Class = getDefinitionByName("fsg.matchresults.fsgMatchResultsUnlockListItem") as Class;
         return new itemClass() as FsgMatchResultsUnlockListItem;
      }
   }
}

