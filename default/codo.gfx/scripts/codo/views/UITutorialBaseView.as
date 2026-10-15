package codo.views
{
   import codo.base.BaseView;
   import codo.component.tutorial.UITourToolTip;
   import codo.constants.BCEvent;
   import codo.constants.GameInfo;
   import codo.objects.uitour.UITourToolTipObj;
   import codo.style.GlobalGuide;
   import codo.style.TutorialGuide;
   import codo.utils.Logger;
   import codo.views.uitour.UITutorialTourBase;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   
   public class UITutorialBaseView extends BaseView
   {
      
      private static var _mouseBlocked:Boolean;
      
      private static const GUTTER_ALPHA:Number = TutorialGuide.OVERLAY_ALPHA;
      
      private static var _activeTutorials:Dictionary = new Dictionary(true);
      
      public var myToolTip:UITourToolTip;
      
      private var mFlagID:uint;
      
      private var mLastFlag:uint = 4294967295;
      
      private var mStepIndex:int;
      
      private var mToolTips:Vector.<UITourToolTipObj>;
      
      private var mOverlay:Sprite;
      
      protected var mDrawGutter:Boolean = true;
      
      private var hasOpenVideoTour:Boolean = false;
      
      public function UITutorialBaseView()
      {
         super();
         mouseEnabled = true;
         if(this.myToolTip != null)
         {
            this.myToolTip.clickCallback = this.onToolTipClicked;
         }
      }
      
      public static function startMouseBlock(container:DisplayObject) : void
      {
         if(_mouseBlocked)
         {
            return;
         }
         _mouseBlocked = true;
         container.stage.addEventListener(MouseEvent.CLICK,blockMouseEvent,true,int.MAX_VALUE);
         container.stage.addEventListener(MouseEvent.MOUSE_DOWN,blockMouseEvent,true,int.MAX_VALUE);
      }
      
      private static function blockMouseEvent(evt:MouseEvent) : void
      {
         evt.stopImmediatePropagation();
         Logger.print("Click blocked!");
      }
      
      private static function endMouseBlock(container:DisplayObject) : void
      {
         if(!_mouseBlocked)
         {
            return;
         }
         _mouseBlocked = false;
         container.stage.removeEventListener(MouseEvent.CLICK,blockMouseEvent,true);
         container.stage.removeEventListener(MouseEvent.MOUSE_DOWN,blockMouseEvent,true);
      }
      
      public static function isTutorialShowing() : Boolean
      {
         var key:Object = null;
         var _loc2_:int = 0;
         var _loc3_:* = _activeTutorials;
         for(key in _loc3_)
         {
            return true;
         }
         return false;
      }
      
      public function get videoTourOpened() : Boolean
      {
         return this.hasOpenVideoTour;
      }
      
      public function set videoTourOpened(isOpened:Boolean) : void
      {
         this.hasOpenVideoTour = isOpened;
      }
      
      override public function set routeData(data:*) : void
      {
         super.routeData = data;
         this.mFlagID = data as uint;
      }
      
      override protected function onInit() : void
      {
         super.onInit();
         if(this.mDrawGutter)
         {
            this.drawViewGutter();
         }
      }
      
      override protected function showView() : void
      {
         super.showView();
         _activeTutorials[this] = true;
         broadcast(BCEvent.EVT_TUTORIAL_STATE);
         endMouseBlock(this);
         this.hideAllTours();
         if(this.mLastFlag != this.flagID)
         {
            this.mLastFlag = this.flagID;
            this.mStepIndex = 0;
            this.mToolTips = this.getToolTips();
            if(this.usesOverlay())
            {
               this.drawToolTipOverlay();
            }
            else if(this.mOverlay != null)
            {
               removeChild(this.mOverlay);
               this.mOverlay = null;
            }
         }
         this.showNextTip();
      }
      
      override protected function hideView() : void
      {
         super.hideView();
         delete _activeTutorials[this];
         broadcast(BCEvent.EVT_TUTORIAL_STATE);
      }
      
      protected function get flagID() : uint
      {
         return this.mFlagID;
      }
      
      private function drawViewGutter() : void
      {
         var GUTTER_WIDTH:uint = 600;
         addChild(this.drawGutterShapeHorizontal(GUTTER_WIDTH)) as Shape;
         addChild(this.drawGutterShapeHorizontal(GUTTER_WIDTH,true)) as Shape;
         addChild(this.drawGutterShapeVertical(GUTTER_WIDTH)) as Shape;
         addChild(this.drawGutterShapeVertical(GUTTER_WIDTH,true)) as Shape;
      }
      
      private function drawGutterShapeHorizontal(gutterWidth:Number, offsetRight:Boolean = false) : Shape
      {
         var rectangle:Shape = new Shape();
         var gutterX:Number = offsetRight ? GameInfo.DEFAULT_WIDTH : -gutterWidth;
         rectangle.graphics.beginFill(GlobalGuide.CODO_BLACK,GUTTER_ALPHA);
         rectangle.graphics.drawRect(gutterX,0,gutterWidth,GameInfo.DEFAULT_HEIGHT);
         rectangle.graphics.endFill();
         return rectangle;
      }
      
      private function drawGutterShapeVertical(gutterHeight:Number, offsetBottom:Boolean = false) : Shape
      {
         var rectangle:Shape = new Shape();
         var gutterY:Number = offsetBottom ? GameInfo.DEFAULT_HEIGHT : -gutterHeight;
         rectangle.graphics.beginFill(GlobalGuide.CODO_BLACK,GUTTER_ALPHA);
         rectangle.graphics.drawRect(0,gutterY,GameInfo.DEFAULT_WIDTH,gutterHeight);
         rectangle.graphics.endFill();
         return rectangle;
      }
      
      public function hideAllTours() : void
      {
         var displayObj:DisplayObject = null;
         var len:uint = uint(this.numChildren);
         for(var i:uint = 0; i < len; )
         {
            displayObj = this.getChildAt(i);
            if(displayObj is UITutorialTourBase)
            {
               UITutorialTourBase(displayObj).hide();
            }
            i++;
         }
      }
      
      protected function usesOverlay() : Boolean
      {
         return false;
      }
      
      protected function getToolTips() : Vector.<UITourToolTipObj>
      {
         return null;
      }
      
      private function onToolTipClicked() : void
      {
         if(this.mStepIndex + 1 < this.mToolTips.length)
         {
            ++this.mStepIndex;
            this.showNextTip();
         }
         else
         {
            this.onTourFinished();
         }
      }
      
      protected function onTourFinished() : void
      {
         this.hideAllTours();
         this.hideView();
      }
      
      private function showNextTip() : void
      {
         if(this.myToolTip != null)
         {
            this.myToolTip.deactive();
            if(this.mToolTips != null)
            {
               if(this.mStepIndex < this.mToolTips.length)
               {
                  this.beginToolTip(this.mToolTips[this.mStepIndex]);
               }
               else
               {
                  this.onTourFinished();
               }
            }
         }
      }
      
      protected function beginToolTip(tip:UITourToolTipObj) : void
      {
         this.myToolTip.showHelpTip(tip);
      }
      
      private function drawToolTipOverlay() : void
      {
         if(this.mOverlay != null)
         {
            return;
         }
         var rectangle:Shape = new Shape();
         rectangle.graphics.beginFill(GlobalGuide.CODO_BLACK,0.4);
         rectangle.graphics.drawRect(0,0,GameInfo.DEFAULT_WIDTH,GameInfo.DEFAULT_HEIGHT);
         rectangle.graphics.endFill();
         this.mOverlay = addChild(new Sprite()) as Sprite;
         this.mOverlay.addChild(rectangle);
         swapChildren(this.myToolTip,this.mOverlay);
      }
   }
}

