package codo.objects
{
   public dynamic class AccountObj extends CustomObject
   {
      
      public var codPoint:int = 0;
      
      public var moneyPoint:int = 0;
      
      public var clanContributionPoint:int = 0;
      
      public var heroPoint:int;
      
      public var epicHeroPoint:int;
      
      public var dmzlFreeTicket:int;
      
      public var dmzlBattleTicket:int;
      
      public function AccountObj(cObj:Object = null)
      {
         super(cObj);
      }
   }
}

