package codo.component
{
   import codo.style.GlobalGuide;
   import flash.display.MovieClip;
   
   public class MarketplaceGridCheckBox extends CheckBox
   {
      
      private static const UP_STATE_FRAME:int = 1;
      
      private static const OVER_STATE_FRAME:int = 2;
      
      private static const DEFAULT_WIDTH:Number = 105;
      
      private static const DEFAULT_HEIGHT:Number = 30;
      
      private static const SLIDE_DURATION:Number = 0.1;
      
      private static const CHECK_OFFSET_X:Number = 4;
      
      private static const WIDTH_OFFSET:Number = 2;
      
      public var myBackground:MovieClip;
      
      public function MarketplaceGridCheckBox()
      {
         super();
         myHitArea.width = DEFAULT_WIDTH;
         myHitArea.height = DEFAULT_HEIGHT;
         this.myBackground.width = DEFAULT_WIDTH;
         this.myBackground.x = myHitArea.x = -(DEFAULT_WIDTH * 0.5) - WIDTH_OFFSET;
         myOutline.x = this.myBackground.x + GlobalGuide.COMPONENT_PADDING;
         myOutline.y = this.myBackground.y + DEFAULT_HEIGHT * 0.5 - myOutline.height * 0.5;
         myCheck.x = myOutline.x + CHECK_OFFSET_X;
         myCheck.y = myOutline.y + CHECK_OFFSET_X;
         myLabel.x = myOutline.x + myOutline.width + GlobalGuide.COMPONENT_PADDING;
      }
      
      override public function set label(label:String) : void
      {
         myLabel.text = label;
      }
      
      override public function set width(w:Number) : void
      {
         super.width = w;
         this.myBackground.width = w;
      }
      
      override protected function updateHighlightState() : void
      {
         super.updateHighlightState();
         this.myBackground.gotoAndStop(_isFocused ? OVER_STATE_FRAME : UP_STATE_FRAME);
      }
   }
}

