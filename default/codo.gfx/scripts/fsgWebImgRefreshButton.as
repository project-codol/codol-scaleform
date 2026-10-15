package
{
   import components.fsgpersistent_part.FsgWebReloadButton;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol4222")]
   public dynamic class fsgWebImgRefreshButton extends FsgWebReloadButton
   {
      
      public function fsgWebImgRefreshButton()
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

