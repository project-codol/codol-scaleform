package codo.views.fsgHudTop3PlayerView_parts
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class FsgHudTop3PlayersViewRankIcon extends MovieClip
   {
      
      public var myRank:TextField;
      
      public function FsgHudTop3PlayersViewRankIcon()
      {
         super();
      }
      
      public function set rank(rank:int) : void
      {
         var frame:int = rank < 4 ? rank : 4;
         gotoAndStop(frame);
         this.myRank.text = rank.toString();
      }
   }
}

