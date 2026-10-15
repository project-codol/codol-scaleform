package codo.views.uitour
{
   import codo.component.Button;
   import codo.component.TextField;
   import codo.component.tutorial.AnimatedArrow;
   import codo.component.tutorial.UITourOverlayFrame;
   import codo.style.TutorialGuide;
   import codo.utils.LocalizeUtil;
   import codo.utils.SoundUtil;
   import com.greensock.TimelineLite;
   import com.greensock.TweenLite;
   import com.greensock.easing.Cubic;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class UITutorialTourBase extends MovieClip
   {
      
      public static const ARROW_BASE_HEIGHT:uint = 130;
      
      public static const CONTENT_PADDING:uint = 10;
      
      protected static const TEXT_BOX_DEFAULT_WIDTH:uint = 500;
      
      protected static const TUTORIAL_FRAME_FIRST:uint = 1;
      
      protected static const TUTORIAL_FRAME_SECOND:uint = 2;
      
      protected static const TUTORIAL_FRAME_THIRD:uint = 3;
      
      protected static const TUTORIAL_FRAME_FOURTH:uint = 4;
      
      protected static const TEXT_BOX_WITH_DESCRIPTION_WIDTH:uint = 650;
      
      protected static var OVERLAY_GLOW_SPEED:Number = 2;
      
      public var myTopicArrow:AnimatedArrow;
      
      public var myFrame:UITourOverlayFrame;
      
      public var myTitleTF:TextField;
      
      public var myDescriptionTF:TextField;
      
      public var myCallToActionButton:Button;
      
      public var myBlocker:Sprite;
      
      public var myOverlay:MovieClip;
      
      public var myOverlayGlow:Sprite;
      
      protected var mTransitionTimeline:TimelineLite;
      
      private var mOnTitleExternalCallback:Function;
      
      public function UITutorialTourBase()
      {
         super();
         this.myTitleTF.textStyle = TutorialGuide.styleTextTitle;
         if(this.myBlocker != null)
         {
            this.blockInput(true);
         }
         if(this.myTopicArrow != null)
         {
            this.useArrowPointer();
         }
         if(this.myOverlayGlow != null)
         {
            this.myOverlayGlow.mouseEnabled = false;
         }
         if(this.myDescriptionTF != null)
         {
            this.myDescriptionTF.myTextClip.textColor = TutorialGuide.DESCRIPTION_TEXT_COLOR;
         }
         if(this.myFrame != null)
         {
            this.myFrame.mouseChildren = this.myFrame.mouseEnabled = false;
         }
      }
      
      public function playSound(soundAlias:String) : void
      {
         SoundUtil.getInstance().playSound(soundAlias);
      }
      
      public function stopSound() : void
      {
         SoundUtil.getInstance().stopSound();
      }
      
      public function show() : void
      {
         this.mTransitionTimeline = new TimelineLite();
         visible = true;
         this.showHideAll(true);
         this.myTitleTF.alpha = 0;
         if(this.myDescriptionTF != null)
         {
            this.myDescriptionTF.alpha = 0;
         }
         if(this.myCallToActionButton != null)
         {
            this.myCallToActionButton.alpha = 0;
         }
         this.initAnimation();
      }
      
      protected function initAnimation() : void
      {
         if(this.myTopicArrow == null)
         {
            return;
         }
         this.myTopicArrow.animationStartCallback = this.revealText;
         this.myTopicArrow.animationCompleteCallback = this.onArrowRevealed;
         this.myTopicArrow.active();
      }
      
      protected function revealText() : void
      {
         this.mTransitionTimeline.append(new TweenLite(this.myTitleTF,0.2,{
            "alpha":1,
            "ease":Cubic.easeOut,
            "onComplete":this.onTitleRevealed
         }));
         if(this.myDescriptionTF != null)
         {
            this.mTransitionTimeline.append(new TweenLite(this.myDescriptionTF,0.4,{
               "alpha":0.8,
               "ease":Cubic.easeOut,
               "onComplete":this.onDescriptionRevealed
            }));
         }
         if(this.myCallToActionButton != null && this.shouldAnimateCallToAction)
         {
            this.mTransitionTimeline.append(new TweenLite(this.myCallToActionButton,0.4,{
               "alpha":this.callToActionInitialAlpha,
               "ease":Cubic.easeOut,
               "onComplete":this.onCalltoActionRevealed
            }));
         }
         this.appendAddionalAnimations();
         this.mTransitionTimeline.play();
      }
      
      protected function get shouldAnimateCallToAction() : Boolean
      {
         return true;
      }
      
      protected function get callToActionInitialAlpha() : Number
      {
         return 1;
      }
      
      protected function appendAddionalAnimations() : void
      {
      }
      
      protected function animateOverlayGlowIn() : void
      {
         if(this.myOverlayGlow == null)
         {
            return;
         }
         TweenLite.to(this.myOverlayGlow,OVERLAY_GLOW_SPEED,{
            "alpha":1,
            "ease":Cubic.easeOut
         });
      }
      
      public function set externalTitleRevealCallback(callback:Function) : void
      {
         this.mOnTitleExternalCallback = callback;
      }
      
      protected function onTitleRevealed() : void
      {
         if(this.mOnTitleExternalCallback != null)
         {
            this.mOnTitleExternalCallback();
         }
      }
      
      protected function onDescriptionRevealed() : void
      {
      }
      
      protected function onCalltoActionRevealed() : void
      {
      }
      
      protected function onArrowRevealed() : void
      {
      }
      
      public function hide() : void
      {
         visible = false;
         this.showHideAll(false);
         if(this.mTransitionTimeline != null)
         {
            this.mTransitionTimeline = null;
         }
         if(this.myTopicArrow != null)
         {
            this.myTopicArrow.deactive();
         }
      }
      
      public function set title(txt:String) : void
      {
         this.myTitleTF.text = LocalizeUtil.localize(txt).toUpperCase();
         this.myTitleTF.visible = true;
      }
      
      public function useArrowPointer() : void
      {
         this.myTopicArrow.visible = true;
         this.myTopicArrow.mouseEnabled = false;
      }
      
      public function set description(txt:String) : void
      {
         this.myDescriptionTF.text = txt;
         this.myDescriptionTF.visible = true;
      }
      
      public function registerCallToActionEvent(callback:Function, data:* = null) : void
      {
         this.myCallToActionButton.setClickCallback(callback,data,true);
         this.myCallToActionButton.visible = true;
      }
      
      public function blockInput(doBlockInput:Boolean) : void
      {
         this.myBlocker.visible = this.myBlocker.mouseEnabled = doBlockInput;
      }
      
      protected function showHideAll(doShow:Boolean) : void
      {
         var asset:* = undefined;
         for each(asset in this)
         {
            if(asset is DisplayObject)
            {
               asset.visible = doShow;
            }
         }
      }
   }
}

