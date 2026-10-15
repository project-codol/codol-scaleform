package components.fsgSocialPanel_part
{
   import codo.component.Button;
   import flash.display.MovieClip;
   
   public class FsgMailFooterBar extends MovieClip
   {
      
      private static const BUTTON_WIDTH:int = 105;
      
      private static const BUTTON_HEIGHT:int = 36;
      
      public var myDeclineBtn:Button;
      
      public var myAcceptBtn:Button;
      
      public var m_onDeleteCallback:Function;
      
      public var m_onAcceptCallback:Function;
      
      public function FsgMailFooterBar()
      {
         super();
         this.myDeclineBtn.width = BUTTON_WIDTH;
         this.myDeclineBtn.height = BUTTON_HEIGHT;
         this.myAcceptBtn.width = BUTTON_WIDTH;
         this.myAcceptBtn.height = BUTTON_HEIGHT;
         this.myDeclineBtn.x = this.myAcceptBtn.x - this.myDeclineBtn.width;
         this.myDeclineBtn.y = this.myAcceptBtn.y;
         this.myDeclineBtn.registerClickEvent(this.onDeclineCallback);
         this.myAcceptBtn.registerClickEvent(this.onAcceptCallback);
      }
      
      public function set declineText(str:String) : void
      {
         this.myDeclineBtn.label = str;
      }
      
      public function setDeclineCallback(func:Function) : void
      {
         this.m_onDeleteCallback = func;
      }
      
      public function onDeclineCallback() : void
      {
         this.m_onDeleteCallback();
      }
      
      public function set acceptText(str:String) : void
      {
         this.myAcceptBtn.label = str;
      }
      
      public function setAcceptCallback(func:Function) : void
      {
         this.m_onAcceptCallback = func;
      }
      
      public function onAcceptCallback() : void
      {
         this.m_onAcceptCallback();
      }
   }
}

