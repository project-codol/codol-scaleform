package codo.tasks
{
   import codo.base.AsyncTaskBase;
   import codo.common.CFunctionContainer;
   import codo.constants.AsyncTaskGroup;
   import codo.constants.DataID;
   
   public class ListContactTask extends AsyncTaskBase
   {
      
      public function ListContactTask()
      {
         super(DataID.LIST_FRIEND,AsyncTaskGroup.CONTACT);
      }
      
      override public function onStart() : void
      {
         super.onStart();
         CFunctionContainer.ListContact(this.params.type);
      }
   }
}

