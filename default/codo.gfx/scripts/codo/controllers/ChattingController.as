package codo.controllers
{
   import codo.base.BaseController;
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.constants.*;
   import codo.event.ParaEvent;
   import codo.localization.DictAAS;
   import codo.localization.DictChatting;
   import codo.localization.DictParty;
   import codo.localization.DictSystem;
   import codo.localization.DictWarGod;
   import codo.objects.ChatChannelObj;
   import codo.objects.ChatMessageObj;
   import codo.objects.PlayerObj;
   import codo.objects.ProductObj;
   import codo.objects.UserObj;
   import codo.utils.LocalizeUtil;
   import codo.utils.Logger;
   import codo.utils.ScaleformUtil;
   import codo.utils.StringUtil;
   import codo.utils.TimeUtil;
   import codo.views.ChatView;
   import com.society.comscore.DAXDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class ChattingController extends BaseController
   {
      
      private static const MAX_BIG_LOUD_SPEAKER_SIZE:int = 100;
      
      private static const SMALL_LOUD_SPEAKER_ID:int = 50002;
      
      private static const BIG_LOUD_SPEAKER_ID:int = 50003;
      
      private static const SMALL_LOUD_SPEAKER_ITEM_ID:String = "small_loudspeaker";
      
      private static const BIG_LOUD_SPEAKER_ITEM_ID:String = "big_loudspeaker";
      
      private static const MAX_REPETITIVE_MSG_NUM:uint = 3;
      
      private static const MAX_HISTORY_COLLECTED:int = 5;
      
      private var _lastSendMsgTime:Number = 0;
      
      private var _lastSendMsgs:Array = [];
      
      private var _chatMsgToSend:ChatMessageObj;
      
      private var _chatChannels:Array = [];
      
      private var _unreadPrivateMsgCount:int = 0;
      
      private var _bigLoudSpeakerPostBuffer:Vector.<Object> = new Vector.<Object>();
      
      private var reserveChatChannelID:uint;
      
      private var _sendingLoudSpeaker:Boolean = false;
      
      private var _globalChatRetryCount:int;
      
      private var _bigLoudSpeakerJoinRetryCount:int;
      
      private var _globalChatJoinRetryTimer:Timer;
      
      private var _bigLoudSpeakerJoinRetryTimer:Timer;
      
      private var _afterBrokenRetryTimer:Timer;
      
      private var _globalChatIsBroken:Boolean = false;
      
      private var _isGlobalChatAfterBrokenRetry:Boolean = false;
      
      private var _isBigSpeakerAfterBrokenRetry:Boolean = false;
      
      private var _isChatViewReady:Boolean = false;
      
      private var _isServerMessageViewReady:Boolean = false;
      
      public function ChattingController()
      {
         super();
      }
      
      override protected function onInitialized() : void
      {
         var rejoinGlobalChatRetryInterval:int = getDvarInt("dw_globalChatRejoinInterval");
         var afterBrokenRetryInterval:int = getDvarInt("dw_afterBrokenReconnectionInterval");
         this._globalChatJoinRetryTimer = new Timer(rejoinGlobalChatRetryInterval,1);
         this._bigLoudSpeakerJoinRetryTimer = new Timer(rejoinGlobalChatRetryInterval,1);
         this._afterBrokenRetryTimer = new Timer(afterBrokenRetryInterval);
         this.addDP(DataID.CHAT_CHANNEL_OBJ,this.getChannelObjByID);
         this.addDP(DataID.BIG_LOUD_SPEAKER_COUNT,this.getBigLoudSpeakerCount);
         this.addDP(DataID.SMALL_LOUD_SPEAKER_COUNT,this.getSmallLoudSpeakerCount);
         this.addDP(DataID.IS_IN_GLOBAL_CHANNEL,this.getIsInGlobalChannel);
         this.addDP(DataID.IS_IN_BIG_SPEAKER_CHANNEL,this.getIsInBigSpeakerChannel);
         this.addDP(DataID.BIG_LOUD_SPEAKER_MESSAGE_LEN,this.getBigLoudSpeakerMessageLen);
         this.addDP(DataID.SMALL_LOUD_SPEAKER_MESSAGE_LEN,this.getSmallLoudSpeakerMessageLen);
         this.addDP(DataID.GLOBAL_CHAT_MESSAGE_LEN,this.getGlobalChatMessageLen);
         this.addDP(DataID.BIG_LOUD_SPEAKER_COOLDOWN,this.getBigLoudSpeakerCoolDown);
         this.addDP(DataID.SMALL_LOUD_SPEAKER_COOLDOWN,this.getSmallLoudSpeakerCoolDown);
         this.addDP(DataID.JOINED_GLOBAL_CHAT_GROUP,this.getJoinedGlobalChatGroup);
         this.addDP(DataID.IS_GLOBAL_CHAT_LOCKED,this.getIsGlobalChatLocked);
         this.addDP(DataID.IS_GLOBAL_CHAT_BROKEN,this.getIsGlobalChatBroken);
         this.addDP(DataID.GET_RECENT_CHAT_MESSAGES,this.getRecentChatMessages);
         this.addDP(DataCommonID.BIG_LOUD_SPEAKER_SHOW_DURATION,this.getBigLoudSpeakerShowDuration);
         this.addDP(DataCommonID.SMALL_LOUD_SPEAKER_SHOW_DURATION,this.getSmallLoudSpeakerShowDuration);
         this.addDP(DataCommonID.HEROIC_TIER_SHOW_DURATION,this.getHeroicTierShowDuration);
         this.listen(BCEvent.PARTY_JOINED,this.onPartyJoinedHandle);
         this.listen(BCEvent.PARTY_LEFT,this.onPartyLeftHandle);
         this.listen(BCEvent.ON_ROOM_JOINED,this.onRoomJoinedHandle);
         this.listen(BCEvent.ON_ROOM_LEFT,this.onRoomLeftHandle);
         this.listen(BCEvent.EVT_ON_CLAN_JOINED,this.onClanJoinedHandle);
         this.listen(BCEvent.EVT_ON_CLAN_LEFT,this.onClanLeftHandle);
         this.listen(BCEvent.EVT_START_PRIVATE_CHAT,this.onStartPrivateChattingHandle);
         this.listen(BCEvent.EVT_CLOSE_PRIVATE_CHAT,this.onClosePrivateChattingHandle);
         this.listen(BCEvent.EVT_PLAYER_STATS_READY,this.onPlayerStatsReadyHandle);
         this.listen(BCEvent.EVT_SEND_CHAT_MSG,this.onSendChatMsgHandle);
         this.listen(BCEvent.EVT_CHAT_MSG_FROM_SYSTEM,this.onReceiveSystemChatMsgHandle);
         this.listen(BCCommonEvent.EVT_ON_STRING_SANITIZED,this.onChatMsgSanitizedHandle);
         this.listen(BCEvent.EVT_READ_MSG_COUNT,this.updatePrivateChatUnreadMsgState);
         this.listen(BCEvent.EVT_ON_CHAT_VIEW_READY,this.onChatViewReady);
         this.listen(BCEvent.EVT_REQUEST_PURCHASE_LOUD_SPEAKER,this.onRequestPurchaseLoudSpeaker);
         this.listen(BCEvent.EVT_SEND_LOUD_SPEAKER,this.onSendLoudSpeaker);
         this.listen(BCCommonEvent.EVT_HIDE_SPEAKER_ANIMATION,this.onHideBigSpeakAnimation);
         this.listen(BCEvent.EVT_CHAT_VIEW_READY_STATE_CHANGE,this.onChatViewReadyStateChange);
         this.listen(BCEvent.EVT_SERVER_MESSAGE_VIEW_READY_STATE_CHANGE,this.onServerMessageViewReadyStateChange);
         this.bind(DataID.EAsyncTaskID_Demonware,this.bind_demonwareChattingStatusChange);
      }
      
      public function cppOnLoudSpeakerMessageSendComplete(isSuccess:Boolean, errorMsg:String, loudSpeakerType:int) : void
      {
         this._sendingLoudSpeaker = false;
         if(isSuccess)
         {
            broadcast(BCEvent.EVT_LOUD_SPEAKER_SEND_SUCCESS,loudSpeakerType);
            broadcast(BCEvent.EVT_MARKET_UPDATE_INVENTORY);
         }
         else
         {
            showMsg(errorMsg,MsgBtnCount.ONE);
         }
      }
      
      public function cppSetWarGodHeroicTierNotification(senderName:String) : void
      {
         var message:String = LocalizeUtil.param(DictWarGod.WARGOD_SOMEONE_GET_HEROIC_TIER,[senderName]);
         Logger.print("cppSetWarGodHeroicTierNotification",senderName);
         var msgObj:ChatMessageObj = new ChatMessageObj();
         msgObj.message = message;
         msgObj.loudSpeakerType = ChatSpeakerType.HEROIC_TIER_NOTIFICATION;
         if(!this.isChatMessageViewReady())
         {
            return;
         }
         if(this._bigLoudSpeakerPostBuffer.length >= MAX_BIG_LOUD_SPEAKER_SIZE)
         {
            return;
         }
         this._bigLoudSpeakerPostBuffer.push(msgObj);
         if(this._bigLoudSpeakerPostBuffer.length == 1)
         {
            broadcast(BCCommonEvent.EVT_SHOW_SPEAKER_ANIMATION,this._bigLoudSpeakerPostBuffer[0]);
         }
      }
      
      public function cppOnMessageReceived(msg:Object) : void
      {
         var msgObj:ChatMessageObj = new ChatMessageObj(msg);
         var tempMyUserInfo:PlayerObj = PlayerObj.getObj();
         msgObj.receiverID = tempMyUserInfo.id;
         if(msgObj.channelID == ChattingChannelType.PRIVATE)
         {
            if(msgObj.senderID == tempMyUserInfo.id)
            {
               msgObj.channelName = msgObj.targetName;
            }
            else
            {
               msgObj.channelName = msgObj.senderName;
               this.addChatChannel(msgObj.channelID,msgObj.senderName,msgObj.senderID,msgObj.isNew);
               if(msgObj.isNew)
               {
                  ++this._unreadPrivateMsgCount;
                  this.setBindData(DataID.HAS_UNREAD_MSG,{"unreadCount":this._unreadPrivateMsgCount});
               }
            }
         }
         if(msgObj.senderID == tempMyUserInfo.id)
         {
            msgObj.selfSend = true;
         }
         else
         {
            msgObj.selfSend = false;
         }
         if(msgObj.channelID == ChattingChannelType.GLOBAL && (msgObj.loudSpeakerType == ChatSpeakerType.SPEAKER_TYPE_BIG || msgObj.loudSpeakerType == ChatSpeakerType.SPEAKER_TYPE_SMALL))
         {
            if(!this.isChatMessageViewReady())
            {
               return;
            }
            if(this._bigLoudSpeakerPostBuffer.length >= MAX_BIG_LOUD_SPEAKER_SIZE)
            {
               return;
            }
            this._bigLoudSpeakerPostBuffer.push(msgObj);
            if(this._bigLoudSpeakerPostBuffer.length == 1)
            {
               broadcast(BCCommonEvent.EVT_SHOW_SPEAKER_ANIMATION,this._bigLoudSpeakerPostBuffer[0]);
            }
         }
         if(msgObj.isSystem)
         {
            msgObj.senderName = this.localize(DictAAS.AAS_SYSTEM);
         }
         this.receiveChatMsg(msgObj);
      }
      
      private function onHideBigSpeakAnimation(evt:ParaEvent) : void
      {
         this._bigLoudSpeakerPostBuffer.shift();
         if(this._bigLoudSpeakerPostBuffer.length > 0)
         {
            broadcast(BCCommonEvent.EVT_SHOW_SPEAKER_ANIMATION,this._bigLoudSpeakerPostBuffer[0]);
         }
      }
      
      public function cppOnMessageMuted(muteType:uint) : void
      {
         var msgObj:ChatMessageObj = new ChatMessageObj();
         msgObj.senderName = this.localize(DictAAS.AAS_SYSTEM);
         msgObj.message = this.localize(DictChatting.NOTE_CHATTING_MUTED);
         msgObj.formatedTime = TimeUtil.now();
         msgObj.isSystem = true;
         switch(muteType)
         {
            case ChattingMuteType.ROOM:
               if(this.reserveChatChannelID == ChattingChannelType.ROOM_TEAM)
               {
                  msgObj.channelID = ChattingChannelType.ROOM_TEAM;
               }
               else
               {
                  msgObj.channelID = ChattingChannelType.ROOM;
               }
               break;
            case ChattingMuteType.PARTY:
               msgObj.channelID = ChattingChannelType.PARTY;
               break;
            case ChattingMuteType.PRIVATE:
               msgObj.channelID = ChattingChannelType.PRIVATE;
         }
         this.receiveChatMsg(msgObj);
      }
      
      private function updatePrivateChatUnreadMsgState(cEvt:ParaEvent) : void
      {
         var readCount:int = int(cEvt.myPara.readCount);
         this._unreadPrivateMsgCount -= readCount;
         this.setBindData(DataID.HAS_UNREAD_MSG,{"unreadCount":this._unreadPrivateMsgCount});
      }
      
      public function cppOnTryJoinGlobalChatComplete(isSuccess:Boolean) : void
      {
         Logger.print("Join global chat complete. ",isSuccess);
         if(isSuccess)
         {
            this.resetGlobalChatRetryCount();
            this.tryResetBrokenFlag();
            this.addChatChannel(ChattingChannelType.GLOBAL);
            broadcast(BCEvent.EVT_JOINED_GLOBAL_CHAT);
         }
         else if(!this._isGlobalChatAfterBrokenRetry)
         {
            this._globalChatJoinRetryTimer.addEventListener(TimerEvent.TIMER,this.onRejoinTimerHit);
            this._globalChatJoinRetryTimer.start();
         }
         this._isGlobalChatAfterBrokenRetry = false;
      }
      
      public function cppOnGlobalChatDisconnected() : void
      {
         if(this._globalChatJoinRetryTimer.running)
         {
            return;
         }
         broadcast(BCEvent.EVT_GLOBAL_CHAT_DISCONNECT);
         this._globalChatJoinRetryTimer.addEventListener(TimerEvent.TIMER,this.onRejoinTimerHit);
         this._globalChatJoinRetryTimer.start();
      }
      
      public function cppOnTryJoinBigSpeakerComplete(isSuccess:Boolean) : void
      {
         Logger.print("Join big loud speaker complete",isSuccess);
         if(isSuccess)
         {
            this.resetBigLoudSpeakerRetryCount();
            this.tryResetBrokenFlag();
            broadcast(BCEvent.EVT_JOINED_BIG_LOUD_SPEAKER);
         }
         else if(!this._isBigSpeakerAfterBrokenRetry)
         {
            this._bigLoudSpeakerJoinRetryTimer.addEventListener(TimerEvent.TIMER,this.onRejoinTimerHit);
            this._bigLoudSpeakerJoinRetryTimer.start();
         }
         this._isBigSpeakerAfterBrokenRetry = false;
      }
      
      public function cppOnBigSpeakerDisconnected() : void
      {
         if(this._bigLoudSpeakerJoinRetryTimer.running)
         {
            return;
         }
         broadcast(BCEvent.EVT_BIG_SPEAKER_DISCONNECT);
         this._bigLoudSpeakerJoinRetryTimer.addEventListener(TimerEvent.TIMER,this.onRejoinTimerHit);
         this._bigLoudSpeakerJoinRetryTimer.start();
      }
      
      private function onRejoinTimerHit(e:TimerEvent) : void
      {
         var timer:Timer = e.target as Timer;
         timer.stop();
         timer.reset();
         timer.removeEventListener(TimerEvent.TIMER,this.onRejoinTimerHit);
         if(timer == this._globalChatJoinRetryTimer)
         {
            if(this._globalChatRetryCount < this.getChannelConnectionRetryCount())
            {
               ++this._globalChatRetryCount;
               CFunctionContainer.JoinGlobalChannel();
            }
            else
            {
               this.resetGlobalChatRetryCount();
               this.setGlobalChatIsBroken();
            }
         }
         else if(timer == this._bigLoudSpeakerJoinRetryTimer)
         {
            if(this._bigLoudSpeakerJoinRetryCount < this.getChannelConnectionRetryCount())
            {
               ++this._bigLoudSpeakerJoinRetryCount;
               CFunctionContainer.JoinBigSpeakerChannel();
            }
            else
            {
               this.resetBigLoudSpeakerRetryCount();
               this.setGlobalChatIsBroken();
            }
         }
      }
      
      private function setGlobalChatIsBroken() : void
      {
         CFunctionContainer.SendGlobalChatBrokenTLog();
         this._globalChatIsBroken = true;
         broadcast(BCEvent.EVT_GLOBAL_CHAT_BROKEN_STATE_CHANGED);
         this.triggerAfterBrokenRetry();
      }
      
      private function triggerAfterBrokenRetry() : void
      {
         this._afterBrokenRetryTimer.addEventListener(TimerEvent.TIMER,this.onAfterBrokenRetry);
         this._afterBrokenRetryTimer.start();
      }
      
      private function onAfterBrokenRetry(e:TimerEvent) : void
      {
         if(!this._globalChatIsBroken)
         {
            this._afterBrokenRetryTimer.stop();
            this._afterBrokenRetryTimer.reset();
            this._afterBrokenRetryTimer.removeEventListener(TimerEvent.TIMER,this.onAfterBrokenRetry);
         }
         else
         {
            this._isGlobalChatAfterBrokenRetry = true;
            this._isBigSpeakerAfterBrokenRetry = true;
            this.startJoinGlobalAndBigSpeakerChannel();
         }
      }
      
      private function onPartyJoinedHandle(cEvt:ParaEvent) : void
      {
         this.addChatChannel(ChattingChannelType.PARTY);
      }
      
      private function onPartyLeftHandle(cEvt:ParaEvent) : void
      {
         this.removeChatChannel(ChattingChannelType.PARTY);
      }
      
      private function onRoomJoinedHandle(cEvt:ParaEvent) : void
      {
         if(Boolean(cEvt.myPara.success))
         {
            this.addChatChannel(ChattingChannelType.ROOM);
            this.addChatChannel(ChattingChannelType.ROOM_TEAM);
         }
      }
      
      private function onRoomLeftHandle(cEvt:ParaEvent) : void
      {
         this.removeChatChannel(ChattingChannelType.ROOM);
      }
      
      private function onClanJoinedHandle(cEvt:ParaEvent) : void
      {
         this.addChatChannel(ChattingChannelType.CLAN);
      }
      
      private function onClanLeftHandle(cEvt:ParaEvent) : void
      {
         this.removeChatChannel(ChattingChannelType.CLAN);
      }
      
      private function onStartPrivateChattingHandle(cEvt:ParaEvent) : void
      {
         var strTagName:String = cEvt.myPara.name;
         CFunctionContainer.ReserveChatChannel(ChattingChannelType.PRIVATE,strTagName,cEvt.myPara.id);
         this.addChatChannel(ChattingChannelType.PRIVATE,strTagName,cEvt.myPara.id,true,true);
         this.broadcast(BCEvent.EVT_OPEN_CHAT_WINDOW,{
            "firstLevelIndex":ChatView.PRIVATE_CHANNEL_INDEX,
            "secondLevelData":cEvt.myPara.id
         });
      }
      
      private function onClosePrivateChattingHandle(cEvt:ParaEvent) : void
      {
         var unreadMsg:int = 0;
         var i:int = 0;
         var index:int = 0;
         var channel:ChatChannelObj = cEvt.myPara.channel;
         if(Boolean(channel))
         {
            unreadMsg = 0;
            for(i = 0; i < channel.msgHistory.length; i++)
            {
               if(channel.msgHistory[i].isNew == true)
               {
                  unreadMsg++;
               }
            }
            this._unreadPrivateMsgCount -= unreadMsg;
            this.setBindData(DataID.HAS_UNREAD_MSG,{"unreadCount":this._unreadPrivateMsgCount});
            index = this._chatChannels.indexOf(channel);
            if(index != -1)
            {
               this._chatChannels.splice(index,1);
            }
            this.removeChatChannel(channel.id,channel.targetName,channel.targetID);
            this.setBindData(DataID.CHAT_CHANNELS,this._chatChannels);
         }
      }
      
      private function onSendChatMsgHandle(cEvt:ParaEvent) : void
      {
         var completeChannelObj:ChatChannelObj = null;
         var channel:ChatChannelObj = cEvt.myPara.channel;
         var msg:String = cEvt.myPara.message;
         if(!this.canSendChatMsg(channel,msg))
         {
            return;
         }
         msg = msg.split("<").join("&lt;");
         msg = msg.split(">").join("&gt;");
         var tempMyUserInfo:PlayerObj = PlayerObj.getObj();
         completeChannelObj = this.getChannelObjByID(channel.id);
         if(completeChannelObj != null)
         {
            this._chatMsgToSend = new ChatMessageObj();
            this._chatMsgToSend.channelID = channel.id;
            this._chatMsgToSend.channelName = channel.name;
            this._chatMsgToSend.receiverName = completeChannelObj.targetName;
            this._chatMsgToSend.receiverID = channel.targetID;
            this._chatMsgToSend.senderName = this.getDP(DataID.PLAYER_NAME_WITH_CLANTAG);
            this._chatMsgToSend.senderID = tempMyUserInfo.id;
            this._chatMsgToSend.message = msg;
            this._chatMsgToSend.targetID = channel.targetID;
            this._chatMsgToSend.targetName = channel.targetName;
            this._chatMsgToSend.selfSend = true;
            this._chatMsgToSend.targetLevel = completeChannelObj.targetLevel;
         }
         else
         {
            this._chatMsgToSend = new ChatMessageObj();
            this._chatMsgToSend.channelID = channel.id;
            this._chatMsgToSend.channelName = channel.name;
            this._chatMsgToSend.receiverName = channel.targetName;
            this._chatMsgToSend.receiverID = channel.targetID;
            this._chatMsgToSend.senderName = this.getDP(DataID.PLAYER_NAME_WITH_CLANTAG);
            this._chatMsgToSend.senderID = tempMyUserInfo.id;
            this._chatMsgToSend.message = msg;
            this._chatMsgToSend.targetID = channel.targetID;
            this._chatMsgToSend.targetName = channel.targetName;
            this._chatMsgToSend.selfSend = true;
            this._chatMsgToSend.targetLevel = 0;
         }
         if(!ScaleformUtil.isScaleform)
         {
            this.receiveChatMsg(this._chatMsgToSend);
         }
         if(this._chatMsgToSend.channelID == ChattingChannelType.PRIVATE || this._chatMsgToSend.channelID == ChattingChannelType.CLAN)
         {
            this.broadcast(BCCommonEvent.EVT_SANITIZE_STRING,{
               "type":SanitizedType.CHATTING_MSG,
               "content":this._chatMsgToSend.message
            });
         }
         this.comScoreLogging("action_type","send_message");
         this.reserveChatChannelID = channel.id;
         CFunctionContainer.SendChatMessage(this._chatMsgToSend);
      }
      
      private function comScoreLogging(action:String, value:String) : void
      {
         try
         {
            DAXDispatcher.queue(action,value);
            DAXDispatcher.dispatch();
         }
         catch(e:Error)
         {
            Logger.print("** DAXDispatcher: " + e.message);
         }
      }
      
      private function onReceiveSystemChatMsgHandle(cEvt:ParaEvent) : void
      {
         this.receiveChatMsg(cEvt.myPara);
      }
      
      private function resetGlobalChatRetryCount() : void
      {
         this._globalChatRetryCount = 0;
      }
      
      private function resetBigLoudSpeakerRetryCount() : void
      {
         this._bigLoudSpeakerJoinRetryCount = 0;
      }
      
      private function tryResetBrokenFlag() : void
      {
         var newState:Boolean = !(this.getIsInGlobalChannel() && this.getIsInBigSpeakerChannel());
         if(this._globalChatIsBroken != newState)
         {
            this._globalChatIsBroken = newState;
            broadcast(BCEvent.EVT_GLOBAL_CHAT_BROKEN_STATE_CHANGED);
         }
      }
      
      private function onPlayerStatsReadyHandle(cEvt:ParaEvent) : void
      {
         var targets:Array = CFunctionContainer.FetchReservedChatChannel();
         for(var i:int = 0; i < targets.length; i++)
         {
            this.addChatChannel(targets[i].id,targets[i].targetName,targets[i].targetID,false);
         }
         this.startJoinGlobalAndBigSpeakerChannel();
         CFunctionContainer.FetchReservedChatMessageAll();
      }
      
      private function startJoinGlobalAndBigSpeakerChannel() : void
      {
         if(!this.getIsGlobalChatLocked())
         {
            this.resetGlobalChatRetryCount();
            this.resetBigLoudSpeakerRetryCount();
            CFunctionContainer.JoinGlobalChannel();
            CFunctionContainer.JoinBigSpeakerChannel();
         }
      }
      
      private function receiveChatMsg(msgObj:ChatMessageObj) : void
      {
         for(var i:int = 0; i < this._chatChannels.length; i++)
         {
            if(msgObj.channelID == ChattingChannelType.GLOBAL || msgObj.channelID == ChattingChannelType.PARTY || msgObj.channelID == ChattingChannelType.CLAN || msgObj.channelID == ChattingChannelType.ROOM || msgObj.channelID == ChattingChannelType.ROOM_TEAM)
            {
               if(this._chatChannels[i].id == msgObj.channelID)
               {
                  (this._chatChannels[i] as ChatChannelObj).msgHistory.push(msgObj);
                  break;
               }
            }
            if(this._chatChannels[i].id == msgObj.channelID && this._chatChannels[i].targetID == msgObj.targetID)
            {
               (this._chatChannels[i] as ChatChannelObj).msgHistory.push(msgObj);
               break;
            }
         }
         this.broadcast(BCEvent.EVT_ON_CHAT_MSG_RECEIVED,msgObj);
         this.setBindData(DataID.CHAT_CHANNELS,this._chatChannels);
      }
      
      private function addChatChannel(channelID:uint, targetName:String = "", targetID:String = "", isNew:Boolean = true, selfInvoke:Boolean = false) : void
      {
         var isPrivate:Boolean = false;
         var channelObj:ChatChannelObj = null;
         var bFound:Boolean = false;
         var i:int = 0;
         if(channelID != ChattingChannelType.PRIVATE)
         {
            targetName = channelID.toString();
            targetID = channelID.toString();
         }
         for(i = 0; i < this._chatChannels.length; i++)
         {
            if(this._chatChannels[i].targetID == targetID)
            {
               bFound = true;
               break;
            }
         }
         if(bFound)
         {
            if(selfInvoke)
            {
               this.broadcast(BCEvent.EVT_CHAT_WITH_ACTIVE_USER,this._chatChannels[i]);
            }
            return;
         }
         if(!bFound)
         {
            isPrivate = channelID == ChattingChannelType.PRIVATE;
            if(isPrivate)
            {
               CFunctionContainer.ReserveChatChannel(channelID,targetName,targetID);
            }
            channelObj = new ChatChannelObj();
            channelObj.name = isPrivate ? targetName : this.getChannelNameByID(channelID);
            channelObj.id = channelID;
            channelObj.targetName = targetName;
            channelObj.targetID = targetID;
            channelObj.canBeClosed = isPrivate;
            channelObj.isNew = isNew;
            channelObj.targetLevel = this.getPlayerLevel(targetID);
            this._chatChannels.push(channelObj);
            this.setBindData(DataID.CHAT_CHANNELS,this._chatChannels);
         }
      }
      
      private function getPlayerLevel(playerID:String) : int
      {
         var userObj:UserObj = null;
         userObj = this.getDP(DataID.PLAYER_QUERY_FRIENDS,[playerID]);
         if(Boolean(userObj))
         {
            return userObj.level;
         }
         userObj = this.getDP(DataID.PLAYER_QUERY_CLAN,[playerID]);
         if(Boolean(userObj))
         {
            return userObj.level;
         }
         userObj = this.getDP(DataID.PLAYER_QUERY_PARTY,[playerID]);
         if(Boolean(userObj))
         {
            return userObj.level;
         }
         return 0;
      }
      
      private function removeChatChannel(channelID:uint, targetName:String = "", targetID:String = "") : void
      {
         var channelObj:ChatChannelObj = null;
         if(channelID != ChattingChannelType.PRIVATE)
         {
            targetID = targetName = channelID.toString();
         }
         CFunctionContainer.RemoveReservedChatChannel(channelID,targetName,targetID);
         for(var i:int = 0; i < this._chatChannels.length; i++)
         {
            if(this._chatChannels[i].targetID == targetID)
            {
               channelObj = this._chatChannels[i];
               this._chatChannels.splice(i,1);
               this.broadcast(BCEvent.EVT_ON_CHATTING_CHANNEL_REMOVED,channelObj);
               break;
            }
         }
      }
      
      private function onChatMsgSanitizedHandle(cEvt:ParaEvent) : void
      {
         var currentTime:Object = null;
         var formatedTime:String = null;
         if(cEvt.myPara.type == SanitizedType.CHATTING_MSG)
         {
            if(ScaleformUtil.isScaleform)
            {
               this._chatMsgToSend.message = cEvt.myPara.content;
               currentTime = CFunctionCommonContainer.GetCurrentTime();
               formatedTime = currentTime.formatedTime;
               this._chatMsgToSend.formatedTime = formatedTime;
               this._chatMsgToSend.senderID = CFunctionCommonContainer.GetPlayerID();
               CFunctionContainer.ReserveChatMessage(this._chatMsgToSend);
               this.receiveChatMsg(this._chatMsgToSend);
            }
         }
      }
      
      private function onChatViewReady(cEvt:ParaEvent) : void
      {
         var ccObj:ChatChannelObj = cEvt.myPara.channel as ChatChannelObj;
         if(ccObj != null)
         {
            CFunctionContainer.FetchReservedChatMessage(ccObj.id);
         }
      }
      
      private function onRequestPurchaseLoudSpeaker(cEvt:ParaEvent) : void
      {
         var isBigLoudSpeaker:Boolean = cEvt.myPara;
         var itemID:int = isBigLoudSpeaker ? BIG_LOUD_SPEAKER_ID : SMALL_LOUD_SPEAKER_ID;
         var prodObj:ProductObj = CFunctionCommonContainer.GetItemInfo(itemID);
         broadcast(BCEvent.EVT_MARKET_PURCHASE_POPUP,{"itemData":prodObj});
      }
      
      private function onChatViewReadyStateChange(cEvt:ParaEvent) : void
      {
         this._isChatViewReady = cEvt.myPara;
      }
      
      private function onServerMessageViewReadyStateChange(cEvt:ParaEvent) : void
      {
         this._isServerMessageViewReady = cEvt.myPara;
      }
      
      private function isChatMessageViewReady() : Boolean
      {
         return this._isChatViewReady && this._isServerMessageViewReady;
      }
      
      private function onSendLoudSpeaker(cEvt:ParaEvent) : void
      {
         if(this._sendingLoudSpeaker)
         {
            showMsg(DictChatting.LOUD_SPEAKER_SEND_IN_PROGRESS,MsgBtnCount.ONE);
            return;
         }
         var muteInfo:Object = getDP(DataID.GET_MUTEINFO) as Object;
         if(muteInfo != null && Boolean(muteInfo.isMuted))
         {
            showMsg(DictChatting.NOTE_CHATTING_MUTED,MsgBtnCount.ONE);
            return;
         }
         this._sendingLoudSpeaker = true;
         var para:Object = cEvt.myPara;
         CFunctionContainer.SendLoudSpeaker(para.type,para.message);
      }
      
      private function getChannelObjByID(channelID:uint) : ChatChannelObj
      {
         for(var i:int = 0; i < this._chatChannels.length; i++)
         {
            if(this._chatChannels[i].id == channelID)
            {
               return this._chatChannels[i];
            }
         }
         return null;
      }
      
      private function getBigLoudSpeakerCount() : int
      {
         return CFunctionCommonContainer.GetInventoryCount(BIG_LOUD_SPEAKER_ITEM_ID);
      }
      
      private function getSmallLoudSpeakerCount() : int
      {
         return CFunctionCommonContainer.GetInventoryCount(SMALL_LOUD_SPEAKER_ITEM_ID);
      }
      
      private function getIsInGlobalChannel() : Boolean
      {
         return CFunctionContainer.IsInGlobalChannel() as Boolean;
      }
      
      private function getIsInBigSpeakerChannel() : Boolean
      {
         return CFunctionContainer.IsInBigSpeakerChannel() as Boolean;
      }
      
      private function getBigLoudSpeakerShowDuration() : int
      {
         return getDvarInt("dw_bigLoudSpeakerShowDuration");
      }
      
      private function getSmallLoudSpeakerShowDuration() : int
      {
         return getDvarInt("dw_smallLoudSpeakerShowDuration");
      }
      
      private function getHeroicTierShowDuration() : int
      {
         return getDvarInt("dw_heroicTierShowDuration");
      }
      
      private function getChannelConnectionRetryCount() : int
      {
         return getDvarInt("dw_channelConnectRetryCount");
      }
      
      private function getBigLoudSpeakerMessageLen() : int
      {
         return getDvarInt("dw_maxBigLoudSpeakerMessageLen");
      }
      
      private function getSmallLoudSpeakerMessageLen() : int
      {
         return getDvarInt("dw_maxSmallLoudSpeakerMessageLen");
      }
      
      private function getGlobalChatMessageLen() : int
      {
         return getDvarInt("dw_maxGlobalChatMessageLen");
      }
      
      public function getBigLoudSpeakerCoolDown() : int
      {
         return getDvarInt("bigLoudSpeakerCoolDown");
      }
      
      public function getSmallLoudSpeakerCoolDown() : int
      {
         return getDvarInt("smallLoudSpeakerCoolDown");
      }
      
      public function getJoinedGlobalChatGroup() : int
      {
         return CFunctionContainer.GetSubscribedChatGroup();
      }
      
      public function getIsGlobalChatLocked() : Boolean
      {
         return getDvarBool("dw_lockGlobalChat");
      }
      
      private function getIsGlobalChatBroken() : Boolean
      {
         return this._globalChatIsBroken;
      }
      
      private function getChannelNameByID(channelID:uint) : String
      {
         var channel:String = "";
         switch(channelID)
         {
            case ChattingChannelType.PARTY:
               channel = DictParty.PARTY;
               break;
            case ChattingChannelType.PRIVATE:
               channel = DictChatting.CHATTING_CHANNEL_PRIVATE;
               break;
            case ChattingChannelType.ROOM:
               channel = DictChatting.CHATTING_CHANNEL_ROOM;
               break;
            case ChattingChannelType.CLAN:
               channel = DictChatting.CHATTING_CHANNEL_CLAN;
               break;
            case ChattingChannelType.GLOBAL:
               channel = DictChatting.CHATTING_CHANNEL_CHANNEL;
         }
         return this.localize(channel);
      }
      
      private function canSendChatMsg(channel:ChatChannelObj, msg:String) : Boolean
      {
         var levelStr:String = null;
         var msgObj:ChatMessageObj = null;
         if(channel == null || msg == null)
         {
            return false;
         }
         var feedback:String = "";
         var tm:Number = new Date().getTime();
         var interval:Number = Math.abs(tm - this._lastSendMsgTime);
         if(feedback.length <= 0 && StringUtil.trim(msg).length <= 0)
         {
            feedback = DictSystem.EMPTY_MSG;
         }
         if(feedback.length <= 0 && this.isChatMsgRepetitive(msg,channel.id,0))
         {
            feedback = DictSystem.REPETITIVE_MSG;
         }
         if(feedback.length <= 0 && interval < ChattingMsgInterval.getInterval(channel.id))
         {
            feedback = DictSystem.FREQUENT_MSG;
         }
         if(feedback.length <= 0 && Boolean(this.getDP(DataID.GET_IS_IN_BLACKLIST,[channel.targetID])))
         {
            feedback = DictChatting.NOTE_FRIEND_BLACKLIST;
         }
         var muteInfo:Object = getDP(DataID.GET_MUTEINFO) as Object;
         if(Boolean(feedback.length <= 0 && channel.id == ChattingChannelType.GLOBAL) && Boolean(muteInfo) && Boolean(muteInfo.isMuted))
         {
            feedback = DictChatting.NOTE_CHATTING_MUTED;
         }
         var globalChatLevelRestriction:int = getDvarInt("dw_globalMessagePostLevelRestriction");
         var playerLevel:int = CFunctionCommonContainer.GetPlayerPrestige() * 100 + (CFunctionCommonContainer.GetPlayerLevel() + 1);
         if(feedback.length <= 0 && channel.id == ChattingChannelType.GLOBAL && globalChatLevelRestriction > playerLevel)
         {
            levelStr = LocalizeUtil.localizePlayerLevel(globalChatLevelRestriction);
            feedback = LocalizeUtil.param(DictChatting.NOTE_CHATTING_LEVEL_RESTRICTION,[levelStr]);
         }
         if(feedback.length > 0)
         {
            msgObj = new ChatMessageObj();
            msgObj.channelID = channel.id;
            msgObj.channelName = channel.name;
            msgObj.targetID = channel.targetID;
            msgObj.senderName = this.localize(DictAAS.AAS_SYSTEM);
            msgObj.message = this.localize(feedback);
            msgObj.isSystem = true;
            msgObj.formatedTime = TimeUtil.now();
            if(channel.id == ChattingChannelType.PRIVATE)
            {
               ++this._unreadPrivateMsgCount;
               this.setBindData(DataID.HAS_UNREAD_MSG,{"unreadCount":this._unreadPrivateMsgCount});
            }
            this.receiveChatMsg(msgObj);
            return false;
         }
         this._lastSendMsgTime = tm;
         this.reserveChatMsg(msg,channel.id,tm);
         return true;
      }
      
      private function isChatMsgRepetitive(cMsg:String, cChannel:uint, cSendTime:Number) : Boolean
      {
         if(this._lastSendMsgs.length < MAX_REPETITIVE_MSG_NUM)
         {
            return false;
         }
         for(var i:int = 0; i < this._lastSendMsgs.length; i++)
         {
            if(this._lastSendMsgs[i].msg != cMsg)
            {
               return false;
            }
         }
         return true;
      }
      
      private function reserveChatMsg(cMsg:String, cChannel:uint, cSendTime:Number) : void
      {
         while(this._lastSendMsgs.length >= MAX_REPETITIVE_MSG_NUM)
         {
            this._lastSendMsgs.shift();
         }
         this._lastSendMsgs.push({
            "msg":cMsg,
            "channel":cChannel,
            "time":cSendTime
         });
      }
      
      private function localize(source:String) : String
      {
         return LocalizeUtil.localize(source);
      }
      
      private function bind_demonwareChattingStatusChange(cRes:Object) : void
      {
         var i:uint = 0;
         for(i = 0; i < cRes.data.length; i++)
         {
            if(cRes.data[i].name == "messaging" && cRes.data[i].status == DWServiceStatus.UNRESPONSIVE)
            {
               Logger.print("ChattingController::bind_demonwareChattingStatusChange: UNRESPONSIVE - timestamp: " + cRes.data[i].timestamp + "\n");
            }
         }
      }
      
      private function getRecentChatMessages(message:ChatMessageObj) : Array
      {
         var histroy:Array = null;
         var chatChannel:ChatChannelObj = null;
         var numHistroy:int = 0;
         var j:int = 0;
         var aHistroy:ChatMessageObj = null;
         for(var i:int = 0; i < this._chatChannels.length; i++)
         {
            chatChannel = this._chatChannels[i] as ChatChannelObj;
            if(chatChannel.id == message.channelID)
            {
               histroy = chatChannel.msgHistory;
               break;
            }
         }
         var result:Array = new Array();
         if(Boolean(histroy))
         {
            numHistroy = int(histroy.length);
            for(j = numHistroy - 1; j >= 0; j--)
            {
               aHistroy = histroy[j] as ChatMessageObj;
               if(aHistroy.senderID == message.senderID)
               {
                  if(aHistroy.formatedTime != message.formatedTime)
                  {
                     result.push(aHistroy.message);
                     if(result.length >= MAX_HISTORY_COLLECTED)
                     {
                        break;
                     }
                  }
               }
            }
         }
         return result;
      }
   }
}

