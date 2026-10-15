package codo.views.chat_parts
{
   import codo.component.ScrollGrid;
   import codo.component.TextField;
   import codo.component.core.UIInteractiveComponent;
   import codo.localization.DictChatting;
   import codo.objects.ScrollListSettings;
   import codo.style.ChatGuide;
   import flash.display.MovieClip;
   
   public class ChatHistoryList extends UIInteractiveComponent
   {
      
      public static const MAX_CHAT_CAN_HOLD:int = 3;
      
      public var myNote:MovieClip;
      
      public var myScrollGrid:ScrollGrid;
      
      private var mSetting:ScrollListSettings;
      
      public function ChatHistoryList()
      {
         super();
         isInteractiveEnabled = true;
         this.mSetting = new ScrollListSettings();
         this.mSetting.orientation = ScrollListSettings.SCROLL_VERTICAL;
         this.mSetting.useNavArrows = false;
         this.mSetting.itemPadding = 0;
         this.mSetting.itemLinkage = "codo.chat.chatlistitem";
         this.myScrollGrid.initGrid(this.mSetting,3,false,1);
         var empty:Vector.<Object> = new Vector.<Object>();
         this.myScrollGrid.addItemsByVector(empty);
         var noteTF:TextField = this.myNote.myTextField as TextField;
         noteTF.width = ChatGuide.GLOBAL_CHANNEL_NOTE_WIDTH;
         noteTF.textStyle = ChatGuide.styleGlobalChannelNote;
         this.switchJoiningGlobalChatNote(false);
      }
      
      public function switchJoiningGlobalChatNote(visible:Boolean) : void
      {
         this.myNote.visible = visible;
      }
      
      public function setHistroy(histroy:Vector.<Object>) : void
      {
         this.myScrollGrid.addItemsByVector(histroy);
      }
      
      public function switchGlobalChatLocked(locked:Boolean) : void
      {
         var noteTF:TextField = this.myNote.myTextField as TextField;
         noteTF.text = locked ? DictChatting.GMSG_NOT_IN_SERVICE : DictChatting.JOINING_GLOBAL_CHAT;
      }
   }
}

