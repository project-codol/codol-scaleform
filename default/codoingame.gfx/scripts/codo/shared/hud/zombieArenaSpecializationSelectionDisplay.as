package codo.shared.hud
{
   import codo.views.hudZombieArena.ZombieArenaSpecializationDisplay;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2793")]
   public dynamic class zombieArenaSpecializationSelectionDisplay extends ZombieArenaSpecializationDisplay
   {
      
      public function zombieArenaSpecializationSelectionDisplay()
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

