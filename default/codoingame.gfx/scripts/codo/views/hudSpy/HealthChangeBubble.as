package codo.views.hudSpy
{
   import codo.style.SpyHudGuide;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class HealthChangeBubble extends MovieClip
   {
      
      private static const HEALTH_ADD_COLOR:uint = 16777215;
      
      private static const HEALTH_LOSE_COLOR:uint = SpyHudGuide.ROLE_SPY_COLOR;
      
      public var myLabel:TextField;
      
      public function HealthChangeBubble()
      {
         super();
      }
      
      public function set healthChange(health:int) : void
      {
         if(health > 0)
         {
            this.myLabel.text = "+" + health.toString();
            this.myLabel.textColor = HEALTH_ADD_COLOR;
         }
         else
         {
            this.myLabel.text = health.toString();
            this.myLabel.textColor = HEALTH_LOSE_COLOR;
         }
      }
   }
}

