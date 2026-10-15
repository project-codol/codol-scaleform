package codo.views.chat_parts
{
   import codo.component.Button;
   import codo.component.TextField;
   import codo.component.core.UIInteractiveComponent;
   import codo.interfaces.ISelectable;
   import codo.objects.ChatChannelObj;
   import codo.style.ChatGuide;
   import codo.utils.CursorUtil;
   import flash.display.MovieClip;
   
   public class ChannelSelectorButton extends UIInteractiveComponent implements ISelectable
   {
      
      private static const WIDTH:int = 223;
      
      private static const HEIGHT:int = 30;
      
      public var myLabel:TextField;
      
      public var myBackground:MovieClip;
      
      public var myFocusBackground:MovieClip;
      
      public var myCloseBtn:Button;
      
      public var myUnread:MovieClip;
      
      protected var mSelected:Boolean = false;
      
      private var mCloseHandler:Function;
      
      private var mClosePara:Object;
      
      public function ChannelSelectorButton()
      {
         super();
         isInteractiveEnabled = true;
         this.myLabel.textStyle = ChatGuide.stylePrivateChannelSelector;
         this.myLabel.width = 190;
         this.myLabel.enableTruncate(true);
         this.myBackground.visible = false;
         this.myFocusBackground.visible = false;
         this.myCloseBtn.registerClickEvent(this.onCloseClick);
      }
      
      public function setCloseCallback(callback:Function, data:Object) : void
      {
         this.mCloseHandler = callback;
         this.mClosePara = data;
      }
      
      override public function setData(data:*) : void
      {
         var channel:ChatChannelObj = null;
         super.setData(data);
         if(data == null)
         {
            return;
         }
         channel = data.rawChannel as ChatChannelObj;
         this.myLabel.text = channel.targetName;
         if(channel.numUnread > 0)
         {
            this.myUnread.visible = true;
            this.myUnread.myUnreadTF.text = String(channel.numUnread);
            this.myLabel.x = 28;
         }
         else
         {
            this.myUnread.visible = false;
            this.myLabel.x = 4;
         }
      }
      
      override protected function onMouseOver() : void
      {
         super.onMouseOver();
         CursorUtil.BeginCursor(CursorUtil.CURSOR_OVER_BUTTON);
         if(!this.mSelected)
         {
            this.myFocusBackground.visible = true;
         }
      }
      
      override protected function onMouseOut() : void
      {
         super.onMouseOut();
         CursorUtil.EndCursor(CursorUtil.CURSOR_OVER_BUTTON);
         if(!this.mSelected)
         {
            this.myFocusBackground.visible = false;
         }
      }
      
      public function set selected(sel:Boolean) : void
      {
         this.mSelected = sel;
         if(this.mSelected)
         {
            this.myBackground.visible = true;
            this.myFocusBackground.visible = false;
         }
         else
         {
            this.myBackground.visible = false;
         }
      }
      
      public function get selected() : Boolean
      {
         return this.mSelected;
      }
      
      override public function get width() : Number
      {
         return WIDTH;
      }
      
      override public function get height() : Number
      {
         return HEIGHT;
      }
      
      private function onCloseClick() : void
      {
         if(null != this.mCloseHandler)
         {
            this.mCloseHandler(this.mClosePara);
         }
      }
   }
}

