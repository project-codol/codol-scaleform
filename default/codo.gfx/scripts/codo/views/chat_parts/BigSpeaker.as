package codo.views.chat_parts
{
   import codo.component.TextField;
   import flash.display.MovieClip;
   
   public class BigSpeaker extends MovieClip
   {
      
      private static const SPEAKER_WIDTH:int = 800;
      
      private static const SPEAKER_HEIGHT:int = 47;
      
      private static const SENDER_NAME_WIDTH:int = 100;
      
      private static const MESSAGE_WIDTH:int = 600;
      
      public var myIcon:MovieClip;
      
      public var mySender:TextField;
      
      public var myBigLoudMessage:TextField;
      
      public function BigSpeaker()
      {
         var padding:Number = NaN;
         super();
         padding = (SPEAKER_HEIGHT - this.myIcon.height) * 0.5;
         this.myIcon.x = this.myIcon.y = padding;
         this.mySender.width = SENDER_NAME_WIDTH;
         this.mySender.x = this.myIcon.x + this.myIcon.width + padding;
         this.mySender.y = padding;
         this.myBigLoudMessage.y = padding;
         this.myBigLoudMessage.width = MESSAGE_WIDTH;
      }
   }
}

