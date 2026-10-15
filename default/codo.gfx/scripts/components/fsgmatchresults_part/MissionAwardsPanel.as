package components.fsgmatchresults_part
{
   import codo.constants.GameInfo;
   import codo.event.ParaEvent;
   import codo.localization.DictMatchResults;
   import codo.utils.LocalizeUtil;
   import codo.utils.Logger;
   import com.greensock.TweenLite;
   import com.society.comscore.DAXDispatcher;
   import components.fsgimgswitcher_part.ImgSwitcher;
   import components.fsgmatchresult_part.FsgMatchResultsListBase;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.utils.getDefinitionByName;
   import flash.utils.setTimeout;
   
   public class MissionAwardsPanel extends FsgMatchResultsListBase
   {
      
      private static const COMPONENT_WIDTH:int = 175;
      
      private static const COMPONENT_GAP_Y:int = -30;
      
      private static const ITEM_ANIM_DELAY:Number = 0.1;
      
      private static const MOUNT_START_X:Number = 178;
      
      private static const ITEM_SLIDE_DURATION:Number = 0.17;
      
      private static const ITEM_SLIDE_DISTANCE:Number = 200;
      
      private static const BG_FADE_DURATION:Number = 600;
      
      private static const END_FRAME:String = "end";
      
      private static const NUM_VISIBLE_ITEMS:Number = 5;
      
      public var myNoAwardsText:TextField;
      
      public var myMask:MovieClip;
      
      public var myAwardMount:MovieClip;
      
      public var myNoAwardsContainer:MovieClip;
      
      public var myPagination:ImgSwitcher;
      
      private var mVecAwardItems:Vector.<MissionAwardsComponent>;
      
      private var mPageIndices:Array;
      
      private var mCurrentPageIndex:int;
      
      public function MissionAwardsPanel()
      {
         super();
         this.myNoAwardsText = this.myNoAwardsContainer["myNoAwardsText"];
         this.mCurrentPageIndex = 0;
         this.mVecAwardItems = new Vector.<MissionAwardsComponent>();
         this.myNoAwardsText.text = LocalizeUtil.localize(DictMatchResults.NO_AWARDS);
      }
      
      public function setMissionAward(medals:Array) : void
      {
         var i:uint;
         var missionAwardObj:Object = null;
         var awardReporting:String = "";
         var dataArr:Array = medals;
         var missionAwardsArr:Array = [];
         for(i = 0; i < dataArr.length; i++)
         {
            missionAwardObj = new Object();
            missionAwardObj.name = dataArr[i].text;
            missionAwardObj.desc = dataArr[i].description;
            missionAwardObj.imageURL = dataArr[i].imgUrl;
            missionAwardObj.reward = dataArr[i].reward;
            missionAwardObj.count = dataArr[i].count;
            missionAwardsArr.push(missionAwardObj);
            awardReporting += missionAwardObj.name + ",";
         }
         awardReporting = awardReporting.slice(0,-1);
         try
         {
            DAXDispatcher.queue("action_type","match_awards");
            DAXDispatcher.queue("awards_earned",awardReporting);
            DAXDispatcher.dispatch();
         }
         catch(e:Error)
         {
            Logger.print("*** DAXDispatcher: " + e.message);
         }
         this.PopulateAwards(missionAwardsArr);
         this.myNoAwardsText.visible = medals.length <= 0;
      }
      
      public function PopulateAwards(awards:Array) : void
      {
         var numPages:int = 0;
         var pageWidth:Number = NaN;
         var curAward:Object = null;
         var item:MissionAwardsComponent = null;
         numPages = 1;
         pageWidth = 0;
         var itemCount:int = 0;
         this.mPageIndices = new Array();
         for(var j:int = 0; j < awards.length; j++)
         {
            curAward = awards[j];
            if(j >= this.mVecAwardItems.length)
            {
               item = this.getNewMedalComponent();
               item.x = j * COMPONENT_WIDTH;
               item.y = COMPONENT_GAP_Y;
               this.mVecAwardItems.push(item);
               this.myAwardMount.addChild(item);
               item.alpha = 0;
               pageWidth += COMPONENT_WIDTH;
            }
            this.mVecAwardItems[j].SetItem(curAward);
            itemCount++;
            if(j == 0)
            {
               this.mPageIndices.push(j);
            }
            if(itemCount > NUM_VISIBLE_ITEMS)
            {
               this.mPageIndices.push(j);
               pageWidth = 0;
               numPages++;
               itemCount = 0;
            }
         }
         if(numPages > 1)
         {
            this.myPagination.visible = true;
            this.myPagination.addEventListener(ImgSwitcher.EVT_CHANGED,this.onPaginationChange);
            this.myPagination.imgCount = numPages;
            this.myPagination.selectedIndex = this.mCurrentPageIndex;
            this.myPagination.x = GameInfo.DEFAULT_WIDTH * 0.5 - this.myPagination.width * 0.5;
            this.myPagination.autoPageFlipEnable = false;
         }
         else
         {
            this.myPagination.visible = false;
         }
         while(this.myAwardMount.numChildren > awards.length)
         {
            this.myAwardMount.removeChildAt(awards.length);
         }
         this.mVecAwardItems.length = awards.length;
      }
      
      override public function startAnimation() : void
      {
         super.startAnimation();
         this.gotoAndPlay(2);
         setTimeout(this.startItemAnimation,BG_FADE_DURATION);
      }
      
      private function startItemAnimation() : void
      {
         var clip:MissionAwardsComponent = null;
         for(var i:int = 0; i < this.mVecAwardItems.length; i++)
         {
            clip = this.mVecAwardItems[i];
            clip.alpha = 1;
            TweenLite.from(clip,ITEM_SLIDE_DURATION,{
               "alpha":0,
               "x":clip.x + ITEM_SLIDE_DISTANCE,
               "delay":ITEM_ANIM_DELAY * i
            });
         }
         if(this.mPageIndices != null && this.mPageIndices.length > 1)
         {
            TweenLite.to(this.myPagination,0.1,{
               "alpha":1,
               "onComplete":this.startAutoPageAnimation
            });
         }
         else
         {
            this.myPagination.alpha = 0;
         }
         TweenLite.delayedCall(ITEM_SLIDE_DURATION * this.mVecAwardItems.length,this.onAnimationComplete);
      }
      
      private function startAutoPageAnimation() : void
      {
         this.myPagination.autoPageFlipEnable = true;
      }
      
      override public function skipAnimation() : void
      {
         gotoAndStop(END_FRAME);
         for(var i:int = 0; i < this.mVecAwardItems.length; i++)
         {
            this.mVecAwardItems[i].alpha = 1;
         }
         if(null != this.mPageIndices && this.mPageIndices.length > 1)
         {
            this.myPagination.alpha = 1;
            this.startAutoPageAnimation();
         }
      }
      
      private function onPaginationChange(cEvt:ParaEvent) : void
      {
         this.mCurrentPageIndex = cEvt.myPara.index;
         TweenLite.to(this.myAwardMount,0.3,{"x":MOUNT_START_X + -this.mPageIndices[this.mCurrentPageIndex] * COMPONENT_WIDTH});
      }
      
      private function getNewMedalComponent() : MissionAwardsComponent
      {
         var awardClass:Class = getDefinitionByName("fsg.matchresults.missionAwardsComponent") as Class;
         return new awardClass() as MissionAwardsComponent;
      }
      
      private function onAnimationComplete() : void
      {
         if(null != mOnCompleteCallback)
         {
            mOnCompleteCallback();
         }
      }
   }
}

