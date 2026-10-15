package codo.views
{
   import codo.base.BaseView;
   import codo.constants.BCInGameEvent;
   import codo.constants.DataCommonID;
   import codo.objects.ResultObj;
   import codo.objects.ScoreboardObj;
   import components.list_part.HudScoreboardItemRenderer;
   import components.scoreboard_part.MatchStatusBar;
   import components.scoreboard_part.ScoreboardTeamPanel;
   
   public class ScoreboardBaseView extends BaseView
   {
      
      public var myHeader:HudScoreboardItemRenderer;
      
      public var myTeamBlue:ScoreboardTeamPanel;
      
      public var myTeamRed:ScoreboardTeamPanel;
      
      public var myFooter:MatchStatusBar;
      
      private var _team2Offset:Number;
      
      private var _footerOffset:Number;
      
      private var _modeInited:Boolean;
      
      public function ScoreboardBaseView()
      {
         super();
      }
      
      override protected function onInit() : void
      {
         super.onInit();
         this.myHeader.visible = false;
         this.myTeamBlue.visible = false;
         this.myTeamBlue.SetStyle(HudScoreboardItemRenderer.STYLE_BLUE);
         if(!this.IsCyborgsAsset())
         {
            this._team2Offset = this.myTeamRed.y - this.PanelBottom(this.myTeamBlue);
            this._footerOffset = this.myFooter.y - this.PanelBottom(this.myTeamRed);
            this.myTeamRed.SetStyle(HudScoreboardItemRenderer.STYLE_RED);
            this.myFooter.visible = this.myTeamRed.visible = false;
         }
      }
      
      override protected function showView() : void
      {
         super.showView();
         this.broadcast(BCInGameEvent.BIND_UI_KEY_CATCHER,true);
      }
      
      override protected function hideView() : void
      {
         super.hideView();
         this.broadcast(BCInGameEvent.BIND_UI_KEY_CATCHER,false);
      }
      
      override protected function enableData() : void
      {
         this.bind(DataCommonID.HUD_SCORE_BOARD,this.bind_hudScoreboard);
         this.bind(DataCommonID.MATCH_STATUS,this.bind_matchStatus);
      }
      
      override protected function disableData() : void
      {
         this.unbind(DataCommonID.HUD_SCORE_BOARD,this.bind_hudScoreboard);
         this.unbind(DataCommonID.MATCH_STATUS,this.bind_matchStatus);
      }
      
      protected function bind_hudScoreboard(cResult:ResultObj) : void
      {
         var scoreboardObj:ScoreboardObj = null;
         var designRows:int = 0;
         var desiredRows:int = 0;
         var expand:Number = NaN;
         var lastTeam:ScoreboardTeamPanel = null;
         scoreboardObj = new ScoreboardObj(cResult.data);
         if(!this._modeInited)
         {
            this._modeInited = true;
            if(scoreboardObj.gametype == "dm" || scoreboardObj.gametype == "infect" || scoreboardObj.gametype == "borg")
            {
               designRows = 9;
               desiredRows = 18;
               expand = this.myHeader.height * (desiredRows - designRows);
               this.myTeamBlue.AdjustHeight(expand);
               this.myTeamBlue.SetStyle(HudScoreboardItemRenderer.STYLE_NOTEAM);
               desiredRows = 3;
               expand = this.myHeader.height * (desiredRows - designRows);
               if(Boolean(this.myTeamRed))
               {
                  this.myTeamRed.AdjustHeight(expand);
               }
            }
         }
         this.myTeamBlue.SetScoreboardData(scoreboardObj);
         this.myHeader.InitHeader(scoreboardObj);
         this.myHeader.visible = true;
         this.myTeamBlue.visible = true;
         if(!this.IsCyborgsAsset())
         {
            this.myTeamRed.SetScoreboardData(scoreboardObj);
            this.myFooter.visible = true;
            this.myTeamRed.visible = true;
            this.myTeamRed.y = this.PanelBottom(this.myTeamBlue) + this._team2Offset;
            lastTeam = this.myTeamRed;
            if(scoreboardObj.axisPlayers.length == 0 || scoreboardObj.gametype == "dm")
            {
               this.myTeamRed.visible = false;
               lastTeam = this.myTeamBlue;
            }
            else if(scoreboardObj.alliesPlayers.length == 0)
            {
               this.myTeamBlue.visible = false;
               this.myTeamRed.y = this.myTeamBlue.y;
            }
            this.myFooter.y = this.PanelBottom(lastTeam) + this._footerOffset;
         }
      }
      
      protected function bind_matchStatus(cResult:ResultObj) : void
      {
         if(!this.IsCyborgsAsset())
         {
            this.myFooter.SetMatchStatus(cResult.data);
         }
      }
      
      private function PanelBottom(panel:ScoreboardTeamPanel) : Number
      {
         return panel.y + panel.myBkg.y + panel.myBkg.height;
      }
      
      protected function IsCyborgsAsset() : Boolean
      {
         return false;
      }
   }
}

