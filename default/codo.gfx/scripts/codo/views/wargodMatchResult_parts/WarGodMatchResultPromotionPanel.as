package codo.views.wargodMatchResult_parts
{
   import codo.component.CallToActionButton;
   import codo.localization.Dict;
   import codo.localization.DictWarGod;
   import codo.objects.PlayerWarGodRank;
   import codo.utils.LocalizeUtil;
   import codo.utils.SoundUtil;
   import codo.utils.WarGodUtility;
   import codo.views.wargod_parts.TierMeter;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class WarGodMatchResultPromotionPanel extends WarGodAnimateElement
   {
      
      public var myPromotionLabel:TextField;
      
      public var myName:TextField;
      
      public var myTierShine:MovieClip;
      
      public var myOldTier:TierMeter;
      
      public var myTier:TierMeter;
      
      public var myFragmentAnimation:MovieClip;
      
      public var myNewTierName:MovieClip;
      
      public var myNewTierNameShadow:MovieClip;
      
      public var myCongratulationLabel:MovieClip;
      
      public var myCloseButton:CallToActionButton;
      
      private var mStateChangedCallback:Function;
      
      private var mOldTier:int;
      
      private var mNewTier:int;
      
      public function WarGodMatchResultPromotionPanel()
      {
         super();
         this.myPromotionLabel.text = DictWarGod.YOU_ARE_PROMOTED_LABEL;
         this.myCloseButton.label = Dict.CONTINUE;
         this.myCloseButton.width = 136;
         this.myCloseButton.height = 57;
      }
      
      public function setUserName(userName:String) : void
      {
         this.myName.text = userName;
      }
      
      public function setOldRank(tier:int, division:int) : void
      {
         this.mOldTier = tier;
         this.myOldTier.setData(tier);
      }
      
      public function setRank(tier:int, division:int) : void
      {
         this.mNewTier = tier;
         this.myTierShine.myTierMask.setData(tier);
         this.myTier.setData(tier);
         var tierDivisionName:String = WarGodUtility.getTierAndDivisionName(tier,division);
         this.myNewTierName.myTF.text = tierDivisionName;
         this.myNewTierNameShadow.myTF.text = tierDivisionName;
         this.myCongratulationLabel.myTF.text = LocalizeUtil.param(DictWarGod.PROMOTION_CONGRATULATION,[tierDivisionName]);
         this.myCongratulationLabel.mySeniorWarGodHintTF.visible = false;
         if(tier >= PlayerWarGodRank.TIER_BRONZE)
         {
            this.myCongratulationLabel.mySeniorWarGodHintTF.visible = true;
            this.myCongratulationLabel.mySeniorWarGodHintTF.text = DictWarGod.SENIOR_PROMOTION_ADDITIONAL_SCORE_HINT;
         }
      }
      
      override public function startAni() : void
      {
         super.startAni();
         visible = true;
         gotoAndPlay(1);
         this.myFragmentAnimation.gotoAndPlay(1);
         this.mStateChangedCallback(true);
      }
      
      public function animationComplete() : void
      {
         this.myCloseButton.registerClickEvent(this.onCloseButtonClicked);
      }
      
      public function playDisappearSFX() : void
      {
         if(this.mOldTier < PlayerWarGodRank.TIER_BRONZE)
         {
            SoundUtil.getInstance().playSound("ui_wgmr_helmeticon_disappear");
         }
         else
         {
            SoundUtil.getInstance().playSound("ui_wgmr_helmet_disappear");
         }
      }
      
      public function playAppearSFX() : void
      {
         if(this.mNewTier < PlayerWarGodRank.TIER_BRONZE)
         {
            SoundUtil.getInstance().playSound("ui_wgmr_helmeticon_upgrade_appear");
         }
         else
         {
            SoundUtil.getInstance().playSound("ui_wgmr_helmet_reappear_newrank");
         }
      }
      
      public function registerStateChangeCallback(callback:Function) : void
      {
         this.mStateChangedCallback = callback;
      }
      
      private function onCloseButtonClicked() : void
      {
         visible = false;
         this.myCloseButton.unRegisterClickEvent(this.onCloseButtonClicked);
         complete();
         this.mStateChangedCallback(false);
      }
   }
}

