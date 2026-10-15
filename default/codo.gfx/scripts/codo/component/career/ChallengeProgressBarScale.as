package codo.component.career
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class ChallengeProgressBarScale extends MovieClip
   {
      
      public var myValue:TextField;
      
      public function ChallengeProgressBarScale()
      {
         super();
      }
      
      public function set text(txt:String) : void
      {
         this.myValue.text = txt;
      }
      
      public function get text() : String
      {
         return this.myValue.text;
      }
   }
}

