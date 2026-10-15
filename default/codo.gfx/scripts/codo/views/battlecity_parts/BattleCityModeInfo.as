package codo.views.battlecity_parts
{
   import codo.component.matchselect.MatchSelectModeInfo2;
   import codo.style.MatchSelectGuide;
   
   public class BattleCityModeInfo extends MatchSelectModeInfo2
   {
      
      public function BattleCityModeInfo()
      {
         super();
      }
      
      override protected function initStage() : void
      {
         myModeName.textStyle = MatchSelectGuide.styleDetailModeName;
         myModeName.width = 390;
         myModeName.height = 36;
         myModeName.x = 553;
         myModeName.y = 18;
         myGameName.textStyle = MatchSelectGuide.styleDetailGameName;
         myGameName.width = 390;
         myGameName.height = 26;
         myGameName.x = 553;
         myGameName.y = 51;
         myModeDescription.textStyle = MatchSelectGuide.styleModeDescription;
         myModeDescription.width = 642;
         myModeDescription.height = 160;
         myModeDescription.x = 553;
         myModeDescription.y = 113;
      }
      
      override public function setModeDescription(description:String) : void
      {
         myModeDescription.text = description;
      }
   }
}

