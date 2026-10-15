package codo.views.chat_parts
{
   import codo.component.Button;
   import codo.style.ChatGuide;
   import codo.style.GlobalGuide;
   import flash.display.MovieClip;
   
   public class ControlPanelChannelSelector extends Button
   {
      
      public static const FRAME_GLOBAL:int = 1;
      
      public static const FRAME_CLAN:int = 2;
      
      public static const FRAME_PARTY:int = 3;
      
      public static const FRAME_PRIVATE:int = 4;
      
      public var myUnreadDot:MovieClip;
      
      public var myIcon:MovieClip;
      
      public function ControlPanelChannelSelector()
      {
         super();
         this.myUnreadDot.visible = false;
         myLabel.visible = false;
      }
      
      override public function set enabled(enabled:Boolean) : void
      {
         super.enabled = enabled;
         alpha = enabled ? 1 : 0.5;
      }
      
      override public function set width(w:Number) : void
      {
         super.width = w;
         this.myUnreadDot.x = w - 4;
      }
      
      override public function get width() : Number
      {
         return myBackground.width;
      }
      
      public function set unreadNum(num:int) : void
      {
         this.myUnreadDot.visible = num > 0;
         if(num >= 99)
         {
            this.myUnreadDot.myUnreadTF.text = "99+";
         }
         else
         {
            this.myUnreadDot.myUnreadTF.text = String(num);
         }
         this.myUnreadDot.myNumberBG.width = this.myUnreadDot.myNumberBG.height = Math.max(this.myUnreadDot.myUnreadTF.textWidth,this.myUnreadDot.myUnreadTF.textHeight) + 4;
      }
      
      override protected function showHighlight() : void
      {
         super.showHighlight();
         if(Boolean(this.myIcon))
         {
            ChatGuide.tint(true,this.myIcon,GlobalGuide.WHITE);
         }
      }
      
      override protected function endHighlight() : void
      {
         super.endHighlight();
         if(Boolean(this.myIcon))
         {
            ChatGuide.tint(false,this.myIcon);
         }
      }
      
      public function set icon(frame:int) : void
      {
         this.myIcon.gotoAndStop(frame);
      }
      
      override public function setToggled(toggled:Boolean) : void
      {
         super.setToggled(toggled);
         if(Boolean(this.myIcon))
         {
            ChatGuide.tint(toggled,this.myIcon,GlobalGuide.WHITE);
         }
      }
   }
}

