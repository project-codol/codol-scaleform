package fsg.widgets
{
   import fsg.shared.PrimaryTab;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1193")]
   public dynamic class primaryButton extends PrimaryTab
   {
      
      public function primaryButton()
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

