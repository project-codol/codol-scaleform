package
{
   import codo.component.lobby.LobbyCountdownTimer;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol4541")]
   public dynamic class lobbyCountdownTimer extends LobbyCountdownTimer
   {
      
      public function lobbyCountdownTimer()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame2() : *
      {
         stop();
      }
   }
}

