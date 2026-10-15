package codo_social_shared_fla
{
   import codo.objects.InputBoxSettings;
   import codo.social.claimBuffButton;
   import codo.social.clanCommonTip;
   import codo.social.clanOptionButton;
   import codo.social.clanSortableTitle;
   import codo.social.ctpGauge;
   import codo.social.infoButton;
   import codo.social.inputBox;
   import codo.social.onlineStatusWidget;
   import codo.social.playerActionButton;
   import codo.social.playerName;
   import codo.social.socialDropDown;
   import flash.display.MovieClip;
   
   public dynamic class MainTimeline extends MovieClip
   {
      
      public var CTPGauge:ctpGauge;
      
      public var ClaimBuffButton:claimBuffButton;
      
      public var ClanCommonTip:clanCommonTip;
      
      public var ClanDropMenu:socialDropDown;
      
      public var myClanSortableTitle:clanSortableTitle;
      
      public var myInfoButton:infoButton;
      
      public var myInputBox:inputBox;
      
      public var myOnlineState:onlineStatusWidget;
      
      public var myOptionBtn:clanOptionButton;
      
      public var myPlayerActionButton:playerActionButton;
      
      public var myPlayerName:playerName;
      
      public var inputBoxSettings:InputBoxSettings;
      
      public function MainTimeline()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         this.CTPGauge.setFillColor([3646444,4708344]);
         this.CTPGauge.setValue(599,1000);
         this.ClaimBuffButton.setClaimRemainingTime(100);
         this.inputBoxSettings = new InputBoxSettings();
         this.inputBoxSettings.width = 300;
         this.inputBoxSettings.height = 30;
         this.inputBoxSettings.showSearchIcon = true;
         this.inputBoxSettings.hintText = "Please input something";
         this.myInputBox.settings = this.inputBoxSettings;
         this.myClanSortableTitle.label = "ABCD";
      }
   }
}

