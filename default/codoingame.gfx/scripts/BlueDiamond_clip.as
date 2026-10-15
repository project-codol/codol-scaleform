package
{
   import fsg.shared.ToolTipItem;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2421")]
   public dynamic class BlueDiamond_clip extends ToolTipItem
   {
      
      public function BlueDiamond_clip()
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

