package codo.views.wargod_parts
{
   import flash.display.MovieClip;
   
   public class TierMeter extends MovieClip
   {
      
      public function TierMeter()
      {
         super();
      }
      
      public function setData(tierIndex:int) : void
      {
         gotoAndStop(tierIndex + 1);
      }
   }
}

