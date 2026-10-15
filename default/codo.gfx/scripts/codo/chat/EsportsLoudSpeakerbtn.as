package codo.chat
{
   import codo.views.chat_parts.LoudSpeakerBtn;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol976")]
   public dynamic class EsportsLoudSpeakerbtn extends LoudSpeakerBtn
   {
      
      public function EsportsLoudSpeakerbtn()
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

