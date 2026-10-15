package components.fsgcareermode_part
{
   import codo.objects.ChallengeBaseObj;
   import flash.display.Sprite;
   import fsg.shared.widgets.FsgTabChallengePanelItem;
   
   public class FsgCareerTabChallengePanelItem extends FsgTabChallengePanelItem
   {
      
      public var mySep:Sprite;
      
      public function FsgCareerTabChallengePanelItem()
      {
         super();
         myChallengeComplete.setWidth(this.width);
         myChallengeComplete.setHeight(this.height);
         mouseEnabled = mouseChildren = buttonMode = false;
      }
      
      override public function setData(challengeData:ChallengeBaseObj, index:int = 0) : void
      {
         setProgressBarOffsets(-1,2,2);
         super.setData(challengeData);
         clearListeners();
         myProgressTF.alpha = 1;
         this.mySep.visible = index != NUM_CHALLENGES - 1;
      }
   }
}

