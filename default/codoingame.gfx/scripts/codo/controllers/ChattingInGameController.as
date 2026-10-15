package codo.controllers
{
   import codo.base.BaseController;
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionInGameContainer;
   import codo.constants.BCCommonEvent;
   import codo.constants.BCInGameEvent;
   import codo.constants.ChatSpeakerType;
   import codo.constants.ChattingChannelType;
   import codo.constants.ChattingMsgInterval;
   import codo.constants.ChattingMuteType;
   import codo.constants.DataInGameID;
   import codo.constants.SanitizedType;
   import codo.event.ParaEvent;
   import codo.localization.DictAAS;
   import codo.localization.DictChatting;
   import codo.localization.DictHud;
   import codo.localization.DictSystem;
   import codo.objects.ChatChannelObj;
   import codo.objects.ChatMessageObj;
   import codo.style.GlobalGuide;
   import codo.style.SpyHudGuide;
   import codo.utils.LocalizeUtil;
   import codo.utils.Logger;
   import codo.utils.ScaleformUtil;
   import codo.utils.StringUtil;
   import codo.utils.TimeUtil;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class ChattingInGameController extends BaseController
   {
      
      private static const MAX_REPETITIVE_MSG_NUM:uint = 5;
      
      private static const MAX_BIG_LOUD_SPEAKER_SIZE:int = 100;
      
      private var _chatChannels:Array = [];
      
      private var _chatMsgToSend:ChatMessageObj = new ChatMessageObj();
      
      private var _lastSendMsgTime:Number = 0;
      
      private var _lastSendMsgs:Array = [];
      
      private var _myName:String = "";
      
      private var _myID:String = "";
      
      private var _isInChatting:Boolean = false;
      
      private var _timerOpenShoutcastMenu:Timer = null;
      
      private var _bigLoudSpeakerPostBuffer:Vector.<Object> = new Vector.<Object>();
      
      private var _deadRoomChatUnavailableMode:Array = ["ph"];
      
      public function ChattingInGameController()
      {
         super();
      }
      
      override protected function onInitialized() : void
      {
         var timer:Timer = null;
         this.listen(BCInGameEvent.EVT_SEND_CHAT_MSG,this.onSendChatMsgHandle);
         this.listen(BCCommonEvent.EVT_ON_STRING_SANITIZED,this.onChatMsgSanitizedHandle);
         this.listen(BCInGameEvent.EVT_ON_CHAT_VIEW_READY,this.onChatViewReady);
         this.listen(BCCommonEvent.EVT_HIDE_SPEAKER_ANIMATION,this.onHideBigSpeakAnimation);
         this.initChatChannels();
         if(!ScaleformUtil.isScaleform)
         {
            timer = new Timer(3000,1);
            timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerCompleteHandle);
            timer.start();
         }
      }
      
      private function onTimerCompleteHandle(cEvt:TimerEvent) : void
      {
         this.openChatMenu();
      }
      
      public function cppOnMessageReceived(msg:Object) : void
      {
         var gameType:String = null;
         Logger.print("ChattingInGameController:::cppOnMessageReceived msg: ",msg.senderName,msg.senderID);
         var msgObj:ChatMessageObj = new ChatMessageObj(msg);
         if(msgObj.channelID == ChattingChannelType.GLOBAL && msgObj.loudSpeakerType == ChatSpeakerType.SPEAKER_TYPE_BIG)
         {
            if(this._bigLoudSpeakerPostBuffer.length >= MAX_BIG_LOUD_SPEAKER_SIZE)
            {
               return;
            }
            this._bigLoudSpeakerPostBuffer.push(msgObj);
            if(this._bigLoudSpeakerPostBuffer.length == 1)
            {
               broadcast(BCCommonEvent.EVT_SHOW_SPEAKER_ANIMATION,this._bigLoudSpeakerPostBuffer[0]);
            }
            this.receiveChatMsg(msgObj);
            return;
         }
         if(Boolean(CFunctionInGameContainer.IsSpectator()))
         {
            if(msgObj.channelID == ChattingChannelType.ROOM_TEAM)
            {
               this.receiveChatMsg(msgObj);
            }
         }
         else
         {
            if(msgObj.channelID == ChattingChannelType.PRIVATE && msgObj.senderID != this.getMyID())
            {
               gameType = this.getDP(DataInGameID.GAME_TYPE);
               if(gameType == "spy")
               {
                  return;
               }
               msgObj.channelName = msgObj.senderName;
               this.addChatChannel(ChattingChannelType.PRIVATE,msgObj.senderName,msgObj.senderID);
            }
            if(msgObj.channelID == ChattingChannelType.SPY || msgObj.channelID == ChattingChannelType.SPECTATOR)
            {
               if(!this.isInChannel(msgObj.channelID))
               {
                  return;
               }
            }
            this.receiveChatMsg(msgObj);
         }
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
         msgObj.senderName = LocalizeUtil.localize(DictAAS.AAS_SYSTEM);
         msgObj.message = LocalizeUtil.localize(DictChatting.NOTE_CHATTING_MUTED);
         msgObj.isSystem = true;
         switch(muteType)
         {
            case ChattingMuteType.ROOM:
               msgObj.channelID = ChattingChannelType.ROOM;
               break;
            case ChattingMuteType.PARTY:
               msgObj.channelID = ChattingChannelType.PARTY;
               break;
            case ChattingMuteType.PRIVATE:
               msgObj.channelID = ChattingChannelType.PRIVATE;
         }
         this.receiveChatMsg(msgObj);
      }
      
      public function isInChat() : Boolean
      {
         return this._isInChatting;
      }
      
      public function openChatMenu() : void
      {
         Logger.print("ChattingInGameController:::openChatMenu");
         this._isInChatting = true;
         this.broadcast(BCInGameEvent.TOGGLE_CHAT,true);
         this.broadcast(BCInGameEvent.BIND_UI_KEY_CATCHER,true);
         CFunctionInGameContainer.BindHudChatIME(true);
      }
      
      public function closeChatMenu() : void
      {
         Logger.print("ChattingInGameController:::closeChatMenu");
         if(this._isInChatting == false)
         {
            return;
         }
         this._isInChatting = false;
         this.broadcast(BCInGameEvent.TOGGLE_CHAT,false);
         this.broadcast(BCInGameEvent.BIND_UI_KEY_CATCHER,false);
         CFunctionInGameContainer.BindHudChatIME(false);
         if(Boolean(CFunctionInGameContainer.IsSpectator()))
         {
            this.tryShowShoutcastAndUpdateBypassMouseInput(null);
         }
      }
      
      private function tryShowShoutcastAndUpdateBypassMouseInput(cEvt:TimerEvent) : void
      {
         if(this._timerOpenShoutcastMenu != null)
         {
            this._timerOpenShoutcastMenu.removeEventListener(TimerEvent.TIMER_COMPLETE,this.tryShowShoutcastAndUpdateBypassMouseInput);
            this._timerOpenShoutcastMenu = null;
         }
         if(Boolean(CFunctionInGameContainer.AS_ShowShoutcastAndUpdateBypassMouseInput()))
         {
            Logger.print("ChattingInGameController | AS_ShowShoutcastAndUpdateBypassMouseInput failed!, will try again");
            CFunctionCommonContainer.setdvar("cl_shoutcast_chatmenuopen","0");
         }
         else
         {
            this._timerOpenShoutcastMenu = new Timer(1000,1);
            this._timerOpenShoutcastMenu.addEventListener(TimerEvent.TIMER_COMPLETE,this.tryShowShoutcastAndUpdateBypassMouseInput);
            this._timerOpenShoutcastMenu.start();
         }
      }
      
      private function onSendChatMsgHandle(cEvt:ParaEvent) : void
      {
         Logger.print("ChattingInGameController:::onSendChatMsgHandle");
         var channel:ChatChannelObj = cEvt.myPara.channel;
         var msg:String = cEvt.myPara.message;
         msg = msg.split("<").join("&lt;");
         msg = msg.split(">").join("&gt;");
         if(this.canSendChatMsg(channel,msg))
         {
            this._chatMsgToSend.channelID = channel.id;
            this._chatMsgToSend.channelName = channel.name;
            this._chatMsgToSend.receiverName = channel.targetName;
            this._chatMsgToSend.receiverID = channel.targetID;
            this._chatMsgToSend.senderName = this.getMyName();
            this._chatMsgToSend.message = msg;
            this._chatMsgToSend.targetID = channel.targetID;
            this._chatMsgToSend.targetName = channel.targetName;
            this._chatMsgToSend.targetLevel = channel.targetLevel;
            if(this._chatMsgToSend.channelID == ChattingChannelType.PRIVATE || this._chatMsgToSend.channelID == ChattingChannelType.CLAN)
            {
               this.broadcast(BCCommonEvent.EVT_SANITIZE_STRING,{
                  "type":SanitizedType.CHATTING_MSG,
                  "content":this._chatMsgToSend.message
               });
            }
            CFunctionInGameContainer.SendChatMessage(this._chatMsgToSend);
         }
         this.closeChatMenu();
      }
      
      private function onChatMsgSanitizedHandle(cEvt:ParaEvent) : void
      {
         var clanObj:Object = null;
         if(cEvt.myPara.type != SanitizedType.CHATTING_MSG)
         {
            return;
         }
         if(ScaleformUtil.isScaleform)
         {
            this._chatMsgToSend.message = cEvt.myPara.content;
            if(this._chatMsgToSend.channelID == ChattingChannelType.CLAN)
            {
               clanObj = CFunctionCommonContainer.GetClanInfo();
               if(Boolean(clanObj))
               {
                  this._chatMsgToSend.senderName = StringUtil.addTag(clanObj.clantag,this._chatMsgToSend.senderName);
               }
            }
            this._chatMsgToSend.formatedTime = TimeUtil.now();
            this._chatMsgToSend.senderID = this.getMyID();
            CFunctionInGameContainer.ReserveChatMessage(this._chatMsgToSend);
            this.receiveChatMsg(this._chatMsgToSend);
         }
      }
      
      private function onChatViewReady(cEvt:ParaEvent) : void
      {
         CFunctionInGameContainer.FetchReservedChatMessageAll();
      }
      
      public function getChannelNameByID(channelID:uint) : String
      {
         var channel:String = "";
         switch(channelID)
         {
            case ChattingChannelType.PRIVATE:
               channel = DictChatting.CHATTING_CHANNEL_PRIVATE;
               break;
            case ChattingChannelType.ROOM:
               channel = DictChatting.CHATTING_CHANNEL_ROOM;
               break;
            case ChattingChannelType.ROOM_TEAM:
               channel = DictChatting.CHATTING_CHANNEL_ROOM_TEAM;
               break;
            case ChattingChannelType.CLAN:
               channel = DictChatting.CHATTING_CHANNEL_CLAN;
               break;
            case ChattingChannelType.PARTY:
               channel = DictChatting.PARTY_CHANNEL_LABEL;
               break;
            case ChattingChannelType.SPY:
               channel = DictChatting.CHATTING_CHANNEL_SPY;
               break;
            case ChattingChannelType.SPECTATOR:
               channel = DictChatting.CHATTING_CHANNEL_SPECTATOR;
         }
         return LocalizeUtil.localize(channel);
      }
      
      private function getMyName() : String
      {
         if(this._myName == "")
         {
            this._myName = ScaleformUtil.isScaleform ? CFunctionCommonContainer.GetPlayerName().name : "CODO";
         }
         return this._myName;
      }
      
      private function getMyID() : String
      {
         if(this._myID == "")
         {
            this._myID = CFunctionCommonContainer.GetPlayerID();
         }
         return this._myID;
      }
      
      private function addChatChannel(channelID:uint, targetName:String = "", targetID:String = "", pos:int = -1) : void
      {
         var isPrivate:Boolean = false;
         var channelObj:ChatChannelObj = null;
         Logger.print("ChattingInGameController:::addChatChannel channelID: " + channelID);
         Logger.print("ChattingInGameController:::addChatChannel targetName: " + targetName);
         var tempIsAlreadyAdd:Boolean = false;
         for(var i:int = 0; i < this._chatChannels.length; i++)
         {
            if(this._chatChannels[i].id == channelID)
            {
               if(this._chatChannels[i].targetName == targetName)
               {
                  return;
               }
               if(this._chatChannels[i].targetID == targetID)
               {
                  this._chatChannels[i].name = targetName;
                  this._chatChannels[i].targetName = targetName;
                  tempIsAlreadyAdd = true;
               }
            }
         }
         if(tempIsAlreadyAdd == false)
         {
            isPrivate = channelID == ChattingChannelType.PRIVATE;
            channelObj = new ChatChannelObj();
            channelObj.name = isPrivate ? targetName : this.getChannelNameByID(channelID);
            channelObj.id = channelID;
            channelObj.targetName = targetName;
            channelObj.targetID = targetID;
            channelObj.canBeClosed = isPrivate;
            if(pos >= 0)
            {
               this._chatChannels.splice(pos,0,channelObj);
            }
            else
            {
               this._chatChannels.push(channelObj);
            }
         }
         this.setBindData(DataInGameID.CHATTING_CHANNELS,this._chatChannels);
      }
      
      private function initChatChannels() : void
      {
         var targets:Array = null;
         var i:int = 0;
         this._chatChannels.splice(0);
         var gameType:String = this.getDP(DataInGameID.GAME_TYPE);
         if(gameType != "dm" && gameType != "zm" && gameType != "infect" && gameType != "borg" && gameType != "coop" && gameType != "spy")
         {
            this.addChatChannel(ChattingChannelType.ROOM_TEAM);
         }
         if(!CFunctionInGameContainer.IsSpectator())
         {
            this.addChatChannel(ChattingChannelType.ROOM);
            if(gameType != "spy" && Boolean(CFunctionCommonContainer.IsInClan()))
            {
               this.addChatChannel(ChattingChannelType.CLAN);
            }
            targets = CFunctionInGameContainer.FetchReservedChatChannel();
            if(!ScaleformUtil.isScaleform)
            {
               targets.push({
                  "id":ChattingChannelType.PRIVATE,
                  "targetName":"AZhang01",
                  "targetID":"111"
               });
               targets.push({
                  "id":ChattingChannelType.PRIVATE,
                  "targetName":"AZhang02",
                  "targetID":"222"
               });
            }
            for(i = 0; i < targets.length; i++)
            {
               if(targets[i].targetName != this.getMyName() && targets[i].targetName.length > 1)
               {
                  this.addChatChannel(targets[i].id,targets[i].targetName,targets[i].targetID);
               }
            }
         }
         else if(gameType == "spy")
         {
            this.addChatChannel(ChattingChannelType.SPECTATOR);
         }
         this.setBindData(DataInGameID.CHATTING_CHANNELS,this._chatChannels);
      }
      
      public function canSendChatMsg(channel:ChatChannelObj, msg:String) : Boolean
      {
         var msgObj:ChatMessageObj = null;
         var feedback:String = "";
         var tm:Number = new Date().getTime();
         var interval:Number = Math.abs(tm - this._lastSendMsgTime);
         if(msg.length <= 0 || StringUtil.trim(msg).length <= 0)
         {
            this.closeChatMenu();
            return false;
         }
         if(feedback.length <= 0 && !this.isDeadChatAvailable(channel.id,getDP(DataInGameID.GAME_TYPE)))
         {
            feedback = DictChatting.NOTE_CANNOT_CHAT_AFTER_DEAD;
         }
         if(feedback.length <= 0 && this.isChatMsgRepetitive(msg,channel.id,0))
         {
            feedback = DictSystem.REPETITIVE_MSG;
         }
         if(feedback.length <= 0 && interval < ChattingMsgInterval.getInterval(channel.id))
         {
            feedback = DictSystem.FREQUENT_MSG;
         }
         if(feedback.length > 0)
         {
            msgObj = new ChatMessageObj();
            msgObj.channelID = channel.id;
            msgObj.channelName = "";
            msgObj.senderName = LocalizeUtil.localize(DictAAS.AAS_SYSTEM);
            msgObj.message = LocalizeUtil.localize(feedback);
            msgObj.isSystem = true;
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
      
      private function receiveChatMsg(msgObj:ChatMessageObj) : void
      {
         Logger.print("ChattingInGameController:::receiveChatMsg msgObj.isNew: " + msgObj.isNew);
         Logger.print("ChattingInGameController:::receiveChatMsg msgObj.channelID: " + msgObj.channelID);
         if(msgObj.channelID != ChattingChannelType.GLOBAL)
         {
            this.decorateChatMsg(msgObj);
            this.broadcast(BCInGameEvent.EVT_ON_CHAT_MSG_RECEIVED,msgObj);
         }
      }
      
      private function getMessageColor(msgObj:ChatMessageObj) : uint
      {
         var color:uint = GlobalGuide.CHAT_DEFAULT_COLOR;
         if(msgObj.isSystem)
         {
            color = GlobalGuide.CHAT_SYSTEM_COLOR;
         }
         else if(msgObj.channelID == ChattingChannelType.SPY)
         {
            color = SpyHudGuide.ROLE_SPY_COLOR;
         }
         else if(msgObj.isInvestigator)
         {
            color = SpyHudGuide.ROLE_INVESTIGATOR_COLOR;
         }
         return color;
      }
      
      private function decorateChatMsg(msgObj:ChatMessageObj) : void
      {
         if(msgObj == null)
         {
            return;
         }
         msgObj.channelName = "[" + this.getChannelNameByID(msgObj.channelID) + "]";
         if(msgObj.senderName.length > 0)
         {
            if(msgObj.channelID == ChattingChannelType.PRIVATE && msgObj.senderID == this.getMyID())
            {
               msgObj.senderName = LocalizeUtil.localize(DictChatting.SEND_TO) + msgObj.targetName;
            }
            else if(msgObj.isInvestigator)
            {
               msgObj.senderName = "[" + LocalizeUtil.localize(DictHud.SPY_INVESTIGATOR) + "]" + msgObj.senderName;
            }
            msgObj.senderName += ": ";
            msgObj.senderName = msgObj.senderName.split("<").join("&lt;");
            msgObj.senderName = msgObj.senderName.split(">").join("&gt;");
         }
         var strTextColor:String = "#" + this.getMessageColor(msgObj).toString(16);
         msgObj.message = "<font color=\"" + strTextColor + "\">" + (msgObj.channelName + msgObj.senderName + msgObj.message) + "</font>";
         msgObj.message += "<br/>";
      }
      
      private function removeChatChannel(channelId:uint) : void
      {
         for(var i:int = 0; i < this._chatChannels.length; i++)
         {
            if(this._chatChannels[i].id == channelId)
            {
               this._chatChannels.splice(i,1);
               this.setBindData(DataInGameID.CHATTING_CHANNELS,this._chatChannels);
               break;
            }
         }
      }
      
      public function cppJoinChannel(channelId:uint, index:int) : void
      {
         this.addChatChannel(channelId,"","",index);
      }
      
      public function cppLeaveChannel(channelId:uint) : void
      {
         this.removeChatChannel(channelId);
      }
      
      public function cppSetChannelReadonly(channelId:uint, readonly:Boolean) : void
      {
         for(var i:int = 0; i < this._chatChannels.length; i++)
         {
            if(this._chatChannels[i].id == channelId)
            {
               if(this._chatChannels[i].readonly != readonly)
               {
                  this._chatChannels[i].readonly = readonly;
                  this.setBindData(DataInGameID.CHATTING_CHANNELS,this._chatChannels);
               }
               break;
            }
         }
      }
      
      private function isInChannel(channelId:uint) : Boolean
      {
         for(var i:int = 0; i < this._chatChannels.length; i++)
         {
            if(this._chatChannels[i].id == channelId)
            {
               return true;
            }
         }
         return false;
      }
      
      private function isDeadChatAvailable(chatChannelType:int, gameType:String) : Boolean
      {
         if(ChattingChannelType.ROOM != chatChannelType)
         {
            return true;
         }
         if(-1 == this._deadRoomChatUnavailableMode.indexOf(gameType))
         {
            return true;
         }
         var isDead:Boolean = CFunctionInGameContainer.AS_IsPlayerDead() as Boolean;
         return !isDead;
      }
   }
}

