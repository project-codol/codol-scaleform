package codo.views.hudDMZScoreboard
{
   import codo.localization.DictDmz;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class HudDMZScoreboardHeader extends MovieClip
   {
      
      public var myPlayerNameTitle:TextField;
      
      public var myEliminationsTitle:TextField;
      
      public var myGearTitle:TextField;
      
      public var myRankTitle:TextField;
      
      public var myStateTitle:TextField;
      
      public var myPingTitle:TextField;
      
      public function HudDMZScoreboardHeader()
      {
         super();
         this.myPlayerNameTitle.text = LocalizeUtil.localize(DictDmz.SCOREBOARD_HEADER_PLAYER_NAME_TITLE);
         this.myEliminationsTitle.text = LocalizeUtil.localize(DictDmz.SCOREBOARD_HEADER_ELIMINATIONS_TITLE);
         this.myGearTitle.text = LocalizeUtil.localize(DictDmz.SCOREBOARD_HEADER_PLAYER_GEAR_TITLE);
         this.myRankTitle.text = LocalizeUtil.localize(DictDmz.SCOREBOARD_HEADER_PLAYER_RANK_TITLE);
         this.myStateTitle.text = LocalizeUtil.localize(DictDmz.SCOREBOARD_HEADER_PLAYER_STATE_TITLE);
         this.myPingTitle.text = LocalizeUtil.localize(DictDmz.SCOREBOARD_HEADER_PLAYER_PING_TITLE);
      }
   }
}

