package codo.views
{
   import codo.base.BaseView;
   import codo.common.CFunctionCommonContainer;
   import codo.constants.DataCommonID;
   import codo.constants.GameInfo;
   import codo.constants.ScoreboardColumnData;
   import codo.localization.Dict;
   import codo.objects.MatchStatusObj;
   import codo.objects.ResultObj;
   import codo.utils.LocalizeUtil;
   import codo.utils.ScaleformUtil;
   import components.fsgmatchresult_part.panels.FsgMatchResultScoreboardPopupPanel;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.utils.getDefinitionByName;
   
   public class FsgHudCyborgsView extends BaseView
   {
      
      private static const HEADER_PADDING:int = 15;
      
      private static const SCOREBOARD_ITEM_LINKAGE:String = "fsg.scoreboard.fsgScoreboardDataRow";
      
      private var mGameHeight:int = 0;
      
      private var mGameWidth:int = 0;
      
      private var mReducedPercentage:Number = 0.888;
      
      private var mSixteenNineRatio:Number = 1.7777777777777777;
      
      public var myContentClip:MovieClip;
      
      public var myScoreboardHeader:MovieClip;
      
      public var myMatchStatus:TextField;
      
      public var myScoreboardPanel:FsgMatchResultScoreboardPopupPanel;
      
      public function FsgHudCyborgsView()
      {
         var scoreboardClass:Class = null;
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
            this.myScoreboardPanel.SetScoreboardMode(ScoreboardColumnData.IN_GAME);
            this.myScoreboardPanel.SetDataRowLinkage(SCOREBOARD_ITEM_LINKAGE);
            this.myScoreboardPanel.SetShowWinner(false);
            this.myScoreboardPanel.SetShowTeamColor(false);
            this.myScoreboardPanel.skipAnimation(true);
            this.myScoreboardPanel.x = (this.mGameWidth - this.myScoreboardPanel.width) * 0.5;
            this.myScoreboardPanel.y = (this.mGameHeight - this.myScoreboardPanel.height) * 0.5;
            this.myScoreboardHeader.x = this.myScoreboardPanel.x;
            this.myScoreboardHeader.y = this.myScoreboardPanel.y - this.myScoreboardHeader.height - HEADER_PADDING;
         }
      }
      
      override protected function showView() : void
      {
         var windowAR:Number = NaN;
         super.showView();
         if(null != this.myScoreboardPanel)
         {
            this.myScoreboardPanel.skipAnimation(true);
            this.myScoreboardPanel.active();
            this.myScoreboardPanel.y = (this.mGameHeight - this.myScoreboardPanel.getHeight()) * 0.5;
            windowAR = GameInfo.gameWidth / GameInfo.gameHeight;
            if(windowAR < this.mSixteenNineRatio)
            {
               this.myScoreboardPanel.y -= 250;
            }
            else
            {
               this.myScoreboardPanel.y -= 200;
            }
            this.myScoreboardHeader.y = this.myScoreboardPanel.y - this.myScoreboardHeader.height - HEADER_PADDING;
         }
      }
      
      override protected function hideView() : void
      {
         super.hideView();
         if(null != this.myScoreboardPanel)
         {
            this.myScoreboardPanel.deactive();
         }
      }
      
      override protected function enableData() : void
      {
         if(true == ScaleformUtil.isScaleform)
         {
            bind(DataCommonID.HUD_SCORE_BOARD,this.myScoreboardPanel.bindScoreboard);
            bind(DataCommonID.OBJECTIVES,this.myScoreboardPanel.myIntelItemsList.bindObjectives);
            bind(DataCommonID.MATCH_STATUS,this.bind_matchStatus);
         }
      }
      
      override protected function disableData() : void
      {
         if(true == ScaleformUtil.isScaleform)
         {
            unbind(DataCommonID.HUD_SCORE_BOARD,this.myScoreboardPanel.bindScoreboard);
            unbind(DataCommonID.OBJECTIVES,this.myScoreboardPanel.myIntelItemsList.bindObjectives);
            unbind(DataCommonID.MATCH_STATUS,this.bind_matchStatus);
         }
      }
      
      protected function bind_matchStatus(cResult:ResultObj) : void
      {
         var statusString:String = null;
         var round:int = 0;
         var roundStr:String = null;
         var isSpecialRound:Boolean = false;
         var isFinalRound:Boolean = false;
         var isTutorialRound:Boolean = false;
         var status:MatchStatusObj = new MatchStatusObj(cResult.data);
         if(this.myMatchStatus != null)
         {
            statusString = status.map;
            round = CFunctionCommonContainer.Dvar_GetInt("ui_hud_round");
            roundStr = LocalizeUtil.localize(Dict.CYBORGS_AAR_ROUND_NUM);
            isSpecialRound = CFunctionCommonContainer.Dvar_GetBool("ui_hud_special_round") as Boolean;
            isFinalRound = CFunctionCommonContainer.Dvar_GetBool("ui_hud_final_round") as Boolean;
            isTutorialRound = CFunctionCommonContainer.Dvar_GetString("ui_mapname") == "zm_zombie_training";
            if(isSpecialRound)
            {
               statusString += " - " + LocalizeUtil.localize(Dict.CYBORG_SPECIAL_ROUND);
            }
            else if(isFinalRound)
            {
               statusString += " - " + LocalizeUtil.localize(Dict.CYBORG_FINAL_ROUND);
            }
            else
            {
               statusString += " - " + LocalizeUtil.replaceConversionString(roundStr,[String(round)]);
            }
            if(isTutorialRound)
            {
               statusString += " - " + LocalizeUtil.localize(Dict.CYBORG_TUTORIAL_ROUND);
            }
            this.myMatchStatus.text = statusString.toUpperCase();
         }
      }
   }
}

