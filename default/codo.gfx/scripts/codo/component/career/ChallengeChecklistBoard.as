package codo.component.career
{
   import codo.component.core.UIInteractiveComponent;
   import codo.component.factory.ButtonFactory;
   import codo.component.home.HomeChallengeListItem;
   import codo.constants.BCEvent;
   import codo.interfaces.IDisposable;
   import codo.manager.EventManager;
   import codo.objects.ChallengeBaseObj;
   import codo.objects.ChallengeRewardObj;
   import codo.objects.OnboardingChecklistObj;
   import codo.utils.Logger;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.utils.Timer;
   import flash.utils.getDefinitionByName;
   
   public class ChallengeChecklistBoard extends MovieClip implements IDisposable
   {
      
      private static const ITEM_MAX_NUM:int = 3;
      
      private static const REWARD_HEIGHT:Number = 64;
      
      private static const LIST_HOLDER_MARGIN:Number = 4;
      
      private static const GAMELOBBY_LIST_HOLDER_MARGIN:Number = 2;
      
      private static const GAMELOBBY_REWARD_SCALE:Number = 0.75;
      
      public var myListHolder:Sprite;
      
      public var myRewardHolder:Sprite;
      
      public var myBackground:Sprite;
      
      public var myHeaderBG:Sprite;
      
      public var myLabel:TextField;
      
      public var myRefreshTime:TextField;
      
      public var myRewardLabel:TextField;
      
      private var mTimeLeft:int;
      
      private var mTimeLeftWatcher:Timer;
      
      private var mShowHeaderLabel:Boolean = true;
      
      private var mBeGameLobbyView:Boolean = false;
      
      public function ChallengeChecklistBoard()
      {
         super();
         this.myRefreshTime.visible = false;
         this.myLabel.width = this.myBackground.width;
         this.mTimeLeftWatcher = new Timer(1000);
         this.mTimeLeftWatcher.addEventListener(TimerEvent.TIMER,this.onTimeLeftWatcherKicked);
      }
      
      public function set showHeaderLabel(beShow:Boolean) : void
      {
         this.mShowHeaderLabel = beShow;
      }
      
      public function set isGameLobbyView(isGameLobbyView:Boolean) : void
      {
         this.mBeGameLobbyView = isGameLobbyView;
      }
      
      override public function get height() : Number
      {
         return this.myBackground.height;
      }
      
      override public function get width() : Number
      {
         return this.myBackground.width;
      }
      
      public function setData(data:OnboardingChecklistObj) : void
      {
         var rewardIconScale:Number = NaN;
         var listMargin:Number = NaN;
         var rewardX:Number = NaN;
         var cls:Class = null;
         var rewardClip:UIInteractiveComponent = null;
         var challenge:ChallengeBaseObj = null;
         var item:HomeChallengeListItem = null;
         var challenges:Array = data.challenges;
         var listHeight:Number = 0;
         var i:int = 0;
         rewardIconScale = this.mBeGameLobbyView ? GAMELOBBY_REWARD_SCALE : 1;
         listMargin = this.mBeGameLobbyView ? GAMELOBBY_LIST_HOLDER_MARGIN : LIST_HOLDER_MARGIN;
         var rewards:Array = this.buildRewards(data.rewards);
         if(rewards != null)
         {
            rewardX = 0;
            for(i = 0; i < rewards.length; i++)
            {
               cls = getDefinitionByName("codo.shared.career.ChallengeChecklistItemReward") as Class;
               rewardClip = new cls() as UIInteractiveComponent;
               this.myRewardHolder.addChild(rewardClip);
               rewardClip.setData(rewards[i]);
               rewardClip.scaleX = rewardClip.scaleY = rewardIconScale;
               rewardClip.x = rewardX;
               rewardX += rewardClip.width;
            }
            this.myRewardLabel.visible = true;
            this.myRewardLabel.y = this.myRewardHolder.y + 0.5 * this.myRewardHolder.height - this.myRewardLabel.height;
            this.myListHolder.y = this.myRewardHolder.y + REWARD_HEIGHT * rewardIconScale + listMargin;
         }
         else
         {
            this.myRewardLabel.visible = false;
            this.myListHolder.y = this.myHeaderBG.y + this.myHeaderBG.height + listMargin;
         }
         i = 0;
         while(i < challenges.length && i < ITEM_MAX_NUM)
         {
            challenge = challenges[i];
            if(challenge == null)
            {
               Logger.print("challenge object is null for " + data.name + " with index " + i.toString());
               break;
            }
            item = ButtonFactory.BUILD_HOME_CHALLENGE_LIST_ITEM(HomeChallengeListItem.STYLE_SMALL);
            this.myListHolder.addChild(item);
            item.setData(challenge);
            item.y = listHeight;
            listHeight += item.height + listMargin;
            i++;
         }
         this.myLabel.text = data.name;
         this.mTimeLeftWatcher.reset();
         if(Boolean(data.timeLeft))
         {
            this.mTimeLeft = data.timeLeft;
            this.mTimeLeftWatcher.start();
         }
         if(Boolean(data.refreshTime) && this.mShowHeaderLabel)
         {
            this.myRefreshTime.text = data.refreshTime;
            this.myRefreshTime.visible = true;
         }
         this.myBackground.height = listHeight + this.myListHolder.y;
      }
      
      public function dispose() : void
      {
         this.mTimeLeftWatcher.reset();
         this.mTimeLeftWatcher.removeEventListener(TimerEvent.TIMER,this.onTimeLeftWatcherKicked);
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
      
      private function buildRewards(rewards:Array) : Array
      {
         var challengeReward:ChallengeRewardObj = null;
         if(rewards.length == 0)
         {
            return null;
         }
         var rebuiltRewards:Array = [];
         var xpReward:ChallengeRewardObj = new ChallengeRewardObj();
         xpReward.type = ChallengeRewardObj.REWARD_TYPE_XP;
         var gpReward:ChallengeRewardObj = new ChallengeRewardObj();
         gpReward.type = ChallengeRewardObj.REWARD_TYPE_GP;
         for(var i:int = 0; i < rewards.length; i++)
         {
            challengeReward = rewards[i];
            if(challengeReward.type == ChallengeRewardObj.REWARD_TYPE_ITEM || challengeReward.type == ChallengeRewardObj.REWARD_TYPE_PRODUCT)
            {
               rebuiltRewards.push(this.copyRewardItemInfo(challengeReward));
            }
            else if(challengeReward.type == ChallengeRewardObj.REWARD_TYPE_GP)
            {
               gpReward.entityInfo += challengeReward.entityInfo;
            }
            gpReward.entityInfo += challengeReward.gp;
            xpReward.entityInfo += challengeReward.xp;
         }
         if(gpReward.entityInfo > 0)
         {
            rebuiltRewards.push(gpReward);
         }
         if(xpReward.entityInfo > 0)
         {
            rebuiltRewards.push(xpReward);
         }
         return rebuiltRewards;
      }
      
      private function copyRewardItemInfo(src:ChallengeRewardObj) : ChallengeRewardObj
      {
         var ret:ChallengeRewardObj = new ChallengeRewardObj();
         ret.type = src.type;
         ret.entityId = src.entityId;
         ret.entityInfo = src.entityInfo;
         ret.entityDuration = src.entityDuration;
         ret.claimed = src.claimed;
         return ret;
      }
   }
}

