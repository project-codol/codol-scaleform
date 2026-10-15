package codo.views.hudSpy
{
   import codo.component.TextField;
   import codo.localization.DictHud;
   import codo.style.SpyHudGuide;
   import flash.display.MovieClip;
   
   public class SpyScoreboardHeader extends MovieClip
   {
      
      public var myNameTF:TextField;
      
      public var myClanTF:TextField;
      
      public var myPrestigeTF:TextField;
      
      public var myScoreTF:TextField;
      
      public var myDeathTF:TextField;
      
      public var myKarmaTF:TextField;
      
      public var myStateTF:TextField;
      
      public var myPingTF:TextField;
      
      public function SpyScoreboardHeader()
      {
         super();
         this.myNameTF.textStyle = SpyHudGuide.SpyScoreboardHeader;
         this.myClanTF.textStyle = SpyHudGuide.SpyScoreboardHeader;
         this.myPrestigeTF.textStyle = SpyHudGuide.SpyScoreboardHeader;
         this.myScoreTF.textStyle = SpyHudGuide.SpyScoreboardHeader;
         this.myDeathTF.textStyle = SpyHudGuide.SpyScoreboardHeader;
         this.myKarmaTF.textStyle = SpyHudGuide.SpyScoreboardHeader;
         this.myStateTF.textStyle = SpyHudGuide.SpyScoreboardHeader;
         this.myPingTF.textStyle = SpyHudGuide.SpyScoreboardHeader;
         this.myNameTF.text = DictHud.SPY_SCOREBOARD_HEADER_NAME;
         this.myClanTF.text = DictHud.SPY_SCOREBOARD_HEADER_CLAN;
         this.myPrestigeTF.text = DictHud.SPY_SCOREBOARD_HEADER_PRESTIGE;
         this.myScoreTF.text = DictHud.SPY_SCOREBOARD_HEADER_SCORE;
         this.myDeathTF.text = DictHud.SPY_SCOREBOARD_HEADER_DEATH;
         this.myKarmaTF.text = DictHud.SPY_SCOREBOARD_HEADER_KARMA;
         this.myStateTF.text = DictHud.SPY_SCOREBOARD_HEADER_STATUS;
         this.myPingTF.text = DictHud.SPY_SCOREBOARD_HEADER_PING;
      }
   }
}

