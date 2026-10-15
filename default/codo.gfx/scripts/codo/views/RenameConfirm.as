package codo.views
{
   import codo.base.PopupView;
   import codo.component.TextField;
   import codo.component.social.InputBox;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.localization.Dict;
   import codo.localization.DictClan;
   import codo.localization.DictOnBoard;
   import codo.objects.InputBoxSettings;
   import codo.style.ClanGuide;
   import codo.style.GlobalGuide;
   import codo.utils.StringUtil;
   
   public class RenameConfirm extends PopupView
   {
      
      public static const RENAME_TYPE_PLAYER:int = 0;
      
      public static const RENAME_TYPE_CLAN:int = 1;
      
      private static const POPUP_WIDTH:Number = 600;
      
      private static const POPUP_HEIGHT:Number = 270;
      
      public var myInputLabel:TextField;
      
      public var myInput:InputBox;
      
      public var myNameHint:TextField;
      
      public var myNameWarning:TextField;
      
      private var mType:int;
      
      private var mInputSetting:InputBoxSettings;
      
      public function RenameConfirm()
      {
         super();
         this.initStage();
      }
      
      private function initStage() : void
      {
         myPopup.width = POPUP_WIDTH;
         myPopup.height = POPUP_HEIGHT;
         myPopup.configConfirmButton(Dict.CONFIRM,this.onRenameBtnClicked,true);
         this.myInputLabel.textStyle = ClanGuide.styleClanLabel;
         this.myInputLabel.width = 150;
         this.myInputLabel.text = Dict.CHANGE_NAME_INTRO;
         this.myNameHint.textStyle = ClanGuide.styleClanValue;
         this.myNameHint.width = 300;
         this.myNameWarning.textStyle = ClanGuide.styleClanWarning;
         this.myNameWarning.fontSize = GlobalGuide.FONT_SIZE_TINY;
         this.myNameWarning.wordWrap = true;
         this.myNameWarning.width = POPUP_WIDTH - 40;
         this.mInputSetting = new InputBoxSettings();
         this.mInputSetting.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         this.mInputSetting.highlightAsDefault = true;
         this.mInputSetting.width = POPUP_WIDTH - 70;
         this.mInputSetting.height = 26;
         this.mInputSetting.showSearchIcon = false;
         this.mInputSetting.needMemoryObfuscate = true;
      }
      
      override public function set routeData(data:*) : void
      {
         super.routeData = data;
         this.mType = data.type;
         this.mInputSetting.regExp = StringUtil.INPUT_FIELD_VALID_REGULAR;
         if(this.mType == RENAME_TYPE_PLAYER)
         {
            myPopup.header.title = Dict.CHANGE_NAME_TITLE;
            this.mInputSetting.limitTextLen = StringUtil.getMaxEnglishNameCharacterCount();
            this.myNameHint.text = DictOnBoard.FIRST_WELCOME_NAME_TEXT_LIMIT;
         }
         else if(this.mType == RENAME_TYPE_CLAN)
         {
            myPopup.header.title = DictClan.CHANGE_CLAN_NAME;
            this.mInputSetting.limitTextLen = StringUtil.getMaxEnglishNameCharacterCount();
            this.myNameHint.text = DictClan.CLAN_CREATE_NAME_LIMIT;
         }
         this.myInput.settings = this.mInputSetting;
         this.showHint("");
      }
      
      override protected function showView() : void
      {
         super.showView();
      }
      
      override protected function hideView() : void
      {
         super.hideView();
      }
      
      override protected function enableData() : void
      {
         super.enableData();
         bind(DataID.SANITIZED_NEW_CLAN_NAME,this.onBindSanitizedClanName);
      }
      
      override protected function disableData() : void
      {
         super.disableData();
         unbind(DataID.SANITIZED_NEW_CLAN_NAME,this.onBindSanitizedClanName);
      }
      
      private function onBindSanitizedClanName(cRes:Object) : void
      {
         this.myInput.text = "";
      }
      
      private function onRenameBtnClicked() : void
      {
         this.showHint("");
         var changedName:String = this.myInput.text;
         if(this.mType == RENAME_TYPE_PLAYER)
         {
            if(StringUtil.getRealLength(changedName) < StringUtil.getMinEnglishNameCharacterCount())
            {
               this.showHint(Dict.NAME_ERROR_LENGTH);
            }
            else
            {
               broadcast(BCEvent.EVT_REDEEM_CHANGE_NAME,changedName);
            }
         }
         else if(this.mType == RENAME_TYPE_CLAN)
         {
            if(changedName.length <= 0)
            {
               this.showHint(DictClan.NOTE_EMPTY_CLAN_NAME);
            }
            else
            {
               broadcast(BCEvent.EVT_REDEEM_CLAN_CHANGE_NAME,changedName);
            }
         }
      }
      
      private function showHint(text:String) : void
      {
         this.myNameWarning.visible = text != "";
         this.myNameWarning.text = text;
      }
   }
}

