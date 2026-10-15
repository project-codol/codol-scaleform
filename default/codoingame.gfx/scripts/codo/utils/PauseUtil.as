package codo.utils
{
   import codo.common.CFunctionCommonContainer;
   
   public class PauseUtil
   {
      
      private static var _mapDisabled:Boolean;
      
      private static const HIDE_PAUSE_MAP_DVAR:String = "ui_hide_pausemenu_minimap";
      
      private static const HIDE_LOADOUT_DVAR:String = "ui_hide_pausemenu_class";
      
      public function PauseUtil()
      {
         super();
      }
      
      public static function getLoadoutHidden() : Boolean
      {
         return CFunctionCommonContainer.Dvar_GetBool(HIDE_LOADOUT_DVAR) as Boolean;
      }
      
      public static function hideLoadout(hide:Boolean) : void
      {
         CFunctionCommonContainer.setdvar(HIDE_LOADOUT_DVAR,hide ? "1" : "0");
      }
      
      public static function getPauseMapHidden() : Boolean
      {
         return CFunctionCommonContainer.Dvar_GetBool(HIDE_PAUSE_MAP_DVAR) as Boolean;
      }
      
      public static function hidePauseMap(hide:Boolean) : void
      {
         if(_mapDisabled)
         {
            return;
         }
         CFunctionCommonContainer.setdvar(HIDE_PAUSE_MAP_DVAR,hide ? "1" : "0");
      }
      
      public static function disableMap() : void
      {
         hidePauseMap(true);
         _mapDisabled = true;
      }
   }
}

