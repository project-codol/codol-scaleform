package codo.views.wargodMatchResult_parts
{
   import codo.objects.WarGodMatchObj;
   import codo.objects.WarGodMatchResultObj;
   import codo.utils.LocalizeUtil;
   import codo.utils.WarGodUtility;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   
   public class PromotionProgress extends PlacementProgress
   {
      
      public function PromotionProgress()
      {
         super();
         myMRs = [myMR0,myMR1,myMR2];
         myHeader.text = LocalizeUtil.localize("@UI_WARGOD_PROMOTION_PROGRESS");
      }
      
      override public function setData(mMatchResult:WarGodMatchResultObj) : void
      {
         var matchIndex:int = 0;
         var match:WarGodMatchObj = null;
         var result:int = 0;
         mData = mMatchResult;
         var numCompletedBefore:int = mMatchResult.numPromotionComplete;
         for(var i:int = 0; i < numCompletedBefore; i++)
         {
            matchIndex = mMatchResult.numMatchHistroy - numCompletedBefore - 1 + i;
            if(matchIndex < 0)
            {
               matchIndex = 0;
            }
            match = mMatchResult.matchHistroy[matchIndex];
            result = WarGodUtility.getMatchResultByFactors(match.isWinner,match.isDraw,match.isDisconnected);
            myMRs[i].gotoAndStop(mFrames[result]);
         }
         while(i < myMRs.length)
         {
            myMRs[i].gotoAndStop(UNMATCH_FRAME);
            i++;
         }
         myAnimationBar.myBar.gotoAndStop(mFrames[mMatchResult.result]);
         myProgressValue.text = mMatchResult.numPromotionComplete + 1 + "/" + myMRs.length;
      }
      
      override protected function onShowComplete() : void
      {
         var bar:MovieClip = null;
         bar = myMRs[mData.numPromotionComplete];
         myAnimationBar.visible = true;
         myAnimationBar.x = bar.x;
         myAnimationBar.y = bar.y;
         myAnimationBar.gotoAndPlay(1);
         TweenLite.to(this,1,{"onComplete":this.onFlashComplete});
      }
      
      private function onFlashComplete() : void
      {
         complete();
      }
   }
}

