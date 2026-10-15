package codo.views
{
   import codo.base.PopupView;
   import codo.component.TextField;
   import codo.component.social.InputBox;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.event.ParaEvent;
   import codo.localization.DictClan;
   import codo.objects.InputBoxSettings;
   import codo.style.ClanGuide;
   import codo.style.GlobalGuide;
   import codo.utils.StringUtil;
   
   public class ClanCreationConfirm extends PopupView
   {
      
      private static const POPUP_WIDTH:Number = 600;
      
      private static const POPUP_HEIGHT:Number = 270;
      
      public var myClanInputLabel:TextField;
      
      public var myClanNameHint:TextField;
      
      public var myClanNameWarning:TextField;
      
      public var myClanInput:InputBox;
      
      public function ClanCreationConfirm()
      {
         super();
         this.initStage();
      }
      
      private function initStage() : void
      {
         var inputSetting:InputBoxSettings = null;
         inputSetting = new InputBoxSettings();
         inputSetting.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         inputSetting.highlightAsDefault = true;
         inputSetting.width = POPUP_WIDTH - 70;
         inputSetting.height = 26;
         inputSetting.showSearchIcon = false;
         inputSetting.limitTextLen = StringUtil.getMaxEnglishNameCharacterCount();
         inputSetting.regExp = StringUtil.INPUT_FIELD_VALID_REGULAR;
         inputSetting.needMemoryObfuscate = true;
         this.myClanInput.settings = inputSetting;
         headerTitle = DictClan.CREATE_CLAN;
         myPopup.width = POPUP_WIDTH;
         myPopup.height = POPUP_HEIGHT;
         myPopup.configConfirmButton(DictClan.CREATE_CLAN,this.onCreateBtnClicked,true);
         this.myClanInputLabel.textStyle = ClanGuide.styleClanLabel;
         this.myClanInputLabel.width = 150;
         this.myClanInputLabel.text = DictClan.LABEL_CLAN_NAME;
         this.myClanNameHint.textStyle = ClanGuide.styleClanValue;
         this.myClanNameHint.width = 300;
         this.myClanNameHint.text = DictClan.CLAN_CREATE_NAME_LIMIT;
         this.myClanNameWarning.textStyle = ClanGuide.styleClanWarning;
         this.myClanNameWarning.fontSize = GlobalGuide.FONT_SIZE_TINY;
         this.myClanNameWarning.wordWrap = true;
         this.myClanNameWarning.width = POPUP_WIDTH - 40;
         this.myClanNameWarning.text = DictClan.CLAN_CREATE_WARNING;
         bind(DataID.CLAN_CREATE_NAME_IPT,this.onGetSanitizedClanName);
         listen(BCEvent.EVT_ON_CLAN_JOINED,this.onClanJoined);
      }
      
      override protected function showView() : void
      {
         super.showView();
         bind(DataID.CLAN_CREATE_NAME_IPT,this.onGetSanitizedClanName);
         listen(BCEvent.EVT_ON_CLAN_JOINED,this.onClanJoined);
         listen(BCEvent.EVT_ON_CLAN_CREATED,this.onClanCreated);
      }
      
      override protected function hideView() : void
      {
         unbind(DataID.CLAN_CREATE_NAME_IPT,this.onGetSanitizedClanName);
         unlisten(BCEvent.EVT_ON_CLAN_JOINED,this.onClanJoined);
         unlisten(BCEvent.EVT_ON_CLAN_CREATED,this.onClanCreated);
         super.hideView();
      }
      
      private function onCreateBtnClicked() : void
      {
         broadcast(BCEvent.CREATE_CLAN_BY_NAME,this.myClanInput.text);
      }
      
      private function onGetSanitizedClanName(cRes:Object) : void
      {
         this.myClanInput.text = "";
      }
      
      private function onClanJoined(cEvt:ParaEvent) : void
      {
         closePopupView();
      }
      
      private function onClanCreated(cEvt:ParaEvent) : void
      {
         closePopupView();
      }
   }
}

