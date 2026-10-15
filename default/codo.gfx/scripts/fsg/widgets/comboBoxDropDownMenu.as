package fsg.widgets
{
   import fsg.shared.ComboBoxDropDownMenu;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol758")]
   public dynamic class comboBoxDropDownMenu extends ComboBoxDropDownMenu
   {
      
      public function comboBoxDropDownMenu()
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

