package codo.views
{
   import codo.base.BaseView;
   import codo.constants.BCCommonEvent;
   import codo.constants.BCEvent;
   import codo.constants.ChatSpeakerType;
   import codo.constants.ChattingChannelType;
   import codo.constants.DataCommonID;
   import codo.constants.DataID;
   import codo.constants.GameInfo;
   import codo.event.ParaEvent;
   import codo.localization.DictChatting;
   import codo.objects.ChatChannelObj;
   import codo.objects.ChatMessageObj;
   import codo.style.ChatGuide;
   import codo.theme.BaseTheme;
   import codo.theme.ITheme;
   import codo.utils.LocalizeUtil;
   import codo.utils.ScaleformUtil;
   import codo.views.chat_parts.ChannelSelector;
   import codo.views.chat_parts.ChatBigSpeaker;
   import codo.views.chat_parts.ChatHistoryList;
   import codo.views.chat_parts.ControlPanel;
   import codo.views.chat_parts.LoudSpeakerBtn;
   import codo.views.chat_parts.LoudSpeakerPanel;
   import codo.views.chat_parts.MainChatPanel;
   import codo.views.chat_parts.MessageSender;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   import scaleform.gfx.MouseEventEx;
   
   public class ChatView extends BaseView
   {
      
      public static const CHANNEL_NAMES:Array = [DictChatting.GLOBAL_CHANNEL_LABEL,DictChatting.CLAN_CHANNEL_LABEL,DictChatting.PARTY_CHANNEL_LABEL,DictChatting.PRIVATE_CHANNEL_LABEL,DictChatting.CHATTING_CHANNEL_ROOM,DictChatting.CHATTING_CHANNEL_ROOM_TEAM];
      
      public static const GLOBAL_CHANNEL_INDEX:int = 0;
      
      public static const CLAN_CHANNEL_INDEX:int = 1;
      
      public static const PARTY_CHANNEL_INDEX:int = 2;
      
      public static const PRIVATE_CHANNEL_INDEX:int = 3;
      
      public static const ROOM_CHANNEL_INDEX:int = 4;
      
      public static const TEAM_CHANNEL_INDEX:int = 5;
      
      public static const MAX_HISTORY_COLLECTED:int = 5;
      
      private static const VIEW_WIDTH:Number = 1861;
      
      private static const VIEW_HEIGHT:Number = 97;
      
      private static const VIEW_STATE:int = 0;
      
      private static const INPUT_STATE:int = 1;
      
      public var myChatList:ChatHistoryList;
      
      public var myLoudSpeakerPanel:LoudSpeakerPanel;
      
      public var myBigSpeakerBtn:LoudSpeakerBtn;
      
      public var mySmallSpeakerBtn:LoudSpeakerBtn;
      
      public var myPrivateChannelSelector:ChannelSelector;
      
      public var myMainChatPanel:MainChatPanel;
      
      public var myControlPanel:ControlPanel;
      
      public var myMessageSender:MessageSender;
      
      public var myChatBigSpeaker:ChatBigSpeaker;
      
      public var myBg:MovieClip;
      
      private var mBigSpeakerTokenCount:int = 0;
      
      private var mSmallSpeakerTokenCount:int = 0;
      
      private var mChatChannels:Array;
      
      private var mCurrentChannelType:int = -1;
      
      private var mGlobalChatJoined:Boolean = false;
      
      private var mGlobalChatLocked:Boolean = false;
      
      private var mPrivateChannelKeeper:Vector.<Object>;
      
      private var mSelectedPrivateChannel:int = -1;
      
      private var mAllRawChannels:Array = [];
      
      private var mChatChannelBeingShown:ChatChannelObj;
      
      private var mState:int = 0;
      
      public function ChatView()
      {
         super();
         this.initStage();
      }
      
      override protected function setupThemeVector() : void
      {
         super.setupThemeVector();
         mThemeSetNew.push({
            "clip":this.myBigSpeakerBtn,
            "piece":BaseTheme.THEME_PIECE_SPEAK_BUTTON
         });
         mThemeSetNew.push({
            "clip":this.mySmallSpeakerBtn,
            "piece":BaseTheme.THEME_PIECE_SPEAK_BUTTON
         });
         mThemeSetNew.push({
            "clip":this.myControlPanel,
            "piece":BaseTheme.THEME_PIECE_CONTROL_PANEL
         });
         mThemeSetNew.push({
            "clip":this.myChatList,
            "piece":BaseTheme.THEME_PIECE_CHAT_LIST
         });
         mThemeSetNew.push({
            "clip":this.myMainChatPanel,
            "piece":BaseTheme.THEME_PIECE_MAIN_CHAT_PANEL
         });
      }
      
      override protected function initTheme() : void
      {
         super.initTheme();
         var theme:ITheme = getDP(DataID.GET_THEME_SUITE);
         this.myControlPanel.themeColor = theme.getChatThemeColor();
      }
      
      private function initStage() : void
      {
         MessageSender.sGlobalMessageLen = getDP(DataID.GLOBAL_CHAT_MESSAGE_LEN);
         this.mPrivateChannelKeeper = new Vector.<Object>();
         this.myLoudSpeakerPanel.visible = false;
         this.myPrivateChannelSelector.visible = false;
         this.myMainChatPanel.visible = false;
         this.myBigSpeakerBtn.setLoudSpeakerFrame(ChatGuide.BIG_SPEAKER_ICON_FRAME);
         this.mySmallSpeakerBtn.setLoudSpeakerFrame(ChatGuide.SMALL_SPEAKER_ICON_FRAME);
         this.myBigSpeakerBtn.registerClickEvent(this.onLoudSpeakerBtnClicked,ChatSpeakerType.SPEAKER_TYPE_BIG);
         this.mySmallSpeakerBtn.registerClickEvent(this.onLoudSpeakerBtnClicked,ChatSpeakerType.SPEAKER_TYPE_SMALL);
         this.myControlPanel.registerExpandButtonClickHandler(this.onExpandButtonClicked);
         this.myControlPanel.registerChannelButtonClickHandler(this.onChannelButtonClicked);
         this.myMessageSender.registerPostMessageHandler(this.onPostMessage);
         this.myPrivateChannelSelector.registerSelectionChangeCallback(this.onPrivateChannelSelectionChanged);
         this.myPrivateChannelSelector.registerChannelCloseCallback(this.onPrivateChannelClosed);
         this.myChatList.addEventListener(MouseEvent.CLICK,this.onClickChatList);
         this.myChatBigSpeaker.visible = false;
         this.myChatBigSpeaker.registerShowAnimationCompleteHandler(this.onShowAnimationCompleteHandler);
         this.mChatChannels = [true,false,false,false,true,true];
         this.myMessageSender.visible = false;
         x = (GameInfo.DEFAULT_WIDTH - VIEW_WIDTH) * 0.5;
         y = GameInfo.DEFAULT_HEIGHT - VIEW_HEIGHT;
      }
      
      override protected function enableData() : void
      {
         super.enableData();
         this.onGlobalChatChannelStateChanged(null);
         this.mChatChannels[CLAN_CHANNEL_INDEX] = getDP(DataID.IS_IN_CLAN);
         this.refreshChannels();
         this.mySmallSpeakerBtn.enabled = this.mGlobalChatJoined;
         this.myBigSpeakerBtn.enabled = Boolean(getDP(DataID.IS_IN_BIG_SPEAKER_CHANNEL)) && !getDP(DataID.IS_GLOBAL_CHAT_LOCKED);
         stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onStageKeyHandle);
         listen(BCEvent.EVT_REFRESH_UI_AFTER_INVENTORY_CHANGE,this.onInventoryUpdate);
         listen(BCEvent.EVT_JOINED_GLOBAL_CHAT,this.onGlobalChatChannelStateChanged);
         listen(BCEvent.EVT_JOINED_BIG_LOUD_SPEAKER,this.onBigSpeakerChannelStateChanged);
         listen(BCEvent.EVT_ON_CLAN_JOINED,this.onJoinClanHandler);
         listen(BCEvent.EVT_ON_CLAN_LEFT,this.onLeftClanHandler);
         listen(BCEvent.PARTY_STATE_CHANGED,this.onPartyStateChangeHandler);
         listen(BCEvent.EVT_ON_CHAT_MSG_RECEIVED,this.onReceiveChatMessage);
         listen(BCCommonEvent.EVT_SHOW_SPEAKER_ANIMATION,this.onShowSpeakAnimation);
         listen(BCEvent.EVT_OPEN_CHAT_WINDOW,this.onInvokeChat);
         listen(BCEvent.EVT_SHOW_PERSISTENT_VIEW,this.onShowEvt);
         listen(BCEvent.EVT_HIDE_PERSISTENT_VIEW,this.onHideEvt);
         listen(BCEvent.EVT_LOUD_SPEAKER_SEND_SUCCESS,this.onLoudSpeakerSendSuccess);
         listen(BCEvent.EVT_GLOBAL_CHAT_DISCONNECT,this.onGlobalChatChannelStateChanged);
         listen(BCEvent.EVT_BIG_SPEAKER_DISCONNECT,this.onBigSpeakerChannelStateChanged);
         listen(BCEvent.EVT_GLOBAL_CHAT_BROKEN_STATE_CHANGED,this.onGlobalChatBroken);
         bind(DataID.CHAT_CHANNELS,this.onGetAllChannels);
         bind(DataID.ROOM_INFO,this.onGetRoomInfo);
         this.refreshLoudSpeakerCount();
         broadcast(BCEvent.EVT_CHAT_VIEW_READY_STATE_CHANGE,true);
      }
      
      override protected function disableData() : void
      {
         super.disableData();
         unlisten(BCEvent.EVT_REFRESH_UI_AFTER_INVENTORY_CHANGE,this.onInventoryUpdate);
         unlisten(BCEvent.EVT_JOINED_GLOBAL_CHAT,this.onGlobalChatChannelStateChanged);
         unlisten(BCEvent.EVT_JOINED_BIG_LOUD_SPEAKER,this.onBigSpeakerChannelStateChanged);
         unlisten(BCEvent.EVT_ON_CLAN_JOINED,this.onJoinClanHandler);
         unlisten(BCEvent.EVT_ON_CLAN_LEFT,this.onLeftClanHandler);
         unlisten(BCEvent.PARTY_STATE_CHANGED,this.onPartyStateChangeHandler);
         unlisten(BCEvent.EVT_ON_CHAT_MSG_RECEIVED,this.onReceiveChatMessage);
         unlisten(BCCommonEvent.EVT_SHOW_SPEAKER_ANIMATION,this.onShowSpeakAnimation);
         unlisten(BCEvent.EVT_OPEN_CHAT_WINDOW,this.onInvokeChat);
         unlisten(BCEvent.EVT_SHOW_PERSISTENT_VIEW,this.onShowEvt);
         unlisten(BCEvent.EVT_HIDE_PERSISTENT_VIEW,this.onHideEvt);
         unlisten(BCEvent.EVT_LOUD_SPEAKER_SEND_SUCCESS,this.onLoudSpeakerSendSuccess);
         unlisten(BCEvent.EVT_GLOBAL_CHAT_DISCONNECT,this.onGlobalChatChannelStateChanged);
         unlisten(BCEvent.EVT_BIG_SPEAKER_DISCONNECT,this.onBigSpeakerChannelStateChanged);
         unlisten(BCEvent.EVT_GLOBAL_CHAT_BROKEN_STATE_CHANGED,this.onGlobalChatBroken);
         unbind(DataID.CHAT_CHANNELS,this.onGetAllChannels);
         broadcast(BCEvent.EVT_CHAT_VIEW_READY_STATE_CHANGE,false);
      }
      
      private function onGetAllChannels(res:Object) : void
      {
         var channelKeeper:Object = null;
         var j:int = 0;
         this.mAllRawChannels = res.data;
         var channelCount:int = int(this.mAllRawChannels.length);
         var bookedChannelCount:int = int(this.mPrivateChannelKeeper.length);
         var hasPrivateChannel:Boolean = false;
         for(var i:int = 0; i < channelCount; i++)
         {
            if(this.mAllRawChannels[i].id == ChattingChannelType.PRIVATE)
            {
               hasPrivateChannel = true;
               channelKeeper = null;
               for(j = 0; j < bookedChannelCount; j++)
               {
                  if(this.mAllRawChannels[i].targetID == this.mPrivateChannelKeeper[j].rawChannel.targetID)
                  {
                     channelKeeper = this.mPrivateChannelKeeper[j];
                     break;
                  }
               }
               if(null == channelKeeper)
               {
                  channelKeeper = new Object();
                  channelKeeper.rawChannel = this.mAllRawChannels[i];
                  this.mPrivateChannelKeeper.push(channelKeeper);
               }
            }
            this.mAllRawChannels[i].numUnread = this.getNewMessageCount(this.mAllRawChannels[i].msgHistory);
         }
         this.mChatChannels[PRIVATE_CHANNEL_INDEX] = hasPrivateChannel;
         this.refreshChannels();
         this.myPrivateChannelSelector.setData(this.mPrivateChannelKeeper);
      }
      
      private function onGetRoomInfo(res:Object) : void
      {
         this.myControlPanel.setRoomInfo(res.data);
         if(res.data != null && this.myBg.visible)
         {
            TweenLite.to(this.myBg,0.25,{
               "alpha":0,
               "onComplete":this.onFadeOutComplete
            });
         }
         else if(res.data == null && !this.myBg.visible)
         {
            this.myBg.visible = true;
            TweenLite.to(this.myBg,0.25,{"alpha":0.5});
         }
      }
      
      private function onFadeOutComplete() : void
      {
         this.myBg.visible = false;
      }
      
      private function onInventoryUpdate(cEvt:ParaEvent) : void
      {
         this.refreshLoudSpeakerCount();
      }
      
      private function onGlobalChatBroken(cEvt:ParaEvent) : void
      {
         this.onGlobalChatChannelStateChanged(cEvt);
         this.onBigSpeakerChannelStateChanged(cEvt);
      }
      
      private function onGlobalChatChannelStateChanged(cEvt:ParaEvent) : void
      {
         this.mGlobalChatJoined = getDP(DataID.IS_IN_GLOBAL_CHANNEL);
         this.mGlobalChatLocked = Boolean(getDP(DataID.IS_GLOBAL_CHAT_LOCKED)) || Boolean(getDP(DataID.IS_GLOBAL_CHAT_BROKEN));
         if(this.mCurrentChannelType == ChattingChannelType.GLOBAL)
         {
            this.myChatList.switchJoiningGlobalChatNote(!this.mGlobalChatJoined || this.mGlobalChatLocked);
            if(!this.mGlobalChatJoined && this.mState == INPUT_STATE)
            {
               this.tryToCloseInput();
            }
         }
         this.mySmallSpeakerBtn.enabled = this.mGlobalChatJoined;
         this.myChatList.switchGlobalChatLocked(this.mGlobalChatLocked);
         this.myControlPanel.switchGlobalChatLocked(this.mGlobalChatLocked);
         if(this.mGlobalChatJoined)
         {
            this.myControlPanel.setJoinedGlobalChatGroup(getDP(DataID.JOINED_GLOBAL_CHAT_GROUP));
         }
         else
         {
            this.myControlPanel.setJoinedGlobalChatGroup(-1);
         }
      }
      
      private function onBigSpeakerChannelStateChanged(cEvt:ParaEvent) : void
      {
         this.myBigSpeakerBtn.enabled = Boolean(getDP(DataID.IS_IN_BIG_SPEAKER_CHANNEL)) && !getDP(DataID.IS_GLOBAL_CHAT_LOCKED) && !getDP(DataID.IS_GLOBAL_CHAT_BROKEN);
      }
      
      private function refreshLoudSpeakerCount() : void
      {
         this.mBigSpeakerTokenCount = getDP(DataID.BIG_LOUD_SPEAKER_COUNT);
         this.mSmallSpeakerTokenCount = getDP(DataID.SMALL_LOUD_SPEAKER_COUNT);
         this.myBigSpeakerBtn.tokenCount = LocalizeUtil.param(DictChatting.LOUD_SPEAKER_COUNT,[this.mBigSpeakerTokenCount]);
         this.mySmallSpeakerBtn.tokenCount = LocalizeUtil.param(DictChatting.LOUD_SPEAKER_COUNT,[this.mSmallSpeakerTokenCount]);
         this.myLoudSpeakerPanel.updateLoudSpeakerCount(ChatSpeakerType.SPEAKER_TYPE_SMALL,this.mSmallSpeakerTokenCount);
         this.myLoudSpeakerPanel.updateLoudSpeakerCount(ChatSpeakerType.SPEAKER_TYPE_BIG,this.mBigSpeakerTokenCount);
      }
      
      private function onLoudSpeakerBtnClicked(loudSpeakerType:int) : void
      {
         var tokenCount:int = loudSpeakerType == ChatSpeakerType.SPEAKER_TYPE_BIG ? this.mBigSpeakerTokenCount : this.mSmallSpeakerTokenCount;
         if(tokenCount > 0)
         {
            this.showLoudSpeakerPostPanel(loudSpeakerType);
         }
         else
         {
            this.showLoudSpeakerPurchasePanel(loudSpeakerType);
         }
      }
      
      private function onReceiveChatMessage(cEvt:ParaEvent) : void
      {
         var msgObj:ChatMessageObj = cEvt.myPara;
         if(msgObj.channelID == this.mCurrentChannelType)
         {
            this.refreshHistoryList();
         }
      }
      
      private function onShowSpeakAnimation(cEvt:ParaEvent) : void
      {
         var duration:int = 0;
         var msgObj:ChatMessageObj = cEvt.myPara;
         if(msgObj.loudSpeakerType == ChatSpeakerType.SPEAKER_TYPE_BIG)
         {
            duration = getDP(DataCommonID.BIG_LOUD_SPEAKER_SHOW_DURATION);
            this.myChatBigSpeaker.showMessage(msgObj.loudSpeakerType,msgObj.senderName,msgObj.message,duration);
         }
         else if(msgObj.loudSpeakerType == ChatSpeakerType.SPEAKER_TYPE_SMALL)
         {
            duration = getDP(DataCommonID.SMALL_LOUD_SPEAKER_SHOW_DURATION);
            this.myChatBigSpeaker.showMessage(msgObj.loudSpeakerType,msgObj.senderName,msgObj.message,duration);
         }
      }
      
      private function onLoudSpeakerSendSuccess(cEvt:ParaEvent) : void
      {
         var loudSpeakerType:int = cEvt.myPara;
         this.myLoudSpeakerPanel.sendLoudSpeakerSuccess(loudSpeakerType);
      }
      
      private function onInvokeChat(cEvt:ParaEvent) : void
      {
         var data:Object = cEvt.myPara;
         var chatChannelIndex:int = int(data.firstLevelIndex);
         var privateChatUserId:String = data.secondLevelData;
         this.myControlPanel.selectChannel(chatChannelIndex);
         if(chatChannelIndex == PRIVATE_CHANNEL_INDEX)
         {
            this.myControlPanel.switchExpandChatPanel(true);
            this.myPrivateChannelSelector.selectUserById(privateChatUserId);
         }
      }
      
      private function onShowEvt(myPara:ParaEvent) : void
      {
         this.visible = true;
      }
      
      private function onHideEvt(myPara:ParaEvent) : void
      {
         this.visible = false;
      }
      
      private function onChannelButtonClicked(channelIndex:int) : void
      {
         var candidateChannelType:uint = 0;
         if(channelIndex == GLOBAL_CHANNEL_INDEX)
         {
            candidateChannelType = ChattingChannelType.GLOBAL;
         }
         else if(channelIndex == CLAN_CHANNEL_INDEX)
         {
            candidateChannelType = ChattingChannelType.CLAN;
         }
         else if(channelIndex == PARTY_CHANNEL_INDEX)
         {
            candidateChannelType = ChattingChannelType.PARTY;
         }
         else if(channelIndex == PRIVATE_CHANNEL_INDEX)
         {
            candidateChannelType = ChattingChannelType.PRIVATE;
         }
         else if(channelIndex == ROOM_CHANNEL_INDEX)
         {
            candidateChannelType = ChattingChannelType.ROOM;
         }
         else if(channelIndex == TEAM_CHANNEL_INDEX)
         {
            candidateChannelType = ChattingChannelType.ROOM_TEAM;
         }
         if(this.mCurrentChannelType != candidateChannelType)
         {
            this.mCurrentChannelType = candidateChannelType;
            this.checkPrivateChannelState();
            this.refreshHistoryList();
            if(this.mCurrentChannelType == GLOBAL_CHANNEL_INDEX && this.mState == INPUT_STATE && !this.checkCanChangeMainChatPanel(true))
            {
               this.tryToCloseInput();
            }
         }
      }
      
      private function refreshHistoryList() : void
      {
         var channelHistory:Array = null;
         var channelHistoryLen:int = 0;
         var historyCount:int = 0;
         var i:int = 0;
         if(this.mCurrentChannelType == ChattingChannelType.GLOBAL && !this.mGlobalChatJoined)
         {
            this.myChatList.switchJoiningGlobalChatNote(true);
            return;
         }
         this.myChatList.switchJoiningGlobalChatNote(false);
         var briefHistory:Vector.<Object> = new Vector.<Object>();
         var wholeHistory:Vector.<Object> = new Vector.<Object>();
         var channelObj:ChatChannelObj = this.getAppropriateChatChannel();
         var isChannelSwitched:Boolean = this.isChannelSwitched(channelObj);
         this.mChatChannelBeingShown = channelObj;
         if(Boolean(channelObj))
         {
            if(channelObj.id == ChattingChannelType.PRIVATE)
            {
               this.myControlPanel.customizeChannelLabel(channelObj.targetName);
            }
            channelHistory = channelObj.msgHistory;
            channelHistoryLen = int(channelHistory.length);
            historyCount = 0;
            for(i = channelHistoryLen - 1; i >= 0; i--)
            {
               if(historyCount < ChatHistoryList.MAX_CHAT_CAN_HOLD)
               {
                  briefHistory.unshift(channelHistory[i]);
               }
               if(historyCount < MainChatPanel.MAX_EXPANDED_CHAT_CAN_HOLD)
               {
                  wholeHistory.unshift(channelHistory[i]);
               }
               channelHistory[i].isNew = false;
               historyCount++;
            }
            channelObj.numUnread = 0;
            this.myPrivateChannelSelector.cleanRedDot();
            this.myControlPanel.refreshUnread(this.mAllRawChannels);
         }
         this.myChatList.setHistroy(briefHistory);
         this.myMainChatPanel.setHistory(wholeHistory,isChannelSwitched);
      }
      
      private function isChannelSwitched(newChannel:ChatChannelObj) : Boolean
      {
         if(this.mChatChannelBeingShown == null || newChannel == null)
         {
            return true;
         }
         if(this.mChatChannelBeingShown.id != newChannel.id)
         {
            return true;
         }
         if(newChannel.id == ChattingChannelType.PRIVATE && this.mChatChannelBeingShown.targetID != newChannel.targetID)
         {
            return true;
         }
         return false;
      }
      
      private function checkPrivateChannelState() : void
      {
         this.myPrivateChannelSelector.visible = this.mCurrentChannelType == ChattingChannelType.PRIVATE;
      }
      
      private function onExpandButtonClicked(expandStatus:Boolean) : void
      {
         if(!this.checkCanChangeMainChatPanel(expandStatus))
         {
            return;
         }
         this.myMainChatPanel.visible = expandStatus;
         this.myChatList.visible = !expandStatus;
         this.myMessageSender.visible = expandStatus;
         this.myControlPanel.updateExpandBtnState(expandStatus);
         this.myControlPanel.updateRoomChannelButtonPosition(expandStatus);
         if(expandStatus)
         {
            this.myMessageSender.focusInput();
         }
         else
         {
            this.myMessageSender.unfocusInput();
         }
         this.myChatBigSpeaker.y = expandStatus ? -355 : -56;
         this.myChatBigSpeaker.myBlueLine.visible = expandStatus;
         this.myPrivateChannelSelector.visible = expandStatus ? this.mCurrentChannelType == ChattingChannelType.PRIVATE : false;
         this.mState = expandStatus ? INPUT_STATE : VIEW_STATE;
         this.closeContextMenu();
      }
      
      private function checkCanChangeMainChatPanel(wantToExpand:Boolean) : Boolean
      {
         if(!wantToExpand)
         {
            return true;
         }
         if(this.mCurrentChannelType == ChattingChannelType.GLOBAL && !this.mGlobalChatJoined)
         {
            return false;
         }
         return true;
      }
      
      private function showLoudSpeakerPostPanel(type:int) : void
      {
         this.myLoudSpeakerPanel.active();
         this.myLoudSpeakerPanel.setLoudSpeakerType(type);
      }
      
      private function showLoudSpeakerPurchasePanel(type:int) : void
      {
         broadcast(BCEvent.EVT_REQUEST_PURCHASE_LOUD_SPEAKER,type == ChatSpeakerType.SPEAKER_TYPE_BIG);
      }
      
      private function onJoinClanHandler() : void
      {
         this.mChatChannels[CLAN_CHANNEL_INDEX] = true;
         this.refreshChannels();
      }
      
      private function onLeftClanHandler() : void
      {
         this.mChatChannels[CLAN_CHANNEL_INDEX] = false;
         this.refreshChannels();
      }
      
      private function onPartyStateChangeHandler() : void
      {
         this.mChatChannels[PARTY_CHANNEL_INDEX] = getDP(DataID.IS_IN_PARTY);
         this.refreshChannels();
      }
      
      private function refreshChannels() : void
      {
         this.myControlPanel.refreshChannels(this.mChatChannels);
         this.myControlPanel.refreshUnread(this.mAllRawChannels);
      }
      
      private function onClickChatList(event:MouseEvent) : void
      {
         var exEvent:MouseEventEx = null;
         if(ScaleformUtil.isScaleform)
         {
            exEvent = event as MouseEventEx;
            if(exEvent.buttonIdx != MouseEventEx.LEFT_BUTTON)
            {
               return;
            }
         }
         this.tryToOpenInput();
      }
      
      private function onPostMessage(msg:String, fromButton:Boolean) : void
      {
         if(msg.length <= 0 && !fromButton)
         {
            this.tryToCloseInput();
            return;
         }
         var channelObj:ChatChannelObj = this.getAppropriateChatChannel();
         broadcast(BCEvent.EVT_SEND_CHAT_MSG,{
            "channel":channelObj,
            "message":msg
         });
      }
      
      private function onPrivateChannelSelectionChanged(index:int) : void
      {
         if(this.mSelectedPrivateChannel != index)
         {
            this.mSelectedPrivateChannel = index;
            this.refreshHistoryList();
         }
      }
      
      private function onPrivateChannelClosed(channelObj:ChatChannelObj) : void
      {
         this.removeClosingPrivateChannel(channelObj);
         broadcast(BCEvent.EVT_CLOSE_PRIVATE_CHAT,{"channel":channelObj});
      }
      
      private function onShowAnimationCompleteHandler() : void
      {
         broadcast(BCCommonEvent.EVT_HIDE_SPEAKER_ANIMATION);
      }
      
      private function removeClosingPrivateChannel(channelObj:ChatChannelObj) : void
      {
         var numPrivateChannelKeeper:int = int(this.mPrivateChannelKeeper.length);
         for(var i:int = 0; i < numPrivateChannelKeeper; i++)
         {
            if(this.mPrivateChannelKeeper[i].rawChannel == channelObj)
            {
               this.mPrivateChannelKeeper.splice(i,1);
               break;
            }
         }
      }
      
      private function onStageKeyHandle(cEvt:KeyboardEvent) : void
      {
         if(cEvt.type == KeyboardEvent.KEY_DOWN)
         {
            if(cEvt.keyCode == Keyboard.ENTER || cEvt.keyCode == Keyboard.NUMPAD_ENTER)
            {
               if(this.mState == INPUT_STATE)
               {
                  this.tryToCloseInput();
               }
               else
               {
                  this.tryToOpenInput();
               }
            }
            else if(cEvt.keyCode == Keyboard.ESCAPE)
            {
               if(this.mState == INPUT_STATE)
               {
                  this.tryToCloseInput();
               }
            }
         }
      }
      
      private function getAppropriateChatChannel() : ChatChannelObj
      {
         var channelObj:ChatChannelObj = null;
         if(this.mCurrentChannelType == ChattingChannelType.PRIVATE)
         {
            if(this.mSelectedPrivateChannel >= 0 && this.mSelectedPrivateChannel < this.mPrivateChannelKeeper.length)
            {
               channelObj = this.mPrivateChannelKeeper[this.mSelectedPrivateChannel].rawChannel;
            }
            if(null == channelObj && this.mPrivateChannelKeeper.length > 0)
            {
               channelObj = this.mPrivateChannelKeeper[0].rawChannel;
            }
         }
         else
         {
            channelObj = getDP(DataID.CHAT_CHANNEL_OBJ,[this.mCurrentChannelType]);
         }
         return channelObj;
      }
      
      private function getNewMessageCount(msgHistroy:Array) : int
      {
         var msg:ChatMessageObj = null;
         var unreadCount:int = 0;
         var numMsg:int = int(msgHistroy.length);
         for(var i:int = 0; i < numMsg; i++)
         {
            msg = msgHistroy[i];
            if(msg.isNew && !msg.selfSend)
            {
               unreadCount++;
            }
         }
         return unreadCount;
      }
      
      private function tryToOpenInput() : void
      {
         if(Boolean(getDP(DataID.HAS_POPUP)) || this.mState == INPUT_STATE)
         {
            return;
         }
         this.onExpandButtonClicked(true);
      }
      
      private function tryToCloseInput() : void
      {
         if(Boolean(getDP(DataID.HAS_POPUP)) || this.mState == VIEW_STATE)
         {
            return;
         }
         this.onExpandButtonClicked(false);
      }
      
      private function closeContextMenu() : void
      {
         broadcast(BCEvent.EVT_HIDE_PLAYER_CONTEXT_MENU);
      }
   }
}

