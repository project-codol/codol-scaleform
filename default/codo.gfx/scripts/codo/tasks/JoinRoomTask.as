package codo.tasks
{
   import codo.base.AsyncTaskBase;
   import codo.common.CFunctionContainer;
   import codo.constants.AsyncTaskGroup;
   import codo.constants.DataID;
   
   public class JoinRoomTask extends AsyncTaskBase
   {
      
      public function JoinRoomTask()
      {
         super(DataID.JOIN_ROOM,AsyncTaskGroup.IN_CHANNEL);
      }
      
      override public function onStart() : void
      {
         var obj:Object = null;
         super.onStart();
         if(this.params.room != null || this.params.invite.targetID.length > 0)
         {
            obj = Boolean(this.params.ticket) ? {
               "ticket":this.params.invite.targetID,
               "inviter":this.params.invite.senderID
            } : this.params.room;
            CFunctionContainer.JoinRoom(obj,this.params.ticket,this.params.teamSpecified);
            this.params = null;
         }
      }
   }
}

