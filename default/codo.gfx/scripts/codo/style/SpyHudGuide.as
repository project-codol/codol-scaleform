package codo.style
{
   import flash.text.TextFieldAutoSize;
   
   public class SpyHudGuide extends GlobalGuide
   {
      
      public static const ROLE_INVESTIGATOR_COLOR:uint = 633855;
      
      public static const ROLE_SPY_COLOR:uint = 16743724;
      
      public static const ROLE_CIVILIAN_COLOR:uint = GlobalGuide.WHITE;
      
      public static const HINT_COLOR_YELLOW:uint = 16771584;
      
      public static const HINT_COLOR_DARK_YELLOW:uint = 16743724;
      
      public static const SKILL_READY_COLOR:uint = GlobalGuide.WHITE;
      
      public static const SKILL_COOLDOWN_COLOR:uint = GlobalGuide.CODO_GRAY_LIGHT;
      
      public function SpyHudGuide()
      {
         super();
      }
      
      public static function get PauseMenuSpyViewRoleInfoPanelRoleCivilian() : TextStyle
      {
         var style:TextStyle = null;
         style = new TextStyle();
         style.font = FONT_FACE_BOLD;
         style.fontSize = 58;
         style.fontColor = WHITE;
         return style;
      }
      
      public static function get PauseMenuSpyViewRoleInfoPanelRoleInvestigater() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_BOLD;
         style.fontSize = 58;
         style.fontColor = 633855;
         return style;
      }
      
      public static function get PauseMenuSpyViewRoleInfoPanelRoleSpy() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_BOLD;
         style.fontSize = 58;
         style.fontColor = 16743724;
         return style;
      }
      
      public static function get PauseMenuSpyViewSkillTitleInvestigator() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_BOLD;
         style.fontSize = 38;
         style.fontColor = 633855;
         return style;
      }
      
      public static function get PauseMenuSpyViewTipsTitle() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_BOLD;
         style.fontSize = 38;
         style.fontColor = WHITE;
         return style;
      }
      
      public static function get PauseMenuSpyViewSkillTitleSpy() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_BOLD;
         style.fontSize = 38;
         style.fontColor = 16743724;
         return style;
      }
      
      public static function get PauseMenuSpyViewSkillTitleCivilian() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_BOLD;
         style.fontSize = 38;
         style.fontColor = WHITE;
         return style;
      }
      
      public static function get PauseMenuSpyViewRoleInfoPanelRoleDesc() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = 22;
         style.fontColor = WHITE;
         style.multiLine = true;
         style.wordWrap = true;
         return style;
      }
      
      public static function get PauseMenuSpyViewSkillItemDesc() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = 16;
         style.fontColor = WHITE;
         style.multiLine = true;
         style.wordWrap = true;
         style.alignmentVertical = TextStyle.VALIGN_MIDDLE;
         return style;
      }
      
      public static function get SpyScoreboardHeader() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = 18;
         style.fontColor = WHITE;
         return style;
      }
      
      public static function get SpyScoreboardCategoryHeader() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_BOLD;
         style.fontSize = 18;
         style.fontColor = WHITE;
         return style;
      }
      
      public static function get SpyScoreboardItemNameCivilian() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = 18;
         style.fontColor = WHITE;
         return style;
      }
      
      public static function get SpyScoreboardItemNameInvectigater() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = 18;
         style.fontColor = 633855;
         return style;
      }
      
      public static function get SpyScoreboardItemNameSpy() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = 18;
         style.fontColor = 16743724;
         return style;
      }
      
      public static function get SpyScoreboardItemCommon() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = 18;
         style.fontColor = WHITE;
         return style;
      }
      
      public static function get SpyScoreboardItemKarmaBlue() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = 18;
         style.fontColor = 633855;
         return style;
      }
      
      public static function get SpyScoreboardItemKarmaRed() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = 18;
         style.fontColor = 14559530;
         return style;
      }
      
      public static function get SpyKillMapItemNameCivilian() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = 18;
         style.fontColor = WHITE;
         return style;
      }
      
      public static function get SpyKillMapItemNameInvestigater() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = 18;
         style.fontColor = 633855;
         return style;
      }
      
      public static function get SpyKillMapItemNameSpy() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = 18;
         style.fontColor = 16743724;
         return style;
      }
      
      public static function get SpyKillMapItemTime() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_NUMBERS;
         style.fontSize = 22;
         style.fontColor = BLACK;
         return style;
      }
      
      public static function get SpyKillMapItemKillStreak() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_BOLD;
         style.fontSize = 22;
         style.fontColor = WHITE;
         style.alignment = TextStyle.HALIGN_RIGHT;
         style.autoSize = TextFieldAutoSize.RIGHT;
         return style;
      }
      
      public static function get SpyKillMapWinnerSpy() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = 46;
         style.fontColor = 16743724;
         return style;
      }
      
      public static function get SpyKillMapWinnerInvestigater() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = 46;
         style.fontColor = 633855;
         return style;
      }
      
      public static function get SpyKillMapWinnerCivilian() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = 46;
         style.fontColor = WHITE;
         return style;
      }
      
      public static function get SpyKillMapCollapseText() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = 18;
         style.fontColor = WHITE;
         style.alignment = TextStyle.HALIGN_RIGHT;
         style.autoSize = TextFieldAutoSize.RIGHT;
         return style;
      }
      
      public static function get HelpMenuSkillKey() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = 15;
         style.fontColor = WHITE;
         style.alignment = TextStyle.HALIGN_CENTER;
         style.autoSize = TextFieldAutoSize.CENTER;
         return style;
      }
      
      public static function get HelpMenuSkillDesc() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = 15;
         style.fontColor = WHITE;
         style.multiLine = true;
         style.wordWrap = true;
         return style;
      }
      
      public static function get HelpMenuRoleCivilian() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = 27;
         style.fontColor = WHITE;
         style.alignment = TextStyle.HALIGN_CENTER;
         style.autoSize = TextFieldAutoSize.CENTER;
         return style;
      }
      
      public static function get HelpMenuRoleSpy() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = 27;
         style.fontColor = 16743724;
         style.alignment = TextStyle.HALIGN_CENTER;
         style.autoSize = TextFieldAutoSize.CENTER;
         return style;
      }
      
      public static function get HelpMenuRoleInvestigater() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = 27;
         style.fontColor = 633855;
         style.alignment = TextStyle.HALIGN_CENTER;
         style.autoSize = TextFieldAutoSize.CENTER;
         return style;
      }
      
      public static function get HelpMenuSpyTitle() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = 16;
         style.fontColor = ROLE_SPY_COLOR;
         return style;
      }
      
      public static function get HelpMenuInvestigatorTitle() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = 16;
         style.fontColor = ROLE_INVESTIGATOR_COLOR;
         return style;
      }
      
      public static function get HelpMenuRoleDescCivilian() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = 15;
         style.fontColor = WHITE;
         style.multiLine = true;
         style.wordWrap = true;
         return style;
      }
      
      public static function get HelpMenuRoleDescSpy() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = 15;
         style.fontColor = 16743724;
         style.multiLine = true;
         style.wordWrap = true;
         return style;
      }
      
      public static function get HelpMenuRoleDescInvestigater() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = 15;
         style.fontColor = 633855;
         style.multiLine = true;
         style.wordWrap = true;
         return style;
      }
      
      public static function get KarmaWarning() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_BOLD;
         style.fontSize = 22;
         style.fontColor = WHITE;
         return style;
      }
      
      public static function get QuickChatSmall() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = 16;
         style.fontColor = WHITE;
         style.alignment = TextStyle.HALIGN_CENTER;
         return style;
      }
      
      public static function get QuickChatBig() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = 16;
         style.fontColor = WHITE;
         style.alignment = TextStyle.HALIGN_CENTER;
         return style;
      }
      
      public static function get PauseMenuAllRoleTitle() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_BOLD;
         style.fontSize = 34;
         style.fontColor = WHITE;
         return style;
      }
      
      public static function get PauseMenuAllRoleInvestigator() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_BOLD;
         style.fontSize = 32;
         style.fontColor = 633855;
         return style;
      }
      
      public static function get PauseMenuAllRoleCivilian() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_BOLD;
         style.fontSize = 32;
         style.fontColor = WHITE;
         return style;
      }
      
      public static function get PauseMenuAllRoleSpy() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_BOLD;
         style.fontSize = 32;
         style.fontColor = 16743724;
         return style;
      }
      
      public static function get PauseMenuAllRoleInvestigatorDesc() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = 24;
         style.fontColor = 633855;
         return style;
      }
      
      public static function get PauseMenuAllRoleCivilianDesc() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = 24;
         style.fontColor = WHITE;
         return style;
      }
      
      public static function get PauseMenuAllRoleSpyDesc() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = 24;
         style.fontColor = 16743724;
         return style;
      }
      
      public static function get PauseMenuAllRoleTipsTitle() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_BOLD;
         style.fontSize = 34;
         style.fontColor = WHITE;
         return style;
      }
      
      public static function get PauseMenuAllRoleTip() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = 20;
         style.fontColor = 9162481;
         return style;
      }
      
      public static function get VoteKick() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = 10;
         style.fontColor = 9551068;
         return style;
      }
      
      public static function get VoteKickTarget() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = 10;
         style.fontColor = 16743724;
         return style;
      }
      
      public static function get VoteKickAdditionalText() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = 10;
         style.fontColor = 9551068;
         style.multiLine = false;
         style.wordWrap = false;
         return style;
      }
      
      public static function get VoteKickOptions() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = 12;
         style.fontColor = WHITE;
         return style;
      }
      
      public static function get VoteKickCountDown() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = 18;
         style.fontColor = WHITE;
         return style;
      }
      
      public static function get VoteKickAgreeRatio() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = 12;
         style.fontColor = WHITE;
         return style;
      }
      
      public static function get SpyAutopsyListTime() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = 19;
         style.fontColor = BLACK;
         return style;
      }
      
      public static function get SpyAutopsyListCivilian() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = 19;
         style.fontColor = WHITE;
         return style;
      }
      
      public static function get SpyAutopsyListSpy() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = 19;
         style.fontColor = 16743724;
         return style;
      }
      
      public static function get SpyAutopsyListInvestigator() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_MEDIUM;
         style.fontSize = 19;
         style.fontColor = 633855;
         return style;
      }
      
      public static function get SpyScoreboardRoundLeft() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_NUMBERS;
         style.bold = true;
         style.fontSize = 24;
         style.fontColor = WHITE;
         style.autoSize = TextFieldAutoSize.RIGHT;
         return style;
      }
      
      public static function get SpyScoreboardRoundLeftLabel() : TextStyle
      {
         var style:TextStyle = new TextStyle();
         style.font = FONT_FACE_BOLD;
         style.fontSize = 22;
         style.fontColor = 13882323;
         style.alignment = TextStyle.HALIGN_LEFT;
         return style;
      }
   }
}

