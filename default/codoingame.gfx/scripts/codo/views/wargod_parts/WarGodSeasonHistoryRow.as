package codo.views.wargod_parts
{
   import codo.component.TextField;
   import codo.component.core.UIInteractiveComponent;
   import codo.localization.DictWarGod;
   import codo.objects.PlayerWarGodRank;
   import codo.objects.WarGodSeasonStatsObj;
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   import codo.utils.WarGodUtility;
   import flash.display.MovieClip;
   import flash.text.TextFieldAutoSize;
   
   public class WarGodSeasonHistoryRow extends UIInteractiveComponent
   {
      
      public var myBackground:MovieClip;
      
      public var myTier:TierMeter;
      
      public var myDivision:DivisionMeter;
      
      public var mySeasonEndRankLabel:TextField;
      
      public var myNoData:TextField;
      
      public function WarGodSeasonHistoryRow()
      {
         super();
         var labelStyle:TextStyle = new TextStyle();
         labelStyle.fontSize = GlobalGuide.FONT_SIZE_MEDIUM_SMALL;
         this.mySeasonEndRankLabel.textStyle = labelStyle;
         this.mySeasonEndRankLabel.text = DictWarGod.HISTORY_SEASON_END_RANK;
         var noDataLabelStyle:TextStyle = new TextStyle();
         noDataLabelStyle.fontSize = GlobalGuide.FONT_SIZE_MEDIUM_SMALL;
         noDataLabelStyle.alignment = TextStyle.HALIGN_CENTER;
         noDataLabelStyle.autoSize = TextFieldAutoSize.NONE;
         this.myNoData.textStyle = noDataLabelStyle;
         this.myNoData.text = DictWarGod.NO_MATCH_RECORD;
         this.myNoData.width = this.width;
         this.myNoData.x = 0;
         this.myNoData.y = (this.height - this.myNoData.textHeight) / 2;
      }
      
      override public function setData(data:*) : void
      {
         var wargodRank:Object = null;
         super.setData(data);
         if(data == null)
         {
            return;
         }
         var historyData:WarGodSeasonStatsObj = data as WarGodSeasonStatsObj;
         this.switchWarGodParticipateState(historyData.seasonRank != 0);
         if(historyData.seasonRank != 0)
         {
            wargodRank = WarGodUtility.getPlayerWarGodRankByScore(historyData.score);
            this.myTier.setData(wargodRank.tier);
            if(wargodRank.tier != PlayerWarGodRank.TIER_HEROIC)
            {
               this.myDivision.setData(true,wargodRank.division);
               this.myDivision.visible = true;
            }
            else
            {
               this.myDivision.visible = false;
            }
         }
         if(historyData.seasonData.lbBestName != "")
         {
            this.mySeasonEndRankLabel.text = DictWarGod.HISTORY_SEASON_BEST_RANK;
         }
         else
         {
            this.mySeasonEndRankLabel.text = DictWarGod.HISTORY_SEASON_END_RANK;
         }
      }
      
      private function switchWarGodParticipateState(participated:Boolean) : void
      {
         this.myNoData.visible = !participated;
         this.myTier.visible = this.myDivision.visible = this.mySeasonEndRankLabel.visible = participated;
      }
      
      override public function get width() : Number
      {
         return this.myBackground.width;
      }
      
      override public function get height() : Number
      {
         return this.myBackground.height;
      }
   }
}

