package codo.views
{
   import codo.constants.DataInGameID;
   import codo.event.ParaEvent;
   import codo.localization.DictInGame;
   import codo.objects.AARXPDetailsObj;
   import codo.objects.ResultObj;
   import codo.objects.ScoreboardObj;
   import components.ingameaar_part.AARPanelRecentMatches;
   import components.ingameaar_part.AARPanelXP;
   import components.ingameaar_part.AARXPDialog;
   import components.ingameaar_part.ScoreboardTeamScoresBar;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class HudAARView extends AARBaseView
   {
      
      public var myTeamResultsHeader:ScoreboardTeamScoresBar;
      
      public var myPanelXP:AARPanelXP;
      
      public var myPanelRecentMatches:AARPanelRecentMatches;
      
      public var myXPDialog:AARXPDialog;
      
      private var mEscTimer:Timer;
      
      private var _darkBkg:Sprite;
      
      private var _mainContainer:Sprite;
      
      public function HudAARView()
      {
         var i:int = 0;
         var child:DisplayObject = null;
         super();
         var mainChildren:Vector.<DisplayObject> = new Vector.<DisplayObject>();
         for(i = 0; i < this.numChildren; i++)
         {
            child = this.getChildAt(i);
            if(child != this.myXPDialog)
            {
               mainChildren.push(child);
            }
         }
         this.myEarlyExitButton.label = DictInGame.BackToGame;
         this.myXPDialog.visible = false;
         this._mainContainer = new Sprite();
         this.addChild(this._mainContainer);
         for(i = 0; i < mainChildren.length; i++)
         {
            this._mainContainer.addChild(mainChildren[i]);
         }
      }
      
      override protected function onInitListener() : void
      {
         super.onInitListener();
         this.myPanelXP.addEventListener(AARPanelXP.SHOW_DETAILS,this.onShowXPDetails);
         this.myXPDialog.addEventListener(AARXPDialog.HIDE_DETAILS,this.onHideXPDetails);
      }
      
      override protected function enableData() : void
      {
         super.enableData();
         if(this._darkBkg == null && this.stage != null)
         {
            this._darkBkg = new Sprite();
            this._darkBkg.x = -this.x;
            this._darkBkg.y = -this.y;
            this._darkBkg.graphics.beginFill(0,0.7);
            this._darkBkg.graphics.drawRect(0,0,this.stage.width,this.stage.height);
            this._darkBkg.graphics.endFill();
         }
         this.myPanelXP.SetXPData();
         var scores:Array = this.getDP(DataInGameID.AAR_RECENT_SCORES);
         var avgScore:int = this.getDP(DataInGameID.AAR_RECENT_AVG);
         this.myPanelRecentMatches.SetMatchesData(scores,avgScore);
         myEarlyExitButton.visible = false;
         this.cleanupEarlyExit();
         this.setupEarlyExit();
      }
      
      override protected function disableData() : void
      {
         super.disableData();
         this.cleanupEarlyExit();
      }
      
      override protected function bind_hudScoreboard(cResult:ResultObj) : void
      {
         super.bind_hudScoreboard(cResult);
         var matchResult:int = this.getDP(DataInGameID.MATCH_RESULT) as int;
         this.myTeamResultsHeader.SetData(new ScoreboardObj(cResult.data),matchResult);
      }
      
      private function setupEarlyExit() : void
      {
         var earlyExitDelay:int = 0;
         if(this.mEscTimer == null)
         {
            earlyExitDelay = this.getDP(DataInGameID.EARLY_EXIT_DELAY) as int;
            this.mEscTimer = new Timer(earlyExitDelay,1);
            this.mEscTimer.addEventListener(TimerEvent.TIMER,this.onEarlyExitTimer);
            this.mEscTimer.start();
         }
      }
      
      private function cleanupEarlyExit() : void
      {
         if(this.mEscTimer != null)
         {
            this.mEscTimer.reset();
            this.mEscTimer.removeEventListener(TimerEvent.TIMER,this.onEarlyExitTimer);
            this.mEscTimer = null;
         }
      }
      
      private function onEarlyExitTimer(event:TimerEvent) : void
      {
         this.cleanupEarlyExit();
         myEarlyExitButton.visible = true;
      }
      
      override protected function HandleBack() : void
      {
         if(this.myXPDialog.visible)
         {
            this.myXPDialog.visible = false;
            this._mainContainer.visible = true;
         }
         else
         {
            super.HandleBack();
         }
      }
      
      private function onShowXPDetails(event:ParaEvent) : void
      {
         this._mainContainer.visible = false;
         this.myXPDialog.SetXPDetails(event.myPara as AARXPDetailsObj);
         this.myXPDialog.visible = true;
      }
      
      private function onHideXPDetails(event:Event) : void
      {
         this._mainContainer.visible = true;
         this.myXPDialog.visible = false;
      }
   }
}

