package codo.objects
{
   public class PartyInvitationObj
   {
      
      public var senderID:String;
      
      public var senderName:String;
      
      public var ticketID:String;
      
      public var timeStamp:uint;
      
      public var expireTime:uint;
      
      public var joinableZones:uint;
      
      public function PartyInvitationObj()
      {
         super();
      }
      
      public function equals(invitation:PartyInvitationObj) : Boolean
      {
         return this.senderID == invitation.senderID && this.ticketID == invitation.ticketID && this.timeStamp == invitation.timeStamp;
      }
   }
}

