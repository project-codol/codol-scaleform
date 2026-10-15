package codo.objects
{
   public class RankedMatchLobbyUpdateObj
   {
      
      private var mElapsedTime:int = 0;
      
      private var mIntermissionElapsedTime:int = 0;
      
      private var mIntermissionTotalTime:int = 0;
      
      private var mIsFinalUpdate:Boolean = false;
      
      public function RankedMatchLobbyUpdateObj(elapsedTime:int, intermissionElapsedTime:int, intermissionTotalTime:int, isFinalUpdate:Boolean)
      {
         super();
         this.mElapsedTime = elapsedTime;
         this.mIntermissionElapsedTime = intermissionElapsedTime;
         this.mIntermissionTotalTime = intermissionTotalTime;
         this.mIsFinalUpdate = isFinalUpdate;
      }
      
      public function get elapsedTime() : int
      {
         return this.mElapsedTime;
      }
      
      public function get intermissionElapsedTime() : int
      {
         return this.mIntermissionElapsedTime;
      }
      
      public function get intermissionTotalTime() : int
      {
         return this.mIntermissionTotalTime;
      }
      
      public function get isFinalUpdate() : Boolean
      {
         return this.mIsFinalUpdate;
      }
   }
}

