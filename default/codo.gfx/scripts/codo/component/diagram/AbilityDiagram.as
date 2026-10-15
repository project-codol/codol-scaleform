package codo.component.diagram
{
   import codo.component.core.UIInteractiveComponent;
   import codo.utils.ScaleformUtil;
   import com.greensock.TweenLite;
   import flash.display.Graphics;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.text.TextField;
   
   public class AbilityDiagram extends UIInteractiveComponent
   {
      
      private static const TWEEN_DURATION:int = 1;
      
      public var myAbility0Label:TextField;
      
      public var myAbility1Label:TextField;
      
      public var myAbility2Label:TextField;
      
      public var myAbility3Label:TextField;
      
      public var myAbility4Label:TextField;
      
      public var myAbility5Label:TextField;
      
      public var myDiagram:MovieClip;
      
      private var mTweenLite:TweenLite;
      
      private var mOrigin:Point = new Point(87,100.6);
      
      private var mEnds:Array = [new Point(87,0),new Point(173.4,50),new Point(173.4,150),new Point(87,200),new Point(0,150),new Point(0,50)];
      
      public function AbilityDiagram()
      {
         var data:Object = null;
         super();
         if(!ScaleformUtil.isScaleform)
         {
            data = [new AbilityDiagramData(0,1,0),new AbilityDiagramData(0,1,0),new AbilityDiagramData(0,1,0),new AbilityDiagramData(0,1,0),new AbilityDiagramData(0,1,0),new AbilityDiagramData(0,1,1)];
            this.setData(data);
            this.playAnimation();
         }
      }
      
      override public function setData(data:*) : void
      {
         super.setData(data);
      }
      
      private function onUpdateHandler() : void
      {
         var value:Number = NaN;
         var max:Number = NaN;
         var min:Number = NaN;
         var dest:Number = NaN;
         var current:Number = NaN;
         var xDelta:int = 0;
         var yDelta:int = 0;
         var destPoint:Point = null;
         var percent:Number = this.mTweenLite.currentTime / TWEEN_DURATION;
         var points:Array = [];
         for(var index:int = 0; index < 6; index++)
         {
            value = Number(mData[index].current);
            max = Number(mData[index].max);
            min = Number(mData[index].min);
            if(value > max)
            {
               value = max;
            }
            if(value < min)
            {
               value = min;
            }
            dest = (value - min) / (max - min);
            current = (1 - dest) * percent;
            xDelta = this.mEnds[index].x - this.mOrigin.x;
            yDelta = this.mEnds[index].y - this.mOrigin.y;
            destPoint = new Point();
            destPoint.x = this.mEnds[index].x - xDelta * current;
            destPoint.y = this.mEnds[index].y - yDelta * current;
            points.push(destPoint);
         }
         var canvas:Graphics = this.myDiagram.graphics;
         canvas.clear();
         canvas.lineStyle(2,16777215,1);
         canvas.moveTo(points[0].x,points[0].y);
         for(var i:int = 1; i < 6; i++)
         {
            canvas.lineTo(points[i].x,points[i].y);
            canvas.moveTo(points[i].x,points[i].y);
         }
         canvas.lineTo(points[0].x,points[0].y);
      }
      
      public function playAnimation() : void
      {
         this.mTweenLite = TweenLite.to(this,TWEEN_DURATION,{"onUpdate":this.onUpdateHandler});
      }
   }
}

