package
{
   import codo.views.playerDetailInfo_parts.PlayerDetailInfoContent;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol5162")]
   public dynamic class playerDetailInfoContent extends PlayerDetailInfoContent
   {
      
      public function playerDetailInfoContent()
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

