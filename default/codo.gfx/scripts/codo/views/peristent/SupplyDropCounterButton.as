package codo.views.peristent
{
   import codo.component.SupplyDropCounterButton;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol4789")]
   public dynamic class SupplyDropCounterButton extends codo.component.SupplyDropCounterButton
   {
      
      public function SupplyDropCounterButton()
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

