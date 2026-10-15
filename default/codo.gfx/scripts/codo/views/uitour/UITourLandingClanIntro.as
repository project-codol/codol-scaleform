package codo.views.uitour
{
   import codo.component.marketplaceitem.parts.MarketplaceItemCard;
   import codo.localization.DictUITutorial;
   import codo.objects.ProductObj;
   import codo.services.TutorialService;
   import codo.style.TutorialGuide;
   import codo.utils.MarketItemUtil;
   
   public class UITourLandingClanIntro extends UITutorialTourBase
   {
      
      public var myRewardItem:MarketplaceItemCard;
      
      public function UITourLandingClanIntro()
      {
         super();
         myTitleTF.textStyle = TutorialGuide.styleTextTitle;
         myDescriptionTF.textStyle = TutorialGuide.styleTextDescriptionMedium;
         myTitleTF.width = myDescriptionTF.width = TEXT_BOX_WITH_DESCRIPTION_WIDTH;
         myDescriptionTF.y = myTitleTF.y + myTitleTF.textHeight + CONTENT_PADDING;
         myTitleTF.text = DictUITutorial.UI_TOUR_CLAN_INTRO_TITLE;
         myDescriptionTF.text = DictUITutorial.UI_TOUR_CLAN_INTRO_DESC;
         myCallToActionButton.visible = false;
         this.myRewardItem.setCardStyle(MarketItemUtil.ITEM_CARD_LARGE_FRAME,false);
         this.myRewardItem.withDiscountTag = false;
         this.myRewardItem.enabled = false;
         var prodObj:ProductObj = TutorialService.getInstance().getClanOnboardingReward();
         this.myRewardItem.setData(prodObj);
         this.myRewardItem.myInnerOutline.visible = false;
         this.myRewardItem.myOuterOutline.visible = false;
         this.myRewardItem.visible = true;
      }
   }
}

