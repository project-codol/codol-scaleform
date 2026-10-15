package codo.views.hud.shared
{
   import flash.display.MovieClip;
   
   public class HUDScalableRing extends MovieClip
   {
      
      public var myInner:MovieClip;
      
      public var myOuter:MovieClip;
      
      private var mRingWidth:Number;
      
      public function HUDScalableRing()
      {
         super();
      }
      
      public function set ringWidth(w:Number) : void
      {
         this.mRingWidth = w;
         this.updateInnerSize();
      }
      
      public function get ringWidth() : Number
      {
         return this.mRingWidth;
      }
      
      override public function set scaleX(s:Number) : void
      {
         super.scaleX = s;
         this.updateInnerWidth();
      }
      
      override public function set scaleY(s:Number) : void
      {
         super.scaleY = s;
         this.updateInnerHeight();
      }
      
      override public function set width(w:Number) : void
      {
         super.width = w;
         this.updateInnerWidth();
      }
      
      override public function set height(h:Number) : void
      {
         super.height = h;
         this.updateInnerHeight();
      }
      
      public function updateInnerSize() : void
      {
         this.updateInnerWidth();
         this.updateInnerHeight();
      }
      
      private function updateInnerWidth() : void
      {
         var dtWidth:Number = 2 * this.mRingWidth / scaleX;
         this.myInner.width = this.myOuter.width - dtWidth;
      }
      
      private function updateInnerHeight() : void
      {
         var dtHeight:Number = 2 * this.mRingWidth / scaleY;
         this.myInner.height = this.myOuter.height - dtHeight;
      }
   }
}

