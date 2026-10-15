package codo.shared.career
{
   import codo.views.career_parts.CareerDailyChallengePanel;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol818")]
   public dynamic class dailyWeeklyPanel extends CareerDailyChallengePanel
   {
      
      public function dailyWeeklyPanel()
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

