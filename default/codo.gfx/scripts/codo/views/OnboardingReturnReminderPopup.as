package codo.views
{
   import codo.base.BaseView;
   import codo.common.CFunctionCommonContainer;
   import codo.component.CallToActionButton;
   import codo.component.TextField;
   import codo.component.marketplaceitem.parts.MarketplaceItemCard;
   import codo.component.tutorial.AnimatedArrow;
   import codo.constants.BCEvent;
   import codo.localization.DictSystem;
   import codo.localization.DictUITutorial;
   import codo.objects.ProductObj;
   import codo.style.GlobalGuide;
   import codo.style.TutorialGuide;
   import codo.utils.LocalizeUtil;
   import codo.utils.MarketItemUtil;
   import com.greensock.TimelineLite;
   import com.greensock.TweenLite;
   import com.greensock.easing.Cubic;
   import flash.display.BlendMode;
   import flash.display.MovieClip;
   import flash.filters.GlowFilter;
   
   public class OnboardingReturnReminderPopup extends BaseView
   {
      
      private static var REWARD_ACR_HELLWALKER:int = 10071;
      
      private static const DESCRIPTION_WIDTH:int = 278;
      
      private static const HEADER_WIDTH:int = 500;
      
      private static const CONTENT_PADDING:uint = 10;
      
      public var myTopicArrow:AnimatedArrow;
      
      public var myTitleTF:TextField;
      
      public var myDescriptionTF:TextField;
      
      public var myOverlay:MovieClip;
      
      public var myOverlayGlow:MovieClip;
      
      public var myConfirmButton:CallToActionButton;
      
      public var myRewardItem:MarketplaceItemCard;
      
      private var mTransitionTimeline:TimelineLite;
      
      public function OnboardingReturnReminderPopup()
      {
         super();
         this.initStage();
      }
      
      private function initStage() : void
      {
         this.myTitleTF.textStyle = TutorialGuide.styleTextTitleSmall;
         var glower:GlowFilter = new GlowFilter(GlobalGuide.NAV_TEXT_BLUE);
         this.myTitleTF.filters = [glower];
         this.myTitleTF.fontSize = GlobalGuide.FONT_SIZE_HUGE;
         this.myTitleTF.width = HEADER_WIDTH;
         this.myRewardItem.setCardStyle(MarketItemUtil.ITEM_CARD_LARGE_FRAME,false);
         this.myRewardItem.withDiscountTag = false;
         this.myRewardItem.enabled = false;
         this.myRewardItem.alpha = 0;
         glower = new GlowFilter(GlobalGuide.CODO_BLACK,0.6,10,10);
         this.myDescriptionTF.filters = [glower];
         this.myDescriptionTF.textStyle = TutorialGuide.styleTextDescriptionMedium;
         this.myDescriptionTF.fontColor = GlobalGuide.CODO_BLUE_HIGHLIGHT;
         this.myDescriptionTF.width = HEADER_WIDTH;
         var item:ProductObj = CFunctionCommonContainer.GetItemInfo(REWARD_ACR_HELLWALKER);
         this.myRewardItem.setData(item);
         this.myTitleTF.text = LocalizeUtil.localize(DictUITutorial.ONBOARDING_UI_TOUR_QUIT_USER_RETURNED_TITLE);
         this.myDescriptionTF.text = LocalizeUtil.localize(DictUITutorial.ONBOARDING_UI_TOUR_QUIT_USER_RETURNED_DESCRIPTION);
         this.myConfirmButton.label = LocalizeUtil.localize(DictSystem.QUIT);
         this.myConfirmButton.registerClickEvent(this.onConfirmClicked);
         this.positionAssets();
      }
      
      override protected function showView() : void
      {
         super.showView();
         this.startAnimation();
      }
      
      private function positionAssets() : void
      {
         this.myDescriptionTF.y = this.myTitleTF.y + this.myTitleTF.textHeight + CONTENT_PADDING;
         this.myRewardItem.y = this.myDescriptionTF.y + this.myDescriptionTF.textHeight + CONTENT_PADDING * 2;
         this.myConfirmButton.y = this.myRewardItem.y + this.myRewardItem.height + CONTENT_PADDING * 2;
         this.myTopicArrow.y = this.myConfirmButton.y + this.myConfirmButton.height + CONTENT_PADDING;
      }
      
      private function startAnimation() : void
      {
         var endY:int = 0;
         this.myTitleTF.alpha = 0;
         this.myDescriptionTF.alpha = 0;
         this.myConfirmButton.alpha = 0;
         this.myOverlayGlow.blendMode = BlendMode.ADD;
         this.myOverlayGlow.mouseEnabled = false;
         this.myOverlayGlow.alpha = 0;
         this.mTransitionTimeline = new TimelineLite();
         endY = this.myTitleTF.y;
         this.myTitleTF.y = endY - CONTENT_PADDING * 2;
         this.mTransitionTimeline.append(new TweenLite(this.myTitleTF,0.2,{
            "alpha":1,
            "y":endY,
            "ease":Cubic.easeOut
         }));
         endY = this.myDescriptionTF.y;
         this.myDescriptionTF.y = endY - CONTENT_PADDING * 2;
         this.mTransitionTimeline.append(new TweenLite(this.myDescriptionTF,0.4,{
            "alpha":0.8,
            "y":endY,
            "ease":Cubic.easeOut
         }));
         this.mTransitionTimeline.append(new TweenLite(this.myRewardItem,0.3,{
            "alpha":1,
            "ease":Cubic.easeOut
         }));
         endY = this.myConfirmButton.y;
         this.myConfirmButton.y = endY - CONTENT_PADDING * 2;
         this.mTransitionTimeline.append(new TweenLite(this.myConfirmButton,0.4,{
            "alpha":1,
            "y":endY,
            "ease":Cubic.easeOut,
            "onComplete":this.myTopicArrow.active
         }));
         this.mTransitionTimeline.append(new TweenLite(this.myOverlayGlow,2,{
            "alpha":1,
            "ease":Cubic.easeOut
         }));
         this.mTransitionTimeline.play();
      }
      
      private function onConfirmClicked() : void
      {
         broadcast(BCEvent.EVT_CLOSE_POPUP_PAGE,{"pageID":_pageID});
      }
   }
}

