package codo.tours
{
   import codo.views.uitour.UITourInventoryNewUserEquipAttachment;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol4073")]
   public dynamic class UITourInventoryNewUserEquipAttachment extends codo.views.uitour.UITourInventoryNewUserEquipAttachment
   {
      
      public function UITourInventoryNewUserEquipAttachment()
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

