package codo.views.zhuntMatchResult_parts
{
   import codo.common.CFunctionCommonContainer;
   import codo.localization.Dict;
   import codo.localization.DictRoom;
   import codo.objects.ProductObj;
   import codo.objects.RewardObjComplete;
   import codo.utils.LocalizeUtil;
   import com.greensock.TimelineLite;
   import com.greensock.TweenLite;
   import com.greensock.easing.Linear;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class ZHuntMatchResultPanel extends MovieClip
   {
      
      private static const MAX_ITEMS_FOR_ONE_ROW:int = 4;
      
      private static const TITLE_BLOCK1_HEIGHT:int = 96;
      
      private static const TITLE_BLOCK2_HEIGHT:int = 35;
      
      private static const TITLE_BLOCK3_HEIGHT:int = 50;
      
      private static const ITEM_WIDTH:int = 220;
      
      private static const ITEM_HEIGHT:int = 186;
      
      private static const ITEM_X_PADDING:int = 10;
      
      private static const ITEM_Y_PADDING:int = 12;
      
      private static const MARGIN_X:int = 26;
      
      private static const MARGIN_Y:int = 10;
      
      public var myArea:MovieClip;
      
      public var myTitle:TextField;
      
      public var myKillRewardTitle:TextField;
      
      public var myPartRewardTitle:TextField;
      
      public var myReward1:ZHuntMatchRewardItem;
      
      public var myReward2:ZHuntMatchRewardItem;
      
      public var myReward3:ZHuntMatchRewardItem;
      
      public var myReward4:ZHuntMatchRewardItem;
      
      public var myReward5:ZHuntMatchRewardItem;
      
      public var myReward6:ZHuntMatchRewardItem;
      
      public var myReward7:ZHuntMatchRewardItem;
      
      public var myReward8:ZHuntMatchRewardItem;
      
      public var myReward9:ZHuntMatchRewardItem;
      
      public var myReward10:ZHuntMatchRewardItem;
      
      public var myRewardName1:MovieClip;
      
      public var myRewardName2:MovieClip;
      
      public var myRewardName3:MovieClip;
      
      public var myRewardName4:MovieClip;
      
      public var myRewardName5:MovieClip;
      
      public var myRewardName6:MovieClip;
      
      public var myRewardName7:MovieClip;
      
      public var myRewardName8:MovieClip;
      
      public var myRewardName9:MovieClip;
      
      public var myRewardName10:MovieClip;
      
      private var mRewards:Array;
      
      private var mRewardNames:Array;
      
      private var mKillRewards:Array;
      
      private var mKillRewardNames:Array;
      
      private var mPartRewards:Array;
      
      private var mPartRewardNames:Array;
      
      public function ZHuntMatchResultPanel()
      {
         super();
         this.mRewards = [this.myReward1,this.myReward2,this.myReward3,this.myReward4,this.myReward5,this.myReward6,this.myReward7,this.myReward8,this.myReward9,this.myReward10];
         this.mRewardNames = [this.myRewardName1,this.myRewardName2,this.myRewardName3,this.myRewardName4,this.myRewardName5,this.myRewardName6,this.myRewardName7,this.myRewardName8,this.myRewardName9,this.myRewardName10];
         this.mKillRewards = [];
         this.mKillRewardNames = [];
         this.mPartRewards = [];
         this.mPartRewardNames = [];
         this.myKillRewardTitle.text = Dict.KILL_REWARD;
         this.myPartRewardTitle.text = Dict.DESTROY_PART_REWARD;
         this.myTitle.text = Dict.OBTAINED_REWARDS;
      }
      
      public function killAllTweens() : void
      {
         TweenLite.killTweensOf(this);
         for(var i:int = 0; i < this.mRewards.length; i++)
         {
            TweenLite.killTweensOf(this.mRewards[i]);
         }
      }
      
      public function setData(rewards:Array) : void
      {
         this.myTitle.visible = false;
         this.myKillRewardTitle.visible = false;
         this.myPartRewardTitle.visible = false;
         this.killAllTweens();
         this.categorizeRewards(rewards);
         this.setupAreaSize();
         this.placeRewards();
      }
      
      private function categorizeRewards(rewards:Array) : void
      {
         var i:int = 0;
         var rewardObjComplete:RewardObjComplete = null;
         var prod:ProductObj = null;
         var rareReward:ZHuntMatchRewardItem = null;
         var rareRewardName:MovieClip = null;
         var difficulty:int = CFunctionCommonContainer.Dvar_GetInt("ui_playlist_difficulty");
         this.mKillRewards = [];
         this.mPartRewards = [];
         for(i = 0; i < this.mRewards.length; i++)
         {
            this.mRewards[i].visible = false;
            this.mRewardNames[i].visible = false;
         }
         for(i = 0; i < rewards.length; i++)
         {
            if(i >= this.mRewards.length)
            {
               break;
            }
            this.mRewards[i].setData(rewards[i]);
            this.mRewards[i].visible = true;
            this.mRewards[i].shouldShowOff = false;
            this.mRewardNames[i].visible = true;
            this.mRewardNames[i].myNameTF.text = LocalizeUtil.localize(rewards[i].nameString) + "[" + LocalizeUtil.localize(DictRoom.ROOM_LEVELS[difficulty]) + "]";
            if(difficulty < 2)
            {
               this.mRewardNames[i].myNameTF.text = LocalizeUtil.localize(rewards[i].nameString);
            }
            rewardObjComplete = new RewardObjComplete(rewards[i].rewardType,rewards[i].rewardEntity,rewards[i].rewardParam);
            prod = rewardObjComplete.getProductObj();
            if(prod != null)
            {
               if(prod.tier > 1)
               {
                  this.mRewards[i].shouldShowOff = true;
               }
               if(rewards[i].rewardType == RewardObjComplete.REWARD_TYPE_RENTAL && rewards[i].rewardParam > 0)
               {
                  this.mRewards[i].shouldShowOff = false;
               }
            }
            if(rewards[i].partID == 0)
            {
               if(rewards[i].isBossReward == 1)
               {
                  this.mKillRewards.push(this.mRewards[i]);
                  this.mKillRewardNames.push(this.mRewardNames[i]);
               }
               else
               {
                  rareReward = this.mRewards[i];
                  rareRewardName = this.mRewardNames[i];
               }
            }
            else
            {
               this.mPartRewards.push(this.mRewards[i]);
               this.mPartRewardNames.push(this.mRewardNames[i]);
            }
         }
         if(rareReward != null)
         {
            this.mKillRewards.push(rareReward);
            this.mKillRewardNames.push(rareRewardName);
         }
      }
      
      private function setupAreaSize() : void
      {
         var rows:int = 0;
         rows += Math.floor(this.mKillRewards.length / MAX_ITEMS_FOR_ONE_ROW);
         rows += Math.floor(this.mKillRewards.length % MAX_ITEMS_FOR_ONE_ROW) > 0 ? 1 : 0;
         rows += Math.floor(this.mPartRewards.length / MAX_ITEMS_FOR_ONE_ROW);
         rows += Math.floor(this.mPartRewards.length % MAX_ITEMS_FOR_ONE_ROW) > 0 ? 1 : 0;
         this.myArea.height = MARGIN_Y + TITLE_BLOCK1_HEIGHT;
         if(this.mKillRewards.length > 0)
         {
            this.myArea.height += TITLE_BLOCK2_HEIGHT;
         }
         if(this.mKillRewards.length + this.mPartRewards.length <= MAX_ITEMS_FOR_ONE_ROW)
         {
            this.myArea.height += ITEM_HEIGHT + ITEM_Y_PADDING;
            this.myArea.height += MARGIN_Y;
         }
         else
         {
            if(this.mPartRewards.length > 0)
            {
               this.myArea.height += TITLE_BLOCK3_HEIGHT;
            }
            this.myArea.height += rows * (ITEM_HEIGHT + ITEM_Y_PADDING);
            this.myArea.height += MARGIN_Y;
         }
         this.myArea.x = 0;
         this.myArea.y = 0;
      }
      
      private function placeRewards() : void
      {
         var i:int = 0;
         this.myTitle.visible = true;
         var maxY:Number = 0;
         if(this.mKillRewards.length > 0)
         {
            this.myKillRewardTitle.visible = true;
            for(i = 0; i < this.mKillRewards.length; i++)
            {
               this.mKillRewards[i].scaleX = this.mKillRewards[i].scaleY = 1;
               this.mKillRewards[i].x = MARGIN_X + Math.floor(i % MAX_ITEMS_FOR_ONE_ROW) * (ITEM_WIDTH + ITEM_X_PADDING);
               this.mKillRewards[i].y = MARGIN_Y + TITLE_BLOCK1_HEIGHT + TITLE_BLOCK2_HEIGHT + Math.floor(i / MAX_ITEMS_FOR_ONE_ROW) * (ITEM_HEIGHT + ITEM_Y_PADDING);
               this.mKillRewardNames[i].x = this.mKillRewards[i].x;
               this.mKillRewardNames[i].y = this.mKillRewards[i].y;
               maxY = maxY > this.mKillRewards[i].y ? maxY : Number(this.mKillRewards[i].y);
            }
         }
         if(this.mKillRewards.length + this.mPartRewards.length < MAX_ITEMS_FOR_ONE_ROW)
         {
            if(this.mPartRewards.length > 0)
            {
               this.myPartRewardTitle.visible = true;
               this.myPartRewardTitle.x = MARGIN_X + Math.floor(this.mKillRewards.length % MAX_ITEMS_FOR_ONE_ROW) * (ITEM_WIDTH + ITEM_X_PADDING);
               this.myPartRewardTitle.y = this.myKillRewardTitle.y;
               for(i = 0; i < this.mPartRewards.length; i++)
               {
                  this.mPartRewards[i].scaleX = this.mPartRewards[i].scaleY = 1;
                  this.mPartRewards[i].x = MARGIN_X + Math.floor(i + this.mKillRewards.length) % MAX_ITEMS_FOR_ONE_ROW * (ITEM_WIDTH + ITEM_X_PADDING);
                  this.mPartRewards[i].y = MARGIN_Y + TITLE_BLOCK1_HEIGHT + TITLE_BLOCK2_HEIGHT;
                  this.mPartRewardNames[i].x = this.mPartRewards[i].x;
                  this.mPartRewardNames[i].y = this.mPartRewards[i].y;
               }
            }
         }
         else if(this.mPartRewards.length > 0)
         {
            this.myPartRewardTitle.visible = true;
            this.myPartRewardTitle.y = maxY + ITEM_HEIGHT + ITEM_Y_PADDING + 15;
            for(i = 0; i < this.mPartRewards.length; i++)
            {
               this.mPartRewards[i].scaleX = this.mPartRewards[i].scaleY = 1;
               this.mPartRewards[i].x = MARGIN_X + Math.floor(i % MAX_ITEMS_FOR_ONE_ROW) * (ITEM_WIDTH + ITEM_X_PADDING);
               this.mPartRewards[i].y = this.myPartRewardTitle.y + TITLE_BLOCK3_HEIGHT + Math.floor(i / MAX_ITEMS_FOR_ONE_ROW) * (ITEM_HEIGHT + ITEM_Y_PADDING) - 15;
               this.mPartRewardNames[i].x = this.mPartRewards[i].x;
               this.mPartRewardNames[i].y = this.mPartRewards[i].y;
            }
         }
      }
      
      public function playOpenCratesAnimations() : void
      {
         var i:int = 0;
         var timelineLite:TimelineLite = null;
         var orgX:Number = NaN;
         var orgY:Number = NaN;
         var zoomOutX:Number = NaN;
         var zoomOutY:Number = NaN;
         var delay:Number = 0.5;
         var zoom:Number = 1.2;
         if(this.mKillRewards.length > 0)
         {
            for(i = 0; i < this.mKillRewards.length; i++)
            {
               if(Boolean(this.mKillRewards[i].shouldShowOff))
               {
                  timelineLite = new TimelineLite({
                     "delay":delay,
                     "onStart":this.mKillRewards[i].open
                  });
                  orgX = Number(this.mKillRewards[i].x);
                  orgY = Number(this.mKillRewards[i].y);
                  zoomOutX = orgX + this.mKillRewards[i].width / 2 - zoom * this.mKillRewards[i].width / 2 + 20;
                  zoomOutY = orgY + this.mKillRewards[i].height / 2 - zoom * this.mKillRewards[i].height / 2;
                  timelineLite.append(TweenLite.to(this.mKillRewards[i],0.2,{
                     "delay":0.4,
                     "ease":Linear.easeIn,
                     "scaleX":zoom,
                     "scaleY":zoom,
                     "x":zoomOutX,
                     "y":zoomOutY,
                     "onStart":this.topMost,
                     "onStartParams":[this.mKillRewards[i]]
                  }));
                  timelineLite.append(TweenLite.to(this.mKillRewards[i],0.2,{
                     "delay":0.1,
                     "ease":Linear.easeOut,
                     "scaleX":1,
                     "scaleY":1,
                     "x":orgX,
                     "y":orgY
                  }));
               }
               else
               {
                  TweenLite.to(this.mKillRewards[i],0.01,{
                     "delay":delay,
                     "onStart":this.mKillRewards[i].open
                  });
               }
               delay += 0.84;
            }
         }
         if(this.mPartRewards.length > 0)
         {
            for(i = 0; i < this.mPartRewards.length; i++)
            {
               if(Boolean(this.mPartRewards[i].shouldShowOff))
               {
                  timelineLite = new TimelineLite({
                     "delay":delay,
                     "onStart":this.mPartRewards[i].open
                  });
                  orgX = Number(this.mPartRewards[i].x);
                  orgY = Number(this.mPartRewards[i].y);
                  zoomOutX = orgX + this.mPartRewards[i].width / 2 - zoom * this.mPartRewards[i].width / 2 + 20;
                  zoomOutY = orgY + this.mPartRewards[i].height / 2 - zoom * this.mPartRewards[i].height / 2;
                  timelineLite.append(TweenLite.to(this.mPartRewards[i],0.2,{
                     "delay":0.4,
                     "ease":Linear.easeIn,
                     "scaleX":zoom,
                     "scaleY":zoom,
                     "x":zoomOutX,
                     "y":zoomOutY,
                     "onStart":this.topMost,
                     "onStartParams":[this.mPartRewards[i]]
                  }));
                  timelineLite.append(TweenLite.to(this.mPartRewards[i],0.2,{
                     "delay":0.1,
                     "ease":Linear.easeOut,
                     "scaleX":1,
                     "scaleY":1,
                     "x":orgX,
                     "y":orgY
                  }));
               }
               else
               {
                  TweenLite.to(this.mPartRewards[i],0.01,{
                     "delay":delay,
                     "onStart":this.mPartRewards[i].open
                  });
               }
               delay += 0.84;
            }
         }
      }
      
      private function topMost(item:DisplayObject) : void
      {
         setChildIndex(item,numChildren - 1);
      }
   }
}

