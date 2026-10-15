package codo.component.lobby
{
   import codo.component.Button;
   
   public class LobbyMainButton extends Button
   {
      
      private static const ENABLE_ALPHA:Number = 1;
      
      private static const DISABLE_ALPHA:Number = 0.5;
      
      public function LobbyMainButton()
      {
         super();
      }
      
      override public function set enabled(enabled:Boolean) : void
      {
         super.enabled = enabled;
         alpha = enabled ? ENABLE_ALPHA : DISABLE_ALPHA;
      }
   }
}

