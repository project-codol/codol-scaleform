package codo.views
{
   import codo.base.BaseView;
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionInGameContainer;
   import codo.constants.GameInfo;
   import codo.localization.DictRoom;
   import codo.localization.DictZHunt;
   import codo.objects.ProductObj;
   import codo.utils.LocalizeUtil;
   import codo.utils.ScaleformUtil;
   import codo.views.helpMenu_parts.zhunt.FsgHelpMenuZhuntPartReward;
   import codo.views.helpMenu_parts.zhunt.FsgHelpMenuZhuntReward;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.text.TextField;
   import fsg.util.FsgImageHolder;
   
   public class FsgHelpMenuZhuntView extends BaseView
   {
      
      private static const ZHUNT_HELP_MENU_SETTINGS_TABLE:String = "mp/zhunt_help_menu_settings.csv";
      
      public var myShardsGuideTitleTF:TextField;
      
      public var myShardsGuideTitleBg:MovieClip;
      
      public var myMiniBossPartReward1:FsgHelpMenuZhuntPartReward;
      
      public var myMiniBossPartReward2:FsgHelpMenuZhuntPartReward;
      
      public var myMiniBossPartReward3:FsgHelpMenuZhuntPartReward;
      
      public var myFinalBossPartReward1:FsgHelpMenuZhuntPartReward;
      
      public var myFinalBossPartReward2:FsgHelpMenuZhuntPartReward;
      
      public var myFinalBossPartReward3:FsgHelpMenuZhuntPartReward;
      
      public var myComposedRewardTitleTF:TextField;
      
      public var myComposedRewardTitleBg:MovieClip;
      
      public var myComposedReward1:FsgHelpMenuZhuntReward;
      
      public var myComposedReward2:FsgHelpMenuZhuntReward;
      
      public var myComposedReward3:FsgHelpMenuZhuntReward;
      
      public var myComposedReward4:FsgHelpMenuZhuntReward;
      
      public var myComposedReward5:FsgHelpMenuZhuntReward;
      
      public var myComposedReward6:FsgHelpMenuZhuntReward;
      
      public var myRandomRewardTitleTF:TextField;
      
      public var myRandomRewardTitleBg:MovieClip;
      
      public var myRandomReward1:FsgHelpMenuZhuntReward;
      
      public var myRandomReward2:FsgHelpMenuZhuntReward;
      
      public var myRandomReward3:FsgHelpMenuZhuntReward;
      
      public var myRandomReward4:FsgHelpMenuZhuntReward;
      
      public var myMiniBossNameTF:TextField;
      
      public var myMiniBossNameBg:MovieClip;
      
      public var myFinalBossNameTF:TextField;
      
      public var myFinalBossNameBg:MovieClip;
      
      public var myMiniBossImage:FsgImageHolder;
      
      public var myFinalBossImage:FsgImageHolder;
      
      public var myWeaponHint:TextField;
      
      public var myBg:MovieClip;
      
      private var mComposeRewards:Array = [];
      
      private var mRandomRewards:Array = [];
      
      private var mMiniBossWeakPartRewards:Array = [];
      
      private var mFinalBossWeakPartRewards:Array = [];
      
      public function FsgHelpMenuZhuntView()
      {
         super();
         this.mComposeRewards = [this.myComposedReward1,this.myComposedReward2,this.myComposedReward3,this.myComposedReward4,this.myComposedReward5,this.myComposedReward6];
         this.mRandomRewards = [this.myRandomReward1,this.myRandomReward2,this.myRandomReward3,this.myRandomReward4];
         this.mMiniBossWeakPartRewards = [this.myMiniBossPartReward1,this.myMiniBossPartReward2,this.myMiniBossPartReward3];
         this.mFinalBossWeakPartRewards = [this.myFinalBossPartReward1,this.myFinalBossPartReward2,this.myFinalBossPartReward3];
         this.myShardsGuideTitleTF.text = DictZHunt.BOSS_WEAKNESS_HINT_TITLE;
         this.myComposedRewardTitleTF.text = DictZHunt.SHARDS_COMPOSE_HINT_TITLE;
         this.myRandomRewardTitleTF.text = DictZHunt.RANDOM_REWARD_HINT_TITLE;
         this.myWeaponHint.text = DictZHunt.WEAPON_HINT;
      }
      
      override protected function showView() : void
      {
         var i:int = 0;
         var helpMenuInfo:Object = null;
         var weakPartReward:Object = null;
         var reward:ProductObj = null;
         super.showView();
         this.adaptToScreen();
         this.myMiniBossPartReward1.visible = false;
         this.myMiniBossPartReward2.visible = false;
         this.myFinalBossPartReward1.visible = false;
         this.myFinalBossPartReward2.visible = false;
         this.myFinalBossPartReward3.visible = false;
         this.myComposedReward1.visible = false;
         this.myComposedReward2.visible = false;
         this.myComposedReward3.visible = false;
         this.myComposedReward4.visible = false;
         this.myComposedReward5.visible = false;
         this.myComposedReward6.visible = false;
         this.myRandomReward1.visible = false;
         this.myRandomReward2.visible = false;
         this.myRandomReward3.visible = false;
         this.myRandomReward4.visible = false;
         helpMenuInfo = CFunctionInGameContainer.AS_GetZHuntHelpMenuInfo();
         if(helpMenuInfo == null)
         {
            return;
         }
         this.myMiniBossImage.setImage(helpMenuInfo.miniBossImage);
         this.myMiniBossImage.x = helpMenuInfo.miniBossX;
         this.myMiniBossImage.y = helpMenuInfo.miniBossY;
         this.myMiniBossNameBg.x = helpMenuInfo.miniBossNameX;
         this.myMiniBossNameBg.y = helpMenuInfo.miniBossNameY;
         this.myMiniBossNameTF.text = "@" + helpMenuInfo.miniBossName;
         this.myMiniBossNameTF.x = this.myMiniBossNameBg.x + 10;
         this.myMiniBossNameTF.y = this.myMiniBossNameBg.y + 30;
         this.myFinalBossImage.setImage(helpMenuInfo.finalBossImage);
         this.myFinalBossImage.x = helpMenuInfo.finalBossX;
         this.myFinalBossImage.y = helpMenuInfo.finalBossY;
         this.myFinalBossNameBg.x = helpMenuInfo.finalBossNameX;
         this.myFinalBossNameBg.y = helpMenuInfo.finalBossNameY;
         this.myFinalBossNameTF.text = "@" + helpMenuInfo.finalBossName;
         this.myFinalBossNameTF.x = this.myFinalBossNameBg.x + 10;
         this.myFinalBossNameTF.y = this.myFinalBossNameBg.y + 30;
         var difficulty:int = CFunctionCommonContainer.Dvar_GetInt("ui_playlist_difficulty");
         if(helpMenuInfo.hasOwnProperty("miniBossWeakPartRewards"))
         {
            for(i = 0; i < helpMenuInfo.miniBossWeakPartRewards.length; i++)
            {
               weakPartReward = helpMenuInfo.miniBossWeakPartRewards[i];
               if(helpMenuInfo.miniBossWeakPartRewards[i] == null)
               {
                  this.mMiniBossWeakPartRewards[i].visible = false;
               }
               else
               {
                  this.mMiniBossWeakPartRewards[i].visible = true;
                  this.mMiniBossWeakPartRewards[i].title = LocalizeUtil.param(DictZHunt.WEAK_PART,[i + 1]) + LocalizeUtil.localize("@" + weakPartReward.weakPart);
                  this.mMiniBossWeakPartRewards[i].icon = weakPartReward.rewardIcon;
                  this.mMiniBossWeakPartRewards[i].rewardName = LocalizeUtil.localize("@" + weakPartReward.rewardName) + "[" + LocalizeUtil.localize(DictRoom.ROOM_LEVELS[difficulty]) + "]";
                  if(difficulty < 2)
                  {
                     this.mMiniBossWeakPartRewards[i].rewardName = LocalizeUtil.localize("@" + weakPartReward.rewardName);
                  }
                  this.mMiniBossWeakPartRewards[i].isFinalBoss = false;
                  this.mMiniBossWeakPartRewards[i].x = weakPartReward.xPos;
                  this.mMiniBossWeakPartRewards[i].y = weakPartReward.yPos;
               }
            }
         }
         if(helpMenuInfo.hasOwnProperty("finalBossWeakPartRewards"))
         {
            for(i = 0; i < helpMenuInfo.finalBossWeakPartRewards.length; i++)
            {
               weakPartReward = helpMenuInfo.finalBossWeakPartRewards[i];
               if(helpMenuInfo.finalBossWeakPartRewards[i] == null)
               {
                  this.mFinalBossWeakPartRewards[i].visible = false;
               }
               else
               {
                  this.mFinalBossWeakPartRewards[i].visible = true;
                  this.mFinalBossWeakPartRewards[i].title = LocalizeUtil.param(DictZHunt.WEAK_PART,[i + 1]) + LocalizeUtil.localize("@" + weakPartReward.weakPart);
                  this.mFinalBossWeakPartRewards[i].icon = weakPartReward.rewardIcon;
                  this.mFinalBossWeakPartRewards[i].rewardName = LocalizeUtil.localize("@" + weakPartReward.rewardName) + "[" + LocalizeUtil.localize(DictRoom.ROOM_LEVELS[difficulty]) + "]";
                  if(difficulty < 2)
                  {
                     this.mFinalBossWeakPartRewards[i].rewardName = LocalizeUtil.localize("@" + weakPartReward.rewardName);
                  }
                  this.mFinalBossWeakPartRewards[i].isFinalBoss = true;
                  this.mFinalBossWeakPartRewards[i].x = weakPartReward.xPos;
                  this.mFinalBossWeakPartRewards[i].y = weakPartReward.yPos;
               }
            }
         }
         var randomRewardTitlePos:int = this.myComposedRewardTitleBg.y + this.myComposedRewardTitleBg.height + 21;
         if(helpMenuInfo.hasOwnProperty("composeRewards"))
         {
            for(i = 0; i < helpMenuInfo.composeRewards.length; i++)
            {
               this.mComposeRewards[i].visible = true;
               this.mComposeRewards[i].icon = helpMenuInfo.composeRewards[i].imageURL;
               randomRewardTitlePos = this.mComposeRewards[i].y + this.mComposeRewards[i].height + 21;
            }
         }
         this.myRandomRewardTitleBg.y = randomRewardTitlePos;
         this.myRandomRewardTitleTF.y = this.myRandomRewardTitleBg.y + 38;
         if(helpMenuInfo.hasOwnProperty("randomRewards"))
         {
            for(i = 0; i < helpMenuInfo.randomRewards.length; i++)
            {
               this.mRandomRewards[i].visible = true;
               this.mRandomRewards[i].icon = helpMenuInfo.randomRewards[i].imageURL;
               this.mRandomRewards[i].y = this.myRandomRewardTitleBg.y + this.myRandomRewardTitleBg.height + 21 + Math.floor(i / 2) * (this.mRandomRewards[i].height + 21);
            }
         }
         var idx1:int = getChildIndex(this.myMiniBossImage);
         var idx2:int = getChildIndex(this.myFinalBossImage);
         if(helpMenuInfo.finalBossOnTop > 0)
         {
            if(idx1 > idx2)
            {
               swapChildren(this.myMiniBossImage,this.myFinalBossImage);
            }
         }
         else if(idx1 < idx2)
         {
            swapChildren(this.myMiniBossImage,this.myFinalBossImage);
         }
      }
      
      override protected function hideView() : void
      {
         super.hideView();
      }
      
      private function adaptToScreen() : void
      {
         this.myMiniBossImage.x = this.myMiniBossImage.y = 0;
         this.myFinalBossImage.x = this.myFinalBossImage.y = 0;
         var stageSize:Point = new Point(1280,960);
         var stagePosition:Point = new Point(0,0);
         if(ScaleformUtil.isScaleform)
         {
            stageSize = GameInfo.stageSize;
            stagePosition = GameInfo.stagePosition;
         }
         var scale:Number = stageSize.x / this.width;
         var scaledHeight:Number = this.height * scale;
         var yOff:Number = (scaledHeight - stageSize.y) / 2;
         this.x = stagePosition.x;
         this.y = stagePosition.y - yOff;
         this.width = stageSize.x;
         this.height = scaledHeight;
      }
   }
}

