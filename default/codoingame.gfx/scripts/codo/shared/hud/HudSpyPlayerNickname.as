package codo.shared.hud
{
   import codo.views.hudSpy.PlayerNickname;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol4123")]
   public dynamic class HudSpyPlayerNickname extends PlayerNickname
   {
      
      public function HudSpyPlayerNickname()
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

