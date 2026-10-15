package codo.views.hudPropHunt
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   public class PropHuntAlive extends MovieClip
   {
      
      public var myNum:TextField;
      
      public var myHeader:TextField;
      
      public var myBkgAlles:Sprite;
      
      public var myBkgEnemies:Sprite;
      
      public function PropHuntAlive()
      {
         super();
         this.myHeader.text = "@PH_ALIVE";
      }
   }
}

