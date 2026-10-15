package codo.controllers
{
   import codo.base.BaseController;
   import codo.common.CFunctionContainer;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.event.ParaEvent;
   
   public class OptionVideoController extends BaseController
   {
      
      private var _videoOptionsOpen:Boolean = false;
      
      private var _optionsEnabled:Boolean = false;
      
      private var _vidRestartInited:Boolean = false;
      
      public function OptionVideoController()
      {
         super();
         this.listen(BCEvent.EVT_VIDEO_OPTIONS_OPEN,this.onVideoOptionsOpen);
      }
      
      override protected function onInitialized() : void
      {
         this.addDP(DataID.OPTIONS_ENABLED,this.getOptionsEnabled);
      }
      
      private function onVideoOptionsOpen(cEvt:ParaEvent) : void
      {
         this._videoOptionsOpen = cEvt.myPara.open;
      }
      
      override public function update(deltaTime:Number) : void
      {
         var doneLoading:Boolean = false;
         if(!this._optionsEnabled)
         {
            doneLoading = Boolean(CFunctionContainer.IsDoneLoading());
            if(doneLoading)
            {
               this._optionsEnabled = true;
               this.broadcast(BCEvent.EVT_ENABLE_OPTIONS);
            }
         }
         var canRestartVideo:Boolean = false;
         if(!this._vidRestartInited)
         {
            canRestartVideo = Boolean(CFunctionContainer.CanRestartVideo());
            if(canRestartVideo)
            {
               this._vidRestartInited = true;
               this.broadcast(BCEvent.EVT_INIT_VID_RESTART);
            }
            return;
         }
         if(this._videoOptionsOpen)
         {
            canRestartVideo = Boolean(CFunctionContainer.CanRestartVideo());
            this.broadcast(BCEvent.EVT_ENABLE_VIDEO_RESTART,{"canRestartVideo":canRestartVideo});
         }
      }
      
      public function getOptionsEnabled() : Boolean
      {
         return this._optionsEnabled;
      }
   }
}

