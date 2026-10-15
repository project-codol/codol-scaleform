package codo.objects
{
   public class SupplyDropFilterObj extends FilterObj
   {
      
      public var category:int;
      
      public function SupplyDropFilterObj(inID:uint = 0, inLabel:String = "unlocalized!", inChild:Array = null, category:int = 0)
      {
         super(inID,inLabel,inChild);
         this.category = category;
      }
   }
}

