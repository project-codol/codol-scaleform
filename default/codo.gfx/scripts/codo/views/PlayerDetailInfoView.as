package codo.views
{
   import codo.base.BaseView;
   import codo.component.playerinfo_part.ErrorPage;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.objects.PlayerBasicInfoObj;
   import codo.utils.PlayerBasicInfoQueryUtil;
   import codo.views.playerDetailInfo_parts.PlayerDetailInfoContent;
   import flash.display.MovieClip;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class PlayerDetailInfoView extends BaseView
   {
      
      public static const FAKE_LOADING_DURATION:int = 3000;
      
      public var myContent:PlayerDetailInfoContent;
      
      public var myLoading:MovieClip;
      
      public var myErrorContent:ErrorPage;
      
      private var mCoolDownTimer:Timer;
      
      private var mCoolDownFlag:Boolean = false;
      
      private var mDataFlag:Boolean = false;
      
      private var mErrorFlag:Boolean = false;
      
      private var mPlayerInfoQueryUtil:PlayerBasicInfoQueryUtil;
      
      public function PlayerDetailInfoView()
      {
         super();
         this.mCoolDownTimer = new Timer(FAKE_LOADING_DURATION,1);
         this.mPlayerInfoQueryUtil = new PlayerBasicInfoQueryUtil();
         this.mPlayerInfoQueryUtil.registerPlayerBasicInfoHandler(this.onPlayerBasicInfo);
         this.myErrorContent.x = 0;
         this.myErrorContent.y = 0;
      }
      
      private function onCoolDownComplete() : void
      {
         this.mCoolDownFlag = true;
         this.resetTimer();
         this.tryToShowContent();
      }
      
      private function onDataReceived() : void
      {
         this.mDataFlag = true;
         this.mErrorFlag = false;
         this.tryToShowContent();
      }
      
      private function onDataFailed() : void
      {
         this.mDataFlag = true;
         this.mErrorFlag = true;
         this.tryToShowContent();
      }
      
      override protected function showView() : void
      {
         super.showView();
         this.mCoolDownFlag = false;
         this.mDataFlag = false;
         this.mErrorFlag = false;
         bind(DataID.PLAYER_QUERY_INFO,this.onBindShowPlayerInfo);
         this.mCoolDownTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onCoolDownComplete);
         this.mCoolDownTimer.reset();
         this.mCoolDownTimer.start();
         this.switchShowContent(false);
         this.mPlayerInfoQueryUtil.queryPlayerBasicInfo([getDP(DataID.REQUESTED_DETAIL_PLAYER_ID)]);
      }
      
      private function onBindShowPlayerInfo(cRes:Object) : void
      {
         if(!cRes.data.isSuccess)
         {
            this.onDataFailed();
            return;
         }
         var data:Object = cRes.data.content;
         this.myContent.setData(data);
         this.updatePartialBasicInfoByProfile(data);
         this.onDataReceived();
      }
      
      override protected function hideView() : void
      {
         this.resetTimer();
         this.myContent.deactive();
         super.hideView();
      }
      
      private function resetTimer() : void
      {
         this.mCoolDownTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onCoolDownComplete);
         this.mCoolDownTimer.reset();
      }
      
      private function onCloseButtonClicked() : void
      {
         broadcast(BCEvent.EVT_CLOSE_POPUP_PAGE,{"pageID":_pageID});
      }
      
      private function tryToShowContent() : void
      {
         if(this.mCoolDownFlag && this.mDataFlag)
         {
            this.switchShowContent(true,this.mErrorFlag);
         }
      }
      
      private function switchShowContent(show:Boolean, error:Boolean = false) : void
      {
         this.myLoading.visible = !show;
         if(show && error)
         {
            this.myErrorContent.active();
         }
         else
         {
            this.myErrorContent.deactive();
         }
         if(show && !error)
         {
            this.myContent.active();
         }
         else
         {
            this.myContent.deactive();
         }
      }
      
      public function onPlayerBasicInfo(info:PlayerBasicInfoObj) : void
      {
         if(!info.available)
         {
            return;
         }
         if(info.entityID == getDP(DataID.REQUESTED_DETAIL_PLAYER_ID))
         {
            this.myContent.setPlayerBasicInfoData(info);
            this.updatePartialBasicInfoByLeaderBoard(info);
         }
      }
      
      private function updatePartialBasicInfoByProfile(data:Object) : void
      {
         var outgoingData:Object = new Object();
         outgoingData.type = 0;
         outgoingData.userId = getDP(DataID.REQUESTED_DETAIL_PLAYER_ID);
         outgoingData.userName = getDP(DataID.REQUESTED_DETAIL_PLAYER_NAME);
         outgoingData.rank = data.rank;
         outgoingData.prestige = data.prestige;
         outgoingData.background = data.playerCard.background.id;
         outgoingData.title = data.playerCard.cardTitle.id;
         outgoingData.icon = data.playerCard.cardIcon.id;
         outgoingData.namePlate = data.playerCard.cardNameplate.id;
         outgoingData.frame = data.playerCard.cardFrame.id;
         broadcast(BCEvent.UPDATE_PARTIAL_BASIC_INFO,outgoingData);
      }
      
      private function updatePartialBasicInfoByLeaderBoard(data:PlayerBasicInfoObj) : void
      {
         var outgoingData:Object = new Object();
         outgoingData.type = 1;
         outgoingData.userId = data.entityID;
         outgoingData.userName = data.entityName;
         outgoingData.clanId = data.clanId;
         outgoingData.clanName = data.clanName;
         outgoingData.wargodScore = data.wargodScore;
         outgoingData.wargodSeason = data.wargodSeason;
         broadcast(BCEvent.UPDATE_PARTIAL_BASIC_INFO,outgoingData);
      }
   }
}

