package codo.views.wargodMatchResult_parts
{
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import fsg.util.FsgAudioUtil;
   
   public class AnimateStar extends MovieClip
   {
      
      private static const NO_STAR_FRAME_NAME:String = "noStar";
      
      private static const STAR_FRAME_NAME:String = "star";
      
      private static const GET_STAR_FRAME_NAME:String = "getStar";
      
      private static const LOSE_STAR_FRAME_NAME:String = "loseStar";
      
      private static const SHINE_STAR_FRAME_NAME:String = "starShine";
      
      private static const GET_STAR_ANIMATION_DURATION:Number = 1.4;
      
      private static const LOSE_STAR_ANIMATION_DURATION:Number = 0.4;
      
      private static const SHINE_STAR_ANIMATION_DURATION:Number = 0.4;
      
      public function AnimateStar()
      {
         super();
      }
      
      public function switchStar(value:Boolean) : void
      {
         gotoAndStop(value ? STAR_FRAME_NAME : NO_STAR_FRAME_NAME);
      }
      
      public function playRewardStarAnimation() : TweenLite
      {
         var realPlayRewardStarAnimation:Function = null;
         realPlayRewardStarAnimation = function():void
         {
            playGainSound();
            gotoAndPlay(GET_STAR_FRAME_NAME);
         };
         return TweenLite.to(this,GET_STAR_ANIMATION_DURATION,{"onStart":realPlayRewardStarAnimation});
      }
      
      public function playDeductStarAnimation(playSound:Boolean = false) : TweenLite
      {
         var realPlayDeductStarAnimation:Function = null;
         realPlayDeductStarAnimation = function():void
         {
            gotoAndPlay(LOSE_STAR_FRAME_NAME);
            if(playSound)
            {
               playLoseSound();
            }
         };
         return TweenLite.to(this,LOSE_STAR_ANIMATION_DURATION,{"onStart":realPlayDeductStarAnimation});
      }
      
      public function playShineStar() : TweenLite
      {
         var realPlayShineAnimation:Function = null;
         realPlayShineAnimation = function():void
         {
            gotoAndPlay(SHINE_STAR_FRAME_NAME);
         };
         return TweenLite.to(this,SHINE_STAR_ANIMATION_DURATION,{"onStart":realPlayShineAnimation});
      }
      
      public function playGainSound() : void
      {
         FsgAudioUtil.getInstance().playSound("ui_star_match_star_up");
      }
      
      public function playLoseSound() : void
      {
         FsgAudioUtil.getInstance().playSound("ui_star_match_silver_to_gold");
      }
   }
}

