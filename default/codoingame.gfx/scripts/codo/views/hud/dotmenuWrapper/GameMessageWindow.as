package codo.views.hud.dotmenuWrapper
{
   import codo.constants.HUDComponentTypes;
   
   public class GameMessageWindow extends HUDDotMenuComponent
   {
      
      public function GameMessageWindow()
      {
         super();
      }
      
      override public function get CompType() : int
      {
         return HUDComponentTypes.GAME_MESSAGEWINDOW;
      }
   }
}

