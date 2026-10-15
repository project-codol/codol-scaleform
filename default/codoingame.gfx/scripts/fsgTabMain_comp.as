package
{
   import fsg.shared.TabMain;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol240")]
   public dynamic class fsgTabMain_comp extends TabMain
   {
      
      public function fsgTabMain_comp()
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

