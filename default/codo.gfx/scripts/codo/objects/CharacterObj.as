package codo.objects
{
   public dynamic class CharacterObj extends CustomObject
   {
      
      public var id:int;
      
      public var nameid:String;
      
      public var name:String;
      
      public var description:String;
      
      public var category:String;
      
      public var imageURL:String;
      
      public var type:String;
      
      public var isDefault:Boolean;
      
      public var loadoutIdx:int;
      
      public var isActive:Boolean;
      
      public var showBreadcrumb:Boolean;
      
      public function CharacterObj(cObj:Object = null)
      {
         super(cObj);
      }
   }
}

