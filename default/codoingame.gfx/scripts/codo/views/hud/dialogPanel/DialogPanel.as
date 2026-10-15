package codo.views.hud.dialogPanel
{
   import codo.constants.GameInfo;
   import codo.constants.HUDComponentTypes;
   import codo.utils.LocalizeUtil;
   import codo.utils.TextUtil;
   import codo.views.hud.HUDComponent;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.text.TextField;
   import fsg.util.FsgImageHolder;
   
   public class DialogPanel extends HUDComponent
   {
      
      private static const DURATION:Number = 0.5;
      
      private static const ANIMATION_STATE_HIDE:int = 0;
      
      private static const ANIMATION_STATE_SHOWING:int = 1;
      
      private static const ANIMATION_STATE_SHOW:int = 2;
      
      private static const ANIMATION_STATE_HIDING:int = 3;
      
      private static const FONT_SIZE_BIG:int = 16;
      
      private static const FONT_SIZE_SMALL:int = 12;
      
      private static const FONT_HEIGHT_BIG:int = 45;
      
      private static const FONT_HEIGHT_SMALL:int = 50;
      
      private static const TEXT_LEN_USE_BIG:int = 36;
      
      public var myPortrait:MovieClip;
      
      public var mySpeaker:TextField;
      
      public var mySubtitle:TextField;
      
      private var mShowX:Number;
      
      private var mHideX:Number;
      
      private var mState:int;
      
      private var mTween:TweenLite;
      
      public function DialogPanel()
      {
         super();
         this.mShowX = GameInfo.getStageCoordForAnchorAndOffset(GameInfo.BOTTOM_LEFT,new Point(0,-300)).x;
         this.mHideX = GameInfo.getStageCoordForAnchorAndOffset(GameInfo.BOTTOM_LEFT,new Point(-410,-300)).x;
         this.mState = ANIMATION_STATE_HIDE;
      }
      
      public function show() : void
      {
         var aniPos:Number = 0;
         var aniDur:Number = 0;
         if(this.mState == ANIMATION_STATE_SHOW)
         {
            return;
         }
         if(this.mState == ANIMATION_STATE_SHOWING)
         {
            return;
         }
         if(this.mState == ANIMATION_STATE_HIDE)
         {
            aniPos = this.mShowX;
            aniDur = DURATION;
         }
         if(this.mState == ANIMATION_STATE_HIDING)
         {
            aniPos = this.mShowX;
            aniDur = (this.mShowX - x) / (this.mShowX - this.mHideX) * DURATION;
         }
         this.mState = ANIMATION_STATE_SHOWING;
         this.playTween(aniPos,aniDur,this.onShowComplete);
      }
      
      private function onShowComplete() : void
      {
         this.mState = ANIMATION_STATE_SHOW;
      }
      
      public function hide() : void
      {
         var aniPos:Number = 0;
         var aniDur:Number = 0;
         if(this.mState == ANIMATION_STATE_HIDE)
         {
            return;
         }
         if(this.mState == ANIMATION_STATE_HIDING)
         {
            return;
         }
         if(this.mState == ANIMATION_STATE_SHOW)
         {
            aniPos = this.mHideX;
            aniDur = DURATION;
         }
         if(this.mState == ANIMATION_STATE_SHOWING)
         {
            aniPos = this.mHideX;
            aniDur = (this.mHideX - x) / (this.mHideX - this.mShowX) * DURATION;
         }
         this.mState = ANIMATION_STATE_HIDING;
         this.playTween(aniPos,aniDur,this.onHideComplete);
      }
      
      private function onHideComplete() : void
      {
         this.mState = ANIMATION_STATE_HIDE;
      }
      
      private function playTween(position:Number, duration:Number, handler:Function) : void
      {
         if(this.mTween != null)
         {
            this.mTween.kill();
         }
         this.mTween = TweenLite.to(this,duration,{
            "x":position,
            "onComplete":handler
         });
      }
      
      public function set speaker(speakerName:String) : void
      {
         this.mySpeaker.text = speakerName;
      }
      
      public function set image(url:String) : void
      {
         (this.myPortrait.myImage as FsgImageHolder).setImage(url);
      }
      
      public function set dialog(sentence:String) : void
      {
         this.mySubtitle.text = LocalizeUtil.localize(sentence);
         if(sentence.length <= TEXT_LEN_USE_BIG)
         {
            TextUtil.setFontSize(this.mySubtitle,FONT_SIZE_BIG);
            this.mySubtitle.height = FONT_HEIGHT_BIG;
         }
         else
         {
            TextUtil.setFontSize(this.mySubtitle,FONT_SIZE_SMALL);
            this.mySubtitle.height = FONT_HEIGHT_SMALL;
         }
      }
      
      override public function get CompType() : int
      {
         return HUDComponentTypes.DIALOG;
      }
   }
}

