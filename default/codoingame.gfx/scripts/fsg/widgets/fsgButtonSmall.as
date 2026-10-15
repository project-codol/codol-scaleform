package fsg.widgets
{
   import components.fsgpersistent_part.FsgDropdownMenuItem;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2460")]
   public dynamic class fsgButtonSmall extends FsgDropdownMenuItem
   {
      
      public function fsgButtonSmall()
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

