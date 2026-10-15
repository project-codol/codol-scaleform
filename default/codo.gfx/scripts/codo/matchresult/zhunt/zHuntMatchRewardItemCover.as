package codo.matchresult.zhunt
{
   import codo.views.zhuntMatchResult_parts.ZHuntMatchResultItem_parts.ZHuntMatchRewardItemCover;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol899")]
   public dynamic class zHuntMatchRewardItemCover extends ZHuntMatchRewardItemCover
   {
      
      public function zHuntMatchRewardItemCover()
      {
         super();
         addFrameScript(25,this.frame26);
      }
      
      internal function frame26() : *
      {
         stop();
      }
   }
}

