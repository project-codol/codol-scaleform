package codo.lobby
{
   import codo.component.CloseButton;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol4539")]
   public dynamic class CloseButtonZombieChampions extends CloseButton
   {
      
      public function CloseButtonZombieChampions()
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

