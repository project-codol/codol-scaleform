package codo.views
{
   import codo.base.PopupView;
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.constants.BCCommonEvent;
   import codo.constants.BCEvent;
   import codo.constants.MsgBtnCount;
   import codo.constants.SanitizedType;
   import codo.event.ParaEvent;
   import codo.localization.Dict;
   import codo.localization.DictInGame;
   import codo.localization.DictRoom;
   import codo.services.WeaponLoadoutService;
   import codo.utils.CursorUtil;
   import components.Input;
   import flash.events.KeyboardEvent;
   import flash.text.TextField;
   import flash.ui.Keyboard;
   import fsg.shared.widgets.FsgSharedInputField;
   
   public class FsgChangeLoadoutNamePopupView extends PopupView
   {
      
      private static const POPUP_HEIGHT:Number = 189;
      
      private static const POPUP_WIDTH:Number = 515;
      
      private static const LOADOUT_NAME_LENGTH:uint = 12;
      
      private static const PADDING:uint = 20;
      
      public var myInputBox:FsgSharedInputField;
      
      public var myDescription:TextField;
      
      private var mLoadoutIndex:int = 0;
      
      private var mAddNameTextField:TextField;
      
      public function FsgChangeLoadoutNamePopupView()
      {
         super();
         this.myInputBox.label = DictRoom.LIST_LABEL_NAME;
         this.myInputBox.lengthLimit = LOADOUT_NAME_LENGTH;
         this.myInputBox.regExpLimit = /^[0-9a-zA-Z一-龥][0-9a-zA-Z_一-龥]{0,99}/;
         this.myInputBox.restrict = "_0-9a-zA-Z一-龥";
         this.myInputBox.enable = true;
         this.mAddNameTextField = this.myInputBox.inputTextField;
      }
      
      override protected function showView() : void
      {
         var loadoutName:String = null;
         super.showView();
         listen(BCCommonEvent.EVT_ON_STRING_SANITIZED,this.onSanitizedHandle);
         this.enableButtons();
         var selectedLoadOutIndex:int = WeaponLoadoutService.getInstance().currentWeaponLoadoutIndex;
         var currentCharacterIdx:int = CFunctionCommonContainer.CL_GetCurrentCharacterLoadoutIndex();
         var maxLoadOuts:int = CFunctionCommonContainer.WL_GetMaxNumLoadouts();
         this.mLoadoutIndex = currentCharacterIdx * maxLoadOuts + selectedLoadOutIndex;
         loadoutName = CFunctionContainer.WL_GetLoadoutName(this.mLoadoutIndex,selectedLoadOutIndex);
         this.myInputBox.text = loadoutName;
         this.myInputBox.focusIn();
         this.myInputBox.forceFocus();
      }
      
      override protected function hideView() : void
      {
         super.hideView();
         unlisten(BCCommonEvent.EVT_ON_STRING_SANITIZED,this.onSanitizedHandle);
      }
      
      override protected function enableData() : void
      {
         super.enableData();
         myPopup.width = POPUP_WIDTH;
         myPopup.height = POPUP_HEIGHT;
         myPopup.resetButtons();
         myPopup.configCancelButton(DictInGame.Cancel,this.onCancelClickHandle);
         myPopup.header.title = Dict.RENAME_LOADOUT;
         this.myDescription.text = Dict.RENAME_LOADOUT_SUBTITLE;
         var offset:uint = myPopup.popupWidth - this.myDescription.x;
         this.myDescription.width = offset - PADDING;
      }
      
      public function enableButtons() : void
      {
         this.myInputBox.addEventListener(Input.EVT_PRESS_ENTER,this.onAdvanceBtnClickHandle);
         this.myInputBox.addEventListener(Input.EVT_CHANGE,this.onAddNameChangedHandle);
         myPopup.enableButtons();
         if(stage != null)
         {
            stage.addEventListener(KeyboardEvent.KEY_UP,this.onKeyUpHandle);
         }
      }
      
      private function disableButtons() : void
      {
         this.myInputBox.removeEventListener(Input.EVT_PRESS_ENTER,this.onAdvanceBtnClickHandle);
         this.myInputBox.removeEventListener(Input.EVT_CHANGE,this.onAddNameChangedHandle);
         myPopup.disableButtons();
         if(stage != null)
         {
            stage.removeEventListener(KeyboardEvent.KEY_UP,this.onKeyUpHandle);
         }
      }
      
      private function onKeyUpHandle(cEvt:KeyboardEvent) : void
      {
         switch(cEvt.keyCode)
         {
            case Keyboard.NUMPAD_ENTER:
            case Keyboard.ENTER:
               this.onAdvanceBtnClickHandle();
         }
      }
      
      private function onAddNameChangedHandle(cEvt:ParaEvent) : void
      {
         myPopup.resetButtons();
         if(this.myInputBox.text.length > 0)
         {
            myPopup.configConfirmButton(Dict.RENAME_LOADOUT,this.onAdvanceBtnClickHandle);
            myPopup.configCancelButton(DictInGame.Cancel,this.onCancelClickHandle);
         }
         else
         {
            myPopup.configCancelButton(DictInGame.Cancel,this.onCancelClickHandle);
         }
      }
      
      private function onAdvanceBtnClickHandle() : void
      {
         var newLoadoutName:String = this.mAddNameTextField.text;
         if(newLoadoutName != "")
         {
            this.disableButtons();
            broadcast(BCEvent.EVT_SET_LOADOUT_NAME,{
               "index":this.mLoadoutIndex,
               "name":newLoadoutName
            });
            CursorUtil.EndCursor(CursorUtil.CURSOR_OVER_BUTTON);
         }
      }
      
      private function onCancelClickHandle() : void
      {
         broadcast(BCEvent.EVT_EXIT_RENAME_LOADOUT);
      }
      
      private function onSanitizedHandle(cEvt:ParaEvent) : void
      {
         if(cEvt.myPara.type == SanitizedType.LOADOUT_NAME && Boolean(cEvt.myPara.sanitized))
         {
            showMsg(Dict.RENAME_LOADOUT_SANITIZED,MsgBtnCount.ONE,0,myPopup.enableButtons);
         }
      }
   }
}

