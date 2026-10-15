package codo.views.wargod_parts
{
   import codo.objects.WarGodGlobalSettingObj;
   import codo.objects.WarGodPlayerObj;
   import codo.objects.WarGodSeasonObj;
   import flash.display.MovieClip;
   
   public class WarGodPlacementMatchStatus extends MovieClip implements IWarGodUIElement
   {
      
      public var myMatch0:MatchLogCard;
      
      public var myMatch1:MatchLogCard;
      
      public var myMatch2:MatchLogCard;
      
      public var myMatch3:MatchLogCard;
      
      public var myMatch4:MatchLogCard;
      
      protected var matchCards:Array;
      
      public function WarGodPlacementMatchStatus()
      {
         super();
         this.matchCards = [this.myMatch0,this.myMatch1,this.myMatch2,this.myMatch3,this.myMatch4];
      }
      
      public function setData(seasonObj:WarGodSeasonObj, playerObj:WarGodPlayerObj, globalSetting:WarGodGlobalSettingObj) : void
      {
         var match:MatchLogCard = null;
         var matchHistroy:Array = playerObj.matchHistroy;
         var numMatchHistroy:int = playerObj.numMatchHistroy;
         var i:int = 0;
         i = 0;
         while(i < numMatchHistroy && i < this.matchCards.length)
         {
            match = this.matchCards[i] as MatchLogCard;
            match.setMatch(matchHistroy[i]);
            match.setIndex(i + 1);
            i++;
         }
         while(i < this.matchCards.length)
         {
            match = this.matchCards[i] as MatchLogCard;
            match.setMatch(null);
            match.setIndex(i + 1);
            i++;
         }
      }
   }
}

