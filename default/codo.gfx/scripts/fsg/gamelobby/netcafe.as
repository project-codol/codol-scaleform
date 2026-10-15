package fsg.gamelobby
{
   import fsg.shared.ToolTipItem;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol302")]
   public dynamic class netcafe extends ToolTipItem
   {
      
      public function netcafe()
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

