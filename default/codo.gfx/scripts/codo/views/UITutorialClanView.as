package codo.views
{
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.constants.UITutorialFlags;
   import codo.event.ParaEvent;
   import codo.views.uitour.UITourClanListViewed;
   
   public class UITutorialClanView extends UITutorialBaseView
   {
      
      public var myTutorialClanList:UITourClanListViewed;
      
      public function UITutorialClanView()
      {
         super();
      }
      
      override protected function showView() : void
      {
         super.showView();
         listen(BCEvent.EVT_ON_CLAN_JOINED,this.onClanStatusChanged);
         switch(flagID)
         {
            case UITutorialFlags.UI_TOUR_CLANS:
               this.myTutorialClanList.show();
               this.myTutorialClanList.registerCallToActionEvent(this.completeTour);
         }
      }
      
      private function completeTour() : void
      {
         hideAllTours();
         hideView();
      }
      
      private function onClanStatusChanged(cEvt:ParaEvent) : void
      {
         var isInClan:Boolean = getDP(DataID.IS_IN_CLAN);
         if(isInClan)
         {
            this.completeTour();
            unlisten(BCEvent.EVT_ON_CLAN_JOINED,this.onClanStatusChanged);
         }
      }
   }
}

