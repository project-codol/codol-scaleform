package fsg.myComplaintViewContent
{
   import fsg.shared.ComboBoxDropDownMenu;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol4010")]
   public dynamic class fsgComboBoxDropDownMenu extends ComboBoxDropDownMenu
   {
      
      public function fsgComboBoxDropDownMenu()
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

