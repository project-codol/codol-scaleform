package codo.objects
{
   public dynamic class ClanMemberObj extends UserObj
   {
      
      public var myClanPos:uint = 0;
      
      public var dlcLevel:uint = 0;
      
      public var ccpCurrent:uint;
      
      public var ccpDaily:uint = 0;
      
      public var ccpWeekly:uint = 0;
      
      public var ccpForever:uint = 0;
      
      public var selectedCCPValue:uint;
      
      public function ClanMemberObj(cObj:Object = null)
      {
         super(cObj);
      }
   }
}

