package codo.component.lobby
{
   [Embed(source="/_assets/assets.swf", symbol="symbol4362")]
   public dynamic class lobbyTeamJoinButton extends LobbyTeamJoinButton
   {
      
      public function lobbyTeamJoinButton()
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

