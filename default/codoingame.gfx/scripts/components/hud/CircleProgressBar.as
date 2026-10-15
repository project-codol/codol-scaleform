package components.hud
{
   import codo.utils.GraphicUtil;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.geom.Point;
   
   public class CircleProgressBar extends ProgressBar
   {
      
      public static const SECTOR_START_OFFSET:Number = 270;
      
      public var mMaskFill:Number = 0;
      
      public function CircleProgressBar()
      {
         super();
      }
      
      override protected function doSetProgress(progress:Number, oldProgress:Number, animated:Boolean) : void
      {
         if(animated)
         {
            mTween = TweenLite.to(this,AnimationLength,{
               "maskFill":progress,
               "onComplete":this.onAnimateComplete
            });
         }
         else
         {
            this.maskFill = progress;
         }
      }
      
      public function set maskFill(progress:Number) : void
      {
         myFill.alpha = progress <= 0 ? 0 : 1;
         if(progress == this.maskFill)
         {
            return;
         }
         myMask = this.setFillProgressMask(myFill,myMask,progress);
         this.mMaskFill = progress;
      }
      
      public function get maskFill() : Number
      {
         return this.mMaskFill;
      }
      
      public function onAnimateComplete() : void
      {
         mTween = null;
      }
      
      protected function setFillProgressMask(fill:MovieClip, mask:MovieClip, progress:Number, startAngle:Number = 270) : MovieClip
      {
         var maskCenter:Point = null;
         if(mask == null)
         {
            mask = new MovieClip();
            this.addChild(mask);
            fill.mask = mask;
            mask.x = fill.x;
            mask.y = fill.y;
         }
         mask.graphics.clear();
         if(progress > 0)
         {
            maskCenter = new Point(fill.width / 2,fill.height / 2);
            GraphicUtil.drawSector(mask,maskCenter,fill.width / 2,0,progress * 360,startAngle,16711680,1);
         }
         return mask;
      }
   }
}

