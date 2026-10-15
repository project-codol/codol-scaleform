package codo.component
{
   import codo.style.ButtonGuide;
   import codo.style.GlobalGuide;
   import codo.utils.ScaleformUtil;
   import flash.display.Sprite;
   
   public class FilterToggleButton extends Button
   {
      
      protected const BUTTON_MIN_WIDTH:int = 106;
      
      public var mySelectedBar:Sprite;
      
      public function FilterToggleButton()
      {
         super();
         myLabel.textStyle = ButtonGuide.styleFilterToggleButton;
         myLabel.height = myBackground.height;
         this.mySelectedBar.visible = false;
         mTextFocusColor = GlobalGuide.WHITE;
         mTextUnfocusColor = GlobalGuide.CODO_BLUE_LIGHT;
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
         var btnWidth:Number = this.BUTTON_MIN_WIDTH;
         myLabel.width = btnWidth;
         myHitArea.width = myBackground.width = btnWidth;
         this.mySelectedBar.x = btnWidth * 0.5;
      }
      
      public function setBar(onOrOff:Boolean) : void
      {
         this.mySelectedBar.visible = onOrOff;
         selected = onOrOff;
      }
      
      override protected function onMouseOver() : void
      {
         if(!enabled)
         {
            return;
         }
         super.onMouseOver();
      }
      
      override protected function onMouseOut() : void
      {
         if(!enabled)
         {
            return;
         }
         super.onMouseOut();
      }
      
      override public function set enabled(doEnable:Boolean) : void
      {
         if(!doEnable)
         {
            this.onMouseOver();
            super.enabled = doEnable;
         }
         else
         {
            super.enabled = doEnable;
            this.onMouseOut();
         }
      }
   }
}

