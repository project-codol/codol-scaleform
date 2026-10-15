package codo.objects
{
   import codo.constants.RightClickMenuType;
   
   public class PlayerNameSettings
   {
      
      public static const MODE_DIRECT:int = 0;
      
      public static const MODE_INDIRECT:int = 1;
      
      public static const FIT_SIZE_METHOD_TRUNCATE:int = 0;
      
      public static const FIT_SIZE_METHOD_EXTEND:int = 1;
      
      public static const FIT_SIZE_METHOD_SMALL_FONT:int = 2;
      
      public var mode:int;
      
      public var fontSize:int;
      
      public var textWidth:int;
      
      public var textHeight:int;
      
      public var textColor:int;
      
      public var fitSizeMethod:int;
      
      public var customHighlight:Boolean = false;
      
      public var rightClickType:String = RightClickMenuType.FULL;
      
      public function PlayerNameSettings()
      {
         super();
      }
   }
}

