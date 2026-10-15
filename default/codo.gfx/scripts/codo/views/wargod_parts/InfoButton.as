package codo.views.wargod_parts
{
   import codo.component.Button;
   import codo.style.ChatGuide;
   import codo.style.GlobalGuide;
   import flash.display.MovieClip;
   
   public class InfoButton extends Button
   {
      
      public var myIcon:MovieClip;
      
      public function InfoButton()
      {
         super();
      }
      
      override protected function showHighlight() : void
      {
         super.showHighlight();
         ChatGuide.tint(true,this.myIcon,GlobalGuide.WHITE);
      }
      
      override protected function endHighlight() : void
      {
         super.endHighlight();
         ChatGuide.tint(false,this.myIcon);
      }
   }
}

