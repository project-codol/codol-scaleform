package codo.tasks
{
   import codo.base.AsyncTaskBase;
   import codo.common.CFunctionContainer;
   import codo.constants.AsyncTaskGroup;
   import codo.constants.DataID;
   
   public class SendMailTask extends AsyncTaskBase
   {
      
      public function SendMailTask()
      {
         super(DataID.SEND_MAIL,AsyncTaskGroup.MAIL);
      }
      
      override public function onStart() : void
      {
         super.onStart();
         CFunctionContainer.SendMail(this.params.mail);
      }
   }
}

