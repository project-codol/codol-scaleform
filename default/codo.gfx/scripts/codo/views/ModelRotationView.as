package codo.views
{
   import codo.base.BaseView;
   import codo.component.LoadingSpinner;
   import codo.constants.BCEvent;
   import codo.event.ParaEvent;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class ModelRotationView extends BaseView
   {
      
      public var my3DRotationHitarea:MovieClip;
      
      public var myLoadingSpinner:LoadingSpinner;
      
      private var mDetect3DRotationOrgX:Number;
      
      private var mDetect3DRotationOrgY:Number;
      
      public function ModelRotationView()
      {
         super();
         this.my3DRotationHitarea.gotoAndStop(1);
         this.my3DRotationHitarea.alpha = 0;
         this.myLoadingSpinner.visible = false;
      }
      
      override protected function showView() : void
      {
         super.showView();
      }
      
      override protected function hideView() : void
      {
         super.hideView();
      }
      
      private function onShowEvt(cEvt:ParaEvent) : void
      {
         visible = true;
      }
      
      private function onHideEvt(cEvt:ParaEvent) : void
      {
         visible = false;
      }
      
      override protected function enableData() : void
      {
         super.enableData();
         listen(BCEvent.EVT_HIDE_PERSISTENT_VIEW,this.onHideEvt);
         listen(BCEvent.EVT_SHOW_PERSISTENT_VIEW,this.onShowEvt);
         listen(BCEvent.EVT_UIVIEWER_MODEL_LOAD_STATE_UPDATE,this.onUiViewerModelLoadStateUpdate);
         this.my3DRotationHitarea.addEventListener(MouseEvent.MOUSE_DOWN,this.onStartDetect3DModelRotationHandle);
      }
      
      override protected function disableData() : void
      {
         super.disableData();
         this.myLoadingSpinner.visible = false;
         unlisten(BCEvent.EVT_HIDE_PERSISTENT_VIEW,this.onHideEvt);
         unlisten(BCEvent.EVT_SHOW_PERSISTENT_VIEW,this.onShowEvt);
         unlisten(BCEvent.EVT_UIVIEWER_MODEL_LOAD_STATE_UPDATE,this.onUiViewerModelLoadStateUpdate);
         this.my3DRotationHitarea.removeEventListener(MouseEvent.MOUSE_DOWN,this.onStartDetect3DModelRotationHandle);
      }
      
      private function onDetect3DModelRotationHandle(cEvt:MouseEvent) : void
      {
         broadcast(BCEvent.CHARACTER3D_ROTATION_CHANGE,{
            "offsetX":stage.mouseX - this.mDetect3DRotationOrgX,
            "offsetY":stage.mouseY - this.mDetect3DRotationOrgY
         });
         this.mDetect3DRotationOrgX = stage.mouseX;
         this.mDetect3DRotationOrgY = stage.mouseY;
      }
      
      private function onStartDetect3DModelRotationHandle(cEvt:MouseEvent) : void
      {
         this.mDetect3DRotationOrgX = stage.mouseX;
         this.mDetect3DRotationOrgY = stage.mouseY;
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onDetect3DModelRotationHandle);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.onStopDetect3DModelRotationHandle);
      }
      
      private function onStopDetect3DModelRotationHandle(cEvt:MouseEvent) : void
      {
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onDetect3DModelRotationHandle);
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.onStopDetect3DModelRotationHandle);
      }
      
      private function onUiViewerModelLoadStateUpdate(e:ParaEvent) : void
      {
         var isLoading:Boolean = e.myPara;
         this.myLoadingSpinner.visible = isLoading;
      }
   }
}

