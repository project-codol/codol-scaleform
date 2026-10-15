package codo.views.hudDMZ
{
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionInGameContainer;
   import codo.constants.DataCommonID;
   import codo.constants.GameInfo;
   import codo.localization.DictDmz;
   import codo.objects.ResultObj;
   import codo.objects.ScoreboardObj;
   import codo.objects.UserObj;
   import codo.utils.LocalizeUtil;
   import codo.utils.Logger;
   import codo.views.BaseTop3PlayersView;
   import com.greensock.TweenLite;
   import com.greensock.easing.Cubic;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.utils.setTimeout;
   import fsg.util.FsgAudioUtil;
   
   public class DMZTop3PlayerView extends BaseTop3PlayersView
   {
      
      private static const MAX_NUM_PLAYERS:Number = 2;
      
      private static const ANIM_DURATION:Number = 0.8;
      
      private static const ANIM_DISTANCE:Number = 25;
      
      private static const ANIM_DELAY:Number = 2.1;
      
      private static const CARD_1_AUDIO_CUE:Number = 1920;
      
      private static const CARD_2_AUDIO_CUE:Number = 2040;
      
      private static const CARD_3_AUDIO_CUE:Number = 2220;
      
      private static const RESULT_PANEL_AUDIO_CUE:Number = 2300;
      
      public var myTop1:DMZTop3PlayerCard;
      
      public var myTop2:DMZTop3PlayerCard;
      
      public var myRank:TextField;
      
      public var myEmoteSettingsBg:MovieClip;
      
      private var mPlayerCards:Array;
      
      private var mAudioPlayed:Boolean = false;
      
      public function DMZTop3PlayerView()
      {
         super();
         this.myTop1.visible = false;
         this.myTop2.visible = false;
         this.mPlayerCards = [this.myTop1,this.myTop2];
         this.myRank.text = LocalizeUtil.param(DictDmz.PLAYER_RANK,["1"]);
         var format:TextFormat = this.myRank.getTextFormat();
         format.font = GameInfo.GAME_FONT_AENCY_FB_BOLD;
         format.size = 120;
         format.bold = true;
         var numberIndex:int = this.myRank.text.indexOf("1");
         this.myRank.setTextFormat(format,numberIndex,numberIndex + 1);
         this.myEmoteSettingsBg.visible = false;
      }
      
      override protected function enableData() : void
      {
         bind(DataCommonID.HUD_SCORE_BOARD,this.bind_hudScoreboard);
      }
      
      override protected function disableData() : void
      {
         unbind(DataCommonID.HUD_SCORE_BOARD,this.bind_hudScoreboard);
      }
      
      override protected function showView() : void
      {
         super.showView();
         this.myEmoteSettingsBg.x = GameInfo.stagePosition.x + GameInfo.stageSize.x - this.myEmoteSettingsBg.width + 1;
         this.myEmoteSettingsBg.y = GameInfo.stagePosition.y + 100;
         myEmoteSettings.x = this.myEmoteSettingsBg.x + 61;
         myEmoteSettings.y = this.myEmoteSettingsBg.y + 3;
      }
      
      private function bind_hudScoreboard(cResult:ResultObj) : void
      {
         var i:int = 0;
         var card:DMZTop3PlayerCard = null;
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
         var scoreboardObj:ScoreboardObj = new ScoreboardObj(cResult.data);
         var playerList:Array = scoreboardObj.alliesPlayers.concat(scoreboardObj.axisPlayers);
         playerList.sortOn("rank",Array.NUMERIC);
         var numPlayers:int = int(playerList.length);
         var players:Array = CFunctionInGameContainer.GetTop3Players();
         var lenPlayers:int = 0;
         for(i = 0; i < players.length; i++)
         {
            if(players[i].name != "")
            {
               lenPlayers++;
            }
         }
         if(players != null && 0 < playerList.length)
         {
            gotoAndStop(lenPlayers == 2 ? 2 : 1);
            for(i = 0; i < lenPlayers; i++)
            {
               card = this.mPlayerCards[i];
               player = players[i];
               user = new UserObj();
               if(Boolean(player.isSelf))
               {
                  myEmoteSettings.visible = true;
                  this.myEmoteSettingsBg.visible = true;
               }
               user.name = player.name;
               user.clanName = player.clanName;
               user.level = player.level;
               user.prestige = player.prestige;
               user.clanName = player.clanName;
               user["score"] = player.score.score;
               user["kills"] = player.score.kills;
               user["damage"] = player.score.damage;
               user.callSignObj.cardTitle = player.cardTitle;
               user.callSignObj.cardIconURL = player.cardIconURL;
               user.callSignObj.cardBackgroundURL = player.cardBackgroundURL;
               user.callSignObj.cardNameplateColor = player.cardNameplateColor;
               user.callSignObj.cardFrameURL = player.cardFrameURL;
               if(null == user["score"] || undefined == user["score"] || player.name == "")
               {
                  Logger.print("[DMZ TOP3]playercard due to user score doesn\'t exist:",user.name);
                  card.visible = false;
               }
               else
               {
                  Logger.print("[DMZ TOP3]playercard show for player:",user.name," index:",i," damage:",user["damage"]," kills:",user["kills"]," score:",user["score"]);
                  card.visible = true;
                  card.setData(user);
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
   }
}

