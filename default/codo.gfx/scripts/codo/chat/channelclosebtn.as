package codo.chat
{
   import codo.component.Button;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol3479")]
   public dynamic class channelclosebtn extends Button
   {
      
      public function channelclosebtn()
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

