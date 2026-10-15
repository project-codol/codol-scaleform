package codo.component.home
{
   import codo.component.core.UIInteractiveComponent;
   import codo.localization.DictWarGod;
   import codo.objects.WarGodPlayerObj;
   import codo.utils.WarGodUtility;
   import codo.views.wargod_parts.TierMeter;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class WarGodShortCut extends UIInteractiveComponent
   {
      
      public var myTierIcon:TierMeter;
      
      public var myUnknownIcon:MovieClip;
      
      public var myTierName:TextField;
      
      public function WarGodShortCut()
      {
         super();
         isInteractiveEnabled = true;
      }
      
      public function setPlayerWarGodData(playerObj:WarGodPlayerObj) : void
      {
         if(playerObj.phase == WarGodPlayerObj.PHASE_PENDING || playerObj.phase == WarGodPlayerObj.PHASE_PLACEMENT)
         {
            this.myTierIcon.visible = false;
            this.myUnknownIcon.visible = true;
            this.myTierName.text = DictWarGod.TIER_UNKNOWN;
         }
         else
         {
            this.myTierIcon.visible = true;
            this.myUnknownIcon.visible = false;
            this.myTierIcon.setData(playerObj.warGodRank.tier);
            this.myTierName.text = WarGodUtility.getTierAndDivisionName(playerObj.warGodRank.tier,playerObj.warGodRank.division,false);
         }
      }
      
      override protected function onMouseOver() : void
      {
         super.onMouseOver();
         gotoAndStop("over");
      }
      
      override protected function onMouseOut() : void
      {
         super.onMouseOut();
         gotoAndStop("normal");
      }
   }
}

