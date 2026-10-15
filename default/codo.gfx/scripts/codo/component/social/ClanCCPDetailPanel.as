package codo.component.social
{
   import codo.localization.DictClan;
   import codo.objects.ClanGlobalConfig;
   import codo.style.GlobalGuide;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class ClanCCPDetailPanel extends MovieClip
   {
      
      public var myClanCCPLabel:TextField;
      
      public var myPlayerWithMateLabel:TextField;
      
      public var myCompleteWarGodLabel:TextField;
      
      public var myCompleteChallengeLabel:TextField;
      
      public var myPlayerWithMate:TextField;
      
      public var myCompleteWarGod:TextField;
      
      public var myCompleteChallenge:TextField;
      
      public function ClanCCPDetailPanel()
      {
         super();
      }
      
      public function setData(stats:Array, globalSetting:ClanGlobalConfig) : void
      {
         this.myClanCCPLabel.text = DictClan.PLAYER_CCP_STATE_LABEL;
         this.myPlayerWithMateLabel.text = DictClan.PLAYER_CCP_STATE_PLAY_WITH_MATE;
         this.myCompleteWarGodLabel.text = DictClan.PLAYER_CCP_STATE_PLAY_WARGOD;
         this.myCompleteChallengeLabel.text = DictClan.PLAYER_CCP_STATE_COMPLETE_CHALLENGE;
         LocalizeUtil.paramColorized(this.myPlayerWithMate,DictClan.PLAYER_CCP_STATE_VALUE,[stats[0],globalSetting.ccpPlayWithMemberCap],[GlobalGuide.CODO_COLOR_HIGHLIGHT_ORANGE,GlobalGuide.WHITE]);
         LocalizeUtil.paramColorized(this.myCompleteWarGod,DictClan.PLAYER_CCP_STATE_VALUE,[stats[1],globalSetting.ccpWargodCap],[GlobalGuide.CODO_COLOR_HIGHLIGHT_ORANGE,GlobalGuide.WHITE]);
         LocalizeUtil.paramColorized(this.myCompleteChallenge,DictClan.PLAYER_CCP_STATE_VALUE,[stats[2],globalSetting.ccpChallengeCap],[GlobalGuide.CODO_COLOR_HIGHLIGHT_ORANGE,GlobalGuide.WHITE]);
      }
   }
}

