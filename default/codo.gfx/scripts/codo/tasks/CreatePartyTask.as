package codo.tasks
{
   import codo.base.AsyncTaskBase;
   import codo.common.CFunctionContainer;
   import codo.constants.AsyncTaskGroup;
   import codo.constants.DataID;
   
   public class CreatePartyTask extends AsyncTaskBase
   {
      
      public function CreatePartyTask()
      {
         super(DataID.CREATE_PARTY,AsyncTaskGroup.PARTY);
      }
      
      override public function onStart() : void
      {
         super.onStart();
         CFunctionContainer.CreateParty(params);
      }
   }
}

