package codo.tasks
{
   import codo.base.AsyncTaskBase;
   import codo.common.CFunctionContainer;
   import codo.constants.AsyncTaskGroup;
   import codo.constants.DataID;
   import codo.utils.ScaleformUtil;
   
   public class DeleteMailsTask extends AsyncTaskBase
   {
      
      public function DeleteMailsTask()
      {
         super(DataID.DELETE_MAILS,AsyncTaskGroup.MAIL);
      }
      
      override public function onStart() : void
      {
         var mails:Array = null;
         var i:int = 0;
         super.onStart();
         if(ScaleformUtil.isTempContentEnabled_3() == true)
         {
            mails = this.params.mails;
            for(i = 0; i < mails.length; i++)
            {
               CFunctionContainer.AS_MessageDelete(int(mails[i].messageid));
            }
         }
         else
         {
            CFunctionContainer.DeleteMails(this.params.mails);
         }
      }
   }
}

