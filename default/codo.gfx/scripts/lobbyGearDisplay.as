package
{
   import codo.component.lobby.LobbyGearDisplay;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol4470")]
   public dynamic class lobbyGearDisplay extends LobbyGearDisplay
   {
      
      public function lobbyGearDisplay()
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

