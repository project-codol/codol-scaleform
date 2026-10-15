package fsg.widgets
{
   import fsg.shared.TextFieldTab;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1866")]
   public dynamic class textFieldTab extends TextFieldTab
   {
      
      public function textFieldTab()
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

