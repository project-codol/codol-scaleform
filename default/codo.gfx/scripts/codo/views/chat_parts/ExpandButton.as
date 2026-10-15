package codo.views.chat_parts
{
   import codo.component.Button;
   import codo.style.ChatGuide;
   import codo.style.GlobalGuide;
   import flash.display.MovieClip;
   
   public class ExpandButton extends Button
   {
      
      private static const EXPAND_FRAME:int = 1;
      
      private static const RETRACT_FRAME:int = 6;
      
      public var myIcon:MovieClip;
      
      public function ExpandButton()
      {
         super();
         this.myIcon.gotoAndStop(1);
      }
      
      public function set expand(value:Boolean) : void
      {
         this.myIcon.gotoAndPlay(value ? EXPAND_FRAME : RETRACT_FRAME);
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

