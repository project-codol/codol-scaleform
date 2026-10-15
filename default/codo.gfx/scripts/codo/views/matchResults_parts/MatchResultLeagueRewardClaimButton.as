package codo.views.matchResults_parts
{
   import codo.component.core.UIInteractiveComponent;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class MatchResultLeagueRewardClaimButton extends UIInteractiveComponent
   {
      
      public var myGlow:MovieClip;
      
      public var myTF:TextField;
      
      public var myTFBG:MovieClip;
      
      public function MatchResultLeagueRewardClaimButton()
      {
         super();
         isInteractiveEnabled = true;
      }
      
      public function toggleReward(hasReward:Boolean) : void
      {
         this.myGlow.visible = hasReward;
         this.myTF.visible = hasReward;
         this.myTFBG.visible = hasReward;
      }
   }
}

