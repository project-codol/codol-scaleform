package codo.views.hudSpy
{
   import codo.common.CFunctionInGameContainer;
   import codo.component.ContentContainer;
   import codo.localization.DictHud;
   import codo.style.GlobalGuide;
   import codo.style.SpyHudGuide;
   import codo.utils.LocalizeUtil;
   import codo.utils.SpyUtil;
   import codo.utils.StringUtil;
   import flash.display.MovieClip;
   import flash.events.KeyboardEvent;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.utils.Timer;
   import fsg.util.FsgImageHolder;
   
   public class AutopsyReport extends MovieClip
   {
      
      private static const CONTAINER_WIDTH:int = 550;
      
      private static const CONTAINER_HEIGHT:int = 413;
      
      private static const CONTAINER_HEIGHT_SMALL:int = 310;
      
      private static const DEATH_TIME_TIMER_TICK_INTERVAL:int = 1000;
      
      public var myContainer:ContentContainer;
      
      public var myTitle:TextField;
      
      public var myDNATrace:TextField;
      
      public var myRole:TextField;
      
      public var myRoleIcon:MovieClip;
      
      public var myTitleBackground:MovieClip;
      
      public var myCloseHint:TextField;
      
      public var myDNAIcon:MovieClip;
      
      public var myTraceBackground:MovieClip;
      
      public var myLastSeeLabel:TextField;
      
      public var myLastSeeNickname:PlayerNickname;
      
      public var myLastSeeName:TextField;
      
      public var myDeadTimeLabel:TextField;
      
      public var myDeadTime:TextField;
      
      public var myDeadReasonLabel:TextField;
      
      public var myBodyNameLabel:TextField;
      
      public var myBodyNickname:PlayerNickname;
      
      public var myBodyName:TextField;
      
      public var myShortcutBg:MovieClip;
      
      public var myInfoBG:MovieClip;
      
      public var myWeapon:FsgImageHolder;
      
      public var mySuicideIcon:MovieClip;
      
      public var mySuicideLabel:TextField;
      
      private var mDNATraceValidTime:int;
      
      private var mDeathTime:int;
      
      private var mIsInvestigator:Boolean;
      
      private var mDeathTimeTimer:Timer;
      
      private var mDNAExpired:Boolean;
      
      public function AutopsyReport()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this.myContainer.myContainer.gotoAndStop(7);
         this.myContainer.width = CONTAINER_WIDTH;
         this.myContainer.height = CONTAINER_HEIGHT;
         this.myCloseHint.width = CONTAINER_WIDTH;
         this.myCloseHint.x = 0;
         this.myCloseHint.visible = false;
         this.myTitle.text = LocalizeUtil.localize(DictHud.SPY_AUTOPSY_REPORT);
         this.myBodyNameLabel.text = LocalizeUtil.localize(DictHud.SPY_BODY_NAME);
         this.myDeadTimeLabel.text = LocalizeUtil.localize(DictHud.SPY_DEAD_TIME);
         this.myDeadReasonLabel.text = LocalizeUtil.localize(DictHud.SPY_DEAD_REASON);
         this.myLastSeeLabel.text = LocalizeUtil.localize(DictHud.SPY_LAST_SEE);
         this.myDNATrace.text = LocalizeUtil.localize(DictHud.SPY_MURDERER_TRACE);
         this.myCloseHint.text = LocalizeUtil.localize(DictHud.SPY_CLOSE_REPORT_HINT);
         this.mySuicideLabel.text = LocalizeUtil.localize(DictHud.SPY_SUICIDE);
         this.mySuicideLabel.visible = this.mySuicideIcon.visible = false;
         this.myInfoBG.width = CONTAINER_WIDTH;
         this.myInfoBG.height = this.myContainer.height - this.myInfoBG.y - 5;
         this.mDeathTimeTimer = new Timer(DEATH_TIME_TIMER_TICK_INTERVAL);
         this.mDeathTimeTimer.addEventListener(TimerEvent.TIMER,this.onDeathTimerTick);
      }
      
      public function setReportData(data:Object) : void
      {
         var isSuicide:Boolean = false;
         this.myRole.text = LocalizeUtil.localize(SpyUtil.getLocalizedRoleName(data.bodyRole));
         this.myRole.textColor = SpyUtil.getRoleColor(data.bodyRole);
         this.myRoleIcon.gotoAndStop(data.bodyRole);
         this.myRole.x = this.myTitleBackground.x + this.myTitleBackground.width - 18 - this.myRole.textWidth;
         this.myRole.width = this.myRole.textWidth;
         this.myRoleIcon.x = this.myRole.x - this.myRoleIcon.width;
         this.myBodyNickname.nickname = data.bodyNickname;
         this.myBodyName.text = data.bodyName;
         isSuicide = data.weaponImage.length == 0;
         this.myWeapon.visible = !isSuicide;
         this.mySuicideIcon.visible = this.mySuicideLabel.visible = isSuicide;
         if(!isSuicide)
         {
            this.myWeapon.setImage(data.weaponImage);
         }
         this.mIsInvestigator = data.isInvestigator;
         this.myTraceBackground.visible = this.myDNAIcon.visible = this.myDNATrace.visible = this.mIsInvestigator;
         this.myLastSeeNickname.visible = this.myLastSeeLabel.visible = this.myLastSeeName.visible = this.mIsInvestigator;
         this.myContainer.height = this.mIsInvestigator ? CONTAINER_HEIGHT : CONTAINER_HEIGHT_SMALL;
         this.mDeathTime = data.bodyDeathTime;
         this.myShortcutBg.visible = false;
         this.updateDeathTime();
         if(this.mIsInvestigator)
         {
            this.mDNAExpired = false;
            this.mDNATraceValidTime = data.dnaTraceValidTime;
            this.myLastSeeNickname.visible = this.myLastSeeName.visible = data.lastSeeName.length > 0;
            this.myLastSeeNickname.nickname = data.lastSeeNickname;
            this.myLastSeeName.text = data.lastSeeName;
            this.updateSmellTraceTime();
         }
         this.myCloseHint.y = this.myContainer.height + this.myContainer.y + 10;
         this.myCloseHint.text = LocalizeUtil.localize(DictHud.SPY_CLOSE_REPORT_HINT);
         this.myInfoBG.height = this.myContainer.height - this.myInfoBG.y - 5;
         this.mDeathTimeTimer.start();
      }
      
      public function show(data:Object) : void
      {
         this.setReportData(data);
         parent.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDownHandler);
         visible = true;
      }
      
      public function hide() : void
      {
         parent.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDownHandler);
         visible = false;
         this.mDeathTimeTimer.reset();
      }
      
      private function onKeyDownHandler(cEvt:KeyboardEvent) : void
      {
         CFunctionInGameContainer.AS_SpyCloseAutopsyReport();
      }
      
      private function onDeathTimerTick(e:TimerEvent) : void
      {
         ++this.mDeathTime;
         this.updateDeathTime();
         this.updateSmellTraceTime();
      }
      
      private function updateSmellTraceTime() : void
      {
         var DNALeftTime:int = 0;
         var strDNALeftTime:String = null;
         var action2Key:String = null;
         if(!this.mDNAExpired && this.mIsInvestigator)
         {
            DNALeftTime = this.mDNATraceValidTime - this.mDeathTime;
            if(DNALeftTime < 0)
            {
               this.mDNAExpired = true;
               this.myDNATrace.text = LocalizeUtil.localize(DictHud.SPY_MURDERER_TRACE_EXPIRED);
            }
            else
            {
               strDNALeftTime = StringUtil.formatSeconds(DNALeftTime);
               action2Key = LocalizeUtil.localizeFirstKeyBindingForCommand("+actionslot 2");
               LocalizeUtil.paramTextFieldInput(this.myDNATrace,DictHud.SPY_MURDERER_TRACE,[strDNALeftTime,action2Key],[SpyHudGuide.HINT_COLOR_YELLOW,SpyHudGuide.HINT_COLOR_DARK_YELLOW],[GlobalGuide.FONT_FACE_NUMBERS,GlobalGuide.FONT_FACE_BOLD],[20,20]);
            }
         }
      }
      
      private function updateDeathTime() : void
      {
         this.myDeadTime.text = StringUtil.formatSeconds(this.mDeathTime);
      }
   }
}

