package codo.component.career
{
   import codo.component.TextField;
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class TextBubble extends MovieClip
   {
      
      public var myText:TextField;
      
      public var myBorder:Sprite;
      
      public var myBG:Sprite;
      
      public function TextBubble()
      {
         super();
         this.myText.alignment = TextStyle.HALIGN_CENTER;
         this.myText.fontColor = GlobalGuide.WHITE;
         this.myText.fontSize = 15;
         this.myText.font = GlobalGuide.FONT_FACE_MEDIUM;
      }
      
      public function get text() : String
      {
         return this.myText.text;
      }
      
      public function set text(txt:String) : void
      {
         this.myText.text = txt;
      }
      
      public function get borderVisible() : Boolean
      {
         return this.myBorder.visible;
      }
      
      public function set borderVisible(visible:Boolean) : void
      {
         this.myBorder.visible = visible;
      }
      
      override public function get width() : Number
      {
         return this.myBorder.width;
      }
   }
}

