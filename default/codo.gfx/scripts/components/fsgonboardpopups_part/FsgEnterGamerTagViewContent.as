package components.fsgonboardpopups_part
{
   import codo.constants.MsgBtnCount;
   import codo.constants.OnboardingSound;
   import codo.event.ParaEvent;
   import codo.localization.Dict;
   import codo.localization.DictOnBoard;
   import codo.localization.DictRoom;
   import codo.utils.LocalizeUtil;
   import codo.utils.ScaleformUtil;
   import codo.utils.StringUtil;
   import components.Input;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import fsg.shared.popups.PopupContentBase;
   import fsg.shared.widgets.FsgSharedInputField;
   
   public class FsgEnterGamerTagViewContent extends PopupContentBase
   {
      
      protected static const STRING_LEN_MIN:uint = 4;
      
      protected static const STRING_LEN_MAX:uint = 16;
      
      public static const EVT_NAME_VAILID_CHANGED:String = "evt_name_valid_changed";
      
      public static const EVT_TRY_CONFIRM_NAME_INPUT:String = "evt_try_confirm_name_input";
      
      public var myTitleText:MovieClip;
      
      public var myDetailsTF:TextField;
      
      public var myMessageTF:TextField;
      
      public var myUsername:FsgSharedInputField;
      
      protected var myUsernameObfuscated:Vector.<int>;
      
      private var m_bNextEnabled:Boolean;
      
      public function FsgEnterGamerTagViewContent()
      {
         super();
         this.myDetailsTF.autoSize = TextFieldAutoSize.LEFT;
      }
      
      override protected function get viewWidth() : uint
      {
         return 545;
      }
      
      override protected function get viewHeight() : uint
      {
         return 300;
      }
      
      public function resetFocus() : void
      {
         this.myUsername.focusIn();
         this.myUsername.forceFocus();
      }
      
      override public function init() : void
      {
         var offset:uint = this.viewWidth * 0.5;
         super.init();
         this.m_bNextEnabled = false;
         this.setNameValid(this.m_bNextEnabled);
         this.myDetailsTF.text = LOCALIZE(DictOnBoard.FIRST_WELCOME_MESSAGE).toUpperCase();
         this.configInputField();
         this.configMessageText();
      }
      
      override public function initListeners() : void
      {
         addEventListener(EVT_NAME_VAILID_CHANGED,this.onNameValidChangedHandle);
         if(ScaleformUtil.isScaleform)
         {
         }
         this.myUsername.addEventListener(Input.EVT_CHANGE,this.onInputChangedHandle);
      }
      
      override protected function configPopUpBase() : void
      {
         super.configPopUpBase();
         var subHeaderTxt:String = LOCALIZE(DictOnBoard.FIRST_WELCOME_TITLE);
         myPopupBase.subheaderText = subHeaderTxt.toUpperCase();
         myPopupBase.configConfirmButton(Dict.NEXT,this.onSubmitName);
         myPopupBase.animateFrame = true;
         myPopupBase.confirmButtonRef.behaviorAudio.overrideMouseOverAudio(OnboardingSound.ONBOARD_UI_MOUSEOVER);
         myPopupBase.confirmButtonRef.behaviorAudio.overrideClickAudio(OnboardingSound.ONBOARD_UI_CLICK);
         this.resetFocus();
      }
      
      private function onSubmitName() : void
      {
         var inputName:String = StringUtil.unobfuscateVectorToString(this.myUsernameObfuscated);
         if(inputName != this.myUsername.inputText || !StringUtil.INPUT_FIELD_VALID_REGULAR.test(inputName))
         {
            this.myUsername.inputText = "";
            this.showMsg(Dict.MESSAGE_UNKNOW_ERROR,MsgBtnCount.ONE);
            return;
         }
         if(StringUtil.getRealLength(inputName) < STRING_LEN_MIN)
         {
            this.onInvalidText(Dict.NAME_ERROR_LENGTH);
         }
         else if(inputName == "")
         {
            this.onInvalidText(Dict.NOTE_CHARACTER_CREATE_PLAYER_NAME_EMPTY);
         }
         else
         {
            this.visible = false;
         }
      }
      
      protected function onInvalidText(msg:String) : void
      {
         showMsg(msg,MsgBtnCount.ONE);
         this.resetFocus();
      }
      
      private function configMessageText() : void
      {
         var contentPos:Point = myPopupBase.contentPosition;
         var restrictions:String = LOCALIZE(DictOnBoard.FIRST_WELCOME_NAME_TEXT_LIMIT);
         this.myMessageTF.text = restrictions.toUpperCase();
         this.myMessageTF.x = this.myDetailsTF.x = contentPos.x + CONTENT_PADDING;
         this.myMessageTF.y = myPopupBase.contentInnerHeight - CONTENT_PADDING;
      }
      
      private function configInputField() : void
      {
         var labelTxt:String = LocalizeUtil.localize(DictRoom.LIST_LABEL_NAME);
         var contentPos:Point = myPopupBase.contentPosition;
         this.myUsername.lengthLimit = STRING_LEN_MAX;
         this.myUsername.regExpLimit = StringUtil.INPUT_FIELD_VALID_REGULAR;
         this.myUsername.restrict = "_0-9a-zA-Z一-龥";
         this.myUsername.label = labelTxt.toUpperCase();
         this.myUsername.x = contentPos.x + CONTENT_PADDING;
         this.myUsername.setSize(myPopupBase.contentWidth - (this.myUsername.x + CONTENT_PADDING * 2));
      }
      
      private function onInputChangedHandle(cEvt:Event) : void
      {
         this.myUsernameObfuscated = StringUtil.obfuscateStringToVector(this.myUsername.inputText);
      }
      
      private function onNameValidChangedHandle(cEvt:ParaEvent) : void
      {
         if(!this.m_bNextEnabled && Boolean(cEvt.myPara.valid))
         {
            onMouseOutTooltip();
         }
         this.m_bNextEnabled = cEvt.myPara.valid;
         myPopupBase.confirmButtonRef.setEnabled(this.m_bNextEnabled);
      }
      
      private function setNameValid(valid:Boolean) : void
      {
         dispatchEvent(new ParaEvent(EVT_NAME_VAILID_CHANGED,{"valid":valid}));
      }
   }
}

