package codo.views.chat_parts
{
   import codo.component.Button;
   import codo.component.TextField;
   import codo.style.ChatGuide;
   import flash.display.MovieClip;
   
   public class LoudSpeakerBtn extends Button
   {
      
      public var myText:TextField;
      
      public var myIcon:MovieClip;
      
      public function LoudSpeakerBtn()
      {
         super();
         this.myText.textStyle = ChatGuide.styleLoudSpeakerRemainNum;
         this.myText.width = 36;
         this.myText.x = 57;
         this.myText.y = 41;
      }
      
      public function set tokenCount(remainTxt:String) : void
      {
         this.myText.text = remainTxt;
      }
      
      public function setLoudSpeakerFrame(frame:int) : void
      {
         this.myIcon.gotoAndStop(frame);
      }
      
      override protected function onMouseOver() : void
      {
         super.onMouseOver();
         gotoAndStop(2);
      }
      
      override protected function onMouseOut() : void
      {
         super.onMouseOut();
         gotoAndStop(1);
      }
      
      override public function set enabled(value:Boolean) : void
      {
         super.enabled = value;
         this.alpha = value ? 1 : 0.5;
      }
   }
}

