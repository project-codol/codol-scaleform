package codo.component.social
{
   import codo.component.Button;
   import codo.component.PlayerName;
   import codo.component.TextField;
   import codo.constants.ClanRecruitState;
   import codo.localization.DictCareer;
   import codo.localization.DictClan;
   import codo.objects.PlayerNameSettings;
   import codo.style.ClanGuide;
   import codo.style.GlobalGuide;
   import codo.utils.LocalizeUtil;
   import codo.utils.StringUtil;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.text.TextFieldAutoSize;
   
   public class ClanSearchResultItem extends PageListBaseRender
   {
      
      public static const JOIN_BUTTON_INDEX:int = 0;
      
      public static const ROLL_OVER_INDEX:int = 0;
      
      public static const ROLL_OUT_INDEX:int = 1;
      
      public static const JOIN_BTN_STATE_NORMAL:int = 0;
      
      public static const JOIN_BTN_STATE_SENT:int = 1;
      
      public var myClanLevelIcon:MovieClip;
      
      public var myClanName:TextField;
      
      public var myLeaderName:PlayerName;
      
      public var myCTP:TextField;
      
      public var myMemberCount:TextField;
      
      public var myRecruiteState:TextField;
      
      public var myLevelRestrict:TextField;
      
      public var myClanTags:ClanTagsItem;
      
      public var myJoinBtn:Button;
      
      private var mCanJoin:Boolean = true;
      
      public function ClanSearchResultItem()
      {
         super();
         this.initStage();
      }
      
      protected function initStage() : void
      {
         isInteractiveEnabled = true;
         this.myClanName.textStyle = ClanGuide.styleItemRenderText;
         this.myClanName.width = 230;
         this.myClanName.wordWrap = false;
         this.myClanName.multiline = false;
         this.myClanName.autoSize = TextFieldAutoSize.NONE;
         var leaderSetting:PlayerNameSettings = new PlayerNameSettings();
         leaderSetting.mode = PlayerNameSettings.MODE_DIRECT;
         leaderSetting.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         leaderSetting.textWidth = 200;
         leaderSetting.textHeight = 22;
         leaderSetting.textColor = GlobalGuide.GRAY_80;
         leaderSetting.fitSizeMethod = PlayerNameSettings.FIT_SIZE_METHOD_SMALL_FONT;
         this.myLeaderName.settings = leaderSetting;
         this.myMemberCount.textStyle = ClanGuide.styleItemRenderText;
         this.myMemberCount.width = 100;
         this.myCTP.textStyle = ClanGuide.styleItemRenderText;
         this.myCTP.width = 100;
         this.myRecruiteState.textStyle = ClanGuide.styleItemRenderText;
         this.myRecruiteState.width = 100;
         this.myLevelRestrict.textStyle = ClanGuide.styleItemRenderText;
         this.myLevelRestrict.width = 100;
         this.myJoinBtn.width = ClanGuide.ITEM_BTN_WIDTH;
         this.myJoinBtn.height = ClanGuide.ITEM_BTN_HEIGHT;
         this.myJoinBtn.label = DictClan.CLAN_APPLY_TO_JOIN;
         this.myJoinBtn.x = myBg.width - 5 - this.myJoinBtn.width;
         this.myJoinBtn.y = ClanGuide.ITEM_BTN_Y_PADDING;
         this.myJoinBtn.registerClickEvent(this.onOptionBtnClicked,this.myJoinBtn);
         this.myLevelRestrict.fontColor = this.myRecruiteState.fontColor = this.myMemberCount.fontColor = this.myClanName.fontColor = GlobalGuide.GRAY_80;
         this.myLeaderName.myTextField.fontColor = GlobalGuide.GRAY_80;
      }
      
      override public function setData(data:*) : void
      {
         super.setData(data);
         this.myClanLevelIcon.gotoAndStop(data.level);
         this.myClanName.text = data.name;
         StringUtil.fitTextField(this.myClanName.myTextClip);
         this.myLeaderName.setData(data.ownerName,data.ownerID);
         this.myMemberCount.text = String(data.numMember) + "/" + String(data.maxMember);
         this.myRecruiteState.text = this.getRecruitLoc(data.recruitState);
         this.myLevelRestrict.text = this.getLevelRestrict(data.levelCondition);
         this.mCanJoin = mData.numMember < 100 && mData.recruitState != ClanRecruitState.RECRUIT_CLOSE;
         this.myCTP.text = String(mData.ctp);
         this.myClanTags.setData(mData.tags);
      }
      
      public function switchShowJoinBtn(show:Boolean) : void
      {
         this.myJoinBtn.visible = show && this.mCanJoin;
      }
      
      private function onOptionBtnClicked(btn:Button) : void
      {
         var btnIndex:int = 0;
         if(btn == this.myJoinBtn)
         {
            btnIndex == JOIN_BUTTON_INDEX;
            this.setJoinBtnState(JOIN_BTN_STATE_SENT);
         }
         if(mHandler != null)
         {
            mHandler(mData,btnIndex);
         }
      }
      
      override protected function onMouseOver() : void
      {
         var pt:Point = null;
         super.onMouseOver();
         if(mIndex >= 5)
         {
            mData.isUpperSection = false;
            pt = new Point(myBg.x,0);
         }
         else
         {
            mData.isUpperSection = true;
            pt = new Point(myBg.x,myBg.height);
         }
         var gPt:Point = localToGlobal(pt);
         mData.globalX = gPt.x;
         mData.globalY = gPt.y;
         if(mInteractiveHandler != null)
         {
            mInteractiveHandler(mData,ROLL_OVER_INDEX);
         }
         this.myLevelRestrict.fontColor = this.myRecruiteState.fontColor = this.myMemberCount.fontColor = this.myClanName.fontColor = GlobalGuide.WHITE;
         this.myLeaderName.myTextField.fontColor = GlobalGuide.WHITE;
      }
      
      override protected function onMouseOut() : void
      {
         super.onMouseOut();
         if(mInteractiveHandler != null)
         {
            mInteractiveHandler(mData,ROLL_OUT_INDEX);
         }
         this.myLevelRestrict.fontColor = this.myRecruiteState.fontColor = this.myMemberCount.fontColor = this.myClanName.fontColor = GlobalGuide.GRAY_80;
         this.myLeaderName.myTextField.fontColor = GlobalGuide.GRAY_80;
      }
      
      public function getRecruitLoc(state:int) : String
      {
         if(state == ClanRecruitState.RECRUIT_APPLY)
         {
            return DictClan.RECRUIT_STATE_APPLY;
         }
         if(state == ClanRecruitState.RECRUIT_OPEN)
         {
            return DictClan.RECRUIT_STATE_OPEN;
         }
         if(state == ClanRecruitState.RECRUIT_CLOSE)
         {
            return DictClan.RECRUIT_STATE_CLOSE;
         }
         return "";
      }
      
      public function getLevelRestrict(levelWithPrestige:int) : String
      {
         var prestige:int = Math.floor(levelWithPrestige / 100);
         var level:int = levelWithPrestige - prestige * 100;
         if(level == 0)
         {
            level = 1;
         }
         if(prestige > 0)
         {
            return LocalizeUtil.replace(LocalizeUtil.localize(DictCareer.CAREER_X_PRESTIGE),[prestige,level]);
         }
         return LocalizeUtil.replace(LocalizeUtil.localize(DictCareer.CAREER_X_LEVEL),[level]);
      }
      
      public function setJoinBtnState(state:int) : void
      {
         if(state == JOIN_BTN_STATE_SENT)
         {
            this.myJoinBtn.label = DictClan.CLAN_APPLICATION_EVER_SENT;
            this.myJoinBtn.isInteractiveEnabled = false;
         }
         else if(state == JOIN_BTN_STATE_NORMAL)
         {
            this.myJoinBtn.label = DictClan.CLAN_APPLY_TO_JOIN;
            this.myJoinBtn.isInteractiveEnabled = true;
         }
      }
   }
}

