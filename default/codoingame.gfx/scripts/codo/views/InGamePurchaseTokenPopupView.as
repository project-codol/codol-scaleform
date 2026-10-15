package codo.views
{
   import codo.base.PopupView;
   import codo.constants.BCEvent;
   import codo.constants.GameInfo;
   import codo.event.ParaEvent;
   import codo.localization.DictInGame;
   import codo.utils.InGameTokenUtil;
   import codo.utils.LocalizeUtil;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.text.TextField;
   import fsg.shared.PveTokenCounter;
   import fsg.util.FsgImageHolder;
   
   public class InGamePurchaseTokenPopupView extends PopupView
   {
      
      private static const STATE_CAN_USE:uint = 0;
      
      private static const STATE_BUY:uint = 1;
      
      private static const STATE_BUY_SUCCESS:uint = 2;
      
      private static const STATE_BUY_FAIL:uint = 3;
      
      protected static const LOCALIZE_KEY_BIND:Function = LocalizeUtil.getLocalizationWithKeyBinding;
      
      public var myTokenCounter:PveTokenCounter;
      
      public var myBuyTokenMessageTF:TextField;
      
      public var myTokensRemainingTF:TextField;
      
      public var myBuyTokenHeader:TextField;
      
      public var myBuyRampageTokenHeader:TextField;
      
      public var myWarningIcon:Sprite;
      
      public var myTokenIcon:Sprite;
      
      public var myTokenBG:Sprite;
      
      public var myAdvTokenBG:Sprite;
      
      public var myAdvWarningIcon:Sprite;
      
      public var myAdvTokenIcon:FsgImageHolder;
      
      public var myAdvTokensRemainingTF:TextField;
      
      public var myAdvBuyTokenMessageTF:TextField;
      
      public var myAdvTokenCounter:PveTokenCounter;
      
      private var mPositionSet:Boolean = false;
      
      public function InGamePurchaseTokenPopupView()
      {
         super();
         listen(BCEvent.EVT_TOKEN_UPDATE_DISPLAY,this.updateTokenDisplay);
         myPopup.width = 653;
         myPopup.height = 357;
         myPopup.myCloseButton.visible = false;
         this.myAdvTokenIcon.setImage("rampage_token_item_icon.tga");
         this.myBuyTokenHeader.text = LocalizeUtil.localize("@SF_UI_CYBORGS_REVIVE_TOKEN_TITLE");
         this.myBuyRampageTokenHeader.text = LocalizeUtil.localize("@MPUI_RAMPAGE_TOKEN");
      }
      
      private function updateTokenDisplay(evt:ParaEvent) : void
      {
         var success:Boolean = Boolean(evt.myPara.success);
         var isRampage:Boolean = Boolean(evt.myPara.isRampage);
         this.setTokenState(success ? STATE_BUY_SUCCESS : STATE_BUY_FAIL,isRampage);
      }
      
      override protected function showView() : void
      {
         super.showView();
         this.initToken(this.mPositionSet,false);
         this.initToken(this.mPositionSet,true);
         if(!this.mPositionSet)
         {
            this.mPositionSet = true;
         }
         this.setTokenLimitDisplay();
      }
      
      override protected function hideView() : void
      {
         super.hideView();
         this.setTokenState(STATE_CAN_USE,false);
         this.setTokenState(STATE_CAN_USE,true);
      }
      
      override protected function get transitionTargetPoint() : Point
      {
         return new Point((GameInfo.DEFAULT_WIDTH - myPopup.popupWidth) * 0.5,(GameInfo.DEFAULT_HEIGHT - myPopup.popupHeight) * 0.5 + 200);
      }
      
      private function setTokenLimitDisplay() : void
      {
         var limitText:String = LocalizeUtil.getLocalizationWithToken(DictInGame.TOKENS_SPENT_LIMIT,InGameTokenUtil.GetTokensCanUse(),InGameTokenUtil.GetTokenUseLimit());
         this.myTokensRemainingTF.htmlText = limitText;
         this.myAdvTokensRemainingTF.htmlText = limitText;
         myPopup.header.title = LocalizeUtil.replaceConversionString(LocalizeUtil.localize(DictInGame.BUY_TOKENS_CALL_TO_ACTION),[InGameTokenUtil.GetTokenUseLimit()]).toUpperCase();
         myPopup.header.myHeaderTF.x = myPopup.header.myBkg.x + myPopup.header.myBkg.width * 0.5 - myPopup.header.myHeaderTF.textWidth * 0.5;
      }
      
      private function initToken(contentInited:Boolean, isRampage:Boolean) : void
      {
         var tokenCount:uint = isRampage ? InGameTokenUtil.GetRampageTokenOwned() : InGameTokenUtil.GetTokenOwned();
         if(tokenCount == 0)
         {
            this.setTokenState(STATE_BUY,isRampage);
         }
         else if(!contentInited)
         {
            this.setTokenState(STATE_CAN_USE,isRampage);
         }
         this.setTokenOwnedDisplay(tokenCount,isRampage);
      }
      
      private function setTokenOwnedDisplay(count:uint, isRampage:Boolean) : void
      {
         var counter:PveTokenCounter = null;
         var icon:Sprite = null;
         var bg:Sprite = null;
         if(isRampage)
         {
            counter = this.myAdvTokenCounter;
            icon = this.myAdvTokenIcon;
            bg = this.myAdvTokenBG;
         }
         else
         {
            counter = this.myTokenCounter;
            icon = this.myTokenIcon;
            bg = this.myTokenBG;
         }
         counter.updateCount(count);
         var spacing:Number = 10;
         var totalWidth:Number = counter.width + icon.width + spacing;
         icon.x = bg.x + (bg.width - totalWidth) * 0.5;
         counter.x = icon.x + icon.width + spacing;
      }
      
      private function setTokenState(state:uint, isRampage:Boolean) : void
      {
         var message:String = null;
         var warning:Boolean = false;
         if(state == STATE_CAN_USE)
         {
            message = isRampage ? DictInGame.SPEND_RAMPAGE_TOKENS_MESSAGING : DictInGame.SPEND_TOKENS_MESSAGING;
         }
         else if(state == STATE_BUY)
         {
            message = isRampage ? DictInGame.BUY_RAMPAGE_TOKENS_MESSAGING : DictInGame.BUY_TOKENS_MESSAGING;
         }
         else if(state == STATE_BUY_SUCCESS)
         {
            message = isRampage ? DictInGame.BUY_RAMPAGE_TOKENS_SUCCESS_SPEND_MESSAGING : DictInGame.BUY_TOKENS_SUCCESS_SPEND_MESSAGING;
         }
         else if(state == STATE_BUY_FAIL)
         {
            message = isRampage ? DictInGame.BUY_RAMPAGE_TOKENS_ERROR_MESSAGING : DictInGame.BUY_TOKENS_ERROR_MESSAGING;
            warning = true;
         }
         message = LOCALIZE_KEY_BIND(message);
         if(isRampage)
         {
            this.myAdvBuyTokenMessageTF.htmlText = message;
            this.myAdvWarningIcon.visible = warning;
            this.myAdvTokenIcon.visible = !warning;
         }
         else
         {
            this.myBuyTokenMessageTF.htmlText = message;
            this.myWarningIcon.visible = warning;
            this.myTokenIcon.visible = !warning;
         }
      }
   }
}

