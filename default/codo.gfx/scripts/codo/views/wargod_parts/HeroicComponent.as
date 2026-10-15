package codo.views.wargod_parts
{
   import codo.component.TextField;
   import codo.localization.DictWarGod;
   import codo.objects.WarGodGlobalSettingObj;
   import codo.objects.WarGodMatchObj;
   import codo.objects.WarGodPlayerObj;
   import codo.objects.WarGodSeasonObj;
   import codo.style.WarGodGuide;
   import flash.display.MovieClip;
   
   public class HeroicComponent extends MovieClip implements IWarGodUIElement
   {
      
      private static const RANK_SCORE:Array = [5,4,4,3,3,2,2,1];
      
      public var myLabel:TextField;
      
      public var myFactor0Label:TextField;
      
      public var myFactor1Label:TextField;
      
      public var myFactor2Label:TextField;
      
      public var myFactor0Value:TextField;
      
      public var myFactor1Value:TextField;
      
      public var myFactor2Value:TextField;
      
      public var myTotal:TextField;
      
      private var STRIKE_SCORE:Array = [0,5,10,15,20];
      
      public function HeroicComponent()
      {
         super();
         this.myLabel.textStyle = WarGodGuide.styleHeroicComLabel;
         this.myLabel.width = 398;
         this.myLabel.height = 25;
         this.myLabel.x = 17;
         this.myLabel.y = 10;
         this.myFactor0Label.textStyle = WarGodGuide.styleHeroicComFactorLabel;
         this.myFactor1Label.textStyle = WarGodGuide.styleHeroicComFactorLabel;
         this.myFactor2Label.textStyle = WarGodGuide.styleHeroicComFactorLabel;
         this.myFactor0Value.textStyle = WarGodGuide.styleHeroicComFactorValue;
         this.myFactor1Value.textStyle = WarGodGuide.styleHeroicComFactorValue;
         this.myFactor2Value.textStyle = WarGodGuide.styleHeroicComFactorValue;
         this.myFactor0Label.width = this.myFactor1Label.width = this.myFactor2Label.width = 330;
         this.myFactor0Label.height = this.myFactor1Label.height = this.myFactor2Label.height = 22;
         this.myFactor0Label.x = this.myFactor1Label.x = this.myFactor2Label.x = 17;
         this.myFactor0Label.y = 54;
         this.myFactor1Label.y = 79;
         this.myFactor2Label.y = 105;
         this.myFactor0Value.width = this.myFactor1Value.width = this.myFactor2Value.width = 70;
         this.myFactor0Value.height = this.myFactor1Value.height = this.myFactor2Value.height = 20;
         this.myFactor0Value.x = this.myFactor1Value.x = this.myFactor2Value.x = 348;
         this.myFactor0Value.y = 54;
         this.myFactor1Value.y = 79;
         this.myFactor2Value.y = 105;
         this.myTotal.textStyle = WarGodGuide.styleHeroicComTotal;
         this.myTotal.width = 175;
         this.myTotal.height = 29;
         this.myTotal.x = 243;
         this.myTotal.y = 160;
         this.myLabel.text = DictWarGod.GAINED_HEROIC_LABEL;
         this.myFactor0Label.text = DictWarGod.GAINED_HEROIC_GAME_RANK;
         this.myFactor1Label.text = DictWarGod.GAINED_HEROIC_WIN_STREAK;
         this.myFactor2Label.text = DictWarGod.GAINED_HEROIC_OTHER_BEHAVIOR;
      }
      
      public function setData(seasonObj:WarGodSeasonObj, playerObj:WarGodPlayerObj, globalSetting:WarGodGlobalSettingObj) : void
      {
         var matchObj:WarGodMatchObj = null;
         var winStreak:int = 0;
         var i:int = 0;
         var matchLog:WarGodMatchObj = null;
         var totalValue:int = 0;
         var hvGainDueToRank:int = 0;
         var hvGainDueToWinStreak:int = 0;
         var hvGainOthers:int = 0;
         var numMatchLog:int = playerObj.numMatchHistroy;
         if(numMatchLog > 0)
         {
            matchObj = playerObj.matchHistroy[numMatchLog - 1];
            totalValue = matchObj.heroicValueGain;
            if(matchObj.place - 1 >= 0 && matchObj.place - 1 < RANK_SCORE.length)
            {
               hvGainDueToRank = int(RANK_SCORE[matchObj.place - 1]);
            }
            winStreak = 0;
            for(i = numMatchLog - 1; i >= 0; i--)
            {
               matchLog = playerObj.matchHistroy[i] as WarGodMatchObj;
               if(!Boolean(matchLog.isWinner))
               {
                  break;
               }
               winStreak++;
            }
            if(winStreak > this.STRIKE_SCORE.length)
            {
               hvGainDueToWinStreak = int(this.STRIKE_SCORE[this.STRIKE_SCORE.length - 1]);
            }
            else
            {
               hvGainDueToWinStreak = int(this.STRIKE_SCORE[winStreak - 1]);
            }
         }
         hvGainOthers = totalValue;
         if(hvGainOthers - hvGainDueToRank < 0)
         {
            hvGainDueToRank = 0;
         }
         hvGainOthers -= hvGainDueToRank;
         if(hvGainOthers - hvGainDueToWinStreak < 0)
         {
            hvGainDueToWinStreak = 0;
         }
         hvGainOthers -= hvGainDueToWinStreak;
         this.myTotal.text = String(totalValue);
         this.myFactor0Value.text = String(hvGainDueToRank);
         this.myFactor1Value.text = String(hvGainDueToWinStreak);
         this.myFactor2Value.text = String(hvGainOthers);
      }
   }
}

