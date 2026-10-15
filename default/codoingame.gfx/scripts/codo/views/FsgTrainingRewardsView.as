package codo.views
{
   import codo.services.OnboardService;
   import components.fsgonboardpopups_part.FsgTrainingRewardsViewContent;
   import fsg.shared.popups.PopupBaseView;
   
   public class FsgTrainingRewardsView extends PopupBaseView
   {
      
      public function FsgTrainingRewardsView()
      {
         super();
      }
      
      override protected function showView() : void
      {
         super.showView();
         FsgTrainingRewardsViewContent(myContent).setDataProvider(OnboardService.getInstance().getTrainEOGUnlocks());
      }
      
      override public function set routeData(data:*) : void
      {
         var score:uint = data as uint;
         FsgTrainingRewardsViewContent(myContent).finalScore = score;
      }
   }
}

