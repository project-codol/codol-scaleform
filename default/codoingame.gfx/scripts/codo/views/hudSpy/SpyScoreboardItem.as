package codo.views.hudSpy
{
   import codo.common.CFunctionCommonContainer;
   import codo.component.TextField;
   import codo.component.core.UIInteractiveComponent;
   import codo.component.playerAccount.PlayerAccountInfoPrivileges;
   import codo.constants.SpyModeRoleType;
   import codo.objects.SpyScoreboardItemObj;
   import codo.style.SpyHudGuide;
   import codo.utils.StringUtil;
   import flash.display.MovieClip;
   import fsg.util.FsgImageHolder;
   import fsg.util.FsgUtil;
   
   public class SpyScoreboardItem extends UIInteractiveComponent
   {
      
      public static const NAME_TEXT_FIELD_WIDTH:int = 190;
      
      public static const CLAN_NAME_TEXT_FIELD_WIDTH:int = 200;
      
      public var myBorder:MovieClip;
      
      public var myNickNameIcon:PlayerNickname;
      
      public var myNameTF:TextField;
      
      public var myRoleIcon:MovieClip;
      
      public var myClanTF:TextField;
      
      public var myScoreTF:TextField;
      
      public var myDeathTF:TextField;
      
      public var myKarmaTF:TextField;
      
      public var myAccountInfo:PlayerAccountInfoPrivileges;
      
      public var myPingTF:TextField;
      
      public var myPrestigeIcon:FsgImageHolder;
      
      private var mAvailable:Boolean;
      
      public function SpyScoreboardItem()
      {
         super();
         this.myClanTF.textStyle = SpyHudGuide.SpyScoreboardItemCommon;
         this.myScoreTF.textStyle = SpyHudGuide.SpyScoreboardItemCommon;
         this.myDeathTF.textStyle = SpyHudGuide.SpyScoreboardItemCommon;
         this.myKarmaTF.textStyle = SpyHudGuide.SpyScoreboardItemCommon;
         this.myPingTF.textStyle = SpyHudGuide.SpyScoreboardItemCommon;
         this.mAvailable = false;
      }
      
      public function set available(val:Boolean) : void
      {
         this.mAvailable = val;
         visible = val;
      }
      
      override public function setData(data:*) : void
      {
         var scoreboardItemObj:SpyScoreboardItemObj = null;
         super.setData(data);
         scoreboardItemObj = data as SpyScoreboardItemObj;
         if(scoreboardItemObj == null)
         {
            this.myNickNameIcon.visible = false;
            this.myNameTF.text = "";
            this.myRoleIcon.text = "";
            this.myClanTF.text = "";
            this.myScoreTF.text = "";
            this.myDeathTF.text = "";
            this.myKarmaTF.text = "";
            this.myPingTF.text = "";
            this.myPrestigeIcon.visible = false;
            this.mAvailable = false;
            return;
         }
         this.available = true;
         this.myBorder.visible = false;
         if(CFunctionCommonContainer.GetPlayerID() == scoreboardItemObj.userId)
         {
            this.myBorder.visible = true;
         }
         this.myNickNameIcon.visible = true;
         this.myNickNameIcon.nickname = (scoreboardItemObj.nickName + 1).toString();
         switch(scoreboardItemObj.role)
         {
            case SpyModeRoleType.SPY_ROLE_INVESTIGATOR:
               this.myNameTF.textStyle = SpyHudGuide.SpyScoreboardItemNameInvectigater;
               break;
            case SpyModeRoleType.SPY_ROLE_SPY:
               this.myNameTF.textStyle = SpyHudGuide.SpyScoreboardItemNameSpy;
               break;
            case SpyModeRoleType.SPY_ROLE_CIVILIAN:
               this.myNameTF.textStyle = SpyHudGuide.SpyScoreboardItemNameCivilian;
               break;
            default:
               this.myNameTF.textStyle = SpyHudGuide.SpyScoreboardItemNameCivilian;
         }
         this.myRoleIcon.visible = true;
         this.myRoleIcon.gotoAndStop(scoreboardItemObj.role);
         if(scoreboardItemObj.role == SpyModeRoleType.SPY_ROLE_CIVILIAN || scoreboardItemObj.role == SpyModeRoleType.SPY_ROLE_NONE)
         {
            this.myRoleIcon.visible = false;
         }
         this.myNameTF.text = scoreboardItemObj.name;
         StringUtil.fitTextFieldByLength(this.myNameTF.myTextClip,NAME_TEXT_FIELD_WIDTH);
         this.myClanTF.text = scoreboardItemObj.clan;
         StringUtil.fitTextFieldByLength(this.myClanTF.myTextClip,CLAN_NAME_TEXT_FIELD_WIDTH);
         this.myPrestigeIcon.visible = true;
         this.myPrestigeIcon.setImage(FsgUtil.getPrestigeIcon(scoreboardItemObj.level));
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
         if(scoreboardItemObj.karma == 0)
         {
            this.myKarmaTF.text = "";
         }
         this.myPingTF.text = scoreboardItemObj.ping.toString();
         this.myAccountInfo.showPlayerPrivileges(scoreboardItemObj.qqMembership,scoreboardItemObj.netcafePrivileges);
      }
   }
}

