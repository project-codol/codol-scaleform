package codo.views
{
   import codo.constants.BCEvent;
   import components.fsgonboardpopups_part.FsgEnterGamerTagViewContent;
   import fsg.shared.popups.PopupBaseView;
   
   public class FsgEnterGamerTagView extends PopupBaseView
   {
      
      public function FsgEnterGamerTagView()
      {
         super();
      }
      
      override protected function positionView() : void
      {
         super.positionView();
         myLogo.y = myContent.y - (myLogo.height + TOP_PADDING);
      }
      
      override protected function onInit() : void
      {
         super.onInit();
         listen(BCEvent.CLOSE_ALL_POPUP,FsgEnterGamerTagViewContent(myContent).resetFocus);
      }
      
      override protected function hideView() : void
      {
         unlisten(BCEvent.CLOSE_ALL_POPUP,FsgEnterGamerTagViewContent(myContent).resetFocus);
         super.hideView();
      }
   }
}

