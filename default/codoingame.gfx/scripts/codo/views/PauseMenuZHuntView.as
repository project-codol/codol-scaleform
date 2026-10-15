package codo.views
{
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionInGameContainer;
   import codo.constants.BCEvent;
   import codo.constants.GameInfo;
   import codo.localization.Dict;
   import codo.localization.DictRoom;
   import codo.localization.DictZHunt;
   import codo.utils.LocalizeUtil;
   import codo.utils.PauseUtil;
   import codo.utils.ScaleformUtil;
   import codo.views.helpMenu_parts.zhunt.FsgHelpMenuZhuntPartReward;
   import codo.views.helpMenu_parts.zhunt.FsgHelpMenuZhuntReward;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.text.TextField;
   import fsg.shared.BehaviourAnimatedClickable;
   import fsg.shared.BehaviourAudio;
   import fsg.shared.BehaviourClickable;
   import fsg.util.FsgImageHolder;
   
   public class PauseMenuZHuntView extends FsgPauseMenuBaseView
   {
      
      public var myComposeRewardHintTF:TextField;
      
      public var myBossWeaknessHintTF:TextField;
      
      public var myShardReward1:FsgHelpMenuZhuntPartReward;
      
      public var myShardReward2:FsgHelpMenuZhuntPartReward;
      
      public var myShardReward3:FsgHelpMenuZhuntPartReward;
      
      public var myComposeReward1:FsgHelpMenuZhuntReward;
      
      public var myComposeReward2:FsgHelpMenuZhuntReward;
      
      public var myComposeReward3:FsgHelpMenuZhuntReward;
      
      public var myComposeReward4:FsgHelpMenuZhuntReward;
      
      public var myBossNameTF:TextField;
      
      public var myBossNameBg:MovieClip;
      
      public var myBossImage:FsgImageHolder;
      
      public var myKickBtn:MovieClip;
      
      private var mKickBehavior:BehaviourClickable;
      
      private var mKickAnimatedBehavior:BehaviourAnimatedClickable;
      
      private var mKickAudioBehavior:BehaviourAudio;
      
      private var mShardRewards:Array = [];
      
      private var mComposeRewards:Array = [];
      
      public function PauseMenuZHuntView()
      {
         super();
      }
      
      override protected function onInit() : void
      {
         super.onInit();
         this.myKickBtn.myComplainsTextTF.text = Dict.VOTE_KILL_PLAYER;
         this.mKickBehavior = new BehaviourClickable(this.myKickBtn.myHitArea);
         this.mKickAnimatedBehavior = new BehaviourAnimatedClickable(this.myKickBtn,this.mKickBehavior,1,2,2,3);
         this.mKickAudioBehavior = new BehaviourAudio(this.mKickBehavior);
         this.mKickBehavior.addClickCallback(this.onKickButtonClicked);
      }
      
      private function adaptToScreen() : void
      {
         var scale:Number = NaN;
         var scaledWidth:Number = NaN;
         this.scaleX = 1;
         this.scaleY = 1;
         this.myBossImage.x = 0;
         this.myBossImage.y = 0;
         var stageSize:Point = new Point(1280,960);
         var stagePosition:Point = new Point(0,0);
         if(ScaleformUtil.isScaleform)
         {
            stageSize = GameInfo.stageSize;
            stagePosition = GameInfo.stagePosition;
         }
         scale = stageSize.x / (1920 * scaleX);
         scaledWidth = this.width * scale;
         var scaledHeight:Number = this.height * scale;
         var yOff:Number = (1440 * scale - stageSize.y) / 2;
         this.x = stagePosition.x;
         this.y = stagePosition.y - yOff;
         this.width = scaledWidth;
         this.height = scaledHeight;
         mPopupOverlay.x = 0;
         mPopupOverlay.y = 0;
         mPopupOverlay.width = 1920 / scale;
         mPopupOverlay.height = 1440 / scale;
      }
      
      override protected function showView() : void
      {
         var i:int = 0;
         var reward:Object = null;
         super.showView();
         PauseUtil.hidePauseMap(true);
         myTitle.visible = false;
         myTabNavigation.visible = false;
         myOptions.gotoAndStop(2);
         this.adaptToScreen();
         refreshLayout();
         this.myBossWeaknessHintTF.text = DictZHunt.BOSS_WEAKNESS_HINT_TITLE;
         this.myComposeRewardHintTF.text = DictZHunt.SHARDS_COMPOSE_HINT_TITLE;
         myOptions.myBrightness.visible = false;
         this.mShardRewards = [this.myShardReward1,this.myShardReward2,this.myShardReward3];
         this.mComposeRewards = [this.myComposeReward1,this.myComposeReward2,this.myComposeReward3,this.myComposeReward4];
         var pauseMenuInfo:Object = CFunctionInGameContainer.AS_GetZHuntPauseMenuInfo();
         if(pauseMenuInfo == null)
         {
            return;
         }
         this.myBossImage.setImage(pauseMenuInfo.bossImage);
         this.myBossImage.x = pauseMenuInfo.bossX;
         this.myBossImage.y = pauseMenuInfo.bossY;
         this.myBossNameTF.text = "@" + pauseMenuInfo.bossName;
         this.myBossNameBg.visible = true;
         this.myBossNameBg.x = pauseMenuInfo.bossNameX;
         this.myBossNameBg.y = pauseMenuInfo.bossNameY;
         this.myBossNameTF.x = pauseMenuInfo.bossNameX + 35;
         this.myBossNameTF.y = pauseMenuInfo.bossNameY + 30;
         for(i = 0; i < this.mComposeRewards.length; i++)
         {
            this.mComposeRewards[i].visible = false;
         }
         for(i = 0; i < pauseMenuInfo.composeRewards.length; i++)
         {
            this.mComposeRewards[i].visible = true;
            this.mComposeRewards[i].icon = pauseMenuInfo.composeRewards[i].imageURL;
         }
         for(i = 0; i < this.mShardRewards.length; i++)
         {
            this.mShardRewards[i].visible = false;
            this.mShardRewards[i].isFinalBoss = false;
         }
         var difficulty:int = CFunctionCommonContainer.Dvar_GetInt("ui_playlist_difficulty");
         for(i = 0; i < pauseMenuInfo.shardsRwards.length; i++)
         {
            reward = pauseMenuInfo.shardsRwards[i];
            if(reward == null)
            {
               break;
            }
            this.mShardRewards[i].visible = true;
            this.mShardRewards[i].x = pauseMenuInfo.shardsX;
            this.mShardRewards[i].y = pauseMenuInfo.shardsY - 10;
            this.mShardRewards[i].title = LocalizeUtil.param(DictZHunt.WEAK_PART,[i + 1]) + LocalizeUtil.localize("@" + reward.weakPart);
            this.mShardRewards[i].icon = reward.rewardIcon;
            this.mShardRewards[i].rewardName = LocalizeUtil.localize("@" + reward.rewardName) + "[" + LocalizeUtil.localize(DictRoom.ROOM_LEVELS[difficulty]) + "]";
            if(difficulty < 2)
            {
               this.mShardRewards[i].rewardName = LocalizeUtil.localize("@" + reward.rewardName);
            }
            this.mShardRewards[i].isFinalBoss = pauseMenuInfo.isFinalBoss;
            this.mShardRewards[i].x = reward.xPos;
            this.mShardRewards[i].y = reward.yPos;
         }
      }
      
      override protected function hideView() : void
      {
         super.hideView();
      }
      
      private function onKickButtonClicked() : void
      {
         broadcast(BCEvent.EVT_VOTE_ACTIVE_PLAYER);
      }
   }
}

