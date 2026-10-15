package codo.views.hudSpy
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class PlayerNickname extends MovieClip
   {
      
      public var myValue:TextField;
      
      public var myBG:MovieClip;
      
      public function PlayerNickname()
      {
         super();
      }
      
      public function get nickname() : String
      {
         return this.myValue.text;
      }
      
      public function set nickname(name:String) : void
      {
         this.myValue.text = name;
      }
   }
}

