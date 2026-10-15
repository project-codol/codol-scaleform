package codo.views.hudSpy
{
   import codo.objects.SpyGameMessageObj;
   import flash.display.MovieClip;
   
   public class GameHistory extends MovieClip
   {
      
      public var myEntry1:GameHistoryEntry;
      
      public var myEntry2:GameHistoryEntry;
      
      public var myEntry3:GameHistoryEntry;
      
      public var myEntry4:GameHistoryEntry;
      
      public var myEntry5:GameHistoryEntry;
      
      private var myEntries:Array;
      
      private var mAnchor:Array = [0,41,82,123,164];
      
      public function GameHistory()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this.myEntries = [this.myEntry1,this.myEntry2,this.myEntry3,this.myEntry4,this.myEntry5];
         this.hideAllEntries();
      }
      
      public function pushMessage(message:SpyGameMessageObj) : void
      {
         var entry:GameHistoryEntry = null;
         entry = this.myEntries.pop();
         entry.setMessageData(message);
         entry.visible = true;
         this.myEntries.unshift(entry);
         for(var i:int = 0; i < this.myEntries.length; i++)
         {
            this.myEntries[i].y = this.mAnchor[i];
         }
      }
      
      private function hideAllEntries() : void
      {
         var entry:GameHistoryEntry = null;
         for each(entry in this.myEntries)
         {
            entry.visible = false;
         }
      }
      
      public function clearAllMessage() : void
      {
         this.hideAllEntries();
      }
   }
}

