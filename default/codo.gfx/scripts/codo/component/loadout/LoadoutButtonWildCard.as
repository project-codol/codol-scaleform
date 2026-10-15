package codo.component.loadout
{
   import flash.display.Sprite;
   
   public class LoadoutButtonWildCard extends LoadoutButton
   {
      
      private static const DEFAULT_WIDTH:Number = 217;
      
      private static const DEFAULT_HEIGHT:Number = 76;
      
      public var myPlus:Sprite;
      
      public function LoadoutButtonWildCard()
      {
         super();
         mWidth = DEFAULT_WIDTH;
         mHeight = DEFAULT_HEIGHT;
         this.draw();
      }
      
      override public function draw() : void
      {
         super.draw();
         this.myPlus.x = mWidth * 0.5 - this.myPlus.width * 0.5;
         this.myPlus.y = mHeight * 0.5 - this.myPlus.height * 0.5;
      }
   }
}

