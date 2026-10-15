package codo.component
{
   public class FilterToggleButton2 extends FilterToggleButton
   {
      
      protected const BUTTON_MARGIN:int = 20;
      
      private var mButtonWidth:int;
      
      public function FilterToggleButton2()
      {
         super();
         this.mButtonWidth = BUTTON_MIN_WIDTH + this.BUTTON_MARGIN;
      }
      
      override public function set label(label:String) : void
      {
         myLabel.text = label;
         if(myLabel.textWidth > BUTTON_MIN_WIDTH)
         {
            this.mButtonWidth = myLabel.textWidth + this.BUTTON_MARGIN;
         }
         else
         {
            this.mButtonWidth = BUTTON_MIN_WIDTH + this.BUTTON_MARGIN;
         }
         this.position();
      }
      
      override public function position() : void
      {
         super.position();
         myLabel.width = this.mButtonWidth;
         myHitArea.width = this.mButtonWidth;
         mySelectedBar.width = this.mButtonWidth;
         myLabel.x = 0;
         myHitArea.x = 0;
         mySelectedBar.x = 0;
      }
   }
}

