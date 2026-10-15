package codo.component
{
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   
   public class SupplyDropRewardDetailsButton extends Button
   {
      
      private static const DESCRIPTION_WIDTH:Number = 228;
      
      private static const DEFAULT_WIDTH:Number = 248;
      
      private static const DEFAULT_HEIGHT:Number = 150;
      
      private static const FADE_DURATION:Number = 0.2;
      
      private static const LABEL_HEIGHT:Number = 32;
      
      public var myDescription:TextField;
      
      public var myImage:MovieClip;
      
      public function SupplyDropRewardDetailsButton()
      {
         super();
         mTextFocusColor = GlobalGuide.WHITE;
         mTextUnfocusColor = GlobalGuide.WHITE;
         mTextClickColor = GlobalGuide.WHITE;
         myLabel.alignment = TextStyle.HALIGN_LEFT;
         this.myDescription.alignment = TextStyle.HALIGN_CENTER;
         this.myDescription.fontSize = GlobalGuide.FONT_SIZE_TINY;
         this.myDescription.alpha = 0;
         this.myDescription.width = DESCRIPTION_WIDTH;
         this.myDescription.height = DEFAULT_HEIGHT;
         width = DEFAULT_WIDTH;
         height = DEFAULT_HEIGHT;
      }
      
      override public function setData(data:*) : void
      {
         if(null != data)
         {
            super.setData(data);
            if(null != mData.description)
            {
               this.myDescription.text = mData.description;
               this.draw();
            }
            if(null != mData.index)
            {
               this.myImage.gotoAndStop(mData.index + 1);
            }
         }
      }
      
      override public function draw() : void
      {
         super.draw();
         myLabel.height = LABEL_HEIGHT;
         myLabel.y = myBackground.y + myBackground.height - LABEL_HEIGHT;
         this.myDescription.y = myBackground.y + myBackground.height * 0.5 - this.myDescription.textHeight * 0.5;
      }
      
      override public function get width() : Number
      {
         return myHitArea.width;
      }
      
      override public function get height() : Number
      {
         return myHitArea.height;
      }
      
      override protected function onMouseOver() : void
      {
         super.onMouseOver();
         if(!mToggled)
         {
            TweenLite.killTweensOf(this.myDescription);
            TweenLite.killTweensOf(this.myImage);
            TweenLite.to(this.myDescription,FADE_DURATION,{"alpha":1});
            TweenLite.to(this.myImage,FADE_DURATION,{"alpha":0.3});
         }
      }
      
      override protected function onMouseOut() : void
      {
         super.onMouseOut();
         if(!mToggled)
         {
            TweenLite.killTweensOf(this.myDescription);
            TweenLite.killTweensOf(this.myImage);
            TweenLite.to(this.myDescription,FADE_DURATION,{"alpha":0});
            TweenLite.to(this.myImage,FADE_DURATION,{"alpha":1});
         }
      }
      
      override protected function onMouseClickUp() : void
      {
         super.onMouseClickUp();
         if(!mToggled)
         {
            TweenLite.killTweensOf(this.myDescription);
            TweenLite.killTweensOf(this.myImage);
            if(myHitArea.hitTestPoint(stage.mouseX,stage.mouseY) == true)
            {
               TweenLite.to(this.myDescription,FADE_DURATION,{"alpha":1});
               TweenLite.to(this.myImage,FADE_DURATION,{"alpha":0.3});
            }
            else
            {
               TweenLite.to(this.myDescription,FADE_DURATION,{"alpha":0});
               TweenLite.to(this.myImage,FADE_DURATION,{"alpha":1});
            }
         }
      }
   }
}

