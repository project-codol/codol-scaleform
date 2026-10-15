package codo.views.hud.popups.hudTdLoadoutView_parts
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.utils.Dictionary;
   
   public class HudTdLoadoutWeaponSlotAmmoInfo extends MovieClip
   {
      
      private static const AMMO_TYPE_FRAME_INDEX:Dictionary = new Dictionary();
      
      AMMO_TYPE_FRAME_INDEX["pstsmg"] = 1;
      AMMO_TYPE_FRAME_INDEX["sniper"] = 2;
      AMMO_TYPE_FRAME_INDEX["arlmg"] = 3;
      AMMO_TYPE_FRAME_INDEX["shotgun"] = 4;
      
      public var myIcon:MovieClip;
      
      public var myText:TextField;
      
      public function HudTdLoadoutWeaponSlotAmmoInfo()
      {
         super();
         this.myIcon.gotoAndStop(1);
         this.myText.text = "";
      }
      
      public function set type(type:String) : void
      {
         this.myIcon.gotoAndStop(AMMO_TYPE_FRAME_INDEX[type]);
      }
      
      public function set text(text:String) : void
      {
         this.myText.text = text;
      }
   }
}

