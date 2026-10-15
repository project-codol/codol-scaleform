package codo.views
{
   import codo.base.BaseView;
   import codo.constants.BCEvent;
   import codo.constants.GameInfo;
   import codo.objects.OnboardingChecklistChallengeObj;
   import codo.style.GlobalGuide;
   import codo.style.TutorialGuide;
   import codo.views.onboarding_parts.OnboardingUIChallengeCompleteContent;
   import com.greensock.TweenLite;
   import com.greensock.easing.Linear;
   import flash.display.Shape;
   import flash.display.Sprite;
   
   public class OnboardingUIChallengeCompleteView extends BaseView
   {
      
      public var myContent:OnboardingUIChallengeCompleteContent;
      
      public var myFX:Sprite;
      
      public function OnboardingUIChallengeCompleteView()
      {
         var tst:OnboardingChecklistChallengeObj = null;
         super();
         if(isDebugMode)
         {
            tst = new OnboardingChecklistChallengeObj();
            tst.id = 591;
            tst.name = "进入【仓库】为你的背包装备一张底牌";
            this.routeData = tst;
         }
         this.myContent.onCompleteCallback = this.closePopupView;
         this.myFX.alpha = 0;
         var rectangle:Shape = new Shape();
         rectangle.graphics.beginFill(GlobalGuide.CODO_BLACK,TutorialGuide.OVERLAY_ALPHA);
         rectangle.graphics.drawRect(0,0,GameInfo.DEFAULT_WIDTH,GameInfo.DEFAULT_HEIGHT);
         rectangle.graphics.endFill();
         addChildAt(rectangle,0);
      }
      
      override public function set routeData(data:*) : void
      {
         super.routeData = data;
         var challengeData:OnboardingChecklistChallengeObj = data as OnboardingChecklistChallengeObj;
         this.myContent.setChallenge(challengeData);
      }
      
      override protected function showView() : void
      {
         super.showView();
         TweenLite.to(this.myFX,0.2,{
            "alpha":1,
            "ease":Linear.easeOut,
            "onComplete":this.myContent.animateIn
         });
      }
      
      private function closePopupView() : void
      {
         TweenLite.to(this.myFX,0.2,{
            "alpha":0,
            "ease":Linear.easeOut,
            "onComplete":this.onAnimationComplete
         });
      }
      
      protected function onAnimationComplete() : void
      {
         broadcast(BCEvent.EVT_CLOSE_POPUP_PAGE,{"pageID":_pageID});
      }
   }
}

