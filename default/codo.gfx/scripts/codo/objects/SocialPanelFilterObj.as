package codo.objects
{
   public class SocialPanelFilterObj
   {
      
      public var order:int;
      
      public var label:String;
      
      public var data:*;
      
      public var sort:*;
      
      public function SocialPanelFilterObj(order:int, label:String, sort:* = null, data:* = null)
      {
         super();
         this.order = order;
         this.label = label;
         this.sort = sort;
         this.data = data;
      }
   }
}

