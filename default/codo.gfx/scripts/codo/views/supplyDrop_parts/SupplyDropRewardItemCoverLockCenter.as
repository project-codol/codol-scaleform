package codo.views.supplyDrop_parts
{
   import codo.style.GlobalGuide;
   import com.greensock.TweenLite;
   import com.greensock.easing.Back;
   import com.greensock.easing.Cubic;
   import flash.display.MovieClip;
   import flash.filters.GlowFilter;
   
   public class SupplyDropRewardItemCoverLockCenter extends MovieClip
   {
      
      private static const ANIMATE_DUR_SCALE:Number = 0.5;
      
      private static const FADE_DURATION:Number = 0.2 * ANIMATE_DUR_SCALE;
      
      private static var GLOW:GlowFilter = new GlowFilter(GlobalGuide.BLACK,0.5,25,25);
      
      private static var BUTTON_ON_FILTER:Array = [GLOW];
      
      public var myTop:MovieClip;
      
      public var myBottom:MovieClip;
      
      public var myLockTxt:MovieClip;
      
      private var mTopInitY:int;
      
      private var mBotInitY:int;
      
      public function SupplyDropRewardItemCoverLockCenter()
      {
         super();
         this.mTopInitY = this.myTop.y;
         this.mBotInitY = this.myBottom.y;
         mouseEnabled = mouseChildren = false;
      }
      
      public function set itemTierColor(colorFrame:uint) : void
      {
         this.myLockTxt.gotoAndStop(colorFrame);
         this.myBottom.gotoAndStop(colorFrame);
         this.myTop.gotoAndStop(colorFrame);
      }
      
      public function animateOpened() : void
      {
         TweenLite.to(this,FADE_DURATION,{
            "scaleX":1.2,
            "scaleY":1.2,
            "ease":Cubic.easeIn
         });
         TweenLite.to(this,0.5 * ANIMATE_DUR_SCALE,{
            "scaleX":0.9,
            "scaleY":0.9,
            "ease":Back.easeOut,
            "delay":0.4 * ANIMATE_DUR_SCALE
         });
         this.filters = [GLOW];
         gotoAndPlay(2);
      }
      
      public function animatePieces() : void
      {
         var Y_OFFSET:uint = 155;
         TweenLite.to(this.myLockTxt,FADE_DURATION,{
            "alpha":0,
            "ease":Cubic.easeIn
         });
         TweenLite.to(this.myTop,FADE_DURATION,{
            "y":this.myTop.y - Y_OFFSET,
            "ease":Cubic.easeOut,
            "delay":0.2 * ANIMATE_DUR_SCALE
         });
         TweenLite.to(this.myBottom,FADE_DURATION,{
            "y":this.myBottom.y + Y_OFFSET + 5,
            "ease":Cubic.easeOut,
            "delay":0.25 * ANIMATE_DUR_SCALE
         });
      }
      
      public function animatePiecesOut(complete:Function) : void
      {
         gotoAndStop(1);
         TweenLite.to(this.myTop,FADE_DURATION,{
            "y":this.mTopInitY,
            "ease":Cubic.easeOut
         });
         TweenLite.to(this.myBottom,FADE_DURATION,{
            "y":this.mBotInitY,
            "ease":Cubic.easeOut,
            "onComplete":complete
         });
      }
      
      public function animateFocusIn() : void
      {
         TweenLite.to(this,FADE_DURATION,{
            "scaleX":1.05,
            "scaleY":1.05,
            "ease":Cubic.easeOut
         });
         this.filters = BUTTON_ON_FILTER;
      }
      
      public function animateFocusOut() : void
      {
         TweenLite.to(this,0.1,{
            "scaleX":1,
            "scaleY":1,
            "ease":Cubic.easeOut
         });
         this.filters = [];
      }
   }
}

