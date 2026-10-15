package codo.utils
{
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import fl.motion.Color;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.filters.ColorMatrixFilter;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   
   public class GraphicUtil
   {
      
      public function GraphicUtil()
      {
         super();
      }
      
      public static function tintIt(cTarget:DisplayObject, cSpd:Number, cTintDat:String, cForceToAlpha0:Boolean = false, cTweenParams:Object = null, cTween:Boolean = true) : void
      {
         var tempCT:ColorTransform = null;
         if(cTarget != null)
         {
            if(cTween == true)
            {
               if(cTweenParams == null)
               {
                  cTweenParams = {};
               }
               cTweenParams.colorTransform = GraphicUtil.tintDatForTween(cTintDat,cForceToAlpha0);
               TweenLite.killTweensOf(cTarget);
               if(cTintDat != null)
               {
                  TweenMax.to(cTarget,cSpd,cTweenParams);
               }
               else
               {
                  TweenLite.to(cTarget,cSpd,cTweenParams);
               }
            }
            else
            {
               TweenLite.killTweensOf(cTarget);
               tempCT = GraphicUtil.tintDatForTween(cTintDat,cForceToAlpha0,0,true);
               cTarget.transform.colorTransform = tempCT;
            }
         }
         if(cTarget != null)
         {
         }
      }
      
      public static function tintDatForTween(cTintDat:String, cForceToAlpha:Boolean = false, cAlpha:Number = 0, cReturnColorTransform:Boolean = false) : *
      {
         var returnTweenTintDat:* = undefined;
         if(cReturnColorTransform == true)
         {
            returnTweenTintDat = new ColorTransform();
         }
         else
         {
            returnTweenTintDat = {};
         }
         if(cTintDat == null || cTintDat == "")
         {
            cTintDat = "0,1,0,1,0,1,0,1";
         }
         var tintAry:Array = cTintDat.split(",");
         if(cForceToAlpha == true)
         {
            tintAry[0] = 0;
            tintAry[1] = cAlpha;
         }
         returnTweenTintDat.redMultiplier = tintAry[3];
         returnTweenTintDat.greenMultiplier = tintAry[5];
         returnTweenTintDat.blueMultiplier = tintAry[7];
         returnTweenTintDat.alphaMultiplier = tintAry[1];
         returnTweenTintDat.redOffset = tintAry[2];
         returnTweenTintDat.greenOffset = tintAry[4];
         returnTweenTintDat.blueOffset = tintAry[6];
         returnTweenTintDat.alphaOffset = tintAry[0];
         return returnTweenTintDat;
      }
      
      public static function toAlpha0Tint(cTintDat:String) : String
      {
         var alpha0Tinit:String = null;
         var tempTintDat:Array = null;
         if(cTintDat == null || cTintDat == "")
         {
            alpha0Tinit = "0,0,0,1,0,1,0,1";
         }
         else
         {
            tempTintDat = cTintDat.split(",");
            tempTintDat[0] = 0;
            tempTintDat[1] = 0;
            alpha0Tinit = tempTintDat.join(",");
         }
         return alpha0Tinit;
      }
      
      public static function scaleImg(cBitmap:Bitmap = null, cWidth:uint = 0, cHeight:uint = 0) : void
      {
         var scale:Number = NaN;
         if(cBitmap == null || cWidth == 0 || cHeight == 0)
         {
            return;
         }
         cBitmap.scaleX = cBitmap.scaleY = 1;
         scale = Math.min(cHeight / cBitmap.height,cWidth / cBitmap.width);
         cBitmap.height *= scale;
         cBitmap.width *= scale;
         cBitmap.y = -cBitmap.height / 2;
         cBitmap.x = -cBitmap.width / 2;
      }
      
      public static function desaturate(item:DisplayObject, doDesaturate:Boolean = true) : void
      {
         var rc:Number = 1 / 3;
         var gc:Number = 1 / 2;
         var bc:Number = 1 / 6;
         if(!doDesaturate)
         {
            item.filters = [];
            return;
         }
         var cmFilter:ColorMatrixFilter = new ColorMatrixFilter([rc,gc,bc,0,0,rc,gc,bc,0,0,rc,gc,bc,0,0,0,0,0,1,0]);
         item.filters = [cmFilter];
      }
      
      public static function drawSector(target:Sprite, center:Point, r:Number, ir:Number, angle:Number, startAngle:Number, color:uint, alpha:Number) : void
      {
         var angleMid:Number = NaN;
         var bx:Number = NaN;
         var by:Number = NaN;
         var cx:Number = NaN;
         var cy:Number = NaN;
         if(angle <= 0)
         {
            return;
         }
         var canvas:Sprite = target;
         var x:Number = center.x;
         var y:Number = center.y;
         var r2:Number = ir;
         angle = Math.abs(angle) > 360 ? 360 : angle;
         var n:Number = Math.ceil(Math.abs(angle) / 45);
         var angleA:Number = angle / n;
         angleA = angleA * Math.PI / 180;
         var startRadian:Number = startAngle * Math.PI / 180;
         var endRadian:Number = startRadian + angle * Math.PI / 180;
         canvas.graphics.beginFill(color,alpha);
         canvas.graphics.lineStyle(1,color);
         canvas.graphics.moveTo(x + r2 * Math.cos(startRadian),y + r2 * Math.sin(startRadian));
         if(angle != 360)
         {
            canvas.graphics.lineTo(x + r * Math.cos(startRadian),y + r * Math.sin(startRadian));
         }
         else
         {
            canvas.graphics.moveTo(x + r * Math.cos(startRadian),y + r * Math.sin(startRadian));
         }
         var tempRadian:Number = startRadian;
         for(var i:int = 1; i <= n; i++)
         {
            tempRadian += angleA;
            angleMid = tempRadian - angleA / 2;
            bx = x + r / Math.cos(angleA / 2) * Math.cos(angleMid);
            by = y + r / Math.cos(angleA / 2) * Math.sin(angleMid);
            cx = x + r * Math.cos(tempRadian);
            cy = y + r * Math.sin(tempRadian);
            canvas.graphics.curveTo(bx,by,cx,cy);
         }
         if(angle != 360)
         {
            canvas.graphics.lineTo(x + r2 * Math.cos(endRadian),y + r2 * Math.sin(endRadian));
         }
         else
         {
            canvas.graphics.moveTo(x + r2 * Math.cos(endRadian),y + r2 * Math.sin(endRadian));
         }
         for(i = 1; i <= n; i++)
         {
            tempRadian -= angleA;
            angleMid = tempRadian + angleA / 2;
            bx = x + r2 / Math.cos(angleA / 2) * Math.cos(angleMid);
            by = y + r2 / Math.cos(angleA / 2) * Math.sin(angleMid);
            cx = x + r2 * Math.cos(tempRadian);
            cy = y + r2 * Math.sin(tempRadian);
            canvas.graphics.curveTo(bx,by,cx,cy);
         }
         canvas.graphics.endFill();
      }
      
      public static function tweenColor(srcColor:uint, desColor:uint, percent:Number) : uint
      {
         return Color.interpolateColor(srcColor,desColor,percent);
      }
   }
}

