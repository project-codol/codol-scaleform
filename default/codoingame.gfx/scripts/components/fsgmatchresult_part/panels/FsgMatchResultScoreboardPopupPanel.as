package components.fsgmatchresult_part.panels
{
   import codo.common.CFunctionCommonContainer;
   import codo.component.lobby.LobbyConstants;
   import codo.constants.DataCommonID;
   import codo.constants.ScoreboardColumnData;
   import codo.localization.DictMatchResults;
   import codo.objects.ResultObj;
   import codo.objects.ScoreboardObj;
   import codo.objects.ScoreboardRowObj;
   import codo.utils.AsymPvpUtil;
   import codo.utils.ScaleformUtil;
   import com.greensock.TweenLite;
   import com.greensock.easing.Linear;
   import components.fsgmatchresult_part.FsgMatchResultIntelList;
   import components.fsgmatchresult_part.FsgMatchResultPopupPanelBase;
   import components.fsgmatchresult_part.FsgMatchResultTeamPanel;
   
   public class FsgMatchResultScoreboardPopupPanel extends FsgMatchResultPopupPanelBase
   {
      
      public static const GAMEMODE_DM:String = "dm";
      
      public static const GAMEMODE_CYBORG:String = "zm";
      
      public static const TF141:int = 0;
      
      public static const SCAR:int = 1;
      
      public static const HUMANS:int = 2;
      
      public static const INFECTED:int = 3;
      
      public static const NO_TEAM:int = 4;
      
      public static const INTEL_LIST_WIDTH:int = 1007;
      
      private static const SLIDE_IN_DURATION:Number = 0.1;
      
      private static const SLIDE_IN_START_X:Number = -50;
      
      private static const START_ANIM_DELAY:Number = 0.75;
      
      private static const PANEL_PADDING:int = 8;
      
      public var myTeamPanelOne:FsgMatchResultTeamPanel;
      
      public var myTeamPanelTwo:FsgMatchResultTeamPanel;
      
      public var myIntelItemsList:FsgMatchResultIntelList;
      
      private var mShowWinner:Boolean;
      
      private var mShowTeamColor:Boolean;
      
      private var mScoreboardMode:String;
      
      private var mScoreboardModeChanged:Boolean = true;
      
      private var mAnimationHasPlayed:Boolean = false;
      
      private var mSkipAnimation:Boolean = false;
      
      public var mGameMode:String = "";
      
      private var mOrderedHeaders:Array;
      
      private var mOrderedKeys:Array;
      
      private var mOrderedColumnWidths:Array;
      
      public function FsgMatchResultScoreboardPopupPanel()
      {
         super();
         this.mShowWinner = true;
         this.mShowTeamColor = true;
         this.myIntelItemsList.visible = false;
         if(false == ScaleformUtil.isScaleform)
         {
            this.bindScoreboard(generateFakeData());
            this.active();
         }
         this.myTeamPanelOne.SetFriendly(true);
         this.myTeamPanelTwo.SetFriendly(false);
      }
      
      private static function translatePlayerData(playerData:Array) : Array
      {
         var row:ScoreboardRowObj = null;
         var translatedData:Array = [];
         for(var i:int = 0; i < playerData.length; i++)
         {
            row = new ScoreboardRowObj(playerData[i]);
            translatedData.push(row);
         }
         return translatedData;
      }
      
      private static function generateFakeData() : ResultObj
      {
         var otherPlayer:Object = null;
         var resultObj:ResultObj = new ResultObj();
         var fakeData:Object = {};
         var axisPlayers:Array = [];
         var alliesPlayers:Array = [];
         resultObj.data = fakeData;
         fakeData["axisScore"] = 1000;
         fakeData["alliesScore"] = 2000;
         fakeData["axisPlayers"] = axisPlayers;
         fakeData["alliesPlayers"] = alliesPlayers;
         fakeData["gametype"] = "dm";
         var onePlayer:Object = {};
         onePlayer.player = "Xiao Yuting";
         onePlayer.kills = 88;
         onePlayer.deaths = 1;
         onePlayer.assists = 10;
         onePlayer.revives = 20;
         onePlayer.objectives = 30;
         onePlayer.rank = 1;
         onePlayer.level = 70;
         onePlayer.score = 12345;
         onePlayer.ping = 16;
         onePlayer.isSelf = true;
         onePlayer.xpgained = 321;
         onePlayer.gpgained = 432;
         onePlayer.isDead = false;
         onePlayer.clantag = "CLAN";
         axisPlayers.push(onePlayer);
         alliesPlayers.push(onePlayer);
         for(var i:int = 2; i < 13; i++)
         {
            otherPlayer = {};
            otherPlayer.player = "Tinggo";
            otherPlayer.kills = 88;
            otherPlayer.deaths = 1;
            otherPlayer.assists = 10;
            otherPlayer.revives = 20;
            otherPlayer.objectives = 30;
            otherPlayer.rank = i;
            otherPlayer.level = 70;
            otherPlayer.score = 12345;
            otherPlayer.ping = 16;
            otherPlayer.isSelf = false;
            otherPlayer.xpgained = 321;
            otherPlayer.gpgained = 432;
            otherPlayer.isDead = false;
            otherPlayer.clantag = "CLAN";
            axisPlayers.push(otherPlayer);
            alliesPlayers.push(otherPlayer);
         }
         return resultObj;
      }
      
      override public function active() : void
      {
         super.active();
         bind(DataCommonID.HUD_SCORE_BOARD,this.bindScoreboard);
         bind(DataCommonID.OBJECTIVES,this.myIntelItemsList.bindObjectives);
         if(false == this.mAnimationHasPlayed && false == this.mSkipAnimation)
         {
            this.startAnimation();
         }
         if(true == this.mSkipAnimation)
         {
            this.skipTeamPanelAnimation();
         }
      }
      
      override public function deactive() : void
      {
         super.deactive();
         unbind(DataCommonID.HUD_SCORE_BOARD,this.bindScoreboard);
         unbind(DataCommonID.OBJECTIVES,this.myIntelItemsList.bindObjectives);
         this.mAnimationHasPlayed = false;
      }
      
      public function SetWidth(w:Number) : void
      {
         this.myTeamPanelOne.SetWidth(w);
         this.myTeamPanelTwo.SetWidth(w);
         this.myIntelItemsList.x = this.myTeamPanelOne.x + w * 0.5 - INTEL_LIST_WIDTH * 0.5;
      }
      
      public function SetScoreboardMode(mode:String) : void
      {
         if(this.mScoreboardMode != mode)
         {
            this.mScoreboardMode = mode;
            this.mScoreboardModeChanged = true;
         }
      }
      
      public function SetShowWinner(show:Boolean) : void
      {
         this.mShowWinner = show;
      }
      
      public function SetShowTeamColor(show:Boolean) : void
      {
         this.mShowTeamColor = show;
      }
      
      public function SetDataRowLinkage(rowLinkage:String) : void
      {
         this.myTeamPanelOne.SetDataRowLinkage(rowLinkage);
         this.myTeamPanelTwo.SetDataRowLinkage(rowLinkage);
      }
      
      public function bindScoreboard(result:ResultObj) : void
      {
         var alliesAreFriendly:Boolean = false;
         var resultallies:int = 0;
         var resultaxis:int = 0;
         var scoreboardObj:ScoreboardObj = new ScoreboardObj(result.data);
         if(this.mGameMode != scoreboardObj.gametype || this.mScoreboardModeChanged)
         {
            this.mGameMode = scoreboardObj.gametype;
            this.mOrderedHeaders = this.mScoreboardMode == ScoreboardColumnData.IN_GAME ? ScoreboardColumnData.getInGameHeaders(this.mGameMode) : ScoreboardColumnData.getPostGameHeaders(this.mGameMode);
            this.mOrderedKeys = this.mScoreboardMode == ScoreboardColumnData.IN_GAME ? ScoreboardColumnData.getInGameDataKeys(this.mGameMode) : ScoreboardColumnData.getPostGameDataKeys(this.mGameMode);
            this.mOrderedColumnWidths = this.mScoreboardMode == ScoreboardColumnData.IN_GAME ? ScoreboardColumnData.getInGameWidths(this.mGameMode) : ScoreboardColumnData.getPostGameWidths(this.mGameMode);
            this.myTeamPanelOne.SetColumnWidths(this.mOrderedColumnWidths);
            this.myTeamPanelTwo.SetColumnWidths(this.mOrderedColumnWidths);
            this.mScoreboardModeChanged = false;
         }
         var singleDisplay:Boolean = this.mGameMode == GAMEMODE_DM;
         var alliesData:Array = translatePlayerData(scoreboardObj.alliesPlayers);
         var axisData:Array = translatePlayerData(scoreboardObj.axisPlayers);
         if(singleDisplay || scoreboardObj.alliesPlayers.length == 0 || scoreboardObj.axisPlayers.length == 0)
         {
            this.myTeamPanelTwo.visible = false;
            this.myTeamPanelOne.SetHeaders(this.mOrderedHeaders);
            this.myTeamPanelOne.SetTeam(NO_TEAM);
            if(this.mGameMode == GAMEMODE_CYBORG)
            {
               this.myIntelItemsList.SetTitle(DictMatchResults.INTEL_GATHERING);
               this.myTeamPanelOne.SetAlternateText(DictMatchResults.MISSION_IN_PROGRESS);
               this.myIntelItemsList.visible = true;
            }
            if(scoreboardObj.axisPlayers.length != 0)
            {
               this.myTeamPanelOne.SetPlayerData(axisData,this.mOrderedKeys,this.mOrderedColumnWidths);
               this.myTeamPanelOne.SetScore(scoreboardObj.axisScore);
            }
            else if(scoreboardObj.alliesPlayers.length != 0)
            {
               this.myTeamPanelOne.SetPlayerData(alliesData,this.mOrderedKeys,this.mOrderedColumnWidths);
               this.myTeamPanelOne.SetScore(scoreboardObj.alliesScore);
            }
         }
         else
         {
            alliesAreFriendly = scoreboardObj.myTeam != LobbyConstants.TEAM_SCAR;
            if(!AsymPvpUtil.instance.isAsymGameMode(this.mGameMode))
            {
               this.myTeamPanelOne.SetTeam(alliesAreFriendly ? TF141 : SCAR);
               this.myTeamPanelTwo.SetTeam(alliesAreFriendly ? SCAR : TF141);
            }
            else if(AsymPvpUtil.instance.isInfectedGameMode(this.mGameMode) || Boolean(CFunctionCommonContainer.Dvar_GetBool("ui_asym_robot_axis")))
            {
               this.myTeamPanelOne.SetTeam(alliesAreFriendly ? HUMANS : INFECTED);
               this.myTeamPanelTwo.SetTeam(alliesAreFriendly ? INFECTED : HUMANS);
            }
            else
            {
               this.myTeamPanelOne.SetTeam(alliesAreFriendly ? INFECTED : HUMANS);
               this.myTeamPanelTwo.SetTeam(alliesAreFriendly ? HUMANS : INFECTED);
            }
            if(false == this.mShowTeamColor)
            {
               this.myTeamPanelOne.HideTeamColor();
               this.myTeamPanelTwo.HideTeamColor();
            }
            if(true == this.mShowWinner)
            {
               if(scoreboardObj.alliesScore > scoreboardObj.axisScore)
               {
                  resultallies = 1;
                  resultaxis = 2;
               }
               else if(scoreboardObj.alliesScore == scoreboardObj.axisScore)
               {
                  resultallies = 3;
                  resultaxis = 3;
               }
               else
               {
                  resultallies = 2;
                  resultaxis = 1;
               }
               this.myTeamPanelOne.SetWinner(alliesAreFriendly ? resultallies : resultaxis);
               this.myTeamPanelTwo.SetWinner(alliesAreFriendly ? resultaxis : resultallies);
            }
            this.myTeamPanelOne.gameMode = this.mGameMode;
            this.myTeamPanelOne.SetHeaders(this.mOrderedHeaders);
            this.myTeamPanelOne.SetPlayerData(alliesAreFriendly ? alliesData : axisData,this.mOrderedKeys,this.mOrderedColumnWidths);
            this.myTeamPanelOne.SetScore(alliesAreFriendly ? scoreboardObj.alliesScore : scoreboardObj.axisScore);
            this.myTeamPanelTwo.visible = true;
            this.myTeamPanelTwo.gameMode = this.mGameMode;
            this.myTeamPanelTwo.SetHeaders(this.mOrderedHeaders);
            this.myTeamPanelTwo.SetPlayerData(alliesAreFriendly ? axisData : alliesData,this.mOrderedKeys,this.mOrderedColumnWidths);
            this.myTeamPanelTwo.SetScore(alliesAreFriendly ? scoreboardObj.axisScore : scoreboardObj.alliesScore);
            this.myTeamPanelTwo.y = this.myTeamPanelOne.y + this.myTeamPanelOne.myInGameBackground.height + PANEL_PADDING;
         }
         if(AsymPvpUtil.instance.isInfectedGameMode(this.mGameMode))
         {
            this.myTeamPanelOne.SetScore(scoreboardObj.humanRemain);
            this.myTeamPanelTwo.SetScore(scoreboardObj.robotRemain);
         }
      }
      
      public function startAnimation() : void
      {
         TweenLite.from(this,SLIDE_IN_DURATION,{
            "alpha":0,
            "x":SLIDE_IN_START_X,
            "onComplete":this.startTeamPanelAnimation,
            "ease":Linear.easeInOut,
            "delay":START_ANIM_DELAY
         });
         this.mAnimationHasPlayed = true;
      }
      
      private function startTeamPanelAnimation() : void
      {
         this.myTeamPanelOne.startAnimation();
         this.myTeamPanelTwo.startAnimation();
      }
      
      private function skipTeamPanelAnimation() : void
      {
         this.myTeamPanelOne.skipAnimation();
         this.myTeamPanelTwo.skipAnimation();
      }
      
      public function skipAnimation(skip:Boolean) : void
      {
         this.mSkipAnimation = skip;
      }
      
      public function getHeight() : Number
      {
         return this.myTeamPanelTwo.visible == false ? this.myTeamPanelOne.myInGameBackground.height : this.myTeamPanelOne.myInGameBackground.height + this.myTeamPanelTwo.myInGameBackground.height + PANEL_PADDING;
      }
   }
}

