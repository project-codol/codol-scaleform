package components.fsgpopups_part
{
   import codo.base.PopupView;
   import codo.constants.BCEvent;
   import codo.localization.DictSystem;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class FsgCharacterSwapViewContent extends PopupView
   {
      
      public static var POPUP_STATE_MAX_CHARACTERS_WARNING:int = 0;
      
      public static var POPUP_STATE_SWAP_LATER:int = 1;
      
      public var myMessageImage:MovieClip;
      
      public var myPopupDescription:TextField;
      
      public function FsgCharacterSwapViewContent()
      {
         super();
      }
      
      override public function set routeData(data:*) : void
      {
         var screen:int = data as int;
         this.setData(screen);
      }
      
      private function setData(... args) : void
      {
         var popupState:int = args[0] as int;
         switch(popupState)
         {
            case POPUP_STATE_MAX_CHARACTERS_WARNING:
               headerTitle = "@SF_UI_CHAR_SWAP_LIMIT_REACHED";
               this.myPopupDescription.text = "@SF_UI_CHAR_SWAP_LIMIT_REACHED_BODY";
               myPopup.configConfirmButton("@SF_UI_CHAR_SWAP_UPDATE_NOW",this.onClickSwapNow);
               myPopup.configCancelButton("@SF_UI_CHAR_SWAP_UPDATE_LATER",this.onClickSwapLater);
               this.myMessageImage.visible = true;
               this.myMessageImage.gotoAndStop(1);
               break;
            case POPUP_STATE_SWAP_LATER:
               headerTitle = "@SF_UI_CHAR_SWAP_SWAP_LATER";
               this.myPopupDescription.text = "@SF_UI_CHAR_SWAP_SWAP_LATER_BODY";
               myPopup.resetButtons();
               myPopup.configConfirmButton(DictSystem.CONFIRM,this.onSuccess);
               this.myMessageImage.visible = true;
               this.myMessageImage.gotoAndStop(2);
         }
      }
      
      private function onClickSwapNow() : void
      {
         broadcast(BCEvent.EVT_GOTO_MANAGE_CHARACTER_ROSTER);
         closePopupView();
      }
      
      private function onClickSwapLater() : void
      {
         this.setData(POPUP_STATE_SWAP_LATER);
      }
      
      private function onSuccess() : void
      {
         closePopupView();
      }
   }
}

