package codo.component.matchselect
{
   import codo.component.TextField;
   import codo.component.lobby.LobbyConstants;
   import codo.objects.MatchSelectTheatreOptionObj;
   import codo.objects.ModeObj;
   import codo.services.MatchService;
   import codo.style.GlobalGuide;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextFieldAutoSize;
   import fsg.util.FsgImageHolder;
   
   public class TheatreSelectModeInfo extends MovieClip
   {
      
      public var myModeImage:FsgImageHolder;
      
      public var myLoadingIndicator:MovieClip;
      
      public var myLoadingLabel:TextField;
      
      public var my141Score:TextField;
      
      public var mySCARScore:TextField;
      
      public var myMatchTime:TextField;
      
      public var myVideoName:TextField;
      
      public var myDateStamp:TextField;
      
      public var myLengthString:TextField;
      
      public var myFrame:MovieClip;
      
      public var myAllyTeam:Sprite;
      
      public var myEnemyTeam:Sprite;
      
      public var myScarLogo:Sprite;
      
      public var myTF141Logo:Sprite;
      
      public var myUserIndicator:Sprite;
      
      public var myTeamBackground:Sprite;
      
      protected var mTextSubColor:uint = 13421772;
      
      protected var _isLoading:Boolean;
      
      public function TheatreSelectModeInfo()
      {
         super();
         this.initStage();
      }
      
      private function initStage() : void
      {
         this.myFrame.gotoAndStop(4);
         this.resetInfo();
         this.showLoadingStatus(false);
      }
      
      public function resetInfo() : void
      {
         this.myVideoName.autoSize = this.myDateStamp.autoSize = TextFieldAutoSize.LEFT;
         this.myVideoName.width = this.myDateStamp.width = 600;
         this.myVideoName.fontSize = GlobalGuide.FONT_SIZE_LARGE;
         this.myDateStamp.fontSize = GlobalGuide.FONT_SIZE_SMALL;
         this.myDateStamp.fontColor = this.mTextSubColor;
         this.myLengthString.text = "@SF_UI_MATCH_LENGTH";
         this.setImage("SP_Multi_Gamemode_.tga");
      }
      
      public function showLoadingStatus(show:Boolean) : void
      {
         this.myLoadingLabel.visible = show;
         this.myLoadingIndicator.visible = show && this._isLoading;
      }
      
      public function setLoadingLabel(label:String, showLoading:Boolean = false) : void
      {
         this.myLoadingLabel.text = label.toUpperCase();
         this._isLoading = showLoading;
      }
      
      public function setImage(imgURL:String) : void
      {
         this.myModeImage.aspectMax = true;
         this.myModeImage.setImage(imgURL);
      }
      
      public function updateMatchInfo(data:MatchSelectTheatreOptionObj) : void
      {
         var showScore:Boolean = false;
         var modeObj:ModeObj = MatchService.getInstance().getModeObj(String(data.gameType).toLowerCase());
         if(Boolean(modeObj))
         {
            this.setImage(modeObj.image);
         }
         else
         {
            this.setImage("SP_Multi_Gamemode_.tga");
         }
         this.myDateStamp.text = data.date + " " + data.time;
         this.myVideoName.text = data.gameTypeLoc + " - " + data.mapLoc;
         this.myMatchTime.text = data.length;
         if(data.yourFaction == LobbyConstants.TEAM_TF141)
         {
            this.my141Score.text = data.yourScore;
            this.mySCARScore.text = data.theirScore;
            this.myTF141Logo.visible = this.myScarLogo.visible = true;
            this.myUserIndicator.x = 15;
            this.myTeamBackground.scaleX = 1;
         }
         else if(data.yourFaction == LobbyConstants.TEAM_SCAR)
         {
            this.mySCARScore.text = data.yourScore;
            this.my141Score.text = data.theirScore;
            this.myTF141Logo.visible = this.myScarLogo.visible = true;
            this.myUserIndicator.x = 599;
            this.myTeamBackground.scaleX = -1;
         }
         else
         {
            showScore = Boolean(modeObj) && !modeObj.isDMZ;
            this.my141Score.text = showScore ? data.yourScore : "--";
            this.mySCARScore.text = "--";
            this.myTF141Logo.visible = this.myScarLogo.visible = false;
            this.myUserIndicator.x = 15;
            this.myTeamBackground.scaleX = 1;
         }
         this.myAllyTeam.visible = !this.myTF141Logo.visible;
         this.myEnemyTeam.visible = false;
         this.myUserIndicator.visible = true;
      }
      
      public function clearMatchInfo() : void
      {
         this.myVideoName.text = this.myDateStamp.text = this.my141Score.text = this.mySCARScore.text = this.myMatchTime.text = "--";
         this.myModeImage.clearImage();
         this.myUserIndicator.visible = false;
      }
      
      override public function get width() : Number
      {
         return this.myFrame.width;
      }
   }
}

