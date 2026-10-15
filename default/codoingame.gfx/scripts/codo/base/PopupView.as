package codo.base
{
   import codo.component.Popup;
   import codo.constants.BCEvent;
   import codo.constants.GameInfo;
   import codo.utils.LocalizeUtil;
   import com.greensock.TimelineLite;
   import com.greensock.TweenLite;
   import com.greensock.easing.Linear;
   import flash.geom.Point;
   
   public class PopupView extends BaseView
   {
      
      protected static const ANIMATION_SPEED:Number = 0.2;
      
      protected static const BASE_WINDOW_SCALE:Number = 0.1;
      
      protected static const LOCALIZE:Function = LocalizeUtil.localize;
      
      private var mTransitionTimeline:TimelineLite;
      
      public var myPopup:Popup;
      
      public function PopupView()
      {
         super();
         this.myPopup.myCloseButton.setClickCallback(this.closePopupView);
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
         super.showView();
         this.mTransitionTimeline.play();
      }
      
      public function set headerTitle(txt:String) : void
      {
         this.myPopup.header.title = txt;
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
         targetPt = this.transitionTargetPoint;
         pt = new Point(GameInfo.DEFAULT_WIDTH * 0.5,GameInfo.DEFAULT_HEIGHT * 0.5);
         alpha = 0;
         scaleX = BASE_WINDOW_SCALE;
         scaleY = BASE_WINDOW_SCALE;
         x = pt.x;
         y = pt.y;
         transitionTimeline.append(new TweenLite(this,ANIMATION_SPEED,{
            "x":targetPt.x,
            "y":targetPt.y,
            "alpha":1,
            "scaleX":1,
            "scaleY":1,
            "onComplete":this.transitionInComplete,
            "ease":Linear.easeIn,
            "overwrite":1
         }));
      }
      
      protected function get transitionTargetPoint() : Point
      {
         return new Point((GameInfo.DEFAULT_WIDTH - this.myPopup.popupWidth) * 0.5,(GameInfo.DEFAULT_HEIGHT - this.myPopup.popupHeight) * 0.5);
      }
      
      protected function transitionOutDelegate(transitionTimeline:TimelineLite) : void
      {
         var targetPt:Point = new Point(GameInfo.DEFAULT_WIDTH * 0.5,GameInfo.DEFAULT_HEIGHT * 0.5);
         transitionTimeline.append(new TweenLite(this,ANIMATION_SPEED,{
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
      }
      
      protected function transitionOutComplete() : void
      {
         super.hideView();
      }
      
      protected function positionView() : void
      {
         x = (GameInfo.DEFAULT_WIDTH - this.myPopup.popupWidth) * 0.5;
         y = (GameInfo.DEFAULT_HEIGHT - this.myPopup.popupHeight) * 0.5;
      }
   }
}

