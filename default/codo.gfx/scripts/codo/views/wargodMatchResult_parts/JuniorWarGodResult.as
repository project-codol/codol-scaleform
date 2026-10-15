package codo.views.wargodMatchResult_parts
{
   import codo.objects.WarGodMatchObj;
   import codo.objects.WarGodMatchResultObj;
   import codo.utils.SoundUtil;
   import codo.utils.WarGodUtility;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   
   public class JuniorWarGodResult extends WarGodAnimateElement
   {
      
      private static const BG_LOSE_FRAME:int = 1;
      
      private static const BG_WIN_FRAME:int = 2;
      
      public var myBg:MovieClip;
      
      public var myWinLabel:MovieClip;
      
      public var myLoseLabel:MovieClip;
      
      private var mCurrentLabel:MovieClip;
      
      public function JuniorWarGodResult()
      {
         super();
         this.myWinLabel.visible = false;
         this.myLoseLabel.visible = false;
         this.myBg.visible = false;
      }
      
      public function setData(data:WarGodMatchResultObj) : void
      {
         if(data.result == WarGodMatchObj.RESULT_WIN)
         {
            this.myBg.myTopBar.gotoAndStop(BG_WIN_FRAME);
            this.myBg.myBottomBar.gotoAndStop(BG_WIN_FRAME);
            this.mCurrentLabel = this.myWinLabel;
         }
         else if(data.result == WarGodMatchObj.RESULT_DRAW)
         {
            this.myBg.myTopBar.gotoAndStop(BG_WIN_FRAME);
            this.myBg.myBottomBar.gotoAndStop(BG_WIN_FRAME);
            this.mCurrentLabel = this.myWinLabel;
         }
         else if(data.result == WarGodMatchObj.RESULT_LOSE)
         {
            this.myBg.myTopBar.gotoAndStop(BG_LOSE_FRAME);
            this.myBg.myBottomBar.gotoAndStop(BG_LOSE_FRAME);
            this.mCurrentLabel = this.myLoseLabel;
         }
         else if(data.result == WarGodMatchObj.RESULT_LEAVE)
         {
            this.myBg.myTopBar.gotoAndStop(BG_LOSE_FRAME);
            this.myBg.myBottomBar.gotoAndStop(BG_LOSE_FRAME);
            this.mCurrentLabel = this.myLoseLabel;
         }
         (this.mCurrentLabel.myLabel as MovieClip).myTF.text = WarGodUtility.getLocalizedMatchResult(data.result);
      }
      
      public function setScoreDifference(value:int) : void
      {
         var prefix:String = value < 0 ? "" : "+";
         this.mCurrentLabel.myScore.myTF.text = prefix + String(value);
      }
      
      override public function startAni() : void
      {
         super.startAni();
         this.myBg.visible = true;
         this.myBg.gotoAndPlay(1);
         SoundUtil.getInstance().playSound("ui_wgmr_dropdown_menu_appear");
         TweenLite.to(this,0.3,{"onComplete":this.onBackgroundExpandedComplete});
      }
      
      override public function stopAni() : void
      {
         super.stopAni();
      }
      
      public function onBackgroundExpandedComplete() : void
      {
         this.mCurrentLabel.visible = true;
         this.mCurrentLabel.gotoAndPlay(1);
         TweenLite.to(this,1,{"onComplete":this.onAnimationComplete});
      }
      
      private function onAnimationComplete() : void
      {
         complete();
      }
   }
}

