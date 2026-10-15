package
{
   import codo.component.lobby.LobbyItemFooterButton;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol4465")]
   public dynamic class ItemFooterButtonAdvanced extends LobbyItemFooterButton
   {
      
      public function ItemFooterButtonAdvanced()
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

