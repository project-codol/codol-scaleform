package codo.views.wargodMatchResult_parts
{
   import codo.localization.DictWarGod;
   import codo.objects.UnlockItemObj;
   import codo.objects.WarGodMatchResultObj;
   import codo.wargod.matchresult.seniorWargodLongPromotionDetailItem;
   import codo.wargod.matchresult.seniorWargodShortPromotionDetailItem;
   import flash.display.MovieClip;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.utils.Timer;
   
   public class SeniorWarGodPromotionDetailPanel extends WarGodAnimateElement
   {
      
      private static const APPEAR_INTERVAL:int = 200;
      
      private static const ITEM_Y_PADDING:int = 25;
      
      private static const ITEM_X_COLUMN0:int = 0;
      
      private static const ITEM_X_COLUMN1:int = 452;
      
      private static const ITEM_HEIGHT:int = 64;
      
      public var myLabel:TextField;
      
      public var myBar:MovieClip;
      
      public var myItemsHolder:MovieClip;
      
      private var mItems:Vector.<PromotionDetailItem>;
      
      private var mDetails:Array;
      
      private var mTimer:Timer;
      
      private var mAnimationCurrentIndex:int = 0;
      
      public function SeniorWarGodPromotionDetailPanel()
      {
         super();
         this.mItems = new Vector.<PromotionDetailItem>();
         this.mTimer = new Timer(APPEAR_INTERVAL);
         this.myLabel.text = DictWarGod.PROMOTION_SCORE_DETAIL_LABEL;
      }
      
      public function setData(data:WarGodMatchResultObj, roundAwards:Vector.<UnlockItemObj>) : void
      {
         var i:int = 0;
         var yOffset:Number = NaN;
         var group0DetailItemNumber:int = 0;
         var column:int = 0;
         this.mDetails = data.matchResultFromDvar;
         var availableDetailNumber:int = this.getAvailableDetailNumber();
         if(availableDetailNumber <= 3)
         {
            yOffset = 0;
            for(i = 1; i < this.mDetails.length; i++)
            {
               if(WarGodMatchResultObj.isValidSeniorWarGodDetail(i))
               {
                  if(this.mDetails[i] != 0)
                  {
                     this.createLongDetailItem(i,this.mDetails[i],ITEM_X_COLUMN0,yOffset);
                     yOffset += ITEM_HEIGHT + ITEM_Y_PADDING;
                  }
                  if(i == 2)
                  {
                     yOffset += ITEM_Y_PADDING;
                  }
               }
            }
         }
         else
         {
            group0DetailItemNumber = this.getAvailableGroup0DetailNumber();
            yOffset = 0;
            if(group0DetailItemNumber == 2)
            {
               this.createShortDetailItem(WarGodMatchResultObj.SENIOR_WARGOD_PROMOTION_SCORE_DETAIL_WINLOSE,this.mDetails[WarGodMatchResultObj.SENIOR_WARGOD_PROMOTION_SCORE_DETAIL_WINLOSE],ITEM_X_COLUMN0,yOffset);
               this.createShortDetailItem(WarGodMatchResultObj.SENIOR_WARGOD_PROMOTION_SCORE_DETAIL_PUNISH,this.mDetails[WarGodMatchResultObj.SENIOR_WARGOD_PROMOTION_SCORE_DETAIL_PUNISH],ITEM_X_COLUMN1,yOffset);
            }
            else if(group0DetailItemNumber == 1)
            {
               i = 1;
               if(i < 3)
               {
                  this.createLongDetailItem(i,this.mDetails[i],ITEM_X_COLUMN0,yOffset);
               }
            }
            if(group0DetailItemNumber > 0)
            {
               yOffset += ITEM_HEIGHT + 2 * ITEM_Y_PADDING;
            }
            column = 0;
            for(i = 8; i < this.mDetails.length; i++)
            {
               if(this.mDetails[i] != 0)
               {
                  this.createShortDetailItem(i,this.mDetails[i],column == 0 ? ITEM_X_COLUMN0 : ITEM_X_COLUMN1,yOffset);
                  column = (column + 1) % 2;
                  if(column == 0)
                  {
                     yOffset += ITEM_HEIGHT + ITEM_Y_PADDING;
                  }
               }
            }
         }
      }
      
      private function getAvailableDetailNumber() : int
      {
         var availableDetailNumber:int = 0;
         for(var i:int = 1; i < this.mDetails.length; i++)
         {
            if(WarGodMatchResultObj.isValidSeniorWarGodDetail(i))
            {
               if(this.mDetails[i] != 0)
               {
                  availableDetailNumber += 1;
               }
            }
         }
         return availableDetailNumber;
      }
      
      private function getAvailableGroup0DetailNumber() : int
      {
         var availableDetailNumber:int = 0;
         var i:int = 1;
         while(i <= 2 && i < this.mDetails.length)
         {
            if(this.mDetails[i] != 0)
            {
               availableDetailNumber += 1;
            }
            i++;
         }
         return availableDetailNumber;
      }
      
      private function createShortDetailItem(type:int, score:int, x:Number, y:Number) : void
      {
         var detailItem:PromotionDetailItem = new seniorWargodShortPromotionDetailItem();
         this.myItemsHolder.addChild(detailItem);
         detailItem.x = x;
         detailItem.y = y;
         detailItem.setData(false,type,score);
         this.mItems.push(detailItem);
      }
      
      private function createLongDetailItem(type:int, score:int, x:Number, y:Number) : void
      {
         var detailItem:PromotionDetailItem = new seniorWargodLongPromotionDetailItem();
         this.myItemsHolder.addChild(detailItem);
         detailItem.x = x;
         detailItem.y = y;
         detailItem.setData(false,type,score);
         this.mItems.push(detailItem);
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
         if(this.mAnimationCurrentIndex < this.mItems.length)
         {
            this.mItems[this.mAnimationCurrentIndex].visible = true;
            (this.mItems[this.mAnimationCurrentIndex] as PromotionDetailItem).startAnimation();
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

