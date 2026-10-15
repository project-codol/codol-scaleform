package components.gvoice
{
   import flash.display.MovieClip;
   import flash.utils.getDefinitionByName;
   
   public class GVoiceSettingsRoomMemberList extends MovieClip
   {
      
      private static const GVOICE_SETTINGS_ROOM_MEMBER_PATH:String = "codo.gvoice.gVoiceSettingsRoomMember";
      
      private var mMembers:Vector.<GVoiceSettingsRoomMember>;
      
      public function GVoiceSettingsRoomMemberList()
      {
         super();
         this.mMembers = new Vector.<GVoiceSettingsRoomMember>(0);
      }
      
      public function setData(members:Array) : void
      {
         var member:GVoiceSettingsRoomMember = null;
         var i:int = 0;
         var roomMemberClass:Class = null;
         for each(member in this.mMembers)
         {
            removeChild(member);
         }
         this.mMembers = new Vector.<GVoiceSettingsRoomMember>(0);
         for(i = 0; i < members.length; i++)
         {
            roomMemberClass = getDefinitionByName(GVOICE_SETTINGS_ROOM_MEMBER_PATH) as Class;
            if(Boolean(roomMemberClass))
            {
               member = addChild(new roomMemberClass()) as GVoiceSettingsRoomMember;
               if(Boolean(member))
               {
                  this.mMembers.push(member);
                  member.y = i * member.height;
                  member.setData(members[i]);
               }
            }
         }
      }
   }
}

