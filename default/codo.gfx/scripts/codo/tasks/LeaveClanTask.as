package codo.tasks
{
   import codo.base.AsyncTaskBase;
   import codo.common.CFunctionContainer;
   import codo.constants.AsyncTaskGroup;
   import codo.constants.DataID;
   
   public class LeaveClanTask extends AsyncTaskBase
   {
      
      public function LeaveClanTask()
      {
         super(DataID.LEAVE_CLAN,AsyncTaskGroup.CLAN);
      }
      
      override public function onStart() : void
      {
         super.onStart();
         CFunctionContainer.LeaveClan(this.params.newOwner);
      }
   }
}

