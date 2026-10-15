package components.ingameaar_part
{
   import components.career_part.RecentScoreChart;
   
   public class AARScoreChart extends RecentScoreChart
   {
      
      public function AARScoreChart()
      {
         super();
         this._lineSpace = 20;
         this._totalHeight = 80;
         this._lineStyleSize = 3;
         this._lineStyleColor = 12055017;
         this._posOffsetX = this._posOffsetY = 0;
      }
   }
}

