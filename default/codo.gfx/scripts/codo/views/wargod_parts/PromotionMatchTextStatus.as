package codo.views.wargod_parts
{
   import codo.component.TextField;
   import codo.localization.DictWarGod;
   import codo.objects.WarGodGlobalSettingObj;
   import codo.objects.WarGodMatchObj;
   import codo.objects.WarGodPlayerObj;
   import codo.objects.WarGodSeasonObj;
   import codo.style.WarGodGuide;
   import codo.utils.WarGodUtility;
   import flash.display.MovieClip;
   
   public class PromotionMatchTextStatus extends MovieClip implements IWarGodUIElement
   {
      
      public var myLabel:TextField;
      
      public var myWinCount:TextField;
      
      public function PromotionMatchTextStatus()
      {
         super();
         this.myLabel.textStyle = WarGodGuide.stylePromotionStatusLabel;
         this.myLabel.x = 0;
         this.myLabel.y = 37;
         this.myLabel.width = 646;
         this.myLabel.height = 25;
         this.myWinCount.textStyle = WarGodGuide.stylePromotionWinCount;
         this.myWinCount.x = 0;
         this.myWinCount.y = 79;
         this.myWinCount.width = 646;
         this.myWinCount.height = 81;
         this.myLabel.text = DictWarGod.PROMOTION_MATCH_WIN_LABEL;
      }
      
      public function setData(seasonData:WarGodSeasonObj, playerObj:WarGodPlayerObj, globalSetting:WarGodGlobalSettingObj) : void
      {
         var match:WarGodMatchObj = null;
         var matchResult:int = 0;
         var numPromotionMatchComplete:int = playerObj.numPromotionMatchCompleted;
         var numWin:int = 0;
         var checkedCount:int = 0;
         for(var i:int = playerObj.numMatchHistroy - 1; i >= 0; i--)
         {
            if(checkedCount >= numPromotionMatchComplete)
            {
               break;
            }
            match = playerObj.matchHistroy[i];
            matchResult = WarGodUtility.getMatchResultByFactors(match.isWinner,match.isDraw,match.isDisconnected);
            if(matchResult == WarGodMatchObj.RESULT_WIN)
            {
               numWin++;
            }
            checkedCount++;
         }
         this.myWinCount.text = String(numWin) + "/3";
      }
   }
}

