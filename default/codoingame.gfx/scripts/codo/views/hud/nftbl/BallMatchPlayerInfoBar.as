package codo.views.hud.nftbl
{
   import codo.constants.HUDComponentTypes;
   import codo.views.hud.HUDComponent;
   import com.greensock.TimelineLite;
   import com.greensock.TweenLite;
   import flash.text.TextField;
   
   public class BallMatchPlayerInfoBar extends HUDComponent
   {
      
      public var myCarryBallTimeLimit:TextField;
      
      public function BallMatchPlayerInfoBar()
      {
         super();
      }
      
      override public function get CompType() : int
      {
         return HUDComponentTypes.BALL_MATCH_PLAYER_INFO_BAR;
      }
      
      public function cppPlayCarryBallTimeLimitAnimation() : void
      {
         var timeline:TimelineLite = null;
         TweenLite.killTweensOf(this.myCarryBallTimeLimit);
         timeline = new TimelineLite();
         this.myCarryBallTimeLimit.scaleX = 1;
         this.myCarryBallTimeLimit.scaleY = 1;
         timeline.append(TweenLite.to(this.myCarryBallTimeLimit,0.3,{
            "scaleX":1.2,
            "scaleY":1.2
         }));
         timeline.append(TweenLite.to(this.myCarryBallTimeLimit,0.3,{
            "scaleX":1,
            "scaleY":1
         }));
      }
   }
}

