package codo.component
{
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   import com.greensock.TweenLite;
   import flash.display.Sprite;
   import flash.text.TextFieldAutoSize;
   
   public class TabNavigationButton extends Button
   {
      
      private static const FADE_DURATION:Number = 0.2;
      
      private static const TEXT_MARGIN:Number = 24;
      
      public var myText:TextField;
      
      public var myGlow:Sprite;
      
      public var myTab:Sprite;
      
      public function TabNavigationButton()
      {
         super();
         mTextUnfocusColor = GlobalGuide.CODO_BLUE_HIGHLIGHT;
         this.myText.autoSize = TextFieldAutoSize.CENTER;
         this.myText.alignment = TextStyle.HALIGN_CENTER;
         this.myText.alignmentVertical = TextStyle.VALIGN_MIDDLE;
         this.myText.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         this.myText.fontColor = mTextUnfocusColor;
      }
      
      override public function setToggled(toggled:Boolean) : void
      {
         mToggled = toggled;
         if(mToggled)
         {
            TweenLite.killTweensOf(this.myGlow);
            TweenLite.killTweensOf(this.myTab);
            TweenLite.to(this.myGlow,FADE_DURATION,{"alpha":1});
            TweenLite.to(this.myTab,FADE_DURATION,{"alpha":1});
            this.myText.fontColor = mTextFocusColor;
         }
         else
         {
            TweenLite.killTweensOf(this.myGlow);
            TweenLite.killTweensOf(this.myTab);
            TweenLite.to(this.myGlow,FADE_DURATION,{"alpha":0});
            TweenLite.to(this.myTab,FADE_DURATION,{"alpha":0});
            this.myText.fontColor = mTextUnfocusColor;
         }
         enabled = mClickable.isEnabled();
      }
      
      override public function set label(label:String) : void
      {
         this.myText.text = label;
         mWidth = this.myText.textWidth + TEXT_MARGIN;
         this.draw();
      }
      
      override public function get label() : String
      {
         return this.myText.text;
      }
      
      override public function draw() : void
      {
         myHitArea.width = mWidth;
         myHitArea.height = mHeight;
         this.myTab.width = this.myGlow.width = mWidth;
         this.myText.x = mWidth * 0.5;
      }
      
      override public function set width(w:Number) : void
      {
      }
      
      override public function set height(h:Number) : void
      {
      }
      
      override public function get width() : Number
      {
         return mWidth;
      }
      
      override public function get height() : Number
      {
         return mHeight;
      }
      
      override public function setData(data:*) : void
      {
         super.setData(data);
         if(null != data.label)
         {
            this.label = data.label;
         }
      }
      
      override protected function onMouseOver() : void
      {
         super.onMouseOver();
         if(!mToggled)
         {
            this.myText.fontColor = mTextFocusColor;
            TweenLite.killTweensOf(this.myGlow);
            TweenLite.killTweensOf(this.myTab);
            TweenLite.to(this.myGlow,FADE_DURATION,{"alpha":1});
            TweenLite.to(this.myTab,FADE_DURATION,{"alpha":1});
         }
      }
      
      override protected function onMouseOut() : void
      {
         super.onMouseOut();
         if(!mToggled)
         {
            this.myText.fontColor = mTextUnfocusColor;
            TweenLite.killTweensOf(this.myGlow);
            TweenLite.killTweensOf(this.myTab);
            TweenLite.to(this.myGlow,FADE_DURATION,{"alpha":0});
            TweenLite.to(this.myTab,FADE_DURATION,{"alpha":0});
         }
      }
   }
}

