package fsg.widgets
{
   import fsg.shared.ComboBoxDropDownMenu;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2062")]
   public dynamic class fsgComboBoxDropDownMenuImage extends ComboBoxDropDownMenu
   {
      
      public function fsgComboBoxDropDownMenuImage()
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

