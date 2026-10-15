package codo.component.loadout
{
   import codo.component.TextField;
   import codo.objects.LoadoutMeterSettings;
   import codo.style.GlobalGuide;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.utils.getDefinitionByName;
   
   public class LoadoutMeter extends MovieClip
   {
      
      private static const TICK_LINKAGE:String = "codo.shared.loadoutMeterTick";
      
      private static const TICK_ENABLE_FRAME:int = 1;
      
      private static const TICK_DISABLE_FRAME:int = 2;
      
      private static const MAX_TICKS:int = 10;
      
      public var myTickMount:Sprite;
      
      public var myTickCount:TextField;
      
      private var mTicks:Vector.<MovieClip>;
      
      public function LoadoutMeter()
      {
         var tick:MovieClip = null;
         super();
         this.myTickCount.font = GlobalGuide.FONT_FACE_NUMBERS;
         this.myTickCount.fontSize = 32;
         this.myTickCount.height = 50;
         this.mTicks = new Vector.<MovieClip>();
         var tickClass:Class = getDefinitionByName(TICK_LINKAGE) as Class;
         for(var i:int = 0; i < MAX_TICKS; i++)
         {
            tick = new tickClass();
            this.myTickMount.addChild(tick);
            this.mTicks.push(tick);
         }
      }
      
      public function setData(data:LoadoutMeterSettings) : void
      {
         var numTicks:int = 0;
         numTicks = data.numTicks;
         var tickWidth:Number = data.tickWidth;
         var tickPadding:Number = data.tickPadding;
         var curX:Number = 0;
         for(var i:int = 0; i < MAX_TICKS; i++)
         {
            this.mTicks[i].width = tickWidth;
            this.mTicks[i].x = curX;
            if(i < numTicks)
            {
               this.mTicks[i].gotoAndStop(TICK_ENABLE_FRAME);
            }
            else
            {
               this.mTicks[i].gotoAndStop(TICK_DISABLE_FRAME);
            }
            curX += tickWidth + tickPadding;
         }
         this.myTickCount.x = curX;
         this.myTickCount.text = numTicks + "/" + MAX_TICKS;
      }
   }
}

