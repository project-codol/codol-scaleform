package codo.views.hudShared
{
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionInGameContainer;
   import codo.component.core.UIInteractiveComponent;
   import codo.constants.BCInGameEvent;
   import codo.constants.DataID;
   import codo.manager.DataManager;
   import codo.manager.EventManager;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.text.TextField;
   
   public class HudQuickChatWheelPart extends UIInteractiveComponent
   {
      
      public var myIndex:TextField;
      
      public var myText:TextField;
      
      public var myActiveBg:MovieClip;
      
      public var myDeactiveBg:MovieClip;
      
      private var mActiveBgColor:uint;
      
      private var mDeactiveBgColor:uint;
      
      private var mActiveTextColor:uint;
      
      private var mDeactiveTextColor:uint;
      
      private var mIsActive:Boolean;
      
      private var mChannel:int;
      
      private var mIndex:int;
      
      private var mTitle:String;
      
      private var mMessage:String;
      
      private var mIsRoomMessage:Boolean;
      
      public function HudQuickChatWheelPart()
      {
         super();
         this.mIsActive = false;
         this.mActiveBgColor = 16777215;
         this.mDeactiveBgColor = 0;
         this.mActiveTextColor = 16777215;
         this.mDeactiveTextColor = 0;
         this.mIndex = 0;
         isInteractiveEnabled = true;
         this.addEventListener(MouseEvent.CLICK,this.onClicked);
         gotoAndStop(1);
      }
      
      public function get isActive() : Boolean
      {
         return this.mIsActive;
      }
      
      public function set isActive(active:Boolean) : void
      {
         this.mIsActive = active;
         if(this.mIsActive)
         {
            gotoAndStop(2);
            this.myIndex.textColor = this.mActiveTextColor;
            this.myActiveBg.visible = true;
            this.myDeactiveBg.visible = false;
            this.myText.text = this.mTitle;
            this.myText.textColor = this.mActiveTextColor;
         }
         else
         {
            gotoAndStop(1);
            this.myIndex.textColor = this.mDeactiveTextColor;
            this.myActiveBg.visible = false;
            this.myDeactiveBg.visible = true;
            this.myText.text = this.mTitle;
            this.myText.textColor = this.mDeactiveTextColor;
         }
      }
      
      public function set deactiveBgColor(color:uint) : void
      {
         this.mDeactiveBgColor = color;
         var redChannel:Number = (this.mDeactiveBgColor >> 16 & 0xFF) / 255;
         var greenChannel:Number = (this.mDeactiveBgColor >> 8 & 0xFF) / 255;
         var blueChannel:Number = (this.mDeactiveBgColor & 0xFF) / 255;
         var colorMat:Array = [redChannel,0,0,0,0,0,greenChannel,0,0,0,0,0,blueChannel,0,0,0,0,0,1,0];
         this.myDeactiveBg.filters = [new ColorMatrixFilter(colorMat)];
         this.myDeactiveBg.alpha = 0.7;
      }
      
      public function set activeBgColor(color:uint) : void
      {
         this.mActiveBgColor = color;
         var redChannel:Number = (this.mActiveBgColor >> 16 & 0xFF) / 255;
         var greenChannel:Number = (this.mActiveBgColor >> 8 & 0xFF) / 255;
         var blueChannel:Number = (this.mActiveBgColor & 0xFF) / 255;
         var colorMat:Array = [redChannel,0,0,0,0,0,greenChannel,0,0,0,0,0,blueChannel,0,0,0,0,0,1,0];
         this.myActiveBg.filters = [new ColorMatrixFilter(colorMat)];
         this.myActiveBg.alpha = 0.7;
      }
      
      public function set deactiveTextColor(color:uint) : void
      {
         this.mDeactiveTextColor = color;
      }
      
      public function set activeTextColor(color:uint) : void
      {
         this.mActiveTextColor = color;
      }
      
      public function set channel(channel:int) : void
      {
         this.mChannel = channel;
      }
      
      public function set index(ix:int) : void
      {
         this.mIndex = ix;
         this.myIndex.text = ix.toString();
      }
      
      public function set text(txt:String) : void
      {
         this.mTitle = txt;
      }
      
      public function set message(msg:String) : void
      {
         this.mMessage = msg;
      }
      
      public function set isRoomMessage(isRoomMessage:Boolean) : void
      {
         this.mIsRoomMessage = isRoomMessage;
      }
      
      override protected function onMouseOver() : void
      {
         super.onMouseOver();
         EventManager.getInstance().broadcast(BCInGameEvent.EVT_SET_ACTIVE_QUICK_CHAT_PART,this.mIndex);
      }
      
      override protected function onMouseOut() : void
      {
         super.onMouseOut();
         EventManager.getInstance().broadcast(BCInGameEvent.EVT_SET_ACTIVE_QUICK_CHAT_PART,0);
      }
      
      protected function onClicked(evt:MouseEvent) : void
      {
         this.SendCommandToDS();
         this.isActive = false;
         CFunctionInGameContainer.AS_HideQuickChatView();
      }
      
      public function SendCommandToDS() : void
      {
         if(this.mChannel == 0)
         {
            return;
         }
         if(this.mIndex == 0)
         {
            return;
         }
         if(!DataManager.getInstance().getDP(DataID.IS_QUICK_CHAT_CD_AVAILABLE))
         {
            return;
         }
         CFunctionCommonContainer.ScriptMenuResponse("quick_chat",this.mChannel.toString() + "_" + this.mIndex.toString());
         EventManager.getInstance().broadcast(BCInGameEvent.EVT_QUICK_CHAT_UPDATE_CD);
         if(this.mIsRoomMessage)
         {
            CFunctionInGameContainer.AS_Say(LocalizeUtil.localize(this.mMessage));
         }
         else
         {
            CFunctionInGameContainer.AS_Say2Team(LocalizeUtil.localize(this.mMessage),1);
         }
      }
   }
}

