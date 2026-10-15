package fsg.widgets
{
   import fsg.shared.CurrencyButton;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2057")]
   public dynamic class fsgButtonCurrency extends CurrencyButton
   {
      
      public function fsgButtonCurrency()
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

