package codo.objects
{
   public class CurrencyObj
   {
      
      public static const CURRENCY_GAMEPOINT:int = 1;
      
      public static const CURRENCY_CASHPOINT:int = 2;
      
      public static const CURRENCY_CLANCONTRIBUTIONPOINT:int = 3;
      
      public static const CURRENCY_CLANTREATUREPOINT:int = 4;
      
      public static const CURRENCY_BSDPOINT:int = 5;
      
      public static const CURRENCY_ASDPOINT:int = 6;
      
      public static const CURRENCY_LSDPOINT:int = 7;
      
      public static const CURRENCY_HEROPOINT:int = 8;
      
      public static const CURRENCY_EPICHEROPOINT:int = 9;
      
      public static const CURRENCY_DMZL_FREE_TICKET:int = 10;
      
      public static const CURRENCY_DMZL_BATTLE_TICKET:int = 11;
      
      public var name:String;
      
      public var description:String;
      
      public var image:String;
      
      public var amount:int;
      
      public function CurrencyObj()
      {
         super();
      }
   }
}

