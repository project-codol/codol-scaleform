package codo.component
{
   import codo.style.GlobalGuide;
   import codo.utils.CursorUtil;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.geom.ColorTransform;
   
   public class ItemFooterButton extends Button
   {
      
      private var mIsButtonTypeToggle:Boolean;
      
      public var myIconHolder:Sprite;
      
      public function ItemFooterButton()
      {
         super();
         this.myIconHolder.visible = false;
         mTextClickColor = GlobalGuide.WHITE;
      }
      
      override public function set enabled(enabled:Boolean) : void
      {
         if(enabled != visible)
         {
            super.enabled = enabled;
            visible = enabled;
         }
      }
      
      public function set isTypeToggle(bIsToggleButton:Boolean) : void
      {
         if(!bIsToggleButton)
         {
            this.setToggled(false);
         }
         this.mIsButtonTypeToggle = bIsToggleButton;
      }
      
      public function get isTypeToggle() : Boolean
      {
         return this.mIsButtonTypeToggle;
      }
      
      public function set previewIcon(icon:DisplayObject) : void
      {
         var colorTF:ColorTransform = new ColorTransform();
         colorTF.color = GlobalGuide.BLACK;
         while(Boolean(this.myIconHolder.numChildren))
         {
            this.myIconHolder.removeChildAt(0);
         }
         this.myIconHolder.addChild(icon);
         this.myIconHolder.transform.colorTransform = colorTF;
      }
      
      override public function set height(h:Number) : void
      {
         myBackground.height = myHitArea.height = myLabel.height = h;
      }
      
      override public function set width(w:Number) : void
      {
         super.width = w;
         this.myIconHolder.x = (w - this.myIconHolder.width) * 0.5;
      }
      
      override protected function onMouseClickUp() : void
      {
         super.onMouseClickUp();
         if(this.mIsButtonTypeToggle)
         {
            this.setToggled(!toggled);
         }
      }
      
      override protected function onMouseOver() : void
      {
         if(mToggled)
         {
            return;
         }
         CursorUtil.BeginCursor(CursorUtil.CURSOR_OVER_BUTTON);
         myBackground.gotoAndStop(2);
         myLabel.fontColor = mTextFocusColor;
      }
      
      override protected function onMouseOut() : void
      {
         if(mToggled)
         {
            return;
         }
         CursorUtil.EndCursor(CursorUtil.CURSOR_OVER_BUTTON);
         myBackground.gotoAndStop(1);
         myLabel.fontColor = mTextUnfocusColor;
      }
      
      override public function setToggled(toggled:Boolean) : void
      {
         if(this.mIsButtonTypeToggle)
         {
            super.setToggled(toggled);
            if(this.myIconHolder.numChildren > 0)
            {
               this.myIconHolder.visible = toggled ? true : false;
               myLabel.visible = !this.myIconHolder.visible;
            }
         }
      }
   }
}

