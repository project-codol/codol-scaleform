package codo.views.wargodMatchResult_parts
{
   import codo.component.ContentContainer;
   import codo.objects.WarGodMatchObj;
   import codo.objects.WarGodMatchResultObj;
   import codo.utils.LocalizeUtil;
   import codo.utils.WarGodUtility;
   import com.greensock.TimelineLite;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class PlacementProgress extends WarGodAnimateElement
   {
      
      protected static const UNMATCH_FRAME:int = 1;
      
      protected static const WIN_FRAME:int = 2;
      
      protected static const LOSE_FRAME:int = 3;
      
      protected static const DRAW_FRAME:int = 4;
      
      public var myMR0:MovieClip;
      
      public var myMR1:MovieClip;
      
      public var myMR2:MovieClip;
      
      public var myMR3:MovieClip;
      
      public var myMR4:MovieClip;
      
      public var myAnimationBar:MovieClip;
      
      public var myHeader:TextField;
      
      public var myProgressLabel:TextField;
      
      public var myProgressValue:TextField;
      
      public var myContainer:ContentContainer;
      
      protected var myMRs:Array;
      
      protected var mFrames:Array;
      
      protected var mData:WarGodMatchResultObj;
      
      private var mTimeline:TimelineLite;
      
      public function PlacementProgress()
      {
         super();
         this.myContainer.width = 300;
         this.myContainer.height = 150;
         this.myContainer.showAccents = false;
         this.myContainer.alpha = 0;
         this.myProgressLabel.alpha = 0;
         this.myProgressValue.alpha = 0;
         this.myProgressLabel.text = LocalizeUtil.localize("@UI_WARGOD_MATCHES_COMPLETE");
         this.myHeader.text = LocalizeUtil.localize("@UI_WARGOD_PLACEMENT_PROGRESS");
         this.myMRs = [this.myMR0,this.myMR1,this.myMR2,this.myMR3,this.myMR4];
         this.mFrames = [LOSE_FRAME,WIN_FRAME,DRAW_FRAME,LOSE_FRAME];
      }
      
      override public function startAni() : void
      {
         super.startAni();
         alpha = 0;
         this.myAnimationBar.visible = false;
         this.mTimeline = new TimelineLite();
         this.mTimeline.append(TweenLite.to(this,1,{"alpha":1}));
         this.mTimeline.append(TweenLite.to(this.myContainer,0.5,{"alpha":1}));
         this.mTimeline.append(TweenLite.to(this.myProgressValue,0.5,{"alpha":1}));
         this.mTimeline.append(TweenLite.to(this.myProgressLabel,0.5,{
            "alpha":1,
            "onComplete":this.onShowComplete
         }));
         this.mTimeline.play();
      }
      
      override public function stopAni() : void
      {
         super.stopAni();
      }
      
      public function setData(mMatchResult:WarGodMatchResultObj) : void
      {
         var match:WarGodMatchObj = null;
         var result:int = 0;
         this.mData = mMatchResult;
         var numCompletedBefore:int = mMatchResult.numPlacementComplete - 1;
         for(var i:int = 0; i < numCompletedBefore; i++)
         {
            match = mMatchResult.matchHistroy[i];
            result = WarGodUtility.getMatchResultByFactors(match.isWinner,match.isDraw,match.isDisconnected);
            this.myMRs[i].gotoAndStop(this.mFrames[result]);
         }
         while(i < this.myMRs.length)
         {
            this.myMRs[i].gotoAndStop(UNMATCH_FRAME);
            i++;
         }
         this.myAnimationBar.myBar.gotoAndStop(this.mFrames[mMatchResult.result]);
         this.myProgressValue.text = mMatchResult.numPlacementComplete + "/" + this.myMRs.length;
      }
      
      protected function onShowComplete() : void
      {
         var bar:MovieClip = this.myMRs[this.mData.numPlacementComplete - 1];
         this.myAnimationBar.visible = true;
         this.myAnimationBar.x = bar.x;
         this.myAnimationBar.y = bar.y;
         this.myAnimationBar.gotoAndPlay(1);
         TweenLite.to(this,1,{"onComplete":this.onFlashComplete});
      }
      
      private function onFlashComplete() : void
      {
         complete();
      }
   }
}

