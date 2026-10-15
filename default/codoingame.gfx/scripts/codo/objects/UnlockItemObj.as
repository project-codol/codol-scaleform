package codo.objects
{
   public dynamic class UnlockItemObj extends CustomObject
   {
      
      public var id:String = "";
      
      public var name:String = "";
      
      public var description:String = "";
      
      public var imageURL:String = "";
      
      public var quantity:int = 0;
      
      public var category:uint = 0;
      
      public function UnlockItemObj(cObj:Object = null)
      {
         super(cObj);
      }
   }
}

