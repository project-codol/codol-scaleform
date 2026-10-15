package codo.component.loadout
{
   import codo.component.TextField;
   import codo.style.GlobalGuide;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class LoadoutHeader extends MovieClip
   {
      
      private static const ARROW_MARGIN:uint = 3;
      
      public var myLabel:TextField;
      
      public var myArrow:Sprite;
      
      public var myBackground:Sprite;
      
      public function LoadoutHeader()
      {
         super();
         this.myLabel.fontSize = GlobalGuide.FONT_SIZE_TINY;
         this.myLabel.fontColor = GlobalGuide.CODO_BLUE_HIGHLIGHT;
      }
      
      public function set label(l:String) : void
      {
         this.myLabel.text = l.toUpperCase();
         this.myBackground.width = this.myLabel.width = this.width;
      }
      
      public function get label() : String
      {
         return this.myLabel.text;
      }
      
      override public function set width(w:Number) : void
      {
         this.myBackground.width = w;
         this.myLabel.width = w - this.myLabel.x;
         this.myArrow.x = this.myBackground.x + this.myBackground.width - this.myArrow.width - ARROW_MARGIN;
      }
      
      override public function get width() : Number
      {
         return this.myBackground.width;
      }
   }
}

