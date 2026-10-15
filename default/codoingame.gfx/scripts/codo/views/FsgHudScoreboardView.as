package codo.views
{
   import codo.base.BaseView;
   import codo.common.CFunctionCommonContainer;
   import codo.constants.DataCommonID;
   import codo.constants.GameInfo;
   import codo.constants.ScoreboardColumnData;
   import codo.localization.DictInGame;
   import codo.objects.MatchStatusObj;
   import codo.objects.ResultObj;
   import codo.objects.ScoreboardObj;
   import codo.services.InGameService;
   import codo.utils.AsymPvpUtil;
   import codo.utils.HostageUtil;
   import codo.utils.LocalizeUtil;
   import codo.utils.ScaleformUtil;
   import components.fsgmatchresult_part.FsgMatchResultTeamPanel;
   import components.fsgmatchresult_part.MatchDataRow;
   import components.fsgmatchresult_part.panels.FsgMatchResultScoreboardPopupPanel;
   import components.scoreboard_part.SurvivalPanel;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.utils.getDefinitionByName;
   
   public class FsgHudScoreboardView extends BaseView
   {
      
      private static const HEADER_PADDING:int = 10;
      
      private static const SCOREBOARD_ITEM_LINKAGE:String = "fsg.scoreboard.fsgScoreboardDataRow";
      
      private static const ZOMBIE_ARENA_ID:String = "zarena";
      
      private static const ZOMBIESURVIVAL_ID:String = "zsurv";
      
      private static const ZCHAMP_ID:String = "zchamp";
      
      private var mGameHeight:int = 0;
      
      private var mGameWidth:int = 0;
      
      private var mReducedPercentage:Number = 0.888;
      
      private var mSixteenNineRatio:Number = 1.7777777777777777;
      
      private var mScorePanelInitPos:Number = 0;
      
      private var mIsSurvival:Boolean;
      
      public var myContentClip:MovieClip;
      
      public var myScoreboardHeader:MovieClip;
      
      public var myMatchStatus:TextField;
      
      public var myScoreboardPanel:FsgMatchResultScoreboardPopupPanel;
      
      public var mySurvivalPanel:SurvivalPanel;
      
      private var mScoreboardDataValid:Boolean;
      
      public function FsgHudScoreboardView()
      {
         var scoreboardClass:Class = null;
         var panelClass:Class = null;
         super();
         this.myScoreboardHeader = this.myContentClip.myScoreboardHeader;
         this.myMatchStatus = this.myScoreboardHeader.myMatchStatus;
         this.myMatchStatus.autoSize = TextFieldAutoSize.LEFT;
         var windowAR:Number = GameInfo.gameWidth / GameInfo.gameHeight;
         if(windowAR < this.mSixteenNineRatio)
         {
            this.mReducedPercentage = 0.75;
         }
         this.mGameWidth = GameInfo.DEFAULT_WIDTH;
         this.mGameHeight = GameInfo.DEFAULT_HEIGHT / this.mReducedPercentage;
         if(true == ScaleformUtil.isScaleform && null == this.myScoreboardPanel)
         {
            scoreboardClass = getDefinitionByName("fsg.matchresults.fsgMatchResultScoreboardPanel") as Class;
            this.myScoreboardPanel = addChild(new scoreboardClass()) as FsgMatchResultScoreboardPopupPanel;
            this.myScoreboardPanel.scaleX = this.myScoreboardPanel.scaleY = this.mReducedPercentage;
            this.myScoreboardPanel.SetDataRowLinkage(SCOREBOARD_ITEM_LINKAGE);
            this.myScoreboardPanel.SetShowWinner(false);
            this.myScoreboardPanel.SetShowTeamColor(false);
            this.myScoreboardPanel.SetScoreboardMode(ScoreboardColumnData.IN_GAME);
            this.myScoreboardPanel.skipAnimation(true);
            this.myScoreboardPanel.x = (this.mGameWidth - this.myScoreboardPanel.width) * 0.5;
            this.myScoreboardPanel.y = (this.mGameHeight - this.myScoreboardPanel.height) * 0.5;
            this.myScoreboardHeader.x = this.myScoreboardPanel.x;
            this.myScoreboardHeader.y = this.myScoreboardPanel.y - this.myScoreboardHeader.height - HEADER_PADDING;
         }
         this.mIsSurvival = InGameService.getInstance().isSurvival();
         if(this.mIsSurvival)
         {
            panelClass = getDefinitionByName("scoreboard.survivalPanel") as Class;
            this.mySurvivalPanel = addChild(new panelClass()) as SurvivalPanel;
            this.mySurvivalPanel.x = (this.mGameWidth - this.mySurvivalPanel.width) * 0.5;
         }
         this.mScoreboardDataValid = false;
      }
      
      override protected function showView() : void
      {
         var totalLines:Number = NaN;
         var totalHeight:Number = NaN;
         var windowAR:Number = NaN;
         super.showView();
         if(null != this.myScoreboardPanel)
         {
            if(!this.mScoreboardDataValid)
            {
               visible = false;
            }
            bind(DataCommonID.HUD_SCORE_BOARD,this.bindScoreboard);
            this.myScoreboardPanel.skipAnimation(true);
            this.myScoreboardPanel.active();
            if(AsymPvpUtil.instance.isInfectedGameMode(this.myScoreboardPanel.mGameMode))
            {
               if(this.mScorePanelInitPos == 0)
               {
                  totalLines = Math.floor((this.myScoreboardPanel.getHeight() - FsgMatchResultTeamPanel.mNumDefaultHeaderHeight) / MatchDataRow.DEFAULT_HEIGHT) - 1;
                  totalHeight = totalLines * MatchDataRow.DEFAULT_HEIGHT + FsgMatchResultTeamPanel.mNumDefaultHeaderHeight + (FsgMatchResultTeamPanel.mNumMinimumRows * MatchDataRow.DEFAULT_HEIGHT + FsgMatchResultTeamPanel.mNumDefaultHeaderHeight);
                  this.mScorePanelInitPos = (this.mGameHeight - totalHeight) * 0.5;
               }
               this.myScoreboardPanel.y = this.mScorePanelInitPos;
               this.myScoreboardHeader.y = this.myScoreboardPanel.y - (this.myScoreboardHeader.height + HEADER_PADDING);
            }
            else
            {
               this.myScoreboardPanel.y = (this.mGameHeight - this.myScoreboardPanel.getHeight()) * 0.5;
               if(this.myScoreboardPanel.mGameMode == ZOMBIE_ARENA_ID || this.myScoreboardPanel.mGameMode == ZOMBIESURVIVAL_ID || this.myScoreboardPanel.mGameMode == ZCHAMP_ID)
               {
                  windowAR = GameInfo.gameWidth / GameInfo.gameHeight;
                  if(windowAR < this.mSixteenNineRatio)
                  {
                     this.myScoreboardPanel.y -= 250;
                  }
                  else
                  {
                     this.myScoreboardPanel.y -= 200;
                  }
               }
               this.myScoreboardHeader.y = this.myScoreboardPanel.y - this.myScoreboardHeader.height - HEADER_PADDING;
               if(this.mIsSurvival)
               {
                  this.mySurvivalPanel.refreshObjectives();
                  this.mySurvivalPanel.y = this.myScoreboardHeader.y - this.mySurvivalPanel.height - HEADER_PADDING;
               }
            }
         }
      }
      
      override protected function hideView() : void
      {
         super.hideView();
         if(null != this.myScoreboardPanel)
         {
            this.myScoreboardPanel.deactive();
            unbind(DataCommonID.HUD_SCORE_BOARD,this.bindScoreboard);
         }
      }
      
      override protected function enableData() : void
      {
         if(true == ScaleformUtil.isScaleform)
         {
            bind(DataCommonID.MATCH_STATUS,this.bind_matchStatus);
         }
      }
      
      override protected function disableData() : void
      {
         if(true == ScaleformUtil.isScaleform)
         {
            unbind(DataCommonID.MATCH_STATUS,this.bind_matchStatus);
         }
      }
      
      protected function bind_matchStatus(cResult:ResultObj) : void
      {
         var statusString:String = null;
         var hostagePhase:int = 0;
         var hostageAction:int = 0;
         var status:MatchStatusObj = new MatchStatusObj(cResult.data);
         if(this.myMatchStatus != null)
         {
            statusString = status.map + " - " + LocalizeUtil.localize(CFunctionCommonContainer.AS_GetGameTypeDisplayName());
            if(status.gametypeID != "coop" && status.gametypeID != "zm")
            {
               if(status.gametypeID == "dd" || status.gametypeID == "sd" || status.gametypeID == "sdp" || status.gametypeID == "sdc" || status.gametypeID == "ctf")
               {
                  statusString += " - " + LocalizeUtil.param(DictInGame.RoundNum,[String(status.round)]);
               }
               else if(status.gametypeID == "hostage")
               {
                  hostagePhase = HostageUtil.GetMatchPhase(status.round);
                  hostageAction = HostageUtil.GetMatchAction(status.round);
                  if(hostagePhase == HostageUtil.HOSTAGE_PHASE_FIRST_HALF)
                  {
                     statusString += " - " + LocalizeUtil.localize(DictInGame.FirstHalf) + " - " + LocalizeUtil.param(DictInGame.OperationNum,[String(hostageAction)]);
                  }
                  else if(hostagePhase == HostageUtil.HOSTAGE_PHASE_SECOND_HALF)
                  {
                     statusString += " - " + LocalizeUtil.localize(DictInGame.SecondHalf) + " - " + LocalizeUtil.param(DictInGame.OperationNum,[String(hostageAction)]);
                  }
                  else
                  {
                     statusString += " - " + LocalizeUtil.localize(DictInGame.OperationExtra);
                  }
               }
            }
            this.myMatchStatus.text = statusString.toUpperCase();
         }
      }
      
      public function bindScoreboard(result:ResultObj) : void
      {
         var scoreboardObj:ScoreboardObj = null;
         if(result.result == ResultObj.RESULT_SUCCESS)
         {
            scoreboardObj = new ScoreboardObj(result.data);
            if(Boolean(scoreboardObj.alliesPlayers) && Boolean(scoreboardObj.alliesPlayers.length > 0) || Boolean(scoreboardObj.axisPlayers) && Boolean(scoreboardObj.axisPlayers.length > 0))
            {
               visible = true;
               this.mScoreboardDataValid = true;
            }
         }
      }
   }
}

