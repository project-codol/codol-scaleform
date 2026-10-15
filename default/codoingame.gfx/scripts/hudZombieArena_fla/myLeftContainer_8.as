package hudZombieArena_fla
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2761")]
   public dynamic class myLeftContainer_8 extends MovieClip
   {
      
      public var myBackground:MovieClip;
      
      public var mySkillRewardRound:MovieClip;
      
      public var myWaveLabel:TextField;
      
      public var myZombiesLeftLabel:TextField;
      
      public function myLeftContainer_8()
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

