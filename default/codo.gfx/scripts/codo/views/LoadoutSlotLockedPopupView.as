package codo.views
{
   import codo.base.PopupView;
   import codo.common.CFunctionCommonContainer;
   import codo.component.TextField;
   import codo.localization.DictSystem;
   import codo.style.TextStyle;
   import fsg.util.FsgImageHolder;
   
   public class LoadoutSlotLockedPopupView extends PopupView
   {
      
      public var myDescription:TextField;
      
      public var myLoadoutCount:TextField;
      
      public var myWildcardImage:FsgImageHolder;
      
      public var myWildcardName:TextField;
      
      public function LoadoutSlotLockedPopupView()
      {
         super();
         headerTitle = LOCALIZE("@SF_UI_SLOT_LOCKED_POPUP_TITLE");
         myPopup.configConfirmButton(DictSystem.CONFIRM,this.onConfirm);
         this.myDescription.wordWrap = true;
         this.myDescription.width = myPopup.popupWidth - this.myDescription.x;
         this.myDescription.height = 64;
         this.myLoadoutCount.alignment = TextStyle.HALIGN_RIGHT;
         this.myWildcardName.width = 250;
         this.myWildcardName.alignment = TextStyle.HALIGN_CENTER;
      }
      
      override public function set routeData(data:*) : void
      {
         var wildcard:Object = CFunctionCommonContainer.GetItemInfo(data.requiredWildcard);
         this.myDescription.text = LOCALIZE("@SF_UI_SLOT_LOCKED_POPUP_DESC");
         this.myLoadoutCount.text = data.numItems + "/10";
         this.myWildcardName.text = wildcard.name;
         this.myWildcardImage.setImage(wildcard.imageURL);
      }
      
      private function onConfirm() : void
      {
         closePopupView();
      }
   }
}

