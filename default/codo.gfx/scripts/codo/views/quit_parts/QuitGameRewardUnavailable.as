package codo.views.quit_parts
{
   import codo.base.BaseSubElement;
   import flash.text.TextField;
   
   public class QuitGameRewardUnavailable extends BaseSubElement
   {
      
      public var myComingSoonTF:TextField;
      
      public var myNewRewardsLabelTF:TextField;
      
      public function QuitGameRewardUnavailable()
      {
         super();
         deactive();
         this.myComingSoonTF.text = isDebugMode ? "COMING SOON" : "@SF_UI_COMING_SOON";
         this.myNewRewardsLabelTF.text = isDebugMode ? "NEW REWARDS" : "@SF_UI_QUIT_GAME_NEW_REWARDS";
      }
   }
}

