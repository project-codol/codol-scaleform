package codo.objects
{
   import codo.localization.DictMarket;
   import codo.utils.LocalizeUtil;
   
   public class MOTDCheckinRewardObj
   {
      
      public var itemID:int;
      
      public var quantity:int;
      
      public var requirement:int;
      
      public var isEarned:Boolean;
      
      public var duration:int;
      
      public var gp:int;
      
      public var featured:Boolean = false;
      
      public function MOTDCheckinRewardObj()
      {
         super();
      }
      
      public function getDurationText(prod:ProductObj) : String
      {
         if(this.duration > 0)
         {
            return LocalizeUtil.replaceConversionString(LocalizeUtil.localize("@SF_UI_DAY_RENTAL"),[this.duration]);
         }
         if(prod.stackable)
         {
            return LocalizeUtil.param(DictMarket.MARKET_QUANTITY,[this.quantity]);
         }
         return DictMarket.MARKET_OWNED_ITEM_PERMANENT;
      }
   }
}

