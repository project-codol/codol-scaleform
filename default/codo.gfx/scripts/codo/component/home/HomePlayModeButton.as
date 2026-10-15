package codo.component.home
{
   import codo.component.TextField;
   import codo.component.core.UIInteractiveComponent;
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   import flash.display.MovieClip;
   
   public class HomePlayModeButton extends UIInteractiveComponent
   {
      
      public var myFocusImage:MovieClip;
      
      public var myLabel:TextField;
      
      public function HomePlayModeButton()
      {
         super();
         isInteractiveEnabled = true;
         this.myLabel.font = GlobalGuide.FONT_FACE_BOLD;
         this.myLabel.fontSize = 22;
         this.myLabel.width = myHitArea.width;
         this.myLabel.height = 54;
         this.myLabel.alignment = TextStyle.HALIGN_CENTER;
         this.myFocusImage.alpha = 0;
      }
      
      public function set label(l:String) : void
      {
         this.myLabel.text = l;
      }
      
      override protected function onMouseOver() : void
      {
         super.onMouseOver();
         this.myFocusImage.alpha = 1;
      }
      
      override protected function onMouseOut() : void
      {
         super.onMouseOut();
         this.myFocusImage.alpha = 0;
      }
   }
}

