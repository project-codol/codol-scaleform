package codo.views
{
   import codo.base.BaseView;
   import codo.constants.BCEvent;
   import codo.constants.Common;
   import codo.constants.GameInfo;
   import codo.event.ParaEvent;
   import com.greensock.TweenLite;
   import com.greensock.easing.Linear;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.utils.getDefinitionByName;
   
   public class BackgroundView extends BaseView
   {
      
      private static const HIDE_DURATION:Number = 0.2;
      
      private static const DEFAULT_TARGET_Y_OFFSET:Number = 200;
      
      private static const SMALL_RESOLUTION_TARGET_Y_OFFSET:Number = 380;
      
      public var myLeftShape:Sprite;
      
      public var myRightCornerShape:Sprite;
      
      private var mRightShapeTargetY:Number = 200;
      
      public function BackgroundView()
      {
         super();
         listen(BCEvent.EVT_SET_UIVIEWER_MODE,this.onViewerModeChanged);
         this.myLeftShape.x = GameInfo.getStageCoordForAnchorAndOffset(GameInfo.TOP_LEFT,new Point(0,0)).x - 50;
         this.myRightCornerShape.x = GameInfo.getStageCoordForAnchorAndOffset(GameInfo.BOTTOM_RIGHT,new Point(0,0)).x + 580;
         this.myLeftShape.alpha = 0;
         this.myRightCornerShape.alpha = 0;
         this.mRightShapeTargetY = GameInfo.gameHeight < GameInfo.DEFAULT_HEIGHT ? SMALL_RESOLUTION_TARGET_Y_OFFSET : DEFAULT_TARGET_Y_OFFSET;
         this.doTransparencyBugHack();
      }
      
      private function doTransparencyBugHack() : void
      {
         var magic:MovieClip = null;
         var magicClass:Class = getDefinitionByName("codo.shared.magicBugFix") as Class;
         magic = new magicClass() as MovieClip;
         var upperLeft:Point = GameInfo.getStageCoordForAnchorAndOffset(GameInfo.TOP_LEFT,new Point(0,0));
         magic.x = upperLeft.x + 300;
         magic.y = 0;
         addChild(magic);
      }
      
      override protected function hideView() : void
      {
         super.hideView();
         this.hideShapes();
      }
      
      private function hideShapes() : void
      {
         TweenLite.to(this.myLeftShape,HIDE_DURATION,{
            "alpha":0,
            "y":-513,
            "ease":Linear.easeNone
         });
         TweenLite.to(this.myRightCornerShape,HIDE_DURATION,{
            "alpha":0,
            "y":GameInfo.gameHeight + 525,
            "ease":Linear.easeNone
         });
      }
      
      private function showShapes() : void
      {
         TweenLite.to(this.myLeftShape,HIDE_DURATION,{
            "alpha":0.8,
            "y":0,
            "ease":Linear.easeNone
         });
         TweenLite.to(this.myRightCornerShape,HIDE_DURATION,{
            "alpha":0.4,
            "y":GameInfo.gameHeight + this.mRightShapeTargetY,
            "ease":Linear.easeNone
         });
      }
      
      private function onViewerModeChanged(cEvt:ParaEvent) : void
      {
         this.showShapes();
         var mode:uint = uint(cEvt.myPara.mode);
         if(Common.UIVIEWER_MODE_TEAM == mode || Common.UIVIEWER_MODE_ONBOARDING_CHAR == mode || Common.UIVIEWER_MODE_DAILY_REWARD == mode)
         {
            this.hideShapes();
         }
         else
         {
            this.showShapes();
         }
      }
   }
}

