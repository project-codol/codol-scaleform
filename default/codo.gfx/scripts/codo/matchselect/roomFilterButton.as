package codo.matchselect
{
   import codo.component.matchselect.RoomFilterButton;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol3446")]
   public dynamic class roomFilterButton extends RoomFilterButton
   {
      
      public function roomFilterButton()
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

