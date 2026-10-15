package codo.objects
{
   import codo.common.CFunctionCommonContainer;
   import codo.localization.Dict;
   import codo.utils.LocalizeUtil;
   
   public class ChallengeBaseObj
   {
      
      public static const MAX_PINNED:uint = 3;
      
      public var id:uint;
      
      public var profileID:int;
      
      public var name:String;
      
      public var description:String;
      
      public var rewardXP:uint;
      
      public var rewardGP:uint;
      
      public var target:uint;
      
      public var progress:Number;
      
      public var icon:String;
      
      public function ChallengeBaseObj()
      {
         super();
      }
      
      public function getFinished() : Boolean
      {
         return this.progress >= this.target;
      }
      
      public function isPinned() : Boolean
      {
         var chal:ChallengeBaseObj = null;
         for(var i:uint = 0; i < MAX_PINNED; i++)
         {
            chal = CFunctionCommonContainer.GetPinnedChallenge(i);
            if(chal != null && chal.profileID == this.profileID)
            {
               return true;
            }
         }
         return false;
      }
      
      public function cppInitData() : void
      {
         this.name = LocalizeUtil.localize("@" + this.name);
         this.description = LocalizeUtil.param("@" + this.description,[this.target]);
      }
      
      public function getRewardText() : String
      {
         var rewardText:String = "";
         if(this.rewardGP > 0)
         {
            rewardText += this.rewardGP + LocalizeUtil.localize(Dict.GP);
         }
         if(this.rewardXP > 0)
         {
            if(rewardText.length > 0)
            {
               rewardText += " | ";
            }
            rewardText += this.rewardXP + LocalizeUtil.localize(Dict.XP);
         }
         return rewardText;
      }
   }
}

