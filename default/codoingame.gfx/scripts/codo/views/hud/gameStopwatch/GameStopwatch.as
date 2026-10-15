package codo.views.hud.gameStopwatch
{
   import codo.constants.HUDComponentTypes;
   import codo.views.hud.HUDComponent;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class GameStopwatch extends HUDComponent
   {
      
      public var myTextWrapper:MovieClip;
      
      public var myTimeLeft:TextField;
      
      public function GameStopwatch()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         this.myTimeLeft = this.myTextWrapper["myText"];
      }
      
      override public function get CompType() : int
      {
         return HUDComponentTypes.GAME_STOPWATCH;
      }
   }
}

