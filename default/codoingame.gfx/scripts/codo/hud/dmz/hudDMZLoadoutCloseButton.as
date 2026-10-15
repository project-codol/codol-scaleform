package codo.hud.dmz
{
   import codo.component.CloseButton;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1441")]
   public dynamic class hudDMZLoadoutCloseButton extends CloseButton
   {
      
      public function hudDMZLoadoutCloseButton()
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

