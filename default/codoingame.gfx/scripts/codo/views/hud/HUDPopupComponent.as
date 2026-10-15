package codo.views.hud
{
   import codo.base.BaseView;
   import codo.common.CFunctionInGameContainer;
   import codo.constants.BCInGameEvent;
   import codo.constants.GameInfo;
   import codo.utils.ScaleformUtil;
   import flash.display.MovieClip;
   import flash.errors.IllegalOperationError;
   import flash.geom.Point;
   
   public class HUDPopupComponent extends BaseView
   {
      
      protected var mCompIndex:int;
      
      protected var mMask:MovieClip;
      
      protected var mBlurView:Boolean;
      
      protected var mShowMask:Boolean;
      
      public function HUDPopupComponent()
      {
         var stageSize:Point = null;
         var stagePosition:Point = null;
         super();
         this.mCompIndex = -1;
         this.mBlurView = true;
         this.mShowMask = true;
         stageSize = new Point(1280,960);
         stagePosition = new Point(0,0);
         if(ScaleformUtil.isScaleform)
         {
            stageSize = GameInfo.stageSize;
            stagePosition = GameInfo.stagePosition;
         }
         this.mMask = new MovieClip();
         this.mMask.graphics.clear();
         this.mMask.graphics.beginFill(0);
         this.mMask.alpha = 0.6;
         this.mMask.graphics.drawRect(0,0,stageSize.x,stageSize.y);
         this.mMask.graphics.endFill();
         this.mMask.x = stagePosition.x;
         this.mMask.y = stagePosition.y;
         addChild(this.mMask);
         setChildIndex(this.mMask,0);
      }
      
      public function get CompType() : int
      {
         throw new IllegalOperationError("Must override CompType function");
      }
      
      override protected function showView() : void
      {
         var blur:Number = NaN;
         super.showView();
         if(this.mCompIndex == -1)
         {
            this.mCompIndex = CFunctionInGameContainer.AS_RegisterHUDPopupView(this.CompType,this);
         }
         if(this.mBlurView)
         {
            blur = 2;
            broadcast(BCInGameEvent.EVT_BLUR,blur);
         }
         this.mMask.visible = this.mShowMask;
      }
      
      override protected function hideView() : void
      {
         var blur:Number = NaN;
         super.hideView();
         CFunctionInGameContainer.AS_UnregisterHUDPopupView(this.mCompIndex);
         this.mCompIndex = -1;
         if(this.mBlurView)
         {
            blur = 0;
            broadcast(BCInGameEvent.EVT_BLUR,blur);
         }
      }
      
      protected function Notify(msg:int, param:Object) : Object
      {
         if(this.mCompIndex < 0)
         {
            return null;
         }
         if(ScaleformUtil.isScaleform)
         {
            return CFunctionInGameContainer.AS_HUDPopupViewNotify(this.mCompIndex,msg,param);
         }
         return null;
      }
   }
}

