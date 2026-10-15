package codo.views.wargod_parts
{
   import codo.objects.WarGodGlobalSettingObj;
   import codo.objects.WarGodPlayerObj;
   import codo.objects.WarGodSeasonObj;
   
   public class WarGodPromotionMatchStatus extends WarGodPlacementMatchStatus
   {
      
      public function WarGodPromotionMatchStatus()
      {
         super();
         matchCards = [myMatch0,myMatch1,myMatch2];
      }
      
      override public function setData(seasonObj:WarGodSeasonObj, playerObj:WarGodPlayerObj, globalSetting:WarGodGlobalSettingObj) : void
      {
         var match:MatchLogCard = null;
         var numPromotionMatchCompleted:int = playerObj.numPromotionMatchCompleted;
         var matchHistroy:Array = playerObj.matchHistroy;
         var numMatchHistroy:int = playerObj.numMatchHistroy;
         var promotionMatchHistroy:Array = new Array();
         var i:int = 0;
         for(i = 0; i < numPromotionMatchCompleted; i++)
         {
            if(numMatchHistroy - 1 - i < 0)
            {
               break;
            }
            promotionMatchHistroy.push(matchHistroy[numMatchHistroy - 1 - i]);
         }
         i = 0;
         while(i < promotionMatchHistroy.length && i < matchCards.length)
         {
            match = matchCards[i] as MatchLogCard;
            match.setMatch(promotionMatchHistroy[i]);
            match.setIndex(i + 1);
            i++;
         }
         while(i < matchCards.length)
         {
            match = matchCards[i] as MatchLogCard;
            match.setMatch(null);
            match.setIndex(i + 1);
            i++;
         }
      }
   }
}

