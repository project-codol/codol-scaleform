package codo.objects
{
   public class ItemBanObj
   {
      
      public var id:int;
      
      public var type:String;
      
      public var name:String;
      
      public var description:String;
      
      public var legendDesc:String;
      
      public var imageURL:String;
      
      public var banned:Boolean;
      
      public var toggleBannedCallback:Function;
      
      public function ItemBanObj()
      {
         super();
      }
   }
}

