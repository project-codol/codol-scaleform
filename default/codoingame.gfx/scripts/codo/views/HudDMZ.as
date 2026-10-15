package codo.views
{
   import codo.base.BaseView;
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionInGameContainer;
   import codo.constants.GameInfo;
   import codo.localization.DictDmz;
   import codo.utils.LocalizeUtil;
   import codo.utils.ScaleformUtil;
   import codo.utils.ShoutcastUtil;
   import codo.views.hudDMZ.DMZWeaponBar;
   import codo.views.hudDMZ.SpectatingNotification;
   import codo.views.hudDMZScoreboard.HudDMZScoreboard;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class HudDMZ extends BaseView
   {
      
      private static const MARGIN_LEFT:int = 10.5;
      
      private static const MARGIN_RIGHT:int = 10.5;
      
      private static const GHOST_OVERLAY_MARGIN:int = 200;
      
      private static const SCOREBOARD_X:int = 286;
      
      private static const ESC_KEY_COLOR:uint = 16741120;
      
      private static const SHOUTCASTER_MARGIN_BOTTOM:int = 25;
      
      public var myScoreboard:HudDMZScoreboard;
      
      public var myTeamPanel:MovieClip;
      
      public var myPlayerCounter:MovieClip;
      
      public var myPlayerInfo:MovieClip;
      
      public var myWeaponBar:DMZWeaponBar;
      
      public var myTimer:MovieClip;
      
      public var myHintPanel:MovieClip;
      
      public var myGhostOverlayLeft:MovieClip;
      
      public var myGhostOverlayRight:MovieClip;
      
      public var myRankBar:MovieClip;
      
      public var myItemPanel:MovieClip;
      
      public var myGhostHintPanel:MovieClip;
      
      public var myBlackScreen:MovieClip;
      
      public var myMarkerHint:MovieClip;
      
      public var myQuickMatchHint:MovieClip;
      
      public var mySpectatingNotification:SpectatingNotification;
      
      public var myTextHint:TextField;
      
      private var mHardcore:Boolean = false;
      
      public function HudDMZ()
      {
         super();
         this.mHardcore = CFunctionCommonContainer.Dvar_GetBool("g_hardcore") as Boolean;
      }
      
      override protected function showView() : void
      {
         var stageSize:Point = null;
         var stagePosition:Point = null;
         super.showView();
         stageSize = new Point(1280,960);
         stagePosition = new Point(0,0);
         if(ScaleformUtil.isScaleform)
         {
            stageSize = GameInfo.stageSize;
            stagePosition = GameInfo.stagePosition;
         }
         this.myPlayerCounter.x = stagePosition.x + MARGIN_LEFT;
         this.myWeaponBar.x = stagePosition.x + stageSize.x - MARGIN_RIGHT;
         this.myItemPanel.x = stagePosition.x + stageSize.x - MARGIN_RIGHT - this.myItemPanel.width;
         this.myTeamPanel.x = this.myPlayerCounter.x + this.myPlayerCounter.width + MARGIN_LEFT;
         this.myItemPanel.visible = false;
         this.myTimer.x = stagePosition.x + MARGIN_LEFT;
         this.myGhostOverlayLeft.x = stagePosition.x + GHOST_OVERLAY_MARGIN + MARGIN_LEFT;
         this.myGhostOverlayRight.x = stagePosition.x + stageSize.x - MARGIN_RIGHT - GHOST_OVERLAY_MARGIN;
         this.myRankBar.x = this.myPlayerCounter.x;
         this.myGhostHintPanel.x = stagePosition.x + stageSize.x - 162 - this.myGhostHintPanel.width;
         this.myScoreboard.visible = false;
         this.myScoreboard.x = SCOREBOARD_X;
         this.myBlackScreen.x = stagePosition.x;
         this.myBlackScreen.y = stagePosition.y;
         this.myBlackScreen.width = stageSize.x;
         this.myBlackScreen.height = stageSize.y;
         this.myBlackScreen.visible = false;
         this.myMarkerHint.x = stagePosition.x + (stageSize.x + stageSize.y) / 2 - this.myMarkerHint.width - 10;
         var quickMatchTextLabel:TextField = this.myQuickMatchHint["myText"];
         var key:String = "ESC";
         var text:String = LocalizeUtil.param(DictDmz.GHOST_QUICK_MATCH,[key]);
         quickMatchTextLabel.text = text;
         var format:TextFormat = quickMatchTextLabel.getTextFormat();
         format.color = ESC_KEY_COLOR;
         var keyIndex:int = text.indexOf(key);
         quickMatchTextLabel.setTextFormat(format,keyIndex,keyIndex + key.length);
         for(var i:int = 0; i < this.numChildren; i++)
         {
            this.getChildAt(i).visible = false;
         }
         if(this.mHardcore)
         {
            this.myHintPanel.x = stagePosition.x + MARGIN_LEFT;
            this.myQuickMatchHint.y = stagePosition.y + stageSize.y - this.myQuickMatchHint.height - 40;
            this.myQuickMatchHint.x = stagePosition.x + stageSize.x - this.myQuickMatchHint.width - 165;
         }
         else
         {
            this.myHintPanel.x = this.myTimer.x + this.myTimer.width + 3;
            this.myQuickMatchHint.y = this.myWeaponBar.y - this.myQuickMatchHint.height - 10;
            this.myQuickMatchHint.x = this.myWeaponBar.x - this.myQuickMatchHint.width;
         }
         this.mySpectatingNotification.visible = false;
         this.myTextHint.visible = false;
         CFunctionInGameContainer.AS_RegisterHUDView(CFunctionInGameContainer.HVT_DMZ,this);
         ShoutcastUtil.getInstance().registerView(this);
      }
      
      public function applyShoutCasterView() : void
      {
         var stageSize:Point = GameInfo.stageSize;
         var stagePosition:Point = GameInfo.stagePosition;
         this.myPlayerCounter.y = stagePosition.y + stageSize.y - this.myPlayerCounter.height - SHOUTCASTER_MARGIN_BOTTOM;
         this.myTeamPanel.y = stagePosition.y + stageSize.y - this.myTeamPanel.height - SHOUTCASTER_MARGIN_BOTTOM;
         this.myPlayerInfo.y = stagePosition.y + stageSize.y - this.myPlayerInfo.height - SHOUTCASTER_MARGIN_BOTTOM;
         this.myWeaponBar.y = stagePosition.y + stageSize.y - this.myWeaponBar.height - SHOUTCASTER_MARGIN_BOTTOM;
         this.myTimer.y = stagePosition.y + 365;
         this.myTimer.x = stagePosition.x + 18;
      }
      
      public function cppSetSpectatingPlayerName(name:String) : void
      {
         this.mySpectatingNotification.setPlayerName(name);
         this.mySpectatingNotification.x = GameInfo.stagePosition.x + GameInfo.stageSize.x / 2 - this.mySpectatingNotification.width / 2;
      }
   }
}

