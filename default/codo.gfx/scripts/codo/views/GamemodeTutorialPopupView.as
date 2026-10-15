package codo.views
{
   import codo.base.PopupView;
   import codo.component.video.VideoPanel;
   import codo.constants.GameInfo;
   import codo.localization.DictSetting;
   import codo.objects.GamemodeTutorialContentObj;
   import codo.services.TutorialService;
   import codo.style.TutorialGuide;
   import codo.utils.LocalizeUtil;
   import codo.utils.ScaleformUtil;
   import com.greensock.TweenLite;
   import com.greensock.easing.Cubic;
   import components.fsggamemodes_part.tutorial.GameModeTutorialContentSlide;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.ui.Keyboard;
   import fsg.shared.BehaviourClickable;
   import fsg.shared.NavArrow;
   import fsg.util.FsgImageHolder;
   
   public class GamemodeTutorialPopupView extends PopupView
   {
      
      private static const ANIM_SPEED:Number = 0.3;
      
      private static const FRAME_OUT:uint = 1;
      
      private static const FRAME_OVER:uint = 2;
      
      private static const MAX_VISIBLE_SLIDES:uint = 7;
      
      private static const MIN:Function = Math.min;
      
      private static const POPUP_CONTENT_WIDTH:int = 1280;
      
      private var mContentData:Vector.<GamemodeTutorialContentObj>;
      
      private var mSlides:Vector.<GameModeTutorialContentSlide>;
      
      private var mSelectedSlide:GameModeTutorialContentSlide;
      
      private var mSlidesHolder:Sprite;
      
      private var mMask:Sprite;
      
      private var mCurrentScrollIndex:uint = 0;
      
      private var mCurrentSlideIndex:uint = 0;
      
      private var myProgressMarker:MovieClip;
      
      private var mProgressMarkerClickable:BehaviourClickable;
      
      private var mProgressMarkerScrollBounds:Rectangle;
      
      private var mIsScrolling:Boolean = false;
      
      private var mSlideWidth:uint = 0;
      
      private var mSlideDescY:uint = 0;
      
      public var myScroller:Sprite;
      
      public var myVideoPlayerPanel:VideoPanel;
      
      public var myHeroImage:FsgImageHolder;
      
      public var myNavArrowRight:NavArrow;
      
      public var myNavArrowLeft:NavArrow;
      
      public var mySlideTitle:TextField;
      
      public var mySlideDesc:TextField;
      
      public var mySlideTextBG:MovieClip;
      
      public function GamemodeTutorialPopupView()
      {
         super();
         if(!ScaleformUtil.isScaleform)
         {
            this.routeData = "war";
         }
         this.myProgressMarker = this.myScroller.getChildAt(0) as MovieClip;
         this.mSlidesHolder = addChild(new Sprite()) as Sprite;
         this.mMask = addChild(new Sprite()) as Sprite;
         this.mSlidesHolder.mask = this.mMask;
         myPopup.width = 1305;
         myPopup.height = 763;
         this.mSlideDescY = this.mySlideDesc.y;
         myPopup.myHeaderbar.visible = this.myScroller.visible = false;
         this.myHeroImage.x = this.myVideoPlayerPanel.x = 11;
         this.myHeroImage.y = this.myVideoPlayerPanel.y = 32;
         this.myVideoPlayerPanel.initVideoPanel(new Point(POPUP_CONTENT_WIDTH,720),TutorialGuide.OVERLAY_ALPHA,false);
         this.myVideoPlayerPanel.fullscreenOffsetPoint = new Point(309,158);
         this.myVideoPlayerPanel.useLetterBox(false);
         this.myVideoPlayerPanel.onVideoClosedCallback = this.closePopupView;
         this.myVideoPlayerPanel.viewIsHandlingKeyESC = true;
         myPopup.configConfirmButton(DictSetting.CLOSE_SETTING,super.closePopupView,true);
         this.myNavArrowRight.setOrientRight();
      }
      
      private function buildSlideShowDisplay() : void
      {
         var SCROLLER_PADDING:int = 0;
         var slide:GameModeTutorialContentSlide = null;
         var prevSlide:GameModeTutorialContentSlide = null;
         var len:uint = 0;
         var SLIDE_PADDING:uint = 8;
         SCROLLER_PADDING = 32;
         var cls:Class = gameModeTutorialContentSlide;
         len = this.mContentData.length;
         var i:uint = 0;
         this.mSlides = new Vector.<GameModeTutorialContentSlide>(0);
         this.myNavArrowRight.clickCallback = this.myNavArrowLeft.clickCallback = this.onNavArrowClick;
         for(this.myNavArrowLeft.visible = false; i < len; )
         {
            slide = new cls() as GameModeTutorialContentSlide;
            slide.index = i;
            slide.clickCallback = this.onSlideClick;
            slide.thumbnailImage = this.mContentData[i].imagePath;
            slide.isVideoSlide = this.mContentData[i].videoPath != "";
            if(slide.isVideoSlide)
            {
               slide.videoSlideClickCallback = this.myVideoPlayerPanel.playVideo;
            }
            if(i > 0)
            {
               prevSlide = this.mSlides[i - 1];
               slide.x = prevSlide.x + prevSlide.width + SLIDE_PADDING;
            }
            this.mSlidesHolder.addChild(slide);
            this.mSlides[i] = slide;
            i++;
         }
         this.mSlideWidth = slide.width;
         this.mSlidesHolder.x = this.myScroller.x = this.mMask.x = this.myHeroImage.x;
         this.mSlidesHolder.y = this.mMask.y = this.myHeroImage.y + this.myHeroImage.height + SCROLLER_PADDING;
         this.myScroller.y = this.mSlidesHolder.y - 33;
         this.mMask.graphics.beginFill(0);
         this.mMask.graphics.drawRect(0,0,POPUP_CONTENT_WIDTH,slide.height);
         this.mMask.graphics.endFill();
         this.myNavArrowRight.enabled = true;
         this.myNavArrowLeft.buttonWidth = this.myNavArrowRight.buttonWidth = this.mMask.width * 0.2;
         this.myNavArrowLeft.buttonHeight = this.myNavArrowRight.buttonHeight = this.myHeroImage.height;
         this.myNavArrowLeft.x = this.mMask.x;
         this.myNavArrowLeft.y = myPopup.y + SCROLLER_PADDING;
         this.myNavArrowRight.x = this.myHeroImage.x + this.mMask.width;
         this.myNavArrowRight.y = this.myHeroImage.y + this.myNavArrowRight.height;
         var barWidth:Number = this.mMask.width * (this.mMask.width / this.mSlidesHolder.width);
         this.myProgressMarker.width = barWidth;
         if(len > MAX_VISIBLE_SLIDES)
         {
            this.mProgressMarkerClickable = new BehaviourClickable(this.myProgressMarker);
            this.mProgressMarkerClickable.setEnableMouseHighlight(true);
            this.mProgressMarkerClickable.addMouseOverCallback(this.onMarkerOver);
            this.mProgressMarkerClickable.addMouseOutCallback(this.onMarkerOut);
            this.mProgressMarkerClickable.addMouseDownCallback(this.onMarkerClicked);
            this.mProgressMarkerClickable.addMouseUpCallback(this.onMarkerReleased);
            this.mProgressMarkerScrollBounds = new Rectangle(0,12,this.mMask.width - this.myProgressMarker.width,0);
         }
         this.myProgressMarker.visible = this.myScroller.visible = len > MAX_VISIBLE_SLIDES;
         myPopup.getButtonByIndex(0).y = this.mSlidesHolder.y + this.mSlidesHolder.height + 10;
         swapChildren(this.mSlidesHolder,this.myVideoPlayerPanel);
         swapChildren(this.myVideoPlayerPanel,this.myNavArrowLeft);
      }
      
      private function onMarkerOver() : void
      {
         this.myProgressMarker.gotoAndStop(FRAME_OVER);
      }
      
      private function onMarkerOut() : void
      {
         if(!this.mIsScrolling)
         {
            this.myProgressMarker.gotoAndStop(FRAME_OUT);
         }
      }
      
      private function onMarkerClicked() : void
      {
         this.onMarkerOver();
         this.myProgressMarker.startDrag(false,this.mProgressMarkerScrollBounds);
         this.mIsScrolling = true;
         this.myProgressMarker.addEventListener(Event.ENTER_FRAME,this.onDragging);
      }
      
      private function onDragging(e:Event) : void
      {
         if(this.myVideoPlayerPanel.isFullscreen)
         {
            return;
         }
         var contentDestination:Number = this.myProgressMarker.x / (this.mMask.width - this.myProgressMarker.width);
         TweenLite.to(this.mSlidesHolder,ANIM_SPEED,{"x":-contentDestination * (this.mSlidesHolder.width - this.mMask.width) + this.mMask.x});
      }
      
      private function onMarkerReleased() : void
      {
         this.myProgressMarker.stopDrag();
         this.mIsScrolling = false;
         this.onMarkerOut();
         this.myProgressMarker.removeEventListener(Event.ENTER_FRAME,this.onDragging);
      }
      
      private function onSlideClick(index:uint) : void
      {
         this.mCurrentSlideIndex = index;
         this.updateContent();
         this.checkEnableArrows();
      }
      
      override protected function get transitionTargetPoint() : Point
      {
         var SLIDE_HOLDER_SCROLLER_OFFSET:int = this.mContentData.length > 1 ? 145 : 0;
         return new Point((GameInfo.DEFAULT_WIDTH - (myPopup.popupWidth + 20)) * 0.5,(GameInfo.DEFAULT_HEIGHT - (myPopup.popupHeight + SLIDE_HOLDER_SCROLLER_OFFSET)) * 0.5);
      }
      
      override public function set routeData(data:*) : void
      {
         this.mContentData = TutorialService.getInstance().getContentByGameType(String(data).toLocaleLowerCase());
      }
      
      override protected function showView() : void
      {
         super.showView();
         if(this.hasSlideShow)
         {
            this.buildSlideShowDisplay();
            parent.stage.addEventListener(MouseEvent.MOUSE_WHEEL,this.handleMouseWheel);
            stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onStageKeyHandle);
         }
         this.updateContent();
      }
      
      override protected function hideView() : void
      {
         super.hideView();
         parent.stage.removeEventListener(MouseEvent.MOUSE_WHEEL,this.handleMouseWheel);
         this.myProgressMarker.removeEventListener(Event.ENTER_FRAME,this.onDragging);
         this.mMask.graphics.clear();
         this.mCurrentScrollIndex = this.mCurrentSlideIndex = 0;
         this.updateContent();
         while(this.mSlidesHolder.numChildren > 0)
         {
            this.mSlidesHolder.removeChildAt(0);
         }
      }
      
      private function onNavArrowClick(arrow:NavArrow) : void
      {
         if(!arrow.enabled)
         {
            return;
         }
         if(arrow == this.myNavArrowLeft)
         {
            if(this.mCurrentScrollIndex > 0)
            {
               --this.mCurrentScrollIndex;
            }
            if(this.mCurrentSlideIndex > 0)
            {
               --this.mCurrentSlideIndex;
            }
         }
         else
         {
            if(this.mCurrentScrollIndex < this.mContentData.length - MAX_VISIBLE_SLIDES)
            {
               ++this.mCurrentScrollIndex;
            }
            if(this.mCurrentSlideIndex < this.mContentData.length - 1)
            {
               ++this.mCurrentSlideIndex;
            }
         }
         this.checkEnableArrows();
         this.updateContent(true);
      }
      
      private function handleMouseWheel(evt:MouseEvent) : void
      {
         if(this.myVideoPlayerPanel.isFullscreen)
         {
            return;
         }
         if(evt.delta > 0)
         {
            if(this.mCurrentScrollIndex < this.mContentData.length - MAX_VISIBLE_SLIDES)
            {
               ++this.mCurrentScrollIndex;
            }
         }
         else if(this.mCurrentScrollIndex > 0)
         {
            --this.mCurrentScrollIndex;
         }
         this.checkEnableArrows();
         this.updateContent(true);
      }
      
      private function updateContent(shiftList:Boolean = false) : void
      {
         var targetX:Number = NaN;
         var offset:Number = NaN;
         var percentComplete:Number = NaN;
         var maxVal:int = 0;
         var IMG_PATH:String = "scaleform_ash/other/tutorials/";
         var currentContentObj:GamemodeTutorialContentObj = this.mContentData[this.mCurrentSlideIndex];
         if(this.hasSlideShow)
         {
            if(this.mSelectedSlide != null)
            {
               this.mSelectedSlide.enabled = true;
            }
            if(this.mSlides != null && this.mSlides.length > this.mCurrentSlideIndex)
            {
               this.mSelectedSlide = this.mSlides[this.mCurrentSlideIndex];
               this.mSelectedSlide.enabled = false;
               if(shiftList)
               {
                  targetX = 0;
                  if(this.mCurrentScrollIndex > 0)
                  {
                     percentComplete = MIN(this.mCurrentScrollIndex / (this.mContentData.length - MAX_VISIBLE_SLIDES),1);
                     maxVal = this.mMask.width - this.myProgressMarker.width;
                     targetX = maxVal * percentComplete;
                  }
                  TweenLite.to(this.myProgressMarker,ANIM_SPEED,{
                     "x":int(targetX),
                     "ease":Cubic.easeOut,
                     "overwrite":1
                  });
                  offset = this.mSlides[this.mCurrentScrollIndex].x;
                  TweenLite.to(this.mSlidesHolder,ANIM_SPEED,{"x":-int(offset - this.mMask.x)});
               }
            }
         }
         if(currentContentObj.videoPath != "")
         {
            this.myHeroImage.clearImage();
            this.myHeroImage.visible = false;
            this.myVideoPlayerPanel.videoPath = currentContentObj.videoPath;
            this.myVideoPlayerPanel.videoCoverFromFile = IMG_PATH.concat(currentContentObj.imagePath);
            this.myVideoPlayerPanel.active();
            this.mySlideTitle.text = "";
            this.mySlideDesc.text = "";
            this.mySlideTextBG.visible = false;
         }
         else
         {
            this.myVideoPlayerPanel.dispose();
            this.myVideoPlayerPanel.visible = false;
            this.myHeroImage.visible = true;
            this.myHeroImage.setImage("scaleform_ash/other/tutorials/" + currentContentObj.imagePath);
            this.mySlideTitle.text = LocalizeUtil.localize(currentContentObj.contentTitle);
            this.mySlideDesc.text = LocalizeUtil.localize(currentContentObj.contentSubTitle);
            this.mySlideTextBG.visible = this.mySlideTitle.text.length + this.mySlideDesc.text.length > 0;
            if(this.mySlideTitle.textHeight == 0)
            {
               this.mySlideDesc.y = this.mySlideTitle.y;
               this.mySlideTextBG.height = this.mySlideTitle.textHeight + this.mySlideDesc.textHeight + 27;
            }
            else
            {
               this.mySlideDesc.y = this.mSlideDescY;
               this.mySlideTextBG.height = this.mySlideTitle.textHeight + this.mySlideDesc.textHeight + 35;
            }
         }
      }
      
      override protected function closePopupView() : void
      {
         if(this.myVideoPlayerPanel.isFullscreen)
         {
            this.myVideoPlayerPanel.toggleFullscreen();
         }
         else
         {
            this.myVideoPlayerPanel.dispose();
            super.closePopupView();
         }
      }
      
      private function checkEnableArrows() : void
      {
         this.myNavArrowRight.enabled = this.mCurrentSlideIndex < this.mContentData.length - 1;
         this.myNavArrowLeft.enabled = this.mCurrentSlideIndex > 0;
      }
      
      protected function onStageKeyHandle(e:KeyboardEvent) : void
      {
         if(Boolean(KeyboardEvent.KEY_DOWN))
         {
            if(e.keyCode == Keyboard.LEFT)
            {
               if(this.mCurrentScrollIndex > 0)
               {
                  --this.mCurrentScrollIndex;
               }
               this.checkEnableArrows();
               this.updateContent(true);
            }
            else if(e.keyCode == Keyboard.RIGHT)
            {
               if(this.mCurrentScrollIndex < this.mContentData.length - MAX_VISIBLE_SLIDES)
               {
                  ++this.mCurrentScrollIndex;
               }
               this.checkEnableArrows();
               this.updateContent(true);
            }
         }
      }
      
      private function get hasSlideShow() : Boolean
      {
         return this.mContentData.length > 1;
      }
   }
}

