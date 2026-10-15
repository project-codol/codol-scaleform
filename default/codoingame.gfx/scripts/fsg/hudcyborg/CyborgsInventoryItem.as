package fsg.hudcyborg
{
   import components.cyborg.cyborgInGame_part.CyborgObjectiveItem;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol618")]
   public dynamic class CyborgsInventoryItem extends CyborgObjectiveItem
   {
      
      public function CyborgsInventoryItem()
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

