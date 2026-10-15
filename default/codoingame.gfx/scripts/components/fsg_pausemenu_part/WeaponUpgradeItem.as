package components.fsg_pausemenu_part
{
   import codo.utils.AsymPvpUtil;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import fsg.util.FsgImageHolder;
   
   public class WeaponUpgradeItem extends MovieClip
   {
      
      public var myUpgradeImg:FsgImageHolder;
      
      public var myUpgradeTitle:TextField;
      
      public var myUpgradeDesc:TextField;
      
      public function WeaponUpgradeItem()
      {
         super();
      }
      
      public function setData(weaponType:int) : void
      {
         this.myUpgradeImg.setImage(AsymPvpUtil.instance.getWeaponUpgradeModImage(weaponType));
         this.myUpgradeTitle.text = AsymPvpUtil.instance.getWeaponUpgradeModName(weaponType);
         this.myUpgradeDesc.text = AsymPvpUtil.instance.getWeaponUpgradeModDesc(weaponType);
      }
   }
}

