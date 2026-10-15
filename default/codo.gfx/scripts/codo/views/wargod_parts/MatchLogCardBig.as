package codo.views.wargod_parts
{
   import codo.component.TextField;
   import codo.objects.WarGodGlobalSettingObj;
   import codo.objects.WarGodMatchObj;
   import codo.objects.WarGodPlayerObj;
   import codo.objects.WarGodSeasonObj;
   import codo.style.WarGodGuide;
   import codo.utils.WarGodUtility;
   
   public class MatchLogCardBig extends MatchLogCard implements IWarGodUIElement
   {
      
      public var myMatchKD:TextField;
      
      public function MatchLogCardBig()
      {
         super();
         myMatchType.width = 188;
         myMatchType.height = 25;
         myMatchType.x = 1;
         myMatchType.y = 15;
         myMatchTime.width = 188;
         myMatchTime.height = 20;
         myMatchTime.x = 1;
         myMatchTime.y = 37;
         myMatchScore.width = 188;
         myMatchScore.height = 58;
         myMatchScore.x = 1;
         myMatchScore.y = 60;
         this.myMatchKD.textStyle = WarGodGuide.styleMatchScore;
         this.myMatchKD.width = 188;
         this.myMatchKD.height = 58;
         this.myMatchKD.x = 1;
         this.myMatchKD.y = 117;
         myMatchResult.width = 188;
         myMatchResult.height = 20;
         myMatchResult.x = 1;
         myMatchResult.y = 179;
         myMatchIndex.visible = false;
      }
      
      public function setData(seasonObj:WarGodSeasonObj, playerObj:WarGodPlayerObj, globalSetting:WarGodGlobalSettingObj) : void
      {
         var matchHistroy:Array = playerObj.matchHistroy;
         var lastMatch:WarGodMatchObj = null;
         if(playerObj.numMatchHistroy > 0)
         {
            lastMatch = matchHistroy[playerObj.numMatchHistroy - 1];
         }
         this.setMatch(lastMatch);
      }
      
      override public function setMatch(match:WarGodMatchObj) : Boolean
      {
         var matchValid:Boolean = false;
         matchValid = super.setMatch(match);
         this.myMatchKD.visible = matchValid;
         if(matchValid)
         {
            this.myMatchKD.text = WarGodUtility.getMatchKDByFactors(match.kills,match.deaths);
         }
         return matchValid;
      }
   }
}

