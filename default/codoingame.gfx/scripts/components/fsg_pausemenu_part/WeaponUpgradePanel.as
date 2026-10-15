package components.fsg_pausemenu_part
{
   import codo.localization.Dict;
   import codo.utils.LocalizeUtil;
   import codo.utils.PauseUtil;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class WeaponUpgradePanel extends MovieClip
   {
      
      public var myPanelHeader:TextField;
      
      public var myWeaponUpgradeItem1:WeaponUpgradeItem;
      
      public var myWeaponUpgradeItem2:WeaponUpgradeItem;
      
      public function WeaponUpgradePanel()
      {
         super();
      }
      
      public function setData(weaponType1:int, weaponType2:int) : void
      {
         if(PauseUtil.getPauseMapHidden())
         {
            gotoAndStop(1);
         }
         else
         {
            gotoAndStop(2);
         }
         this.myPanelHeader.text = LocalizeUtil.localize(Dict.ASYM_UPGRADES);
         this.myWeaponUpgradeItem1.setData(weaponType1);
         this.myWeaponUpgradeItem2.setData(weaponType2);
      }
   }
}

