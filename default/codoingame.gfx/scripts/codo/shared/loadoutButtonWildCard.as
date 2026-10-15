package codo.shared
{
   import codo.component.loadout.LoadoutButtonWildCard;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2484")]
   public dynamic class loadoutButtonWildCard extends LoadoutButtonWildCard
   {
      
      public function loadoutButtonWildCard()
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

