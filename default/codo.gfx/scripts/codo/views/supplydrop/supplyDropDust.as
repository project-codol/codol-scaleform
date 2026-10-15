package codo.views.supplydrop
{
   import codo.views.supplyDrop_parts.SupplyDropDust;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol3362")]
   public dynamic class supplyDropDust extends SupplyDropDust
   {
      
      public function supplyDropDust()
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

