package codo.views
{
   import codo.constants.BCEvent;
   import codo.constants.PageID;
   import codo.constants.UITutorialFlags;
   import codo.utils.ItemUtil;
   import codo.utils.ScaleformUtil;
   import codo.views.uitour.UITourLandingClanIntro;
   import codo.views.uitour.UITourLandingNewUser;
   import codo.views.uitour.UITourLandingPick10Intro;
   
   public class UITutorialLandingView extends UITutorialBaseView
   {
      
      public var myNewUserTour:UITourLandingNewUser;
      
      public var myNewUserTour_cn:UITourLandingNewUser;
      
      public var myPick10Tour:UITourLandingPick10Intro;
      
      public var myClanTour:UITourLandingClanIntro;
      
      public function UITutorialLandingView()
      {
         super();
      }
      
      override protected function showView() : void
      {
         super.showView();
         var isBuildEnglish:Boolean = !ItemUtil.isChineseLanguage;
         if(!ScaleformUtil.isScaleform)
         {
            this.myPick10Tour.show();
         }
         switch(flagID)
         {
            case UITutorialFlags.UI_TOUR_LANDING_PICK10_INTRO_VIEWED:
               this.myPick10Tour.registerCallToActionEvent(this.onPick10ContinueClicked);
               this.myPick10Tour.show();
         }
      }
      
      private function onPick10ContinueClicked() : void
      {
         broadcast(BCEvent.EVT_ROUTE_TO_PAGE,{"page":PageID.FSG_LOADOUT});
      }
   }
}

