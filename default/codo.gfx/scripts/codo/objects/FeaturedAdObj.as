package codo.objects
{
   public class FeaturedAdObj
   {
      
      public var itemLinkage:String;
      
      public var itemData:*;
      
      public var webSlot:uint = 0;
      
      public function FeaturedAdObj(linkage:String, data:*)
      {
         super();
         this.itemLinkage = linkage;
         this.itemData = data;
      }
   }
}

