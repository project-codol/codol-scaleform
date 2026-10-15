package codo.component.career
{
   import codo.common.CFunctionCommonContainer;
   import codo.component.TextField;
   import codo.localization.Dict;
   import codo.localization.DictChallenge;
   import codo.objects.WeeklyChallengeObj;
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   import fsg.util.FsgImageHolder;
   
   public class WeeklyChallengeReward extends MovieClip
   {
      
      public var myImage:FsgImageHolder;
      
      public var myRewardBonus:TextField;
      
      public var myRewardBonusLabel:TextField;
      
      public var myRewardBase:TextField;
      
      public var myRewardBaseLabel:TextField;
      
      public function WeeklyChallengeReward()
      {
         super();
         this.myRewardBonusLabel.fontSize = GlobalGuide.FONT_SIZE_TINY;
         this.myRewardBaseLabel.fontSize = GlobalGuide.FONT_SIZE_TINY;
         this.myRewardBonus.alignment = this.myRewardBase.alignment = this.myRewardBaseLabel.alignment = this.myRewardBonusLabel.alignment = TextStyle.HALIGN_CENTER;
         this.myRewardBonus.fontColor = this.myRewardBonusLabel.fontColor = GlobalGuide.CODO_YELLOW;
         this.myRewardBonus.font = this.myRewardBase.font = GlobalGuide.FONT_FACE_NUMBERS;
         this.myRewardBonus.width = this.myRewardBase.width = this.myRewardBaseLabel.width = this.myRewardBonusLabel.width = 80;
         this.myRewardBonus.height = this.myRewardBase.height = 50;
         this.myRewardBaseLabel.text = LocalizeUtil.localize(DictChallenge.CHALLENGES_REWARD_BASE);
         this.myRewardBonusLabel.text = LocalizeUtil.localize(DictChallenge.CHALLENGES_REWARD_BONUS);
         this.myImage.setImage("supply_drop_basic_item_icon");
      }
      
      public function setData(challenges:Vector.<WeeklyChallengeObj>) : void
      {
         var xpBase:int = 0;
         var gpBase:int = 0;
         for(var i:int = 0; i < challenges.length; i++)
         {
            xpBase += challenges[i].rewardXP;
            gpBase += challenges[i].rewardGP;
         }
         this.myRewardBase.text = xpBase + LocalizeUtil.localize(Dict.XP) + "\n";
         this.myRewardBase.text += gpBase + LocalizeUtil.localize(Dict.GP);
         var bonus:Object = CFunctionCommonContainer.GetWeeklyChallengeBonus();
         this.myRewardBonus.text = bonus.xp + LocalizeUtil.localize(Dict.XP) + "\n";
         this.myRewardBonus.text += bonus.gp + LocalizeUtil.localize(Dict.GP);
      }
   }
}

