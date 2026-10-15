package fsg.shared.popups
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class PopupProgressBar extends Sprite
   {
      
      public var myCurrentRank:PopupProgressRank;
      
      public var myNextRank:PopupProgressRank;
      
      public var myProgressBar:MovieClip;
      
      public var myProgressBarBkg:Sprite;
      
      public function PopupProgressBar()
      {
         super();
      }
      
      public function get barWidth() : uint
      {
         return this.myProgressBar.width;
      }
      
      public function set barWidth(w:uint) : void
      {
         this.myProgressBar.width = this.myProgressBarBkg.width = this.myNextRank.x = w;
      }
      
      public function set currentRank(rank:uint) : void
      {
         this.myCurrentRank.rank = rank;
      }
      
      public function set nextRank(rank:uint) : void
      {
         this.myNextRank.rank = rank;
      }
      
      public function setProgress(percentage:uint) : void
      {
         this.myProgressBar.width = percentage * (this.myProgressBar.width / 100);
      }
   }
}

