package codo.controllers
{
   import codo.base.BaseController;
   import codo.common.CFunctionCommonContainer;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.constants.VideoStatus;
   import codo.event.ParaEvent;
   import codo.objects.TutorialVideoObj;
   import codo.utils.ScaleformUtil;
   import codo.utils.TableUtil;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class VideoController extends BaseController
   {
      
      private static const PATH_TUTORIAL_VIDEO_CSV:String = "mp/tutorialVideo.csv";
      
      private static var IS_ALL_VIDEO_READY_DETECT_DELAY:uint = 2000;
      
      private var tutorialVideos:Vector.<TutorialVideoObj> = new Vector.<TutorialVideoObj>(0);
      
      private var _tutorialVideosReadyTimer:Timer;
      
      private var _currentVideoURL:String;
      
      private var _currentVideoLoop:Boolean = false;
      
      private var _nextVideoURL:String;
      
      private var _currentVideoStatus:int = VideoStatus.PLAY_STOP;
      
      public function VideoController()
      {
         super();
      }
      
      override protected function onInitialized() : void
      {
         this.addDP(DataID.IS_VIDEO_PLAYING,this.isVideoPlaying);
         this.addDP(DataID.IS_VIDEO_PAUSING,this.isVideoPausing);
         this.listen(BCEvent.EVT_PLAY_VIDEO,this.onPlayVideoHandle);
         this.listen(BCEvent.EVT_CLOSE_VIDEO_PLAYER,this.onCloseVideoPlayerHandle);
         this.listen(BCEvent.EVT_VIDEO_PLAY_OR_PAUSE,this.onTryPlayOrPauseVideoHandle);
         this.listen(BCEvent.EVT_PLAYER_STATS_READY,this.onPlayerStatsReadyHandle);
      }
      
      private function isVideoPlaying() : Boolean
      {
         return CFunctionCommonContainer.isvideoplaying() as Boolean;
      }
      
      private function isVideoPausing() : Boolean
      {
         return CFunctionCommonContainer.isvideopaused() as Boolean;
      }
      
      private function getCurrentVideoSize() : Object
      {
         var videoSize:Object = CFunctionCommonContainer.getvideosize();
         if(ScaleformUtil.isTempContentEnabled() == true || videoSize == null)
         {
            videoSize = {
               "width":1280,
               "height":720
            };
         }
         return videoSize;
      }
      
      private function onPlayVideoHandle(cEvt:ParaEvent) : void
      {
         if(cEvt.myPara != null)
         {
            this._nextVideoURL = cEvt.myPara.videoURL;
            if(Boolean(CFunctionCommonContainer.isvideoplaying()))
            {
               CFunctionCommonContainer.stopvideo();
            }
            else
            {
               this.playVideoNow();
            }
         }
      }
      
      private function playVideoNow() : void
      {
      }
      
      private function onCloseVideoPlayerHandle(cEvt:ParaEvent) : void
      {
         if(CFunctionCommonContainer.isvideoplaying() == true)
         {
            CFunctionCommonContainer.stopvideo();
         }
         this.prevPage();
      }
      
      private function onTryPlayOrPauseVideoHandle(cEvt:ParaEvent) : void
      {
         if(Boolean(CFunctionCommonContainer.isvideopaused()))
         {
            CFunctionCommonContainer.resumevideo();
         }
         else
         {
            CFunctionCommonContainer.pausevideo();
         }
      }
      
      private function onPlayerStatsReadyHandle(cEvt:ParaEvent) : void
      {
         var rowCount:int = 0;
         var i:uint = 0;
         var videoObj:TutorialVideoObj = null;
         if(ScaleformUtil.isScaleform)
         {
            rowCount = TableUtil.getRowCount(PATH_TUTORIAL_VIDEO_CSV);
            for(i = 0; i < rowCount; i++)
            {
               videoObj = new TutorialVideoObj();
               videoObj.name = TableUtil.getValue(PATH_TUTORIAL_VIDEO_CSV,i,0);
               videoObj.width = Number(TableUtil.getValue(PATH_TUTORIAL_VIDEO_CSV,i,2));
               videoObj.height = Number(TableUtil.getValue(PATH_TUTORIAL_VIDEO_CSV,i,3));
               videoObj.length = Number(TableUtil.getValue(PATH_TUTORIAL_VIDEO_CSV,i,4));
               videoObj.picURL = TableUtil.getValue(PATH_TUTORIAL_VIDEO_CSV,i,1);
               this.tutorialVideos.push(videoObj);
            }
            if(this.tutorialVideos.length > 0)
            {
               this._tutorialVideosReadyTimer = new Timer(IS_ALL_VIDEO_READY_DETECT_DELAY);
               this._tutorialVideosReadyTimer.addEventListener(TimerEvent.TIMER,this.onDetectAllVideoReadyTimerHandle);
               this._tutorialVideosReadyTimer.start();
            }
         }
      }
      
      private function onDetectAllVideoReadyTimerHandle(cEvt:TimerEvent) : void
      {
         var allReady:Boolean = true;
         for(var i:uint = 0; i < this.tutorialVideos.length; i++)
         {
            if(this.tutorialVideos[i].isReady == false)
            {
               this.tutorialVideos[i].isReady = Boolean(CFunctionCommonContainer.isvideoready(this.tutorialVideos[i].name));
               if(this.tutorialVideos[i].isReady == false)
               {
                  allReady = false;
               }
            }
         }
         if(allReady)
         {
            this._tutorialVideosReadyTimer.stop();
            this.broadcast(BCEvent.EVT_TUTORIAL_VIDEO_ALL_READY,{"data":this.tutorialVideos});
            this.setBindData(DataID.TUTORIAL_VIDEO_LIST_DAT,this.tutorialVideos);
         }
      }
      
      override public function update(deltaTime:Number) : void
      {
         var status:int = CFunctionCommonContainer.getvideostatus();
         if(this._currentVideoStatus != status)
         {
            this._currentVideoStatus = status;
            if(!this._currentVideoLoop)
            {
               if(this._currentVideoStatus == VideoStatus.PLAY_START)
               {
                  this.broadcast(BCEvent.EVT_VIDEO_SIZE_CHANGED,this.getCurrentVideoSize());
               }
               this.broadcast(BCEvent.EVT_VIDEO_STATUS_CHANGE,{"status":this._currentVideoStatus});
            }
            if(this._currentVideoStatus == VideoStatus.PLAY_STOP)
            {
               this.playVideoNow();
            }
         }
      }
   }
}

