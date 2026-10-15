package codo.objects
{
   import codo.constants.PartyType;
   
   public dynamic class PartyObj extends CustomObject
   {
      
      public var id:String = "";
      
      public var size:int = 0;
      
      public var type:int = PartyType.PUBLIC;
      
      public var description:String = "";
      
      public var hostId:String = "";
      
      public var idxSize:int = 0;
      
      public var idxType:int = 0;
      
      public var members:Array = [];
      
      public var partyDLCLevel:uint = 0;
      
      public function PartyObj(cObj:Object = null)
      {
         super(cObj);
      }
   }
}

