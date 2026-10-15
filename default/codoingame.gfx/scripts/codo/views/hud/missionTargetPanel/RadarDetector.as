package codo.views.hud.missionTargetPanel
{
   import codo.views.hud.shared.HUDScalableRing;
   import flash.display.MovieClip;
   
   public class RadarDetector extends MovieClip
   {
      
      private static const RING_WIDTH:Number = 3;
      
      private static const START_WIDTH:Number = 30;
      
      private static const END_WIDTH:Number = 66;
      
      public var myRingContainer:MovieClip;
      
      public var myOutRing:MovieClip;
      
      private var myRings:Vector.<HUDScalableRing>;
      
      public function RadarDetector()
      {
         var dtWidth:Number = NaN;
         var ring:HUDScalableRing = null;
         super();
         this.myRings = new Vector.<HUDScalableRing>();
         for(var i:int = 0; true; i++)
         {
            ring = this.myRingContainer.getChildByName("myRing".concat(i)) as HUDScalableRing;
            if(ring == null)
            {
               break;
            }
            ring.ringWidth = RING_WIDTH;
            this.myRings.push(ring);
         }
         this.blink = false;
         dtWidth = (END_WIDTH - START_WIDTH) / (this.myRings.length - 1);
         for(i = 0; i < this.myRings.length; i++)
         {
            this.myRings[i].width = this.myRings[i].height = dtWidth * i + START_WIDTH;
         }
      }
      
      public function set blink(b:Boolean) : void
      {
         if(b)
         {
            this.myOutRing.play();
         }
         else
         {
            this.myOutRing.gotoAndStop(1);
         }
      }
      
      public function set intensity(iVal:int) : void
      {
         for(var i:int = 0; i < this.myRings.length; i++)
         {
            this.myRings[i].visible = i < iVal;
         }
      }
   }
}

