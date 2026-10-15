package codo.views
{
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.event.ParaEvent;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   
   public class ServerMessageView extends InGameServerMessageView
   {
      
      private static const BACKGROUND_TAB_WIDTH:Number = 8;
      
      public var myBackground:MovieClip;
      
      public var mySystemMessageBackground:MovieClip;
      
      private var _visibleAreaDict:Dictionary = new Dictionary();
      
      public function ServerMessageView()
      {
         super();
      }
      
      override protected function initStage() : void
      {
         _isInGame = false;
         super.initStage();
         x = 110;
         y = 11;
         _defaultArea = new Rectangle(182,0,790,25);
         _visibleRect = _defaultArea;
         adjustMaskArea();
         this.myBackground.width = 16;
         this.myBackground.alpha = 0;
         this.myBackground.x = _visibleRect.x + _visibleRect.width;
         this.mySystemMessageBackground.width = 16;
         this.mySystemMessageBackground.alpha = 0;
         this.mySystemMessageBackground.x = _visibleRect.x + _visibleRect.width;
      }
      
      override protected function enableData() : void
      {
         super.enableData();
         listen(BCEvent.EVT_SHOW_PERSISTENT_VIEW,this.onShowEvt);
         listen(BCEvent.EVT_HIDE_PERSISTENT_VIEW,this.onHideEvt);
      }
      
      override protected function disableData() : void
      {
         super.disableData();
         unlisten(BCEvent.EVT_SHOW_PERSISTENT_VIEW,this.onShowEvt);
         unlisten(BCEvent.EVT_HIDE_PERSISTENT_VIEW,this.onHideEvt);
      }
      
      private function onMainPageChangeHandle(cEvt:ParaEvent) : void
      {
         var currentPage:String = this.getDP(DataID.CURRENT_MAIN_PAGE_ID);
         if(this._visibleAreaDict.hasOwnProperty(currentPage))
         {
            _visibleRect = this._visibleAreaDict[currentPage];
         }
         else
         {
            _visibleRect = _defaultArea;
         }
         adjustMaskArea();
      }
      
      override protected function startLoudSpeaker() : void
      {
         super.startLoudSpeaker();
         this.adjustBackgroundPosition();
      }
      
      override protected function endLoudSpeaker() : void
      {
         super.endLoudSpeaker();
         TweenLite.to(this.myBackground,0.25,{
            "alpha":0,
            "x":_visibleRect.x + _visibleRect.width,
            "width":BACKGROUND_TAB_WIDTH
         });
         this.adjustBackgroundPosition();
      }
      
      override protected function startAnnouncement() : void
      {
         super.startAnnouncement();
         this.adjustBackgroundPosition();
      }
      
      override protected function endAnnouncement() : void
      {
         super.endAnnouncement();
         TweenLite.to(this.mySystemMessageBackground,0.25,{
            "alpha":0,
            "x":_visibleRect.x + _visibleRect.width,
            "width":BACKGROUND_TAB_WIDTH
         });
         this.adjustBackgroundPosition();
      }
      
      private function onShowEvt(myPara:ParaEvent) : void
      {
         visible = true;
      }
      
      private function onHideEvt(myPara:ParaEvent) : void
      {
         visible = false;
      }
      
      private function adjustBackgroundPosition() : void
      {
         if(_announcementShowing)
         {
            TweenLite.to(this.mySystemMessageBackground,0.25,{
               "alpha":1,
               "x":myAnnouncementMask.x - BACKGROUND_TAB_WIDTH * 0.5,
               "width":myAnnouncementMask.width + BACKGROUND_TAB_WIDTH
            });
         }
         if(_loudSpeakerShowing)
         {
            TweenLite.to(this.myBackground,0.25,{
               "alpha":1,
               "x":myBigLoudSpeakerMask.x - BACKGROUND_TAB_WIDTH * 0.5,
               "width":myBigLoudSpeakerMask.width + BACKGROUND_TAB_WIDTH
            });
         }
      }
   }
}

