package codo.shared
{
   import codo.component.InfoButton;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2457")]
   public dynamic class infoButton extends InfoButton
   {
      
      public function infoButton()
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

