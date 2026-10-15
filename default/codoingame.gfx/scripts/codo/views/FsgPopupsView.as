package codo.views
{
   import codo.base.PopupView;
   import codo.component.factory.MarketFactory;
   import codo.component.marketplaceitem.MarketplaceItem;
   import codo.constants.BCEvent;
   import codo.constants.MsgBtnCount;
   import codo.constants.SystemMsgPriority;
   import codo.event.ParaEvent;
   import codo.localization.Dict;
   import codo.localization.DictSystem;
   import codo.objects.MessageRewardData;
   import codo.objects.ProductObj;
   import codo.objects.SystemMsgObj;
   import codo.style.GlobalGuide;
   import codo.utils.ItemUtil;
   import codo.utils.MarketItemUtil;
   import flash.display.MovieClip;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.utils.Timer;
   import fsg.util.FsgImageHolder;
   
   public class FsgPopupsView extends PopupView
   {
      
      private static const SPINNER_WIDTH:int = 40;
      
      private static const HORIZONTAL_MARGIN:int = 44;
      
      private static const POPUP_WIDTH:Number = 377;
      
      private static const POPUP_HEIGHT:Number = 200;
      
      private static const ITEM_CARD_MARGIN:Number = 40;
      
      private static const ITEM_CARD_SPACE:Number = 12;
      
      private static const ITEM_POPUP_WIDTH:Number = 456;
      
      public var mySpinner:MovieClip;
      
      public var myDetailsTF:TextField;
      
      public var myImage:FsgImageHolder;
      
      protected var mCurrentMsgObj:SystemMsgObj = null;
      
      private var mDelayTimer:Timer;
      
      private var m_vecItemCard:Vector.<MarketplaceItem> = new Vector.<MarketplaceItem>();
      
      private var m_cardItemsNode:MovieClip;
      
      public function FsgPopupsView()
      {
         super();
         myPopup.width = 377;
         myPopup.height = 200;
         this.myDetailsTF.multiline = this.myDetailsTF.wordWrap = true;
         this.mySpinner.visible = false;
         headerTitle = LOCALIZE(Dict.TITLE_SYS_MSG).toUpperCase();
         this.myDetailsTF.width = myPopup.popupWidth - (SPINNER_WIDTH + HORIZONTAL_MARGIN);
         this.mySpinner.y = this.myDetailsTF.y + this.mySpinner.height * 0.5 * 0.3;
         myPopup.myCloseButton.visible = false;
         this.myImage.visible = false;
         this.m_cardItemsNode = new MovieClip();
         this.addChild(this.m_cardItemsNode);
         listen(BCEvent.EVT_SET_SYS_VIEW_MSG,this.onSetSystemMsg);
         listen(BCEvent.EVT_CHANGE_SYS_VIEW_MSG,this.onChangeSystemMsg);
         visible = false;
      }
      
      public function onSetSystemMsg(cEvt:ParaEvent) : void
      {
         var rewardData:Object = null;
         this.mCurrentMsgObj = cEvt.myPara as SystemMsgObj;
         if(this.mCurrentMsgObj == null)
         {
            return;
         }
         myPopup.resetButtons();
         this.hideAllItemCards();
         this.myDetailsTF.text = this.mCurrentMsgObj.message;
         if(this.mCurrentMsgObj.rewardData != null)
         {
            this.makeItemCards(this.mCurrentMsgObj.rewardData);
         }
         else if(this.mCurrentMsgObj.imageURL != "")
         {
            this.myImage.setImage(this.mCurrentMsgObj.imageURL);
            this.myImage.visible = true;
            myPopup.width = POPUP_WIDTH + this.myImage.width;
            myPopup.height = POPUP_HEIGHT + 62;
            this.myDetailsTF.x = this.myImage.x + this.myImage.width;
            this.myDetailsTF.textColor = GlobalGuide.WHITE;
         }
         else
         {
            this.myImage.visible = false;
            myPopup.width = POPUP_WIDTH;
            myPopup.height = POPUP_HEIGHT;
            this.myDetailsTF.x = 21;
            this.myDetailsTF.textColor = GlobalGuide.WHITE;
         }
         var showSpinner:Boolean = true;
         if(this.mCurrentMsgObj.btnCount > 0)
         {
            showSpinner = this.mCurrentMsgObj.alwaysShowSpinner;
         }
         this.changeStyle(showSpinner);
         var tfm:TextFormat = this.myDetailsTF.getTextFormat();
         this.mySpinner.x = this.myDetailsTF.x + this.myDetailsTF.textWidth + tfm.leftMargin + 25;
         switch(this.mCurrentMsgObj.btnCount)
         {
            case MsgBtnCount.ONE:
               myPopup.configConfirmButton(this.mCurrentMsgObj.btn0Label || DictSystem.CONFIRM,this.mCurrentMsgObj.btn0Handle);
               break;
            case MsgBtnCount.TWO:
               myPopup.configConfirmButton(this.mCurrentMsgObj.btn0Label || DictSystem.CONFIRM,this.mCurrentMsgObj.btn0Handle);
               myPopup.configCancelButton(this.mCurrentMsgObj.btn1Label || DictSystem.CANCEL,this.mCurrentMsgObj.btn1Handle);
               break;
            case MsgBtnCount.THREE:
               myPopup.configConfirmButton(this.mCurrentMsgObj.btn0Label || DictSystem.CONFIRM,this.mCurrentMsgObj.btn0Handle);
               myPopup.configCancelButton(this.mCurrentMsgObj.btn1Label || DictSystem.CANCEL,this.mCurrentMsgObj.btn1Handle);
               myPopup.configAuxiliaryButton(this.mCurrentMsgObj.btn2Label || DictSystem.CANCEL,this.mCurrentMsgObj.btn2Handle);
         }
         if(this.mCurrentMsgObj.btnDelay > 0)
         {
            if(this.mDelayTimer != null)
            {
               this.mDelayTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.delayRevealButtons);
               this.mDelayTimer.reset();
               this.mDelayTimer = null;
            }
            this.mDelayTimer = new Timer(this.mCurrentMsgObj.btnDelay,1);
            this.mDelayTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.delayRevealButtons);
            this.mDelayTimer.start();
            myPopup.disableButtons(true);
         }
         else if(this.mDelayTimer != null)
         {
            this.delayRevealButtons(null);
         }
         this.refreshErrorState();
      }
      
      public function onChangeSystemMsg(cEvt:ParaEvent) : void
      {
         var tempMsg:SystemMsgObj = cEvt.myPara;
         this.mCurrentMsgObj = tempMsg;
         if(this.mCurrentMsgObj.message.length > 0)
         {
            this.myDetailsTF.text = this.mCurrentMsgObj.message;
            this.resizeDetailTF();
            if(this.mySpinner.visible)
            {
               this.mySpinner.x = this.myDetailsTF.x + this.myDetailsTF.textWidth + 20;
            }
         }
         this.refreshErrorState();
      }
      
      protected function changeStyle(showSpinner:Boolean) : void
      {
         if(showSpinner)
         {
            this.mySpinner.visible = true;
            this.mySpinner.play();
         }
         else
         {
            this.mySpinner.visible = false;
            this.mySpinner.stop();
         }
         this.resizeDetailTF();
      }
      
      protected function resizeDetailTF() : void
      {
         if(this.mySpinner.visible)
         {
            this.myDetailsTF.width = myPopup.popupWidth - (SPINNER_WIDTH + HORIZONTAL_MARGIN);
         }
         else if(this.myImage.visible)
         {
            this.myDetailsTF.width = myPopup.popupWidth - HORIZONTAL_MARGIN - this.myDetailsTF.x;
         }
         else
         {
            this.myDetailsTF.width = myPopup.popupWidth - HORIZONTAL_MARGIN;
         }
      }
      
      protected function refreshErrorState() : void
      {
         if(this.mCurrentMsgObj.title != null)
         {
            headerTitle = LOCALIZE(this.mCurrentMsgObj.title).toUpperCase();
         }
         else
         {
            switch(this.mCurrentMsgObj.priority)
            {
               case SystemMsgPriority.ERROR:
                  headerTitle = LOCALIZE(DictSystem.ERROR).toUpperCase();
                  break;
               case SystemMsgPriority.WARNING:
                  headerTitle = LOCALIZE(DictSystem.WARNING).toUpperCase();
                  break;
               default:
                  headerTitle = LOCALIZE(Dict.TITLE_SYS_MSG).toUpperCase();
            }
         }
      }
      
      private function delayRevealButtons(te:TimerEvent) : void
      {
         this.mDelayTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.delayRevealButtons);
         this.mDelayTimer.reset();
         this.mDelayTimer = null;
         myPopup.enableButtons(true);
      }
      
      private function hideAllItemCards() : void
      {
         while(this.m_cardItemsNode.numChildren > 0)
         {
            this.m_cardItemsNode.removeChildAt(0);
         }
      }
      
      private function makeItemCards(data:MessageRewardData) : void
      {
         var itemProductId:int = 0;
         var itemObject:ProductObj = null;
         var itemCard:MarketplaceItem = null;
         var objList:Array = new Array();
         if(data.currencyAmount > 0)
         {
            objList.push(ProductObj.makeCurrencyObj(new ProductObj(),data.currencyType,data.currencyAmount));
         }
         if(data.item != null)
         {
            itemProductId = int(data.item.id);
            itemObject = ItemUtil.getProductObjByProductId(itemProductId);
            if(itemObject.stackable)
            {
               itemObject.stackDelta = data.item.quantity;
            }
            else
            {
               itemObject.remainSecond = data.item.duration;
            }
            if(itemObject != null)
            {
               objList.push(itemObject);
            }
         }
         for(var i:int = 0; i < objList.length; i++)
         {
            itemCard = null;
            if(i >= this.m_vecItemCard.length)
            {
               itemCard = MarketFactory.GET_BUILD_MARKET_ITEM_CARD_FUNC(MarketItemUtil.ITEM_CARD_SMALL_FRAME,false,false)() as MarketplaceItem;
               itemCard.withCallToArms = false;
               itemCard.withDiscountTag = false;
               itemCard.withOwnStateHint = false;
               itemCard.hasPreviewPopup = false;
               this.m_vecItemCard.push(itemCard);
            }
            else
            {
               itemCard = this.m_vecItemCard[i];
            }
            this.m_cardItemsNode.addChild(itemCard);
            itemCard.x = i * (itemCard.width + ITEM_CARD_SPACE);
            itemCard.setData(objList[i]);
         }
         this.m_cardItemsNode.y = this.myDetailsTF.y + this.myDetailsTF.textHeight + ITEM_CARD_SPACE;
         myPopup.height = this.m_cardItemsNode.y + itemCard.height + ITEM_CARD_MARGIN;
         var cardItemsFieldWidth:Number = (itemCard.width + ITEM_CARD_SPACE) * objList.length - ITEM_CARD_SPACE;
         var popupWidth:Number = cardItemsFieldWidth + ITEM_CARD_MARGIN * 2 > ITEM_POPUP_WIDTH ? cardItemsFieldWidth + ITEM_CARD_MARGIN * 2 : ITEM_POPUP_WIDTH;
         myPopup.width = popupWidth;
         this.m_cardItemsNode.x = (popupWidth - cardItemsFieldWidth) / 2;
         this.myDetailsTF.textColor = GlobalGuide.CODO_BLUE_HIGHLIGHT;
      }
   }
}

