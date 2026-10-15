package ui.tours
{
   import codo.views.uitour.UITourLoadoutSelectPick10EquipItems;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol3899")]
   public dynamic class UITourLoadoutSelectPick10EquipItems extends codo.views.uitour.UITourLoadoutSelectPick10EquipItems
   {
      
      public function UITourLoadoutSelectPick10EquipItems()
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

