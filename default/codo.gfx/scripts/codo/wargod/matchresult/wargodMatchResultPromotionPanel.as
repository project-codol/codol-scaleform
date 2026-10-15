package codo.wargod.matchresult
{
   import codo.views.wargodMatchResult_parts.WarGodMatchResultPromotionPanel;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol3326")]
   public dynamic class wargodMatchResultPromotionPanel extends WarGodMatchResultPromotionPanel
   {
      
      public function wargodMatchResultPromotionPanel()
      {
         super();
         addFrameScript(0,this.frame1,64,this.frame65,99,this.frame100,144,this.frame145);
      }
      
      internal function frame1() : *
      {
         playDisappearSFX();
      }
      
      internal function frame65() : *
      {
         playAppearSFX();
      }
      
      internal function frame100() : *
      {
         myTierShine.gotoAndPlay(1);
      }
      
      internal function frame145() : *
      {
         stop();
         animationComplete();
      }
   }
}

