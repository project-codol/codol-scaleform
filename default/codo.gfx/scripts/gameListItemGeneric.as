package
{
   import components.matchselect_part.MatchSelectListItem;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol503")]
   public dynamic class gameListItemGeneric extends MatchSelectListItem
   {
      
      public function gameListItemGeneric()
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

