package codo.component.social
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class UnsolvedNoteDot extends MovieClip
   {
      
      public var myText:TextField;
      
      public function UnsolvedNoteDot()
      {
         super();
      }
      
      public function setCount(count:int) : void
      {
         this.myText.text = String(count);
      }
   }
}

