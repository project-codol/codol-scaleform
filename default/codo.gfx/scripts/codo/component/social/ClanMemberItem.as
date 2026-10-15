package codo.component.social
{
   import codo.component.Button;
   import codo.component.PlayerName;
   import codo.component.TextField;
   import codo.constants.ClanMemberPosition;
   import codo.constants.Common;
   import codo.localization.Dict;
   import codo.localization.DictClan;
   import codo.objects.PlayerNameSettings;
   import codo.style.ClanGuide;
   import codo.style.GlobalGuide;
   import codo.utils.LocalizeUtil;
   import codo.utils.WarGodUtility;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import fsg.util.FsgUtil;
   
   public class ClanMemberItem extends PageListBaseRender
   {
      
      public static const DETAIL_BUTTON_INDEX:int = 0;
      
      public static const OPTION_BUTTON_INDEX:int = 1;
      
      public static const ROLL_OVER_INDEX:int = 0;
      
      public static const ROLL_OUT_INDEX:int = 1;
      
      private static const CLAN_MEMBER_POSITION:Array = [DictClan.CLAN_POS_ORDINARY,DictClan.CLAN_POS_ADMIN,DictClan.CLAN_POS_OWNER];
      
      public var myName:PlayerName;
      
      public var myRankIcon:MemberRankIcon;
      
      public var myRankName:TextField;
      
      public var myContribution:TextField;
      
      public var myTitle:TextField;
      
      public var myOnlineState:TextField;
      
      public var myWargodTier:MovieClip;
      
      public var myDetailBtn:Button;
      
      public var myOptionBtn:Button;
      
      public function ClanMemberItem()
      {
         super();
         this.initStage();
      }
      
      private function initStage() : void
      {
         isInteractiveEnabled = true;
         var nameSetting:PlayerNameSettings = new PlayerNameSettings();
         nameSetting.mode = PlayerNameSettings.MODE_DIRECT;
         nameSetting.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         nameSetting.textWidth = 270;
         nameSetting.textHeight = 22;
         nameSetting.textColor = GlobalGuide.WHITE;
         nameSetting.fitSizeMethod = PlayerNameSettings.FIT_SIZE_METHOD_SMALL_FONT;
         this.myName.settings = nameSetting;
         this.myContribution.textStyle = ClanGuide.styleItemRenderText;
         this.myContribution.width = 60;
         this.myTitle.textStyle = ClanGuide.styleItemRenderText;
         this.myTitle.width = 75;
         this.myRankName.textStyle = ClanGuide.styleItemRenderText;
         this.myRankName.width = 75;
         this.myOnlineState.textStyle = ClanGuide.styleItemRenderText;
         this.myOnlineState.width = 110;
         this.myDetailBtn.width = ClanGuide.ITEM_BTN_WIDTH;
         this.myDetailBtn.height = ClanGuide.ITEM_BTN_HEIGHT;
         this.myOptionBtn.width = ClanGuide.ITEM_BTN_WIDTH;
         this.myOptionBtn.height = ClanGuide.ITEM_BTN_HEIGHT;
         this.myDetailBtn.label = DictClan.BUTTON_DETAIL_LABEL;
         this.myOptionBtn.label = DictClan.BUTTON_OPTION_LABEL;
         this.myOptionBtn.x = myBg.width - 2 - this.myOptionBtn.width;
         this.myOptionBtn.y = ClanGuide.ITEM_BTN_Y_PADDING;
         this.myDetailBtn.x = this.myOptionBtn.x - 2 - this.myDetailBtn.width;
         this.myDetailBtn.y = ClanGuide.ITEM_BTN_Y_PADDING;
         this.myDetailBtn.registerClickEvent(this.onOptionBtnClicked,this.myDetailBtn);
         this.myOptionBtn.registerClickEvent(this.onOptionBtnClicked,this.myOptionBtn);
         this.myOnlineState.fontColor = this.myRankName.fontColor = this.myTitle.fontColor = this.myContribution.fontColor = GlobalGuide.GRAY_80;
         this.myName.myTextField.fontColor = GlobalGuide.GRAY_80;
      }
      
      override public function setData(data:*) : void
      {
         super.setData(data);
         if(Boolean(data.isMe))
         {
            this.myOptionBtn.visible = false;
            this.myDetailBtn.x = myBg.width - 2 - this.myDetailBtn.width;
            this.myName.myTextField.fontColor = GlobalGuide.CODO_YELLOW;
         }
         else
         {
            this.myOptionBtn.visible = true;
            this.myOptionBtn.x = myBg.width - 2 - this.myOptionBtn.width;
            this.myDetailBtn.x = this.myOptionBtn.x - 2 - this.myDetailBtn.width;
            this.myName.myTextField.fontColor = GlobalGuide.GRAY_80;
         }
         var dataReady:Boolean = true;
         if(data.level == 0)
         {
            dataReady = false;
         }
         if(dataReady)
         {
            this.myRankIcon.visible = true;
            this.myRankIcon.setImage(FsgUtil.getRankIcon(data.level - 1,data.prestige));
            this.myRankName.text = formatRank(data.prestige,data.level - 1);
            this.myRankName.x = 432;
         }
         else
         {
            this.myRankIcon.visible = false;
            this.myRankName.text = DictClan.PENDING;
            this.myRankName.x = 397;
         }
         this.myName.setData(data.name,data.id);
         this.myTitle.text = LocalizeUtil.localize(CLAN_MEMBER_POSITION[data.clanPos]);
         if(data.clanPos == ClanMemberPosition.OWNER)
         {
            this.myTitle.fontColor = GlobalGuide.CODO_COLOR_HIGHLIGHT_ORANGE;
         }
         else if(data.clanPos == ClanMemberPosition.ADMIN)
         {
            this.myTitle.fontColor = GlobalGuide.CODO_YELLOW;
         }
         else
         {
            this.myTitle.fontColor = GlobalGuide.GRAY_80;
         }
         this.myContribution.text = data.selectedCCPValue;
         if(data.friendStatus == Common.CODO_BASIC_PRESENCE_GAME)
         {
            this.myOnlineState.text = "@SF_UI_USER_STATUS_INGAME";
            this.myOnlineState.fontColor = ClanGuide.INGAME_COLOR;
         }
         else if(data.friendStatus == Common.CODO_BASIC_PRESENCE_MENU)
         {
            this.myOnlineState.text = Dict.USER_ONLINE;
            this.myOnlineState.fontColor = ClanGuide.ONLINE_COLOR;
         }
         else
         {
            this.myOnlineState.text = Dict.INVITE_OFFLINE;
            this.myOnlineState.fontColor = ClanGuide.OFFLINE_COLOR;
         }
         WarGodUtility.setWargodTierIcon(this,data);
      }
      
      private function onOptionBtnClicked(btn:Button) : void
      {
         var btnIndex:int = 0;
         if(btn == this.myDetailBtn)
         {
            btnIndex = DETAIL_BUTTON_INDEX;
         }
         else if(btn == this.myOptionBtn)
         {
            btnIndex = OPTION_BUTTON_INDEX;
         }
         if(mHandler != null)
         {
            mHandler(this,btnIndex);
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
      }
      
      override protected function onMouseOut() : void
      {
         super.onMouseOut();
         if(mInteractiveHandler != null)
         {
            mInteractiveHandler(mData,ROLL_OUT_INDEX);
         }
      }
   }
}

