package codo.component.matchselect
{
   import codo.component.ScrollList;
   import codo.objects.ScrollListSettings;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class ModeSelectScrollList extends ScrollList
   {
      
      private static const SCROLL_SPEED:Number = 0.3;
      
      public var myUpperIndicator:MatchSelectModeScrollNavButton;
      
      public var myDownIndicator:MatchSelectModeScrollNavButton;
      
      private var mTimer:Timer = new Timer(SCROLL_SPEED);
      
      private var mIsGoUp:Boolean = true;
      
      public function ModeSelectScrollList()
      {
         super();
         this.myUpperIndicator.isInteractiveEnabled = this.myDownIndicator.isInteractiveEnabled = true;
         this.myUpperIndicator.registerFocusEvent(this.onNavButtonFocused,true);
         this.myUpperIndicator.registerUnfocusEvent(this.onNavButtonUnfocused);
         this.myDownIndicator.registerFocusEvent(this.onNavButtonFocused,false);
         this.myDownIndicator.registerUnfocusEvent(this.onNavButtonUnfocused);
      }
      
      override public function set settings(newSettings:ScrollListSettings) : void
      {
         super.settings = newSettings;
         this.myUpperIndicator.rotation = 0;
         this.myUpperIndicator.x = 0;
         this.myUpperIndicator.y = 0;
         this.myDownIndicator.rotation = 180;
         this.myDownIndicator.x = 369;
         this.myDownIndicator.y = 653;
      }
      
      override protected function checkEnableArrows(pos:Number) : void
      {
         var floatErrTolerance:Number = NaN;
         super.checkEnableArrows(pos);
         if(mHeight >= _contentLength)
         {
            this.myUpperIndicator.visible = this.myDownIndicator.visible = false;
         }
         else
         {
            floatErrTolerance = 0.005;
            this.myUpperIndicator.visible = pos > 0 + floatErrTolerance;
            this.myDownIndicator.visible = pos < 1 - floatErrTolerance;
         }
      }
      
      private function onNavButtonFocused(isUpper:Object) : void
      {
         this.mIsGoUp = isUpper as Boolean;
         this.mTimer.addEventListener(TimerEvent.TIMER,this.onScrollKick);
         this.mTimer.start();
      }
      
      private function onNavButtonUnfocused() : void
      {
         this.mTimer.removeEventListener(TimerEvent.TIMER,this.onScrollKick);
         this.mTimer.stop();
      }
      
      private function onScrollKick(e:TimerEvent) : void
      {
         if(this.mIsGoUp)
         {
            doScroll(false);
         }
         else
         {
            doScroll(true);
         }
      }
   }
}

