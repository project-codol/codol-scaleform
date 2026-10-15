package codo.views.hud.popups.HudTdTurretManageView_parts
{
   import codo.localization.DictTD;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class HudTdTurretManagePanel extends MovieClip
   {
      
      public var myTitle:TextField;
      
      public function HudTdTurretManagePanel()
      {
         super();
         this.myTitle.text = DictTD.TURRET_MANAGE_TITLE;
      }
   }
}

