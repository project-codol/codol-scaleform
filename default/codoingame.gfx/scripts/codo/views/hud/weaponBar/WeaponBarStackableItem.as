package codo.views.hud.weaponBar
{
   import codo.style.GlobalGuide;
   import codo.style.SpyHudGuide;
   import fl.motion.AdjustColor;
   import flash.display.MovieClip;
   import flash.filters.ColorMatrixFilter;
   import flash.text.TextField;
   import fsg.util.FsgImageHolder;
   
   public class WeaponBarStackableItem extends MovieClip
   {
      
      private static var ENABLE_COLOR:uint = 16745472;
      
      public var myKey:TextField;
      
      public var myIcon:FsgImageHolder;
      
      public var myBG:MovieClip;
      
      private var mCanvas:MovieClip;
      
      private var mColorFilter:ColorMatrixFilter;
      
      public function WeaponBarStackableItem()
      {
         super();
         var colorAdjust:AdjustColor = new AdjustColor();
         colorAdjust.contrast = -80;
         colorAdjust.hue = 0;
         colorAdjust.saturation = 0;
         colorAdjust.brightness = 0;
         this.mColorFilter = new ColorMatrixFilter(colorAdjust.CalculateFinalFlatArray());
      }
      
      public function set image(name:String) : void
      {
         this.myIcon.setImage(name);
      }
      
      public function cppSetStack(stack:int, maxStack:int) : void
      {
         var X_OFFSET:Number = 8;
         var Y_OFFSET:Number = 5;
         var RECT_WIDTH:Number = 3;
         var RECT_PADDING:Number = 3;
         var TOTAL_HEIGHT:Number = 55;
         if(this.mCanvas != null)
         {
            removeChild(this.mCanvas);
         }
         this.mCanvas = addChild(new MovieClip()) as MovieClip;
         this.mCanvas.x = 0;
         this.mCanvas.y = 0;
         this.mCanvas.graphics.clear();
         if(maxStack <= 0)
         {
            this.myIcon.filters = [this.mColorFilter];
            return;
         }
         this.myIcon.filters = [];
         if(stack == 0)
         {
            this.myKey.textColor = GlobalGuide.CODO_GRAY_LIGHT;
         }
         else
         {
            this.myKey.textColor = SpyHudGuide.HINT_COLOR_DARK_YELLOW;
         }
         if(maxStack == 1)
         {
            return;
         }
         var stackRectHeight:Number = (TOTAL_HEIGHT - 2 * Y_OFFSET - (maxStack - 1) * RECT_PADDING) / maxStack;
         var y:Number = Y_OFFSET;
         for(var i:int = 0; i < maxStack; i++)
         {
            if(maxStack - i > stack)
            {
               this.mCanvas.graphics.beginFill(16777215,0.5);
            }
            else
            {
               this.mCanvas.graphics.beginFill(16777215,1);
            }
            this.mCanvas.graphics.drawRect(X_OFFSET,y,RECT_WIDTH,stackRectHeight);
            y += stackRectHeight + RECT_PADDING;
            this.mCanvas.graphics.endFill();
         }
      }
   }
}

