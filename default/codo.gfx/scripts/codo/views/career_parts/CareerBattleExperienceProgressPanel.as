package codo.views.career_parts
{
   import codo.component.ViewPanelBase;
   import codo.constants.BCEvent;
   import codo.event.ParaEvent;
   import codo.localization.DictCareer;
   import codo.manager.EventManager;
   import codo.objects.PlayerObj;
   import codo.utils.LocalizeUtil;
   import codo.utils.TextUtil;
   import codo.utils.TimeUtil;
   import components.fsgcareermode_part.FsgCareerProgressPart;
   import flash.text.TextField;
   
   public class CareerBattleExperienceProgressPanel extends ViewPanelBase
   {
      
      public var myProgressBar:FsgCareerProgressPart;
      
      public var myStatLabel0:TextField;
      
      public var myStatLabel1:TextField;
      
      public var myStatLabel2:TextField;
      
      public var myStatLabel3:TextField;
      
      public var myStatLabel4:TextField;
      
      public var myStatLabel5:TextField;
      
      public var myStatValue0:TextField;
      
      public var myStatValue1:TextField;
      
      public var myStatValue2:TextField;
      
      public var myStatValue3:TextField;
      
      public var myStatValue4:TextField;
      
      public var myStatValue5:TextField;
      
      public var myPerformanceLabel:TextField;
      
      public var myTotalXP:TextField;
      
      public function CareerBattleExperienceProgressPanel()
      {
         super();
      }
      
      override protected function onInit() : void
      {
         super.onInit();
         this.myProgressBar.init();
         this.myProgressBar.initialiseData();
         this.myStatLabel0.text = LocalizeUtil.localize(DictCareer.CAREER_WINS);
         this.myStatLabel1.text = LocalizeUtil.localize(DictCareer.CAREER_LOSSES);
         this.myStatLabel2.text = LocalizeUtil.localize(DictCareer.CAREER_KILLS);
         this.myStatLabel3.text = LocalizeUtil.localize(DictCareer.CAREER_ASSISTS);
         this.myStatLabel4.text = LocalizeUtil.localize(DictCareer.CAREER_HEADSHOTS);
         this.myStatLabel5.text = LocalizeUtil.localize(DictCareer.CAREER_TIMEPLAYED);
         var playerData:PlayerObj = PlayerObj.getObj();
         TextUtil.replaceEnFontAndFitWidth(this.myStatValue0,playerData.careerData.wins.toString());
         TextUtil.replaceEnFontAndFitWidth(this.myStatValue1,playerData.careerData.losses.toString());
         TextUtil.replaceEnFontAndFitWidth(this.myStatValue2,playerData.careerData.kills.toString());
         TextUtil.replaceEnFontAndFitWidth(this.myStatValue3,playerData.careerData.assists.toString());
         TextUtil.replaceEnFontAndFitWidth(this.myStatValue4,playerData.careerData.headshots.toString());
         TextUtil.replaceEnFontAndFitWidth(this.myStatValue5,TimeUtil.timeToString(playerData.careerData.timePlayed));
         this.myPerformanceLabel.text = LocalizeUtil.localize("@SF_UI_CAREER_PERFORMANCE");
         this.myTotalXP.text = playerData.careerData.totalEarnedXP.toString();
      }
      
      override protected function enableData() : void
      {
         super.enableData();
         this.myProgressBar.refreshRewards();
         EventManager.getInstance().addEventListener(BCEvent.EVT_REFRESH_UI_AFTER_INVENTORY_CHANGE,this.onInventoryUpdate);
      }
      
      override protected function disableData() : void
      {
         super.disableData();
         EventManager.getInstance().removeEventListener(BCEvent.EVT_REFRESH_UI_AFTER_INVENTORY_CHANGE,this.onInventoryUpdate);
      }
      
      private function onInventoryUpdate(evt:ParaEvent) : void
      {
         this.myProgressBar.refreshRewards();
      }
   }
}

