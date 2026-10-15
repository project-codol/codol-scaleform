package codo.views.hudSpy
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   public class WarningHint extends MovieClip
   {
      
      private static const MARGIN_RIGHT:int = 25;
      
      public var myText:TextField;
      
      public var myIcon:MovieClip;
      
      public var myBG:MovieClip;
      
      public function WarningHint()
      {
         super();
         this.myText.autoSize = TextFieldAutoSize.LEFT;
      }
      
      public function setText(text:String) : void
      {
         this.myText.text = text;
         this.myBG.width = this.myText.x + this.myText.textWidth + MARGIN_RIGHT;
      }
      
      override public function get width() : Number
      {
         return this.myBG.width;
      }
   }
}

