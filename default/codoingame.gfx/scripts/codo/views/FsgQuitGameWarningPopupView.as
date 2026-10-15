package codo.views
{
   import codo.constants.BCInGameEvent;
   import codo.constants.CodoInGamePageDB;
   import codo.manager.PageInGameManager;
   import components.fsgpopups_part.FsgQuitGameWarningPopupViewContent;
   import flash.display.Sprite;
   import flash.utils.getDefinitionByName;
   import fsg.shared.popups.PopupBaseView;
   
   public class FsgQuitGameWarningPopupView extends PopupBaseView
   {
      
      private var mPopupOverlay:Sprite;
      
      public function FsgQuitGameWarningPopupView()
      {
         super();
         var overlayClass:Class = getDefinitionByName("fsg.popups.fsgPopupOverlay") as Class;
         this.mPopupOverlay = addChild(new overlayClass()) as Sprite;
         this.mPopupOverlay.visible = false;
         swapChildren(myContent,this.mPopupOverlay);
      }
      
      override public function set routeData(data:*) : void
      {
         FsgQuitGameWarningPopupViewContent(myContent).warningDescription = data.msg as String;
         FsgQuitGameWarningPopupViewContent(myContent).warningStyle = data.style as uint;
      }
      
      override protected function showView() : void
      {
         this.mPopupOverlay.visible = true;
         FsgQuitGameWarningPopupViewContent(myContent).cancelCallback = this.onCancelButtonClicked;
         super.showView();
      }
      
      private function onCancelButtonClicked() : void
      {
         PageInGameManager.getInstance().cleanPageLayer(CodoInGamePageDB.PAGE_QUIT_GAME_WARNING_POPUP.owner);
         this.mPopupOverlay.visible = false;
         broadcast(BCInGameEvent.HIDE_NOTIFICATION_POPUP);
      }
   }
}

