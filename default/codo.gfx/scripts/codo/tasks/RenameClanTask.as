package codo.tasks
{
   import codo.base.AsyncTaskBase;
   import codo.common.CFunctionContainer;
   import codo.constants.AsyncTaskGroup;
   import codo.constants.DataID;
   
   public class RenameClanTask extends AsyncTaskBase
   {
      
      public function RenameClanTask()
      {
         super(DataID.RENAME_CLAN,AsyncTaskGroup.CLAN);
      }
      
      override public function onStart() : void
      {
         super.onStart();
         CFunctionContainer.RenameClan(this.params);
      }
   }
}

