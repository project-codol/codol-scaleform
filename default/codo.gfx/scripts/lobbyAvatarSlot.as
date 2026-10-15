package
{
   import codo.component.lobby.LobbyAvatarSlot;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol4455")]
   public dynamic class lobbyAvatarSlot extends LobbyAvatarSlot
   {
      
      public function lobbyAvatarSlot()
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

