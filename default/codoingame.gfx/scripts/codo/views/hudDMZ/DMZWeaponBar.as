package codo.views.hudDMZ
{
   import codo.utils.LocalizeUtil;
   import codo.utils.TextUtil;
   import codo.views.hudSpy.WeaponInfoEquipment;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import fsg.util.FsgImageHolder;
   
   public class DMZWeaponBar extends MovieClip
   {
      
      public var myPistolAmmo:AmmoCounter;
      
      public var myAssaultAmmo:AmmoCounter;
      
      public var myShotAmmo:AmmoCounter;
      
      public var mySniperAmmo:AmmoCounter;
      
      public var myImage:FsgImageHolder;
      
      public var myWeaponName:TextField;
      
      public var myWeaponType:TextField;
      
      public var myLethEquip:WeaponInfoEquipment;
      
      public var myTacticalEquip:WeaponInfoEquipment;
      
      public function DMZWeaponBar()
      {
         super();
         this.init();
      }
      
      public function init() : void
      {
         this.myAssaultAmmo.myAmmoIcon.gotoAndStop(2);
         this.myShotAmmo.myAmmoIcon.gotoAndStop(3);
         this.mySniperAmmo.myAmmoIcon.gotoAndStop(4);
         this.mySniperAmmo.myBG.gotoAndStop(2);
         this.myLethEquip.myKey.text = LocalizeUtil.localizeFirstKeyBindingForCommand("+frag");
         this.myTacticalEquip.myKey.text = LocalizeUtil.localizeFirstKeyBindingForCommand("+tact");
      }
      
      public function set image(image:String) : void
      {
         this.myImage.setImage(image);
      }
      
      public function setWeaponName(name:String) : void
      {
         this.myWeaponName.text = name;
         TextUtil.resizeTextToFitWidth(this.myWeaponName);
      }
   }
}

