package codo.views.chat_parts
{
   import codo.component.Button;
   import codo.component.TextField;
   import codo.component.core.UIInteractiveComponent;
   import codo.constants.ChattingChannelType;
   import codo.localization.DictChatting;
   import codo.objects.ChatChannelObj;
   import codo.objects.RoomInfoObj;
   import codo.style.ChatGuide;
   import codo.style.GlobalGuide;
   import codo.utils.LocalizeUtil;
   import codo.utils.TextUtil;
   import codo.views.ChatView;
   import flash.display.MovieClip;
   
   public class ControlPanel extends MovieClip
   {
      
      private static const EXPAND_Y:int = -332;
      
      private static const RETRACT_Y:int = -35;
      
      private static const ROOM_CHAT_BUTTON_START_X:int = 250;
      
      private static const ROOM_CHAT_BUTTON_GAP:int = 5;
      
      public var myChannelLabel:TextField;
      
      public var myChannel:TextField;
      
      public var myGlobalChannelBtn:ControlPanelChannelSelector;
      
      public var myClanChannelBtn:ControlPanelChannelSelector;
      
      public var myPartyChannelBtn:ControlPanelChannelSelector;
      
      public var myPrivateChannelBtn:ControlPanelChannelSelector;
      
      public var myRoomChannelBtn:ControlPanelChannelSelector;
      
      public var myTeamChannelBtn:ControlPanelChannelSelector;
      
      public var myExpandBtn:ExpandButton;
      
      public var myChatCloseHitArea:UIInteractiveComponent;
      
      private var mChatPanelExpandStatus:Boolean = false;
      
      private var mChannelButtonClickHanlder:Function;
      
      private var mExpandButtonClickHandler:Function;
      
      private var mCurrentIndex:int = -1;
      
      private var mChannelBtns:Array;
      
      private var mRoomInfo:Object;
      
      private var mJoinedGlobalChatGroup:int = -1;
      
      private var mGlobalChatLocked:Boolean = false;
      
      public function ControlPanel()
      {
         super();
         this.mChannelBtns = [this.myGlobalChannelBtn,this.myClanChannelBtn,this.myPartyChannelBtn,this.myPrivateChannelBtn,this.myRoomChannelBtn,this.myTeamChannelBtn];
         this.myClanChannelBtn.x = this.myGlobalChannelBtn.x + ChatGuide.CHANNEL_BTN_WIDTH + ChatGuide.CHANNEL_BTN_PADDING;
         this.myPartyChannelBtn.x = this.myClanChannelBtn.x + ChatGuide.CHANNEL_BTN_WIDTH + ChatGuide.CHANNEL_BTN_PADDING;
         this.myPrivateChannelBtn.x = this.myPartyChannelBtn.x + ChatGuide.CHANNEL_BTN_WIDTH + ChatGuide.CHANNEL_BTN_PADDING;
         this.myExpandBtn.x = this.myPrivateChannelBtn.x;
         this.myGlobalChannelBtn.icon = ControlPanelChannelSelector.FRAME_GLOBAL;
         this.myClanChannelBtn.icon = ControlPanelChannelSelector.FRAME_CLAN;
         this.myPartyChannelBtn.icon = ControlPanelChannelSelector.FRAME_PARTY;
         this.myPrivateChannelBtn.icon = ControlPanelChannelSelector.FRAME_PRIVATE;
         this.myRoomChannelBtn.label = DictChatting.CHATTING_CHANNEL_ROOM;
         this.myTeamChannelBtn.label = DictChatting.CHATTING_CHANNEL_ROOM_TEAM;
         this.myRoomChannelBtn.width = this.myTeamChannelBtn.width = 60;
         this.myRoomChannelBtn.height = this.myTeamChannelBtn.height = 30;
         this.myTeamChannelBtn.x = this.myRoomChannelBtn.x + this.myRoomChannelBtn.width + ROOM_CHAT_BUTTON_GAP;
         this.myChannelLabel.textStyle = ChatGuide.styleChannelLabel;
         this.myChannelLabel.enableTruncate(true);
         this.myChannelLabel.text = DictChatting.CHANNEL_LABEL;
         this.myChannel.x = this.myChannelLabel.x + this.myChannelLabel.textWidth + 10;
         this.myChannel.width = this.myExpandBtn.x - this.myChannel.x;
         this.myChannel.textStyle = ChatGuide.styleChannelName;
         this.myGlobalChannelBtn.registerClickEvent(this.selectChannel,ChatView.GLOBAL_CHANNEL_INDEX);
         this.myClanChannelBtn.registerClickEvent(this.selectChannel,ChatView.CLAN_CHANNEL_INDEX);
         this.myPartyChannelBtn.registerClickEvent(this.selectChannel,ChatView.PARTY_CHANNEL_INDEX);
         this.myPrivateChannelBtn.registerClickEvent(this.selectChannel,ChatView.PRIVATE_CHANNEL_INDEX);
         this.myRoomChannelBtn.registerClickEvent(this.selectChannel,ChatView.ROOM_CHANNEL_INDEX);
         this.myTeamChannelBtn.registerClickEvent(this.selectChannel,ChatView.TEAM_CHANNEL_INDEX);
         this.myExpandBtn.registerClickEvent(this.onExpandButtonSelected);
         this.myChatCloseHitArea.isInteractiveEnabled = true;
         this.myChatCloseHitArea.visible = false;
         this.myChatCloseHitArea.registerClickEvent(this.onExpandButtonSelected);
         this.mRoomInfo = null;
         this.myRoomChannelBtn.visible = this.myTeamChannelBtn.visible = false;
      }
      
      public function set themeColor(col:uint) : void
      {
         this.myChannelLabel.fontColor = col;
         this.myRoomChannelBtn.labelUnfocusColor = col;
         this.myTeamChannelBtn.labelUnfocusColor = col;
         this.myRoomChannelBtn.labelClickColor = col;
         this.myTeamChannelBtn.labelClickColor = col;
      }
      
      public function registerChannelButtonClickHandler(selectHandler:Function) : void
      {
         this.mChannelButtonClickHanlder = selectHandler;
      }
      
      public function registerExpandButtonClickHandler(expandHandler:Function) : void
      {
         this.mExpandButtonClickHandler = expandHandler;
      }
      
      private function onExpandButtonSelected() : void
      {
         this.switchExpandChatPanel(!this.mChatPanelExpandStatus);
      }
      
      public function refreshChannels(channels:Array) : void
      {
         this.myGlobalChannelBtn.enabled = channels[ChatView.GLOBAL_CHANNEL_INDEX];
         this.myClanChannelBtn.enabled = channels[ChatView.CLAN_CHANNEL_INDEX];
         this.myPartyChannelBtn.enabled = channels[ChatView.PARTY_CHANNEL_INDEX];
         this.myPrivateChannelBtn.enabled = channels[ChatView.PRIVATE_CHANNEL_INDEX];
         if(this.mCurrentIndex == -1 || !channels[this.mCurrentIndex])
         {
            this.selectChannel(ChatView.GLOBAL_CHANNEL_INDEX);
         }
      }
      
      public function refreshUnread(channels:Array) : void
      {
         var channel:ChatChannelObj = null;
         var channelIDs:Array = [ChattingChannelType.GLOBAL,ChattingChannelType.CLAN,ChattingChannelType.PARTY,ChattingChannelType.ROOM,ChattingChannelType.ROOM_TEAM,ChattingChannelType.PRIVATE];
         for(var chIndex:int = 0; chIndex < channelIDs.length; chIndex++)
         {
            this.updateUnreadState(channelIDs[chIndex],0);
         }
         var privateNumUnread:int = 0;
         var numChannels:int = int(channels.length);
         for(var i:int = 0; i < numChannels; i++)
         {
            channel = channels[i];
            if(channel.id == ChattingChannelType.GLOBAL || channel.id == ChattingChannelType.CLAN || channel.id == ChattingChannelType.PARTY || channel.id == ChattingChannelType.ROOM || channel.id == ChattingChannelType.ROOM_TEAM)
            {
               this.updateUnreadState(channel.id,channel.numUnread);
            }
            else if(channel.id == ChattingChannelType.PRIVATE)
            {
               privateNumUnread += channel.numUnread;
            }
         }
         this.updateUnreadState(ChattingChannelType.PRIVATE,privateNumUnread);
      }
      
      public function switchExpandChatPanel(isExpand:Boolean) : void
      {
         if(this.mExpandButtonClickHandler != null)
         {
            this.mExpandButtonClickHandler(isExpand);
         }
      }
      
      public function updateRoomChannelButtonPosition(isExpand:Boolean) : void
      {
         this.myRoomChannelBtn.y = isExpand ? EXPAND_Y : RETRACT_Y;
         this.myTeamChannelBtn.y = isExpand ? EXPAND_Y : RETRACT_Y;
      }
      
      public function setRoomInfo(roomInfo:Object) : void
      {
         if(roomInfo == null)
         {
            this.mRoomInfo = null;
            this.myRoomChannelBtn.visible = this.myTeamChannelBtn.visible = false;
            this.selectChannel(ChatView.GLOBAL_CHANNEL_INDEX);
            return;
         }
         if(this.mRoomInfo == null)
         {
            if(Boolean(roomInfo.isWarGod))
            {
               this.selectChannel(ChatView.TEAM_CHANNEL_INDEX);
            }
            else
            {
               this.selectChannel(ChatView.ROOM_CHANNEL_INDEX);
            }
         }
         this.myRoomChannelBtn.visible = true;
         this.myTeamChannelBtn.visible = true;
         var roomInfoObj:RoomInfoObj = roomInfo.forces;
         var hasTwoForce:Boolean = roomInfoObj.showForce0 && roomInfoObj.showForce1;
         this.myTeamChannelBtn.visible = hasTwoForce;
         if(Boolean(roomInfo.isWarGod))
         {
            this.myRoomChannelBtn.visible = false;
            this.myTeamChannelBtn.visible = false;
         }
         this.mRoomInfo = roomInfo;
         this.arrangeRoomChatButtons();
      }
      
      private function arrangeRoomChatButtons() : void
      {
         var chatButtons:Array = [this.myRoomChannelBtn,this.myTeamChannelBtn];
         var buttonXSoFar:Number = ROOM_CHAT_BUTTON_START_X;
         for(var i:int = 0; i < chatButtons.length; i++)
         {
            if(Boolean(chatButtons[i].visible))
            {
               chatButtons[i].x = buttonXSoFar;
               buttonXSoFar += chatButtons[i].width + ROOM_CHAT_BUTTON_GAP;
            }
         }
      }
      
      public function updateExpandBtnState(isExpand:Boolean) : void
      {
         this.mChatPanelExpandStatus = isExpand;
         this.myExpandBtn.expand = this.mChatPanelExpandStatus;
         this.myChatCloseHitArea.visible = isExpand;
      }
      
      public function selectChannel(index:int) : void
      {
         if(this.mCurrentIndex == index)
         {
            return;
         }
         var channelBtnCount:int = int(this.mChannelBtns.length);
         for(var i:int = 0; i < channelBtnCount; i++)
         {
            (this.mChannelBtns[i] as Button).selected = index == i;
         }
         this.mCurrentIndex = index;
         this.setChannelLabel(ChatView.CHANNEL_NAMES[index]);
         this.updateChannelLabel();
         if(null != this.mChannelButtonClickHanlder)
         {
            this.mChannelButtonClickHanlder(index);
         }
      }
      
      public function customizeChannelLabel(label:String) : void
      {
         this.setChannelLabel(label);
      }
      
      private function setChannelLabel(label:String) : void
      {
         this.myChannel.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         this.myChannel.text = label;
         TextUtil.resizeTextToFitWidth(this.myChannel.myTextClip);
      }
      
      private function updateUnreadState(type:uint, unread:int) : void
      {
         var button:ControlPanelChannelSelector = this.getButtonByChatChannelType(type);
         button.unreadNum = unread;
      }
      
      private function getButtonByChatChannelType(type:uint) : ControlPanelChannelSelector
      {
         if(type == ChattingChannelType.GLOBAL)
         {
            return this.myGlobalChannelBtn;
         }
         if(type == ChattingChannelType.CLAN)
         {
            return this.myClanChannelBtn;
         }
         if(type == ChattingChannelType.PARTY)
         {
            return this.myPartyChannelBtn;
         }
         if(type == ChattingChannelType.ROOM)
         {
            return this.myRoomChannelBtn;
         }
         if(type == ChattingChannelType.ROOM_TEAM)
         {
            return this.myTeamChannelBtn;
         }
         if(type == ChattingChannelType.PRIVATE)
         {
            return this.myPrivateChannelBtn;
         }
         return null;
      }
      
      public function setJoinedGlobalChatGroup(group:int) : void
      {
         this.mJoinedGlobalChatGroup = group;
         this.updateChannelLabel();
      }
      
      private function updateChannelLabel() : void
      {
         var name:String = null;
         if(this.mCurrentIndex == ChatView.GLOBAL_CHANNEL_INDEX)
         {
            if(this.mJoinedGlobalChatGroup == -1)
            {
               if(this.mGlobalChatLocked)
               {
                  name = DictChatting.NO_GLOBAL_CHAT_SERVICE;
               }
               else
               {
                  name = DictChatting.NO_GLOBAL_CHANNEL;
               }
            }
            else
            {
               name = LocalizeUtil.param(ChatView.CHANNEL_NAMES[this.mCurrentIndex],[this.mJoinedGlobalChatGroup + 1]);
            }
            this.setChannelLabel(name);
         }
      }
      
      public function switchGlobalChatLocked(locked:Boolean) : void
      {
         this.mGlobalChatLocked = locked;
      }
   }
}

