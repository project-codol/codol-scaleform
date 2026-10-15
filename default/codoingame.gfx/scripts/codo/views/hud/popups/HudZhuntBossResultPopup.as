package codo.views.hud.popups
{
   import codo.constants.GameInfo;
   import codo.constants.HUDPopupComponentTypes;
   import codo.utils.ScaleformUtil;
   import codo.utils.SoundUtil;
   import codo.views.hud.HUDPopupComponent;
   import codo.views.hud.resultStats.HUDBossRewardBoard;
   import codo.views.hud.resultStats.HUDBossScoreBoard;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.text.TextField;
   
   public class HudZhuntBossResultPopup extends HUDPopupComponent
   {
      
      private static const POPUP_WIDTH:int = 1707;
      
      private static const AnimateOffset:Number = 600;
      
      private static const AnimateDur:Number = 0.5;
      
      public var myBorder:MovieClip;
      
      public var myTimer:TextField;
      
      public var myRewardBoard:HUDBossRewardBoard;
      
      public var myScoreboard:HUDBossScoreBoard;
      
      public var myLeaderboard:MovieClip;
      
      public function HudZhuntBossResultPopup()
      {
         var stageSize:Point = null;
         super();
         stageSize = new Point(1280,720);
         var stagePosition:Point = new Point(0,0);
         if(ScaleformUtil.isScaleform)
         {
            stageSize = GameInfo.stageSize;
            stagePosition = GameInfo.stagePosition;
         }
         scaleX = scaleY = stageSize.x / POPUP_WIDTH;
         x = stagePosition.x;
         y = stagePosition.y + (stageSize.y - height) * 0.5;
         mMask.x = this.myBorder.x;
         mMask.width = this.myBorder.width;
         mMask.height = this.myBorder.height = this.myBorder.width * (stageSize.y / stageSize.x);
         mMask.y = this.myBorder.y = -y / scaleY;
         mMask.alpha = 0.95;
      }
      
      override protected function showView() : void
      {
         super.showView();
         this.myRewardBoard.startAnimation(this.showScoreBoard);
         this.myTimer.visible = false;
         this.myLeaderboard.x += AnimateOffset;
         this.myScoreboard.x -= AnimateOffset;
         SoundUtil.getInstance().playSound("zh_boss_endui_appear");
      }
      
      override protected function hideView() : void
      {
         super.hideView();
         SoundUtil.getInstance().playSound("zh_boss_endui_disappear");
      }
      
      private function showScoreBoard() : void
      {
         TweenLite.to(this.myLeaderboard,AnimateDur,{"x":this.myLeaderboard.x - AnimateOffset});
         TweenLite.to(this.myScoreboard,AnimateDur,{"x":this.myScoreboard.x + AnimateOffset});
         this.myScoreboard.startAnimation();
         TweenLite.delayedCall(AnimateDur,function():void
         {
            myTimer.visible = true;
         });
      }
      
      override public function get CompType() : int
      {
         return HUDPopupComponentTypes.ZHuntBossResult;
      }
   }
}

