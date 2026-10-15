package codo.objects
{
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import flash.text.TextFormat;
   
   public class ToolTipObject
   {
      
      public static const ARROW_POSITION_TOP:uint = 0;
      
      public static const ARROW_POSITION_RIGHT:uint = 1;
      
      public static const ARROW_POSITION_BOTTOM:uint = 2;
      
      public static const ARROW_POSITION_LEFT:uint = 3;
      
      public var requestClip:DisplayObject;
      
      public var textFormatting:TextFormat;
      
      public var offsetPoint:Point;
      
      public var contents:String;
      
      public var setWidth:int;
      
      public var setHeight:int;
      
      public var showArrow:Boolean;
      
      public var arrowPosition:uint;
      
      public function ToolTipObject(requestClip:DisplayObject, contents:String = null, textFormatting:TextFormat = null, offsetX:int = 0, offsetY:int = 0, setWidth:int = -1, setHeight:int = -1, showArrow:Boolean = false, arrowPosition:uint = 0)
      {
         super();
         this.requestClip = requestClip;
         this.contents = contents;
         this.textFormatting = textFormatting;
         this.offsetPoint = new Point(offsetX,offsetY);
         this.setWidth = setWidth;
         this.setHeight = setHeight;
         this.showArrow = showArrow;
         this.arrowPosition = arrowPosition;
      }
   }
}

