package codo.views.spyMatchResult_parts
{
   import codo.common.CFunctionCommonContainer;
   import codo.component.TextField;
   import codo.component.core.UIInteractiveComponent;
   import codo.component.playerAccount.PlayerAccountInfoPrivileges;
   import codo.constants.SpyModeRoleType;
   import codo.objects.SpyScoreboardItemObj;
   import codo.style.SpyHudGuide;
   import codo.utils.StringUtil;
   import codo.views.hudSpy.PlayerNickname;
   import flash.display.MovieClip;
   import fsg.util.FsgImageHolder;
   import fsg.util.FsgUtil;
   
   public class SpyMatchResultScoreboardItem extends UIInteractiveComponent
   {
      
      public static const CLAN_NAME_TEXT_FIELD_WIDTH:int = 200;
      
      public var myBorder:MovieClip;
      
      public var myInvestigaterHighLight:MovieClip;
      
      public var mySpyHighLight:MovieClip;
      
      public var myStatus:PlayerAccountInfoPrivileges;
      
      public var myKarmaTF:TextField;
      
      public var myDeathTF:TextField;
      
      public var myScoreTF:TextField;
      
      public var myPrestige:FsgImageHolder;
      
      public var myClanNameTF:TextField;
      
      public var myRoleIcon:MovieClip;
      
      public var myNameTF:TextField;
      
      public var myNickname:PlayerNickname;
      
      public function SpyMatchResultScoreboardItem()
      {
         super();
         this.myClanNameTF.textStyle = SpyHudGuide.SpyScoreboardItemCommon;
         this.myScoreTF.textStyle = SpyHudGuide.SpyScoreboardItemCommon;
         this.myDeathTF.textStyle = SpyHudGuide.SpyScoreboardItemCommon;
         this.myKarmaTF.textStyle = SpyHudGuide.SpyScoreboardItemCommon;
      }
      
      override public function setData(data:*) : void
      {
         super.setData(data);
         var scoreboardItemObj:SpyScoreboardItemObj = data as SpyScoreboardItemObj;
         if(scoreboardItemObj == null)
         {
            this.myNickname.visible = false;
            this.myNameTF.text = "";
            this.myRoleIcon.text = "";
            this.myClanNameTF.text = "";
            this.myScoreTF.text = "";
            this.myDeathTF.text = "";
            this.myKarmaTF.text = "";
            this.myPrestige.visible = false;
            this.myInvestigaterHighLight.visible = false;
            this.mySpyHighLight.visible = false;
            return;
         }
         this.myBorder.visible = false;
         if(CFunctionCommonContainer.GetPlayerID() == scoreboardItemObj.userId)
         {
            this.myBorder.visible = true;
         }
         this.myNickname.visible = true;
         this.myNickname.nickname = (scoreboardItemObj.nickName + 1).toString();
         switch(scoreboardItemObj.role)
         {
            case SpyModeRoleType.SPY_ROLE_INVESTIGATOR:
               this.myNameTF.textStyle = SpyHudGuide.SpyScoreboardItemNameInvectigater;
               this.myInvestigaterHighLight.visible = true;
               this.mySpyHighLight.visible = false;
               break;
            case SpyModeRoleType.SPY_ROLE_SPY:
               this.myNameTF.textStyle = SpyHudGuide.SpyScoreboardItemNameSpy;
               this.myInvestigaterHighLight.visible = false;
               this.mySpyHighLight.visible = true;
               break;
            case SpyModeRoleType.SPY_ROLE_CIVILIAN:
               this.myNameTF.textStyle = SpyHudGuide.SpyScoreboardItemNameCivilian;
               this.myInvestigaterHighLight.visible = false;
               this.mySpyHighLight.visible = false;
               break;
            default:
               this.myNameTF.textStyle = SpyHudGuide.SpyScoreboardItemNameCivilian;
               this.myInvestigaterHighLight.visible = false;
               this.mySpyHighLight.visible = false;
         }
         this.myRoleIcon.visible = true;
         this.myRoleIcon.gotoAndStop(scoreboardItemObj.role);
         if(scoreboardItemObj.role == SpyModeRoleType.SPY_ROLE_CIVILIAN || scoreboardItemObj.role == SpyModeRoleType.SPY_ROLE_NONE)
         {
            this.myRoleIcon.visible = false;
         }
         this.myNameTF.text = scoreboardItemObj.name;
         this.myClanNameTF.text = scoreboardItemObj.clan;
         StringUtil.fitTextFieldByLength(this.myClanNameTF.myTextClip,CLAN_NAME_TEXT_FIELD_WIDTH);
         this.myPrestige.visible = true;
         this.myPrestige.setImage(FsgUtil.getPrestigeIcon(scoreboardItemObj.level));
         this.myScoreTF.text = scoreboardItemObj.score.toString();
         this.myDeathTF.text = scoreboardItemObj.death.toString();
         if(scoreboardItemObj.karma <= 300)
         {
            this.myKarmaTF.textStyle = SpyHudGuide.SpyScoreboardItemKarmaRed;
         }
         else if(scoreboardItemObj.karma > 1000)
         {
            this.myKarmaTF.textStyle = SpyHudGuide.SpyScoreboardItemKarmaBlue;
         }
         else
         {
            this.myKarmaTF.textStyle = SpyHudGuide.SpyScoreboardItemCommon;
         }
         this.myKarmaTF.text = Math.floor(scoreboardItemObj.karma / 10).toString() + "%";
         this.myStatus.showPlayerPrivileges(scoreboardItemObj.qqMembership,scoreboardItemObj.netcafePrivileges);
      }
   }
}

