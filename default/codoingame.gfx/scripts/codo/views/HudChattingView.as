package codo.views
{
   import codo.base.BaseView;
   import codo.constants.BCInGameEvent;
   import codo.constants.DataInGameID;
   import codo.constants.GameInfo;
   import codo.event.ParaEvent;
   import codo.objects.ChatChannelObj;
   import codo.utils.Logger;
   import components.CodoComboBox;
   import components.chatting_part.ChatModule;
   import components.chatting_part.HudChatModule;
   import flash.display.MovieClip;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.ui.Keyboard;
   import flash.utils.Timer;
   
   public class HudChattingView extends BaseView
   {
      
      public var myChannelCB:CodoComboBox;
      
      public var myChatModule:HudChatModule;
      
      public var myBG:MovieClip;
      
      private var _hideHistoryTimer:Timer = new Timer(5000,1);
      
      public function HudChattingView()
      {
         super();
      }
      
      override protected function onInit() : void
      {
         tabChildren = false;
         this.myChannelCB.tabEnabled = false;
         x = 955;
         y = 400;
         x += GameInfo.widthExtra;
         this.myChannelCB.visible = false;
         this.myBG.visible = false;
         this.myChatModule.setMode(HudChatModule.PLAY_MODE);
      }
      
      override protected function onInitListener() : void
      {
         this.myChatModule.addEventListener(ChatModule.SEND_MESSGAE,this.onSendChatMessage);
         this._hideHistoryTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onHideHistoryTimerComplete);
         listen(BCInGameEvent.TOGGLE_CHAT,this.onToggleChat);
         listen(BCInGameEvent.EVT_ON_CHAT_MSG_RECEIVED,this.onChatMsgReceived);
         bind(DataInGameID.CHATTING_CHANNELS,this.bind_chatChannels);
         bind(DataInGameID.CHATTING_VIEW_ROTATION,this.bind_chatViewRotation);
         broadcast(BCInGameEvent.EVT_ON_CHAT_VIEW_READY);
      }
      
      private function showPanel(showInputBox:Boolean) : void
      {
         Logger.print("HudChattingView:::inputAble cSwi: " + showInputBox);
         this.myChannelCB.visible = showInputBox;
         this.myBG.visible = showInputBox;
         this.myChatModule.setMode(showInputBox ? HudChatModule.INPUT_MODE : HudChatModule.SHOW_MODE);
         this._hideHistoryTimer.reset();
         Logger.print("HudChattingView:::inputAble _hideHistoryTimer.running: " + this._hideHistoryTimer.running);
         if(showInputBox)
         {
            stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onStageKeyDown);
            stage.addEventListener(MouseEvent.MOUSE_DOWN,this.onLocalMouseDownHandler);
         }
         else
         {
            this._hideHistoryTimer.start();
            stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onStageKeyDown);
            stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.onLocalMouseDownHandler);
         }
         Logger.print("HudChattingView:::inputAble _hideHistoryTimer.running: " + this._hideHistoryTimer.running);
      }
      
      private function onHideHistoryTimerComplete(evt:TimerEvent) : void
      {
         Logger.print("HudChattingView:::onHideHistoryTimerComplete...");
         this.myChatModule.setMode(HudChatModule.PLAY_MODE);
      }
      
      private function bind_chatChannels(cRes:Object) : void
      {
         var channel:ChatChannelObj = null;
         var writableChannels:Array = [];
         for each(channel in cRes.data)
         {
            if(!channel.readonly)
            {
               writableChannels.push(channel);
            }
         }
         this.myChannelCB.dataProvider = writableChannels;
      }
      
      private function bind_chatViewRotation(cRes:Object) : void
      {
         this.rotationY = cRes.data;
      }
      
      private function onSendChatMessage(cEvt:ParaEvent) : void
      {
         broadcast(BCInGameEvent.EVT_SEND_CHAT_MSG,{
            "channel":this.myChannelCB.selectedValue,
            "message":cEvt.myPara
         });
      }
      
      private function onStageKeyDown(cEvt:KeyboardEvent) : void
      {
         switch(cEvt.keyCode)
         {
            case Keyboard.NUMPAD_ENTER:
            case Keyboard.ENTER:
               this.myChatModule.focusIn(true);
               break;
            case Keyboard.TAB:
               if(this.myChannelCB.selectedDataIndex < this.myChannelCB.dataProvider.length - 1)
               {
                  ++this.myChannelCB.selectedDataIndex;
               }
               else
               {
                  this.myChannelCB.selectedDataIndex = 0;
               }
         }
      }
      
      private function onLocalMouseDownHandler(cEvt:MouseEvent) : void
      {
         this.myChatModule.focusIn(true);
      }
      
      private function onToggleChat(cEvt:ParaEvent) : void
      {
         Logger.print("HudChattingView:::onToggleChat cEvt.myPara: " + cEvt.myPara);
         this.showPanel(cEvt.myPara);
      }
      
      private function onChatMsgReceived(cEvt:ParaEvent) : void
      {
         Logger.print("HudChattingView:::onChatMsgReceived cEvt.myPara: " + cEvt.myPara);
         this.myChatModule.newMsg(cEvt.myPara);
         if((this.myChatModule.getMode() == HudChatModule.PLAY_MODE || this.myChatModule.getMode() == HudChatModule.SHOW_MODE) && Boolean(cEvt.myPara.isNew))
         {
            this._hideHistoryTimer.reset();
            this._hideHistoryTimer.start();
            this.myChatModule.setMode(HudChatModule.SHOW_MODE);
         }
      }
   }
}

