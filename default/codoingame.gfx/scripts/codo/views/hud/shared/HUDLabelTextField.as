package codo.views.hud.shared
{
   import codo.utils.StringUtil;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class HUDLabelTextField extends MovieClip
   {
      
      public static const LAYOUT_ALIGN_CENTER:Number = 0;
      
      public static const LAYOUT_ALIGN_LEFT:Number = 1;
      
      public var myLabel:TextField;
      
      public var myValue:TextField;
      
      private var mySpace:Number;
      
      private var myCentralX:Number;
      
      public function HUDLabelTextField()
      {
         super();
         this.mySpace = this.myValue.x - this.myLabel.x - this.myLabel.textWidth;
         this.myCentralX = (this.myLabel.x + this.myValue.x + this.myValue.textWidth) * 0.5;
      }
      
      public function tweenValueText(duration:Number, delay:Number = 0) : void
      {
         var targetValue:Number = Number(this.myValue.text);
         this.myValue.text = "0";
         if(delay > 0)
         {
            TweenLite.delayedCall(delay,StringUtil.tweenText,[this.myValue,targetValue,duration]);
         }
         else
         {
            StringUtil.tweenText(this.myValue,targetValue,duration);
         }
      }
      
      public function layoutAlign(align:Number) : void
      {
         var totalHalfWidth:Number = NaN;
         switch(align)
         {
            case LAYOUT_ALIGN_CENTER:
               totalHalfWidth = (this.myLabel.textWidth + this.mySpace + this.myValue.textWidth) * 0.5;
               this.myLabel.x = this.myCentralX - totalHalfWidth;
               this.myValue.x = this.myCentralX + totalHalfWidth - this.myValue.textWidth;
               break;
            case LAYOUT_ALIGN_LEFT:
               this.myValue.x = this.myLabel.x + this.myLabel.textWidth + this.mySpace;
               break;
            default:
               throw new Error("Unknown align type:" + align);
         }
      }
   }
}

