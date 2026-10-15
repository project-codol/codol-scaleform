package codo.component.diagram
{
   import codo.component.core.UIInteractiveComponent;
   import codo.style.GlobalGuide;
   import codo.utils.GraphicUtil;
   import codo.utils.ScaleformUtil;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.text.TextField;
   
   public class CircleDiagram extends UIInteractiveComponent
   {
      
      public static const TEXT_DECIMAL:uint = 0;
      
      public static const TEXT_PERCENT:uint = 1;
      
      public static const TEXT_X_OF_Y:uint = 2;
      
      public static const TEXT_OVERRIDE:uint = 3;
      
      private static const TWEEN_DURATION:int = 1;
      
      public var myValue:TextField;
      
      public var myFrontCircle:MovieClip;
      
      public var myEndCircle:MovieClip;
      
      public var myTickMarks:MovieClip;
      
      public var myTickIcons:MovieClip;
      
      public var myBackCircle:MovieClip;
      
      private var mTweenLite:TweenLite;
      
      private var mTextType:uint;
      
      private var mFillAmount:Number;
      
      private var mMaxAmount:Number;
      
      private var mDeltaAmount:Number;
      
      private var mOuterRadius:Number = 70;
      
      private var mInnerRadius:Number = 45;
      
      private var mCenter:Point;
      
      private var mStartOffset:Number = -90;
      
      private var mFillColor:Number = 173817;
      
      private var mSecondaryFillColor:Number = 12182271;
      
      private var mUseSecondFill:Boolean = false;
      
      private var mGainFillColor:Number = 65280;
      
      private var mGainSecondaryFillColor:Number = 43520;
      
      private var mDrawTicks:Boolean = false;
      
      private var mTickIconFlags:Vector.<Boolean>;
      
      public function CircleDiagram()
      {
         super();
         this.mCenter = new Point(70,70);
         this.mTextType = TEXT_DECIMAL;
         if(!ScaleformUtil.isScaleform)
         {
            this.setFillAmount(0.8);
            this.playAnimation();
         }
         this.mTickIconFlags = new Vector.<Boolean>();
      }
      
      public function setParams(outerRadius:Number, innerRadius:Number, center:Point, startOffset:Number = -90) : void
      {
         this.mOuterRadius = outerRadius;
         this.mInnerRadius = innerRadius;
         this.mCenter = center;
         this.mStartOffset = startOffset;
      }
      
      public function setFillColor(color:Number) : void
      {
         this.mFillColor = color;
      }
      
      public function setDeltaFillColor(color:Number) : void
      {
         this.mGainFillColor = color;
      }
      
      public function setSecondaryFillColor(color:Number) : void
      {
         this.mSecondaryFillColor = color;
      }
      
      public function setUseSecondaryFill(b:Boolean) : void
      {
         this.mUseSecondFill = b;
      }
      
      public function setDrawTicks(b:Boolean) : void
      {
         this.mDrawTicks = b;
      }
      
      public function flagTickIcon(index:uint, value:Boolean) : void
      {
         this.mTickIconFlags[index] = value;
      }
      
      public function setDrawBackground(b:Boolean) : void
      {
         if(null == this.myBackCircle)
         {
            this.myBackCircle = new MovieClip();
            addChild(this.myBackCircle);
            swapChildren(this.myFrontCircle,this.myBackCircle);
         }
         this.myBackCircle.graphics.clear();
         if(b)
         {
            GraphicUtil.drawSector(this.myBackCircle,this.mCenter,this.mOuterRadius,this.mInnerRadius,360,0,GlobalGuide.CODO_GRAY_DARK,1);
         }
      }
      
      public function setTextType(type:uint) : void
      {
         this.mTextType = type;
      }
      
      public function overrideValue(value:String) : void
      {
         this.setTextType(TEXT_OVERRIDE);
         this.myValue.text = value;
      }
      
      public function setFillAmount(fillAmount:Number, maxAmount:Number = 1, deltaAmount:Number = 0) : void
      {
         maxAmount = Math.max(0,maxAmount);
         if(this.mDrawTicks && maxAmount > 1 && maxAmount != this.mMaxAmount)
         {
            this.drawTickLines(maxAmount,this.mCenter,this.mOuterRadius,this.mInnerRadius,360,this.mStartOffset,GlobalGuide.CODO_BLACK,1);
         }
         this.mMaxAmount = maxAmount;
         this.mFillAmount = Math.min(fillAmount,this.mMaxAmount);
         this.mFillAmount = Math.max(0,this.mFillAmount);
         this.mDeltaAmount = Math.min(this.mFillAmount,deltaAmount);
         this.mDeltaAmount = Math.max(0,this.mDeltaAmount);
      }
      
      public function skipAnimation() : void
      {
         this.updateFill(1);
      }
      
      public function playAnimation() : void
      {
         TweenLite.killTweensOf(this);
         this.mTweenLite = TweenLite.to(this,TWEEN_DURATION,{"onUpdate":this.onUpdateHandler});
      }
      
      public function animateTimer(duration:Number, delay:Number = 0) : void
      {
         TweenLite.killTweensOf(this);
         duration -= delay;
         if(duration > 0)
         {
            this.setFillAmount(1);
            this.skipAnimation();
            this.mTweenLite = TweenLite.to(this,duration,{
               "delay":delay,
               "onUpdate":this.onUpdateTimerHandler
            });
         }
         else
         {
            this.setFillAmount(0);
            this.skipAnimation();
         }
      }
      
      private function drawSector(angle:Number, startAngle:Number, isDelta:Boolean) : void
      {
         var secondFillOuterRadius:Number = NaN;
         var color:Number = isDelta ? this.mGainFillColor : this.mFillColor;
         GraphicUtil.drawSector(this.myFrontCircle,this.mCenter,this.mOuterRadius,this.mInnerRadius,angle,startAngle,color,alpha);
         if(this.mUseSecondFill)
         {
            secondFillOuterRadius = Math.abs((this.mOuterRadius - this.mInnerRadius) * 0.5);
            color = isDelta ? this.mGainSecondaryFillColor : this.mSecondaryFillColor;
            GraphicUtil.drawSector(this.myFrontCircle,this.mCenter,this.mOuterRadius - secondFillOuterRadius,this.mInnerRadius,angle,startAngle,color,alpha);
         }
      }
      
      private function onUpdateHandler() : void
      {
         var percent:Number = this.mTweenLite.currentTime / TWEEN_DURATION;
         this.updateFill(percent);
      }
      
      private function onUpdateTimerHandler() : void
      {
         var currPercent:Number = (this.mTweenLite.duration - this.mTweenLite.currentTime) / this.mTweenLite.duration;
         this.setFillAmount(currPercent);
         this.skipAnimation();
      }
      
      private function updateFill(percent:Number) : void
      {
         var deltaFill:Number = NaN;
         var deltaAngle:Number = NaN;
         if(this.mMaxAmount <= 0)
         {
            return;
         }
         var endAmount:Number = this.mFillAmount * percent;
         var endFill:Number = endAmount / this.mMaxAmount;
         var baseAmount:Number = Math.min(endAmount,this.mFillAmount - this.mDeltaAmount);
         var baseFill:Number = baseAmount / this.mMaxAmount;
         var angle:Number = 360 * baseFill;
         this.myFrontCircle.graphics.clear();
         this.drawSector(angle,this.mStartOffset,false);
         if(endAmount > baseAmount)
         {
            deltaFill = (endAmount - baseAmount) / this.mMaxAmount;
            deltaAngle = 360 * deltaFill;
            this.drawSector(deltaAngle,angle + this.mStartOffset,true);
         }
         if(this.mTextType == TEXT_DECIMAL)
         {
            this.myValue.text = endFill.toFixed(2);
         }
         else if(this.mTextType == TEXT_PERCENT)
         {
            this.myValue.text = (endFill * 100).toFixed(2) + "%";
         }
         else if(this.mTextType == TEXT_X_OF_Y)
         {
            this.myValue.text = this.mFillAmount.toString() + "/" + this.mMaxAmount.toString();
         }
      }
      
      private function drawTickLines(numTickSections:uint, center:Point, r:Number, ir:Number, angle:Number, startAngle:Number, color:uint, alpha:Number) : void
      {
         var sectionSize:Number = NaN;
         var n:Number = NaN;
         var bx:Number = NaN;
         var by:Number = NaN;
         var cx:Number = NaN;
         var cy:Number = NaN;
         var tempRadianMid:Number = NaN;
         if(angle <= 0)
         {
            return;
         }
         angle = Math.abs(angle) > 360 ? 360 : angle;
         if(null == this.myTickMarks)
         {
            this.myTickMarks = new MovieClip();
            addChild(this.myTickMarks);
         }
         if(null == this.myTickIcons)
         {
            this.myTickIcons = new MovieClip();
            addChild(this.myTickIcons);
         }
         this.myTickMarks.graphics.clear();
         this.myTickMarks.graphics.beginFill(color,alpha);
         this.myTickMarks.graphics.lineStyle(5,color);
         this.myTickIcons.graphics.clear();
         this.myTickIcons.graphics.beginFill(6710886,0.7);
         this.myTickIcons.graphics.lineStyle(1,6710886,0.7);
         var x:Number = center.x;
         var y:Number = center.y;
         sectionSize = 360 / numTickSections;
         n = Math.ceil(Math.abs(angle) / sectionSize);
         var angleA:Number = angle / n * Math.PI / 180;
         var cr:Number = (r + ir) / 2;
         var tempRadian:Number = startAngle * Math.PI / 180;
         for(var i:int = 0; i < n; i++)
         {
            bx = x + r * Math.cos(tempRadian);
            by = y + r * Math.sin(tempRadian);
            cx = x + ir * Math.cos(tempRadian);
            cy = y + ir * Math.sin(tempRadian);
            this.myTickMarks.graphics.moveTo(cx,cy);
            this.myTickMarks.graphics.lineTo(bx,by);
            if(i < this.mTickIconFlags.length && this.mTickIconFlags[i])
            {
               tempRadianMid = tempRadian + angleA / 2;
               bx = x + cr * Math.cos(tempRadianMid);
               by = y + cr * Math.sin(tempRadianMid);
               this.myTickIcons.graphics.drawCircle(bx,by,3);
            }
            tempRadian += angleA;
         }
         this.myTickMarks.graphics.endFill();
         this.myTickIcons.graphics.endFill();
      }
   }
}

