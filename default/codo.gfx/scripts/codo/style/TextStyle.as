package codo.style
{
   import flash.text.TextFormatAlign;
   import scaleform.gfx.TextFieldEx;
   
   public class TextStyle
   {
      
      public static const VALIGN_TOP:String = TextFieldEx.VALIGN_TOP;
      
      public static const VALIGN_MIDDLE:String = TextFieldEx.VALIGN_CENTER;
      
      public static const VALIGN_BOTTOM:String = TextFieldEx.VALIGN_BOTTOM;
      
      public static const HALIGN_LEFT:String = TextFormatAlign.LEFT;
      
      public static const HALIGN_CENTER:String = TextFormatAlign.CENTER;
      
      public static const HALIGN_RIGHT:String = TextFormatAlign.RIGHT;
      
      public var font:String = "FZLanTingHei-R-GBK";
      
      public var fontSize:int = 24;
      
      public var fontColor:uint = 16777215;
      
      public var alignment:String = "left";
      
      public var alignmentVertical:String = "top";
      
      public var autoSize:String = "left";
      
      public var allCaps:Boolean = false;
      
      public var wordWrap:Boolean = false;
      
      public var multiLine:Boolean = false;
      
      public var border:Boolean = false;
      
      public var bold:Boolean = false;
      
      public var italic:Boolean = false;
      
      public function TextStyle()
      {
         super();
      }
   }
}

