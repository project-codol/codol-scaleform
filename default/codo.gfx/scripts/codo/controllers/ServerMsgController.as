package codo.controllers
{
   import codo.base.BaseController;
   import codo.common.CFunctionCommonContainer;
   import codo.constants.BCCommonEvent;
   import codo.constants.BCEvent;
   import codo.constants.BCInGameEvent;
   import codo.constants.DataCommonID;
   import codo.constants.DataID;
   import codo.constants.MsgBtnCount;
   import codo.constants.PlayerAgeStatus;
   import codo.constants.ServerMessageDuration;
   import codo.constants.ServerMessageType;
   import codo.event.ParaEvent;
   import codo.localization.DictAAS;
   import codo.localization.DictChatting;
   import codo.localization.DictServer;
   import codo.localization.DictSummary;
   import codo.objects.ServerMessageObj;
   import codo.utils.LocalizeUtil;
   import codo.utils.Logger;
   import codo.utils.ScaleformUtil;
   import codo.utils.TimeUtil;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class ServerMsgController extends BaseController
   {
      
      public static const GET_AAS_RECORD_TIMER:uint = 300;
      
      public static const DELTA_TIME_MIN:Number = 0;
      
      public static const DELTA_TIME_MAX:Number = 5;
      
      public static const ONE_HOUR:Number = 3600;
      
      private var _ageStatus:uint = 0;
      
      private var _playedTime:Number = 0;
      
      private var _localPlayedTime:Number = 0;
      
      private var _elapsedTime:Number = 300;
      
      private var _firstTimeToShowAAS:Boolean = true;
      
      private var _bFetched:Boolean = false;
      
      private var _bFetchingAAS:Boolean = false;
      
      private var _bFetchedDuringInterval:Boolean = false;
      
      private var _isInGame:Boolean = false;
      
      private var _serverMessages:Array = [];
      
      public function ServerMsgController()
      {
         super();
      }
      
      override protected function onInitialized() : void
      {
         this.addDP(DataCommonID.IS_IN_GAME,this.getIsInGame);
         this.addDP(DataCommonID.BIG_LOUD_SPEAKER_ROLL_SPEED,this.getBigLoudSpeakerRollSpeed);
         this.addDP(DataCommonID.SMALL_LOUD_SPEAKER_ROLL_SPEED,this.getSmallLoudSpeakerRollSpeed);
         this.addDP(DataCommonID.HEROIC_TIER_ROLL_SPEED,this.getHeroicTierMessageRollSpeed);
         this.bind(DataID.TENCENT_GET_AAS_RECORD,this.onTencentAASRecordReceived);
         this.listen(BCEvent.EVT_PLAYER_STATS_READY,this.onPlayerStatsReadyHandle);
         this.listen(BCCommonEvent.EVT_NOTE_NOT_BUY_TRY_ON_ITEM,this.onNotBuyTryOnItemHandle);
         CFunctionCommonContainer.FetchServerMessage();
         if(!ScaleformUtil.isScaleform)
         {
            this.onTencentAASRecordReceived({"data":{
               "ageStatus":2,
               "gameplaySeconds":3595
            }});
            this.cppSetServerMessage("You receive a new message from Tencent",ServerMessageType.IDIP,ServerMessageDuration.IDIP);
            this.addServerMessage("You receive a new message from QQ",ServerMessageType.IDIP,ServerMessageDuration.IDIP);
            this.addServerMessage("You receive a new message from Activision",ServerMessageType.IDIP,ServerMessageDuration.IDIP,1);
         }
      }
      
      public function cppSetServerMessage(msg:String, type:uint, timeStamp:Number, priority:uint = 0) : void
      {
         var duration:Number = NaN;
         if(msg == null)
         {
            return;
         }
         var now:Object = CFunctionCommonContainer.GetCurrentTime();
         var nowUtc:uint = uint(now.utc);
         Logger.print("cppSetServerMessage, current timestamp is " + String(nowUtc) + " and target timeStamp is " + String(timeStamp));
         if(timeStamp >= nowUtc)
         {
            if(type == ServerMessageType.IDIP)
            {
               this.removeIDIPMessages();
               duration = ServerMessageDuration.IDIP;
            }
            this.addServerMessage(msg.indexOf("@SF_UI_") >= 0 ? LocalizeUtil.localize(msg) : msg,type,duration,priority);
         }
      }
      
      public function cppRefreshInGameLoadouts(msg:String) : void
      {
         if(msg == "lite")
         {
            this.broadcast(BCInGameEvent.CHARACTER_LOADOUT_RELOADED);
         }
         else
         {
            this.broadcast(BCInGameEvent.RELOAD_CHARACTER_LOADOUT);
         }
      }
      
      override public function update(deltaTime:Number) : void
      {
         if(this._isInGame || this._ageStatus == PlayerAgeStatus.ADULT)
         {
            return;
         }
         this._elapsedTime += deltaTime;
         if((this.checkLocalPlayedTime(deltaTime) || this._elapsedTime >= GET_AAS_RECORD_TIMER) && (this._ageStatus == PlayerAgeStatus.MINOR || this._ageStatus == PlayerAgeStatus.PENDING))
         {
            this._elapsedTime = 0;
            this._bFetched = true;
            this.retrieveAASRecord();
         }
      }
      
      private function removeIDIPMessages() : void
      {
         var i:int = 0;
         if(this._serverMessages.length > 0)
         {
            for(i = this._serverMessages.length - 1; i >= 0; i--)
            {
               if(Boolean(this._serverMessages[i]) && this._serverMessages[i].type == ServerMessageType.IDIP)
               {
                  this._serverMessages[i].timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onServerMessageTimerComplete);
                  this._serverMessages[i].timer.stop();
                  this._serverMessages[i].timer = null;
                  this._serverMessages.splice(i,1);
               }
            }
         }
      }
      
      private function addServerMessage(msg:String, type:uint, duration:Number, priority:uint = 0) : void
      {
         if(msg == null)
         {
            return;
         }
         if(msg.length <= 0)
         {
            this.setBindData(DataCommonID.SERVER_MESSAGES,this._serverMessages.concat());
            return;
         }
         var msgObj:ServerMessageObj = new ServerMessageObj();
         msgObj.message = msg;
         msgObj.type = type;
         msgObj.duration = duration;
         msgObj.priority = priority;
         if(msgObj.duration != ServerMessageDuration.INFINITE)
         {
            msgObj.timer = new Timer(msgObj.duration,1);
            msgObj.timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onServerMessageTimerComplete);
         }
         this._serverMessages.push(msgObj);
         this._serverMessages.sortOn("priority",Array.DESCENDING);
         this.setBindData(DataCommonID.SERVER_MESSAGES,this._serverMessages.concat());
      }
      
      private function onServerMessageTimerComplete(event:TimerEvent) : void
      {
         for(var i:int = 0; i < this._serverMessages.length; i++)
         {
            if(this._serverMessages[i].timer == event.target)
            {
               this._serverMessages[i].timer.stop();
               this._serverMessages[i].timer = null;
               this._serverMessages.splice(i,1);
               break;
            }
         }
      }
      
      private function onPlayerStatsReadyHandle(cEvt:ParaEvent) : void
      {
         if(!this.getDP(DataID.IS_TCLS_LOGON))
         {
            this._ageStatus = PlayerAgeStatus.ADULT;
         }
         this.notifyMuteInfo();
      }
      
      public function notifyMuteInfo() : void
      {
         var msg:String = null;
         if(!ScaleformUtil.isScaleform)
         {
            return;
         }
         var muteInfo:Object = getDP(DataID.GET_MUTEINFO) as Object;
         Logger.print("ServerMsgController::onPlayerStatsReadyHandle " + muteInfo.isMuted);
         if(Boolean(muteInfo != null) && Boolean(muteInfo.isMuted) && !muteInfo.bInformed)
         {
            if(Boolean(muteInfo.isPermanent))
            {
               msg = DictChatting.NOTE_PLAYER_MUTED_PERMANENT;
            }
            else
            {
               msg = LocalizeUtil.param(DictChatting.NOTE_PLAYER_MUTED,[muteInfo.year,muteInfo.month,muteInfo.day]);
            }
            showMsg(msg,MsgBtnCount.ONE);
         }
      }
      
      private function onNotBuyTryOnItemHandle(cEvt:ParaEvent) : void
      {
         this.addServerMessage(LocalizeUtil.localize(DictServer.NOTIFY_HAVNT_BUY_TRYON_ITEM),ServerMessageType.TRY_ON,ServerMessageDuration.TRY_ON);
      }
      
      private function checkLocalPlayedTime(deltaTime:Number) : Boolean
      {
         var j:Number = NaN;
         this._localPlayedTime += deltaTime;
         if(this._localPlayedTime > ONE_HOUR)
         {
            j = this._localPlayedTime % ONE_HOUR;
            if(j >= DELTA_TIME_MIN && j < DELTA_TIME_MAX)
            {
               if(!this._bFetchedDuringInterval)
               {
                  this._bFetchedDuringInterval = true;
                  return true;
               }
            }
         }
         return false;
      }
      
      public function set isInGame(cInGame:Boolean) : void
      {
         this._isInGame = cInGame;
      }
      
      private function getIsInGame() : Boolean
      {
         return this._isInGame;
      }
      
      private function getBigLoudSpeakerRollSpeed() : int
      {
         return getDvarInt("dw_bigLoudSpeakerRollSpeed");
      }
      
      private function getSmallLoudSpeakerRollSpeed() : int
      {
         return getDvarInt("dw_smallLoudSpeakerRollSpeed");
      }
      
      private function getHeroicTierMessageRollSpeed() : int
      {
         return getDvarInt("dw_heroicTierNotificationSpeed");
      }
      
      private function setFirstAASMsg() : void
      {
         var msg:String = null;
         if(this._isInGame || !this._firstTimeToShowAAS)
         {
            return;
         }
         if(this._bFetched && this._ageStatus == PlayerAgeStatus.MINOR)
         {
            this._firstTimeToShowAAS = false;
            msg = LocalizeUtil.localize(DictSummary.SUMMARY_TOTAL_TIME) + ": " + TimeUtil.timeToString(this._playedTime);
            this.showAAS(msg,true);
         }
      }
      
      private function retrieveAASRecord() : void
      {
         if(!this._bFetchingAAS)
         {
            this._bFetchingAAS = true;
            this.request(DataID.TENCENT_GET_AAS_RECORD);
         }
      }
      
      private function showAAS(cMsg:String, cLocalized:Boolean = false) : void
      {
         var msg:String = Boolean(LocalizeUtil.localize(DictAAS.AAS_SYSTEM) + cLocalized) ? cMsg : LocalizeUtil.localize(cMsg);
         this.addServerMessage(msg,ServerMessageType.AAS,ServerMessageDuration.AAS);
      }
      
      public function onTencentAASRecordReceived(cRes:Object) : void
      {
         if(cRes.data == null)
         {
            return;
         }
         var playedTime:Number = this._playedTime;
         this._bFetchingAAS = false;
         this._elapsedTime = this._bFetched ? 0 : this._elapsedTime;
         this._ageStatus = cRes.data.ageStatus;
         this._playedTime = cRes.data.gameplaySeconds;
         this._localPlayedTime = this._playedTime;
         if(this._bFetchedDuringInterval && this._localPlayedTime % ONE_HOUR > 3000)
         {
            this._bFetchedDuringInterval = false;
         }
         this.setFirstAASMsg();
         if(playedTime == this._playedTime || this._ageStatus != PlayerAgeStatus.MINOR)
         {
            return;
         }
         if(playedTime < ONE_HOUR && this._playedTime >= ONE_HOUR && this._playedTime < ONE_HOUR * 2)
         {
            this.showAAS(DictAAS.PLAYED_ONE_HOUR);
         }
         else if(playedTime < ONE_HOUR * 2 && this._playedTime >= ONE_HOUR * 2 && this._playedTime < ONE_HOUR * 3)
         {
            this.showAAS(DictAAS.PLAYED_TWO_HOUR);
         }
         else if(playedTime < ONE_HOUR * 3 && this._playedTime >= ONE_HOUR * 3 && this._playedTime < ONE_HOUR * 4)
         {
            this.showAAS(DictAAS.PLAYED_THREE_HOUR);
         }
         if((playedTime < ONE_HOUR * 3.5 && this._playedTime >= ONE_HOUR * 3.5 || playedTime < ONE_HOUR * 4 && this._playedTime >= ONE_HOUR * 4 || playedTime < ONE_HOUR * 4.5 && this._playedTime >= ONE_HOUR * 4.5) && this._playedTime < ONE_HOUR * 5)
         {
            this.showAAS(DictAAS.PLAYED_TIRED);
         }
         if(playedTime < ONE_HOUR * 5 && this._playedTime >= ONE_HOUR * 5 || playedTime < ONE_HOUR * 5.25 && this._playedTime >= ONE_HOUR * 5.25 || playedTime < ONE_HOUR * 5.5 && this._playedTime >= ONE_HOUR * 5.5 || playedTime < ONE_HOUR * 5.75 && this._playedTime >= ONE_HOUR * 5.75 || playedTime < ONE_HOUR * 6 && this._playedTime >= ONE_HOUR * 6 || playedTime < ONE_HOUR * 6.25 && this._playedTime >= ONE_HOUR * 6.25 || playedTime < ONE_HOUR * 6.5 && this._playedTime >= ONE_HOUR * 6.5 || playedTime < ONE_HOUR * 6.75 && this._playedTime >= ONE_HOUR * 6.75 || playedTime < ONE_HOUR * 7 && this._playedTime >= ONE_HOUR * 7 || playedTime < ONE_HOUR * 7.25 && this._playedTime >= ONE_HOUR * 7.25 || playedTime < ONE_HOUR * 7.5 && this._playedTime >= ONE_HOUR * 7.5 || playedTime < ONE_HOUR * 7.75 && this._playedTime >= ONE_HOUR * 7.75 || playedTime < ONE_HOUR * 8 && this._playedTime >= ONE_HOUR * 8 || playedTime < ONE_HOUR * 8.25 && this._playedTime >= ONE_HOUR * 8.25 || playedTime < ONE_HOUR * 8.5 && this
         ._playedTime >= ONE_HOUR * 8.5 || playedTime < ONE_HOUR * 8.75 && this._playedTime >= ONE_HOUR * 8.75 || playedTime < ONE_HOUR * 9 && this._playedTime >= ONE_HOUR * 9 || playedTime < ONE_HOUR * 9.25 && this._playedTime >= ONE_HOUR * 9.25 || playedTime < ONE_HOUR * 9.5 && this._playedTime >= ONE_HOUR * 9.5 || playedTime < ONE_HOUR * 9.75 && this._playedTime >= ONE_HOUR * 9.75 || playedTime < ONE_HOUR * 10 && this._playedTime >= ONE_HOUR * 10 || playedTime < ONE_HOUR * 10.25 && this._playedTime >= ONE_HOUR * 10.25 || playedTime < ONE_HOUR * 10.5 && this._playedTime >= ONE_HOUR * 10.5 || playedTime < ONE_HOUR * 10.75 && this._playedTime >= ONE_HOUR * 10.75 || playedTime < ONE_HOUR * 11 && this._playedTime >= ONE_HOUR * 11 || playedTime < ONE_HOUR * 11.25 && this._playedTime >= ONE_HOUR * 11.25 || playedTime < ONE_HOUR * 11.5 && this._playedTime >= ONE_HOUR * 11.5 || playedTime < ONE_HOUR * 11.75 && this._playedTime >= ONE_HOUR * 11.75 || this._playedTime >= ONE_HOUR * 12)
         {
            this.showAAS(DictAAS.PLAYED_UNHEALTHY);
         }
      }
   }
}

