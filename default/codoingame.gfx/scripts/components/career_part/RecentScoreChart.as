package components.career_part
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   
   public class RecentScoreChart extends Sprite
   {
      
      private static const MAX_POINT:uint = 15;
      
      public var myScoreLineSprite:Sprite;
      
      public var myPoint:MovieClip;
      
      private var _pointCls:Class;
      
      private var _pointInstanceAry:Array = [];
      
      protected var _posOffsetX:int = 16;
      
      protected var _posOffsetY:int = -9;
      
      protected var _lineSpace:uint = 24;
      
      protected var _totalHeight:uint = 144;
      
      protected var _lineStyleSize:uint = 2;
      
      protected var _lineStyleColor:uint = 16777215;
      
      protected var _lineStyleAlpha:Number = 0.8;
      
      public function RecentScoreChart()
      {
         super();
         this.onInit();
      }
      
      private function onInit() : void
      {
         var newPoint:MovieClip = null;
         this._pointCls = getDefinitionByName(getQualifiedClassName(this.myPoint)) as Class;
         this.removeChild(this.myPoint);
         this._pointInstanceAry.push(this.myPoint);
         for(var i:uint = 0; i < MAX_POINT; i++)
         {
            newPoint = new this._pointCls();
            newPoint.stop();
            this._pointInstanceAry.push(newPoint);
         }
      }
      
      public function set data(cDat:Array) : void
      {
         var i:uint = 0;
         this.myScoreLineSprite.graphics.clear();
         this.myScoreLineSprite.graphics.lineStyle(this._lineStyleSize,this._lineStyleColor,this._lineStyleAlpha);
         for(i = 0; i < MAX_POINT; i++)
         {
            if(this._pointInstanceAry[i].parent != null)
            {
               this.removeChild(this._pointInstanceAry[i]);
            }
         }
         var offsetX:int = this._posOffsetX;
         var offsetY:int = this._posOffsetY;
         if(cDat != null)
         {
            i = 0;
            while(i < cDat.length && i < MAX_POINT)
            {
               offsetX += this._lineSpace;
               offsetY = this._posOffsetY + (1 - cDat[i]) * this._totalHeight;
               if(i == 0)
               {
                  this.myScoreLineSprite.graphics.moveTo(offsetX,offsetY);
               }
               else
               {
                  this.myScoreLineSprite.graphics.lineTo(offsetX,offsetY);
               }
               this._pointInstanceAry[i].x = offsetX;
               this._pointInstanceAry[i].y = offsetY;
               this.addChild(this._pointInstanceAry[i]);
               if(cDat[i] >= 0.5)
               {
                  this._pointInstanceAry[i].gotoAndStop(1);
               }
               else
               {
                  this._pointInstanceAry[i].gotoAndStop(2);
               }
               i++;
            }
         }
      }
   }
}

