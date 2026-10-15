package codo.views.hud.resultStats
{
   import codo.utils.SoundUtil;
   import codo.views.hud.shared.HUDLabelTextField;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   
   public class HUDBossScoreBoard extends MovieClip
   {
      
      private static const TWEEN_DURATION:Number = 1;
      
      private static const TWEEN_DELAY:Number = 0.5;
      
      public var myDamageScore:HUDLabelTextField;
      
      public var mySurvivalScore:HUDLabelTextField;
      
      public var myTimeScore:HUDLabelTextField;
      
      public var myTotalScore:HUDLabelTextField;
      
      public function HUDBossScoreBoard()
      {
         super();
      }
      
      public function startAnimation() : void
      {
         this.playSoundLoop(TWEEN_DELAY,TWEEN_DURATION,"zh_boss_endui_small_counter_lp");
         this.myDamageScore.tweenValueText(TWEEN_DURATION,TWEEN_DELAY);
         this.mySurvivalScore.tweenValueText(TWEEN_DURATION,TWEEN_DELAY);
         this.myTimeScore.tweenValueText(TWEEN_DURATION,TWEEN_DELAY);
         this.playSoundLoop(TWEEN_DELAY + TWEEN_DURATION + 0.1,TWEEN_DURATION,"zh_boss_endui_med_counter_lp");
         this.myTotalScore.tweenValueText(TWEEN_DURATION,TWEEN_DELAY + TWEEN_DURATION + 0.1);
      }
      
      private function playSoundLoop(delay:Number, duration:Number, sound:String) : TweenLite
      {
         return new TweenLite(this,duration,{
            "delay":delay,
            "onStart":SoundUtil.getInstance().playSound,
            "onStartParams":[sound],
            "onComplete":SoundUtil.getInstance().stopSound
         });
      }
   }
}

