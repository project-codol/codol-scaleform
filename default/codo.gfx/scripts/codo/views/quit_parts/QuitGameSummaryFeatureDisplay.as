package codo.views.quit_parts
{
   import codo.utils.StringUtil;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   public class QuitGameSummaryFeatureDisplay extends Sprite
   {
      
      private static const FLOOR:Function = Math.floor;
      
      private static const ADD_ZERO:Function = StringUtil.addZero;
      
      private static const MINS_SECS:int = 60;
      
      private static const HOURS_PER_DAY:int = 24;
      
      public var myHeaderTF:TextField;
      
      public var myTimeDisplayValueTF:TextField;
      
      public var myTimeDisplayLabelTF:TextField;
      
      public var myTimeBkg:Sprite;
      
      public function QuitGameSummaryFeatureDisplay()
      {
         super();
      }
      
      public function setText(header:String, label:String) : void
      {
         this.myHeaderTF.text = header;
         this.myTimeDisplayLabelTF.text = label;
      }
      
      public function setValueInSeconds(val:Number) : void
      {
         var minute:Number = FLOOR(val / MINS_SECS);
         var hours:Number = FLOOR(minute / MINS_SECS);
         var seconds:Number = FLOOR(val % MINS_SECS);
         minute %= MINS_SECS;
         hours %= HOURS_PER_DAY;
         this.myTimeDisplayValueTF.text = ADD_ZERO(hours).concat(":",ADD_ZERO(minute),":",ADD_ZERO(seconds));
      }
      
      public function showHideTimeDisplay(isAvailable:Boolean) : void
      {
         this.myTimeBkg.visible = this.myTimeDisplayLabelTF.visible = this.myTimeDisplayValueTF.visible = isAvailable;
      }
   }
}

