package codo.style
{
   import codo.utils.Logger;
   import com.greensock.TweenLite;
   import flash.display.DisplayObject;
   import flash.geom.ColorTransform;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   public class GlobalGuide
   {
      
      public static const DESIGN_GRID_WIDTH:uint = 43;
      
      public static const FOCUS_DURATION:Number = 0.2;
      
      private static const UNFOCUS_SCALE:Number = 1;
      
      public static var FOCUS_SCALE:Number = 1.09;
      
      public static var FOCUS_ALPHA:Number = 1;
      
      public static var UNFOCUS_ALPHA:Number = 0.5;
      
      public static var GOLDEN_RATIO:Number = 0.618;
      
      public static const COMPONENT_PADDING:int = 10;
      
      public static const FONT_FACE_MEDIUM:String = "FZLanTingHei-R-GBK";
      
      public static const FONT_FACE_BOLD:String = "FZZongYi-M05S";
      
      public static const FONT_FACE_NUMBERS:String = "Agency FB";
      
      public static const FONT_FACE_NUMBERS_BOLD:String = "Agency FB Bold";
      
      public static const FONT_SIZE_MICRO:int = 10;
      
      public static const FONT_SIZE_TINY:int = 12;
      
      public static const FONT_SIZE_EXTRA_SMALL:int = 15;
      
      public static const FONT_SIZE_SMALL:int = 18;
      
      public static const FONT_SIZE_MEDIUM_SMALL:int = 20;
      
      public static const FONT_SIZE_MEDIUM:int = 24;
      
      public static const FONT_SIZE_LARGE:int = 36;
      
      public static const FONT_SIZE_HUGE:int = 48;
      
      public static const FONT_SIZE_GIGANTIC:int = 68;
      
      public static const WHITE:uint = 16777215;
      
      public static const BLACK:uint = 0;
      
      public static const GREEN:uint = 65280;
      
      public static const NAV_TEXT_BLUE:uint = 3317998;
      
      public static const GRAY_50:uint = 8421504;
      
      public static const GRAY_80:uint = 13421772;
      
      public static const CODO_BLACK:uint = 1118481;
      
      public static const CODO_GRAY_DARK:uint = 2369320;
      
      public static const CODO_BLUE_DARK:uint = 1393005;
      
      public static const CODO_BLUE_MID:uint = 3576790;
      
      public static const CODO_BLUE_LIGHT:uint = 41706;
      
      public static const CODO_BLUE_HIGHLIGHT:uint = 4375548;
      
      public static const CODO_GRAY_LIGHT:uint = 8619913;
      
      public static const CODO_YELLOW:uint = 16774407;
      
      public static const CODO_COLOR_HIGHLIGHT_ORANGE:uint = 16218120;
      
      public static const CODO_RED:uint = 12658477;
      
      public static const CODO_INSTRUCTION_GREY:uint = 10002856;
      
      public static const COMMON_CHALLENGE_COLOR:uint = 16777215;
      
      public static const PVE_CHALLENGE_COLOR:uint = 5308335;
      
      public static const PVP_CHALLENGE_COLOR:uint = 16776528;
      
      public static const CHAT_DEFAULT_COLOR:uint = 14540253;
      
      public static const CHAT_SYSTEM_COLOR:uint = 16711680;
      
      public function GlobalGuide()
      {
         super();
      }
      
      public static function get styleTextHeader() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.fontColor = WHITE;
         style.fontSize = FONT_SIZE_LARGE;
         return style;
      }
      
      public static function get styleGlobalShoppingCartItemCount() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_BOLD;
         style.fontColor = NAV_TEXT_BLUE;
         style.fontSize = FONT_SIZE_EXTRA_SMALL;
         return style;
      }
      
      public static function get styleTextSubHeader() : TextStyle
      {
         var style:TextStyle = styleTextHeader;
         style.fontSize = FONT_SIZE_MEDIUM;
         return style;
      }
      
      public static function get styleTextDescription() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.fontColor = WHITE;
         style.fontSize = FONT_SIZE_EXTRA_SMALL;
         style.multiLine = style.wordWrap = true;
         return style;
      }
      
      public static function get styleTextSaleLimit() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.fontColor = CODO_COLOR_HIGHLIGHT_ORANGE;
         style.fontSize = FONT_SIZE_EXTRA_SMALL;
         style.multiLine = style.wordWrap = true;
         return style;
      }
      
      public static function get stylePopupDescription() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.fontColor = WHITE;
         style.fontSize = FONT_SIZE_MEDIUM_SMALL;
         style.multiLine = style.wordWrap = true;
         return style;
      }
      
      public static function get styleTextSmall() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.fontColor = WHITE;
         style.fontSize = FONT_SIZE_TINY;
         return style;
      }
      
      public static function get subNavTextStyle() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.fontSize = FONT_SIZE_EXTRA_SMALL;
         style.alignment = TextStyle.HALIGN_CENTER;
         style.autoSize = TextFieldAutoSize.NONE;
         style.multiLine = style.wordWrap = false;
         style.alignmentVertical = TextStyle.VALIGN_MIDDLE;
         return style;
      }
      
      public static function get styleNumericTextSmall() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_NUMBERS;
         style.fontColor = WHITE;
         style.fontSize = FONT_SIZE_SMALL;
         style.alignmentVertical = TextStyle.VALIGN_MIDDLE;
         style.autoSize = TextFieldAutoSize.LEFT;
         return style;
      }
      
      public static function clearComponentTierColor(... args) : void
      {
         var item:DisplayObject = null;
         var newColorTf:ColorTransform = new ColorTransform();
         for each(item in args)
         {
            if(!item is TextField)
            {
               item.transform.colorTransform = newColorTf;
            }
         }
      }
      
      public static function formatComponentsByTier(tier:uint, args:Vector.<DisplayObject>) : void
      {
         var colorTf:ColorTransform = null;
         var displayobj:DisplayObject = null;
         var tf:TextField = null;
         try
         {
            for each(displayobj in args)
            {
               if(displayobj in TextField)
               {
                  tf = displayobj as TextField;
                  tf.textColor = tier;
               }
               else
               {
                  colorTf = new ColorTransform();
                  colorTf.color = tier;
                  displayobj.transform.colorTransform = colorTf;
               }
            }
         }
         catch(e:Error)
         {
            Logger.print(e.message + ". You probably passed a Non-Display Object");
         }
      }
      
      public static function TOGGLE_ITEM_FOCUS_CENTERPOINT(item:DisplayObject, isFocused:Boolean, initX:Number, initY:Number) : void
      {
         var offX:Number = NaN;
         var offY:Number = NaN;
         var prevW:Number = item.width;
         var prevH:Number = item.height;
         var focusScale:Number = isFocused ? 1.05 : UNFOCUS_SCALE;
         item.scaleX = item.scaleY = focusScale;
         item.x += (prevW - item.width) * 0.5;
         item.y += (prevH - item.height) * 0.5;
      }
      
      public static function TOGGLE_ITEM_FOCUS(item:DisplayObject, isFocused:Boolean, toggleAlpha:Boolean = false, overrideScale:Number = -1, delay:Number = 0, onAnimComplete:Function = null) : void
      {
         var focusScale:Number = isFocused ? FOCUS_SCALE : UNFOCUS_SCALE;
         var endAlpha:Number = 1;
         if(toggleAlpha)
         {
            endAlpha = isFocused ? FOCUS_ALPHA : UNFOCUS_ALPHA;
         }
         else
         {
            endAlpha = item.alpha;
         }
         if(overrideScale > -1)
         {
            focusScale = overrideScale;
         }
         TweenLite.to(item,FOCUS_DURATION,{
            "alpha":endAlpha,
            "scaleX":focusScale,
            "scaleY":focusScale,
            "delay":delay,
            "overwrite":true,
            "onComplete":onAnimComplete
         });
      }
      
      public static function TOGGLE_ITEM_FOCUS_SINGLE_AXIS(item:DisplayObject, isFocused:Boolean, useXAxisOnly:Boolean = false, overrideScale:Number = -1, delay:Number = 0) : void
      {
         var focusScale:Number = isFocused ? FOCUS_SCALE : UNFOCUS_SCALE;
         if(overrideScale > -1)
         {
            focusScale = overrideScale;
         }
         var focusXScale:Number = useXAxisOnly ? focusScale : item.scaleX;
         var focusYScale:Number = !useXAxisOnly ? item.scaleY : focusScale;
         TweenLite.to(item,FOCUS_DURATION,{
            "scaleX":focusXScale,
            "scaleY":focusYScale,
            "delay":delay,
            "overwrite":true
         });
      }
      
      public static function TOGGLE_ITEM_ONLY_ALPHA(item:DisplayObject, isFocused:Boolean, overrideAlpha:Number = -1, delay:Number = 0) : void
      {
         var focusAlpha:Number = isFocused ? FOCUS_ALPHA : UNFOCUS_ALPHA;
         if(overrideAlpha > -1)
         {
            focusAlpha = overrideAlpha;
         }
         TweenLite.to(item,FOCUS_DURATION,{
            "alpha":overrideAlpha,
            "delay":delay
         });
      }
   }
}

