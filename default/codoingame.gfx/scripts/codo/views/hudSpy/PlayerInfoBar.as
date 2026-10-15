package codo.views.hudSpy
{
   import codo.localization.DictHud;
   import codo.utils.LocalizeUtil;
   import codo.utils.StringUtil;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class PlayerInfoBar extends MovieClip
   {
      
      private static const PLAYER_NAME_TF_LEN:int = 178;
      
      public var myIndicator:MovieClip;
      
      public var myTime:TextField;
      
      public var myName:TextField;
      
      public var myNickname:PlayerNickname;
      
      public var myRoleIcon:MovieClip;
      
      public var myRoleName:TextField;
      
      public function PlayerInfoBar()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this.myTime.text = "";
         this.myName.text = "";
         this.myRoleName.text = "";
         this.myNickname.nickname = "";
      }
      
      public function setPlayerInfoData() : void
      {
         this.myRoleIcon.gotoAndStop(1);
         this.myIndicator.gotoAndStop(1);
         this.myRoleName.text = LocalizeUtil.localize(DictHud.SPY_INVESTIGATOR);
      }
      
      public function set playerName(playerName:String) : void
      {
         this.myName.text = playerName;
         StringUtil.fitTextFieldByLength(this.myName,PLAYER_NAME_TF_LEN);
      }
   }
}

