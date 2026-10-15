package codo.views.wargod_parts
{
   import flash.display.MovieClip;
   
   public class DivisionMeter extends MovieClip
   {
      
      public function DivisionMeter()
      {
         super();
      }
      
      public function setData(enabled:Boolean, divisionIndex:int) : void
      {
         visible = enabled;
         var frame:int = divisionIndex + 1;
         gotoAndStop(frame);
      }
   }
}

