package codo.component.social
{
   import codo.component.Button;
   import codo.component.PlayerName;
   import codo.component.TextField;
   import codo.localization.DictClan;
   import codo.localization.DictSystem;
   import codo.objects.PlayerNameSettings;
   import codo.style.ClanGuide;
   import codo.style.GlobalGuide;
   
   public class ClanApplicationItem extends PageListBaseRender
   {
      
      public static const DETAIL_BUTTON_INDEX:int = 0;
      
      public static const REJECT_BUTTON_INDEX:int = 1;
      
      public static const APPROVE_BUTTON_INDEX:int = 2;
      
      public var myTimeStamp:TextField;
      
      public var myApplicant:PlayerName;
      
      public var myRank:TextField;
      
      public var myKDA:TextField;
      
      public var myTimePlayed:TextField;
      
      public var myDetailBtn:Button;
      
      public var myApproveBtn:Button;
      
      public var myRejectBtn:Button;
      
      public function ClanApplicationItem()
      {
         super();
         this.initStage();
      }
      
      private function initStage() : void
      {
         isInteractiveEnabled = true;
         this.myTimeStamp.textStyle = ClanGuide.styleItemRenderText;
         this.myTimeStamp.width = 145;
         var applicantSetting:PlayerNameSettings = new PlayerNameSettings();
         applicantSetting.mode = PlayerNameSettings.MODE_DIRECT;
         applicantSetting.textWidth = 180;
         applicantSetting.textHeight = 22;
         applicantSetting.textColor = GlobalGuide.GRAY_80;
         applicantSetting.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         applicantSetting.fitSizeMethod = PlayerNameSettings.FIT_SIZE_METHOD_SMALL_FONT;
         this.myApplicant.settings = applicantSetting;
         this.myRank.textStyle = ClanGuide.styleItemRenderText;
         this.myRank.width = 90;
         this.myKDA.textStyle = ClanGuide.styleItemRenderText;
         this.myKDA.width = 80;
         this.myTimePlayed.textStyle = ClanGuide.styleItemRenderText;
         this.myTimePlayed.width = 80;
         this.myApproveBtn.width = ClanGuide.ITEM_BTN_WIDTH;
         this.myApproveBtn.height = ClanGuide.ITEM_BTN_HEIGHT;
         this.myApproveBtn.label = DictSystem.ACCEPT;
         this.myRejectBtn.width = ClanGuide.ITEM_BTN_WIDTH;
         this.myRejectBtn.height = ClanGuide.ITEM_BTN_HEIGHT;
         this.myRejectBtn.label = DictSystem.REFUSE;
         this.myDetailBtn.width = ClanGuide.ITEM_BTN_WIDTH;
         this.myDetailBtn.height = ClanGuide.ITEM_BTN_HEIGHT;
         this.myDetailBtn.label = DictClan.BUTTON_DETAIL_LABEL;
         this.myApproveBtn.x = myBg.width - 10 - this.myApproveBtn.width;
         this.myApproveBtn.y = ClanGuide.ITEM_BTN_Y_PADDING;
         this.myRejectBtn.x = this.myApproveBtn.x - GlobalGuide.COMPONENT_PADDING - this.myRejectBtn.width;
         this.myRejectBtn.y = ClanGuide.ITEM_BTN_Y_PADDING;
         this.myDetailBtn.x = this.myRejectBtn.x - GlobalGuide.COMPONENT_PADDING - this.myDetailBtn.width;
         this.myDetailBtn.y = ClanGuide.ITEM_BTN_Y_PADDING;
         this.myDetailBtn.registerClickEvent(this.onOptionBtnClicked,this.myDetailBtn);
         this.myRejectBtn.registerClickEvent(this.onOptionBtnClicked,this.myRejectBtn);
         this.myApproveBtn.registerClickEvent(this.onOptionBtnClicked,this.myApproveBtn);
         this.myTimeStamp.fontColor = this.myRank.fontColor = this.myKDA.fontColor = this.myTimePlayed.fontColor = GlobalGuide.GRAY_80;
         this.myApplicant.myTextField.fontColor = GlobalGuide.GRAY_80;
      }
      
      override public function setData(data:*) : void
      {
         super.setData(data);
         this.myTimeStamp.text = data.formattedTime;
         this.myApplicant.setData(data.senderName,data.senderID);
         this.myRank.text = formatRank(data.introduction.prestige,data.introduction.rank);
         this.myKDA.text = calculateKDA(data.introduction.kills,data.introduction.deaths,data.introduction.assists);
         this.myTimePlayed.text = timePlayedHour(data.introduction.timePlayedOverall);
      }
      
      private function onOptionBtnClicked(btn:Button) : void
      {
         var btnIndex:int = 0;
         if(btn == this.myDetailBtn)
         {
            btnIndex = DETAIL_BUTTON_INDEX;
         }
         else if(btn == this.myApproveBtn)
         {
            btnIndex = APPROVE_BUTTON_INDEX;
         }
         else if(btn == this.myRejectBtn)
         {
            btnIndex = REJECT_BUTTON_INDEX;
         }
         if(mHandler != null)
         {
            mHandler(mData,btnIndex);
         }
      }
      
      override protected function onMouseOver() : void
      {
         super.onMouseOver();
         this.myTimeStamp.fontColor = this.myRank.fontColor = this.myKDA.fontColor = this.myTimePlayed.fontColor = GlobalGuide.WHITE;
         this.myApplicant.myTextField.fontColor = GlobalGuide.WHITE;
      }
      
      override protected function onMouseOut() : void
      {
         super.onMouseOut();
         this.myTimeStamp.fontColor = this.myRank.fontColor = this.myKDA.fontColor = this.myTimePlayed.fontColor = GlobalGuide.GRAY_80;
         this.myApplicant.myTextField.fontColor = GlobalGuide.GRAY_80;
      }
   }
}

