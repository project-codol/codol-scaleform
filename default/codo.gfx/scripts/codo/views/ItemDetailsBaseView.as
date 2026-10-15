package codo.views
{
   import codo.base.BaseView;
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.component.BackButton;
   import codo.component.LoadingSpinner;
   import codo.component.MarketCharacterModule;
   import codo.constants.BCEvent;
   import codo.event.ParaEvent;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class ItemDetailsBaseView extends BaseView
   {
      
      public var myBackButton:BackButton;
      
      public var my3DRotationHitarea:MovieClip;
      
      public var myLoadingSpinner:LoadingSpinner;
      
      public var myCharacterModule:MarketCharacterModule;
      
      protected var _flagResetRotation:Boolean;
      
      private var _detect3DRotationOrgX:Number;
      
      public function ItemDetailsBaseView()
      {
         super();
         this.initStage();
      }
      
      protected function initStage() : void
      {
         this.myLoadingSpinner.visible = false;
         this.myBackButton.registerClickEvent(this.onBackButtonClicked);
         listen(BCEvent.EVT_UIVIEWER_MODEL_LOAD_STATE_UPDATE,this.onUiViewerModelLoadStateUpdate);
      }
      
      override public function set routeData(data:*) : void
      {
      }
      
      override protected function enableData() : void
      {
         this.my3DRotationHitarea.addEventListener(MouseEvent.MOUSE_DOWN,this.onStartDetect3DModelRotationHandle);
      }
      
      override protected function disableData() : void
      {
         this.myLoadingSpinner.visible = false;
         CFunctionCommonContainer.AS_UIViewerEnableTurntable(false);
         this.my3DRotationHitarea.removeEventListener(MouseEvent.MOUSE_DOWN,this.onStartDetect3DModelRotationHandle);
         this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onDetect3DModelRotationHandle);
         this.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onStopDetect3DModelRotationHandle);
      }
      
      override protected function showView() : void
      {
         super.showView();
         this.myBackButton.show();
      }
      
      override protected function hideView() : void
      {
         super.hideView();
         this.myBackButton.hide();
      }
      
      protected function onBackButtonClicked() : void
      {
         broadcast(BCEvent.GOTO_PREV_MAIN_PAGE);
      }
      
      protected function onUiViewerModelLoadStateUpdate(e:ParaEvent) : void
      {
         var isLoading:Boolean = e.myPara;
         if(!isLoading)
         {
            this.myLoadingSpinner.visible = false;
            if(this._flagResetRotation)
            {
               this._flagResetRotation = false;
               CFunctionContainer.WL_ResetWeaponRotation();
            }
         }
         else
         {
            this.myLoadingSpinner.visible = true;
         }
      }
      
      protected function onDetect3DModelRotationHandle(cEvt:MouseEvent) : void
      {
         this.broadcast(BCEvent.CHARACTER3D_ROTATION_CHANGE,{
            "offsetX":this.stage.mouseX - this._detect3DRotationOrgX,
            "offsetY":0
         });
         this._detect3DRotationOrgX = this.stage.mouseX;
      }
      
      protected function onStartDetect3DModelRotationHandle(cEvt:MouseEvent) : void
      {
         CFunctionCommonContainer.AS_UIViewerEnableTurntable(false);
         this._detect3DRotationOrgX = this.stage.mouseX;
         this.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onDetect3DModelRotationHandle);
         this.stage.addEventListener(MouseEvent.MOUSE_UP,this.onStopDetect3DModelRotationHandle);
      }
      
      protected function onStopDetect3DModelRotationHandle(cEvt:MouseEvent) : void
      {
         this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onDetect3DModelRotationHandle);
         this.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onStopDetect3DModelRotationHandle);
      }
   }
}

