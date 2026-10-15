package codo.views
{
   import codo.base.BaseView;
   import codo.component.video.VideoPanel;
   import codo.constants.BCEvent;
   import codo.constants.GameInfo;
   import codo.objects.VideoPlayerObj;
   import codo.style.TutorialGuide;
   import flash.geom.Point;
   
   public class VideoPlayerView extends BaseView
   {
      
      public var myVideoPlayerPanel:VideoPanel;
      
      public function VideoPlayerView()
      {
         super();
         this.myVideoPlayerPanel.deactive();
      }
      
      override public function set routeData(data:*) : void
      {
         super.routeData = data;
         this.setUpVideo(data as VideoPlayerObj);
      }
      
      private function setUpVideo(videoConfig:VideoPlayerObj) : void
      {
         this.myVideoPlayerPanel.x = GameInfo.stagePosition.x + (GameInfo.stageSize.x - videoConfig.videoSize.x) * 0.5;
         this.myVideoPlayerPanel.y = GameInfo.stagePosition.y + (GameInfo.stageSize.y - videoConfig.videoSize.y) * 0.5;
         this.myVideoPlayerPanel.initVideoPanel(new Point(videoConfig.videoSize.x,videoConfig.videoSize.y),TutorialGuide.OVERLAY_ALPHA);
         if(videoConfig.drawScrim)
         {
            this.myVideoPlayerPanel.drawScrim();
         }
         this.myVideoPlayerPanel.fullscreenOffsetPoint = new Point(this.x,this.y);
         this.myVideoPlayerPanel.videoPath = videoConfig.videoPath;
         this.myVideoPlayerPanel.useLetterBox(videoConfig.useLetterBox);
         if(videoConfig.videoCover != null)
         {
            this.myVideoPlayerPanel.videoCoverImage = videoConfig.videoCover;
         }
         this.myVideoPlayerPanel.onVideoClosedCallback = this.closeView;
      }
      
      override protected function showView() : void
      {
         super.showView();
         this.myVideoPlayerPanel.active();
         this.myVideoPlayerPanel.playVideo();
      }
      
      private function closeView() : void
      {
         broadcast(BCEvent.EVT_CLOSE_POPUP_PAGE,{"pageID":_pageID});
      }
   }
}

