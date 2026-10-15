package codo.views
{
   import codo.base.PopupView;
   import codo.common.CFunctionCommonContainer;
   import codo.component.SliderBar;
   import codo.component.TextField;
   import codo.constants.ItemType;
   import codo.localization.Dict;
   import codo.objects.ChallengeBaseObj;
   import codo.objects.DailyChallengeObj;
   import codo.objects.ProductObj;
   import codo.objects.VetChallengeObj;
   import codo.style.GlobalGuide;
   import codo.style.MarketGuide;
   import codo.style.TextStyle;
   import codo.utils.LocalizeUtil;
   import codo.utils.MarketItemUtil;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import fsg.util.FsgImageHolder;
   
   public class ChallengeInfoPopup extends PopupView
   {
      
      private static const POPUP_WIDTH:Number = 600;
      
      private static const POPUP_HEIGHT:Number = 262;
      
      private static const MASK_HEIGHT:Number = 187;
      
      private static const REWARD_ITEM_POPUP_HEIGHT:Number = 313;
      
      private static const REWARD_ITEM_MASK_HEIGHT:Number = 294;
      
      private static const POPUP_MARGIN:Number = 40;
      
      private static const DESCRIPTION_HEIGHT:Number = 128;
      
      private static const BAR_WIDTH:Number = 517;
      
      private static const BAR_HEIGHT:Number = 21;
      
      private static const REWARD_PADDING:Number = 5;
      
      public var myChallengeProgress:SliderBar;
      
      public var myIcon:FsgImageHolder;
      
      public var myChallengeName:TextField;
      
      public var myChallengeDescription:TextField;
      
      public var myChallengeProgressLabel:TextField;
      
      public var myRewardLabel:TextField;
      
      public var myRewardValue:TextField;
      
      public var myHeader:TextField;
      
      public var myChainInstructions:TextField;
      
      public var myChainModule:MovieClip;
      
      public var myBackgroundMask:Sprite;
      
      public var myTierColor:Sprite;
      
      public var myTierColorSecondary:Sprite;
      
      public var myRewardStripe:Sprite;
      
      public var myRewardName:TextField;
      
      public var myRewardCategory:TextField;
      
      public var myRewardImage:FsgImageHolder;
      
      public function ChallengeInfoPopup()
      {
         super();
         this.myChallengeProgressLabel.fontSize = GlobalGuide.FONT_SIZE_SMALL;
         this.myChallengeProgressLabel.alignment = TextStyle.HALIGN_RIGHT;
         this.myChallengeDescription.textStyle = GlobalGuide.styleTextDescription;
         this.myChallengeName.font = GlobalGuide.FONT_FACE_BOLD;
         this.myChallengeName.fontSize = GlobalGuide.FONT_SIZE_MEDIUM;
         this.myChallengeProgress.width = BAR_WIDTH - this.myIcon.width;
         this.myChallengeProgress.height = BAR_HEIGHT;
         this.myRewardValue.width = BAR_WIDTH - this.myIcon.width;
         this.myChallengeDescription.width = this.myChallengeProgressLabel.width = this.myChallengeName.width = POPUP_WIDTH - POPUP_MARGIN - this.myIcon.width;
         this.myChallengeDescription.height = DESCRIPTION_HEIGHT;
         this.myRewardName.font = GlobalGuide.FONT_FACE_BOLD;
         this.myRewardName.width = POPUP_WIDTH;
         this.myRewardCategory.width = this.myTierColor.width;
         this.myRewardCategory.alignment = TextStyle.HALIGN_RIGHT;
         this.myRewardCategory.fontSize = GlobalGuide.FONT_SIZE_TINY;
         this.myRewardCategory.fontColor = GlobalGuide.BLACK;
         this.myRewardLabel.fontSize = GlobalGuide.FONT_SIZE_SMALL;
         this.myRewardValue.fontSize = GlobalGuide.FONT_SIZE_SMALL;
         this.myRewardLabel.text = LocalizeUtil.localize(Dict.CHALLENGE_REWARD);
         this.myRewardValue.x = this.myRewardLabel.x + this.myRewardLabel.textWidth + REWARD_PADDING;
         this.myHeader.font = GlobalGuide.FONT_FACE_BOLD;
         this.myHeader.fontSize = GlobalGuide.FONT_SIZE_LARGE;
         this.myHeader.width = POPUP_WIDTH;
         this.myHeader.height = 42;
         this.myHeader.text = LocalizeUtil.localize(Dict.CHALLENGE_INFO).toUpperCase();
         this.myChainInstructions.fontSize = GlobalGuide.FONT_SIZE_TINY;
         this.myChainInstructions.fontColor = GlobalGuide.GRAY_80;
         this.myChainInstructions.width = POPUP_WIDTH - this.myChainInstructions.x - 30;
         this.myChainInstructions.text = LocalizeUtil.localize("@SF_UI_CHAIN_CHALLENGE_INSTRUCTIONS");
         myPopup.width = POPUP_WIDTH;
         myPopup.myHeaderbar.title = "";
         myPopup.configConfirmButton(Dict.CONFIRM,this.onConfirm,true);
      }
      
      override public function set routeData(data:*) : void
      {
         var prodData:ProductObj = null;
         var tierColor:uint = 0;
         super.routeData = data;
         var challengeData:ChallengeBaseObj = data.challenge as ChallengeBaseObj;
         this.myChallengeName.text = challengeData.name;
         this.myChallengeDescription.text = LocalizeUtil.getLocalizationWithKeyBinding(challengeData.description);
         this.myIcon.setImage(challengeData.icon);
         this.myChallengeProgressLabel.text = challengeData.progress.toString() + "/" + challengeData.target.toString();
         this.myChallengeProgress.fillPercent = challengeData.progress / challengeData.target;
         this.myChallengeProgress.prepareForShow();
         this.myChallengeProgress.show(0);
         var rewardText:String = "";
         var prefix:String = "";
         if(challengeData.rewardGP > 0)
         {
            rewardText += challengeData.rewardGP + LocalizeUtil.localize(Dict.GP);
            prefix = " | ";
         }
         if(challengeData.rewardXP > 0)
         {
            rewardText += prefix + challengeData.rewardXP + LocalizeUtil.localize(Dict.XP);
         }
         this.myRewardValue.text = rewardText;
         var dailyChallenge:DailyChallengeObj = challengeData as DailyChallengeObj;
         if(dailyChallenge != null)
         {
            this.myChainInstructions.visible = true;
            if(dailyChallenge.chainBonus)
            {
               this.myChainModule.gotoAndStop(dailyChallenge.isPvp ? 2 : 3);
            }
            else
            {
               this.myChainModule.gotoAndStop(1);
            }
            this.myChainModule.visible = true;
         }
         else
         {
            this.myChainInstructions.visible = false;
            this.myChainModule.visible = false;
         }
         var vetChallenge:VetChallengeObj = challengeData as VetChallengeObj;
         if(vetChallenge != null && vetChallenge.awardSkuID > 0)
         {
            prodData = CFunctionCommonContainer.GetItemInfoBySku(int(vetChallenge.awardSkuID));
            tierColor = uint(MarketGuide.COLOR_BY_TIER[prodData.tier]);
            GlobalGuide.formatComponentsByTier(tierColor,new <DisplayObject>[this.myTierColor,this.myTierColorSecondary]);
            this.myTierColorSecondary.alpha = 0.6;
            if(prodData.type != ItemType.PCT)
            {
               this.myRewardImage.setImage(prodData.imageURL);
               this.myRewardImage.visible = true;
            }
            else
            {
               this.myRewardImage.visible = false;
            }
            this.myRewardName.text = prodData.name;
            this.myRewardCategory.text = LocalizeUtil.localize(MarketItemUtil.ITEM_TIER_LABELS[prodData.tier]).toUpperCase() + " " + LocalizeUtil.localize(MarketItemUtil.GET_ITEM_CATEGORY_BY_GROUP(prodData.group));
            this.myRewardStripe.visible = this.myRewardImage.visible = this.myRewardName.visible = this.myRewardCategory.visible = this.myTierColorSecondary.visible = this.myTierColor.visible = true;
            this.myBackgroundMask.height = REWARD_ITEM_MASK_HEIGHT;
            myPopup.height = REWARD_ITEM_POPUP_HEIGHT;
         }
         else
         {
            this.myRewardStripe.visible = this.myRewardImage.visible = this.myRewardName.visible = this.myRewardCategory.visible = this.myTierColorSecondary.visible = this.myTierColor.visible = false;
            this.myBackgroundMask.height = MASK_HEIGHT;
            myPopup.height = POPUP_HEIGHT;
         }
      }
      
      private function onConfirm() : void
      {
         closePopupView();
      }
   }
}

