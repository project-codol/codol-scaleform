package codo.tasks
{
   import codo.base.AsyncTaskBase;
   import codo.common.CFunctionContainer;
   import codo.constants.AsyncTaskGroup;
   import codo.constants.DataID;
   
   public class ListBlackListTask extends AsyncTaskBase
   {
      
      public function ListBlackListTask()
      {
         super(DataID.LIST_BLACKLIST,AsyncTaskGroup.BLACK_LIST);
      }
      
      override public function onStart() : void
      {
         super.onStart();
         CFunctionContainer.ListBlackList();
      }
   }
}

