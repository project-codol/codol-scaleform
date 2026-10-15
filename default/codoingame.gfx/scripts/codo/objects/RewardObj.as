package codo.objects
{
   public class RewardObj
   {
      
      public var rewardName:String;
      
      public var rewardDescription:String;
      
      public var rewardImagePath:String;
      
      public function RewardObj(rewardName:String, rewardDescription:String, rewardImagePath:String)
      {
         super();
         this.rewardName = rewardName;
         this.rewardDescription = rewardDescription;
         this.rewardImagePath = rewardImagePath;
      }
   }
}

