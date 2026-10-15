package awesomium
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class DropDownMenuItem extends BaseMc
   {
      
      public static const STATE_OVER:int = 0;
      
      public static const STATE_OUT:int = 1;
      
      private static const OUT_FRAME:String = "out";
      
      private static const OVER_FRAME:String = "over";
      
      private var myBg:MovieClip;
      
      private var myHitArea:MovieClip;
      
      private var myText:MovieClip;
      
      public function DropDownMenuItem(asset:MovieClip)
      {
         super(asset);
      }
      
      override protected function assembleAsset() : void
      {
         this.myBg = m_rawAsset["myBg"];
         this.myHitArea = m_rawAsset["myHitArea"];
         this.myText = m_rawAsset["myText"];
         this.myBg.gotoAndStop(OUT_FRAME);
         this.myText.gotoAndStop(OUT_FRAME);
         addChild(this.myBg);
         addChild(this.myText);
         addChild(this.myHitArea);
      }
      
      override protected function registerListener() : void
      {
         this.myHitArea.addEventListener(MouseEvent.ROLL_OVER,this.onMouseRollOverHandler);
      }
      
      private function onMouseRollOverHandler(e:MouseEvent) : void
      {
         this.setState(STATE_OVER);
      }
      
      public function setState(state:int) : void
      {
         if(state == STATE_OUT)
         {
            this.myBg.gotoAndStop(OUT_FRAME);
            this.myText.gotoAndStop(OUT_FRAME);
         }
         else if(state == STATE_OVER)
         {
            this.myBg.gotoAndStop(OVER_FRAME);
            this.myText.gotoAndStop(OVER_FRAME);
         }
      }
      
      public function setLabel(text:String) : void
      {
         (this.myText["myLabel"]["myTF"] as TextField).text = text;
         this.setWidth((this.myText["myLabel"]["myTF"] as TextField).textWidth);
      }
      
      public function setTextSize(fontSize:Number) : void
      {
         var tff:TextFormat = (this.myText["myLabel"]["myTF"] as TextField).getTextFormat();
         tff.size = fontSize;
         (this.myText["myLabel"]["myTF"] as TextField).setTextFormat(tff);
         this.myHitArea.height = this.myBg.height = (this.myText["myLabel"]["myTF"] as TextField).textHeight;
      }
      
      public function setItemSize(w:int, h:int) : void
      {
         this.myHitArea.width = this.myBg.width = w;
         (this.myText["myLabel"]["myTF"] as TextField).width = w;
      }
      
      public function setWidth(value:Number) : void
      {
         this.myBg.width = value;
         (this.myText["myLabel"]["myTF"] as TextField).width = value;
      }
      
      override protected function unregisterListener() : void
      {
         this.myHitArea.removeEventListener(MouseEvent.ROLL_OVER,this.onMouseRollOverHandler);
      }
   }
}

