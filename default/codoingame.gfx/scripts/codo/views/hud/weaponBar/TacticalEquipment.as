package codo.views.hud.weaponBar
{
   import codo.style.GlobalGuide;
   import fl.motion.AdjustColor;
   import flash.display.MovieClip;
   import flash.filters.ColorMatrixFilter;
   import flash.text.TextField;
   import fsg.util.FsgImageHolder;
   
   public class TacticalEquipment extends MovieClip
   {
      
      private static var ENABLE_COLOR:uint = 16745472;
      
      public var myBG:MovieClip;
      
      public var myEquipImage2:FsgImageHolder;
      
      public var myEquipImage1:FsgImageHolder;
      
      public var myKey:TextField;
      
      private var mEquipAmmo:int = 0;
      
      private var mColorFilter:ColorMatrixFilter;
      
      public function TacticalEquipment()
      {
         super();
         var colorAdjust:AdjustColor = new AdjustColor();
         colorAdjust.contrast = -80;
         colorAdjust.hue = 0;
         colorAdjust.saturation = 0;
         colorAdjust.brightness = 0;
         this.mColorFilter = new ColorMatrixFilter(colorAdjust.CalculateFinalFlatArray());
      }
      
      public function set image(name:String) : void
      {
         this.myEquipImage1.setImage(name);
         this.myEquipImage2.setImage(name);
         if(name == "")
         {
            this.myBG.gotoAndStop(2);
            this.myEquipImage1.visible = this.myEquipImage2.visible = false;
         }
         else
         {
            this.setAmmo(this.mEquipAmmo);
         }
      }
      
      public function set ammo(ammo:int) : void
      {
         this.setAmmo(ammo);
      }
      
      private function setAmmo(ammo:int) : void
      {
         this.mEquipAmmo = ammo;
         if(this.mEquipAmmo == 0)
         {
            this.myBG.gotoAndStop(2);
            this.myEquipImage1.visible = true;
            this.myEquipImage2.visible = false;
            this.myEquipImage1.filters = [this.mColorFilter];
            this.myKey.textColor = GlobalGuide.CODO_GRAY_LIGHT;
         }
         else if(this.mEquipAmmo == 1)
         {
            this.myBG.gotoAndStop(1);
            this.myEquipImage1.visible = true;
            this.myEquipImage2.visible = false;
            this.myEquipImage1.filters = [];
            this.myKey.textColor = ENABLE_COLOR;
         }
         else if(this.mEquipAmmo == 2)
         {
            this.myBG.gotoAndStop(1);
            this.myEquipImage1.visible = true;
            this.myEquipImage2.visible = true;
            this.myEquipImage1.filters = [];
            this.myKey.textColor = ENABLE_COLOR;
         }
      }
   }
}

