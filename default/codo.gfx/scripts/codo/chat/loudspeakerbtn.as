package codo.chat
{
   import codo.views.chat_parts.LoudSpeakerBtn;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol5256")]
   public dynamic class loudspeakerbtn extends LoudSpeakerBtn
   {
      
      public function loudspeakerbtn()
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

