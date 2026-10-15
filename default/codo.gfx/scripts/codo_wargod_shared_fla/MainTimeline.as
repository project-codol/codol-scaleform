package codo_wargod_shared_fla
{
   import codo.wargod.heroicValueMeter;
   import codo.wargod.promotionScoreMeter;
   import codo.wargod.wargodItemRewardCard;
   import flash.display.MovieClip;
   
   public dynamic class MainTimeline extends MovieClip
   {
      
      public var myHeroicValueMeter:heroicValueMeter;
      
      public var myPromotionScoreMeter:promotionScoreMeter;
      
      public var myRewardCard:wargodItemRewardCard;
      
      public function MainTimeline()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         this.myHeroicValueMeter.setData(555,555,30);
         this.myPromotionScoreMeter.playAnimation(0,200,200);
      }
   }
}

