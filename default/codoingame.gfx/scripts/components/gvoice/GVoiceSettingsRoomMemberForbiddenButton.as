package components.gvoice
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import shaui.component.core.InteractiveComponent;
   
   public class GVoiceSettingsRoomMemberForbiddenButton extends InteractiveComponent
   {
      
      public var myForbiddenSign:MovieClip;
      
      private var mForbidden:Boolean = false;
      
      private var mIsMouseOver:Boolean = false;
      
      private var mMember:GVoiceSettingsRoomMember;
      
      public function GVoiceSettingsRoomMemberForbiddenButton()
      {
         super();
         gotoAndStop(1);
         enable = true;
      }
      
      public function set member(member:GVoiceSettingsRoomMember) : void
      {
         this.mMember = member;
      }
      
      public function set forbidden(forbidden:Boolean) : void
      {
         this.mForbidden = forbidden;
         this.myForbiddenSign.visible = this.mForbidden;
         this.refreshButton();
      }
      
      override protected function onMouseOverHandler(e:MouseEvent) : void
      {
         this.mIsMouseOver = true;
         this.refreshButton();
      }
      
      override protected function onMouseOutHandler(e:MouseEvent) : void
      {
         this.mIsMouseOver = false;
         this.refreshButton();
      }
      
      override protected function onClickHandler(e:MouseEvent) : void
      {
         if(Boolean(this.mMember))
         {
            this.mForbidden = !this.mForbidden;
            this.mMember.forbidMember(this.mForbidden);
         }
      }
      
      protected function refreshButton() : void
      {
         if(this.mIsMouseOver)
         {
            gotoAndStop(3);
         }
         else if(this.mForbidden)
         {
            gotoAndStop(2);
         }
         else
         {
            gotoAndStop(1);
         }
      }
   }
}

