package components.fsggamemodes_part
{
   import flash.display.MovieClip;
   import fsg.GameMode.fsgGameModeReward;
   
   public class FsgRewardsListItem extends MovieClip
   {
      
      public var myDescriptionText:MovieClip;
      
      public var myTitleText:MovieClip;
      
      public var myLineSeparator:MovieClip;
      
      public var myAwardItemsContainer:MovieClip;
      
      public function FsgRewardsListItem()
      {
         super();
         gotoAndStop(4);
      }
      
      public function setTitleText(title:String, description:String) : void
      {
         this.myTitleText.myTextTF.text = title;
         this.myDescriptionText.myTextTF.text = description;
      }
      
      public function setRewards(rewardArray:Array, movieCache:Vector.<fsgGameModeReward>) : void
      {
         var reward:fsgGameModeReward = null;
         for(var i:int = 0; i < rewardArray.length; i++)
         {
            if(i >= this.myAwardItemsContainer.numChildren)
            {
               if(movieCache.length == 0)
               {
                  reward = new fsgGameModeReward();
               }
               else
               {
                  reward = movieCache.pop();
               }
               reward.x = i % 3 * (reward.width + 8);
               reward.y = int(i / 3) * (reward.height + 15);
               this.myAwardItemsContainer.addChild(reward);
            }
            else
            {
               reward = this.myAwardItemsContainer.getChildAt(i) as fsgGameModeReward;
            }
            reward.setData(rewardArray[i]);
         }
         while(this.myAwardItemsContainer.numChildren > rewardArray.length)
         {
            movieCache.push(this.myAwardItemsContainer.getChildAt(rewardArray.length));
            this.myAwardItemsContainer.removeChildAt(rewardArray.length);
         }
         this.myLineSeparator.y = this.myAwardItemsContainer.y + this.myAwardItemsContainer.height + 15;
      }
      
      public function cacheRewardMovies(movieCache:Vector.<fsgGameModeReward>) : void
      {
         while(this.myAwardItemsContainer.numChildren > 0)
         {
            movieCache.push(this.myAwardItemsContainer.getChildAt(0));
            this.myAwardItemsContainer.removeChildAt(0);
         }
      }
   }
}

