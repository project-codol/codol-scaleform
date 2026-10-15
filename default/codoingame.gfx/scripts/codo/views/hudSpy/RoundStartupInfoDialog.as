package codo.views.hudSpy
{
   import codo.common.CFunctionInGameContainer;
   import codo.component.ContentContainer;
   import codo.constants.SpyModeRoleType;
   import codo.localization.DictHud;
   import codo.objects.SpyModeSkillObj;
   import codo.shared.hud.SpyRoleSkillImage;
   import codo.utils.LocalizeUtil;
   import codo.utils.SpyUtil;
   import flash.display.MovieClip;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.utils.Timer;
   import fsg.util.FsgImageHolder;
   
   public class RoundStartupInfoDialog extends MovieClip
   {
      
      private static const CONTAINER_HEIGHT:int = 614;
      
      private static const CONTAINER_WIDTH:int = 550;
      
      private static const CLOSE_TIMER_TICK:int = 1000;
      
      private static const CLOSE_DELAY_TIME:int = 5;
      
      private static const GAME_INFO_TYPE_ROLE_PICK:int = 0;
      
      private static const GAME_INFO_TYPE_CASUAL_ROUND:int = 1;
      
      private static const SPY_DESC_LABEL_Y_POS:int = 345;
      
      private static const SPY_DESC_Y_POS:int = 375;
      
      private static const CIVILIAN_DESC_LABEL_Y_POS:int = 390;
      
      private static const CIVILIAN_DESC_Y_POS:int = 430;
      
      private static const SKILL_ICON_LEFT_POS:int = 31;
      
      private static const SKILL_ICON_RIGHT_POS:int = 519;
      
      private static const SKILL_ICON_WIDTH:int = 52;
      
      private static const SKILL_ICON_Y_ANCHOR:int = 523;
      
      private static const SKILL_ICON_SPACE_WIDTH:int = SKILL_ICON_RIGHT_POS - SKILL_ICON_LEFT_POS;
      
      public var myContainer:ContentContainer;
      
      public var myTitle:TextField;
      
      public var myText:TextField;
      
      public var myRoleIcon:MovieClip;
      
      public var myDesc:TextField;
      
      public var mySkillsLabel:TextField;
      
      public var myRoleDescLabel:TextField;
      
      public var myTimeLeft:TextField;
      
      private var mSkills:Array;
      
      private var mTimer:Timer;
      
      private var mTimeCounter:int;
      
      public function RoundStartupInfoDialog()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this.myContainer.myContainer.gotoAndStop(7);
         this.myContainer.width = CONTAINER_WIDTH;
         this.myContainer.height = CONTAINER_HEIGHT;
         this.myRoleDescLabel.text = LocalizeUtil.localize(DictHud.SPY_ROLE_DESC_LABEL);
         this.mySkillsLabel.text = LocalizeUtil.localize(DictHud.SPY_ROLE_SKILLS_LABEL);
         this.mTimer = new Timer(CLOSE_TIMER_TICK);
         this.mTimer.addEventListener(TimerEvent.TIMER,this.handleCloseDialogTimerEvent);
         this.mSkills = [];
      }
      
      private function handleCloseDialogTimerEvent(evt:TimerEvent) : void
      {
         if(--this.mTimeCounter <= 0)
         {
            this.mTimer.stop();
            this.close();
         }
         this.myTimeLeft.text = this.mTimeCounter.toString();
      }
      
      private function close() : void
      {
         CFunctionInGameContainer.AS_SpyCloseRoundStartup();
      }
      
      public function show(data:Object) : void
      {
         var skillsArr:Vector.<SpyModeSkillObj> = null;
         var j:int = 0;
         var numSkills:int = 0;
         var numGap:int = 0;
         var gapWidth:int = 0;
         var nextIconPos:int = 0;
         var i:int = 0;
         var skill:FsgImageHolder = null;
         var k:int = 0;
         var infoType:int = int(data.type);
         if(infoType == GAME_INFO_TYPE_ROLE_PICK)
         {
            this.myRoleIcon.visible = true;
            this.myText.visible = true;
            this.myTitle.text = LocalizeUtil.localize(DictHud.SPY_IDENTITY_IDENTIFIED_LABEL);
            this.myText.text = LocalizeUtil.param(DictHud.SPY_IDENTITY_IDENTIFIED,[LocalizeUtil.localize("@" + data.name)]);
            this.myText.textColor = SpyUtil.getRoleColor(data.role);
            this.myDesc.text = LocalizeUtil.localize("@" + data.desc);
            this.myRoleIcon.gotoAndStop(data.role);
            skillsArr = data.skills as Vector.<SpyModeSkillObj>;
            for(j = 0; j < this.mSkills.length; j++)
            {
               this.removeChild(this.mSkills[j]);
            }
            this.mSkills = [];
            numSkills = int(skillsArr.length);
            this.mySkillsLabel.visible = skillsArr.length != 0;
            if(numSkills > 0)
            {
               numGap = numSkills;
               gapWidth = (SKILL_ICON_SPACE_WIDTH - numSkills * SKILL_ICON_WIDTH) / numGap;
               nextIconPos = SKILL_ICON_LEFT_POS + gapWidth / 2;
               for(i = 0; i < skillsArr.length; i++)
               {
                  skill = new SpyRoleSkillImage();
                  skill.setImage(skillsArr[i].icon);
                  this.addChild(skill);
                  skill.x = nextIconPos;
                  nextIconPos += SKILL_ICON_WIDTH + gapWidth;
                  skill.y = SKILL_ICON_Y_ANCHOR;
                  this.mSkills.push(skill);
               }
            }
            if(data.role == SpyModeRoleType.SPY_ROLE_CIVILIAN)
            {
               this.myRoleDescLabel.y = CIVILIAN_DESC_LABEL_Y_POS;
               this.myDesc.y = CIVILIAN_DESC_Y_POS;
            }
            else
            {
               this.myRoleDescLabel.y = SPY_DESC_LABEL_Y_POS;
               this.myDesc.y = SPY_DESC_Y_POS;
            }
         }
         else
         {
            this.mySkillsLabel.visible = false;
            this.myRoleIcon.gotoAndStop(data.role);
            this.myTitle.text = LocalizeUtil.localize("@" + data.name);
            this.myRoleDescLabel.text = LocalizeUtil.localize(DictHud.SPY_ROUND_DESC_LABEL);
            this.myText.text = SpyUtil.getLocalizedRoleName(data.role);
            this.myText.textColor = SpyUtil.getRoleColor(data.role);
            this.myRoleDescLabel.y = CIVILIAN_DESC_LABEL_Y_POS;
            this.myDesc.y = CIVILIAN_DESC_Y_POS;
            this.myDesc.text = LocalizeUtil.localize("@" + data.desc);
            for(k = 0; k < this.mSkills.length; k++)
            {
               this.removeChild(this.mSkills[k]);
            }
            this.mSkills = [];
         }
         this.visible = true;
         this.mTimeCounter = CLOSE_DELAY_TIME;
         this.myTimeLeft.text = this.mTimeCounter.toString();
         this.mTimer.reset();
         this.mTimer.start();
         this.myTimeLeft.visible = false;
      }
      
      public function hide() : void
      {
         this.visible = false;
         if(this.mTimer.running)
         {
            this.mTimer.stop();
         }
      }
   }
}

