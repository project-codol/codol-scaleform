package codo.shared.hud
{
   import codo.views.hudSpy.PlayerInfoBar;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol4159")]
   public dynamic class HudSpyPlayerInfoBar extends PlayerInfoBar
   {
      
      public function HudSpyPlayerInfoBar()
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

