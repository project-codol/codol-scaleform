package codo.views.wargodMatchResult_parts
{
   import com.greensock.TweenLite;
   
   public class WarGodMatchResultThreeRewards extends WarGodAnimateElement
   {
      
      public var myRewardCard0:WarGodMatchResultRewardCardWrapper;
      
      public var myRewardCard1:WarGodMatchResultRewardCardWrapper;
      
      public var myRewardCard2:WarGodMatchResultRewardCardWrapper;
      
      private var mRewards:Array;
      
      public function WarGodMatchResultThreeRewards()
      {
         super();
         this.mRewards = [this.myRewardCard0,this.myRewardCard1,this.myRewardCard2];
      }
      
      public function setRewards(rewards:Array) : void
      {
         var reward:WarGodMatchResultRewardCardWrapper = null;
         var i:int = 0;
         var numRewards:int = int(rewards.length);
         this.mRewards[0].visible = this.mRewards[1].visible = this.mRewards[2].visible = false;
         for(i = 0; i < numRewards; i++)
         {
            reward = this.mRewards[i];
            reward.alpha = 0;
            reward.x = -reward.width;
            reward.visible = true;
            reward.setData(rewards[i]);
         }
      }
      
      override public function startAni() : void
      {
         super.startAni();
         this.alpha = 1;
         var len:int = int(this.mRewards.length);
         var params:Object = {
            "alpha":1,
            "x":0
         };
         for(var i:int = 0; i < len; i++)
         {
            params.delay = 0.2 * i;
            if(i == len - 1)
            {
               params.onComplete = this.onShowComplete;
            }
            TweenLite.to(this.mRewards[i],0.3,params);
         }
      }
      
      private function onShowComplete() : void
      {
         complete();
      }
   }
}

