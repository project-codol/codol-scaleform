package codo.views.hud.playerInfoBar
{
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   
   public class HealthChangeBubbleContainer extends MovieClip
   {
      
      private static const MAX_BUBBLES:int = 5;
      
      private static const HEALTH_LABEL_POOR_SIZE:int = 10;
      
      public var myBubble1:HealthChangeBubble;
      
      public var myBubble2:HealthChangeBubble;
      
      public var myBubble3:HealthChangeBubble;
      
      public var myBubble4:HealthChangeBubble;
      
      public var myBubble5:HealthChangeBubble;
      
      private var mHealthBubbles:Array;
      
      private var mIndex:int = 0;
      
      public function HealthChangeBubbleContainer()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this.mHealthBubbles = [this.myBubble1,this.myBubble2,this.myBubble3,this.myBubble4,this.myBubble5];
         for(var i:int = 0; i < this.mHealthBubbles.length; i++)
         {
            this.mHealthBubbles[i].visible = false;
         }
      }
      
      public function showHealthChange(health:int) : void
      {
         var bubble:HealthChangeBubble = this.mHealthBubbles[this.mIndex];
         ++this.mIndex;
         if(this.mIndex == MAX_BUBBLES)
         {
            this.mIndex = 0;
         }
         TweenLite.killTweensOf(bubble,false);
         this.resetBubbleState(bubble);
         bubble.healthChange = health;
         this.setChildIndex(bubble,0);
         TweenLite.to(bubble,1,{
            "y":-80,
            "alpha":0.5,
            "onComplete":this.onAnimationComplete,
            "onCompleteParams":[bubble]
         });
      }
      
      private function onAnimationComplete(bubble:HealthChangeBubble) : void
      {
         bubble.visible = false;
      }
      
      private function resetBubbleState(bubble:HealthChangeBubble) : void
      {
         bubble.visible = true;
         bubble.x = 0;
         bubble.y = 0;
         bubble.alpha = 1;
      }
   }
}

