package codo.views.spyMatchResult_parts
{
   import codo.component.TextField;
   import codo.localization.DictHud;
   import codo.style.SpyHudGuide;
   import flash.display.MovieClip;
   
   public class SpyMatchResultScoreboardHeader extends MovieClip
   {
      
      public var myNameTF:TextField;
      
      public var myClanTF:TextField;
      
      public var myPrestigeTF:TextField;
      
      public var myScoreTF:TextField;
      
      public var myDeathTF:TextField;
      
      public var myKarmaTF:TextField;
      
      public var myStatusTF:TextField;
      
      public function SpyMatchResultScoreboardHeader()
      {
         super();
         this.myNameTF.textStyle = SpyHudGuide.SpyScoreboardHeader;
         this.myClanTF.textStyle = SpyHudGuide.SpyScoreboardHeader;
         this.myPrestigeTF.textStyle = SpyHudGuide.SpyScoreboardHeader;
         this.myScoreTF.textStyle = SpyHudGuide.SpyScoreboardHeader;
         this.myDeathTF.textStyle = SpyHudGuide.SpyScoreboardHeader;
         this.myKarmaTF.textStyle = SpyHudGuide.SpyScoreboardHeader;
         this.myStatusTF.textStyle = SpyHudGuide.SpyScoreboardHeader;
         this.myNameTF.text = DictHud.SPY_SCOREBOARD_HEADER_NAME;
         this.myClanTF.text = DictHud.SPY_SCOREBOARD_HEADER_CLAN;
         this.myPrestigeTF.text = DictHud.SPY_SCOREBOARD_HEADER_PRESTIGE;
         this.myScoreTF.text = DictHud.SPY_SCOREBOARD_HEADER_SCORE;
         this.myDeathTF.text = DictHud.SPY_SCOREBOARD_HEADER_DEATH;
         this.myKarmaTF.text = DictHud.SPY_SCOREBOARD_HEADER_KARMA;
         this.myStatusTF.text = DictHud.SPY_SCOREBOARD_HEADER_STATUS;
      }
   }
}

