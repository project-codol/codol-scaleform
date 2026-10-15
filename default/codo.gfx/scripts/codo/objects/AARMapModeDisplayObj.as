package codo.objects
{
   public class AARMapModeDisplayObj
   {
      
      public var mapName:String;
      
      public var modeName:String;
      
      public var playerScore:int;
      
      public var mapImageURL:String;
      
      public var timePlayed:int;
      
      public var roundsPlayed:int;
      
      public var isVictory:Boolean;
      
      public function AARMapModeDisplayObj(mapName:String, modeName:String, playerScore:int, timePlayed:int, mapImageURL:String = "", roundsPlayed:int = 0, isVictory:Boolean = true)
      {
         super();
         this.mapName = mapName;
         this.modeName = modeName;
         this.playerScore = playerScore;
         this.timePlayed = timePlayed;
         this.mapImageURL = mapImageURL;
         this.roundsPlayed = roundsPlayed;
         this.isVictory = isVictory;
      }
   }
}

