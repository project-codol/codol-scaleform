package codo.tasks
{
   import codo.base.AsyncTaskBase;
   import codo.common.CFunctionContainer;
   import codo.constants.AsyncTaskGroup;
   import codo.constants.DataID;
   
   public class JumpGameTask extends AsyncTaskBase
   {
      
      public function JumpGameTask()
      {
         super(DataID.JUMP_GAME,AsyncTaskGroup.IN_CHANNEL);
      }
      
      override public function onStart() : void
      {
         super.onStart();
         CFunctionContainer.JumpGame(this.params);
      }
   }
}

