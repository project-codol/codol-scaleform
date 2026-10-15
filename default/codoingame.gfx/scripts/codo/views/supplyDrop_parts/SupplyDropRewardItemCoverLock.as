package codo.views.supplyDrop_parts
{
   import com.greensock.TweenLite;
   import com.greensock.easing.Linear;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class SupplyDropRewardItemCoverLock extends Sprite
   {
      
      private static const ANIMATE_DUR_SCALE:Number = 0.5;
      
      private static const FADE_DURATION:Number = 0.3 * ANIMATE_DUR_SCALE;
      
      public var myLockCenter:SupplyDropRewardItemCoverLockCenter;
      
      public var myLockPieceBottom:MovieClip;
      
      public var myLockPieceTop:MovieClip;
      
      public function SupplyDropRewardItemCoverLock()
      {
         super();
      }
      
      public function set cardTypeByID(colorFrame:int) : void
      {
         this.myLockCenter.itemTierColor = colorFrame;
         this.myLockPieceBottom.gotoAndStop(colorFrame);
         this.myLockPieceTop.gotoAndStop(colorFrame);
      }
      
      public function animateOpened(callback:Function) : void
      {
         var endTopX:int = this.myLockPieceTop.x - this.myLockPieceTop.width;
         var endBotX:int = this.myLockPieceBottom.x + this.myLockPieceBottom.width;
         TweenLite.to(this.myLockPieceTop,FADE_DURATION,{
            "x":endTopX,
            "alpha":0,
            "ease":Linear.easeNone,
            "delay":0.2 * ANIMATE_DUR_SCALE,
            "onComplete":this.myLockCenter.animatePieces
         });
         TweenLite.to(this.myLockPieceBottom,FADE_DURATION,{
            "x":endBotX,
            "alpha":0,
            "ease":Linear.easeNone,
            "delay":0.3 * ANIMATE_DUR_SCALE,
            "onComplete":callback
         });
         this.myLockCenter.animateOpened();
      }
      
      public function animateFocusIn() : void
      {
         this.myLockCenter.animateFocusIn();
      }
      
      public function animateFocusOut() : void
      {
         this.myLockCenter.animateFocusOut();
      }
   }
}

