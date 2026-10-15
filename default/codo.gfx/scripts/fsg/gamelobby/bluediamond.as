package fsg.gamelobby
{
   import fsg.shared.ToolTipItem;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol310")]
   public dynamic class bluediamond extends ToolTipItem
   {
      
      public function bluediamond()
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

