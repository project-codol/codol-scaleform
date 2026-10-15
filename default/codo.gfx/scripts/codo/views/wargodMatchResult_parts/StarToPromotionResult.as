package codo.views.wargodMatchResult_parts
{
   import codo.localization.DictWarGod;
   import codo.objects.PlayerWarGodRank;
   import codo.utils.LocalizeUtil;
   import codo.utils.WarGodUtility;
   import codo.views.wargod_parts.TierMeter;
   import flash.display.MovieClip;
   
   public class StarToPromotionResult extends WarGodAnimateElement
   {
      
      public var myTier:TierMeter;
      
      public var myText:MovieClip;
      
      public function StarToPromotionResult()
      {
         super();
         mSoundEffect = "ui_star_match_gold_to_silver";
      }
      
      override public function startAni() : void
      {
         super.startAni();
         gotoAndPlay(1);
      }
      
      public function setRank(rank:PlayerWarGodRank) : void
      {
         this.myTier.setData(rank.tier);
         var rankStr:String = LocalizeUtil.localize(WarGodUtility.getTierName(rank.tier));
         this.myText.myTF.text = LocalizeUtil.param(DictWarGod.WARGOD_ENTER_PROMOTION,[rankStr]);
      }
   }
}

