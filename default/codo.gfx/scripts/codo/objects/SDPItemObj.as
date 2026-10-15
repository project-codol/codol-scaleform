package codo.objects
{
   public class SDPItemObj
   {
      
      public var index:int;
      
      public var id:int;
      
      public var attachments:Array;
      
      public var group:String;
      
      public var subGroup:String;
      
      public var limit:uint;
      
      public var cost:int;
      
      public var nameLoc:String;
      
      public var descLoc:String;
      
      public var icon:String;
      
      public var filter:int;
      
      public var disable:int;
      
      public var favorite:Boolean;
      
      public var canAfford:Boolean = true;
      
      public var numEquipped:uint = 0;
      
      public var disabled:Boolean = false;
      
      public var isInLoadout:Boolean = false;
      
      public function SDPItemObj()
      {
         super();
      }
   }
}

