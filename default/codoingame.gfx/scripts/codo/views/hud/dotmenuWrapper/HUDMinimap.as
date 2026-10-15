package codo.views.hud.dotmenuWrapper
{
   import codo.constants.HUDComponentTypes;
   
   public class HUDMinimap extends HUDDotMenuComponent
   {
      
      public var showCompass:Boolean;
      
      public function HUDMinimap()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.showCompass = true;
      }
      
      override public function get CompType() : int
      {
         return HUDComponentTypes.MINIMAP;
      }
   }
}

