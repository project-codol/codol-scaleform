package codo.component
{
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.ColorTransform;
   
   public class SliderBar extends MovieClip
   {
      
      private static var ANIM_DURATION:Number = 0.4;
      
      public var myFill:Sprite;
      
      public var myFillCap:Sprite;
      
      public var myFillCapMask:Sprite;
      
      public var myBonusFill:Sprite;
      
      public var myFillBG:Sprite;
      
      private var mFillPercent:Number = 0;
      
      private var mBonusFillPercent:Number = 0;
      
      private var mWidth:Number = 0;
      
      private var mHeight:Number = 0;
      
      public function SliderBar()
      {
         super();
         this.mWidth = this.myFillBG.width;
         this.mHeight = this.myFillBG.height;
         this.myBonusFill.visible = false;
      }
      
      override public function set width(w:Number) : void
      {
         this.mWidth = w;
         this.draw();
      }
      
      override public function get width() : Number
      {
         return this.mWidth;
      }
      
      override public function set height(w:Number) : void
      {
         this.mHeight = w;
         this.draw();
      }
      
      override public function get height() : Number
      {
         return this.mHeight;
      }
      
      public function set fillColor(c:Number) : void
      {
         var newColor:ColorTransform = new ColorTransform();
         newColor.color = c;
         this.myFill.transform.colorTransform = newColor;
      }
      
      public function resetFillColor() : void
      {
         this.fillColor = 5293055;
      }
      
      public function set fillPercent(p:Number) : void
      {
         this.mFillPercent = p;
         this.draw();
      }
      
      public function get fillPercent() : Number
      {
         return this.mFillPercent;
      }
      
      public function set bonusFillPercent(p:Number) : void
      {
         this.mBonusFillPercent = p;
         this.draw();
      }
      
      public function get bonusFillPercent() : Number
      {
         return this.mFillPercent;
      }
      
      public function prepareForShow() : void
      {
         this.myFill.width = 0;
         this.myBonusFill.width = 0;
         this.myFillCap.x = this.myFill.x - this.myFillCap.width;
      }
      
      public function show(startDelay:Number = 0) : void
      {
         this.myFillCap.x = this.myFill.x + this.myFill.width - this.myFillCap.width;
         TweenLite.to(this.myFill,ANIM_DURATION,{
            "width":this.myFillBG.width * this.mFillPercent,
            "onComplete":this.showBonus,
            "onUpdate":this.onShowUpdate,
            "delay":startDelay
         });
      }
      
      public function onShowUpdate() : void
      {
         this.myFillCap.x = this.myFill.x + this.myFill.width - this.myFillCap.width;
      }
      
      public function showBonus() : void
      {
         TweenLite.to(this.myBonusFill,ANIM_DURATION,{"width":this.myFillBG.width * this.mBonusFillPercent});
      }
      
      private function draw() : void
      {
         this.myFillCapMask.width = this.myFillBG.width = this.mWidth;
         this.myFillCapMask.height = this.myFillBG.height = this.mHeight;
         this.myBonusFill.height = this.myFillCap.height = this.myFillCap.width = this.myFill.height = this.myFillBG.height = this.mHeight;
         this.myFill.width = this.myFillBG.width * this.mFillPercent;
         this.myFillCap.x = this.myFill.x + this.myFill.width - this.myFillCap.width;
         if(this.mBonusFillPercent > 0)
         {
            this.myBonusFill.width = this.myFillBG.width * this.mBonusFillPercent;
            this.myBonusFill.x = this.myFill.x + this.myFill.width;
            this.myBonusFill.visible = true;
         }
         else
         {
            this.myBonusFill.visible = false;
         }
      }
   }
}

