package codo.shared.career
{
   import fsg.util.FsgImageHolder;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol238")]
   public dynamic class ChallengeChecklistItemRewardImage extends FsgImageHolder
   {
      
      public function ChallengeChecklistItemRewardImage()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}

