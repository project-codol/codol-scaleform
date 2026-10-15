package codo.views.uitour
{
   import codo.constants.GameInfo;
   import codo.localization.DictUITutorial;
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   import codo.style.TutorialGuide;
   import com.greensock.TweenLite;
   import com.greensock.easing.Linear;
   import flash.geom.Point;
   
   public class UITourAARCrateRewards extends UITutorialTourBase
   {
      
      public function UITourAARCrateRewards()
      {
         super();
      }
      
      public function showCrateRewardMission1() : void
      {
         var style:TextStyle = TutorialGuide.styleTextTitleAlignCenter;
         style.fontSize = GlobalGuide.FONT_SIZE_HUGE;
         myTitleTF.width = 1000;
         myTitleTF.textStyle = style;
         title = DictUITutorial.ONBOARDING_UI_TOUR_AAR_POST_MATCH1_REWARD_TITLE;
         var titlePoint:Point = GameInfo.getStageCoordForAnchorAndOffset(GameInfo.CENTER,new Point(-(myTitleTF.width * 0.5)));
         myTitleTF.x = titlePoint.x;
         alpha = 0;
         TweenLite.to(this,0.3,{
            "alpha":1,
            "ease":Linear.easeInOut,
            "delay":3,
            "onComplete":show
         });
      }
      
      override protected function initAnimation() : void
      {
         revealText();
      }
      
      public function showArrow() : void
      {
         myTopicArrow.active();
      }
   }
}

