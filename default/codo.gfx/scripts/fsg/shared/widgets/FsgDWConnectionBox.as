package fsg.shared.widgets
{
   import codo.localization.Dict;
   import codo.utils.LocalizeUtil;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import scaleform.gfx.TextFieldEx;
   
   public class FsgDWConnectionBox extends Sprite
   {
      
      public var myText:TextField;
      
      public var myIcon:Sprite;
      
      public var myBackground:Sprite;
      
      public function FsgDWConnectionBox()
      {
         super();
         this.myText.autoSize = TextFieldAutoSize.LEFT;
         TextFieldEx.setVerticalAlign(this.myText,TextFieldEx.VALIGN_CENTER);
         this.title = Dict.DW_CONTENT_UNAVAILABLE;
      }
      
      public function set title(myMsg:String) : void
      {
         this.myText.text = LocalizeUtil.localize(myMsg);
      }
      
      public function SetSize(w:int, h:int) : void
      {
         var PADDING:uint = 0;
         var offset:int = 0;
         PADDING = 15;
         offset = (this.myIcon.width + this.myText.textWidth + PADDING) * 0.5;
         this.myBackground.width = w;
         this.myBackground.height = h;
         this.myIcon.y = h * 0.5;
         this.myIcon.x = w * 0.5 - offset;
         this.myText.y = h * 0.5 - this.myText.height * 0.5;
         this.myText.x = this.myIcon.x + this.myIcon.width + PADDING;
      }
   }
}

