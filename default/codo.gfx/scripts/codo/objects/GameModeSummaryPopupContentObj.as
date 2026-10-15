package codo.objects
{
   public class GameModeSummaryPopupContentObj
   {
      
      public var title:String;
      
      public var description:String;
      
      public var imagePath:Class;
      
      public var broadcastID:String;
      
      public var broadcastData:Object;
      
      public var notificationID:int;
      
      public var trainingMapName:String;
      
      public var trainingSuggestion:String;
      
      public function GameModeSummaryPopupContentObj(title:String, description:String, imagePath:Class, notificationID:int, broadcastID:String, trainingMapName:String = null, trainingSuggestion:String = null, broadcastData:Object = null)
      {
         super();
         this.title = title;
         this.description = description;
         this.imagePath = imagePath;
         this.notificationID = notificationID;
         this.broadcastID = broadcastID;
         this.broadcastData = broadcastData;
         this.trainingMapName = trainingMapName;
         this.trainingSuggestion = trainingSuggestion;
      }
   }
}

