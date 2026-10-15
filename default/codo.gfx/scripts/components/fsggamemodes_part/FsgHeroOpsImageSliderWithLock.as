package components.fsggamemodes_part
{
   import codo.objects.MapObj;
   
   public class FsgHeroOpsImageSliderWithLock extends FsgImageSliderWithLock
   {
      
      public var myMissionCompleteBanner:FsgMissionCompleteBanner;
      
      public function FsgHeroOpsImageSliderWithLock()
      {
         super();
      }
      
      override public function set currentIndex(cIndex:uint) : void
      {
         super.currentIndex = cIndex;
         if(Boolean(MapObj(selectedData)))
         {
            this.myMissionCompleteBanner.setMissionCompleted(MapObj(selectedData).isComplete);
         }
      }
   }
}

