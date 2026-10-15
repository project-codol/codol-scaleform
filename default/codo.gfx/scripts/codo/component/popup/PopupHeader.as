package codo.component.popup
{
   import codo.style.GlobalGuide;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import scaleform.gfx.TextFieldEx;
   
   public class PopupHeader extends Sprite
   {
      
      private static const PADDING:uint = 20;
      
      public var myHeaderTF:TextField;
      
      public var myBkg:Sprite;
      
      public var myErrorIcon:Sprite;
      
      public var myErrorBkg:Sprite;
      
      private var mBaseHeaderTextFormat:TextFormat;
      
      public function PopupHeader()
      {
         super();
         this.myHeaderTF.autoSize = TextFieldAutoSize.LEFT;
         TextFieldEx.setVerticalAlign(this.myHeaderTF,TextFieldEx.VALIGN_CENTER);
         this.mBaseHeaderTextFormat = this.myHeaderTF.getTextFormat();
      }
      
      public function set title(txt:String) : void
      {
         this.resetDisplay();
         this.myHeaderTF.text = txt;
      }
      
      public function setErrorMode(msg:String) : void
      {
         var offset:uint = this.myErrorIcon.x + this.myErrorIcon.width;
         this.title = msg;
         this.myErrorBkg.visible = this.myErrorIcon.visible = true;
         this.myBkg.visible = false;
         this.mBaseHeaderTextFormat.size = GlobalGuide.FONT_SIZE_SMALL;
         this.mBaseHeaderTextFormat.color = GlobalGuide.CODO_RED;
         this.myHeaderTF.setTextFormat(this.mBaseHeaderTextFormat);
         this.myHeaderTF.x = offset;
      }
      
      public function setTextFormat(fmt:TextFormat) : void
      {
         this.mBaseHeaderTextFormat = fmt;
         this.myHeaderTF.setTextFormat(this.mBaseHeaderTextFormat);
      }
      
      public function getTextFormat() : TextFormat
      {
         return this.mBaseHeaderTextFormat;
      }
      
      protected function resetDisplay() : void
      {
         this.myErrorIcon.visible = this.myErrorBkg.visible = false;
         this.myBkg.visible = true;
         this.myHeaderTF.x = PADDING;
         this.mBaseHeaderTextFormat.size = GlobalGuide.FONT_SIZE_LARGE;
         this.mBaseHeaderTextFormat.color = GlobalGuide.WHITE;
         this.myHeaderTF.setTextFormat(this.mBaseHeaderTextFormat);
      }
      
      override public function set width(value:Number) : void
      {
         var finalWidth:uint = Math.max(value,this.myHeaderTF.textWidth + PADDING);
         this.myHeaderTF.width = this.myBkg.width = this.myErrorBkg.width = finalWidth - 10;
      }
   }
}

