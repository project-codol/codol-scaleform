package codo.shared
{
   import components.fsgpersistent_part.FsgWebReloadButton;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2021")]
   public dynamic class EsportsWebImgRefreshButton extends FsgWebReloadButton
   {
      
      public function EsportsWebImgRefreshButton()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame2() : *
      {
         stop();
      }
   }
}

