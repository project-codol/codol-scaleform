package components.gvoice
{
   import codo.common.CFunctionCommonContainer;
   import codo.style.GlobalGuide;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class GVoiceSettingsRoomMember extends MovieClip
   {
      
      public var myName:TextField;
      
      public var myForbiddenButton:GVoiceSettingsRoomMemberForbiddenButton;
      
      private var mMemberInfo:Object;
      
      public function GVoiceSettingsRoomMember()
      {
         super();
         this.myForbiddenButton.member = this;
      }
      
      public function forbidMember(forbidden:Boolean) : void
      {
         CFunctionCommonContainer.AS_GVoice_ForbidMemberVoice(this.mMemberInfo.memberID,forbidden);
         this.mMemberInfo.forbidden = forbidden;
         this.setData(this.mMemberInfo);
      }
      
      public function setData(memberInfo:Object) : void
      {
         this.mMemberInfo = memberInfo;
         this.myName.text = memberInfo.name;
         this.myForbiddenButton.forbidden = memberInfo.forbidden;
         this.myForbiddenButton.visible = !memberInfo.isSelf;
         if(Boolean(memberInfo.isSelf))
         {
            this.myForbiddenButton.visible = false;
            this.myName.textColor = GlobalGuide.CODO_YELLOW;
         }
         else
         {
            this.myForbiddenButton.visible = true;
            this.myName.textColor = GlobalGuide.WHITE;
         }
         if(Boolean(memberInfo.forbidden))
         {
            this.myName.textColor = GlobalGuide.GRAY_80;
         }
         else
         {
            this.myName.textColor = GlobalGuide.WHITE;
         }
      }
   }
}

