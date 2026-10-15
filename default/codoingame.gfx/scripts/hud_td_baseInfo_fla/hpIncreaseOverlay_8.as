package hud_td_baseInfo_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol4916")]
   public dynamic class hpIncreaseOverlay_8 extends MovieClip
   {
      
      public var myHealthIncreaseOverlay:MovieClip;
      
      public function hpIncreaseOverlay_8()
      {
         super();
         addFrameScript(31,this.frame32,59,this.frame60);
      }
      
      internal function frame32() : *
      {
         if(!visible)
         {
            gotoAndStop(1);
         }
      }
      
      internal function frame60() : *
      {
         if(!visible)
         {
            gotoAndStop(1);
         }
      }
   }
}

