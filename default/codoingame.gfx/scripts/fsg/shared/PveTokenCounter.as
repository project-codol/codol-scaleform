package fsg.shared
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import fsg.util.FsgUtil;
   
   public class PveTokenCounter extends MovieClip
   {
      
      public var myTextTF:TextField;
      
      public function PveTokenCounter()
      {
         super();
      }
      
      public function updateCount(tokenAmount:uint) : int
      {
         var shiftOffset:int = this.myTextTF.x;
         tokenAmount = FsgUtil.clamp(tokenAmount,0,999);
         this.myTextTF.text = "x" + String(tokenAmount);
         var newX:int = this.myTextTF.x;
         return int(shiftOffset - newX);
      }
      
      override public function get width() : Number
      {
         return this.myTextTF.textWidth * scaleX;
      }
   }
}

