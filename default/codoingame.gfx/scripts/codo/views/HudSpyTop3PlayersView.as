package codo.views
{
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionInGameContainer;
   import codo.constants.BCInGameEvent;
   import codo.constants.DataCommonID;
   import codo.constants.GameInfo;
   import codo.constants.SpyModeRoleType;
   import codo.constants.SpyRoundType;
   import codo.event.ParaEvent;
   import codo.localization.DictHud;
   import codo.localization.DictMatchResults;
   import codo.objects.ResultObj;
   import codo.objects.SpyUserObj;
   import codo.style.GlobalGuide;
   import codo.style.SpyHudGuide;
   import codo.utils.LocalizeUtil;
   import codo.utils.ScaleformUtil;
   import codo.utils.SpyUtil;
   import codo.views.hudSpy.KillMap;
   import codo.views.hudSpy.SpyTop3PlayerCard;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.KeyboardEvent;
   import flash.filters.BlurFilter;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   public class HudSpyTop3PlayersView extends BaseTop3PlayersView
   {
      
      private static const MARGIN_RIGHT:int = 50;
      
      public var myPlayerCardFirst:SpyTop3PlayerCard;
      
      public var myPlayerCardSecond:SpyTop3PlayerCard;
      
      public var myPlayerCardThird:SpyTop3PlayerCard;
      
      public var myMatchResult:TextField;
      
      public var myScoreLabel:TextField;
      
      public var myKills:TextField;
      
      public var myDamage:TextField;
      
      public var myBodyConfirm:TextField;
      
      public var myScore:TextField;
      
      public var myFooterBG:MovieClip;
      
      public var myRoleIcon:MovieClip;
      
      public var myFooter:MovieClip;
      
      public var myHeader:MovieClip;
      
      public var myHint:TextField;
      
      public var myKillmap:KillMap;
      
      public var myKarma:TextField;
      
      public var myKarmaDesc:TextField;
      
      public var myWinner:TextField;
      
      public var myWinnerIcon:MovieClip;
      
      public var myRoundsLeft:TextField;
      
      public var myRoundsLeftLabel:TextField;
      
      private var mPlayerCards:Vector.<SpyTop3PlayerCard>;
      
      public function HudSpyTop3PlayersView()
      {
         var meleeKey:String = null;
         super();
         this.myPlayerCardFirst.visible = this.myPlayerCardSecond.visible = this.myPlayerCardThird.visible = false;
         var isSpectator:Boolean = CFunctionInGameContainer.IsSpectator() as Boolean;
         this.myFooter.visible = !isSpectator;
         this.myRoleIcon = this.myFooter["myRoleIcon"];
         this.myScoreLabel = this.myFooter["myScoreLabel"];
         this.myBodyConfirm = this.myFooter["myBodyConfirm"];
         this.myScore = this.myFooter["myScore"];
         this.myKills = this.myFooter["myKills"];
         this.myDamage = this.myFooter["myDamage"];
         this.myHint = this.myHeader["myHint"];
         this.myKarma = this.myFooter["myKarma"];
         this.myKarmaDesc = this.myFooter["myKarmaDesc"];
         this.mPlayerCards = new <SpyTop3PlayerCard>[this.myPlayerCardFirst,this.myPlayerCardSecond,this.myPlayerCardThird];
         if(ScaleformUtil.isScaleform)
         {
            this.myKillmap.visible = false;
            meleeKey = LocalizeUtil.localizeFirstKeyBindingForCommand("+melee");
            LocalizeUtil.paramTextFieldInput(this.myHint,DictHud.SPY_SHOW_GAME_PROGRESS,[meleeKey],[SpyHudGuide.HINT_COLOR_DARK_YELLOW]);
         }
         this.myScoreLabel.text = LocalizeUtil.localize(DictMatchResults.YOUR_SCORE);
         this.myRoundsLeft.text = "";
         this.myRoundsLeftLabel.autoSize = TextFieldAutoSize.LEFT;
         this.myRoundsLeftLabel.text = LocalizeUtil.localize(DictHud.SPY_ROUNDS_LEFT);
         this.myRoundsLeft.visible = this.myRoundsLeftLabel.visible = false;
         this.myRoundsLeftLabel.x = GameInfo.stagePosition.x + GameInfo.stageSize.x - this.myRoundsLeftLabel.textWidth - MARGIN_RIGHT;
         this.myRoundsLeft.x = this.myRoundsLeftLabel.x - 2 - this.myRoundsLeft.width;
      }
      
      override protected function enableData() : void
      {
         super.enableData();
         this.myKillmap.visible = false;
         CFunctionInGameContainer.BindUIKeyCatcher(true);
         stage.addEventListener(KeyboardEvent.KEY_DOWN,this.keyboardEventHandler);
      }
      
      override protected function disableData() : void
      {
         super.disableData();
         CFunctionInGameContainer.BindUIKeyCatcher(false);
         stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.keyboardEventHandler);
      }
      
      private function keyboardEventHandler(cEvt:KeyboardEvent) : void
      {
         if(CFunctionCommonContainer.GetKeyBindingValuesFromCommand("+melee").indexOf(cEvt.charCode) != -1)
         {
            this.toggleKillmap();
         }
      }
      
      private function bind_hudScoreboard(cResult:ResultObj) : void
      {
         unbind(DataCommonID.HUD_SCORE_BOARD,this.bind_hudScoreboard);
      }
      
      override protected function showView() : void
      {
         var card:SpyTop3PlayerCard = null;
         var i:int = 0;
         var player:Object = null;
         var user:SpyUserObj = null;
         var winRole:int = 0;
         var karmaDelta:int = 0;
         super.showView();
         listen(BCInGameEvent.EVT_BLUR,this.onBlurAllUI);
         var roundType:int = CFunctionInGameContainer.AS_SpyMode_GetRoundType();
         var isCasualRound:Boolean = roundType != SpyRoundType.ROUND_NORMAL;
         var players:Array = CFunctionInGameContainer.GetSpyTop3Players();
         var lenPlayers:uint = players.length;
         if(players != null)
         {
            for(i = 0; i < lenPlayers; i++)
            {
               player = players[i];
               user = new SpyUserObj();
               card = this.mPlayerCards[i];
               user.name = player.name;
               user.clanName = player.clanName;
               user.level = player.level;
               user.prestige = player.prestige;
               user.clanName = player.clanName;
               user.callSignObj.cardTitle = player.cardTitle;
               user.callSignObj.cardIconURL = player.cardIconURL;
               user.callSignObj.cardBackgroundURL = player.cardBackgroundURL;
               user.callSignObj.cardNameplateColor = player.cardNameplateColor;
               user.callSignObj.cardFrameURL = player.cardFrameURL;
               user.kills = player.kills;
               user.damage = player.damage;
               user.confirmCorpse = player.confirmCorpse;
               user.nickname = player.nickname;
               user.role = player.role;
               user.score = player.score;
               user.kills2 = player.kills2;
               if(Boolean(player.isSelf))
               {
                  myEmoteSettings.visible = true;
               }
               if(player.name == "")
               {
                  card.visible = false;
               }
               else
               {
                  card.visible = true;
                  card.setData(user,isCasualRound);
               }
            }
         }
         var roundState:Object = CFunctionInGameContainer.AS_SpyGetMyRoundState();
         if(isCasualRound)
         {
            this.myWinner.text = LocalizeUtil.localize(DictMatchResults.MATCH_WON);
            this.myWinner.textColor = GlobalGuide.WHITE;
            this.myWinnerIcon.gotoAndStop(3 + roundType);
         }
         else
         {
            winRole = int(roundState.winner);
            this.myWinner.text = LocalizeUtil.param(DictHud.SPY_ROUND_WINNER,[LocalizeUtil.localize(SpyUtil.getLocalizedRoleName(winRole))]);
            this.myWinner.textColor = SpyUtil.getRoleColor(winRole);
            this.myWinnerIcon.gotoAndStop(winRole);
         }
         this.myFooter.visible = !roundState.isSpectator;
         if(!roundState.isSpectator)
         {
            this.myScore.text = roundState.score.toString();
            this.myDamage.text = LocalizeUtil.param(DictMatchResults.MATCH_DAMAGE_MADE,[roundState.damage.toString()]);
            this.myBodyConfirm.visible = this.myKarma.visible = this.myKarmaDesc.visible = !isCasualRound;
            if(isCasualRound)
            {
               this.myKills.text = LocalizeUtil.param(DictHud.SPY_MATCH_KILL_ENEMY_COUNT,[roundState.kills.toString()]);
            }
            else
            {
               if(roundState.role == SpyModeRoleType.SPY_ROLE_SPY)
               {
                  this.myKills.text = LocalizeUtil.param(DictMatchResults.MATCH_ENEMY_KILL_CIVILIAN,[roundState.kills.toString()]);
                  this.myBodyConfirm.text = LocalizeUtil.param(DictMatchResults.MATCH_ENEMY_KILL_INVESTIGATOR,[roundState.kills2.toString()]);
               }
               else
               {
                  this.myKills.text = LocalizeUtil.param(DictMatchResults.MATCH_ENEMY_KILL_SPY,[roundState.kills.toString()]);
                  this.myBodyConfirm.text = LocalizeUtil.param(DictMatchResults.MATCH_CONFIRM_CORPSE,[roundState.confirmCorpse.toString()]);
               }
               karmaDelta = roundState.karmaDelta / 10;
               if(karmaDelta < 0)
               {
                  this.myKarma.text = LocalizeUtil.param(DictMatchResults.MATCH_KARMA_DECREASE,[Math.abs(karmaDelta).toString() + "%"]);
                  if(CFunctionCommonContainer.Dvar_GetInt("spy_inactive_karma_punishment") == 0)
                  {
                     this.myKarmaDesc.text = LocalizeUtil.localize(DictMatchResults.MATCH_KARMA_NEGATIVE_HINT);
                  }
                  else
                  {
                     this.myKarmaDesc.text = LocalizeUtil.localize(DictMatchResults.MATCH_KARMA_INACTIVE_HINT);
                  }
               }
               else
               {
                  this.myKarma.text = LocalizeUtil.param(DictMatchResults.MATCH_KARMA_INCREASE,[Math.abs(karmaDelta).toString() + "%"]);
                  this.myKarmaDesc.text = LocalizeUtil.localize(DictMatchResults.MATCH_KARMA_POSITIVE_HINT);
               }
            }
         }
         var roundsLeft:int = CFunctionInGameContainer.AS_SpyGetRoundsLeft();
         if(roundsLeft > 0)
         {
            this.myRoundsLeft.text = roundsLeft.toString();
            this.myRoundsLeftLabel.visible = this.myRoundsLeft.visible = true;
         }
         else
         {
            this.myRoundsLeftLabel.visible = this.myRoundsLeft.visible = false;
         }
      }
      
      override protected function hideView() : void
      {
         super.hideView();
         this.blurAllUI(0);
         unlisten(BCInGameEvent.EVT_BLUR,this.onBlurAllUI);
      }
      
      private function onBlurAllUI(cEvt:ParaEvent) : void
      {
         var blur:Number = cEvt.myPara as Number;
         this.blurAllUI(blur);
      }
      
      private function blurAllUI(blur:Number) : void
      {
         var child:DisplayObject = null;
         var filter:BlurFilter = null;
         CFunctionCommonContainer.SetUIBlur(blur);
         for(var i:int = 0; i < numChildren; i++)
         {
            child = getChildAt(i);
            if(child != this.myKillmap)
            {
               if(blur != 0)
               {
                  filter = new BlurFilter(4,4,1);
                  child.filters = [filter];
               }
               else
               {
                  child.filters = [];
               }
            }
         }
      }
      
      private function toggleKillmap() : void
      {
         this.myKillmap.toggle();
      }
   }
}

