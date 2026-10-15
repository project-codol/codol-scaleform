package codo.component.career
{
   import codo.component.Button;
   import codo.component.TextField;
   import codo.component.core.UIInteractiveComponent;
   import codo.component.onboarding.OnboardingChallengesCheckbox;
   import codo.constants.BCEvent;
   import codo.interfaces.IDisposable;
   import codo.localization.Dict;
   import codo.manager.EventManager;
   import codo.objects.ChallengeBaseObj;
   import codo.objects.ChallengeRewardObj;
   import codo.objects.DailyChallengeChecklistObj;
   import codo.objects.DailyChallengeObj;
   import codo.objects.DailyChallengeRewardObj;
   import codo.objects.OnboardingCheckboxObj;
   import codo.objects.OnboardingChecklistObj;
   import codo.objects.ProductObj;
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   import codo.utils.LocalizeUtil;
   import codo.utils.Logger;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.getDefinitionByName;
   
   public class ChallengeChecklistItem extends MovieClip implements IDisposable
   {
      
      private static const REWARD_HEIGHT:Number = 75;
      
      private static const GENERAL_MINIMUM_HEIGHT:Number = 87;
      
      private static const GAME_LOBBY_MINIMUM_HEIGHT:Number = 74;
      
      private static const GENERAL_LIST_HOLDER_Y_MARGIN:Number = 77;
      
      private static const GAME_LOBBY_LIST_HOLDER_Y_MARGIN:Number = 63;
      
      public var myListHolder:Sprite;
      
      public var myRewardHolder:Sprite;
      
      public var myRewardProgress:Sprite;
      
      public var myRewardProgressBG:Sprite;
      
      public var myBackground:Sprite;
      
      public var myReRollButton:Button;
      
      public var myLabel:TextField;
      
      public var myRefreshTime:TextField;
      
      public var myProgressBubble:TextBubble;
      
      public var myScale1:ChallengeProgressBarScale;
      
      public var myScale2:ChallengeProgressBarScale;
      
      public var myScale3:ChallengeProgressBarScale;
      
      public var myScale4:ChallengeProgressBarScale;
      
      private var mOnChallengeFocused:Function;
      
      private var mOnChallengeUnfocused:Function;
      
      private var mTimeLeft:int;
      
      private var mTimeLeftWatcher:Timer;
      
      private var myScales:Array;
      
      private var mShowHeaderLabel:Boolean = true;
      
      private var mBeGameLobbyView:Boolean = false;
      
      public function ChallengeChecklistItem()
      {
         super();
         this.myReRollButton.height = 41;
         this.myReRollButton.label = LocalizeUtil.localize(Dict.REROLL_CHALLENGE);
         this.myReRollButton.registerClickEvent(this.onReRollClicked);
         this.myReRollButton.visible = false;
         this.myRefreshTime.fontColor = 7633534;
         this.myRefreshTime.alignment = TextStyle.HALIGN_RIGHT;
         this.myRefreshTime.visible = false;
         this.myLabel.width = this.myBackground.width;
         this.myRefreshTime.width = this.myBackground.width;
         this.mTimeLeftWatcher = new Timer(1000);
         this.mTimeLeftWatcher.addEventListener(TimerEvent.TIMER,this.onTimeLeftWatcherKicked);
         this.myScales = [this.myScale1,this.myScale2,this.myScale3,this.myScale4];
         for(var i:int = 0; i < this.myScales.length; i++)
         {
            this.myScales[i].visible = false;
         }
      }
      
      public function registerCheckboxFocusEvent(func:Function) : void
      {
         this.mOnChallengeFocused = func;
      }
      
      public function registerCheckboxUnfocusEvent(func:Function) : void
      {
         this.mOnChallengeUnfocused = func;
      }
      
      private function onTimeLeftWatcherKicked(event:TimerEvent) : void
      {
         --this.mTimeLeft;
         if(this.mTimeLeft < 0)
         {
            this.mTimeLeft = 24 * 60 * 60;
            EventManager.getInstance().broadcast(BCEvent.EVT_REFRESH_CHALLENGES);
         }
      }
      
      public function setData(data:OnboardingChecklistObj) : void
      {
         var challenge:ChallengeBaseObj = null;
         var item:OnboardingChallengesCheckbox = null;
         var nextItem:OnboardingChallengesCheckbox = null;
         var progress:String = null;
         var checkboxData:OnboardingCheckboxObj = null;
         var prodObj:ProductObj = null;
         var claimIcon:Sprite = null;
         var dailyChallengeReward:DailyChallengeRewardObj = null;
         var progressBarArrow:ChallengeChecklistRewardArrow = null;
         var challengeReward:ChallengeRewardObj = null;
         var rewardClip:UIInteractiveComponent = null;
         var veteranReward:ChallengeChecklistVeteranReward = null;
         var scoreEarned:int = 0;
         var maxScore:int = 0;
         var score:int = 0;
         var fillEnd:Number = 0;
         var fillTotal:Number = 0;
         var challenges:Array = data.challenges;
         var len:int = int(challenges.length);
         var i:int = 0;
         var cls:Class = getDefinitionByName("codo.shared.career.ChallengesCheckbox") as Class;
         var listHeight:int = 0;
         var foundHighlightChallenge:Boolean = false;
         var completionCount:int = 0;
         for(var dailyChallengeRewardScores:Array = []; i < len; )
         {
            challenge = challenges[i];
            if(challenge == null)
            {
               Logger.print("challenge object is null for " + data.name + " with index " + i.toString());
               break;
            }
            fillEnd += challenge.progress / challenge.target;
            fillTotal += 1;
            if(challenge.target > 1)
            {
               progress = challenge.progress.toString().concat("/",challenge.target.toString());
            }
            else
            {
               progress = null;
            }
            checkboxData = new OnboardingCheckboxObj();
            checkboxData.name = challenge.name;
            checkboxData.finished = challenge.getFinished();
            checkboxData.animateIn = false;
            checkboxData.progress = progress;
            checkboxData.challenge = challenge;
            if(challenge is DailyChallengeObj)
            {
               checkboxData.tag = (challenge as DailyChallengeObj).score.toString();
            }
            if(checkboxData.finished)
            {
               completionCount++;
            }
            item = this.myListHolder.addChild(new cls()) as OnboardingChallengesCheckbox;
            item.registerFocusEvent(this.mOnChallengeFocused,item);
            item.registerUnfocusEvent(this.mOnChallengeUnfocused,item);
            item.setData(checkboxData);
            listHeight += item.height;
            if(i > 0)
            {
               nextItem = this.myListHolder.getChildAt(i - 1) as OnboardingChallengesCheckbox;
               item.y = nextItem.y + nextItem.height;
            }
            if(!foundHighlightChallenge && data[i] != null)
            {
               if(!challenge.getFinished())
               {
                  foundHighlightChallenge = true;
                  item.myLabel.textColor = GlobalGuide.CODO_COLOR_HIGHLIGHT_ORANGE;
                  item.myValue.textColor = GlobalGuide.CODO_COLOR_HIGHLIGHT_ORANGE;
                  break;
               }
            }
            i++;
         }
         if(this.mBeGameLobbyView)
         {
            this.myRewardHolder.y = GAME_LOBBY_LIST_HOLDER_Y_MARGIN;
            this.myListHolder.y = GAME_LOBBY_LIST_HOLDER_Y_MARGIN;
         }
         else
         {
            this.myRewardHolder.y = GENERAL_LIST_HOLDER_Y_MARGIN;
            this.myListHolder.y = GENERAL_LIST_HOLDER_Y_MARGIN;
         }
         var curY:Number = 0;
         len = int(data.rewards.length);
         for(i = 0; i < len; i++)
         {
            challengeReward = data.rewards[i];
            if(challengeReward.type == ChallengeRewardObj.REWARD_TYPE_GP)
            {
               cls = getDefinitionByName("codo.shared.career.ChallengeChecklistGPReward") as Class;
               rewardClip = new cls();
               this.myRewardHolder.addChild(rewardClip);
               rewardClip.setData(challengeReward);
               rewardClip.y = curY;
               curY += REWARD_HEIGHT;
            }
            else if(challengeReward.type == ChallengeRewardObj.REWARD_TYPE_ITEM || challengeReward.type == ChallengeRewardObj.REWARD_TYPE_PRODUCT)
            {
               cls = getDefinitionByName("codo.shared.career.ChallengeChecklistItemRewardOld") as Class;
               rewardClip = new cls();
               this.myRewardHolder.addChild(rewardClip);
               rewardClip.setData(challengeReward);
               rewardClip.y = curY;
               curY += REWARD_HEIGHT;
            }
            if(challengeReward is DailyChallengeRewardObj && rewardClip != null)
            {
               dailyChallengeReward = challengeReward as DailyChallengeRewardObj;
               dailyChallengeRewardScores.push(dailyChallengeReward.score);
               if(dailyChallengeReward.score > (data as DailyChallengeChecklistObj).scoreEarned)
               {
                  cls = getDefinitionByName("codo.shared.career.ChallengeChecklistRewardArrow") as Class;
                  progressBarArrow = new cls();
                  progressBarArrow.setData(dailyChallengeReward.score.toString());
                  progressBarArrow.y = rewardClip.y + this.myRewardHolder.y + progressBarArrow.height / 2;
                  progressBarArrow.x = -10;
                  this.addChildAt(progressBarArrow,this.getChildIndex(this.myProgressBubble) - 1);
               }
            }
         }
         this.myLabel.text = data.name;
         if(data.isVeteran)
         {
            this.myProgressBubble.visible = false;
            this.myRewardProgress.visible = false;
            cls = getDefinitionByName("codo.shared.career.ChallengeChecklistVeteranReward") as Class;
            veteranReward = new cls() as ChallengeChecklistVeteranReward;
            this.myRewardHolder.addChild(veteranReward);
            veteranReward.y = curY;
            curY += veteranReward.height;
         }
         this.mTimeLeftWatcher.reset();
         if(Boolean(data.timeLeft))
         {
            this.mTimeLeft = data.timeLeft;
            this.mTimeLeftWatcher.start();
         }
         if(Boolean(data.refreshTime) && this.mShowHeaderLabel)
         {
            this.myRefreshTime.text = data.refreshTime;
            this.myRefreshTime.x = this.myBackground.x + this.myBackground.width - this.myRefreshTime.width - 10;
            this.myRefreshTime.visible = true;
         }
         this.showReRoll(data.canReRoll);
         if(this.mBeGameLobbyView)
         {
            this.myBackground.height = Math.max(listHeight,curY + 10) + GAME_LOBBY_MINIMUM_HEIGHT;
         }
         else
         {
            this.myBackground.height = Math.max(listHeight,curY + 10) + GENERAL_MINIMUM_HEIGHT;
         }
         if(data is DailyChallengeChecklistObj)
         {
            scoreEarned = (data as DailyChallengeChecklistObj).scoreEarned;
            maxScore = dailyChallengeRewardScores.length > 0 ? int(dailyChallengeRewardScores[0]) : 1;
            if(maxScore < scoreEarned)
            {
               scoreEarned = maxScore;
            }
            for(i = 0; i < dailyChallengeRewardScores.length; i++)
            {
               score = int(dailyChallengeRewardScores[i]);
               if(score > scoreEarned)
               {
                  this.myScales[i].text = score.toString();
                  this.myScales[i].visible = true;
                  this.myScales[i].x = this.myRewardProgressBG.x + this.myRewardProgressBG.width * (Number(score) / Number(maxScore));
                  if(this.myScales[i].x > this.myRewardProgressBG.x + this.myRewardProgressBG.width - this.myScales[i].width / 2)
                  {
                     this.myScales[i].x = this.myRewardProgressBG.x + this.myRewardProgressBG.width - this.myScales[i].width / 2;
                  }
               }
            }
            this.myProgressBubble.text = scoreEarned.toString();
            this.updateProgress(maxScore == 0 ? 1 : scoreEarned / maxScore);
         }
         else
         {
            this.updateProgress(completionCount / fillTotal);
            this.myProgressBubble.text = completionCount.toString() + "/" + challenges.length.toString();
         }
      }
      
      public function showReRoll(show:Boolean) : void
      {
         this.myReRollButton.visible = show;
      }
      
      override public function get height() : Number
      {
         return this.myBackground.height;
      }
      
      override public function get width() : Number
      {
         return this.myBackground.width;
      }
      
      private function updateProgress(progress:Number) : void
      {
         this.myRewardProgress.width = this.myRewardProgressBG.width * progress;
         this.myProgressBubble.x = this.myRewardProgress.width + this.myRewardProgress.x - this.myProgressBubble.width;
         if(this.myProgressBubble.x < this.myRewardProgress.x)
         {
            this.myProgressBubble.x = this.myRewardProgress.x;
         }
         var len:int = this.myListHolder.numChildren;
         for(var i:int = 0; i < len; i++)
         {
            OnboardingChallengesCheckbox(this.myListHolder.getChildAt(i)).animateIn(0,false);
         }
      }
      
      private function onReRollClicked() : void
      {
      }
      
      public function dispose() : void
      {
         this.mTimeLeftWatcher.reset();
         this.mTimeLeftWatcher.removeEventListener(TimerEvent.TIMER,this.onTimeLeftWatcherKicked);
      }
      
      public function set showHeaderLabel(beShow:Boolean) : void
      {
         this.mShowHeaderLabel = beShow;
      }
      
      public function set isGameLobbyView(isGameLobbyView:Boolean) : void
      {
         this.mBeGameLobbyView = isGameLobbyView;
      }
   }
}

