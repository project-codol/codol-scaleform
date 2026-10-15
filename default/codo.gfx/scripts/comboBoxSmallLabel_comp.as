package
{
   import fsg.shared.ComboBox;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol759")]
   public dynamic class comboBoxSmallLabel_comp extends ComboBox
   {
      
      public function comboBoxSmallLabel_comp()
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

