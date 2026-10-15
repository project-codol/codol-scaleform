package fsg.options
{
   import components.option_part.FsgKeyBoxButton;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol3606")]
   public dynamic class fsgOptionKeyBoxWithLabel extends FsgKeyBoxButton
   {
      
      public function fsgOptionKeyBoxWithLabel()
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

