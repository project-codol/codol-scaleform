package codo.objects
{
   public class MessageRewardData
   {
      
      public var currencyType:int;
      
      public var currencyAmount:int;
      
      public var item:Object;
      
      public function MessageRewardData(ctype:int, cAmount:int, item:Object)
      {
         super();
         this.currencyType = ctype;
         this.currencyAmount = cAmount;
         this.item = item;
      }
   }
}

