package codo.views.supplyDrop_parts
{
   import codo.constants.MarketMenuData;
   import flash.display.MovieClip;
   
   public class SupplyDropDust extends MovieClip
   {
      
      private var mDropID:int;
      
      private var mQuantity:int;
      
      public function SupplyDropDust()
      {
         super();
      }
      
      public function set dropID(val:int) : void
      {
         this.mDropID = val;
         switch(this.mDropID)
         {
            case MarketMenuData.SUPPLY_DROP_EVENT:
               gotoAndStop(1);
               break;
            case MarketMenuData.SUPPLY_DROP_ADVANCED:
               gotoAndPlay(1);
               break;
            case MarketMenuData.SUPPLY_DROP_BASIC:
               gotoAndPlay(2);
         }
      }
      
      public function get dropID() : int
      {
         return this.mDropID;
      }
      
      public function set quantity(val:int) : void
      {
         this.mQuantity = val;
      }
      
      public function get quantity() : int
      {
         return this.mQuantity;
      }
   }
}

