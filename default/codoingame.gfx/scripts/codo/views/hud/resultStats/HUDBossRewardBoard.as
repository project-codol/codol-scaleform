package codo.views.hud.resultStats
{
   import codo.localization.DictRoom;
   import codo.style.GlobalGuide;
   import codo.utils.LocalizeUtil;
   import codo.utils.Logger;
   import codo.utils.SoundUtil;
   import codo.utils.TableUtil;
   import com.greensock.TweenLite;
   import com.greensock.easing.Back;
   import com.greensock.easing.Circ;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class HUDBossRewardBoard extends MovieClip
   {
      
      private static const BOSS_INFO:Object = {
         "5001":{"frame":1},
         "5002":{"frame":2},
         "5003":{"frame":3},
         "5004":{"frame":4},
         "5005":{"frame":5},
         "5006":{"frame":6},
         "5007":{"frame":7},
         "5008":{"frame":8}
      };
      
      private static const BOSS_REWARD_TABLE:String = "mp/zhunt_reward_crates_info.csv";
      
      private static const BOSS_REWARD_COLUMN_ID:int = 0;
      
      private static const BOSS_REWARD_COLUMN_PART:int = 1;
      
      private static const BOSS_REWARD_COLUMN_LABEL:int = 3;
      
      private static const BOSS_REWARD_COLUMN_ICON:int = 4;
      
      private static const BOSS_KILL_REWARD_SUFFIX_SIZE:int = 32;
      
      private static const BOSS_GOAL_REWARD_SUFFIX_SIZE:int = 30;
      
      private static const BOX_OPENED_FRAME:int = 1;
      
      private static const BOX_CLOSED_FRAME:int = 2;
      
      private static const BOX_LABEL_COLOR:uint = 15003350;
      
      private static const ANIMATE_STAGE_BOSS_APPEAR:int = 0;
      
      private static const ANIMATE_STAGE_TITLE_APPEAR:int = 1;
      
      private static const ANIMATE_STAGE_BOSS_BOX_APPEAR:int = 2;
      
      private static const ANIMATE_STAGE_PART_BOX_APPEAR:int = 3;
      
      private static const ANIMATE_STAGE_END:int = 4;
      
      private static const ANIMATE_OFFSET:Number = 500;
      
      private static const ANIMATE_DELAY:Number = 0.3;
      
      private static const ANIMATE_DUR:Number = 0.5;
      
      public var myTitle:TextField;
      
      public var myBoss:MovieClip;
      
      public var mDifficulty:int;
      
      public var mAbleToGetReward:Boolean;
      
      private var myRewardBoxs:Array;
      
      private var myRewardBoxNum:Number;
      
      private var myGoals:Array;
      
      private var myCallbackOnAnimationComplete:Function;
      
      public function HUDBossRewardBoard()
      {
         var box:DisplayObject = null;
         super();
         this.myRewardBoxs = new Array();
         for(var i:int = 0; true; i++)
         {
            box = getChildByName("myRewardBox".concat(i));
            if(box == null)
            {
               break;
            }
            this.myRewardBoxs.push(box);
         }
         this.myRewardBoxNum = 0;
         this.mDifficulty = 0;
         this.mAbleToGetReward = true;
      }
      
      public function set bossName(name:String) : void
      {
         this.myTitle.text = LocalizeUtil.replaceConversionString(LocalizeUtil.localize("@MATCH_RESULTS_BOSS_DEFEATED"),[LocalizeUtil.localize("@" + name)]);
      }
      
      public function set bossID(id:String) : void
      {
         var goal:DisplayObject = null;
         var bossInfo:Object = BOSS_INFO[id];
         if(bossInfo != null)
         {
            this.myBoss.gotoAndStop(bossInfo.frame);
            this.buildBossRewardBoxInfo(id);
            this.myGoals = new Array();
            for(var i:int = 0; true; i++)
            {
               goal = this.myBoss.getChildByName("myGoal".concat(i));
               if(goal == null)
               {
                  break;
               }
               goal.visible = false;
               this.myGoals.push(goal);
            }
            return;
         }
         Logger.print("[ZHunt][HUD]ERROR-Unrecognized boss" + id);
      }
      
      public function set rewards(rewardIndexes:Array) : void
      {
         var index:int = 0;
         var i:int = 0;
         var showReward:Boolean = false;
         var myLabel:TextField = null;
         var startIndex:int = 0;
         var textFormat:TextFormat = null;
         if(this.myGoals == null || this.myGoals.length == 0)
         {
            return;
         }
         for each(index in rewardIndexes)
         {
            this.myGoals[index - 1].visible = true;
            this.myGoals[index - 1].alpha = 0;
         }
         for(i = 0; i < this.myRewardBoxs.length; i++)
         {
            if(i > this.myGoals.length)
            {
               break;
            }
            showReward = this.mAbleToGetReward;
            if(i > 0)
            {
               showReward &&= Boolean(this.myGoals[i - 1].visible);
            }
            this.myRewardBoxs[i].myBoxIcon.visible = showReward;
            this.myRewardBoxs[i].myLabel.textColor = showReward ? BOX_LABEL_COLOR : GlobalGuide.BLACK;
            this.myRewardBoxs[i].gotoAndStop(showReward ? BOX_OPENED_FRAME : BOX_CLOSED_FRAME);
            myLabel = this.myRewardBoxs[i].myLabel;
            myLabel.appendText(" ");
            startIndex = myLabel.text.length;
            if(this.mDifficulty >= 2)
            {
               myLabel.appendText("[" + LocalizeUtil.localize(DictRoom.ROOM_LEVELS[this.mDifficulty]) + "]");
            }
            textFormat = myLabel.getTextFormat(startIndex);
            textFormat.size = i == 0 ? BOSS_KILL_REWARD_SUFFIX_SIZE : BOSS_GOAL_REWARD_SUFFIX_SIZE;
            textFormat.color = GlobalGuide.BLACK;
            myLabel.setTextFormat(textFormat,startIndex);
         }
      }
      
      public function startAnimation(onComplete:Function) : void
      {
         this.myCallbackOnAnimationComplete = onComplete;
         this.myTitle.visible = false;
         for(var i:int = 0; i < this.myRewardBoxNum; i++)
         {
            this.myRewardBoxs[i].visible = false;
         }
         this.playAnimateStage(ANIMATE_STAGE_BOSS_APPEAR);
      }
      
      private function playAnimateStage(stage:int) : void
      {
         var bossBoxIcon:MovieClip = null;
         var partBoxStageTime:Number = NaN;
         var i:int = 0;
         var partBoxSound:String = null;
         var stageTimeCost:Number = NaN;
         switch(stage)
         {
            case ANIMATE_STAGE_BOSS_APPEAR:
               this.myBoss.alpha = 0;
               TweenLite.to(this.myBoss,ANIMATE_DUR,{
                  "alpha":1,
                  "ease":Circ.easeIn
               });
               this.setNextAnimateStage(ANIMATE_STAGE_TITLE_APPEAR,0.3);
               break;
            case ANIMATE_STAGE_TITLE_APPEAR:
               this.myTitle.visible = true;
               this.tweenIntro(this.myTitle,ANIMATE_DUR,{"x":ANIMATE_OFFSET});
               SoundUtil.getInstance().playSound("zh_boss_endui_left_appear");
               this.setNextAnimateStage(ANIMATE_STAGE_BOSS_BOX_APPEAR,0.2);
               break;
            case ANIMATE_STAGE_BOSS_BOX_APPEAR:
               this.myRewardBoxs[0].visible = true;
               bossBoxIcon = this.myRewardBoxs[0].myBoxIcon;
               bossBoxIcon.scaleX = bossBoxIcon.scaleY = 0.1;
               this.tweenIntro(bossBoxIcon,ANIMATE_DUR * 2,{
                  "x":240,
                  "y":151,
                  "scaleX":1,
                  "scaleY":1,
                  "ease":Back.easeInOut
               });
               this.tweenIntro(this.myRewardBoxs[0],ANIMATE_DUR,{
                  "x":ANIMATE_OFFSET,
                  "y":0,
                  "delay":0.1
               });
               this.setNextAnimateStage(ANIMATE_STAGE_PART_BOX_APPEAR,0.4);
               break;
            case ANIMATE_STAGE_PART_BOX_APPEAR:
               partBoxStageTime = 0;
               for(i = 1; i < this.myRewardBoxNum; i++)
               {
                  this.myRewardBoxs[i].visible = true;
                  partBoxSound = "zh_boss_endui_right_appear_empty";
                  stageTimeCost = 0;
                  if(Boolean(this.myGoals[i - 1].visible))
                  {
                     TweenLite.to(this.myGoals[i - 1],ANIMATE_DUR,{
                        "delay":partBoxStageTime + 0.1,
                        "alpha":1,
                        "ease":Circ.easeOut
                     });
                     stageTimeCost = 0.2;
                  }
                  bossBoxIcon = this.myRewardBoxs[i].myBoxIcon;
                  if(bossBoxIcon.visible)
                  {
                     partBoxSound = "zh_boss_endui_right_appear_full";
                     bossBoxIcon.scaleX = bossBoxIcon.scaleY = 0.2;
                     this.tweenIntro(bossBoxIcon,ANIMATE_DUR * 2,{
                        "x":-160,
                        "y":60,
                        "scaleX":1,
                        "scaleY":1,
                        "delay":partBoxStageTime,
                        "ease":Back.easeInOut
                     });
                     TweenLite.delayedCall(partBoxStageTime,SoundUtil.getInstance().playSound,["zh_boss_endui_damage_01"]);
                     stageTimeCost = 0.2;
                  }
                  partBoxStageTime += stageTimeCost;
                  this.tweenIntro(this.myRewardBoxs[i],ANIMATE_DUR,{
                     "x":-ANIMATE_OFFSET,
                     "delay":partBoxStageTime + 0.1,
                     "onComplete":SoundUtil.getInstance().playSound,
                     "onCompleteParams":[partBoxSound]
                  });
                  partBoxStageTime += ANIMATE_DUR;
               }
               this.setNextAnimateStage(ANIMATE_STAGE_END,partBoxStageTime);
               break;
            case ANIMATE_STAGE_END:
               if(this.myCallbackOnAnimationComplete != null)
               {
                  this.myCallbackOnAnimationComplete();
               }
         }
      }
      
      private function setNextAnimateStage(stage:int, delay:Number) : void
      {
         TweenLite.delayedCall(delay,this.playAnimateStage,[stage]);
      }
      
      private function buildBossRewardBoxInfo(id:String) : void
      {
         var rewardBox:Object = null;
         var rowCount:int = 0;
         var row:int = 0;
         for each(rewardBox in this.myRewardBoxs)
         {
            rewardBox.visible = false;
         }
         rowCount = TableUtil.getRowCount(BOSS_REWARD_TABLE);
         this.myRewardBoxNum = 0;
         for(row = 0; row < rowCount; row++)
         {
            if(TableUtil.getValue(BOSS_REWARD_TABLE,row,BOSS_REWARD_COLUMN_ID) == id)
            {
               rewardBox = this.myRewardBoxs[int(TableUtil.getValue(BOSS_REWARD_TABLE,row,BOSS_REWARD_COLUMN_PART))];
               rewardBox.visible = true;
               rewardBox.myLabel.text = LocalizeUtil.localize("@" + TableUtil.getValue(BOSS_REWARD_TABLE,row,BOSS_REWARD_COLUMN_LABEL));
               rewardBox.myBoxIcon.setImage("scaleform_ash/miscicons/" + TableUtil.getValue(BOSS_REWARD_TABLE,row,BOSS_REWARD_COLUMN_ICON));
               ++this.myRewardBoxNum;
            }
         }
      }
      
      private function tweenIntro(target:Object, duration:Number, vars:Object) : void
      {
         target.x -= vars.x;
         vars.x = target.x + vars.x;
         target.y -= vars.y;
         vars.y = target.y + vars.y;
         TweenLite.to(target,duration,vars);
      }
   }
}

