package codo.views.playerDetailInfo_parts
{
   import codo.base.BaseSubElement;
   import codo.common.CFunctionCommonContainer;
   import codo.component.TextField;
   import codo.component.diagram.AbilityDiagram;
   import codo.component.diagram.AbilityDiagramData;
   import codo.component.diagram.CircleDiagram;
   import codo.component.diagram.CurveDiagram;
   import codo.component.diagram.CurveDiagramSetting;
   import codo.component.playerinfo_part.MostUsedWeaponSlot;
   import codo.component.playerinfo_part.StaticLoadoutIcon;
   import codo.localization.Dict;
   import codo.style.ClanGuide;
   import codo.style.GlobalGuide;
   import codo.utils.LocalizeUtil;
   import codo.utils.Logger;
   
   public class PlayerRecentInfo extends BaseSubElement
   {
      
      public static const PRIVATE_VERSION_FRAME:int = 1;
      
      public static const PUBLIC_VERSION_FRAME:int = 2;
      
      public static const KILLSTREAK_IMAGE_SCALE:Number = 1.5;
      
      public var myKDACurveLabel:TextField;
      
      public var myMostUsedKillStreak0:StaticLoadoutIcon;
      
      public var myMostUsedKillStreak1:StaticLoadoutIcon;
      
      public var myMostUsedKillStreak2:StaticLoadoutIcon;
      
      public var myMostUsedPrimaryWeapon:MostUsedWeaponSlot;
      
      public var myMostUsedSecondaryWeapon:MostUsedWeaponSlot;
      
      public var myKDALineChart:CurveDiagram;
      
      public var myWinRatePieChart:CircleDiagram;
      
      public var myWinRatePieChartLabel:TextField;
      
      public var myMostUsedLethal:StaticLoadoutIcon;
      
      public var myMostUsedTactical:StaticLoadoutIcon;
      
      public var myAbilityDiagram:AbilityDiagram;
      
      public var myMostUsedWeaponLabel:TextField;
      
      public var myMostUsedKillStreakLabel:TextField;
      
      public var myMostUsedEquipmentLabel:TextField;
      
      public var myMostPlayedModeLabel:TextField;
      
      public var myMostPlayedMode:TextField;
      
      public var myKDALabel:TextField;
      
      public var myKDA:TextField;
      
      private var mIsFullVersion:Boolean = false;
      
      public function PlayerRecentInfo()
      {
         super();
         this.initStage();
      }
      
      private function initStage() : void
      {
         this.myKDACurveLabel.textStyle = ClanGuide.stylePlayerDetailCategoryLabelStyle;
         this.myKDACurveLabel.text = Dict.PLAYER_INFO_KDA_CURVE_LABEL;
         this.myWinRatePieChartLabel.textStyle = ClanGuide.stylePlayerDetailCategoryLabel2Style;
         this.myWinRatePieChartLabel.text = Dict.PLAYER_INFO_AVG_WIN_RATE_LABEL;
         this.myWinRatePieChart.setTextType(CircleDiagram.TEXT_PERCENT);
         this.myMostUsedKillStreak0.scaleImage(KILLSTREAK_IMAGE_SCALE);
         this.myMostUsedKillStreak1.scaleImage(KILLSTREAK_IMAGE_SCALE);
         this.myMostUsedKillStreak2.scaleImage(KILLSTREAK_IMAGE_SCALE);
         this.myMostUsedWeaponLabel.textStyle = ClanGuide.stylePlayerDetailCategoryLabelStyle;
         this.myMostUsedKillStreakLabel.textStyle = ClanGuide.stylePlayerDetailCategoryLabelStyle;
         this.myMostUsedEquipmentLabel.textStyle = ClanGuide.stylePlayerDetailCategoryLabelStyle;
         this.myMostUsedWeaponLabel.text = Dict.PLAYER_INFO_MOST_USED_WEAPON_LABEL;
         this.myMostUsedKillStreakLabel.text = Dict.PLAYER_INFO_MOST_USED_KILL_STREAK_LABEL;
         this.myMostUsedEquipmentLabel.text = Dict.PLAYER_INFO_MOST_USED_KILL_EQUIPMENT_LABEL;
         this.myMostPlayedModeLabel.textStyle = ClanGuide.stylePlayerDetailLabelStyle;
         this.myMostPlayedModeLabel.text = Dict.PLAYER_INFO_RECENT_MOST_PLAYED_MODE_LABEL;
         this.myMostPlayedMode.textStyle = ClanGuide.stylePlayerDetailLabelStyle;
         this.myMostPlayedMode.fontColor = GlobalGuide.CODO_BLUE_LIGHT;
         this.myKDALabel.textStyle = ClanGuide.stylePlayerDetailLabelStyle;
         this.myKDALabel.text = Dict.PLAYER_INFO_AVG_KDA_LABEL;
         this.myKDA.textStyle = ClanGuide.stylePlayerDetailLabelNumberStyle;
         this.myKDA.fontColor = GlobalGuide.CODO_BLUE_LIGHT;
         var setting:CurveDiagramSetting = new CurveDiagramSetting();
         setting.xMinValue = 0;
         setting.xMaxValue = 10;
         setting.yMinValue = 0;
         setting.yMaxValueSet = [1,1.5,2,2.5,3,3.5,4,4.5,5,6,7,8,9,10,15,20,50,100];
         this.myKDALineChart.setting = setting;
      }
      
      public function setData(data:*) : void
      {
         if(this.mIsFullVersion)
         {
            gotoAndStop(PRIVATE_VERSION_FRAME);
            this.myKDACurveLabel.visible = true;
            this.myKDALineChart.visible = true;
            this.myKDALabel.visible = true;
            this.myKDA.visible = true;
         }
         else
         {
            gotoAndStop(PUBLIC_VERSION_FRAME);
            this.myKDACurveLabel.visible = false;
            this.myKDALineChart.visible = false;
            this.myKDALabel.visible = false;
            this.myKDA.visible = false;
         }
         var mostUsedPerks:Array = data.mostUsedPerks as Array;
         var mostUsedKillStreaks:Array = data.mostUsedKillStreaks as Array;
         if(mostUsedKillStreaks.length > 0)
         {
            this.myMostUsedKillStreak0.setData(mostUsedKillStreaks[0]);
         }
         if(mostUsedKillStreaks.length > 1)
         {
            this.myMostUsedKillStreak1.setData(mostUsedKillStreaks[1]);
         }
         if(mostUsedKillStreaks.length > 2)
         {
            this.myMostUsedKillStreak2.setData(mostUsedKillStreaks[2]);
         }
         var mostUsedPrimaryWeaponId:int = int(data.mostUsedPrimaryWeapon);
         var mostUsedPrimaryWeaponObj:Object = CFunctionCommonContainer.GetItemInfo(int(mostUsedPrimaryWeaponId));
         this.myMostUsedPrimaryWeapon.setData(mostUsedPrimaryWeaponObj);
         var mostUsedSecondaryWeaponId:int = int(data.mostUsedSecondaryWeapon);
         var mostUsedSecondaryWeaponObj:Object = CFunctionCommonContainer.GetItemInfo(int(mostUsedSecondaryWeaponId));
         this.myMostUsedSecondaryWeapon.setData(mostUsedSecondaryWeaponObj);
         this.myKDALineChart.setData(data.recentKdas.slice(20));
         var avgKda:Number = data.avgKda as Number;
         this.myKDA.text = String(avgKda.toFixed(2));
         var avgWinRatio:Number = data.avgWinRatio as Number;
         this.myWinRatePieChart.setFillAmount(avgWinRatio);
         this.myMostUsedLethal.setData(data.mostUsedGrenade);
         this.myMostUsedTactical.setData(data.mostUsedTactical);
         var abilityData:Array = [new AbilityDiagramData(data.minScoreAbility,data.maxScoreAbility,data.scoreAbility),new AbilityDiagramData(data.minKAAbility,data.maxKAAbility,data.kaAbility),new AbilityDiagramData(data.minKillstreakKillAbility,data.maxKillstreakKillAbility,data.killstreakKillAbility),new AbilityDiagramData(data.minSurvivalAbility,data.maxSurvivalAbility,data.survivalAbility),new AbilityDiagramData(data.minMotivationAbility,data.maxMotivationAbility,data.motivationAbility),new AbilityDiagramData(data.minAccuracyAbility,data.maxAccuracyAbility,data.accuracyAbility)];
         Logger.print("PlayerRecentInfo::setData:");
         Logger.print("ScoreAbility:" + int(data.scoreAbility * 1000).toString());
         Logger.print("KillAssistAbility:" + int(data.kaAbility * 1000).toString());
         Logger.print("KillstreakKillAbility:" + int(data.killstreakKillAbility * 1000).toString());
         Logger.print("SurvivalAbility:" + int(data.survivalAbility * 1000).toString());
         Logger.print("Mobility:" + int(data.motivationAbility * 1000).toString());
         Logger.print("AccuracyAbility:" + int(data.accuracyAbility * 1000).toString());
         this.myAbilityDiagram.setData(abilityData);
         var mostPlayedGameModeRef:String = data.recentMostPlayedMode as String;
         if(mostPlayedGameModeRef.length > 0)
         {
            this.myMostPlayedMode.text = LocalizeUtil.localize("@" + mostPlayedGameModeRef);
         }
         else
         {
            this.myMostPlayedMode.text = Dict.PLAYER_INFO_NOT_AVAILABLE;
         }
      }
      
      public function set IsFullVersion(isFull:Boolean) : void
      {
         this.mIsFullVersion = isFull;
      }
      
      public function get IsFullVersion() : Boolean
      {
         return this.mIsFullVersion;
      }
      
      public function resetView() : void
      {
         this.myMostUsedKillStreak0.resetView();
         this.myMostUsedKillStreak1.resetView();
         this.myMostUsedKillStreak2.resetView();
         this.myKDALineChart.setData([]);
         this.myWinRatePieChart.setFillAmount(0);
         this.myMostUsedLethal.setData(0);
         this.myMostUsedTactical.setData(0);
         this.myMostUsedPrimaryWeapon.reset();
         this.myMostUsedSecondaryWeapon.reset();
      }
      
      public function playAnimation() : void
      {
         this.myKDALineChart.playAnimation();
         this.myWinRatePieChart.playAnimation();
         this.myAbilityDiagram.playAnimation();
      }
      
      override public function active() : void
      {
         super.active();
         this.playAnimation();
      }
   }
}

