package components.fsggamemodes_part.tutorial
{
   import fl.motion.AdjustColor;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.filters.ColorMatrixFilter;
   import fsg.shared.BehaviourAudio;
   import fsg.shared.BehaviourClickable;
   import fsg.util.FsgImageHolder;
   
   public class GameModeTutorialContentSlide extends Sprite
   {
      
      private static const FRAME_OUT:uint = 1;
      
      private static const FRAME_OVER:uint = 2;
      
      public var myImageHolder:FsgImageHolder;
      
      public var myHitArea:MovieClip;
      
      public var myVideoHitArea:MovieClip;
      
      public var myPlayIcon:GameModeTutorialVideoControl;
      
      public var myFrame:MovieClip;
      
      public var index:uint = 0;
      
      private var mColorMatrix:ColorMatrixFilter;
      
      private var mClickable:BehaviourClickable;
      
      private var mVideoClickable:BehaviourClickable;
      
      private var mAudio:BehaviourAudio;
      
      private var mIsVideoSlide:Boolean;
      
      public function GameModeTutorialContentSlide()
      {
         super();
         this.mColorMatrix = this.buildMouseOutEffect();
         this.mClickable = new BehaviourClickable(this.myHitArea);
         this.mClickable.addMouseOverCallback(this.onMouseOver);
         this.mClickable.addMouseOutCallback(this.onMouseOut);
         this.mVideoClickable = new BehaviourClickable(this.myVideoHitArea);
         this.myVideoHitArea.visible = false;
         this.mVideoClickable.setEnabled(false);
         this.mAudio = new BehaviourAudio(this.mClickable);
         this.myImageHolder.keepWHRatio = false;
         this.filters = [this.mColorMatrix];
      }
      
      public function set thumbnailImage(imagePath:String) : void
      {
         this.myImageHolder.setImage("scaleform_ash/other/tutorials/" + imagePath);
      }
      
      public function get isVideoSlide() : Boolean
      {
         return this.mIsVideoSlide;
      }
      
      public function set isVideoSlide(isVidSlide:Boolean) : void
      {
         this.mIsVideoSlide = isVidSlide;
         if(isVidSlide)
         {
            this.myPlayIcon.enable = true;
         }
      }
      
      private function onMouseOver() : void
      {
         this.filters = [];
         this.myFrame.gotoAndStop(FRAME_OVER);
         if(this.mIsVideoSlide)
         {
            this.myPlayIcon.onMouseOver();
         }
      }
      
      private function onMouseOut() : void
      {
         this.filters = [this.mColorMatrix];
         this.myFrame.gotoAndStop(FRAME_OUT);
         if(this.mIsVideoSlide)
         {
            this.myPlayIcon.onMouseOut();
         }
      }
      
      public function set videoClickEnabled(isEnabled:Boolean) : void
      {
         this.myVideoHitArea.visible = isEnabled;
         this.mVideoClickable.setEnabled(isEnabled);
         if(!isEnabled)
         {
            this.myPlayIcon.controlType = GameModeTutorialVideoControl.ICON_FRAME_PLAY;
         }
      }
      
      public function set enabled(isEnabled:Boolean) : void
      {
         this.mClickable.setEnabled(isEnabled);
         if(isEnabled)
         {
            this.onMouseOut();
         }
         else
         {
            this.onMouseOver();
         }
      }
      
      public function set clickCallback(callBack:Function) : void
      {
         this.mClickable.addClickCallback(callBack,this.index);
         this.mClickable.addDoubleClickCallback(callBack,this.index);
      }
      
      public function set videoSlideClickCallback(callBack:Function) : void
      {
         this.mVideoClickable.addClickCallback(callBack);
         this.mVideoClickable.addDoubleClickCallback(callBack);
      }
      
      private function buildMouseOutEffect() : ColorMatrixFilter
      {
         var adjustColor:AdjustColor = new AdjustColor();
         adjustColor.brightness = 0;
         adjustColor.contrast = 0;
         adjustColor.hue = 0;
         adjustColor.saturation = -100;
         return new ColorMatrixFilter(adjustColor.CalculateFinalFlatArray());
      }
   }
}

