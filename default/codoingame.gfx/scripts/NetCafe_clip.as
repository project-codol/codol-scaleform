package
{
   import fsg.shared.ToolTipItem;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol487")]
   public dynamic class NetCafe_clip extends ToolTipItem
   {
      
      public function NetCafe_clip()
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

