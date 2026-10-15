package codo.objects
{
   public class LoadoutMeterSettings
   {
      
      public var numTicks:int;
      
      public var tickWidth:Number;
      
      public var tickPadding:Number;
      
      public function LoadoutMeterSettings(inNumTicks:int = 0, inTickWidth:Number = 53, inTickPadding:Number = 5)
      {
         super();
         this.numTicks = inNumTicks;
         this.tickWidth = inTickWidth;
         this.tickPadding = inTickPadding;
      }
   }
}

