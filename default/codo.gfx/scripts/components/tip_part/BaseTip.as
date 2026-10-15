package components.tip_part
{
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import shaui.component.core.UIComponent;
   
   public class BaseTip extends UIComponent
   {
      
      public var myLabel:TextField;
      
      public var myBg:MovieClip;
      
      public var myPointer:MovieClip;
      
      protected var _labelMarginLeft:Number;
      
      protected var _labelMarginRight:Number;
      
      protected var _labelMarginTop:Number;
      
      protected var _labelMarginBottom:Number;
      
      public function BaseTip()
      {
         super();
         this.onInit();
         this.onInitListener();
      }
      
      override protected function onInit() : void
      {
         this._labelMarginLeft = 10;
         this._labelMarginRight = this._labelMarginLeft;
         this._labelMarginTop = 10;
         this._labelMarginBottom = 5;
         this.myLabel.autoSize = TextFieldAutoSize.LEFT;
         this.myLabel.mouseEnabled = false;
         this.myBg.mouseEnabled = false;
         mouseChildren = false;
         mouseEnabled = false;
      }
      
      public function set toolTipFormat(formatToSet:TextFormat) : void
      {
         var txtFormat:TextFormat = this.myLabel.getTextFormat();
         txtFormat.size = formatToSet.size;
         txtFormat.font = formatToSet.font;
         txtFormat.align = formatToSet.align;
         this.myLabel.border = true;
         this.myLabel.borderColor = 16711680;
         this.myLabel.setTextFormat(txtFormat);
      }
      
      override protected function onInitListener() : void
      {
      }
      
      public function set textWidth(nWidth:Number) : void
      {
         if(nWidth > 0)
         {
            this.myLabel.wordWrap = true;
            this.myLabel.width = nWidth;
            this.myLabel.multiline = true;
         }
         else
         {
            this.myLabel.multiline = true;
            this.myLabel.wordWrap = false;
         }
      }
      
      public function set data(cTxt:String) : void
      {
         this.myLabel.htmlText = LocalizeUtil.getLocalizationWithKeyBinding(cTxt);
         this.myBg.width = this._labelMarginLeft + this.myLabel.width + this._labelMarginRight;
      }
   }
}

