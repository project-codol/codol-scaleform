package codo.views.hud.nftbl
{
   import codo.constants.HUDComponentTypes;
   import codo.views.hud.HUDComponent;
   import com.greensock.TimelineLite;
   import com.greensock.TweenLite;
   import flash.text.TextField;
   
   public class BallMatchScoreBar extends HUDComponent
   {
      
      public var myTimeLeft:TextField;
      
      private var mOrgTimeLeftX:Number;
      
      private var mOrgTimeLeftY:Number;
      
      public function BallMatchScoreBar()
      {
         super();
         this.mOrgTimeLeftX = this.myTimeLeft.x;
         this.mOrgTimeLeftY = this.myTimeLeft.y;
      }
      
      override public function get CompType() : int
      {
         return HUDComponentTypes.BALL_MATCH_SCORE_BAR;
      }
      
      public function cppPlayTimeLeftWarningAnimation() : void
      {
         var timeline:TimelineLite = null;
         TweenLite.killTweensOf(this.myTimeLeft);
         timeline = new TimelineLite();
         this.myTimeLeft.scaleX = 1;
         this.myTimeLeft.scaleY = 1;
         this.myTimeLeft.x = this.mOrgTimeLeftX;
         this.myTimeLeft.y = this.mOrgTimeLeftY;
         var destX:Number = this.mOrgTimeLeftX - this.myTimeLeft.width * 0.5;
         var destY:Number = this.mOrgTimeLeftY - this.myTimeLeft.height * 0.5;
         timeline.append(TweenLite.to(this.myTimeLeft,0.3,{
            "scaleX":2,
            "scaleY":2,
            "x":destX,
            "y":destY
         }));
         timeline.append(TweenLite.to(this.myTimeLeft,0.3,{
            "scaleX":1,
            "scaleY":1,
            "x":this.mOrgTimeLeftX,
            "y":this.mOrgTimeLeftY
         }));
      }
   }
}

