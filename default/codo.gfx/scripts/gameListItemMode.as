package
{
   import components.matchselect_part.MatchSelectListItem;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol412")]
   public dynamic class gameListItemMode extends MatchSelectListItem
   {
      
      public function gameListItemMode()
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

