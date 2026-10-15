package codo.views.supplyDrop_parts
{
   import codo.constants.MarketMenuData;
   import com.greensock.TweenLite;
   import com.greensock.easing.Linear;
   import flash.display.MovieClip;
   
   public class SupplyDropRewardDustProgressBarIcon extends MovieClip
   {
      
      public var myGlow1:MovieClip;
      
      public var myGlow2:MovieClip;
      
      public var myLeft:MovieClip;
      
      public var myMiddle:MovieClip;
      
      public var myRight:MovieClip;
      
      public function SupplyDropRewardDustProgressBarIcon()
      {
         super();
         gotoAndStop(1);
         this.myGlow1.alpha = 0;
         this.myGlow2.alpha = 0;
      }
      
      public function set dropId(dropId:int) : void
      {
         switch(dropId)
         {
            case MarketMenuData.SUPPLY_DROP_BASIC:
               this.myLeft.gotoAndStop(1);
               this.myMiddle.gotoAndStop(1);
               this.myRight.gotoAndStop(1);
               break;
            case MarketMenuData.SUPPLY_DROP_ADVANCED:
               this.myLeft.gotoAndStop(2);
               this.myMiddle.gotoAndStop(2);
               this.myRight.gotoAndStop(2);
               break;
            case MarketMenuData.SUPPLY_DROP_EVENT:
               this.myLeft.gotoAndStop(3);
               this.myMiddle.gotoAndStop(3);
               this.myRight.gotoAndStop(3);
         }
      }
      
      override public function get width() : Number
      {
         return 280;
      }
      
      override public function get height() : Number
      {
         return 204;
      }
      
      public function open() : void
      {
         var DURATION:Number = 1;
         this.myGlow1.alpha = 0;
         this.myGlow2.alpha = 0;
         TweenLite.to(this.myGlow1,DURATION,{"alpha":1});
         TweenLite.to(this.myLeft,DURATION,{
            "x":-45.75,
            "y":-8,
            "ease":Linear.easeOut
         });
         TweenLite.to(this.myMiddle,DURATION,{
            "x":-35.5,
            "y":-37.5,
            "ease":Linear.easeOut
         });
         TweenLite.to(this.myRight,DURATION,{
            "x":7,
            "y":-2,
            "ease":Linear.easeOut
         });
      }
      
      public function close(completeCallback:Function) : void
      {
         var DURATION:Number = 0.5;
         TweenLite.to(this.myGlow1,DURATION,{"alpha":0});
         TweenLite.to(this.myLeft,DURATION,{
            "x":-41.75,
            "y":-11.5,
            "ease":Linear.easeIn
         });
         TweenLite.to(this.myMiddle,DURATION,{
            "x":-38,
            "y":-32,
            "ease":Linear.easeIn
         });
         TweenLite.to(this.myRight,DURATION,{
            "x":4,
            "y":-7,
            "ease":Linear.easeIn,
            "onComplete":completeCallback
         });
      }
      
      public function showGlow() : void
      {
         var DURATION:Number = NaN;
         DURATION = 0.5;
         this.myGlow1.alpha = 0;
         this.myGlow2.alpha = 0;
         TweenLite.to(this.myGlow2,DURATION,{
            "delay":0.2,
            "alpha":1,
            "onComplete":this.hideGlow
         });
      }
      
      public function hideGlow() : void
      {
         var DURATION:Number = 1;
         TweenLite.to(this.myGlow2,DURATION,{"alpha":0});
      }
   }
}

