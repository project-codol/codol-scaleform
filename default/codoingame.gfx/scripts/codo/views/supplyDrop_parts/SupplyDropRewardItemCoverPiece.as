package codo.views.supplyDrop_parts
{
   import com.greensock.TweenLite;
   import com.greensock.easing.Bounce;
   import com.greensock.easing.Cubic;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class SupplyDropRewardItemCoverPiece extends MovieClip
   {
      
      private static const ANIMATE_DUR_SCALE:Number = 0.5;
      
      protected static const Y_OFFSET:uint = 122;
      
      private static const Y_SHIFT_OFFSET:Number = 0.01;
      
      public var myShadow:Sprite;
      
      protected var mEndY:int;
      
      public function SupplyDropRewardItemCoverPiece()
      {
         super();
         this.mEndY = this.y;
         this.myShadow.visible = false;
         this.myShadow.alpha = 0;
      }
      
      public function animateOpen() : void
      {
         this.myShadow.visible = true;
         TweenLite.to(this,0.45 * ANIMATE_DUR_SCALE,{
            "y":this.animationTargetY,
            "ease":Bounce.easeOut
         });
         TweenLite.to(this.myShadow,0.4 * ANIMATE_DUR_SCALE,{
            "alpha":1,
            "ease":Cubic.easeOut
         });
      }
      
      public function set cardTypeByID(typeID:int) : void
      {
         gotoAndStop(typeID);
      }
      
      public function animateClose() : void
      {
         this.myShadow.visible = true;
         TweenLite.to(this,0.45 * ANIMATE_DUR_SCALE,{
            "y":this.mEndY,
            "ease":Bounce.easeOut
         });
         TweenLite.to(this.myShadow,0.4 * ANIMATE_DUR_SCALE,{
            "alpha":0,
            "ease":Cubic.easeOut
         });
      }
      
      public function animateFocusIn() : void
      {
         TweenLite.to(this,0.3 * ANIMATE_DUR_SCALE,{
            "y":this.mEndY + this.animationTargetY * Y_SHIFT_OFFSET,
            "ease":Cubic.easeOut
         });
      }
      
      public function animateFocusOut() : void
      {
         TweenLite.to(this,0.3 * ANIMATE_DUR_SCALE,{
            "y":this.mEndY,
            "ease":Cubic.easeOut
         });
      }
      
      public function get animationTargetY() : int
      {
         return this.mEndY - Y_OFFSET;
      }
      
      protected function get shadowAnimationTargetY() : int
      {
         return 0;
      }
   }
}

