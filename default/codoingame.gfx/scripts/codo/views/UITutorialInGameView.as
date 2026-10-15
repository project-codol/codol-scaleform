package codo.views
{
   import codo.base.BaseView;
   import codo.constants.GameInfo;
   import codo.constants.UITutorialFlags;
   import codo.localization.DictUITutorial;
   import codo.style.TutorialGuide;
   import codo.utils.LocalizeUtil;
   import codo.utils.ScaleformUtil;
   import codo.views.uitour.UIInGameTutorialBase;
   import codo.views.uitour.UIInGameTutorialSplash;
   import codo.views.uitour.UITutorialTourBase;
   import codo.views.uitour.ingame.UITourInGameAnimatedLines;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class UITutorialInGameView extends BaseView
   {
      
      public var myIngameTutorial:UIInGameTutorialBase;
      
      public var myFirstKillTutorial:UIInGameTutorialSplash;
      
      public var myFirstKillstreakTutorial:UIInGameTutorialSplash;
      
      public var myKillstreakAnimatedLines:UITourInGameAnimatedLines;
      
      public var myScoreboardAnimatedLines:UITourInGameAnimatedLines;
      
      private var mCurrentSplash:UITutorialTourBase;
      
      private var mInitSprintMsg:Boolean = true;
      
      private var mTimeout:int = -1;
      
      private var mCurrentStep:int = -1;
      
      public function UITutorialInGameView()
      {
         var animLinesPos:Point = null;
         super();
         animLinesPos = GameInfo.getStageCoordForAnchorAndOffset(GameInfo.BOTTOM_RIGHT,new Point());
         this.hideAllTours();
         this.myKillstreakAnimatedLines.x = animLinesPos.x - (this.myKillstreakAnimatedLines.width + 158);
         this.myKillstreakAnimatedLines.y = animLinesPos.y - (this.myKillstreakAnimatedLines.width - 97);
         animLinesPos = GameInfo.getStageCoordForAnchorAndOffset(GameInfo.BOTTOM_LEFT,new Point());
         this.myScoreboardAnimatedLines.x = animLinesPos.x - 122;
         this.myScoreboardAnimatedLines.y = animLinesPos.y - (57 + this.myScoreboardAnimatedLines.height);
         this.myScoreboardAnimatedLines.deactive();
         this.myKillstreakAnimatedLines.deactive();
         this.myFirstKillTutorial.myTitleTF.textStyle = this.myFirstKillstreakTutorial.myTitleTF.textStyle = TutorialGuide.styleTextTitleAlignRight;
         if(!ScaleformUtil.isScaleform)
         {
            this.routeData = {"step":UITutorialFlags.UI_TUTORIAL_IN_GAME_FIRST_KILL};
         }
      }
      
      override public function set routeData(data:*) : void
      {
         var contentAnchor:Point = null;
         var ingameMsg:String = null;
         var step:int = int(data.step);
         var stepData:int = int(data.stepData);
         this.myScoreboardAnimatedLines.deactive();
         this.myKillstreakAnimatedLines.deactive();
         if(this.mCurrentSplash != null)
         {
            this.mCurrentSplash.hide();
         }
         if(this.mTimeout != -1)
         {
            clearTimeout(this.mTimeout);
            this.mTimeout = -1;
         }
         this.myIngameTutorial.byPassGhostAnimation = false;
         this.myIngameTutorial.forceOpenObjectiveWindow = false;
         if(step == this.mCurrentStep)
         {
            return;
         }
         this.mCurrentStep = step;
         switch(step)
         {
            case UITutorialFlags.UI_TUTORIAL_IN_GAME_SPRINT:
               if(this.mInitSprintMsg)
               {
                  this.myIngameTutorial.byPassGhostAnimation = this.myIngameTutorial.isInitMission = true;
                  this.myIngameTutorial.setObjectiveWindowOverrideMsg(DictUITutorial.ONBOARDING_UI_TOUR_IN_GAME_USE_WASD_TO_MOVE,"input_key_wasd");
                  this.mInitSprintMsg = false;
               }
               this.showInGameTutorial(DictUITutorial.ONBOARDING_UI_TOUR_IN_GAME_SPRINT,"+breath_sprint");
               break;
            case UITutorialFlags.UI_TUTORIAL_IN_GAME_SHOOT:
               ingameMsg = DictUITutorial.ONBOARDING_UI_TOUR_IN_GAME_SHOOT;
               if(stepData < 5)
               {
                  this.myIngameTutorial.forceOpenObjectiveWindow = true;
               }
               if(stepData == 5)
               {
                  ingameMsg = DictUITutorial.ONBOARDING_UI_TOUR_IN_GAME_SHOOT_FIRST_ENEMY;
                  this.showInGameTutorial(ingameMsg);
               }
               else
               {
                  this.showInGameTutorial(LocalizeUtil.param(ingameMsg,[stepData]),"+attack");
               }
               break;
            case UITutorialFlags.UI_TUTORIAL_IN_GAME_FIRST_KILL:
               this.mCurrentSplash = this.myFirstKillTutorial;
               contentAnchor = GameInfo.getStageCoordForAnchorAndOffset(GameInfo.BOTTOM_RIGHT,new Point(-112,-421));
               this.mCurrentSplash.externalTitleRevealCallback = this.myKillstreakAnimatedLines.active;
               this.showInGameSplash(DictUITutorial.ONBOARDING_UI_TOUR_IN_GAME_FIRST_KILL,contentAnchor);
               break;
            case UITutorialFlags.UI_TUTORIAL_IN_GAME_FIRST_KILLSTREAK:
               this.mCurrentSplash = this.myFirstKillstreakTutorial;
               contentAnchor = GameInfo.getStageCoordForAnchorAndOffset(GameInfo.BOTTOM_RIGHT,new Point(-112,-421));
               this.mCurrentSplash.externalTitleRevealCallback = this.myKillstreakAnimatedLines.active;
               this.showInGameSplash(DictUITutorial.ONBOARDING_UI_TOUR_IN_GAME_FIRST_KILLSTREAK,contentAnchor);
               break;
            case UITutorialFlags.UI_TUTORIAL_IN_GAME_CALL_IN_PREDATOR:
               this.showInGameTutorial(DictUITutorial.ONBOARDING_UI_TOUR_IN_GAME_CALL_IN_PREDATOR);
               this.mTimeout = setTimeout(this.showInGameTutorial,3500,DictUITutorial.ONBOARDING_UI_TOUR_IN_GAME_KILL_ENEMIES_WITH_PREDATOR,"+actionslot 2");
               break;
            case UITutorialFlags.UI_TUTORIAL_IN_GAME_KILL_ENEMIES_WITH_PREDATOR:
               this.myIngameTutorial.forceOpenObjectiveWindow = true;
               this.showInGameTutorial(DictUITutorial.ONBOARDING_UI_TOUR_IN_GAME_KILL_ENEMIES_WITH_PREDATOR,"+attack");
               break;
            case UITutorialFlags.UI_TUTORIAL_IN_GAME_DAMAGE:
               this.showInGameTutorial(DictUITutorial.ONBOARDING_UI_TOUR_IN_GAME_DAMAGE);
               break;
            case UITutorialFlags.UI_TUTORIAL_IN_GAME_KILL:
               this.showInGameTutorial(DictUITutorial.ONBOARDING_UI_TOUR_IN_GAME_KILL);
               break;
            case UITutorialFlags.UI_TUTORIAL_IN_GAME_ADS:
               this.myIngameTutorial.setObjectiveWindowOverrideMsg(DictUITutorial.ONBOARDING_UI_TOUR_IN_GAME_ADS_ELIMINATE_ENEMIES,"input_key_mouse2_icon");
               this.showInGameTutorial(DictUITutorial.ONBOARDING_UI_TOUR_IN_GAME_ADS,"+toggleads_throw");
               break;
            case UITutorialFlags.UI_TUTORIAL_IN_GAME_CALL_IN_HELICOPTER:
               this.showInGameTutorial(DictUITutorial.ONBOARDING_UI_TOUR_IN_GAME_CALL_IN_HELICOPTER,"+actionslot 3");
               break;
            case UITutorialFlags.UI_TUTORIAL_IN_GAME_ELIMINATE_FORCES:
               this.mCurrentSplash.hide();
               this.myIngameTutorial.forceOpenObjectiveWindow = true;
               this.showInGameTutorial(DictUITutorial.ONBOARDING_UI_TOUR_IN_GAME_ELIMINATE_FORCES_PT2);
               break;
            case UITutorialFlags.UI_TUTORIAL_IN_GAME_COURSE:
               this.showInGameTutorial(DictUITutorial.FIRINGRANGE_COURSE);
               break;
            case UITutorialFlags.UI_TUTORIAL_IN_GAME_CQB:
               this.showInGameTutorial(DictUITutorial.FIRINGRANGE_CQB);
               break;
            case UITutorialFlags.UI_TUTORIAL_IN_GAME_CHOOSE:
               this.showInGameTutorial(DictUITutorial.FIRINGRANGE_CHOOSE);
         }
      }
      
      private function showInGameSplash(topic:String, anchor:Point, alignRight:Boolean = true) : void
      {
         this.mCurrentSplash.title = topic;
         this.mCurrentSplash.myFrame.x = anchor.x;
         this.mCurrentSplash.myFrame.y = anchor.y;
         if(alignRight)
         {
            this.mCurrentSplash.myTopicArrow.x = this.mCurrentSplash.myFrame.x - UITutorialTourBase.CONTENT_PADDING;
            this.mCurrentSplash.myTopicArrow.y = this.mCurrentSplash.myFrame.y + 105;
            this.mCurrentSplash.myTitleTF.x = this.mCurrentSplash.myTopicArrow.x - UITutorialTourBase.ARROW_BASE_HEIGHT - this.mCurrentSplash.myTitleTF.width;
            this.mCurrentSplash.myTitleTF.y = this.mCurrentSplash.myTopicArrow.y + 30;
         }
         else
         {
            this.mCurrentSplash.myTopicArrow.x = this.mCurrentSplash.myFrame.x - UITutorialTourBase.CONTENT_PADDING;
            this.mCurrentSplash.myTopicArrow.y = this.mCurrentSplash.myFrame.y + (this.mCurrentSplash.myFrame.height - this.mCurrentSplash.myTopicArrow.width);
            this.mCurrentSplash.myTitleTF.x = anchor.x + this.mCurrentSplash.myFrame.width + UITutorialTourBase.ARROW_BASE_HEIGHT;
            this.mCurrentSplash.myTitleTF.y = anchor.y + 30;
         }
         this.myIngameTutorial.hide();
         this.mCurrentSplash.show();
      }
      
      private function showInGameTutorial(topic:String, icon:String = null) : void
      {
         if(this.mTimeout != -1)
         {
            clearTimeout(this.mTimeout);
            this.mTimeout = -1;
         }
         if(this.mCurrentSplash != null)
         {
            this.mCurrentSplash.hide();
         }
         this.myIngameTutorial.hide();
         this.myIngameTutorial.title = topic;
         this.myIngameTutorial.setIcon(icon);
         this.myIngameTutorial.show();
      }
      
      public function hideAllTours() : void
      {
         var displayObj:DisplayObject = null;
         var len:uint = uint(this.numChildren);
         for(var i:uint = 0; i < len; )
         {
            displayObj = this.getChildAt(i);
            if(displayObj is UITutorialTourBase)
            {
               UITutorialTourBase(displayObj).hide();
            }
            i++;
         }
      }
   }
}

