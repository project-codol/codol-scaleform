package codo_diagram_fla
{
   import codo.diagram.circleDiagram;
   import codo.diagram.curveDiagram;
   import flash.display.MovieClip;
   
   public dynamic class MainTimeline extends MovieClip
   {
      
      public var myCircle:circleDiagram;
      
      public var myDiagram1:curveDiagram;
      
      public function MainTimeline()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      public function drawSector(param1:MovieClip, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number) : void
      {
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         if(param6 == 0)
         {
            return;
         }
         param6 = Math.abs(param6) > 360 ? 360 : param6;
         var _loc9_:Number = Math.ceil(Math.abs(param6) / 45);
         var _loc10_:Number = param6 / _loc9_;
         _loc10_ = _loc10_ * Math.PI / 180;
         var _loc11_:Number = param7 * Math.PI / 180;
         var _loc12_:Number = _loc11_ + param6 * Math.PI / 180;
         param1.graphics.beginFill(param8,50);
         param1.graphics.lineStyle(1,param8);
         param1.graphics.moveTo(param2 + param5 * Math.cos(_loc11_),param3 + param5 * Math.sin(_loc11_));
         if(param6 != 360)
         {
            param1.graphics.lineTo(param2 + param4 * Math.cos(_loc11_),param3 + param4 * Math.sin(_loc11_));
         }
         else
         {
            param1.graphics.moveTo(param2 + param4 * Math.cos(_loc11_),param3 + param4 * Math.sin(_loc11_));
         }
         var _loc13_:* = _loc11_;
         var _loc14_:int = 1;
         while(_loc14_ <= _loc9_)
         {
            _loc13_ += _loc10_;
            _loc15_ = _loc13_ - _loc10_ / 2;
            _loc16_ = param2 + param4 / Math.cos(_loc10_ / 2) * Math.cos(_loc15_);
            _loc17_ = param3 + param4 / Math.cos(_loc10_ / 2) * Math.sin(_loc15_);
            _loc18_ = param2 + param4 * Math.cos(_loc13_);
            _loc19_ = param3 + param4 * Math.sin(_loc13_);
            param1.graphics.curveTo(_loc16_,_loc17_,_loc18_,_loc19_);
            _loc14_++;
         }
         if(param6 != 360)
         {
            param1.graphics.lineTo(param2 + param5 * Math.cos(_loc12_),param3 + param5 * Math.sin(_loc12_));
         }
         else
         {
            param1.graphics.moveTo(param2 + param5 * Math.cos(_loc12_),param3 + param5 * Math.sin(_loc12_));
         }
         _loc14_ = 1;
         while(_loc14_ <= _loc9_)
         {
            _loc13_ -= _loc10_;
            _loc15_ = _loc13_ + _loc10_ / 2;
            _loc16_ = param2 + param5 / Math.cos(_loc10_ / 2) * Math.cos(_loc15_);
            _loc17_ = param3 + param5 / Math.cos(_loc10_ / 2) * Math.sin(_loc15_);
            _loc18_ = param2 + param5 * Math.cos(_loc13_);
            _loc19_ = param3 + param5 * Math.sin(_loc13_);
            param1.graphics.curveTo(_loc16_,_loc17_,_loc18_,_loc19_);
            _loc14_++;
         }
         param1.graphics.moveTo(param2 + param5 * Math.cos(_loc11_),param3 + param4 * Math.sin(_loc11_));
         param1.graphics.endFill();
      }
      
      internal function frame1() : *
      {
         this.drawSector(this.myCircle.myFrontCircle,70,70,70,45,180,-90,173817);
      }
   }
}

