package codo.component.marketplaceitem
{
   import codo.constants.ItemType;
   import codo.constants.MarketMenuData;
   import codo.localization.Dict;
   import codo.objects.ProductObj;
   import codo.utils.LocalizeUtil;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   public class MarketplaceBonusTag extends Sprite
   {
      
      public var myEarnLabelTF:TextField;
      
      public var myEarnValueTF:TextField;
      
      public function MarketplaceBonusTag()
      {
         super();
      }
      
      public function setBonusInfo(data:ProductObj) : void
      {
         var name:String = null;
         var value:String = null;
         if(data.specialPara == null || data.specialPara.length == 0)
         {
            visible = false;
            return;
         }
         name = data.specialPara[0].name.toUpperCase();
         value = data.specialPara[0].value;
         if(value == "0")
         {
            visible = false;
            return;
         }
         visible = true;
         if(data.type == ItemType.CAT || data.group == MarketMenuData.GRP_OUTFIT)
         {
            this.myEarnLabelTF.text = name;
         }
         else
         {
            this.myEarnLabelTF.text = LocalizeUtil.param(Dict.SPECIAL_TAG_WEAPON_XP,[name]);
         }
         this.myEarnValueTF.text = "+" + value;
      }
   }
}

