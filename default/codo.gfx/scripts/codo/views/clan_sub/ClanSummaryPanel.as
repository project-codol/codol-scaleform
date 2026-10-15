package codo.views.clan_sub
{
   import codo.base.BaseSubElement;
   import codo.component.Button;
   import codo.component.TextField;
   import codo.component.social.CTPGauge;
   import codo.component.social.ClaimBuffButton;
   import codo.component.social.ClanCommonTip;
   import codo.component.social.ClanOptionButton;
   import codo.component.social.ClanTagsItem;
   import codo.component.social.TextArea;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.event.ParaEvent;
   import codo.localization.Dict;
   import codo.localization.DictClan;
   import codo.objects.ClanGlobalConfig;
   import codo.objects.ClanObj;
   import codo.objects.InputBoxSettings;
   import codo.objects.RightClickMenuItemObj;
   import codo.style.ClanGuide;
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   import codo.utils.LocalizeUtil;
   import codo.utils.StringUtil;
   import codo.utils.TextUtil;
   import codo.views.ChatView;
   import codo.views.wargod_parts.InfoButton;
   import flash.display.MovieClip;
   
   public class ClanSummaryPanel extends BaseSubElement
   {
      
      private static const CLAN_NAME_TEXT_WIDTH:int = 583;
      
      private static const CLAN_LEADER_NAME_TEXT_WIDTH:int = 480;
      
      private static const CLAN_SUMMARY_TEXT_WIDTH:int = 220;
      
      private static const EDIT_BTN_WIDTH:Number = 68;
      
      private static const OPTION_BTN_HEIGHT:Number = 55;
      
      private static const EDIT_MODE:uint = 0;
      
      private static const SHOW_MODE:uint = 1;
      
      private static const BASIC_WIDTH:uint = 1194;
      
      private static const CLAN_TAGS_VERTICAL_LIMIT:int = 810;
      
      private static const CLAN_TAGS_VERTICAL_X:int = 824;
      
      public var myClanOptionBtn:ClanOptionButton;
      
      public var myClanLevelName:TextField;
      
      public var myClanName:TextField;
      
      public var myClanID:TextField;
      
      public var myClanLeader:TextField;
      
      public var myClanSize:TextField;
      
      public var myClanAnnouncement:TextField;
      
      public var myClanAnnouncementInput:TextArea;
      
      public var myClanMarketBtn:Button;
      
      public var myEditBtn:Button;
      
      public var myCTPEarnedToday:CTPGauge;
      
      public var myCTPTotal:CTPGauge;
      
      public var myClanIcon:MovieClip;
      
      public var myClanCommonTip:ClanCommonTip;
      
      public var myClaimReward:ClaimBuffButton;
      
      public var myInfoButton:InfoButton;
      
      public var myClanTags:ClanTagsItem;
      
      private var mData:ClanObj;
      
      private var mEditMode:uint = 1;
      
      private var mInputBoxSetting:InputBoxSettings;
      
      private var mGlobalConfig:ClanGlobalConfig;
      
      private var mOwnerOptions:Vector.<RightClickMenuItemObj> = new Vector.<RightClickMenuItemObj>();
      
      private var mOptions:Vector.<RightClickMenuItemObj> = new Vector.<RightClickMenuItemObj>();
      
      private var mCTPToLevelUp:int = -1;
      
      public function ClanSummaryPanel()
      {
         super();
         this.initStage();
      }
      
      private function initStage() : void
      {
         this.myClanName.font = GlobalGuide.FONT_FACE_MEDIUM;
         this.myClanName.fontSize = GlobalGuide.FONT_SIZE_LARGE;
         var labelStyle:TextStyle = new TextStyle();
         labelStyle.font = GlobalGuide.FONT_FACE_BOLD;
         labelStyle.fontSize = GlobalGuide.FONT_SIZE_SMALL;
         labelStyle.fontColor = GlobalGuide.WHITE;
         var clanLeaderNameStyle:TextStyle = new TextStyle();
         clanLeaderNameStyle.font = GlobalGuide.FONT_FACE_MEDIUM;
         clanLeaderNameStyle.fontSize = GlobalGuide.FONT_SIZE_MEDIUM;
         clanLeaderNameStyle.fontColor = GlobalGuide.GRAY_80;
         this.myClanLeader.textStyle = ClanGuide.styleClanLeader;
         this.myClanLeader.width = CLAN_LEADER_NAME_TEXT_WIDTH;
         this.myClanID.textStyle = ClanGuide.styleClanID;
         this.myClanSize.textStyle = ClanGuide.styleClanSize;
         this.myClanLevelName.textStyle = ClanGuide.styleClanLevelName;
         this.myClanLevelName.width = 120;
         this.myClanLevelName.height = 31;
         this.myClanName.enableTruncate(true);
         this.myClanName.width = CLAN_NAME_TEXT_WIDTH;
         this.myClanName.height = 50;
         this.myClanName.multiline = false;
         this.myClanName.wordWrap = false;
         this.myClanID.width = CLAN_SUMMARY_TEXT_WIDTH;
         this.myClanSize.x = this.myClanSize.x + this.myClanSize.width - CLAN_SUMMARY_TEXT_WIDTH;
         this.myClanSize.width = CLAN_SUMMARY_TEXT_WIDTH;
         this.myClanAnnouncement.height = 55;
         this.myClanAnnouncement.width = BASIC_WIDTH;
         this.myClanAnnouncement.textStyle = ClanGuide.styleClanMultiLineValue;
         this.myClanName.text = "";
         this.myClanID.text = "";
         this.myClanLeader.text = "";
         this.myClanSize.text = "";
         this.myClanAnnouncement.text = "";
         var xpBoostPercent1:Number = getDP(DataID.CLAN_XP_BOOST_VALUE,[1]);
         var xpBoostPercent1Str:String = String(Math.round(xpBoostPercent1 * 100)) + "%";
         this.mInputBoxSetting = new InputBoxSettings();
         this.mInputBoxSetting.height = 55;
         this.mInputBoxSetting.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         this.mInputBoxSetting.highlightAsDefault = true;
         this.mInputBoxSetting.limitTextLen = ClanGuide.MAX_ANNO_TEXT_COUNT;
         this.mInputBoxSetting.limitTextLine = 2;
         this.myClanAnnouncementInput.settings = this.mInputBoxSetting;
         this.myEditBtn.width = EDIT_BTN_WIDTH;
         this.myEditBtn.height = OPTION_BTN_HEIGHT;
         this.myEditBtn.label = DictClan.EDIT_ANNOUNCEMENT;
         this.myEditBtn.visible = false;
         this.myCTPEarnedToday.setFillColor([3646444,4708344]);
         this.myCTPEarnedToday.setLabel(DictClan.CTP_EARNED_TODAY);
         this.myCTPEarnedToday.setValue(50,100);
         this.myCTPTotal.setFillColor([15963911,16763904]);
         this.myCTPTotal.setLabel(DictClan.CTP_EARNED_TOTAL);
         this.myCTPTotal.setValue(50,100);
         this.myClanMarketBtn.width = 150;
         this.myClanMarketBtn.height = 35;
         this.myClanMarketBtn.label = DictClan.CLAN_MARKETPLACE_BTN;
         this.myEditBtn.registerClickEvent(this.clickEditAnnouncement);
         this.myClanMarketBtn.registerClickEvent(this.navigateToClanMarketplace);
         this.myInfoButton.registerClickEvent(this.clickInfoButton);
         this.myClaimReward.registerClickCallback(this.clickClaimButton);
         this.myClanAnnouncementInput.visible = false;
         this.myClanAnnouncement.visible = true;
         var chatOption:RightClickMenuItemObj = new RightClickMenuItemObj();
         chatOption.label = DictClan.CLAN_CHATTING;
         chatOption.handle = this.startClanChat;
         var editAnnouncementOption:RightClickMenuItemObj = new RightClickMenuItemObj();
         editAnnouncementOption.label = DictClan.EDIT_ANNOUNCEMENT;
         editAnnouncementOption.handle = this.clickEditAnnouncement;
         var leaveOption:RightClickMenuItemObj = new RightClickMenuItemObj();
         leaveOption.label = DictClan.LEAVE_CLAN;
         leaveOption.handle = this.leaveClan;
         var changeNameOption:RightClickMenuItemObj = new RightClickMenuItemObj();
         changeNameOption.label = DictClan.CHANGE_CLAN_NAME;
         changeNameOption.handle = this.clickChangeClanName;
         var editClanTag:RightClickMenuItemObj = new RightClickMenuItemObj();
         editClanTag.label = DictClan.EDIT_CLAN_TAGS;
         editClanTag.handle = this.clickEditClanTags;
         this.mOptions.push(chatOption);
         this.mOptions.push(leaveOption);
         this.mOwnerOptions.push(chatOption);
         this.mOwnerOptions.push(editAnnouncementOption);
         this.mOwnerOptions.push(changeNameOption);
         this.mOwnerOptions.push(leaveOption);
         this.mOwnerOptions.push(editClanTag);
         this.myClanCommonTip.hideTip();
      }
      
      override public function active() : void
      {
         super.active();
         this.mGlobalConfig = getDP(DataID.CLAN_GLOBAL_CONFIG);
         bind(DataID.CLAN_INFO,this.bind_clanBasicInfo);
         bind(DataID.CLAN_MEMBER,this.bind_clanMember);
         bind(DataID.SECONDS_TO_CLAIM_CLAN_DAILY_REWARD,this.bind_nextClaimRewardTimeUpdate);
         bind(DataID.MARKETPLACE_MAINTAIN_STATE,this.bindMarketplaceMaintainState);
         listen(BCEvent.ON_ROOM_JOINED,this.onInRoomStateChanged);
         listen(BCEvent.ON_ROOM_LEFT,this.onInRoomStateChanged);
         this.myClanCommonTip.bindMovieClip(this.myClanIcon,this.clanIconToolTipTextSetter);
         this.myClanCommonTip.bindMovieClip(this.myCTPTotal,this.ctpTotalTipTextSetter);
         this.updateClanMarketBtnState();
      }
      
      override public function deactive() : void
      {
         this.myClanCommonTip.unbindMovieClip(this.myClanIcon);
         this.myClanCommonTip.unbindMovieClip(this.myCTPTotal);
         this.myClanCommonTip.hideTip();
         unbind(DataID.CLAN_INFO,this.bind_clanBasicInfo);
         unbind(DataID.CLAN_MEMBER,this.bind_clanMember);
         unbind(DataID.SECONDS_TO_CLAIM_CLAN_DAILY_REWARD,this.bind_nextClaimRewardTimeUpdate);
         unbind(DataID.MARKETPLACE_MAINTAIN_STATE,this.bindMarketplaceMaintainState);
         unlisten(BCEvent.ON_ROOM_JOINED,this.onInRoomStateChanged);
         unlisten(BCEvent.ON_ROOM_LEFT,this.onInRoomStateChanged);
         super.deactive();
      }
      
      private function onInRoomStateChanged(cEvt:ParaEvent) : void
      {
         this.updateClanMarketBtnState();
      }
      
      private function updateClanMarketBtnState() : void
      {
         var isEnabled:Boolean = !getDP(DataID.IS_IN_ROOM);
         isEnabled &&= Boolean(getDP(DataID.IS_DATA_AVAILABLE));
         if(isEnabled)
         {
            this.myClanMarketBtn.enabled = true;
            this.myClanMarketBtn.alpha = 1;
            this.myClanCommonTip.unbindMovieClip(this.myClanMarketBtn);
         }
         else
         {
            this.myClanMarketBtn.enabled = false;
            this.myClanMarketBtn.alpha = 0.5;
            this.myClanCommonTip.bindMovieClip(this.myClanMarketBtn,this.clanMarketBtnDisableToolTip);
         }
      }
      
      private function bind_clanBasicInfo(cRes:Object) : void
      {
         this.mData = cRes.data;
         this.myClanName.text = this.mData.name;
         this.myClanID.text = "(" + LocalizeUtil.localize(DictClan.LABEL_CLAN_ID) + ": " + this.mData.id + ")";
         this.myClanID.x = this.myClanName.x + this.myClanName.textWidth + 10;
         var clanTagsX:Number = this.myClanID.x + this.myClanID.textWidth + 22;
         if(clanTagsX > CLAN_TAGS_VERTICAL_LIMIT)
         {
            clanTagsX = clanTagsX > CLAN_TAGS_VERTICAL_X ? clanTagsX : CLAN_TAGS_VERTICAL_X;
            this.myClanTags.vertical = true;
         }
         else
         {
            this.myClanTags.vertical = false;
         }
         this.myClanTags.x = clanTagsX;
         this.myClanTags.setData(this.mData.tags);
         this.myClanLeader.text = LocalizeUtil.localize(DictClan.LABEL_CLAN_LEADER) + " " + this.mData.ownerName;
         StringUtil.fitTextField(this.myClanLeader.myTextClip);
         if(this.mEditMode == EDIT_MODE)
         {
            return;
         }
         if(this.mData.clanAnnouncement == "")
         {
            this.myClanAnnouncement.text = DictClan.NOTE_NO_CLAN_ANNOUNCEMENT;
            this.myClanAnnouncement.alignment = TextStyle.HALIGN_CENTER;
         }
         else
         {
            this.myClanAnnouncement.text = this.mData.clanAnnouncement;
            this.myClanAnnouncement.alignment = this.myClanAnnouncement.numLines > 1 ? TextStyle.HALIGN_LEFT : TextStyle.HALIGN_CENTER;
            TextUtil.truncatTextByLineNum(this.myClanAnnouncement.myTextClip,2);
         }
         if(Boolean(getDP(DataID.IS_CLAN_OWNER)))
         {
            this.myClanOptionBtn.setOption(this.mOwnerOptions);
            this.mInputBoxSetting.width = BASIC_WIDTH - EDIT_BTN_WIDTH - GlobalGuide.COMPONENT_PADDING;
         }
         else
         {
            this.myClanOptionBtn.setOption(this.mOptions);
            this.mInputBoxSetting.width = BASIC_WIDTH;
            this.switchEditAnnouncementMode(SHOW_MODE);
         }
         this.myClanAnnouncementInput.settings = this.mInputBoxSetting;
         this.setClanLevel(this.mData.level);
         this.setCTP(this.mData.level,this.mData.ctp);
         this.setCTPEarnedToday(this.mData.level,this.mData.ctpEarnedToday);
         this.setClaimButton(this.mData.level);
      }
      
      private function bind_clanMember(cRes:Object) : void
      {
         var members:Array = cRes.data;
         this.myClanSize.text = LocalizeUtil.localize(DictClan.LABEL_CLAN_SIZE) + " " + String(members.length) + "/100";
      }
      
      private function bind_nextClaimRewardTimeUpdate(cRes:Object) : void
      {
         var secondLeft:int = int(cRes.data);
         this.myClaimReward.setClaimRemainingTime(secondLeft);
      }
      
      private function bindMarketplaceMaintainState(cRes:Object) : void
      {
         this.updateClanMarketBtnState();
      }
      
      private function clickChangeClanName() : void
      {
         broadcast(BCEvent.TRY_TO_CHANGE_CLAN_NAME);
      }
      
      private function leaveClan() : void
      {
         broadcast(BCEvent.LEAVE_CLAN);
      }
      
      private function clickEditAnnouncement() : void
      {
         this.switchEditAnnouncementMode(this.mEditMode == EDIT_MODE ? SHOW_MODE : EDIT_MODE);
      }
      
      private function clickInfoButton() : void
      {
         broadcast(BCEvent.EVT_OPEN_CLAN_RULE_PANEL);
      }
      
      private function clickClaimButton() : void
      {
         broadcast(BCEvent.EVT_CLAIM_CLAN_DAILY_REWARD);
      }
      
      private function clickEditClanTags() : void
      {
         broadcast(BCEvent.EVT_OPEN_CLAN_TAGS_EDIT_PANEL,this.mData);
      }
      
      private function navigateToClanMarketplace() : void
      {
         broadcast(BCEvent.EVT_NAVIGATE_TO_CLAN_MARKETPLACE);
      }
      
      private function startClanChat() : void
      {
         broadcast(BCEvent.EVT_OPEN_CHAT_WINDOW,{"firstLevelIndex":ChatView.CLAN_CHANNEL_INDEX});
      }
      
      private function switchEditAnnouncementMode(mode:uint) : void
      {
         if(this.mEditMode == mode)
         {
            return;
         }
         this.mEditMode = mode;
         if(this.mEditMode == EDIT_MODE)
         {
            this.myEditBtn.visible = true;
            this.myEditBtn.label = DictClan.SAVE_ANNOUNCEMENT;
            this.myClanAnnouncementInput.text = this.mData.clanAnnouncement;
         }
         else
         {
            this.myEditBtn.visible = false;
            this.myEditBtn.label = DictClan.EDIT_ANNOUNCEMENT;
            if(this.mData.clanAnnouncement != this.myClanAnnouncementInput.text)
            {
               broadcast(BCEvent.EVT_CHANGE_CLAN_ANNOUNCEMENT,{"text":this.myClanAnnouncementInput.text});
            }
         }
         this.myClanAnnouncementInput.visible = this.mEditMode == EDIT_MODE;
         this.myClanAnnouncement.visible = this.mEditMode == SHOW_MODE;
      }
      
      private function setClanLevel(level:int) : void
      {
         this.myClanIcon.gotoAndStop(level);
         this.myClanLevelName.text = ClanGlobalConfig.CLAN_LEVEL_NAMES[level - 1];
      }
      
      private function setCTP(level:int, value:int) : void
      {
         var currentLevelCTPThreshold:int = 0;
         if(level == ClanGlobalConfig.CLAN_LEVEL_DIAMOND)
         {
            this.myCTPTotal.setValue(value,value,true);
            this.mCTPToLevelUp = -1;
         }
         else
         {
            currentLevelCTPThreshold = int(this.mGlobalConfig.levelUpgrade[level - 1 < 0 ? 0 : level - 1]);
            this.myCTPTotal.setValue(value - currentLevelCTPThreshold,this.mGlobalConfig.levelUpgrade[level] - currentLevelCTPThreshold);
            this.myCTPTotal.setGaugeRular(value,this.mGlobalConfig.levelUpgrade[level]);
            this.mCTPToLevelUp = this.mGlobalConfig.levelUpgrade[level] - value;
         }
      }
      
      private function setCTPEarnedToday(level:int, value:int) : void
      {
         var dailyCap:int = int(this.mGlobalConfig.dailyCap[level - 1]);
         this.myCTPEarnedToday.setValue(value,dailyCap);
      }
      
      private function setClaimButton(level:int) : void
      {
         var reward:int = int(this.mGlobalConfig.dailyGPReward[level - 1]);
         this.myClaimReward.setReward(ClaimBuffButton.GP_BUFF,LocalizeUtil.param(DictClan.CLICK_TO_CLAIM_GP,[reward]));
      }
      
      private function clanIconToolTipTextSetter(tf:TextField) : void
      {
         if(this.mData == null || this.mGlobalConfig == null)
         {
            return;
         }
         var index:int = this.mData.level - 1 < 0 ? 0 : int(this.mData.level - 1);
         var xpBuffPerLevel:String = String(Math.round(this.mGlobalConfig.xpBuffPerLevel[index] * 100)) + "%";
         var xpMatePlayBuffPerLevel:String = String(Math.round(this.mGlobalConfig.xpMatePlayBuffPerLevel[index] * 100)) + "%";
         var maintenance:String = String(this.mGlobalConfig.maintenance[index]);
         LocalizeUtil.paramColorized(tf.myTextClip,DictClan.CLAN_LEVEL_TOOL_TIP,[xpBuffPerLevel,xpMatePlayBuffPerLevel,maintenance],[GlobalGuide.CODO_COLOR_HIGHLIGHT_ORANGE,GlobalGuide.CODO_YELLOW,GlobalGuide.WHITE]);
      }
      
      private function ctpTotalTipTextSetter(tf:TextField) : void
      {
         if(this.mCTPToLevelUp == -1)
         {
            tf.myTextClip.text = DictClan.CLAN_ALREADY_TOP_LEVEL;
         }
         else
         {
            LocalizeUtil.paramColorized(tf.myTextClip,DictClan.NEED_XP_TO_UPDATE,[this.mCTPToLevelUp],[GlobalGuide.CODO_YELLOW]);
         }
      }
      
      private function clanMarketBtnDisableToolTip(tf:TextField) : void
      {
         if(Boolean(getDP(DataID.IS_IN_ROOM)))
         {
            tf.text = DictClan.MARKET_CLOSE_IN_ROOM;
         }
         else if(Boolean(getDP(DataID.IS_MARKETPLACE_MAINTAIN)))
         {
            tf.text = Dict.DW_MARKETPLACE_MAINTAIN;
         }
      }
   }
}

