package codo.views.wargod_parts
{
   import codo.common.CFunctionContainer;
   import codo.component.Button;
   import codo.component.CallToActionButton;
   import codo.constants.BCEvent;
   import codo.localization.DictWarGod;
   import codo.manager.EventManager;
   import codo.objects.WarGodGlobalSettingObj;
   import codo.objects.WarGodPendingPhasePlayerObj;
   import codo.objects.WarGodPlayerObj;
   import codo.objects.WarGodSeasonObj;
   import codo.utils.LocalizeUtil;
   import codo.utils.MiscUtil;
   import codo.utils.WarGodUtility;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class SeasonRotationSelection extends MovieClip implements IWarGodUIElement
   {
      
      public var myPreviousSeasonName:TextField;
      
      public var myPreviousTierName:TextField;
      
      public var myCurrentSeasonName:TextField;
      
      public var myCurrentTierName:TextField;
      
      public var myPreviousTier:TierMeter;
      
      public var myCurrentTier:TierMeter;
      
      public var myDescription1:TextField;
      
      public var myDescription2:TextField;
      
      public var myDescription3:TextField;
      
      public var myPlacementUnfinishedTier:MovieClip;
      
      public var myInheritButton:Button;
      
      public var myPlacementButton:CallToActionButton;
      
      public function SeasonRotationSelection()
      {
         super();
         this.myInheritButton.width = 220;
         this.myInheritButton.height = 53;
         this.myInheritButton.label = DictWarGod.GIVEUP_PLACEMENT;
         this.myInheritButton.myLabel.fontSize = 24;
         this.myPlacementButton.width = 220;
         this.myPlacementButton.height = 53;
         this.myPlacementButton.label = DictWarGod.ACCEPT_PLACEMENT;
         this.myPlacementButton.myLabel.fontSize = 24;
         this.myInheritButton.registerClickEvent(this.onPickAcceptInherit);
         this.myPlacementButton.registerClickEvent(this.onPickAcceptPlacement);
      }
      
      public function setData(seasonObj:WarGodSeasonObj, playerObj:WarGodPlayerObj, globalSetting:WarGodGlobalSettingObj) : void
      {
         var previousTierName:String = null;
         var currentTierName:String = null;
         var pendingPlayerObj:WarGodPendingPhasePlayerObj = CFunctionContainer.AS_GetPendingPhasePlayerObj();
         var prevSeasonObj:WarGodSeasonObj = CFunctionContainer.AS_GetSeasonBySeasonId(seasonObj.id - 1);
         this.myPreviousSeasonName.text = prevSeasonObj.name;
         if(!pendingPlayerObj.isParticipatePreviousSeason)
         {
            this.myPreviousTier.visible = false;
            this.myPlacementUnfinishedTier.visible = true;
            previousTierName = DictWarGod.TIER_NOT_PLAY_PREVIOUS_SEASON;
         }
         else if(!pendingPlayerObj.isPlacementCompleted)
         {
            this.myPreviousTier.visible = false;
            this.myPlacementUnfinishedTier.visible = true;
            previousTierName = DictWarGod.TIER_PLACEMENT_UNFINISHED;
         }
         else
         {
            this.myPreviousTier.visible = true;
            this.myPlacementUnfinishedTier.visible = false;
            this.myPreviousTier.setData(pendingPlayerObj.warGodRank.tier);
            previousTierName = WarGodUtility.getTierAndDivisionName(pendingPlayerObj.warGodRank.tier,pendingPlayerObj.warGodRank.division);
         }
         this.myPreviousTierName.text = previousTierName;
         this.myCurrentSeasonName.text = seasonObj.name;
         this.myCurrentTier.setData(pendingPlayerObj.inheritedWarGodRank.tier);
         currentTierName = WarGodUtility.getTierAndDivisionName(pendingPlayerObj.inheritedWarGodRank.tier,pendingPlayerObj.inheritedWarGodRank.division);
         this.myCurrentTierName.text = currentTierName;
         if(!pendingPlayerObj.isDirectToWG)
         {
            this.myDescription1.text = LocalizeUtil.param(DictWarGod.SEASON_ROTATION_DESC1,[LocalizeUtil.localize(previousTierName),prevSeasonObj.name]);
            this.myDescription2.text = LocalizeUtil.param(DictWarGod.SEASON_ROTATION_DESC2,[LocalizeUtil.localize(currentTierName),seasonObj.name]);
         }
         else
         {
            this.myDescription1.text = LocalizeUtil.param(DictWarGod.SEASON_ROTATION_DESC4,[MiscUtil.getFormattedRankPrestige(globalSetting.levelPromoteWargod)]);
            this.myDescription2.text = LocalizeUtil.param(DictWarGod.SEASON_ROTATION_DESC5,[seasonObj.name]);
         }
         this.myDescription3.text = DictWarGod.SEASON_ROTATION_DESC3;
      }
      
      private function onPickAcceptInherit() : void
      {
         EventManager.getInstance().broadcast(BCEvent.EVT_NEW_SEASON_SELECT_INHERIT_SCORE);
      }
      
      private function onPickAcceptPlacement() : void
      {
         EventManager.getInstance().broadcast(BCEvent.EVT_NEW_SEASON_SELECT_PLACEMENT);
      }
   }
}

