package codo.views.wargodMatchResult_parts
{
   import codo.objects.WarGodRewardObj;
   import codo.views.wargod_parts.WarGodRewardCard;
   import flash.display.MovieClip;
   
   public class WarGodMatchResultRewardCardWrapper extends MovieClip
   {
      
      public var myCard:WarGodRewardCard;
      
      public function WarGodMatchResultRewardCardWrapper()
      {
         super();
      }
      
      public function setData(rewardObj:WarGodRewardObj) : void
      {
         this.myCard.setWarGodReward(rewardObj);
      }
   }
}

