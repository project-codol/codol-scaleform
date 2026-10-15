package codo.views
{
   import codo.base.PopupView;
   import codo.common.CFunctionContainer;
   import codo.component.CallToActionButton;
   import codo.component.TextField;
   import codo.component.core.UIInteractiveComponent;
   import codo.constants.BCEvent;
   import codo.constants.MarketMenuData;
   import codo.event.ParaEvent;
   import codo.objects.PlayListObj;
   import codo.objects.RecommendationObject;
   import codo.objects.SystemMsgObj;
   import codo.objects.WebAdObj;
   import codo.services.MatchService;
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   
   public class RecommendationPopup extends PopupView
   {
      
      private static const POPUP_WIDTH_PADDING:Number = 30;
      
      private static const POPUP_HEIGHT_PADDING:Number = 60;
      
      private static const BUTTON_TEXT_PADDING:Number = 24;
      
      private static const SUBTITLE_HEIGHT_PADDING:Number = 4;
      
      public var myActionButton:CallToActionButton;
      
      public var myTitle:TextField;
      
      public var mySubTitle:TextField;
      
      public var myWebImage:UIInteractiveComponent;
      
      private var m_msgObj:SystemMsgObj;
      
      private var m_subTitleToTitleDty:Number;
      
      private var m_subTitleBottomY:Number;
      
      public function RecommendationPopup()
      {
         var popupHeight:Number = NaN;
         super();
         listen(BCEvent.EVT_RECOMMENDATION_POPUP_MSG,this.onSetRecommendationMsg);
         var popupWidth:Number = POPUP_WIDTH_PADDING + this.myWebImage.width;
         popupHeight = POPUP_HEIGHT_PADDING + this.myWebImage.height;
         myPopup.width = popupWidth;
         myPopup.height = popupHeight;
         myPopup.setStyleNoFrame();
         myPopup.myHeaderbar.visible = false;
         this.myTitle.width = popupWidth;
         var style:TextStyle = new TextStyle();
         style.font = GlobalGuide.FONT_FACE_BOLD;
         style.fontSize = GlobalGuide.FONT_SIZE_LARGE;
         style.fontColor = GlobalGuide.WHITE;
         this.myTitle.textStyle = style;
         this.mySubTitle.width = popupWidth;
         this.mySubTitle.fontColor = 3062006;
         this.m_subTitleBottomY = this.mySubTitle.y + this.mySubTitle.textHeight;
         this.m_subTitleToTitleDty = this.mySubTitle.y - this.myTitle.y;
         this.myActionButton.y = popupHeight;
         this.myActionButton.setClickCallback(this.onAcceptButtonClicked);
      }
      
      private function onSetRecommendationMsg(cEvt:ParaEvent) : void
      {
         var webAd:WebAdObj = null;
         var buttonWidth:Number = NaN;
         this.m_msgObj = cEvt.myPara as SystemMsgObj;
         if(Boolean(this.m_msgObj) && Boolean(this.m_msgObj.recommendationData))
         {
            this.myTitle.text = this.m_msgObj.recommendationData.title;
            this.mySubTitle.text = this.m_msgObj.recommendationData.subtitle;
            this.myActionButton.label = this.m_msgObj.recommendationData.buttontext;
            myPopup.myCloseButton.visible = this.m_msgObj.recommendationData.type != RecommendationObject.REWARD;
            if(this.myActionButton.label != "" && this.m_msgObj.recommendationData.imagejump != "")
            {
               if(this.m_msgObj.recommendationData.buttondata == "")
               {
                  this.m_msgObj.recommendationData.buttondata = this.m_msgObj.recommendationData.imagejump;
               }
               this.m_msgObj.recommendationData.imagejump = "";
            }
            webAd = new WebAdObj("remote_datamore_" + this.m_msgObj.recommendationData.taskid,this.onWebImageClicked);
            this.myWebImage.setData(webAd);
         }
         this.mySubTitle.visible = this.mySubTitle.text != "";
         if(this.mySubTitle.visible)
         {
            this.mySubTitle.height = this.mySubTitle.textHeight + SUBTITLE_HEIGHT_PADDING;
            this.mySubTitle.y = this.m_subTitleBottomY - this.mySubTitle.textHeight;
            this.myTitle.y = this.mySubTitle.y - this.m_subTitleToTitleDty;
         }
         else
         {
            this.myTitle.y = this.m_subTitleBottomY - this.myTitle.textHeight;
         }
         this.myActionButton.visible = this.myActionButton.label != "";
         if(this.myActionButton.visible)
         {
            buttonWidth = this.myActionButton.myLabel.textWidth + BUTTON_TEXT_PADDING * 2;
            this.myActionButton.width = buttonWidth;
            this.myActionButton.x = myPopup.width - buttonWidth;
         }
      }
      
      private function onWebImageClicked() : void
      {
         if(this.m_msgObj.recommendationData.imagejump != "")
         {
            this.openWebPage(this.m_msgObj.recommendationData.imagejump);
            this.closePopupView();
         }
      }
      
      private function onAcceptButtonClicked() : void
      {
         var playlistObj:PlayListObj = null;
         var playlistNum:int = 0;
         var dataObj:RecommendationObject = this.m_msgObj.recommendationData;
         switch(dataObj.type)
         {
            case RecommendationObject.WELFARE:
               this.openWebPage(dataObj.buttondata);
               break;
            case RecommendationObject.REWARD:
               CFunctionContainer.AS_DatamoreClaimReward(this.m_msgObj.recommendationData.taskid);
               break;
            case RecommendationObject.GAMEMODE:
               playlistObj = new PlayListObj();
               playlistNum = CFunctionContainer.AS_GetPlayListNumForId(int(dataObj.buttondata));
               playlistObj = MatchService.getInstance().getPlayListObj(playlistNum);
               broadcast(playlistObj.getGotoMatchMainPageEvent(),{"playlist":playlistObj});
               break;
            case RecommendationObject.MARKET:
               broadcast(BCEvent.EVT_GOTO_MARKET,{
                  "tabIndex":MarketMenuData.TAB_FEATURED,
                  "subtabIndex":1
               });
               break;
            case RecommendationObject.SUPPLY_DROP:
               broadcast(BCEvent.EVT_GOTO_SUPPLY_DROP);
         }
         this.closePopupView();
      }
      
      private function openWebPage(url:String) : void
      {
         if(url == "")
         {
            return;
         }
         var welfareIndex:int = CFunctionContainer.AS_GetMOTDWelfarePageIndexByURL(url);
         if(welfareIndex < 0)
         {
            broadcast(BCEvent.EVT_DATAMORE_OPEN_WEB_PAGE,url);
         }
         else
         {
            broadcast(BCEvent.EVT_OPEN_MOTD_DASHBOARD,{
               "category":MOTDNotificationsPopup.CATEGORY_INDEX_WELFARE,
               "index":welfareIndex
            });
         }
      }
      
      override protected function closePopupView() : void
      {
         broadcast(BCEvent.EVT_DATAMORE_REPORT_POPUP,this.m_msgObj.recommendationData.taskid);
         this.m_msgObj.btn0Handle();
      }
   }
}

