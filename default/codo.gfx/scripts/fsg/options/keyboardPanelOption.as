package fsg.options
{
   import components.fsgkeyboardpanel_part.FsgKeyboardPanelOption;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol3642")]
   public dynamic class keyboardPanelOption extends FsgKeyboardPanelOption
   {
      
      public function keyboardPanelOption()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}

