package components.fsgmatchresult_part
{
   import codo.localization.DictMatchResults;
   import codo.utils.LocalizeUtil;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.utils.getDefinitionByName;
   import fsg.shared.ButtonGeneric;
   import fsg.util.FsgImageHolder;
   import fsg.util.FsgUtil;
   
   public class FsgWeaponProgressRow extends MovieClip
   {
      
      private static const FILL_MAX_WIDTH:int = 212;
      
      private static const ITEM_LINKAGE:String = "fsg.matchresults.weaponAttachmentItem";
      
      private static const ITEM_WIDTH:int = 221;
      
      private static const NUM_VISIBLE_ITEMS:int = 3;
      
      private static const MOUNT_START_X:Number = 110;
      
      private static const CONTAINER_SLIDE_START_X:int = -589;
      
      private static const CONTAINER_SLIDE_END_X:int = 144;
      
      private static const SLIDE_DURATION:Number = 0.3;
      
      private static const ITEM_SLIDE_DURATION:Number = 0.2;
      
      private static const ITEM_SLIDE_DELAY:Number = 0.15;
      
      private static const FILL_SPEED:Number = 0.8;
      
      public var myImgHolder:FsgImageHolder;
      
      public var myPrevArrow:ButtonGeneric;
      
      public var myNextArrow:ButtonGeneric;
      
      public var myListContainer:MovieClip;
      
      public var myItemMount:MovieClip;
      
      public var myProgressBar:MovieClip;
      
      public var myFillMask:MovieClip;
      
      public var myLevelContainer:MovieClip;
      
      public var myMask:MovieClip;
      
      public var myCurrentRank:TextField;
      
      public var myNextRank:TextField;
      
      public var myTitle:TextField;
      
      public var myLevel:TextField;
      
      public var myNoUnlockstext:TextField;
      
      private var mPageIndices:Array;
      
      private var mCurrentPageIndex:int;
      
      private var mTargetWidth:Number;
      
      private var mItems:Vector.<MovieClip>;
      
      public function FsgWeaponProgressRow()
      {
         super();
         this.myPrevArrow = this.myListContainer["myPrevArrow"];
         this.myNextArrow = this.myListContainer["myNextArrow"];
         this.myLevelContainer = this.myListContainer["myLevelContainer"];
         this.myItemMount = this.myListContainer["myItemMount"];
         this.myMask = this.myListContainer["myMask"];
         this.myNoUnlockstext = this.myListContainer["myNoUnlockstext"];
         this.myLevel = this.myLevelContainer["myLevel"];
         this.myListContainer.x = CONTAINER_SLIDE_START_X;
         this.myNoUnlockstext.autoSize = TextFieldAutoSize.CENTER;
         this.myNoUnlockstext.text = LocalizeUtil.localize(DictMatchResults.NO_UNLOCKS);
         this.myNoUnlockstext.visible = false;
      }
      
      public function setData(data:Object) : void
      {
         var unlocks:Array = null;
         var item:MovieClip = null;
         var itemName:TextField = null;
         var imgHolder:FsgImageHolder = null;
         var currentX:int = 0;
         var i:int = 0;
         this.fillProgressBar(data);
         this.myTitle.text = data.name;
         this.myImgHolder.setImage(data.imageURL);
         this.mPageIndices = new Array();
         this.mItems = new Vector.<MovieClip>();
         var numPages:int = 1;
         unlocks = data.unlockAttachment;
         var itemClass:Class = getDefinitionByName(ITEM_LINKAGE) as Class;
         currentX = 0;
         var itemCount:Number = 0;
         for(i = 0; i < unlocks.length; i++)
         {
            item = new itemClass() as MovieClip;
            this.myItemMount.addChild(item);
            item.alpha = 0;
            item.x = currentX;
            currentX += ITEM_WIDTH;
            itemCount++;
            itemName = item["myName"];
            itemName.text = unlocks[i].name;
            imgHolder = item["myImgHolder"];
            imgHolder.setImage(unlocks[i].imageURL);
            if(i == 0)
            {
               this.mPageIndices.push(i);
            }
            if(itemCount > NUM_VISIBLE_ITEMS)
            {
               this.mPageIndices.push(i);
               itemCount = 0;
               numPages++;
            }
            this.mItems.push(item);
         }
         if(this.mItems.length == 0)
         {
            this.myNoUnlockstext.visible = true;
         }
         else
         {
            this.myNoUnlockstext.visible = false;
         }
         if(numPages > 1)
         {
            this.myPrevArrow.visible = false;
            this.myNextArrow.registerClickEvent(this.onNextPage);
            this.myPrevArrow.registerClickEvent(this.onPreviousPage);
         }
         else
         {
            this.myPrevArrow.visible = false;
            this.myNextArrow.visible = false;
         }
         this.mCurrentPageIndex = 0;
      }
      
      public function startAnimation() : void
      {
         TweenLite.to(this.myListContainer,SLIDE_DURATION,{
            "alpha":1,
            "x":CONTAINER_SLIDE_END_X,
            "onComplete":this.onSlideAnimComplete
         });
         TweenLite.to(this.myFillMask,FILL_SPEED,{"width":this.mTargetWidth});
      }
      
      private function onSlideAnimComplete() : void
      {
         var item:MovieClip = null;
         var startDelay:Number = ITEM_SLIDE_DELAY;
         for(var i:int = 0; i < this.mItems.length; i++)
         {
            item = this.mItems[i];
            TweenLite.to(item,ITEM_SLIDE_DURATION,{
               "alpha":1,
               "delay":ITEM_SLIDE_DELAY * i
            });
            TweenLite.to(item.myWhiteOut,ITEM_SLIDE_DURATION,{
               "alpha":0,
               "delay":startDelay
            });
            startDelay += ITEM_SLIDE_DELAY;
         }
      }
      
      private function fillProgressBar(data:Object) : void
      {
         var XPToAdvance:Number = NaN;
         var desiredXP:Number = Number(data.progressInfo["desExpValue"]);
         var currentLevel:Number = Number(data.progressInfo["currentLevel"]);
         var targetLevel:Number = Number(data.progressInfo["targetLevel"]);
         var levels:Array = data.progressInfo["levelValue"];
         var targetLevelIndex:int = 0;
         for(var i:int = int(levels.length); i >= 0; i--)
         {
            if(desiredXP >= levels[i])
            {
               targetLevelIndex = i;
               break;
            }
         }
         var targetProgress:Number = 0;
         if(targetLevelIndex + 1 >= levels.length)
         {
            this.myCurrentRank.text = String(LocalizeUtil.localize(DictMatchResults.LVL) + " " + String(targetLevel));
            this.myLevel.text = String(targetLevel);
            this.myNextRank.text = "";
            targetProgress = 100;
         }
         else
         {
            this.myCurrentRank.text = String(LocalizeUtil.localize(DictMatchResults.LVL) + " " + String(targetLevel));
            this.myLevel.text = String(targetLevel);
            XPToAdvance = levels[targetLevelIndex + 1] - levels[targetLevelIndex];
            targetProgress = 100 * ((desiredXP - levels[targetLevelIndex]) / XPToAdvance);
            this.myNextRank.text = LocalizeUtil.param(DictMatchResults.XP_TO_RANK_UP,[FsgUtil.commaFormatNumber(Math.round(XPToAdvance - XPToAdvance * (targetProgress * 0.01)))]);
         }
         this.SetProgress(targetProgress);
      }
      
      public function SetProgress(progress:Number) : void
      {
         progress = Math.min(100,progress);
         var targetWidth:Number = FILL_MAX_WIDTH * (progress * 0.01);
         this.myFillMask.width = 0;
         this.mTargetWidth = targetWidth;
      }
      
      private function onNextPage() : void
      {
         ++this.mCurrentPageIndex;
         this.changePage();
      }
      
      private function onPreviousPage() : void
      {
         --this.mCurrentPageIndex;
         this.changePage();
      }
      
      private function changePage() : void
      {
         if(this.mCurrentPageIndex == this.mPageIndices.length - 1)
         {
            this.myNextArrow.visible = false;
         }
         else
         {
            this.myNextArrow.visible = true;
         }
         if(this.mCurrentPageIndex == 0)
         {
            this.myPrevArrow.visible = false;
         }
         else
         {
            this.myPrevArrow.visible = true;
         }
         TweenLite.to(this.myItemMount,0.3,{"x":MOUNT_START_X + -this.mPageIndices[this.mCurrentPageIndex] * ITEM_WIDTH});
      }
   }
}

