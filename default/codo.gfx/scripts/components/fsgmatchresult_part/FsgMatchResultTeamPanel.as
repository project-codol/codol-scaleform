package components.fsgmatchresult_part
{
   import codo.common.CFunctionCommonContainer;
   import codo.constants.ScoreboardColumnData;
   import codo.localization.Dict;
   import codo.localization.DictCoopSummary;
   import codo.localization.DictMatchResults;
   import codo.utils.AsymPvpUtil;
   import codo.utils.LocalizeUtil;
   import com.greensock.TweenLite;
   import com.greensock.easing.Linear;
   import components.fsgmatchresult_part.panels.FsgMatchResultScoreboardPopupPanel;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.utils.clearTimeout;
   import flash.utils.getDefinitionByName;
   import flash.utils.setTimeout;
   
   public class FsgMatchResultTeamPanel extends MovieClip
   {
      
      private static const WIN_LOSS_SLIDE_DURATION:Number = 0.2;
      
      private static const FADE_IN_DURATION:Number = 0.4;
      
      private static const WINNER_FADE_IN_DURATION:Number = 0.2;
      
      private static const WINLOSS_SLIDE_END_X:Number = 54;
      
      private static const SHOW_WIN_DELAY:int = 1000;
      
      private static const WIN_ANIM_START_FRAME:String = "play";
      
      private static const DEFAULT_LOGO_FRAME:String = "default";
      
      private static const SCAR_LOGO_FRAME:String = "scar";
      
      private static const TF141_LOGO_FRAME:String = "tf141";
      
      private static const HUMANS_LOGO_FRAME:String = "humans";
      
      private static const INFECTED_LOGO_FRAME:String = "infected";
      
      private static const TF141_COLOR:uint = 16777215;
      
      private static const SCAR_COLOR:uint = 16777215;
      
      private static const LOSS_TEAM_COLOR:uint = 16777215;
      
      private static const LOSS_TEAM_TEXT_ALPHA:Number = 0.7;
      
      private static const WIN_TEAM_LOGO_ALPHA:Number = 0.8;
      
      private static const SCORE_TITLE_PADDING:Number = 133;
      
      private static const SCORE_TEXT_PADDING:Number = 8;
      
      private static const HEADER_DIVIDER_MARGIN:int = 14;
      
      private static const IN_GAME_HEADER_BG_MARGIN:int = 6;
      
      private static const DEFAULT_DATA_ROW_LINKAGE:String = "fsg.matchresults.fsgMatchResultDataRow";
      
      public static var mNumDefaultRows:int = 9;
      
      public static var mNumMinimumRows:int = 7;
      
      private static var mBaseColumnHeight:int = 308;
      
      private static var mBaseBGHeight:int = 344;
      
      private static var mClipLogoHeight:int = 344;
      
      private static var mBaseBGWidth:int = 440;
      
      public static var mNumDefaultHeaderHeight:int = 36;
      
      public var myContainer:MovieClip;
      
      public var myColumns:MovieClip;
      
      public var myWinLossTextContainer:MovieClip;
      
      public var myTeamLogo:MovieClip;
      
      public var myInGameBackground:MovieClip;
      
      public var myClippedLogo:MovieClip;
      
      public var myTeamCorner:MovieClip;
      
      public var myWinStamp:MovieClip;
      
      public var myHeader:MovieClip;
      
      public var myHeaderDivider:MovieClip;
      
      public var myRowMount:MovieClip;
      
      public var myPanelOutline:MovieClip;
      
      public var myClippedMask:MovieClip;
      
      public var myTeamNameText:TextField;
      
      public var myScoreTitle:TextField;
      
      public var myScoreText:TextField;
      
      public var myWinLossText:TextField;
      
      public var myAlternateText:TextField;
      
      private var mDataRowLinkage:String;
      
      private var mShowWinTimer:int;
      
      private var mDataRows:Vector.<MatchDataRow>;
      
      private var mIsWinner:Boolean = false;
      
      private var mIsWargod:Boolean = false;
      
      private var mTeam:int;
      
      private var mIsFriendly:Boolean;
      
      private var mGameMode:String;
      
      public function FsgMatchResultTeamPanel()
      {
         super();
         this.myWinLossTextContainer = this.myContainer.myWinLossTextContainer;
         this.myTeamLogo = this.myContainer.myTeamLogo;
         this.myInGameBackground = this.myContainer.myInGameBackground;
         this.myClippedLogo = this.myContainer.myClippedLogo;
         this.myWinStamp = this.myContainer.myWinStamp;
         this.myHeader = this.myContainer.myHeader;
         this.myHeaderDivider = this.myContainer.myHeaderDivider;
         this.myRowMount = this.myContainer.myRowMount;
         this.myPanelOutline = this.myContainer.myPanelOutline;
         this.myClippedMask = this.myContainer.myClippedMask;
         this.myColumns = this.myContainer.myColumns;
         this.myTeamNameText = this.myContainer.myTeamNameText;
         this.myAlternateText = this.myContainer.myAlternateText;
         this.myScoreTitle = this.myWinLossTextContainer.myScoreTitle;
         this.myScoreText = this.myWinLossTextContainer.myScoreText;
         this.myWinLossText = this.myWinLossTextContainer.myWinLossText;
         this.myTeamCorner = this.myWinLossTextContainer.myTeamCorner;
         this.mDataRowLinkage = DEFAULT_DATA_ROW_LINKAGE;
         this.myTeamNameText.autoSize = TextFieldAutoSize.CENTER;
         this.myScoreTitle.autoSize = TextFieldAutoSize.LEFT;
         this.myScoreText.autoSize = TextFieldAutoSize.LEFT;
         this.myWinLossText.autoSize = TextFieldAutoSize.CENTER;
         this.myAlternateText.autoSize = TextFieldAutoSize.CENTER;
         this.myAlternateText.visible = false;
         this.myWinLossText.visible = false;
         this.myTeamNameText.visible = false;
         this.myRowMount.visible = false;
         this.myWinLossTextContainer.visible = false;
         this.myTeamLogo.visible = false;
      }
      
      private function _InitDataRows(numRows:Number, orderedColumnWidths:Array) : void
      {
         var newRow:MatchDataRow = null;
         this.mDataRows = new Vector.<MatchDataRow>();
         this._ClearDataRows();
         var rowClass:Class = getDefinitionByName(this.mDataRowLinkage) as Class;
         var heightIncrease:Number = 0;
         if(!AsymPvpUtil.instance.isInfectedGameMode(this.mGameMode))
         {
            mNumDefaultRows = 9;
            mBaseColumnHeight = 308;
            mBaseBGHeight = 344;
         }
         else
         {
            mNumDefaultRows = mNumMinimumRows;
            mBaseColumnHeight = 240;
            mBaseBGHeight = 276;
         }
         for(var i:int = 0; i < numRows; i++)
         {
            newRow = new rowClass() as MatchDataRow;
            newRow.SetColumnWidths(orderedColumnWidths);
            newRow.TeamColor = this.GetTeamColor();
            this.mDataRows.push(newRow);
            newRow.y = MatchDataRow.GetHeight() * i;
            if(i >= mNumDefaultRows)
            {
               heightIncrease += MatchDataRow.GetHeight();
            }
         }
         var baseHeight:Number = mBaseBGHeight + heightIncrease;
         var basePercentage:Number = baseHeight / mClipLogoHeight;
         this.myColumns.height = mBaseColumnHeight + heightIncrease;
         this.myPanelOutline.height = baseHeight;
         this.myInGameBackground.height = baseHeight;
         this.myInGameBackground.gotoAndStop(this.GetTeamColor());
         this.myHeader.myColorSwitch.gotoAndStop(this.GetTeamColor());
         this.myHeaderDivider.gotoAndStop(this.GetTeamColor());
         this.myPanelOutline.gotoAndStop(this.GetTeamColor());
         this.myClippedMask.height = baseHeight;
         if(basePercentage < 1)
         {
            this.myClippedLogo.scaleX = this.myClippedLogo.scaleY = 1;
         }
         else
         {
            this.myClippedLogo.scaleX = this.myClippedLogo.scaleY = basePercentage;
         }
         this.myClippedLogo.x = (mBaseBGWidth - this.myClippedLogo.width) * 0.5;
         this.myClippedLogo.y = (baseHeight - this.myClippedLogo.height) * 0.5;
         this.myScoreTitle.y = this.myInGameBackground.height - SCORE_TITLE_PADDING;
         this.myScoreText.y = this.myScoreTitle.y + SCORE_TEXT_PADDING;
         for(var j:int = this.mDataRows.length - 1; j >= 0; j--)
         {
            this.myRowMount.addChild(this.mDataRows[j]);
         }
         this.myTeamCorner.y = this.myClippedMask.height;
         this.myTeamNameText.y = (this.myClippedMask.height - this.myTeamNameText.height) / 2;
      }
      
      public function SetWidth(w:Number) : void
      {
         this.myHeaderDivider.width = w - HEADER_DIVIDER_MARGIN;
         this.myInGameBackground.width = w + IN_GAME_HEADER_BG_MARGIN;
      }
      
      public function SetAlternateText(txt:String) : void
      {
         this.myAlternateText.text = LocalizeUtil.localize(txt).toUpperCase();
      }
      
      public function SetHeaders(headers:Array) : void
      {
         for(var i:int = 0; i < ScoreboardColumnData.MAX_COLUMNS; i++)
         {
            this.myHeader["myHeader" + String(i)].text = LocalizeUtil.localize(headers[i]).toUpperCase();
         }
      }
      
      public function SetDataRowLinkage(rowLinkage:String) : void
      {
         this.mDataRowLinkage = rowLinkage;
      }
      
      public function SetPlayerData(data:Array, orderedKeys:Array, orderedColumnWidths:Array) : void
      {
         var row:MatchDataRow = null;
         var numPlayers:int = int(data.length);
         if(this.mDataRows == null || this.mDataRows.length != numPlayers)
         {
            this._InitDataRows(numPlayers,orderedColumnWidths);
         }
         for(var i:int = 0; i < this.mDataRows.length; i++)
         {
            row = this.mDataRows[i];
            if(null != data[i])
            {
               row.SetData(data[i],orderedKeys);
            }
            else
            {
               row.ClearData();
            }
         }
      }
      
      public function SetColumnWidths(orderedWidths:Array) : void
      {
         var column:MovieClip = null;
         var header:TextField = null;
         var xPos:Number = 0;
         for(var i:int = 0; i < ScoreboardColumnData.MAX_COLUMNS; i++)
         {
            column = this.myColumns["myColumn" + String(i)];
            header = this.myHeader["myHeader" + String(i)];
            if(Boolean(orderedWidths[i]) && Boolean(column) && Boolean(header))
            {
               column.width = orderedWidths[i];
               header.width = column.width - 10;
               header.x = column.x = xPos;
               xPos += column.width;
               column.visible = true;
            }
            else
            {
               column.visible = false;
            }
         }
      }
      
      public function SetTeam(team:int) : void
      {
         this.mTeam = team;
         switch(team)
         {
            case FsgMatchResultScoreboardPopupPanel.SCAR:
               this.myTeamNameText.text = Dict.FORCE_SC;
               this.myTeamNameText.textColor = SCAR_COLOR;
               this.myScoreText.textColor = SCAR_COLOR;
               this.myTeamLogo.gotoAndStop(SCAR_LOGO_FRAME);
               this.myClippedLogo.gotoAndStop(SCAR_LOGO_FRAME);
               this.myWinStamp.myMedalIcon.gotoAndStop(SCAR_LOGO_FRAME);
               this.myTeamNameText.alpha = 1;
               this.myTeamLogo.alpha = 1;
               this.myClippedLogo.visible = true;
               this.myScoreTitle.visible = true;
               this.myScoreText.visible = true;
               this.myAlternateText.visible = false;
               break;
            case FsgMatchResultScoreboardPopupPanel.TF141:
               this.myTeamNameText.text = Dict.FORCE_TF;
               this.myTeamNameText.textColor = TF141_COLOR;
               this.myScoreText.textColor = TF141_COLOR;
               this.myTeamLogo.gotoAndStop(TF141_LOGO_FRAME);
               this.myClippedLogo.gotoAndStop(TF141_LOGO_FRAME);
               this.myWinStamp.myMedalIcon.gotoAndStop(TF141_LOGO_FRAME);
               this.myTeamNameText.alpha = 1;
               this.myTeamLogo.alpha = 1;
               this.myClippedLogo.visible = true;
               this.myScoreTitle.visible = true;
               this.myScoreText.visible = true;
               this.myAlternateText.visible = false;
               break;
            case FsgMatchResultScoreboardPopupPanel.INFECTED:
               this.myTeamNameText.text = Dict.FORCE_INFECTED;
               this.myTeamNameText.textColor = SCAR_COLOR;
               this.myScoreText.textColor = SCAR_COLOR;
               this.myTeamLogo.gotoAndStop(INFECTED_LOGO_FRAME);
               this.myClippedLogo.gotoAndStop(INFECTED_LOGO_FRAME);
               this.myTeamNameText.alpha = 1;
               this.myTeamLogo.alpha = 1;
               this.myClippedLogo.visible = true;
               this.myScoreTitle.visible = true;
               this.myScoreText.visible = true;
               this.myAlternateText.visible = false;
               break;
            case FsgMatchResultScoreboardPopupPanel.HUMANS:
               this.myTeamNameText.text = Dict.FORCE_HUMANS;
               this.myTeamNameText.textColor = TF141_COLOR;
               this.myScoreText.textColor = TF141_COLOR;
               this.myTeamLogo.gotoAndStop(HUMANS_LOGO_FRAME);
               this.myClippedLogo.gotoAndStop(HUMANS_LOGO_FRAME);
               this.myTeamNameText.alpha = 1;
               this.myTeamLogo.alpha = 1;
               this.myClippedLogo.visible = true;
               this.myScoreTitle.visible = true;
               this.myScoreText.visible = true;
               this.myAlternateText.visible = false;
               break;
            case FsgMatchResultScoreboardPopupPanel.NO_TEAM:
               this.myClippedLogo.gotoAndStop(DEFAULT_LOGO_FRAME);
               this.myTeamNameText.alpha = 0;
               this.myTeamLogo.alpha = 0;
               this.myClippedLogo.visible = true;
               this.myScoreTitle.visible = false;
               this.myScoreText.visible = false;
               this.myWinLossText.visible = false;
               this.myAlternateText.visible = true;
         }
      }
      
      public function SetFriendly(isFriendly:Boolean) : void
      {
         this.mIsFriendly = isFriendly;
         if(isFriendly)
         {
            this.SetColumnColor(TF141_LOGO_FRAME);
            this.myTeamCorner.gotoAndStop(TF141_LOGO_FRAME);
         }
         else
         {
            this.SetColumnColor(SCAR_LOGO_FRAME);
            this.myTeamCorner.gotoAndStop(SCAR_LOGO_FRAME);
         }
      }
      
      public function SetColumnColor(team:String) : void
      {
         var column:MovieClip = null;
         for(var i:int = 0; i < ScoreboardColumnData.MAX_COLUMNS; i++)
         {
            column = this.myColumns["myColumn" + String(i)];
            column.gotoAndStop(team);
         }
      }
      
      public function GetTeamColor() : String
      {
         if(this.mIsFriendly)
         {
            return TF141_LOGO_FRAME;
         }
         return SCAR_LOGO_FRAME;
      }
      
      public function SetScore(score:int) : void
      {
         this.myScoreTitle.text = Dict.MATCH_SCORE_LABEL;
         this.myScoreText.text = score.toString();
      }
      
      public function HideTeamColor() : void
      {
         this.myTeamNameText.textColor = LOSS_TEAM_COLOR;
         this.myScoreText.textColor = LOSS_TEAM_COLOR;
         this.myWinLossText.textColor = LOSS_TEAM_COLOR;
      }
      
      public function SetWinner(result:int) : void
      {
         this.myWinLossText.visible = true;
         this.mIsWinner = result == 1;
         this.mIsWargod = CFunctionCommonContainer.IsWargodMatch() as Boolean;
         if(result == 1)
         {
            this.myWinLossText.text = LocalizeUtil.localize(DictMatchResults.MATCH_WON).toUpperCase();
            this.myAlternateText.text = LocalizeUtil.localize(DictCoopSummary.UI_MISSION_SUCCESS).toUpperCase();
            if(this.mShowWinTimer <= 0)
            {
               this.mShowWinTimer = setTimeout(this._PlayWinAnim,SHOW_WIN_DELAY);
            }
            this.myClippedLogo.alpha = WIN_TEAM_LOGO_ALPHA;
         }
         else if(result == 2)
         {
            this.myWinLossText.text = this.mIsWargod ? LocalizeUtil.localize(DictMatchResults.MATCH_LOST).toUpperCase() : "";
            this.myAlternateText.text = LocalizeUtil.localize(DictCoopSummary.UI_MISSION_FAILED).toUpperCase();
            this.myTeamNameText.textColor = LOSS_TEAM_COLOR;
            this.myScoreText.textColor = LOSS_TEAM_COLOR;
            this.myWinLossText.textColor = LOSS_TEAM_COLOR;
            this.myTeamNameText.alpha = LOSS_TEAM_TEXT_ALPHA;
            this.myWinLossText.alpha = LOSS_TEAM_TEXT_ALPHA;
            this.myClippedLogo.alpha = WIN_TEAM_LOGO_ALPHA;
            this.myAlternateText.alpha = LOSS_TEAM_TEXT_ALPHA;
         }
         else
         {
            this.myWinLossText.text = LocalizeUtil.localize(DictMatchResults.MATCH_DRAW).toUpperCase();
            this.myAlternateText.text = LocalizeUtil.localize(DictCoopSummary.UI_MISSION_FAILED).toUpperCase();
            this.myTeamNameText.textColor = LOSS_TEAM_COLOR;
            this.myScoreText.textColor = LOSS_TEAM_COLOR;
            this.myWinLossText.textColor = LOSS_TEAM_COLOR;
            this.myTeamNameText.alpha = LOSS_TEAM_TEXT_ALPHA;
            this.myWinLossText.alpha = LOSS_TEAM_TEXT_ALPHA;
            this.myClippedLogo.alpha = WIN_TEAM_LOGO_ALPHA;
            this.myAlternateText.alpha = LOSS_TEAM_TEXT_ALPHA;
         }
         this.myScoreTitle.visible = this.myScoreText.visible = this.mIsWargod;
      }
      
      public function set gameMode(mode:String) : void
      {
         this.mGameMode = mode;
      }
      
      public function startAnimation() : void
      {
         TweenLite.to(this.myRowMount,FADE_IN_DURATION,{
            "alpha":1,
            "ease":Linear.easeInOut
         });
         var teamNameAlpha:Number = true == this.mIsWinner ? 1 : LOSS_TEAM_TEXT_ALPHA;
         TweenLite.to(this.myTeamNameText,FADE_IN_DURATION,{
            "alpha":teamNameAlpha,
            "ease":Linear.easeInOut,
            "delay":FADE_IN_DURATION
         });
         if(true == this.mIsWinner)
         {
            gotoAndPlay(2);
            this.myContainer.gotoAndPlay(2);
            TweenLite.to(this.myWinLossTextContainer,WIN_LOSS_SLIDE_DURATION,{
               "alpha":1,
               "x":WINLOSS_SLIDE_END_X,
               "ease":Linear.easeOut,
               "delay":WINNER_FADE_IN_DURATION
            });
         }
         else
         {
            TweenLite.to(this.myWinLossTextContainer,FADE_IN_DURATION,{
               "alpha":1,
               "ease":Linear.easeInOut,
               "delay":FADE_IN_DURATION
            });
         }
         TweenLite.to(this.myTeamLogo,FADE_IN_DURATION,{
            "alpha":1,
            "ease":Linear.easeInOut,
            "delay":FADE_IN_DURATION
         });
      }
      
      public function skipAnimation() : void
      {
         this.myRowMount.visible = true;
         this.myTeamNameText.visible = true;
         this.myWinLossTextContainer.visible = true;
         this.myTeamLogo.visible = true;
      }
      
      private function _PlayWinAnim() : void
      {
         clearTimeout(this.mShowWinTimer);
         this.myWinStamp.gotoAndPlay(WIN_ANIM_START_FRAME);
      }
      
      private function _ClearDataRows() : void
      {
         while(this.myRowMount.numChildren > 0)
         {
            this.myRowMount.removeChildAt(0);
         }
      }
   }
}

