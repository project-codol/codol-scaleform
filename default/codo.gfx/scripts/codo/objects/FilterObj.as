package codo.objects
{
   public class FilterObj
   {
      
      public var child:Array;
      
      public var label:String;
      
      public var id:uint;
      
      public var aggregate:Boolean;
      
      public var categoryFunc:int;
      
      public var locked:Boolean;
      
      public var lockedForPurchase:Boolean = false;
      
      public var breadcrumb:uint = 52;
      
      public var onboardLock:String;
      
      public var enabled:Boolean = true;
      
      public function FilterObj(inID:uint = 0, inLabel:String = "unlocalized!", inChild:Array = null)
      {
         super();
         this.id = inID;
         this.label = inLabel;
         if(inChild != null)
         {
            this.child = inChild;
         }
         else
         {
            this.child = [];
         }
      }
   }
}

