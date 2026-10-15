package fsg.gamemodes
{
   import components.fsggamemodes_part.FsgFilterListItem;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol6034")]
   public dynamic class fsgFilterListItem extends FsgFilterListItem
   {
      
      public function fsgFilterListItem()
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

