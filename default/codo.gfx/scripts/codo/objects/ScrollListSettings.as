package codo.objects
{
   public class ScrollListSettings extends CustomObject
   {
      
      public static const SCROLL_HORIZONTAL:int = 0;
      
      public static const SCROLL_VERTICAL:int = 1;
      
      public var itemPadding:Number = 10;
      
      public var width:Number = 256;
      
      public var height:Number = 256;
      
      public var orientation:int = 0;
      
      public var useNavArrows:Boolean = true;
      
      public var focusChangeCallback:Function;
      
      public var buildGridItemRenderMethod:Function;
      
      public var itemLinkage:String;
      
      public var useMask:Boolean = true;
      
      public var autoSize:Boolean = true;
      
      public var autoSizeItems:Boolean = false;
      
      public var barOffsetX:Number = 20;
      
      public var barOffsetY:Number = 4;
      
      public var hideScrollBar:Boolean = false;
      
      public function ScrollListSettings()
      {
         super();
      }
   }
}

