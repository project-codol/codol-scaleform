package codo.views.uitour.ingame
{
   import codo.component.tutorial.TourBaseComponent;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class UITourInGameAnimatedLines extends TourBaseComponent
   {
      
      private static const FRAME_KILL:uint = 1;
      
      private static const FRAME_ANIMATE:uint = 2;
      
      public var myLines1:MovieClip;
      
      public var myLines2:MovieClip;
      
      public var myMask:Sprite;
      
      public function UITourInGameAnimatedLines()
      {
         super();
         super.deactive();
      }
      
      override public function active() : void
      {
         super.active();
         this.myLines1.gotoAndPlay(FRAME_ANIMATE);
         this.myLines2.gotoAndPlay(FRAME_ANIMATE);
      }
      
      override public function deactive() : void
      {
         super.deactive();
         this.myLines1.gotoAndStop(FRAME_KILL);
         this.myLines2.gotoAndStop(FRAME_KILL);
      }
   }
}

