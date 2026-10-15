package codo.views.hud.speakerContainer
{
   import codo.constants.HUDComponentTypes;
   import codo.views.hud.HUDComponent;
   
   public class SpeakerContainer extends HUDComponent
   {
      
      public function SpeakerContainer()
      {
         super();
         scaleX = scaleY = 0.67;
      }
      
      override public function get CompType() : int
      {
         return HUDComponentTypes.SPEAKER_CONTAINER;
      }
   }
}

