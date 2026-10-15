package
{
   import codo.views.GameLobbyView;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol4548")]
   public dynamic class gameLobbyView extends GameLobbyView
   {
      
      public function gameLobbyView()
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

