package codo.views.hudSpy
{
   import codo.common.CFunctionCommonContainer;
   import codo.component.PlayerCard;
   import codo.constants.SpyModeRoleType;
   import codo.localization.DictHud;
   import codo.localization.DictMatchResults;
   import codo.objects.SpyUserObj;
   import codo.utils.LocalizeUtil;
   import codo.utils.SpyUtil;
   import codo.utils.StringUtil;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import fsg.util.FsgUtil;
   
   public class SpyTop3PlayerCard extends MovieClip
   {
      
      public var myPlayerCard:PlayerCard;
      
      public var myNickname:PlayerNickname;
      
      public var myKills:TextField;
      
      public var myDamage:TextField;
      
      public var myBodyConfirm:TextField;
      
      public var myScore:TextField;
      
      public var myScoreLabel:TextField;
      
      public var myRoleName:TextField;
      
      public var myRoleIcon:MovieClip;
      
      public function SpyTop3PlayerCard()
      {
         super();
         this.myScoreLabel.text = LocalizeUtil.localize(DictMatchResults.MATCH_SCORE).toUpperCase();
      }
      
      public function setData(data:SpyUserObj, isCasualRound:Boolean) : void
      {
         this.truncateName(data.name);
         this.myPlayerCard.setClanName(data.clanName);
         var prestigeLvl:uint = uint(data.prestige);
         this.myPlayerCard.setPrestige(prestigeLvl == 0 ? "" : prestigeLvl.toString());
         this.myScore.text = data.score.toString();
         this.myPlayerCard.setRank(CFunctionCommonContainer.GetDisplayLevel(data.level));
         this.myPlayerCard.setTitle(LocalizeUtil.localize("@" + data.callSignObj.cardTitle));
         this.myPlayerCard.setEmblem(data.callSignObj.cardIconURL);
         this.myPlayerCard.setBackground(data.callSignObj.cardBackgroundURL);
         this.myPlayerCard.setNameplate(data.callSignObj.cardNameplateColor);
         if(data.prestige > 0)
         {
            this.myPlayerCard.setPrestigeIcon(FsgUtil.getPrestigeIcon(data.prestige));
         }
         else
         {
            this.myPlayerCard.setPrestigeIcon("");
         }
         this.myRoleIcon.gotoAndStop(data.role);
         this.myRoleName.text = SpyUtil.getLocalizedRoleName(data.role);
         this.myRoleName.textColor = SpyUtil.getRoleColor(data.role);
         this.myNickname.nickname = data.nickname;
         this.myDamage.text = LocalizeUtil.param(DictMatchResults.MATCH_DAMAGE_MADE,[data.damage.toString()]);
         if(isCasualRound)
         {
            this.myKills.text = LocalizeUtil.param(DictHud.SPY_MATCH_KILL_ENEMY_COUNT,[data.kills.toString()]);
            this.myBodyConfirm.visible = false;
         }
         else
         {
            this.myBodyConfirm.visible = true;
            if(data.role == SpyModeRoleType.SPY_ROLE_SPY)
            {
               this.myKills.text = LocalizeUtil.param(DictMatchResults.MATCH_ENEMY_KILL_CIVILIAN,[data.kills.toString()]);
               this.myBodyConfirm.text = LocalizeUtil.param(DictMatchResults.MATCH_ENEMY_KILL_INVESTIGATOR,[data.kills2.toString()]);
            }
            else
            {
               this.myKills.text = LocalizeUtil.param(DictMatchResults.MATCH_ENEMY_KILL_SPY,[data.kills.toString()]);
               this.myBodyConfirm.text = LocalizeUtil.param(DictMatchResults.MATCH_CONFIRM_CORPSE,[data.confirmCorpse.toString()]);
            }
         }
      }
      
      private function truncateName(txt:String) : void
      {
         this.myPlayerCard.setName(txt);
         StringUtil.fitTextField(this.myPlayerCard.myName);
      }
   }
}

