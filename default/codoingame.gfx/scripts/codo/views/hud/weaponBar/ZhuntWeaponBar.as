package codo.views.hud.weaponBar
{
   import codo.common.CFunctionCommonContainer;
   import codo.constants.HUDComponentTypes;
   import flash.display.MovieClip;
   import flash.geom.Point;
   
   public class ZhuntWeaponBar extends WeaponBar
   {
      
      public var mySyringe:MovieClip;
      
      public var myConsumable:MovieClip;
      
      public function ZhuntWeaponBar()
      {
         super();
      }
      
      override public function get CompType() : int
      {
         return HUDComponentTypes.ZHUNT_WEAPON_BAR;
      }
      
      public function cppPositionChanged() : void
      {
         var point:Point = localToGlobal(new Point(this.myConsumable.x,this.myConsumable.y));
         CFunctionCommonContainer.setdvar("ui_zhunt_weapon_bar_consumable_icon_x",(point.x + this.myConsumable.width / 2).toString());
         CFunctionCommonContainer.setdvar("ui_zhunt_weapon_bar_consumable_icon_y",(point.y + this.myConsumable.height / 2).toString());
      }
   }
}

