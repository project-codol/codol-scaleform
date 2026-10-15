package fsg.shared.popups
{
   import codo.base.BaseView;
   import codo.constants.BCEvent;
   import codo.constants.GameInfo;
   import codo.utils.LocalizeUtil;
   import com.greensock.TimelineLite;
   import com.greensock.TweenLite;
   import com.greensock.easing.Linear;
   import flash.display.Sprite;
   import flash.geom.Point;
   
   public class PopupBaseView extends BaseView
   {
      
      protected static const ANIMATION_SPEED:Number = 0.2;
      
      protected static const BASE_WINDOW_SCALE:Number = 0.1;
      
      protected static const TOP_PADDING:uint = 35;
      
      protected static const LOCALIZE:Function = LocalizeUtil.localize;
      
      public var myCloseBtn:PopupCloseBtn;
      
      public var myLogo:Sprite;
      
      public var myContent:PopupContentBase;
      
      private var mTransitionTimeline:TimelineLite;
      
      public function PopupBaseView()
      {
         super();
         this.myContent.init();
      }
      
      override protected function onInit() : void
      {
         if(Boolean(this.myCloseBtn))
         {
            this.myCloseBtn.alpha = 0;
         }
         if(Boolean(this.myLogo))
         {
            this.myLogo.alpha = 0;
         }
         this.myContent.myPopupBase.autosizeButtonToText();
      }
      
      protected function closePopupView() : void
      {
         broadcast(BCEvent.EVT_CLOSE_POPUP_PAGE,{"pageID":_pageID});
      }
      
      override protected function showView() : void
      {
         this.positionView();
         if(null != this.mTransitionTimeline)
         {
            this.mTransitionTimeline.clear();
         }
         this.mTransitionTimeline = new TimelineLite();
         this.transitionInDelegate(this.mTransitionTimeline);
         visible = true;
         this.mTransitionTimeline.play();
      }
      
      override protected function hideView() : void
      {
         if(null != this.mTransitionTimeline)
         {
            this.mTransitionTimeline.clear();
         }
         this.mTransitionTimeline = new TimelineLite();
         this.transitionOutDelegate(this.mTransitionTimeline);
         this.mTransitionTimeline.play();
      }
      
      protected function transitionInDelegate(transitionTimeline:TimelineLite) : void
      {
         var targetPt:Point = null;
         var pt:Point = null;
         targetPt = new Point((GameInfo.DEFAULT_WIDTH - this.myContent.contentWidth) * 0.5,(GameInfo.DEFAULT_HEIGHT - this.myContent.contentHeight) * 0.5);
         pt = new Point(GameInfo.DEFAULT_WIDTH * 0.5,GameInfo.DEFAULT_HEIGHT * 0.5);
         this.myContent.alpha = 0;
         this.myContent.scaleX = BASE_WINDOW_SCALE;
         this.myContent.scaleY = BASE_WINDOW_SCALE;
         this.myContent.x = pt.x;
         this.myContent.y = pt.y;
         transitionTimeline.append(new TweenLite(this.myContent,ANIMATION_SPEED,{
            "x":targetPt.x,
            "y":targetPt.y,
            "alpha":1,
            "scaleX":1,
            "scaleY":1,
            "onComplete":this.transitionInComplete,
            "ease":Linear.easeIn,
            "overwrite":1
         }));
         if(Boolean(this.myLogo))
         {
            transitionTimeline.append(new TweenLite(this.myLogo,ANIMATION_SPEED,{
               "alpha":1,
               "ease":Linear.easeIn,
               "overwrite":1
            }));
         }
      }
      
      protected function transitionOutDelegate(transitionTimeline:TimelineLite) : void
      {
         this.myContent.startTransitionOut();
         var targetPt:Point = new Point(GameInfo.DEFAULT_WIDTH * 0.5,GameInfo.DEFAULT_HEIGHT * 0.5);
         if(Boolean(this.myLogo))
         {
            transitionTimeline.append(new TweenLite(this.myLogo,ANIMATION_SPEED,{
               "alpha":0,
               "ease":Linear.easeOut,
               "overwrite":1
            }));
         }
         transitionTimeline.append(new TweenLite(this.myContent,ANIMATION_SPEED,{
            "x":targetPt.x,
            "y":targetPt.y,
            "alpha":0,
            "scaleX":BASE_WINDOW_SCALE,
            "scaleY":BASE_WINDOW_SCALE,
            "onComplete":this.transitionOutComplete,
            "ease":Linear.easeOut,
            "overwrite":1
         }));
      }
      
      protected function transitionInComplete() : void
      {
         if(Boolean(this.myCloseBtn))
         {
            this.myCloseBtn.registerClickEvent(this.closePopupView);
            this.myCloseBtn.alpha = 1;
         }
         this.myContent.startTransitionIn();
      }
      
      protected function transitionOutComplete() : void
      {
         visible = false;
      }
      
      protected function positionView() : void
      {
         var BTN_PADDING:uint = 0;
         this.myContent.x = (GameInfo.DEFAULT_WIDTH - this.myContent.contentWidth) * 0.5;
         this.myContent.y = (GameInfo.DEFAULT_HEIGHT - this.myContent.contentHeight) * 0.5;
         if(this.myLogo != null)
         {
            this.myLogo.x = this.myContent.x + this.myContent.contentWidth * 0.5 - this.myLogo.width * 0.5;
            this.myLogo.y = TOP_PADDING;
         }
         if(this.myCloseBtn != null)
         {
            BTN_PADDING = 19;
            this.myCloseBtn.y = this.myContent.y + BTN_PADDING;
            this.myCloseBtn.x = this.myContent.x + (this.myContent.contentWidth - (this.myCloseBtn.width + BTN_PADDING));
         }
      }
      
      override protected function onInitListener() : void
      {
         this.myContent.initListeners();
      }
      
      public function initListeners() : void
      {
      }
   }
}

