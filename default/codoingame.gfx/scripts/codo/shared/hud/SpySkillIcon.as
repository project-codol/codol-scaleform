package codo.shared.hud
{
   import codo.views.hudSpy.SpySKillIcon;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol4109")]
   public dynamic class SpySkillIcon extends SpySKillIcon
   {
      
      public function SpySkillIcon()
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

