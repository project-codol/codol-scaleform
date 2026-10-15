package components.ingameaar_part
{
   import codo.localization.DictInGame;
   import codo.utils.LocalizeUtil;
   import components.career_part.RecentScoreChart;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   public class AARPanelRecentMatches extends AARPanelBase
   {
      
      private static const TEXTFIELD_PADDING:uint = 2;
      
      public var myStatTitleTF:TextField;
      
      public var myStatValueTF:TextField;
      
      public var myAvgTitleTF:TextField;
      
      public var myAvgValueTF:TextField;
      
      public var myGrid:RecentScoreChart;
      
      public function AARPanelRecentMatches()
      {
         super();
         this.SetHeader(DictInGame.AAR_RECENT_MATCHES);
         this.myStatTitleTF.autoSize = this.myStatValueTF.autoSize = TextFieldAutoSize.LEFT;
         this.myAvgTitleTF.autoSize = this.myAvgValueTF.autoSize = TextFieldAutoSize.RIGHT;
         this.myStatTitleTF.text = LocalizeUtil.localize(DictInGame.AAR_RECENT_MATCH_STAT_TITLE);
         this.myStatValueTF.text = DictInGame.AAR_RECENT_MATCH_STAT_VALUE_SCORE;
         this.myAvgTitleTF.text = LocalizeUtil.localize(DictInGame.AAR_RECENT_MATCH_STAT_AVERAGE_TITLE);
         this.myStatValueTF.x = this.myStatTitleTF.x + this.myStatTitleTF.textWidth + TEXTFIELD_PADDING;
      }
      
      public function SetMatchesData(scores:Array, avgScore:int) : void
      {
         this.myGrid.data = scores;
         this.myAvgValueTF.text = String(avgScore);
         this.myAvgTitleTF.x = this.myAvgValueTF.x - (this.myAvgTitleTF.textWidth + TEXTFIELD_PADDING);
      }
   }
}

