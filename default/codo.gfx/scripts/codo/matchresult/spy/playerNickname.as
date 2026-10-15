package codo.matchresult.spy
{
   import codo.views.hudSpy.PlayerNickname;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol3496")]
   public dynamic class playerNickname extends PlayerNickname
   {
      
      public function playerNickname()
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

