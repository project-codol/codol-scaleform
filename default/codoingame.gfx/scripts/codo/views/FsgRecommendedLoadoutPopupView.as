package codo.views
{
   import codo.base.PopupView;
   import codo.component.loadout.RecommendedLoadoutPanel;
   import codo.constants.BCEvent;
   import codo.cpp.UiCppSuggestedLoadoutView;
   import codo.cpp.UiCppView;
   import codo.event.ParaEvent;
   import codo.objects.SuggestedLoadoutTypeObj;
   
   public class FsgRecommendedLoadoutPopupView extends PopupView
   {
      
      private static const POPUP_WIDTH:Number = 1017;
      
      private static const POPUP_HEIGHT:Number = 947;
      
      private static const X_OFFSET:Number = 117;
      
      private static const CLOSE_BUTTON_OFFSET:Number = 17;
      
      public var myRecommendedLoadoutPanel:RecommendedLoadoutPanel;
      
      public function FsgRecommendedLoadoutPopupView()
      {
         super();
         myPopup.width = POPUP_WIDTH;
         myPopup.height = POPUP_HEIGHT;
         myPopup.myHeaderbar.visible = false;
         myPopup.myCloseButton.x += CLOSE_BUTTON_OFFSET;
         myPopup.myCloseButton.y -= CLOSE_BUTTON_OFFSET;
         myPopup.x -= X_OFFSET;
         this.myRecommendedLoadoutPanel.x -= X_OFFSET;
      }
      
      override public function set routeData(data:*) : void
      {
         super.routeData = data;
         var type:SuggestedLoadoutTypeObj = data;
         this.myRecommendedLoadoutPanel.setLoadoutType(type);
      }
      
      override protected function makeUiCpp() : UiCppView
      {
         return new UiCppSuggestedLoadoutView(this);
      }
      
      override protected function showView() : void
      {
         super.showView();
         listen(BCEvent.EVT_CLOSE_RECOMMENTED_LOADOUT_POPUP,this.onClose);
      }
      
      override protected function hideView() : void
      {
         super.hideView();
         unlisten(BCEvent.EVT_CLOSE_RECOMMENTED_LOADOUT_POPUP,this.onClose);
      }
      
      private function onClose(evt:ParaEvent) : void
      {
         closePopupView();
      }
   }
}

