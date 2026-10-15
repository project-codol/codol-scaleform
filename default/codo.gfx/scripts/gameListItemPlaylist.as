package
{
   import components.matchselect_part.MatchSelectPlaylistItem;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol499")]
   public dynamic class gameListItemPlaylist extends MatchSelectPlaylistItem
   {
      
      public function gameListItemPlaylist()
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

