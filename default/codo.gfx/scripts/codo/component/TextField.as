package codo.component
{
   import codo.component.core.UIInteractiveComponent;
   import codo.style.TextStyle;
   import codo.utils.StringUtil;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import scaleform.gfx.TextFieldEx;
   
   public class TextField extends UIInteractiveComponent
   {
      
      public var myTextClip:flash.text.TextField;
      
      private var mTextFormat:TextFormat;
      
      private var mTextStyle:TextStyle;
      
      private var mWidth:Number = 0;
      
      private var mHeight:Number = 0;
      
      private var mLabel:String;
      
      private var mEnableTruncate:Boolean = false;
      
      private var mMaxLines:int = 0;
      
      public function TextField()
      {
         super();
         this.mTextStyle = new TextStyle();
         this.mTextFormat = this.myTextClip.getTextFormat();
         this.mWidth = this.myTextClip.textWidth;
         this.mHeight = this.myTextClip.textHeight;
         this.mLabel = this.myTextClip.text;
      }
      
      override public function setData(data:*) : void
      {
         super.setData(data);
         if(null != data.label)
         {
            this.text = data.label;
         }
      }
      
      public function setBorder(useBorder:Boolean = true, borderColor:uint = 16711680) : void
      {
         this.myTextClip.border = useBorder;
         if(useBorder)
         {
            this.myTextClip.borderColor = borderColor;
         }
      }
      
      public function set text(txt:String) : void
      {
         this.mLabel = txt;
         this.myTextClip.text = this.mTextStyle.allCaps ? txt.toUpperCase() : txt;
         if(this.mEnableTruncate)
         {
            StringUtil.fitTextField(this.myTextClip);
         }
         if(this.mMaxLines > 0)
         {
            StringUtil.cutOffString(this.myTextClip,this.mMaxLines);
         }
      }
      
      public function get text() : String
      {
         return this.mLabel;
      }
      
      public function get numLines() : int
      {
         return this.myTextClip.numLines;
      }
      
      public function set htmlText(txt:String) : void
      {
         this.mLabel = txt;
         this.myTextClip.htmlText = this.mTextStyle.allCaps ? txt.toUpperCase() : txt;
      }
      
      public function get htmlText() : String
      {
         return this.mLabel;
      }
      
      public function set allCaps(caps:Boolean) : void
      {
         this.mTextStyle.allCaps = caps;
         this.text = this.mLabel;
      }
      
      public function get allCaps() : Boolean
      {
         return this.mTextStyle.allCaps;
      }
      
      public function set autoSize(autoSize:String) : void
      {
         this.myTextClip.autoSize = autoSize;
      }
      
      public function set alignment(align:String) : void
      {
         this.mTextStyle.alignment = align;
         this.mTextFormat.align = align;
         this.onFormatChange();
      }
      
      public function get alignment() : String
      {
         return this.myTextClip.getTextFormat().align;
      }
      
      public function set alignmentVertical(align:String) : void
      {
         TextFieldEx.setVerticalAlign(this.myTextClip,align);
      }
      
      public function set font(font:String) : void
      {
         this.mTextStyle.font = font;
         this.mTextFormat.font = font;
         this.onFormatChange();
      }
      
      public function get font() : String
      {
         return this.myTextClip.getTextFormat().font;
      }
      
      public function set fontSize(size:Number) : void
      {
         this.mTextStyle.fontSize = size;
         this.mTextFormat.size = size;
         this.onFormatChange();
      }
      
      public function get fontSize() : Number
      {
         return this.myTextClip.getTextFormat().size as Number;
      }
      
      public function set fontColor(color:uint) : void
      {
         this.mTextFormat.color = color;
         this.onFormatChange();
         this.mTextStyle.fontColor = color;
         this.myTextClip.textColor = color;
      }
      
      public function get fontColor() : uint
      {
         return this.myTextClip.textColor;
      }
      
      override public function set width(w:Number) : void
      {
         this.myTextClip.width = w;
         this.mWidth = w;
         this.alignment = this.mTextStyle.alignment;
      }
      
      override public function get width() : Number
      {
         return this.mWidth;
      }
      
      public function get textWidth() : Number
      {
         return this.myTextClip.textWidth;
      }
      
      public function get textHeight() : Number
      {
         return this.myTextClip.textHeight;
      }
      
      override public function set height(h:Number) : void
      {
         this.myTextClip.height = h;
         this.mHeight = h;
      }
      
      override public function get height() : Number
      {
         return this.mHeight;
      }
      
      public function set textStyle(fmt:TextStyle) : void
      {
         this.mTextStyle = fmt;
         this.font = this.mTextStyle.font;
         this.fontSize = this.mTextStyle.fontSize;
         this.fontColor = this.mTextStyle.fontColor;
         this.alignment = this.mTextStyle.alignment;
         this.alignmentVertical = this.mTextStyle.alignmentVertical;
         this.wordWrap = fmt.wordWrap;
         this.multiline = fmt.multiLine;
         this.autoSize = this.mTextStyle.autoSize;
         this.bold = this.mTextStyle.bold;
         this.italic = this.mTextStyle.italic;
         this.setBorder(this.mTextStyle.border);
      }
      
      public function get textStyle() : TextStyle
      {
         return this.mTextStyle;
      }
      
      public function set wordWrap(wrap:Boolean) : void
      {
         this.mTextStyle.wordWrap = wrap;
         this.myTextClip.wordWrap = wrap;
      }
      
      public function set multiline(doMultiLine:Boolean) : void
      {
         this.mTextStyle.multiLine = doMultiLine;
         this.myTextClip.multiline = doMultiLine;
      }
      
      public function set bold(doBold:Boolean) : void
      {
         this.mTextStyle.bold = doBold;
         this.mTextFormat.bold = doBold;
         this.onFormatChange();
      }
      
      public function get bold() : Boolean
      {
         return this.mTextStyle.bold;
      }
      
      public function set italic(doItalic:Boolean) : void
      {
         this.mTextStyle.italic = doItalic;
         this.mTextFormat.italic = doItalic;
         this.onFormatChange();
      }
      
      public function get italic() : Boolean
      {
         return this.mTextStyle.italic;
      }
      
      public function get wordWrap() : Boolean
      {
         return this.mTextStyle.wordWrap;
      }
      
      protected function onFormatChange() : void
      {
         this.myTextClip.defaultTextFormat = this.mTextFormat;
         this.myTextClip.setTextFormat(this.mTextFormat);
      }
      
      override public function set enabled(newEnable:Boolean) : void
      {
         super.enabled = newEnable;
         this.myTextClip.tabEnabled = this.myTextClip.mouseEnabled = newEnable;
      }
      
      public function enableTruncate(enable:Boolean) : void
      {
         this.mEnableTruncate = enable;
      }
      
      public function set maxLines(lines:int) : void
      {
         this.mMaxLines = lines;
      }
   }
}

