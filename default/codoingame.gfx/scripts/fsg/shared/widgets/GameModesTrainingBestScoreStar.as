package fsg.shared.widgets
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class GameModesTrainingBestScoreStar extends Sprite
   {
      
      public var myStarGold:MovieClip;
      
      public var myStarEmpty:MovieClip;
      
      public function GameModesTrainingBestScoreStar()
      {
         super();
         this.reset();
      }
      
      public function setComplete(delay:uint) : void
      {
         this.myStarEmpty.alpha = 0;
         this.myStarGold.alpha = 1;
         this.myStarGold.visible = true;
         this.myStarEmpty.visible = false;
      }
      
      public function reset() : void
      {
         this.myStarEmpty.visible = true;
         this.myStarEmpty.alpha = 1;
         this.myStarGold.visible = false;
         this.myStarGold.alpha = 0;
      }
      
      private function onStarAnimComplete() : void
      {
         this.myStarEmpty.visible = false;
      }
   }
}

