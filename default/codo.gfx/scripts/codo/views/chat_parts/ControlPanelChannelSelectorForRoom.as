package codo.views.chat_parts
{
   import codo.style.ChatGuide;
   import codo.style.GlobalGuide;
   import flash.display.MovieClip;
   
   public class ControlPanelChannelSelectorForRoom extends ControlPanelChannelSelector
   {
      
      private static const OUT_FRAME:int = 1;
      
      private static const OVER_FRAME:int = 5;
      
      private static const SELECTED_FRAME:int = 10;
      
      public var myAccent:MovieClip;
      
      public function ControlPanelChannelSelectorForRoom()
      {
         super();
         myLabel.visible = true;
         myLabel.y = 0;
         myLabel.textStyle = ChatGuide.roomChatTabButton;
         labelFocusColor = GlobalGuide.WHITE;
         labelUnfocusColor = GlobalGuide.CODO_BLUE_LIGHT;
      }
      
      override public function setToggled(toggled:Boolean) : void
      {
         super.setToggled(toggled);
         if(toggled)
         {
            myBackground.gotoAndPlay(SELECTED_FRAME);
            this.myAccent.visible = true;
         }
         else
         {
            this.myAccent.visible = false;
            if(_isFocused)
            {
               myBackground.gotoAndPlay(OVER_FRAME);
            }
            else
            {
               myBackground.gotoAndPlay(OUT_FRAME);
            }
         }
      }
   }
}

