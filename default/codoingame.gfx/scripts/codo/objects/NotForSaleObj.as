package codo.objects
{
   public class NotForSaleObj
   {
      
      public static const NOT_FOR_SALE_TYPE_EVT:int = 0;
      
      public static const NOT_FOR_SALE_TYPE_PVE:int = 1;
      
      public static const NOT_FOR_SALE_TYPE_PVP:int = 2;
      
      public static const NOT_FOR_SALE_TYPE_OTH:int = 3;
      
      public static const NOT_FOR_SALE_TYPE_EXT:int = 4;
      
      public var type:int;
      
      public var label:String;
      
      public var url:String;
      
      public var message:String;
      
      public var playlist:int;
      
      public function NotForSaleObj()
      {
         super();
      }
   }
}

