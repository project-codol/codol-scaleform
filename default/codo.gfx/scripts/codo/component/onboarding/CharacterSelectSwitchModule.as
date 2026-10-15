package codo.component.onboarding
{
   import codo.component.CharacterSwitchModule;
   
   public class CharacterSelectSwitchModule extends CharacterSwitchModule
   {
      
      public function CharacterSelectSwitchModule()
      {
         super();
         myDetails.height = 30;
      }
      
      override public function refreshDisplay() : void
      {
         super.refreshDisplay();
         myDetails.y = 88;
         if(myDetails.textHeight > 12)
         {
            myDetails.y = 95;
         }
      }
      
      override protected function setupPreviewAndFactionAssets() : void
      {
      }
      
      override protected function initBinds() : void
      {
      }
      
      override public function refreshFaction() : void
      {
      }
   }
}

