package fsg.shared
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class BehaviourSlider
   {
      
      private static const MIN_BAR_VALUE:Number = 1.5;
      
      private var m_hitArea:MovieClip;
      
      private var m_slider:MovieClip;
      
      private var m_clickable:BehaviourClickable;
      
      private var m_valueCallback:Function;
      
      private var m_minValue:Number;
      
      private var m_maxValue:Number;
      
      private var m_step:Number;
      
      public function BehaviourSlider(clickable:BehaviourClickable, slider:MovieClip, hitArea:MovieClip)
      {
         super();
         this.m_hitArea = hitArea;
         this.m_slider = slider;
         this.m_clickable = clickable;
      }
      
      public function initialise(value:Number, minValue:Number, maxValue:Number, step:Number = 1) : void
      {
         this.m_minValue = minValue;
         this.m_maxValue = maxValue;
         this.m_step = step;
         if(this.m_minValue % this.m_step != 0 || this.m_maxValue % this.m_step != 0)
         {
         }
         this.setSliderPosition(value);
         this.m_clickable.addMouseDownCallback(this.startDrag);
         this.m_clickable.addMouseUpCallback(this.stopDrag);
      }
      
      public function startDrag() : void
      {
         this.m_hitArea.addEventListener(Event.ENTER_FRAME,this.updateScroll,false,0,true);
      }
      
      public function stopDrag() : void
      {
         this.m_hitArea.removeEventListener(Event.ENTER_FRAME,this.updateScroll);
      }
      
      public function updateScroll(e:Event) : void
      {
         var startPoint:Point = new Point(this.m_hitArea.x,this.m_hitArea.y);
         var endPoint:Point = new Point(this.m_hitArea.x + this.m_hitArea.width,0);
         var mousePoint:Point = new Point(this.m_hitArea.stage.mouseX,this.m_hitArea.stage.mouseY);
         startPoint = this.m_hitArea.parent.localToGlobal(startPoint);
         endPoint = this.m_hitArea.parent.localToGlobal(endPoint);
         var width:Number = endPoint.x - startPoint.x;
         var mouseX:Number = mousePoint.x - startPoint.x;
         var value:Number = this.mapRange(mouseX,0,width,this.m_minValue,this.m_maxValue,0,this.m_step);
         this.setSliderPosition(value);
      }
      
      public function setSliderPosition(pos:Number) : void
      {
         var scale:Number = this.mapRange(pos,this.m_minValue,this.m_maxValue,MIN_BAR_VALUE,100,0,0);
         this.m_slider.scaleX = scale / 100;
         if(this.m_valueCallback != null)
         {
            this.m_valueCallback(pos);
         }
      }
      
      public function registerValueCallback(callback:Function) : void
      {
         this.m_valueCallback = callback;
      }
      
      private function mapRange(val:Number, inMin:Number, inMax:Number, outMin:Number, outMax:Number, decimals:uint = 0, step:Number = 1) : Number
      {
         var returnVal:Number = NaN;
         var mulVal:Number = NaN;
         var factor:int = 0;
         var inRange:Number = inMax - inMin;
         var outRange:Number = outMax - outMin;
         val = Math.max(inMin,val);
         val = Math.min(inMax,val);
         var ratio:Number = (val - inMin) / inRange;
         returnVal = outRange * ratio + outMin;
         if(step > 0 && step < 1)
         {
            mulVal = 1 / step;
            returnVal = Math.round(returnVal * mulVal) / mulVal;
         }
         else if(step == 1)
         {
            factor = Math.pow(10,decimals);
            returnVal = Math.round(returnVal * factor) / factor;
         }
         return returnVal;
      }
   }
}

