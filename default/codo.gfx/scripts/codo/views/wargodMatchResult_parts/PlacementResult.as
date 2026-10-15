package codo.views.wargodMatchResult_parts
{
   import codo.localization.DictWarGod;
   import codo.objects.PlayerWarGodRank;
   import codo.utils.LocalizeUtil;
   import codo.utils.WarGodUtility;
   import codo.views.wargod_parts.DivisionMeter;
   import codo.views.wargod_parts.TierMeter;
   import flash.display.MovieClip;
   
   public class PlacementResult extends WarGodAnimateElement
   {
      
      public var myTier:TierMeter;
      
      public var myDivision:DivisionMeter;
      
      public var myText:MovieClip;
      
      public function PlacementResult()
      {
         super();
      }
      
      override public function startAni() : void
      {
         super.startAni();
         gotoAndPlay(1);
      }
      
      public function setRank(rank:PlayerWarGodRank) : void
      {
         this.myTier.setData(rank.tier);
         this.myDivision.setData(true,rank.division);
         var rankStr:String = LocalizeUtil.localize(WarGodUtility.getTierName(rank.tier)) + LocalizeUtil.localize(WarGodUtility.getDivisionName(rank.division));
         this.myText.myTF.text = LocalizeUtil.param(DictWarGod.WARGOD_PLACEMENT_RESULT,[rankStr]);
      }
   }
}

