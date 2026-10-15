package codo.views.hud.popups.hudTdShare
{
   import codo.common.CFunctionInGameContainer;
   import codo.localization.DictTD;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class HudTdItemDetailBox extends MovieClip
   {
      
      private static const sTierColor:Array = [14868183,8837949,3525116,12147967,16747264];
      
      public var myName:TextField;
      
      public var myCurrentOwn:TextField;
      
      public var myDesc:TextField;
      
      public var myBg:MovieClip;
      
      public function HudTdItemDetailBox()
      {
         super();
         mouseEnabled = false;
         mouseChildren = false;
      }
      
      public function set lootItemIndex(lootItemIndex:int) : void
      {
         var packageCount:int = 0;
         var inventoryCount:int = 0;
         var itemInfo:Object = CFunctionInGameContainer.AS_TD_GetLootItemInfo(lootItemIndex);
         if(itemInfo == null)
         {
            this.myName.text = this.myCurrentOwn.text = this.myDesc.text = "";
         }
         else
         {
            this.myName.text = itemInfo.name;
            this.myName.textColor = sTierColor[itemInfo.tier];
            this.myDesc.text = itemInfo.desc;
            packageCount = CFunctionInGameContainer.AS_TD_GetItemPackageCount(lootItemIndex);
            inventoryCount = CFunctionInGameContainer.AS_TD_GetItemInventoryCount(lootItemIndex);
            this.myCurrentOwn.text = LocalizeUtil.param(DictTD.PACKAGE_AND_INVENTORY_COUNT,[packageCount.toString(),inventoryCount.toString()]);
         }
         this.myBg.height = this.myDesc.y + this.myDesc.textHeight + 20;
      }
   }
}

