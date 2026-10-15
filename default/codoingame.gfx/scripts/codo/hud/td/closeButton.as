package codo.hud.td
{
   import codo.component.CloseButton;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol3218")]
   public dynamic class closeButton extends CloseButton
   {
      
      public function closeButton()
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

