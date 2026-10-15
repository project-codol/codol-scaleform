package codo.objects
{
   public dynamic class BadgeObj extends CustomObject
   {
      
      public var id:uint = 0;
      
      public var name:String = "";
      
      public var description:String = "";
      
      public var imageURL:String = "";
      
      public function BadgeObj(cObj:Object = null)
      {
         super(cObj);
      }
   }
}

