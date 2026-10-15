package codo.views
{
   import codo.base.PopupView;
   import codo.common.CFunctionCommonContainer;
   import codo.component.Button;
   import codo.component.TextField;
   import codo.component.marketplaceitem.MarketplaceItem;
   import codo.constants.BCEvent;
   import codo.constants.Common;
   import codo.constants.DataID;
   import codo.constants.table.UINotifications;
   import codo.localization.Dict;
   import codo.localization.DictMarket;
   import codo.localization.DictRoom;
   import codo.objects.ProductObj;
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   import codo.utils.LocalizeUtil;
   import codo.utils.ScaleformUtil;
   
   public class TokenBuyPopupView extends PopupView
   {
      
      private static const PADDING:uint = 20;
      
      public var myDescription:TextField;
      
      public var myTokenItem:MarketplaceItem;
      
      public var myRepairTokenItem:MarketplaceItem;
      
      public function TokenBuyPopupView()
      {
         super();
         var GET_INFO:Function = CFunctionCommonContainer.GetItemInfo;
         var tokenObj:ProductObj = GET_INFO(CFunctionCommonContainer.GetReviveTokenID());
         myPopup.configConfirmButton(DictRoom.JOIN,this.onPlayClickHandle,true);
         myPopup.configCancelButton(DictMarket.CANCEL_BUY,this.onCancelClickHandle);
         this.myTokenItem.setCardStyle(2,true);
         this.myTokenItem.withDiscountTag = false;
         this.myTokenItem.setData(tokenObj);
         this.myRepairTokenItem.setCardStyle(2,true);
         this.myRepairTokenItem.withDiscountTag = false;
         this.myTokenItem.isStandaloneDisplay = this.myRepairTokenItem.isStandaloneDisplay = true;
         myPopup.width = 826;
         this.myRepairTokenItem.visible = false;
      }
      
      override protected function showView() : void
      {
         var POPUP_BORDER_OFFSET:int = 0;
         var joinBtn:Button = null;
         var cancelBtn:Button = null;
         super.showView();
         POPUP_BORDER_OFFSET = 11;
         var titleStr:String = Dict.TOKEN_POPUP_TITLE;
         var msgStr:String = Dict.TOKEN_POPUP_SURVIVAL_MESSAGE;
         var newbieToken:Boolean = getDP(DataID.IS_NOTIFIED,[UINotifications.ONBOARD_NEWBIE_TOKEN]) as Boolean;
         var descStyle:TextStyle = GlobalGuide.styleTextDescription;
         var revivalToken:int = CFunctionCommonContainer.GetCyborgTokenCount();
         bind(DataID.DATA_RECEIVE,this.bind_dataReceived);
         bind(DataID.MARKETPLACE_MAINTAIN_STATE,this.bind_mktMaintainStateChanged);
         listen(BCEvent.EVT_REFRESH_UI_AFTER_INVENTORY_CHANGE,this.updateTokens);
         this.checkMktData();
         this.updateTokens();
         if(!newbieToken && revivalToken > 0)
         {
            msgStr = LocalizeUtil.param(Dict.NEWBIE_TOKEN_REMINDER,[revivalToken]);
            broadcast(BCEvent.EVT_UI_NOTIFICATION,{
               "notification":UINotifications.ONBOARD_NEWBIE_TOKEN,
               "clean":false
            });
         }
         headerTitle = LocalizeUtil.localize(titleStr);
         this.myDescription.textStyle = descStyle;
         this.myDescription.text = msgStr;
         var contentWidth:int = this.myRepairTokenItem.x + this.myRepairTokenItem.width + PADDING * 2;
         var offset:uint = myPopup.popupWidth - this.myDescription.x;
         this.myDescription.width = offset - PADDING;
         this.myRepairTokenItem.y = this.myTokenItem.y = this.myDescription.y + this.myDescription.textHeight + PADDING;
         myPopup.height = this.myTokenItem.y + this.myTokenItem.height;
         joinBtn = myPopup.getButtonByIndex(0);
         cancelBtn = myPopup.getButtonByIndex(1);
         joinBtn.x = contentWidth - (joinBtn.width + POPUP_BORDER_OFFSET);
         cancelBtn.x = joinBtn.x - (cancelBtn.width + 10);
         if(!ScaleformUtil.isScaleform)
         {
            this.myTokenItem.visible = true;
         }
         if(!this.myRepairTokenItem.visible)
         {
            this.myTokenItem.x = (myPopup.width - this.myTokenItem.width) * 0.5 - POPUP_BORDER_OFFSET / 2;
         }
      }
      
      override protected function hideView() : void
      {
         super.hideView();
         unbind(DataID.DATA_RECEIVE,this.bind_dataReceived);
         unbind(DataID.MARKETPLACE_MAINTAIN_STATE,this.bind_mktMaintainStateChanged);
         unlisten(BCEvent.EVT_REFRESH_UI_AFTER_INVENTORY_CHANGE,this.updateTokens);
      }
      
      private function bind_dataReceived(cRes:Object) : void
      {
         if(cRes.result == 1 && (cRes.data == Common.MARKET_RECEIVED || cRes.data == Common.PLAYERDATA_RECEIVED))
         {
            this.checkMktData();
         }
      }
      
      private function bind_mktMaintainStateChanged(cRes:Object) : void
      {
         this.checkMktData();
      }
      
      private function checkMktData() : void
      {
         var isAvailable:Boolean = getDP(DataID.IS_DATA_AVAILABLE);
         var enabledAlpha:Number = isAvailable ? 1 : 0.5;
         this.myTokenItem.enabled = isAvailable;
         this.myTokenItem.alpha = this.myRepairTokenItem.alpha = enabledAlpha;
      }
      
      private function updateTokens() : void
      {
         var tokenAmount:uint = CFunctionCommonContainer.GetCyborgTokenCount();
         this.myTokenItem.myMarketplaceItemCard.myItemCategoryTF.text = LocalizeUtil.param(DictMarket.MARKET_ITEM_QUANTITY,[tokenAmount]);
      }
      
      public function onCancelClickHandle() : void
      {
         broadcast(BCEvent.EVT_QUIT_TOKEN_BUY_POPUP);
      }
      
      public function onPlayClickHandle() : void
      {
         broadcast(BCEvent.EVT_TOKEN_BUY_POPUP_START_GAME);
      }
   }
}

