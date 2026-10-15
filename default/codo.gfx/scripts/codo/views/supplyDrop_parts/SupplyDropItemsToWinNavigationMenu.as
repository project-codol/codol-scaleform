package codo.views.supplyDrop_parts
{
   import codo.component.navigation.NavigationMenu;
   import codo.component.object.NavigationObj;
   
   public class SupplyDropItemsToWinNavigationMenu extends NavigationMenu
   {
      
      public function SupplyDropItemsToWinNavigationMenu()
      {
         super();
      }
      
      override public function setData(menuData:Vector.<NavigationObj>) : void
      {
         super.setData(menuData);
         myMenuBkg.width = menuItemHolder.width + 40;
         myMask.width = myMenuBkg.width + MASK_PADDING;
      }
   }
}

