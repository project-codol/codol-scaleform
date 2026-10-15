package
{
   import fsg.shared.ComboBoxDropDownMenu;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1326")]
   public dynamic class fsgComboBoxDropDownMenuNEW extends ComboBoxDropDownMenu
   {
      
      public function fsgComboBoxDropDownMenuNEW()
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

