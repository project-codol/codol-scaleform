package codo.component
{
   import codo.style.GlobalGuide;
   import flash.display.MovieClip;
   
   public class ContentContainer extends MovieClip
   {
      
      private static const BOTTOM_TEXT_MARGIN:Number = 38;
      
      public var myContainer:MovieClip;
      
      public var myTopText:TextField;
      
      public var myBottomText:TextField;
      
      private var mWidth:Number = 0;
      
      private var mHeight:Number = 0;
      
      private var mShowText:Boolean = true;
      
      public function ContentContainer()
      {
         super();
         this.myTopText.fontSize = GlobalGuide.FONT_SIZE_MICRO;
         this.myBottomText.fontSize = GlobalGuide.FONT_SIZE_MICRO;
         this.myTopText.fontColor = GlobalGuide.CODO_BLACK;
         this.myBottomText.fontColor = GlobalGuide.CODO_BLUE_LIGHT;
         this.myBottomText.width = this.myTopText.width = this.mWidth;
         this.myContainer.width = 260;
         this.mWidth = this.myContainer.width;
         this.mHeight = this.myContainer.height;
      }
      
      public function set showAccents(show:Boolean) : void
      {
         this.myContainer.gotoAndStop(show ? 1 : 2);
      }
      
      public function showHalfAccentsLeft() : void
      {
         this.myContainer.gotoAndStop(3);
      }
      
      public function showHalfAccentsRight() : void
      {
         this.myContainer.gotoAndStop(4);
      }
      
      public function hudMode() : void
      {
         this.myContainer.gotoAndStop(5);
      }
      
      public function set showText(show:Boolean) : void
      {
         this.mShowText = show;
         this.myTopText.visible = this.mShowText;
         this.myBottomText.visible = this.mShowText;
      }
      
      override public function get width() : Number
      {
         return this.mWidth;
      }
      
      override public function set width(w:Number) : void
      {
         this.mWidth = w;
         this.draw();
      }
      
      override public function get height() : Number
      {
         return this.mHeight;
      }
      
      override public function set height(h:Number) : void
      {
         this.mHeight = h;
         this.draw();
      }
      
      private function draw() : void
      {
         this.myContainer.width = this.mWidth;
         this.myContainer.height = this.mHeight;
         if(true == this.mShowText)
         {
            this.myTopText.text = "X .00" + this.x.toString() + "   0D0" + this.y.toString();
            this.myBottomText.text = "//  " + (this.height.toString() + this.width.toString()) + "." + this.y.toString();
            this.myBottomText.y = this.mHeight - BOTTOM_TEXT_MARGIN;
         }
      }
   }
}

