package codo.component
{
   import codo.style.ButtonGuide;
   import codo.style.GlobalGuide;
   import codo.utils.CursorUtil;
   import codo.utils.ScaleformUtil;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class NumberButton extends Button
   {
      
      public var myBarMask:MovieClip;
      
      public var mySelectedBar:Sprite;
      
      public function NumberButton()
      {
         super();
         myLabel.textStyle = ButtonGuide.styleNumberButton;
         myLabel.height = myBackground.height;
         this.mySelectedBar.visible = false;
         mTextFocusColor = GlobalGuide.CODO_BLUE_LIGHT;
         mTextUnfocusColor = GlobalGuide.WHITE;
         if(!ScaleformUtil.isScaleform)
         {
            this.label = "43334";
         }
      }
      
      override public function set label(label:String) : void
      {
         myLabel.text = label;
         this.position();
      }
      
      public function position() : void
      {
         var BTN_PADDING:uint = 24;
         var btnWidth:Number = myLabel.textWidth + BTN_PADDING;
         myLabel.width = btnWidth;
         myHitArea.width = this.myBarMask.width = this.mySelectedBar.width = myBackground.width = btnWidth;
         this.myBarMask.x = myHitArea.x = this.mySelectedBar.x = myBackground.x;
      }
      
      override protected function onMouseOver() : void
      {
         if(!enabled)
         {
            return;
         }
         this.highlightButton(true);
         CursorUtil.BeginCursor(CursorUtil.CURSOR_OVER_BUTTON);
      }
      
      override protected function onMouseOut() : void
      {
         if(!enabled)
         {
            return;
         }
         this.highlightButton(false);
         CursorUtil.EndCursor(CursorUtil.CURSOR_OVER_BUTTON);
      }
      
      private function highlightButton(bOn:Boolean) : void
      {
         this.mySelectedBar.visible = bOn;
         if(bOn)
         {
            myLabel.fontColor = mTextFocusColor;
            this.myBarMask.play();
            myBackground.gotoAndStop(OVER_STATE_FRAME);
         }
         else
         {
            myLabel.fontColor = mTextUnfocusColor;
            this.myBarMask.gotoAndStop(0);
            myBackground.gotoAndStop(mUpStateFrame);
         }
      }
      
      override public function set enabled(doEnable:Boolean) : void
      {
         super.enabled = doEnable;
         if(!doEnable)
         {
            if(this.myBarMask.currentFrame != 22)
            {
               this.highlightButton(true);
            }
         }
         else
         {
            this.highlightButton(false);
         }
      }
   }
}

