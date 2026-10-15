package codo.views.uitour
{
   import codo.component.TextField;
   import codo.constants.GameInfo;
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   import codo.utils.LocalizeUtil;
   import codo.utils.ScaleformUtil;
   import codo.views.uitour.ingame.UITourInGameGhostImage;
   import codo.views.uitour.ingame.UITourInGameSharedObjectiveWindow;
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import com.greensock.easing.Cubic;
   import com.greensock.easing.Elastic;
   import com.greensock.easing.Linear;
   import com.greensock.text.SplitTextField;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.text.TextFieldAutoSize;
   import fsg.shared.InputIconUtility;
   
   public class UIInGameTutorialBase extends UITutorialTourBase
   {
      
      protected static const FRAME_WIDTH:uint = 405;
      
      private static const ICON_AREA:uint = 86;
      
      private static const GHOST_FADE_OUT_DELAY:uint = 5;
      
      private static const LABEL_TARGET_Y:uint = 278;
      
      public var myIcon:InputIconUtility;
      
      public var myBlankKey:Sprite;
      
      public var myGhostImage:UITourInGameGhostImage;
      
      public var myObjectiveWindow:UITourInGameSharedObjectiveWindow;
      
      public var myRevealMask:Sprite;
      
      public var myHeader:TextField;
      
      private var mForceOpenObjectiveWindow:Boolean = false;
      
      private var mIsInitMissionStep:Boolean = false;
      
      private var mDoObjectiveWindowBypass:Boolean = false;
      
      private var mSplitField:SplitTextField;
      
      private var mTxtCounter:int = 0;
      
      public function UIInGameTutorialBase()
      {
         super();
         var style:TextStyle = myTitleTF.textStyle;
         style.alignment = TextStyle.HALIGN_CENTER;
         style.fontSize = 22;
         style.font = GlobalGuide.FONT_FACE_MEDIUM;
         myTitleTF.textStyle = style;
         myTitleTF.width = 372;
         myTitleTF.filters = this.myHeader.filters;
         if(null != this.myBlankKey)
         {
            this.myBlankKey.visible = false;
         }
         var anchor:Point = GameInfo.getStageCoordForAnchorAndOffset(GameInfo.TOP_LEFT,new Point(0,LABEL_TARGET_Y));
         this.myObjectiveWindow.x = anchor.x;
         this.myObjectiveWindow.y = anchor.y;
         this.myRevealMask.width = 1;
         this.myHeader.font = GlobalGuide.FONT_FACE_BOLD;
         this.myHeader.autoSize = TextFieldAutoSize.LEFT;
         this.myHeader.fontSize = 40;
         this.myHeader.width = 300;
         this.myHeader.height = 56;
         this.myHeader.text = LocalizeUtil.localize("@UI_TUTORIAL_ONBOARDING_INGAME_INCOMING");
         if(!ScaleformUtil.isScaleform)
         {
            this.title = "BE SURE TO DO SOMETHING WITH YOUR LIFE";
            super.show();
         }
      }
      
      override public function show() : void
      {
         super.show();
         this.myIcon.alpha = 0;
      }
      
      public function set forceOpenObjectiveWindow(open:Boolean) : void
      {
         this.mForceOpenObjectiveWindow = open;
      }
      
      public function set byPassGhostAnimation(bypass:Boolean) : void
      {
         this.myGhostImage.byPassAnimation = bypass;
      }
      
      override public function set title(txt:String) : void
      {
         super.title = txt;
         if(!this.mDoObjectiveWindowBypass)
         {
            this.myObjectiveWindow.objective = txt;
         }
      }
      
      override protected function initAnimation() : void
      {
         var frameHeight:Number = 0;
         if(myTitleTF.text != "" && myTitleTF.visible)
         {
            frameHeight += myTitleTF.textHeight + 22;
         }
         if(this.myIcon.visible)
         {
            if(myTitleTF.text.length > 0)
            {
               this.myIcon.y = myTitleTF.y + myTitleTF.textHeight + 38;
            }
            else
            {
               this.myIcon.y = myFrame.y + myFrame.height * 0.5 - 20;
            }
            this.myBlankKey.y = this.myIcon.y - this.myIcon.height;
            frameHeight += this.myIcon.height;
         }
         frameHeight = Math.max(frameHeight,89);
         myFrame.height = frameHeight;
         this.myObjectiveWindow.deactive();
         this.visible = true;
         this.alpha = 1;
         this.resetTyper();
         this.myHeader.alpha = 1;
         this.mSplitField = new SplitTextField(this.myHeader.myTextClip);
         TweenMax.allFrom(this.mSplitField.textFields,0.1,{
            "alpha":0,
            "ease":Linear.easeIn,
            "delay":0.2
         },0.05);
         TweenMax.allTo(this.mSplitField.textFields,0.1,{
            "alpha":0,
            "ease":Linear.easeOut,
            "delay":2,
            "onComplete":this.onHeaderAnimateComplete
         },0.05);
         if(this.mForceOpenObjectiveWindow)
         {
            this.onWindowHidden();
            return;
         }
         this.myGhostImage.transitionOutDelay = GHOST_FADE_OUT_DELAY;
         this.myGhostImage.active();
         if(this.mIsInitMissionStep)
         {
            this.myObjectiveWindow.active();
         }
         TweenLite.killTweensOf(this.myRevealMask);
         TweenLite.to(this.myRevealMask,0.8,{
            "width":655,
            "ease":Elastic.easeInOut,
            "onComplete":this.onRevealed,
            "delay":0.1
         });
         TweenLite.to(myTitleTF,2,{
            "alpha":1,
            "ease":Cubic.easeOut,
            "delay":0.3,
            "overwrite":1
         });
         TweenLite.to(this.myIcon,2,{
            "alpha":1,
            "ease":Cubic.easeOut,
            "delay":0.3,
            "overwrite":1
         });
      }
      
      private function resetTyper() : void
      {
         if(this.mSplitField != null)
         {
            this.myHeader.alpha = 0;
            this.mSplitField.deactivate();
            this.mSplitField.destroy();
            this.mSplitField = null;
            this.mTxtCounter = 0;
         }
      }
      
      private function onHeaderAnimateComplete() : void
      {
         if(this.mTxtCounter == this.myHeader.myTextClip.text.length - 1)
         {
            this.resetTyper();
         }
         ++this.mTxtCounter;
      }
      
      private function animateIncomingMsg() : void
      {
      }
      
      public function set isInitMission(isInitMissionStep:Boolean) : void
      {
         this.mIsInitMissionStep = isInitMissionStep;
      }
      
      public function setObjectiveWindowOverrideMsg(overrideCopy:String, overrideIcon:String = null) : void
      {
         this.mDoObjectiveWindowBypass = true;
         this.myObjectiveWindow.objective = overrideCopy;
         this.myObjectiveWindow.setKeyImageByRef(overrideIcon);
      }
      
      private function onRevealed() : void
      {
         this.mDoObjectiveWindowBypass = false;
         if(this.mIsInitMissionStep)
         {
            this.mIsInitMissionStep = false;
            return;
         }
         TweenLite.killTweensOf(this.myRevealMask);
         TweenLite.to(this.myRevealMask,0.4,{
            "width":1,
            "ease":Cubic.easeIn,
            "onComplete":this.onWindowHidden,
            "delay":GHOST_FADE_OUT_DELAY,
            "onStart":this.myGhostImage.hide
         });
      }
      
      private function onWindowHidden() : void
      {
         TweenLite.killTweensOf(this.myRevealMask);
         this.myGhostImage.deactive();
         this.myObjectiveWindow.active();
         this.myRevealMask.width = 0;
      }
      
      override public function hide() : void
      {
         super.hide();
         this.myObjectiveWindow.deactive();
         this.myGhostImage.deactive();
         this.myRevealMask.width = 0;
      }
      
      public function setIcon(key:String = null) : void
      {
         if(!this.mDoObjectiveWindowBypass)
         {
            this.myObjectiveWindow.objectiveIcon = key;
         }
         if(key == null)
         {
            this.myBlankKey.visible = this.myIcon.visible = false;
            return;
         }
         this.myIcon.visible = true;
         if(ScaleformUtil.isScaleform)
         {
            this.myBlankKey.visible = !this.myIcon.setForCommand(key,GlobalGuide.BLACK);
            myTitleTF.height = myFrame.height - ICON_AREA;
         }
      }
   }
}

