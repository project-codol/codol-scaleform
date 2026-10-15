package components.fsgpopups_part
{
   import codo.common.CFunctionCommonContainer;
   import codo.constants.BCEvent;
   import codo.constants.ItemType;
   import codo.constants.MarketMenuData;
   import codo.localization.Dict;
   import codo.localization.DictChallenge;
   import codo.localization.DictSystem;
   import codo.objects.ProductObj;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import fsg.shared.popups.PopupContentBase;
   
   public class FsgChallengeAwardViewContent extends PopupContentBase
   {
      
      public var myChallengeDescription:TextField;
      
      public var myAwardItem:MovieClip;
      
      public function FsgChallengeAwardViewContent()
      {
         super();
      }
      
      override protected function configPopUpBase() : void
      {
         myPopupBase.setSize(viewWidth,viewHeight);
         myPopupBase.configConfirmButton(DictSystem.CONFIRM,this.onClickOkay);
         myPopupBase.animateFrame = true;
         myPopupBase.headerText = DictChallenge.CHALLENGE_REWARD_BASE;
      }
      
      override public function setData(... args) : void
      {
         var obj:Object = args[0] as Object;
         var awardSkuID:int = int(obj.awardSku);
         var product:ProductObj = CFunctionCommonContainer.GetItemInfoBySku(awardSkuID);
         if(product.type == ItemType.PCT)
         {
            this.myAwardItem.myRewardName.text_txt.text = "";
            this.myAwardItem.myImageHolder.setImage("");
            this.myAwardItem.myRewardCardTitle.visible = true;
            this.myAwardItem.myRewardCardTitle.myTextTF.text = product.name;
         }
         else
         {
            this.myAwardItem.myRewardName.text_txt.text = product.name;
            this.myAwardItem.myImageHolder.setImage(product.imageURL);
            this.myAwardItem.myRewardCardTitle.visible = false;
         }
         this.myAwardItem.myRewardTitle.text_txt.text = DictChallenge.CHALLENGE_REWARD_BASE;
         myPopupBase.subheaderText = LocalizeUtil.param("@SF_UI_CAREER_AWARD_POPUP_HEADER",[LocalizeUtil.localize(obj.challengeName),LocalizeUtil.localize(product.name)]);
         this.myChallengeDescription.text = obj.challengeDesc;
         if(product.type == ItemType.WAT && product.group == MarketMenuData.SLOT_CAMO)
         {
            this.myChallengeDescription.text = this.myChallengeDescription.text + "\n\n" + LocalizeUtil.localize(Dict.CHALLENGE_AWARD_BASE_WEAPON_EXPLANATION);
         }
      }
      
      private function onClickOkay() : void
      {
         broadcast(BCEvent.GOTO_PREV_PAGE);
      }
   }
}

