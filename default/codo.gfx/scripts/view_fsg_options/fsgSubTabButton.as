package view_fsg_options
{
   import fsg.shared.SubTab;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol6139")]
   public dynamic class fsgSubTabButton extends SubTab
   {
      
      public function fsgSubTabButton()
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

