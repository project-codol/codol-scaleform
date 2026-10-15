package codo.views.wargodMatchResult_parts
{
   import codo.objects.PlayerWarGodRank;
   import codo.views.wargod_parts.TierMeter;
   import com.greensock.TimelineLite;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class MatchResultHeroicMeter extends MovieClip
   {
      
      public var myTier:TierMeter;
      
      public var myStarMC:MovieClip;
      
      public var myStarCount:TextField;
      
      private var originX:Number;
      
      private var originY:Number;
      
      private var originW:Number;
      
      private var originH:Number;
      
      public function MatchResultHeroicMeter()
      {
         super();
         this.myTier.setData(PlayerWarGodRank.TIER_HEROIC);
         this.originX = this.myStarCount.x;
         this.originY = this.myStarCount.y;
         this.originW = this.myStarCount.width;
         this.originH = this.myStarCount.height;
      }
      
      public function setPlayerRank(rank:PlayerWarGodRank) : void
      {
         this.myStarCount.text = "X" + String(rank.star);
      }
      
      public function playStarChangeAnimation(finalAccount:int) : TimelineLite
      {
         var tempCount:int = 0;
         var onAniComplete:Function = null;
         onAniComplete = function():void
         {
            myStarCount.text = "X" + String(tempCount);
         };
         tempCount = finalAccount;
         var timeline:TimelineLite = new TimelineLite();
         timeline.append(TweenLite.to(this.myStarCount,0.2,{
            "scaleX":2,
            "scaleY":2,
            "onUpdate":this.centerTF,
            "onComplete":onAniComplete
         }));
         timeline.append(TweenLite.to(this.myStarCount,0.2,{
            "scaleX":1,
            "scaleY":1,
            "onUpdate":this.centerTF
         }));
         return timeline;
      }
      
      private function centerTF() : void
      {
         this.myStarCount.x = this.originX + (this.originW - this.myStarCount.width) / 2;
         this.myStarCount.y = this.originY + (this.originH - this.myStarCount.height) / 2;
      }
   }
}

