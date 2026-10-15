package fsg.shared.widgets
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class FsgProgressBar extends Sprite
   {
      
      public static const FRAME_STYLE_VIOLET:uint = 1;
      
      public static const FRAME_STYLE_GREEN:uint = 2;
      
      public static const FRAME_STYLE_BLUE:uint = 3;
      
      public static const FRAME_STYLE_YELLOW:uint = 4;
      
      public var myBarShadow:Sprite;
      
      public var myHighlight:Sprite;
      
      public var myProgressBarFill:MovieClip;
      
      public var myProgressBarBkg:Sprite;
      
      public var myBarOutline:Sprite;
      
      public function FsgProgressBar()
      {
         super();
         this.myBarOutline.visible = false;
      }
      
      public function setProgressBarFillStyle(styleFrame:uint) : void
      {
         this.myProgressBarFill.gotoAndStop(styleFrame);
      }
      
      public function setProgressBarFillScaleX(value:Number) : void
      {
         this.myProgressBarFill.scaleX = Math.min(value,1);
      }
      
      public function formatProgressBarFill(barHeight:int = -1, barX:uint = 0, barY:uint = 0) : void
      {
         if(barHeight > -1)
         {
            this.myProgressBarFill.height = barHeight;
         }
         this.myProgressBarFill.width -= barX;
         this.myProgressBarFill.height -= barY;
         this.myProgressBarFill.y = barY;
         this.myProgressBarFill.x = barX;
      }
   }
}

