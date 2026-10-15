package codo.controllers
{
   import codo.base.BaseController;
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.constants.BCCommonEvent;
   import codo.constants.BCEvent;
   import codo.constants.Common;
   import codo.event.ParaEvent;
   import codo.utils.Logger;
   
   public class UIViewerController extends BaseController
   {
      
      private var m_inputFocused:Boolean = false;
      
      public function UIViewerController()
      {
         super();
      }
      
      override protected function onInitialized() : void
      {
         this.listen(BCEvent.EVT_SET_UIVIEWER_MODE,this.onSetUIViewerMode);
         this.listen(BCCommonEvent.EVT_INPUT_FOCUS_CHANGED,this.onInputFocusChanged);
      }
      
      private function onInputFocusChanged(cEvt:ParaEvent) : void
      {
         this.m_inputFocused = cEvt.myPara.focus;
      }
      
      private function onSetUIViewerMode(cEvt:ParaEvent) : void
      {
         var mode:uint = uint(cEvt.myPara.mode);
         var status:uint = uint(cEvt.myPara.status);
         var gametype:uint = uint(cEvt.myPara.gametype);
         if(mode == Common.UIVIEWER_MODE_TEAM)
         {
            CFunctionContainer.WL_SwitchWeaponCategory("primary");
         }
         Logger.print("UIViewerController::onSetUIViewerMode : " + mode + " " + status + " " + gametype);
         if(mode == Common.UIVIEWER_MODE_NONE)
         {
            CFunctionContainer.AS_UIViewerSet3DSceneVisibility(false);
            mode = Common.UIVIEWER_MODE_CHARACTER_LOADOUT;
         }
         else if(mode == Common.UIVIEWER_MODE_DISABLE)
         {
            CFunctionContainer.AS_UIViewerSet3DSceneVisibility(false);
            mode = Common.UIVIEWER_MODE_NONE;
         }
         else
         {
            CFunctionContainer.AS_UIViewerSet3DSceneVisibility(true);
         }
         CFunctionCommonContainer.AS_UIViewerSetMode(mode,status,gametype);
      }
      
      public function cppIsInputFocused() : Boolean
      {
         return this.m_inputFocused;
      }
      
      public function cppUiViewerModelLoadStateUpdate(isLoading:Boolean) : void
      {
         broadcast(BCEvent.EVT_UIVIEWER_MODEL_LOAD_STATE_UPDATE,isLoading);
      }
      
      public function cppUiViewerAnimTypeBegin(animType:uint) : void
      {
         broadcast(BCEvent.EVT_UIVIEWER_ANIM_TYPE_BEGIN,animType);
      }
      
      public function cppUiViewerAnimTypeEnd(animType:uint) : void
      {
         broadcast(BCEvent.EVT_UIVIEWER_ANIM_TYPE_END,animType);
      }
   }
}

