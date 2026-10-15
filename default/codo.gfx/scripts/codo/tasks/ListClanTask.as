package codo.tasks
{
   import codo.base.AsyncTaskBase;
   import codo.common.CFunctionContainer;
   import codo.constants.AsyncTaskGroup;
   import codo.constants.DataID;
   
   public class ListClanTask extends AsyncTaskBase
   {
      
      public function ListClanTask()
      {
         super(DataID.LIST_CLAN,AsyncTaskGroup.CLAN);
      }
      
      override public function onStart() : void
      {
         super.onStart();
         CFunctionContainer.ListClan();
      }
   }
}

