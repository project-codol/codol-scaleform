package codo.views.wargod_parts
{
   import codo.component.core.ItemCardBase;
   import codo.constants.MarketMenuData;
   import codo.localization.Dict;
   import codo.localization.DictMarket;
   import codo.objects.ProductObj;
   import codo.objects.WarGodRewardObj;
   import codo.utils.ItemUtil;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   import flash.text.TextFieldAutoSize;
   
   public class WarGodRewardCard extends ItemCardBase
   {
      
      public var myTier:MovieClip;
      
      public function WarGodRewardCard()
      {
         super();
         myItemNameTF.autoSize = TextFieldAutoSize.LEFT;
      }
      
      override public function get height() : Number
      {
         return myHitArea.height;
      }
      
      override protected function checkUseIconHolderForImage() : Boolean
      {
         return false;
      }
      
      public function setWarGodReward(rewardObj:WarGodRewardObj) : void
      {
         var prod:ProductObj = ItemUtil.getProductObjByProductId(rewardObj.prodID);
         super.setData(prod);
         var type:int = rewardObj.type;
         var parameter:int = rewardObj.parameter;
         if(type == WarGodRewardObj.TYPE_RENTAL)
         {
            if(parameter == 0)
            {
               myItemCategoryTF.text = LocalizeUtil.localize(Dict.FOREVER);
            }
            else
            {
               myItemCategoryTF.text = parameter + " " + LocalizeUtil.localize(Dict.DAY);
            }
         }
         else if(type == WarGodRewardObj.TYPE_STACKABLE)
         {
            myItemCategoryTF.text = LocalizeUtil.param(DictMarket.MARKET_QUANTITY,[parameter]);
         }
         myItemCategoryTF.visible = true;
         if(Boolean(this.myTier))
         {
            this.myTier.visible = prod.type != MarketMenuData.TYPE_CALLSIGN_TITLE;
            this.myTier.width = myItemNameTF.textWidth + 15;
         }
      }
   }
}

