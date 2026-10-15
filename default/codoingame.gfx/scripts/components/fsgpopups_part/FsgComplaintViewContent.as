package components.fsgpopups_part
{
   import codo.common.CFunctionInGameContainer;
   import codo.constants.BCCommonEvent;
   import codo.constants.BCEvent;
   import codo.constants.DataInGameID;
   import codo.constants.GameInfo;
   import codo.constants.SanitizedType;
   import codo.event.ParaEvent;
   import codo.localization.Dict;
   import codo.localization.DictRoom;
   import codo.localization.DictSystem;
   import codo.manager.DataManager;
   import codo.manager.EventManager;
   import codo.objects.UserObj;
   import codo.utils.ScaleformUtil;
   import components.Input;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import fsg.shared.CheckBox;
   import fsg.shared.ComboBox;
   import fsg.shared.popups.PopupContentBase;
   import fsg.widgets.scrollBarVertical;
   
   public class FsgComplaintViewContent extends PopupContentBase
   {
      
      private static var CHECKBOX_DATA:Vector.<CheckBoxData>;
      
      private static const MAX_COMPLAINT_CHARACTER_LIMIT:uint = 150;
      
      private static const MAX_VOTE_CHARACTER_LIMIT:uint = 20;
      
      public var myAdditionalCommentsBox:MovieClip;
      
      public var myDescriptionTF:TextField;
      
      public var myPlayerName:ComboBox;
      
      public var mySinglePlayerName:MovieClip;
      
      public var myCB0:CheckBox;
      
      public var myCB1:CheckBox;
      
      public var myCB2:CheckBox;
      
      public var myCB3:CheckBox;
      
      public var myCB4:CheckBox;
      
      public var myCB5:CheckBox;
      
      public var myCB6:CheckBox;
      
      public var myCB7:CheckBox;
      
      public var myCB8:CheckBox;
      
      public var myCB9:CheckBox;
      
      public var myCB10:CheckBox;
      
      public var myCB11:CheckBox;
      
      private var mAdditionalComments:Input;
      
      private var mCheckBoxes:Vector.<CheckBox>;
      
      private var mDropdownLabel:Object;
      
      private var m_defaultPlayerSelected:Boolean;
      
      private var mAdditionalCommentsMaxTextField:TextField;
      
      private var mAdditionalCommentsScrollbar:scrollBarVertical;
      
      private var mUseSinglePlayerName:Boolean = false;
      
      private var mSelectedPlayerData:UserObj;
      
      private var mSavedVoteSelectedPlayer:UserObj;
      
      private var mSavedVoteReason:int;
      
      private var mSavedVoteAdditionalText:String;
      
      private var mSavedComplaintSelectedPlayer:UserObj;
      
      private var mSavedComplaintReason:int;
      
      private var mSavedComplaintAdditionalText:String;
      
      private var mIgnoreSavedData:Boolean;
      
      private var mMode:String;
      
      public function FsgComplaintViewContent()
      {
         super();
         this.createSinglePlayerArtAsset();
         this.mAdditionalComments = this.myAdditionalCommentsBox.myAdditionalComments;
         this.mAdditionalCommentsMaxTextField = this.myAdditionalCommentsBox.myAdditionalComments.myIptTF;
         this.mAdditionalCommentsScrollbar = this.myAdditionalCommentsBox.myScrollBar;
         this.mCheckBoxes = new <CheckBox>[this.myCB0,this.myCB1,this.myCB2,this.myCB3,this.myCB4,this.myCB5,this.myCB6,this.myCB7,this.myCB8,this.myCB9,this.myCB10,this.myCB11];
         this.mDropdownLabel = {"label":Dict.COMPLAINT_DROPDOWN_LABEL};
         this.m_defaultPlayerSelected = false;
         this.myAdditionalCommentsBox.y = 207;
         this.mAdditionalCommentsMaxTextField.height = 124;
         this.myAdditionalCommentsBox.gotoAndStop(3);
         this.mIgnoreSavedData = false;
         this.mSavedVoteSelectedPlayer = null;
         this.mSavedVoteReason = -1;
         this.mSavedVoteAdditionalText = "";
         this.mSavedComplaintSelectedPlayer = null;
         this.mSavedComplaintReason = -1;
         this.mSavedComplaintAdditionalText = "";
      }
      
      override protected function configPopUpBase() : void
      {
         super.configPopUpBase();
         myPopupBase.animateFrame = false;
         myPopupBase.setSize(viewWidth,viewHeight);
         if(ScaleformUtil.isScaleform)
         {
            myPopupBase.configCancelButton(LOCALIZE(DictSystem.CANCEL).toUpperCase(),this.onCancelBtnClickHandle);
            myPopupBase.configConfirmButton(LOCALIZE(Dict.QUESTION_SUBMIT).toUpperCase(),this.onConfirmBtnClickHandle);
         }
         this.myPlayerName.label = LOCALIZE(DictRoom.LIST_LABEL_PLAYER).toUpperCase();
         this.mySinglePlayerName.myLabel.text = LOCALIZE(DictRoom.LIST_LABEL_PLAYER).toUpperCase();
         this.reset();
      }
      
      override public function setData(... args) : void
      {
         var index:uint = 0;
         var user:Object = null;
         var reasons:Array = null;
         var i:int = 0;
         var playerName:String = null;
         var voteType:int = 0;
         var voteTypeInfo:Object = null;
         var cb:CheckBox = null;
         var data:CheckBoxData = null;
         var preSelection:UserObj = args[0];
         var userList:Array = args[1];
         this.mMode = args[2];
         if(preSelection == null)
         {
            userList = userList.concat();
            userList.unshift(this.mDropdownLabel);
         }
         this.m_defaultPlayerSelected = preSelection != null ? true : false;
         index = 0;
         var selectUser:UserObj = preSelection != null ? preSelection : (this.mMode == "vote" ? this.mSavedVoteSelectedPlayer : this.mSavedComplaintSelectedPlayer);
         if(selectUser != null)
         {
            for each(user in userList)
            {
               if(selectUser.id != null && selectUser.id == user.id)
               {
                  break;
               }
               index++;
            }
         }
         if(!this.mUseSinglePlayerName)
         {
            this.myPlayerName.dataProvider = userList;
            this.myPlayerName.selectedIndex = index;
            if(userList.length > 1)
            {
               this.myPlayerName.enabled = true;
            }
            else
            {
               this.myPlayerName.enabled = false;
            }
         }
         else
         {
            this.mSelectedPlayerData = userList[0];
            playerName = this.mSelectedPlayerData.name;
            this.mySinglePlayerName.myPlayerName.text = playerName;
         }
         if(this.mMode == "vote")
         {
            voteType = DataManager.getInstance().getDP(DataInGameID.GET_CURRENT_VOTE_TYPE);
            voteTypeInfo = CFunctionInGameContainer.AS_GetVoteTypeInfo(voteType);
            if(voteTypeInfo != null)
            {
               myPopupBase.headerText = LOCALIZE("@" + voteTypeInfo.title).toUpperCase();
               myPopupBase.subheaderText = LOCALIZE("@" + voteTypeInfo.subtitle).toUpperCase();
               this.myDescriptionTF.text = "@" + voteTypeInfo.desc;
               this.myAdditionalCommentsBox.myTitleTF.text = "@" + voteTypeInfo.additionalComments;
            }
            this.mAdditionalComments.lengthLimit = MAX_VOTE_CHARACTER_LIMIT;
            this.mAdditionalComments.lengthLimitIsCharacterCount = true;
            this.mAdditionalComments.multiLineEnable = false;
            this.myAdditionalCommentsBox.mCharLimit.text = MAX_VOTE_CHARACTER_LIMIT.toString();
            reasons = CFunctionInGameContainer.AS_GetVoteReasonListByVoteType(voteType);
            CHECKBOX_DATA = new Vector.<CheckBoxData>(0);
            for(i = 0; i < reasons.length; i++)
            {
               CHECKBOX_DATA.push(new CheckBoxData(i + 1,reasons[i]));
            }
         }
         else
         {
            myPopupBase.headerText = LOCALIZE(Dict.COMPLAINT_TITLE).toUpperCase();
            myPopupBase.subheaderText = LOCALIZE(Dict.COMPLAINT_SUBITLE).toUpperCase();
            this.mAdditionalComments.lengthLimit = MAX_COMPLAINT_CHARACTER_LIMIT;
            this.mAdditionalComments.lengthLimitIsCharacterCount = true;
            this.mAdditionalComments.multiLineEnable = true;
            this.myAdditionalCommentsBox.mCharLimit.text = MAX_COMPLAINT_CHARACTER_LIMIT.toString();
            CHECKBOX_DATA = new <CheckBoxData>[new CheckBoxData(1,Dict.COMPLAINT_CHECKBOX_HACK),new CheckBoxData(2,Dict.COMPLAINT_CHECKBOX_MALICIOUS_USE_OF_BUG),new CheckBoxData(3,Dict.COMPLAINT_CHECKBOX_IDLING),new CheckBoxData(4,Dict.COMPLAINT_CHECKBOX_TEAM_CHAT_HARASSMENT),new CheckBoxData(5,Dict.COMPLAINT_CHECKBOX_ACTOR)];
            this.myDescriptionTF.text = Dict.COMPLAINT_DESC;
            this.myAdditionalCommentsBox.myTitleTF.text = Dict.COMPLAINT_ADDITIONAL_COMMENTS;
         }
         var preselectedReason:int = this.mMode == "vote" ? this.mSavedVoteReason : this.mSavedComplaintReason;
         if(ScaleformUtil.isScaleform)
         {
            index = 0;
            for each(cb in this.mCheckBoxes)
            {
               cb.addCheckedCallback(this.onCheckBoxStateChanged,cb);
               cb.addUncheckedCallback(this.onCheckBoxStateChanged,cb);
               cb.visible = index < CHECKBOX_DATA.length;
               if(cb.visible)
               {
                  data = CHECKBOX_DATA[index];
                  cb.setText("@" + data.mTitle);
                  if(data.mId == preselectedReason)
                  {
                     cb.checked = true;
                  }
               }
               index++;
            }
         }
         this.myAdditionalCommentsBox.text = this.mMode == "vote" ? this.mSavedVoteAdditionalText : this.mSavedComplaintAdditionalText;
         this.refreshConfirmBtn();
      }
      
      public function set useSinglePlayerName(value:Boolean) : void
      {
         this.mUseSinglePlayerName = value;
         this.mySinglePlayerName.visible = this.mUseSinglePlayerName;
         this.myPlayerName.visible = !this.mUseSinglePlayerName;
      }
      
      public function tryToSendOriginalBadLanguageTLog(id:String, name:String) : void
      {
         var data:Object = null;
         if(this.mUseSinglePlayerName && this.mSelectedPlayerData.badLanguage != null)
         {
            data = {
               "id":id,
               "name":name,
               "message":this.mSelectedPlayerData.badLanguage,
               "history":this.mSelectedPlayerData.recentChatMessage
            };
            broadcast(BCEvent.EVT_SEND_BAD_LANGUAGE_TLOG,data);
         }
      }
      
      public function enableData() : void
      {
         this.reset();
         this.myPlayerName.hackShowInTheBeginning();
         this.mIgnoreSavedData = false;
         this.autoFillBadLanguage();
         this.myPlayerName.addEventListener(ComboBox.EVT_CHANGE,this.onPlayerNameChanged);
         this.mAdditionalComments.addEventListener(Input.EVT_CHANGE,this.onAdditionalCommentChange);
         this.mAdditionalCommentsMaxTextField.addEventListener(Event.SCROLL,this.onAdditionalCommentScroll);
         this.mAdditionalCommentsScrollbar.setScrollCallback(this.onAdditionalCommentScrollbarDrag);
         EventManager.getInstance().listen(BCCommonEvent.EVT_ON_STRING_SANITIZED,this.onAdditionalCommentSanitizedHandle);
      }
      
      private function autoFillBadLanguage() : void
      {
         if(this.mUseSinglePlayerName && this.mSelectedPlayerData.badLanguage != null)
         {
            this.myCB3.checked = true;
            this.mAdditionalComments.text = this.mSelectedPlayerData.badLanguage;
         }
      }
      
      public function disableData() : void
      {
         var cb:CheckBox = null;
         if(Boolean(stage))
         {
            stage.focus = null;
         }
         this.myPlayerName.removeEventListener(ComboBox.EVT_CHANGE,this.onPlayerNameChanged);
         for each(cb in this.mCheckBoxes)
         {
            cb.removeCheckedCallback(this.onCheckBoxStateChanged,cb);
            cb.removeUncheckedCallback(this.onCheckBoxStateChanged,cb);
         }
         this.mAdditionalComments.removeEventListener(Input.EVT_CHANGE,this.onAdditionalCommentChange);
         this.mAdditionalCommentsMaxTextField.removeEventListener(Event.SCROLL,this.onAdditionalCommentScroll);
         this.mAdditionalCommentsScrollbar.setScrollCallback(null);
         EventManager.getInstance().unlisten(BCCommonEvent.EVT_ON_STRING_SANITIZED,this.onAdditionalCommentSanitizedHandle);
      }
      
      public function storeDataIfNeeded() : void
      {
         if(this.mMode == "vote")
         {
            this.mSavedVoteSelectedPlayer = this.mIgnoreSavedData == false ? this.getSelectedValue() : null;
            this.mSavedVoteReason = this.mIgnoreSavedData == false ? int(this.getCheckedValue()) : -1;
            this.mSavedVoteAdditionalText = this.mIgnoreSavedData == false ? this.mAdditionalComments.text : "";
         }
         else
         {
            this.mSavedComplaintSelectedPlayer = this.mIgnoreSavedData == false ? this.getSelectedValue() : null;
            this.mSavedComplaintReason = this.mIgnoreSavedData == false ? int(this.getCheckedValue()) : -1;
            this.mSavedComplaintAdditionalText = this.mIgnoreSavedData == false ? this.mAdditionalComments.text : "";
         }
      }
      
      protected function onCancelBtnClickHandle() : void
      {
         if(this.mMode == "vote")
         {
            broadcast(BCEvent.EVT_VOTE_CANCEL);
         }
         else
         {
            broadcast(BCEvent.EVT_COMPLAINT_CANCEL);
         }
      }
      
      protected function onConfirmBtnClickHandle() : void
      {
         if(this.mMode == "vote")
         {
            if(this.mAdditionalComments.text == "")
            {
               this.broadcastVoteConfirmMessage("");
               return;
            }
            broadcast(BCCommonEvent.EVT_SANITIZE_STRING,{
               "type":SanitizedType.VOTE,
               "content":this.mAdditionalComments.text
            });
            return;
         }
         var selectedValue:UserObj = this.getSelectedValue();
         var checkedValue:uint = this.getCheckedValue();
         var eventMessage:Object = {
            "user":selectedValue,
            "options":checkedValue - 1,
            "message":this.mAdditionalComments.text
         };
         this.tryToSendOriginalBadLanguageTLog(selectedValue.id,selectedValue.name);
         broadcast(BCEvent.EVT_COMPLAINT_CONFIRM,eventMessage);
      }
      
      private function getCheckedValue() : uint
      {
         var cb:CheckBox = null;
         var checkedValue:uint = 0;
         for each(cb in this.mCheckBoxes)
         {
            if(cb.checked)
            {
               checkedValue = CHECKBOX_DATA[this.mCheckBoxes.indexOf(cb)].mId;
               break;
            }
         }
         return checkedValue;
      }
      
      private function getSelectedValue() : UserObj
      {
         var selectedValue:UserObj = null;
         if(!this.mUseSinglePlayerName)
         {
            selectedValue = this.myPlayerName.selectedValue as UserObj;
            if(!selectedValue)
            {
               selectedValue = new UserObj(this.myPlayerName.selectedValue);
            }
         }
         else
         {
            selectedValue = this.mSelectedPlayerData;
         }
         return selectedValue;
      }
      
      private function broadcastVoteConfirmMessage(additionalComments:String) : void
      {
         this.mIgnoreSavedData = true;
         var selectedValue:UserObj = this.getSelectedValue();
         var checkedValue:uint = this.getCheckedValue();
         var eventMessage:Object = {
            "user":selectedValue,
            "options":checkedValue - 1,
            "message":additionalComments
         };
         broadcast(BCEvent.EVT_VOTE_CONFIRM,eventMessage);
      }
      
      private function onAdditionalCommentSanitizedHandle(cEvt:ParaEvent) : void
      {
         var additionalComments:String = null;
         if(cEvt.myPara.type == SanitizedType.VOTE)
         {
            additionalComments = cEvt.myPara.content;
            this.broadcastVoteConfirmMessage(additionalComments);
         }
      }
      
      private function onPlayerNameChanged(cEvt:ParaEvent) : void
      {
         this.refreshConfirmBtn();
      }
      
      private function onCheckBoxStateChanged(cb:CheckBox) : void
      {
         var entry:CheckBox = null;
         if(cb.checked)
         {
            for each(entry in this.mCheckBoxes)
            {
               if(entry != cb)
               {
                  entry.checked = false;
               }
            }
            this.refreshConfirmBtn();
            return;
         }
         this.refreshConfirmBtn();
      }
      
      private function onAdditionalCommentChange(cEvt:ParaEvent) : void
      {
         var limit:int = this.mMode == "vote" ? int(MAX_VOTE_CHARACTER_LIMIT) : int(MAX_COMPLAINT_CHARACTER_LIMIT);
         this.myAdditionalCommentsBox.mCharLimit.text = limit - this.mAdditionalComments.text.length;
         this.refreshScrollbar();
      }
      
      private function onAdditionalCommentScroll(cEvt:Event) : void
      {
         this.refreshScrollbar();
      }
      
      private function onAdditionalCommentScrollbarDrag() : void
      {
         this.mAdditionalCommentsMaxTextField.scrollV = Math.round((this.mAdditionalCommentsMaxTextField.maxScrollV - 1) * this.mAdditionalCommentsScrollbar.position) + 1;
      }
      
      private function refreshConfirmBtn() : void
      {
         var cb:CheckBox = null;
         var hasAnOptionChecked:Boolean = false;
         var hasSelectedPlayer:Boolean = false;
         if(this.m_defaultPlayerSelected)
         {
            hasSelectedPlayer = true;
         }
         else
         {
            hasSelectedPlayer = this.myPlayerName.selectedIndex > 0 ? true : false;
         }
         for each(cb in this.mCheckBoxes)
         {
            if(cb.checked)
            {
               hasAnOptionChecked = true;
               break;
            }
         }
         if(CHECKBOX_DATA == null || CHECKBOX_DATA.length == 0)
         {
            hasAnOptionChecked = true;
         }
         myPopupBase.myPopupConfirmBtn.setEnabled(hasAnOptionChecked && hasSelectedPlayer);
      }
      
      private function refreshScrollbar() : void
      {
         if(this.mAdditionalCommentsMaxTextField.maxScrollV > 1)
         {
            this.mAdditionalCommentsScrollbar.visible = true;
            this.mAdditionalCommentsScrollbar.setNoCBPosition((this.mAdditionalCommentsMaxTextField.scrollV - 1) / (this.mAdditionalCommentsMaxTextField.maxScrollV - 1));
         }
         else
         {
            this.mAdditionalCommentsScrollbar.visible = false;
         }
      }
      
      private function reset() : void
      {
         var cb:CheckBox = null;
         this.mAdditionalComments.text = "";
         this.myAdditionalCommentsBox.mCharLimit.text = this.mMode == "vote" ? MAX_VOTE_CHARACTER_LIMIT : MAX_COMPLAINT_CHARACTER_LIMIT;
         for each(cb in this.mCheckBoxes)
         {
            cb.checked = false;
         }
         this.refreshConfirmBtn();
         this.refreshScrollbar();
      }
      
      private function createSinglePlayerArtAsset() : void
      {
         this.mySinglePlayerName = new MovieClip();
         this.mySinglePlayerName.graphics.beginFill(0,0.6);
         this.mySinglePlayerName.graphics.drawRect(0,0,452,27);
         this.mySinglePlayerName.graphics.beginFill(16777215,0.2);
         this.mySinglePlayerName.graphics.drawRect(185,3,264,21);
         var textFormat:TextFormat = new TextFormat();
         textFormat.font = GameInfo.GAME_FONT_L;
         textFormat.size = 14;
         var label:TextField = new TextField();
         label.name = "myLabel";
         label.x = 10;
         label.y = 3.25;
         label.width = 104;
         label.height = 20.25;
         label.textColor = 16777215;
         label.selectable = false;
         label.defaultTextFormat = textFormat;
         this.mySinglePlayerName.myLabel = label;
         this.mySinglePlayerName.addChild(label);
         var playerName:TextField = new TextField();
         playerName.name = "myPlayerName";
         playerName.x = 186;
         playerName.y = 3.25;
         playerName.width = 260;
         playerName.height = 20.25;
         playerName.textColor = 16777215;
         playerName.selectable = false;
         playerName.defaultTextFormat = textFormat;
         this.mySinglePlayerName.myPlayerName = playerName;
         this.mySinglePlayerName.addChild(playerName);
         this.mySinglePlayerName.x = 40.5;
         this.mySinglePlayerName.y = 109.5;
         addChild(this.mySinglePlayerName);
      }
   }
}

class CheckBoxData
{
   
   public var mId:uint;
   
   public var mTitle:String;
   
   public function CheckBoxData(cId:uint, cTitle:String)
   {
      super();
      this.mId = cId;
      this.mTitle = cTitle;
   }
}
