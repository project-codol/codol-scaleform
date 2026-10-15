package codo.views
{
   import codo.base.PopupView;
   import codo.component.TextField;
   import codo.localization.DictSystem;
   import codo.style.TextStyle;
   
   public class LoadoutFullPopupView extends PopupView
   {
      
      public var myDescription:TextField;
      
      public var myLoadoutCount:TextField;
      
      public function LoadoutFullPopupView()
      {
         super();
         myPopup.width = 550;
         myPopup.height = 300;
         headerTitle = LOCALIZE("@SF_UI_SLOTS_FULL_POPUP_TITLE");
         myPopup.configConfirmButton(DictSystem.CONFIRM,this.onConfirm);
         this.myDescription.wordWrap = true;
         this.myDescription.width = myPopup.popupWidth - this.myDescription.x;
         this.myDescription.height = 64;
         this.myLoadoutCount.alignment = TextStyle.HALIGN_RIGHT;
         this.myLoadoutCount.text = "10/10";
         this.myLoadoutCount.x = myPopup.width - this.myLoadoutCount.textWidth - 80;
      }
      
      override public function set routeData(data:*) : void
      {
         this.myDescription.text = LOCALIZE("@SF_UI_SLOTS_FULL_POPUP_DESC");
      }
      
      private function onConfirm() : void
      {
         closePopupView();
      }
   }
}

