package codo.component.diagram
{
   import codo.component.core.UIInteractiveComponent;
   import codo.utils.ScaleformUtil;
   import flash.display.Graphics;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class CurveDiagram extends UIInteractiveComponent
   {
      
      private static const TWEEN_DURATION:int = 1;
      
      private static const FRAME_RATE:int = 30;
      
      public var myBg:MovieClip;
      
      public var myData:MovieClip;
      
      public var myPointer:MovieClip;
      
      private var mSetting:CurveDiagramSetting;
      
      private var mMinMouseOverZone:Number;
      
      private var mDataPoint:Array = [];
      
      private var mAnimationCounter:int = 0;
      
      public function CurveDiagram()
      {
         var setting:CurveDiagramSetting = null;
         var data:Array = null;
         super();
         this.myPointer.visible = false;
         if(!ScaleformUtil.isScaleform)
         {
            setting = new CurveDiagramSetting();
            setting.xMinValue = 0;
            setting.xMaxValue = 10;
            setting.yMinValue = 0;
            setting.yMaxValueSet = [2,3,4,5,6,7,8,9,10,15,20,50,100,150,200];
            this.setting = setting;
            data = [0,0,0,0,0,8,0,0,9,10];
            this.setData(data);
            this.playAnimation();
         }
         this.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMoveHandler);
      }
      
      public function set setting(setting:CurveDiagramSetting) : void
      {
         this.mSetting = setting;
      }
      
      override public function setData(data:*) : void
      {
         super.setData(data);
         this.selectMaxYValue();
         this.mMinMouseOverZone = (this.mSetting.xMaxPos - this.mSetting.xMinPos) / data.length;
      }
      
      private function selectMaxYValue() : void
      {
         var maxValue:Number = 0;
         for(var i:int = 0; i < mData.length; i++)
         {
            if(mData[i] > maxValue)
            {
               maxValue = Number(mData[i]);
            }
         }
         for(var j:int = 0; j < this.mSetting.yMaxValueSet.length; j++)
         {
            if(maxValue < this.mSetting.yMaxValueSet[j])
            {
               this.mSetting.yMaxValue = this.mSetting.yMaxValueSet[j];
               break;
            }
         }
      }
      
      private function draw(frame:int) : void
      {
         var point:Point = null;
         var prevPoint:Point = null;
         var nextPoint:Point = null;
         var curPoint:Point = null;
         var canvas:Graphics = this.myData.graphics;
         canvas.clear();
         canvas.lineStyle(3,15129610,0.7);
         var position:Number = frame * mData.length / (FRAME_RATE * TWEEN_DURATION);
         var dataIndex:int = position;
         this.mDataPoint.splice(0);
         for(var i:int = 0; i <= dataIndex; i++)
         {
            point = this.getPosition(i);
            this.mDataPoint.push(point);
            if(i == 0)
            {
               canvas.moveTo(point.x,point.y);
            }
            else
            {
               canvas.lineTo(point.x,point.y);
            }
         }
         var partial:Number = position - dataIndex;
         if(partial > 0 && dataIndex < mData.length - 1)
         {
            prevPoint = this.getPosition(dataIndex);
            nextPoint = this.getPosition(dataIndex + 1);
            curPoint = prevPoint;
            curPoint.x += (nextPoint.x - prevPoint.x) * partial;
            curPoint.y += (nextPoint.y - curPoint.y) * partial;
            canvas.lineTo(curPoint.x,curPoint.y);
         }
      }
      
      private function getPosition(dataIndex:int) : Point
      {
         var percentX:Number = (dataIndex + 1 - this.mSetting.xMinValue) / (this.mSetting.xMaxValue - this.mSetting.xMinValue);
         var posX:Number = this.mSetting.xMinPos + (this.mSetting.xMaxPos - this.mSetting.xMinPos) * percentX;
         var value:Number = Number(mData[dataIndex]);
         var percentY:Number = (value - this.mSetting.yMinValue) / (this.mSetting.yMaxValue - this.mSetting.yMinValue);
         var posY:Number = this.mSetting.yMinPos + (this.mSetting.yMaxPos - this.mSetting.yMinPos) * percentY;
         return new Point(posX,posY);
      }
      
      public function playAnimation() : void
      {
         this.cleanCanvas();
         this.mAnimationCounter = 0;
         this.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      private function cleanCanvas() : void
      {
         var canvas:Graphics = this.myData.graphics;
         canvas.clear();
      }
      
      private function onEnterFrame(evt:Event) : void
      {
         var index:int = this.mAnimationCounter;
         if(this.mAnimationCounter < FRAME_RATE * TWEEN_DURATION)
         {
            this.draw(this.mAnimationCounter);
            ++this.mAnimationCounter;
         }
         else
         {
            this.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         }
      }
      
      private function onMouseMoveHandler(e:MouseEvent) : void
      {
         var distance:Number = NaN;
         var pos:Point = null;
         var gPoint:Point = new Point(e.stageX,e.stageY);
         var lPoint:Point = this.myData.globalToLocal(gPoint);
         for(var i:int = 0; i < this.mDataPoint.length; i++)
         {
            distance = Math.sqrt(Math.pow(this.mDataPoint[i].x - lPoint.x,2) + Math.pow(this.mDataPoint[i].y - lPoint.y,2));
            if(distance < this.mMinMouseOverZone)
            {
               this.myPointer.visible = true;
               pos = globalToLocal(this.myData.localToGlobal(this.mDataPoint[i]));
               this.myPointer.x = pos.x;
               this.myPointer.y = pos.y;
               this.myPointer.myValue.text = String((mData[i] as Number).toFixed(2));
               return;
            }
         }
         this.myPointer.visible = false;
      }
   }
}

