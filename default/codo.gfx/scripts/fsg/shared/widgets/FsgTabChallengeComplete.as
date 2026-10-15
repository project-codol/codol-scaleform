package fsg.shared.widgets
{
   import flash.display.Sprite;
   
   public class FsgTabChallengeComplete extends Sprite
   {
      
      public var myCompleteIcon:Sprite;
      
      public var myBkg:Sprite;
      
      public function FsgTabChallengeComplete()
      {
         super();
      }
      
      public function setWidth(widthVal:uint) : void
      {
         this.myBkg.width = widthVal;
         this.myCompleteIcon.x = widthVal * 0.5 - this.myCompleteIcon.width * 0.5;
      }
      
      public function setHeight(heightVal:uint) : void
      {
         this.myBkg.height = heightVal;
         this.myCompleteIcon.y = heightVal * 0.5 - this.myCompleteIcon.height * 0.5;
      }
   }
}

