package codo.component
{
   import codo.style.GlobalGuide;
   import flash.display.MovieClip;
   
   public class ScrollingTextField extends MovieClip
   {
      
      private static const BAR_PADDING:Number = 5;
      
      public var myScrollBar:ScrollBar;
      
      public var myMask:MovieClip;
      
      public var myText:TextField;
      
      private var mWidth:Number = 0;
      
      private var mHeight:Number = 0;
      
      public function ScrollingTextField()
      {
         super();
         this.myText.textStyle = GlobalGuide.styleTextSmall;
         this.myText.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         this.myText.wordWrap = true;
         var scrollBarSettings:Object = new Object();
         scrollBarSettings.hitArea = this;
         scrollBarSettings.scrollCallback = this.onScroll;
         this.myScrollBar.init(scrollBarSettings);
         this.myScrollBar.setPosition(0,false);
      }
      
      public function set text(s:String) : void
      {
         this.myText.text = s;
         this.refreshScrollBar();
      }
      
      public function set htmlText(s:String) : void
      {
         this.myText.htmlText = s;
         this.refreshScrollBar();
      }
      
      override public function set width(w:Number) : void
      {
         this.mWidth = w;
         var widthOffset:Number = this.myScrollBar.visible == true ? this.myScrollBar.height + BAR_PADDING : 0;
         this.myText.width = this.myMask.width = this.mWidth - widthOffset;
         this.myScrollBar.x = this.mWidth - this.myScrollBar.height + BAR_PADDING;
      }
      
      override public function get width() : Number
      {
         return this.mWidth;
      }
      
      override public function set height(h:Number) : void
      {
         this.mHeight = h;
         this.myText.height = this.mHeight;
         this.myMask.height = this.mHeight;
         this.refreshScrollBar();
      }
      
      override public function get height() : Number
      {
         return this.mHeight;
      }
      
      private function refreshScrollBar() : void
      {
         this.myScrollBar.setBarLength(this.mHeight,this.myText.textHeight);
         this.myScrollBar.setPosition(0,false);
         this.myScrollBar.visible = this.myScrollBar.enabled = this.myText.textHeight > this.mHeight;
         this.myScrollBar.setEnabled(this.myScrollBar.enabled);
         this.myText.y = 0;
      }
      
      protected function onScroll(position:Number) : void
      {
         this.myText.y = -(this.myText.textHeight - this.mHeight) * position;
      }
   }
}

