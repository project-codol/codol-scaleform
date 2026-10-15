package codo.shared
{
   import codo.component.CloseButton;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2207")]
   public dynamic class PopupCloseButton extends CloseButton
   {
      
      public function PopupCloseButton()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}

