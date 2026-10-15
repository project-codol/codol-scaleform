package codo.tasks
{
   import codo.base.AsyncTaskBase;
   import codo.common.CFunctionContainer;
   import codo.constants.AsyncTaskGroup;
   import codo.constants.DataID;
   
   public class CreateClanTask extends AsyncTaskBase
   {
      
      public function CreateClanTask()
      {
         super(DataID.CREATE_CLAN,AsyncTaskGroup.CLAN);
      }
      
      override public function onStart() : void
      {
         super.onStart();
         CFunctionContainer.CreateClan(this.params);
      }
   }
}

