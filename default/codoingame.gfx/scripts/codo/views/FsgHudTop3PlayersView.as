package codo.views
{
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionInGameContainer;
   import codo.constants.DataCommonID;
   import codo.constants.GameInfo;
   import codo.localization.DictMatchResults;
   import codo.objects.ResultObj;
   import codo.objects.ScoreboardObj;
   import codo.objects.UserObj;
   import codo.utils.LocalizeUtil;
   import codo.utils.ScaleformUtil;
   import codo.views.fsgHudTop3PlayerView_parts.FsgHudTop3PlayersViewMatchDetail;
   import codo.views.fsgHudTop3PlayerView_parts.FsgHudTop3PlayersViewRankIcon;
   import com.greensock.TweenLite;
   import com.greensock.easing.Cubic;
   import components.fsghudtop3_part.FsgTop3PlayerCard;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.utils.setTimeout;
   import fsg.util.FsgAudioUtil;
   
   public class FsgHudTop3PlayersView extends BaseTop3PlayersView
   {
      
      private static const FOOTER_LABEL_PADDING:Number = 10;
      
      private static const MAX_NUM_PLAYERS:Number = 4;
      
      private static const ANIM_DURATION:Number = 0.8;
      
      private static const ANIM_DISTANCE:Number = 25;
      
      private static const ANIM_DELAY:Number = 2.1;
      
      private static const CARD_1_AUDIO_CUE:Number = 1920;
      
      private static const CARD_2_AUDIO_CUE:Number = 2040;
      
      private static const CARD_3_AUDIO_CUE:Number = 2220;
      
      private static const RESULT_PANEL_AUDIO_CUE:Number = 2300;
      
      public var myPlayerCardFirst:FsgTop3PlayerCard;
      
      public var myPlayerCardSecond:FsgTop3PlayerCard;
      
      public var myPlayerCardThird:FsgTop3PlayerCard;
      
      public var myPlayerCardFourth:FsgTop3PlayerCard;
      
      public var myHeaderTitle:TextField;
      
      public var myScoreTitle:TextField;
      
      public var myRankIcon:FsgHudTop3PlayersViewRankIcon;
      
      public var myScore:TextField;
      
      public var myHeaderBg:MovieClip;
      
      public var myMatchDetail:FsgHudTop3PlayersViewMatchDetail;
      
      private var mPlayerCards:Vector.<FsgTop3PlayerCard>;
      
      private var mAudioPlayed:Boolean = false;
      
      public function FsgHudTop3PlayersView()
      {
         super();
         this.mPlayerCards = new <FsgTop3PlayerCard>[this.myPlayerCardFirst,this.myPlayerCardSecond,this.myPlayerCardThird,this.myPlayerCardFourth];
         this.myHeaderTitle.text = LocalizeUtil.localize(DictMatchResults.MATCH_COMPLETE).toUpperCase();
         this.myScoreTitle.text = LocalizeUtil.localize(DictMatchResults.YOUR_SCORE).toUpperCase();
         this.myPlayerCardFirst.visible = false;
         this.myPlayerCardSecond.visible = false;
         this.myPlayerCardThird.visible = false;
         this.myPlayerCardFourth.visible = false;
         if(false == ScaleformUtil.isScaleform)
         {
            this.bind_hudScoreboard(this.generateFakeData());
         }
         var isSpectator:Boolean = CFunctionInGameContainer.IsSpectator() as Boolean;
         this.hideHeader(isSpectator);
      }
      
      private function hideHeader(hide:Boolean) : void
      {
         this.myHeaderBg.visible = this.myHeaderTitle.visible = this.myScoreTitle.visible = this.myRankIcon.visible = this.myScore.visible = this.myMatchDetail.visible = !hide;
      }
      
      override protected function enableData() : void
      {
         bind(DataCommonID.HUD_SCORE_BOARD,this.bind_hudScoreboard);
      }
      
      override protected function disableData() : void
      {
         unbind(DataCommonID.HUD_SCORE_BOARD,this.bind_hudScoreboard);
      }
      
      private function bind_hudScoreboard(cResult:ResultObj) : void
      {
         var scoreboardObj:ScoreboardObj = null;
         var i:int = 0;
         var card:FsgTop3PlayerCard = null;
         var row:Object = null;
         var player:Object = null;
         var user:UserObj = null;
         var cardDelay:Number = NaN;
         var cardTargetY:Number = NaN;
         var timeout:Number = NaN;
         unbind(DataCommonID.HUD_SCORE_BOARD,this.bind_hudScoreboard);
         if(Boolean(CFunctionCommonContainer.IsDevelopmentBuild()) && CFunctionCommonContainer.Dvar_GetBool("ui_disable_top3") == 1)
         {
            return;
         }
         scoreboardObj = new ScoreboardObj(cResult.data);
         var playerList:Array = scoreboardObj.alliesPlayers.concat(scoreboardObj.axisPlayers);
         playerList.sortOn("rank",Array.NUMERIC);
         this.myScoreTitle.x = GameInfo.stagePosition.x + 48;
         this.myRankIcon.x = GameInfo.stagePosition.x + 65;
         this.myScore.x = this.myRankIcon.x + 26;
         this.myMatchDetail.x = this.myScore.x + 100;
         var showMyScore:Boolean = scoreboardObj.gametype != "td";
         if(showMyScore)
         {
            for each(row in playerList)
            {
               if(Boolean(row.isSelf))
               {
                  this.myScore.text = row.score.toString();
                  this.myRankIcon.rank = row.rank;
                  this.myMatchDetail.setData(row,scoreboardObj.gametype);
                  break;
               }
            }
         }
         this.myScoreTitle.visible = this.myScore.visible = this.myRankIcon.visible = this.myMatchDetail.visible = showMyScore;
         myEmoteSettings.x = GameInfo.stagePosition.x + GameInfo.stageSize.x - myEmoteSettings.width - 80;
         var players:Array = this.getTop3PlayersData();
         var lenPlayers:uint = players.length;
         if(players != null)
         {
            gotoAndStop(lenPlayers == 4 ? 2 : 1);
            for(i = 0; i < lenPlayers; i++)
            {
               player = players[i];
               if(Boolean(player.isSelf) && this.myHeaderBg.visible)
               {
                  myEmoteSettings.visible = true;
               }
               user = new UserObj();
               card = this.mPlayerCards[i];
               user.name = player.name;
               user.clanName = player.clanName;
               user.level = player.level;
               user.prestige = player.prestige;
               user.clanName = player.clanName;
               user["score"] = player.score;
               user["rewards"] = player.rewards;
               user["score"].rank = i + 1;
               user["score"].weaponHudIcon = CFunctionInGameContainer.AS_GetTop3PlayerCurrentWeaponHudIcon(i);
               user.callSignObj.cardTitle = player.cardTitle;
               user.callSignObj.cardIconURL = player.cardIconURL;
               user.callSignObj.cardBackgroundURL = player.cardBackgroundURL;
               user.callSignObj.cardNameplateColor = player.cardNameplateColor;
               user.callSignObj.cardFrameURL = player.cardFrameURL;
               if(user.name == "")
               {
                  card.visible = false;
               }
               else
               {
                  card.visible = true;
                  card.setData(user,scoreboardObj.gametype);
                  card.alpha = 0;
                  cardDelay = ANIM_DURATION / 4 * i + ANIM_DELAY;
                  cardTargetY = card.y;
                  card.y += ANIM_DISTANCE;
                  TweenLite.to(card,ANIM_DURATION,{
                     "alpha":1,
                     "ease":Cubic.easeOut,
                     "delay":cardDelay
                  });
                  TweenLite.to(card,ANIM_DURATION,{
                     "y":cardTargetY,
                     "ease":Cubic.easeOut,
                     "delay":cardDelay
                  });
                  switch(i)
                  {
                     case 0:
                        timeout = CARD_1_AUDIO_CUE;
                        break;
                     case 1:
                        timeout = CARD_2_AUDIO_CUE;
                        break;
                     case 2:
                        timeout = CARD_3_AUDIO_CUE;
                  }
                  if(false == this.mAudioPlayed)
                  {
                     setTimeout(this.startPlayerCardAudio,timeout);
                  }
                  if(false == this.mAudioPlayed)
                  {
                     setTimeout(this.startResultPanelAudio,RESULT_PANEL_AUDIO_CUE);
                  }
                  this.mAudioPlayed = true;
               }
            }
         }
      }
      
      private function startPlayerCardAudio() : void
      {
         FsgAudioUtil.getInstance().playSound("ui_top3_walkout_players");
      }
      
      private function startResultPanelAudio() : void
      {
         FsgAudioUtil.getInstance().playSound("ui_top3_walkout_match_score");
      }
      
      private function getTop3PlayersData() : Array
      {
         var data:Array = null;
         if(true == ScaleformUtil.isScaleform)
         {
            data = CFunctionInGameContainer.GetTop3Players();
         }
         else
         {
            data = this.generateFakeTop3Data();
         }
         return data;
      }
      
      private function generateFakeTop3Data() : Array
      {
         var returnArray:Array = new Array();
         returnArray.push({
            "name":"WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW",
            "level":2,
            "prestige":0,
            "wargodScore":0,
            "cardTitle":"CALL SIGN TEXT",
            "cardIconURL":"http://www.activision.com/content/dam/atvi/activision/atviLogo.png",
            "cardBackgroundURL":"http://www.activision.com/content/dam/atvi/activision/atviLogo.png"
         });
         returnArray.push({
            "name":"WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW",
            "level":2,
            "prestige":0,
            "wargodScore":0,
            "cardTitle":"CALL SIGN TEXT",
            "cardIconURL":"http://www.activision.com/content/dam/atvi/activision/atviLogo.png",
            "cardBackgroundURL":"http://www.activision.com/content/dam/atvi/activision/atviLogo.png"
         });
         returnArray.push({
            "name":"WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW",
            "level":2,
            "prestige":0,
            "wargodScore":0,
            "cardTitle":"CALL SIGN TEXT",
            "cardIconURL":"http://www.activision.com/content/dam/atvi/activision/atviLogo.png",
            "cardBackgroundURL":"http://www.activision.com/content/dam/atvi/activision/atviLogo.png"
         });
         return returnArray;
      }
      
      private function generateFakeData() : ResultObj
      {
         var i:int = 0;
         var resultObj:ResultObj = new ResultObj();
         var fakeData:Object = {};
         var axisPlayers:Array = [];
         var alliesPlayers:Array = [];
         resultObj.data = fakeData;
         fakeData["axisScore"] = 1000;
         fakeData["alliesScore"] = 2000;
         fakeData["axisPlayers"] = axisPlayers;
         fakeData["alliesPlayers"] = alliesPlayers;
         fakeData["gametype"] = "tdm";
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
         var otherPlayer:Object = {};
         var rankCount:int = 1;
         for(i = 1; i < 8; i++)
         {
            rankCount++;
            otherPlayer = new Object();
            otherPlayer.player = "Tinggo";
            otherPlayer.kills = 88;
            otherPlayer.deaths = 1;
            otherPlayer.assists = 10;
            otherPlayer.revives = 20;
            otherPlayer.objectives = 30;
            otherPlayer.rank = rankCount;
            otherPlayer.level = 70;
            otherPlayer.score = 12345;
            otherPlayer.ping = 16;
            otherPlayer.isSelf = false;
            otherPlayer.xpgained = 321;
            otherPlayer.gpgained = 432;
            otherPlayer.isDead = false;
            otherPlayer.clantag = "CLAN";
            axisPlayers.push(otherPlayer);
         }
         for(i = 0; i < 8; i++)
         {
            rankCount++;
            otherPlayer = new Object();
            otherPlayer.player = "Tinggo";
            otherPlayer.kills = 88;
            otherPlayer.deaths = 1;
            otherPlayer.assists = 10;
            otherPlayer.revives = 20;
            otherPlayer.objectives = 30;
            otherPlayer.rank = rankCount;
            otherPlayer.level = 70;
            otherPlayer.score = 12345;
            otherPlayer.ping = 16;
            otherPlayer.isSelf = false;
            otherPlayer.xpgained = 321;
            otherPlayer.gpgained = 432;
            otherPlayer.isDead = false;
            otherPlayer.clantag = "CLAN";
            alliesPlayers.push(otherPlayer);
         }
         return resultObj;
      }
   }
}

