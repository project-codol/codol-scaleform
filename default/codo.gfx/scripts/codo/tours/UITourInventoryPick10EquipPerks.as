package codo.tours
{
   import codo.views.uitour.UITourInventoryPick10EquipPerks;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol4112")]
   public dynamic class UITourInventoryPick10EquipPerks extends codo.views.uitour.UITourInventoryPick10EquipPerks
   {
      
      public function UITourInventoryPick10EquipPerks()
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

