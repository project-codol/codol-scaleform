package codo.tasks
{
   import codo.base.AsyncTaskBase;
   import codo.common.CFunctionContainer;
   import codo.constants.AsyncTaskGroup;
   import codo.constants.DataID;
   
   public class ChangeUserNameTask extends AsyncTaskBase
   {
      
      public function ChangeUserNameTask()
      {
         super(DataID.REDEEM_CHANGE_NAME,AsyncTaskGroup.REDEEM_CHANGE_NAME);
      }
      
      override public function onStart() : void
      {
         super.onStart();
         CFunctionContainer.AS_RedeemChangeName(this.params.newName);
      }
   }
}

