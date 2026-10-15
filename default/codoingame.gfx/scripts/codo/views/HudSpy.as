package codo.views
{
   import codo.base.BaseView;
   import codo.common.CFunctionInGameContainer;
   import codo.constants.BCInGameEvent;
   import codo.constants.DataInGameID;
   import codo.constants.GameInfo;
   import codo.event.ParaEvent;
   import codo.objects.SpyGameMessageObj;
   import codo.objects.SpyModeSkillObj;
   import codo.utils.ScaleformUtil;
   import codo.views.hudSpy.AimingPlayerInfo;
   import codo.views.hudSpy.AutopsyReport;
   import codo.views.hudSpy.FeaturedSpyHint;
   import codo.views.hudSpy.GameHistory;
   import codo.views.hudSpy.HudSpySelectSkillCard;
   import codo.views.hudSpy.KarmaPunishmentHint;
   import codo.views.hudSpy.QuickChatWheel;
   import codo.views.hudSpy.RoundStartupInfoDialog;
   import codo.views.hudSpy.SkillActiveHint;
   import codo.views.hudSpy.SkillCastHint;
   import codo.views.hudSpy.SkillEffectHint;
   import codo.views.hudSpy.SpeakerContainer;
   import codo.views.hudSpy.SpyAutopsyList;
   import codo.views.hudSpy.SpyScoreboard;
   import codo.views.hudSpy.WarningHint;
   import codo.views.hudSpy.WeaponBar;
   import flash.display.MovieClip;
   import flash.events.KeyboardEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   
   public class HudSpy extends BaseView
   {
      
      private static const STAGE_DEFAULT_WIDTH:int = 1280;
      
      private static const YROTATION:int = -8;
      
      private static const MARGIN_LEFT:int = 28;
      
      private static const MARGIN_BOTTOM:int = 28;
      
      private static const MARGIN_TOP:int = 14;
      
      private static const MARGIN_RIGHT:int = 28;
      
      private static const MAX_SPEAKER_CONTAINER_HEIGHT:int = 400;
      
      private static const SCOREBOARD_X:int = 240;
      
      private static const SCOREBOARD_Y:int = 200;
      
      private static const AUTOPSY_LIST_X:int = 1054;
      
      private static const AUTOPSY_LIST_Y:int = 224;
      
      private static const SCOREBOARD_W:int = 814;
      
      private static const AUTOPSY_LIST_W:int = 260;
      
      private static const SELECT_SKILL_CARD_PADDING:int = 330;
      
      public var myAutopsyReport:AutopsyReport;
      
      public var myPlayerInfoBar:MovieClip;
      
      public var mySpeakerContainer:SpeakerContainer;
      
      public var myOverallState:MovieClip;
      
      public var myRoundStartupInfo:RoundStartupInfoDialog;
      
      public var myGameHistory:GameHistory;
      
      public var myWeaponBar:WeaponBar;
      
      public var myAimingPlayer:AimingPlayerInfo;
      
      public var mySkills:MovieClip;
      
      public var myKarmaWarning:MovieClip;
      
      public var mySkillActiveHint:SkillActiveHint;
      
      public var myKarmaPunishHint:KarmaPunishmentHint;
      
      public var myQuickChatWheel:QuickChatWheel;
      
      public var myTextHint:TextField;
      
      public var myWarningHint:WarningHint;
      
      public var mySkillCastHint:SkillCastHint;
      
      public var myFeaturedHint:FeaturedSpyHint;
      
      public var myBlackScreen:MovieClip;
      
      public var myScoreboard:SpyScoreboard;
      
      public var myAutopsyList:SpyAutopsyList;
      
      public var myMask:MovieClip;
      
      public var mySelectSkillCard1:HudSpySelectSkillCard;
      
      public var mySelectSkillCard2:HudSpySelectSkillCard;
      
      public var mySelectSkillCard3:HudSpySelectSkillCard;
      
      public var mySkillEffectHint:SkillEffectHint;
      
      private var mSelectSkillCards:Vector.<HudSpySelectSkillCard>;
      
      public function HudSpy()
      {
         super();
         this.mSelectSkillCards = new <HudSpySelectSkillCard>[this.mySelectSkillCard1,this.mySelectSkillCard2,this.mySelectSkillCard3];
      }
      
      override protected function showView() : void
      {
         var stageSize:Point = null;
         var stagePosition:Point = null;
         var i:int = 0;
         super.showView();
         stageSize = new Point(1280,960);
         stagePosition = new Point(0,0);
         if(ScaleformUtil.isScaleform)
         {
            stageSize = GameInfo.stageSize;
            stagePosition = GameInfo.stagePosition;
         }
         this.myMask.visible = false;
         this.myMask.x = stagePosition.x;
         this.myMask.y = stagePosition.y;
         this.myMask.width = stageSize.x;
         this.myMask.height = stageSize.y;
         for(i = 0; i < this.mSelectSkillCards.length; i++)
         {
            this.mSelectSkillCards[i].visible = false;
         }
         this.myPlayerInfoBar.x = stagePosition.x + MARGIN_LEFT;
         this.myPlayerInfoBar.y = stagePosition.y + stageSize.y - this.myPlayerInfoBar.height - MARGIN_BOTTOM;
         this.myPlayerInfoBar.rotationY = YROTATION;
         this.myWeaponBar.x = stagePosition.x + stageSize.x - MARGIN_RIGHT;
         this.myWeaponBar.y = stagePosition.y + stageSize.y - this.myWeaponBar.height - MARGIN_BOTTOM;
         this.myWeaponBar.rotationY = -YROTATION;
         this.mySkills.x = stagePosition.x + stageSize.x - MARGIN_RIGHT;
         this.mySkills.y = this.myWeaponBar.y - 60;
         this.mySkills.rotationY = -YROTATION;
         this.myOverallState.x = stagePosition.x + MARGIN_LEFT;
         this.myOverallState.y = stagePosition.y + MARGIN_TOP;
         this.myOverallState.rotationY = YROTATION;
         this.mySpeakerContainer.x = stagePosition.x + MARGIN_LEFT;
         this.mySpeakerContainer.y = this.myOverallState.y + this.myOverallState.height + 5;
         this.mySpeakerContainer.rotationY = YROTATION;
         this.myGameHistory.x = stagePosition.x + stageSize.x - MARGIN_RIGHT;
         this.myGameHistory.y = stagePosition.y + MARGIN_TOP;
         this.myGameHistory.rotationY = -YROTATION;
         this.myKarmaWarning.x = stagePosition.x + (stageSize.x - this.myKarmaWarning.width) / 2;
         this.myKarmaWarning.y = stagePosition.y + MARGIN_TOP;
         this.myBlackScreen.visible = false;
         this.myBlackScreen.x = stagePosition.x;
         this.myBlackScreen.y = stagePosition.y;
         this.myBlackScreen.width = stageSize.x;
         this.myBlackScreen.height = stageSize.y;
         this.myScoreboard.x = stagePosition.x + (stageSize.x - (SCOREBOARD_W + AUTOPSY_LIST_W)) / 2;
         this.myScoreboard.y = stagePosition.y + SCOREBOARD_Y;
         this.myAutopsyList.x = stagePosition.x + (stageSize.x - (SCOREBOARD_W + AUTOPSY_LIST_W)) / 2 + SCOREBOARD_W;
         this.myAutopsyList.y = stagePosition.y + AUTOPSY_LIST_Y;
         this.mySkillEffectHint.visible = false;
         CFunctionInGameContainer.AS_RegisterHUDView(CFunctionInGameContainer.HVT_Spy,this);
         setBindData(DataInGameID.CHATTING_VIEW_ROTATION,-YROTATION);
         listen(BCInGameEvent.EVT_HIDE_SPY_SELECT_SKILL_CARDS,this.onHideSelectSkillCards);
      }
      
      override protected function hideView() : void
      {
         super.hideView();
         unlisten(BCInGameEvent.EVT_HIDE_SPY_SELECT_SKILL_CARDS,this.onHideSelectSkillCards);
      }
      
      public function cppShowAutopsyReport(data:Object) : void
      {
         this.myAutopsyReport.show(data);
      }
      
      public function cppCloseAutopsyReport() : void
      {
         this.myAutopsyReport.hide();
      }
      
      public function cppSetAimingPlayerInfo(data:Object) : void
      {
         this.myAimingPlayer.setData(data);
         this.centerMC(this.myAimingPlayer);
      }
      
      public function cppShowRoundStartupInfo(data:Object) : void
      {
         this.myRoundStartupInfo.show(data);
      }
      
      public function cppCloseRolePick() : void
      {
         this.myRoundStartupInfo.hide();
      }
      
      public function cppPushGameMessage(message:SpyGameMessageObj) : void
      {
         this.myGameHistory.pushMessage(message);
      }
      
      public function cppClearGameHistory() : void
      {
         this.myGameHistory.clearAllMessage();
      }
      
      public function cppSetSkillActiveHint(data:*) : void
      {
         this.mySkillActiveHint.setData(data);
         this.centerMC(this.mySkillActiveHint);
      }
      
      public function cppSetWarningHint(text:*) : void
      {
         this.myWarningHint.setText(text as String);
         this.centerMC(this.myWarningHint);
      }
      
      public function cppSetSkillCastHint(data:*) : void
      {
         this.mySkillCastHint.setData(data);
         this.centerMC(this.mySkillCastHint);
      }
      
      public function cppShowFeaturedRoomHint(data:*) : void
      {
         this.myFeaturedHint.setData(data);
         this.centerMC(this.myFeaturedHint);
      }
      
      public function cppShowKarmaPunishHint() : void
      {
         this.myKarmaPunishHint.showKarmaPunishHint();
         this.showBlackScreen(this.myKarmaPunishHint);
      }
      
      public function cppHideKarmaPunishHint() : void
      {
         this.myKarmaPunishHint.hideKarmaPunishHint();
         this.hideBlackScreen();
      }
      
      public function cppShowSelectSkillCardsPanel(skillObjs:Array) : void
      {
         var i:int = 0;
         var skillObj:SpyModeSkillObj = null;
         this.myMask.visible = true;
         var stageSize:Point = new Point(1280,960);
         var stagePosition:Point = new Point(0,0);
         if(ScaleformUtil.isScaleform)
         {
            stageSize = GameInfo.stageSize;
            stagePosition = GameInfo.stagePosition;
         }
         for(i = 0; i < this.mSelectSkillCards.length; i++)
         {
            this.mSelectSkillCards[i].scaleX = 1;
            this.mSelectSkillCards[i].scaleY = 1;
         }
         var totalWidth:int = skillObjs.length * SELECT_SKILL_CARD_PADDING;
         var xOff:int = (stageSize.x - totalWidth) / 2;
         var yOff:int = (stageSize.y - this.mySelectSkillCard1.height) / 2;
         for(i = 0; i < skillObjs.length; i++)
         {
            this.mSelectSkillCards[i].visible = true;
            this.mSelectSkillCards[i].setOrgPosition(stagePosition.x + xOff + i * SELECT_SKILL_CARD_PADDING,stagePosition.y + yOff);
            skillObj = skillObjs[i];
            this.mSelectSkillCards[i].index = i + 1;
            this.mSelectSkillCards[i].setData(skillObj);
         }
         stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onSelectSkillKeyEventHandle);
      }
      
      public function cppHideSelectSkillCardsPanel() : void
      {
         this.myMask.visible = false;
         for(var i:int = 0; i < this.mSelectSkillCards.length; i++)
         {
            this.mSelectSkillCards[i].visible = false;
         }
         stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onSelectSkillKeyEventHandle);
      }
      
      protected function onSelectSkillKeyEventHandle(cEvt:KeyboardEvent) : void
      {
         var index:int = cEvt.charCode - "1".charCodeAt();
         if(index < 0)
         {
            return;
         }
         if(index >= this.mSelectSkillCards.length)
         {
            return;
         }
         this.mSelectSkillCards[index].choose();
      }
      
      private function centerMC(mc:MovieClip) : void
      {
         mc.x = (STAGE_DEFAULT_WIDTH - mc.width) / 2;
      }
      
      private function showBlackScreen(after:MovieClip) : void
      {
         this.setChildIndex(this.myBlackScreen,this.getChildIndex(after) - 1);
         this.myBlackScreen.visible = true;
      }
      
      private function hideBlackScreen() : void
      {
         this.myBlackScreen.visible = false;
      }
      
      private function onHideSelectSkillCards(cEvt:ParaEvent) : void
      {
         var exceptionCard:HudSpySelectSkillCard = cEvt.myPara as HudSpySelectSkillCard;
         for(var i:int = 0; i < this.mSelectSkillCards.length; i++)
         {
            if(this.mSelectSkillCards[i] != exceptionCard)
            {
               this.mSelectSkillCards[i].alpha = 0;
            }
         }
      }
      
      public function cppShowSkillEffectHint(data:Object) : void
      {
         this.mySkillEffectHint.setData(data);
         this.mySkillEffectHint.visible = true;
      }
      
      public function cppHideSkillEffectHint() : void
      {
         this.mySkillEffectHint.visible = false;
      }
   }
}

