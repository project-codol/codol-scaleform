package codo.matchselect
{
   import codo.component.matchselect.RoomItem;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol3563")]
   public dynamic class roomItem extends RoomItem
   {
      
      public function roomItem()
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

