package awesomium
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class MessageBoxButton extends BaseMc
   {
      
      public static const CLICK_EVENT:String = "clickevent";
      
      private static const OUT_FRAME:String = "out";
      
      private static const OVER_FRAME:String = "over";
      
      private var myText:TextField;
      
      private var myHitArea:MovieClip;
      
      public function MessageBoxButton(asset:MovieClip)
      {
         super(asset);
      }
      
      override protected function assembleAsset() : void
      {
         this.myText = m_rawAsset["myText"];
         this.myHitArea = m_rawAsset["myHitArea"];
         addChild(m_rawAsset);
      }
      
      override protected function registerListener() : void
      {
         this.myHitArea.addEventListener(MouseEvent.ROLL_OVER,this.onMouseRollOverHandler);
         this.myHitArea.addEventListener(MouseEvent.ROLL_OUT,this.onMouseRollOutHandler);
         this.myHitArea.addEventListener(MouseEvent.CLICK,this.onMouseClickHandler);
      }
      
      private function onMouseRollOverHandler(e:MouseEvent) : void
      {
         m_rawAsset.gotoAndStop(OVER_FRAME);
      }
      
      private function onMouseRollOutHandler(e:MouseEvent) : void
      {
         m_rawAsset.gotoAndStop(OUT_FRAME);
      }
      
      private function onMouseClickHandler(e:MouseEvent) : void
      {
         dispatchEvent(new Event(CLICK_EVENT));
      }
      
      public function setLabel(text:String) : void
      {
         this.myText.text = text;
      }
      
      override protected function unregisterListener() : void
      {
         this.myHitArea.removeEventListener(MouseEvent.ROLL_OVER,this.onMouseRollOutHandler);
         this.myHitArea.removeEventListener(MouseEvent.ROLL_OUT,this.onMouseRollOutHandler);
      }
   }
}

