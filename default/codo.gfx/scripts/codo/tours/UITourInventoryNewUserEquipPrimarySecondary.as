package codo.tours
{
   import codo.views.uitour.UITourInventoryNewUserEquipPrimarySecondary;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol4062")]
   public dynamic class UITourInventoryNewUserEquipPrimarySecondary extends codo.views.uitour.UITourInventoryNewUserEquipPrimarySecondary
   {
      
      public function UITourInventoryNewUserEquipPrimarySecondary()
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

