package codo.views.quit_parts
{
   import codo.base.BaseSubElement;
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.component.marketplaceitem.parts.IconLock;
   import codo.cpp.UiCppOnboarding;
   import codo.localization.DictMarket;
   import codo.utils.LocalizeUtil;
   import flash.display.Sprite;
   import flash.text.TextField;
   import scaleform.gfx.TextFieldEx;
   
   public class QuitGameSummaryContentNextDrop extends BaseSubElement
   {
      
      public var myFeatureDisplay:QuitGameSummaryFeatureDisplay;
      
      public var myProgressBarFill:Sprite;
      
      public var myLockIcon:IconLock;
      
      public var myLockBkg:Sprite;
      
      public var mSupplyDropLimitTF:TextField;
      
      public function QuitGameSummaryContentNextDrop()
      {
         var dailyLimit:int = 0;
         var dailyEarned:int = 0;
         var unlockLvl:String = null;
         super();
         dailyLimit = CFunctionCommonContainer.Dvar_GetInt("scr_supply_drop_reward_daily_limit");
         var timeReqMax:int = CFunctionCommonContainer.Dvar_GetInt("scr_supply_drop_reward_time_minutes");
         dailyEarned = CFunctionContainer.AS_GetSupplyDropRewardsEarned();
         var progress:Number = CFunctionContainer.AS_GetSupplyDropRewardProgress();
         this.myFeatureDisplay.setText(DictMarket.SUPPLY_DROP_NEXT_DROP_TITLE,DictMarket.SUPPLY_DROP_TIME_TO_NEXT_DROP);
         TextFieldEx.setVerticalAlign(this.mSupplyDropLimitTF,TextFieldEx.VALIGN_CENTER);
         this.mSupplyDropLimitTF.htmlText = LocalizeUtil.param(DictMarket.SUPPLY_DROPS_DAILY_LIMIT_MSG,[dailyLimit]);
         timeReqMax = timeReqMax > 0 ? timeReqMax : 40;
         var secsToEarn:Number = (timeReqMax - timeReqMax * progress) * 60;
         this.myFeatureDisplay.setValueInSeconds(secsToEarn);
         this.myProgressBarFill.scaleX = progress;
         this.mSupplyDropLimitTF.visible = false;
         unlockLvl = CFunctionCommonContainer.GetOnboardUnlockLevel(UiCppOnboarding.FEATURE_SUPPLY_DROPS);
         if(dailyEarned >= dailyLimit)
         {
            this.myLockIcon.visible = false;
            this.myFeatureDisplay.showHideTimeDisplay(false);
            this.mSupplyDropLimitTF.visible = true;
            return;
         }
         if(CFunctionCommonContainer.SupplyDropsEnabled() && unlockLvl == null && Boolean(CFunctionCommonContainer.OnboardIntroDone()))
         {
            this.myLockIcon.visible = this.myLockBkg.visible = false;
            this.myFeatureDisplay.showHideTimeDisplay(true);
         }
         else
         {
            this.myLockIcon.visible = this.myLockBkg.visible = true;
            this.myLockIcon.setLockLevel(unlockLvl);
            this.myFeatureDisplay.showHideTimeDisplay(false);
         }
      }
   }
}

