package codo.views.wargodMatchResult_parts
{
   import codo.localization.DictWarGod;
   import codo.objects.UnlockItemObj;
   import codo.objects.WarGodMatchResultObj;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.utils.Timer;
   
   public class JuniorWarGodPromotionDetailPanel extends WarGodAnimateElement
   {
      
      public static const APPEAR_INTERVAL:int = 200;
      
      public static const DETAIL_ITEM_START_Y:int = 90;
      
      public static const DETAIL_ITEM_HEIGHT:int = 56;
      
      public static const DETAIL_ITEM_DEFAULT_GAP:int = 25;
      
      public var myLabel:TextField;
      
      public var myDetailItem0:PromotionDetailItem;
      
      public var myDetailItem1:PromotionDetailItem;
      
      public var myDetailItem2:PromotionDetailItem;
      
      public var myDetailItem3:PromotionDetailItem;
      
      private var mDetailItems:Array;
      
      private var mDetails:Array;
      
      private var mNumDetailItems:int = 0;
      
      private var mTimer:Timer;
      
      private var mAnimationCurrentIndex:int = 0;
      
      public function JuniorWarGodPromotionDetailPanel()
      {
         super();
         this.myLabel.text = DictWarGod.PROMOTION_SCORE_DETAIL_LABEL;
         this.mDetailItems = [this.myDetailItem0,this.myDetailItem1,this.myDetailItem2,this.myDetailItem3];
         this.mTimer = new Timer(APPEAR_INTERVAL);
      }
      
      public function setData(data:WarGodMatchResultObj, roundAwards:Vector.<UnlockItemObj>) : void
      {
         for(var i:int = 0; i < this.mDetailItems.length; i++)
         {
            this.mDetailItems[i].visible = false;
         }
         this.mDetails = data.matchResultFromDvar;
         if(this.mDetails[WarGodMatchResultObj.PROMOTION_SCORE_DETAIL_WINLOSE] != 0)
         {
            (this.mDetailItems[this.mNumDetailItems] as PromotionDetailItem).setData(true,WarGodMatchResultObj.PROMOTION_SCORE_DETAIL_WINLOSE,this.mDetails[WarGodMatchResultObj.PROMOTION_SCORE_DETAIL_WINLOSE]);
            ++this.mNumDetailItems;
         }
         if(this.mDetails[WarGodMatchResultObj.PROMOTION_SCORE_DETAIL_PERFORMANCE] != 0)
         {
            (this.mDetailItems[this.mNumDetailItems] as PromotionDetailItem).setData(true,WarGodMatchResultObj.PROMOTION_SCORE_DETAIL_PERFORMANCE,this.mDetails[WarGodMatchResultObj.PROMOTION_SCORE_DETAIL_PERFORMANCE]);
            ++this.mNumDetailItems;
         }
         if(this.mDetails[WarGodMatchResultObj.PROMOTION_SCORE_DETAIL_MEDAL] != 0)
         {
            (this.mDetailItems[this.mNumDetailItems] as PromotionDetailItem).setData(true,WarGodMatchResultObj.PROMOTION_SCORE_DETAIL_MEDAL,this.mDetails[WarGodMatchResultObj.PROMOTION_SCORE_DETAIL_MEDAL],roundAwards);
            ++this.mNumDetailItems;
         }
         if(this.mDetails[WarGodMatchResultObj.PROMOTION_SCORE_DETAIL_PUNISH] != 0)
         {
            (this.mDetailItems[this.mNumDetailItems] as PromotionDetailItem).setData(true,WarGodMatchResultObj.PROMOTION_SCORE_DETAIL_PUNISH,this.mDetails[WarGodMatchResultObj.PROMOTION_SCORE_DETAIL_PUNISH]);
            ++this.mNumDetailItems;
         }
         this.arrangeDetailItemPosition();
      }
      
      private function arrangeDetailItemPosition() : void
      {
         var itemStartY:Number = DETAIL_ITEM_START_Y;
         for(var i:int = 0; i < this.mNumDetailItems; i++)
         {
            this.mDetailItems[i].y = itemStartY;
            itemStartY += DETAIL_ITEM_DEFAULT_GAP + DETAIL_ITEM_HEIGHT;
         }
      }
      
      override public function startAni() : void
      {
         super.startAni();
         this.mAnimationCurrentIndex = 0;
         this.mTimer.addEventListener(TimerEvent.TIMER,this.onTimerTick);
         this.mTimer.start();
      }
      
      private function onTimerTick(e:TimerEvent) : void
      {
         if(this.mAnimationCurrentIndex < this.mNumDetailItems)
         {
            this.mDetailItems[this.mAnimationCurrentIndex].visible = true;
            (this.mDetailItems[this.mAnimationCurrentIndex] as PromotionDetailItem).startAnimation();
            ++this.mAnimationCurrentIndex;
         }
         else
         {
            this.mTimer.stop();
            this.mTimer.reset();
            this.mTimer.removeEventListener(TimerEvent.TIMER,this.onTimerTick);
            complete();
         }
      }
   }
}

