package
{
   import codo.component.lobby.LobbyVoteButton;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol4289")]
   public dynamic class lobbyVoteButton extends LobbyVoteButton
   {
      
      public function lobbyVoteButton()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2,2,this.frame3,3,this.frame4);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame2() : *
      {
         stop();
      }
      
      internal function frame3() : *
      {
         stop();
      }
      
      internal function frame4() : *
      {
         stop();
      }
   }
}

