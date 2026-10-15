package codo.controllers
{
   import codo.base.BaseController;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.constants.MsgBtnCount;
   import codo.event.ParaEvent;
   import codo.localization.Dict;
   import codo.objects.MailObj;
   import codo.objects.ProductObj;
   import codo.utils.Logger;
   import codo.utils.StringUtil;
   
   public class CouponController extends BaseController
   {
      
      private static const REDEEM_COUPON_SUCCESS:int = 0;
      
      private static const CLAIM_COUPON_FAIL_WHENCLAIM:int = 1;
      
      private static const CLAIM_COUPON_FAIL_WHENUPDATE:int = 2;
      
      private static const CLAIM_COUPON_FAIL_WHENREDEEM:int = 3;
      
      private static const BD_MARKETPLACE_ITEM_MULTIPLE_PURCHASE_ERROR:int = 8010;
      
      private var _currentTargetUser:String;
      
      private var _currentTargetUserID:String;
      
      private var _currentMessage:String;
      
      private var _currentCoupon:String;
      
      private var _waitingSendingGiftMail:Boolean = false;
      
      private var _bAutoClaimCoupon:Boolean = false;
      
      private var _mailToDelArray:Array = new Array();
      
      private var _bRedeemed:Boolean = false;
      
      public function CouponController()
      {
         super();
      }
      
      override protected function onInit() : void
      {
         this.listen(BCEvent.EVT_SEND_GIFT,this.onSendGift);
         this.listen(BCEvent.EVT_ON_MAIL_SENT,this.onMailSentHandle);
         this.listen(BCEvent.EVT_CLAIM_COUPONARRAY,this.onClaimCouponArrayHandle);
         this.listen(BCEvent.EVT_INVENTORY_OPEN_COUPON,this.onRedeemCoupon);
         this.listen(BCEvent.EVT_SEND_COUPON_GIFT,this.onTransferCoupon);
         this.listen(BCEvent.EVT_CLAIM_COUPON_COMPLETED,this.onRefreshPendingAndOwnedCoupon);
      }
      
      private function onSendGift(cEvt:ParaEvent) : void
      {
         var marketItemObj:ProductObj = new ProductObj(cEvt.myPara.item);
         var skuID:int = int(marketItemObj.SKUs[marketItemObj.currentSKUIndex].id);
         this._currentMessage = cEvt.myPara.msg;
         if(typeof cEvt.myPara.targetUser == "string")
         {
            this._currentTargetUser = cEvt.myPara.targetUser;
            this.request(DataID.PURCHASE_GIFT,{
               "sku":skuID,
               "targetUser":this._currentTargetUser,
               "needCheckID":true
            },this.onPurchaseGiftComplete);
         }
         else
         {
            this._currentTargetUser = cEvt.myPara.targetUser.name;
            this._currentTargetUserID = cEvt.myPara.targetUser.id;
            this.request(DataID.PURCHASE_GIFT,{
               "sku":skuID,
               "targetUser":this._currentTargetUserID,
               "needCheckID":false
            },this.onPurchaseGiftComplete);
         }
         Logger.print("Send gift - SKU: " + skuID + " TO USER: " + this._currentTargetUser + " With Message: " + this._currentMessage);
      }
      
      private function onPurchaseGiftComplete(cRes:Object) : void
      {
         var mailObj:MailObj = null;
         if(cRes.result == 1)
         {
            Logger.print("CouponController::onPurchaseGiftComplete");
            mailObj = new MailObj();
            mailObj.receivers = StringUtil.stringToReceivers(this._currentTargetUser);
            mailObj.addAttachment(cRes.data);
            mailObj.message = this._currentMessage;
            this._waitingSendingGiftMail = true;
            this.showMsg(Dict.SEND_GIFT_IN_PROGRESS);
            this.broadcast(BCEvent.EVT_SEND_MAIL,mailObj);
         }
         else
         {
            this.broadcast(BCEvent.EVT_SEND_GIFT_FAILED);
         }
      }
      
      private function returnCoupon() : void
      {
         this.hideMsg();
         this.request(DataID.TRANSFER_COUPON,{
            "coupon":this._currentCoupon,
            "targetUser":this._currentTargetUserID,
            "needCheckID":false
         },this.onReturnCouponComplete);
      }
      
      private function cancelReturn() : void
      {
         this.broadcast(BCEvent.EVT_RETURN_COUPON_CANCEL);
      }
      
      private function onReturnCouponComplete(cRes:Object) : void
      {
         this.broadcast(BCEvent.EVT_RETURN_MAIL,cRes.result);
      }
      
      private function onTransferCoupon(cEvt:ParaEvent) : void
      {
         this._currentMessage = cEvt.myPara.msg;
         this._currentCoupon = cEvt.myPara.item.couponID;
         if(typeof cEvt.myPara.targetUser == "string")
         {
            this._currentTargetUser = cEvt.myPara.targetUser;
            Logger.print("Transfer coupon: " + this._currentCoupon + " TO USER: " + this._currentTargetUser + " With Message: " + this._currentMessage);
            this.request(DataID.TRANSFER_COUPON,{
               "coupon":this._currentCoupon,
               "targetUser":this._currentTargetUser,
               "needCheckID":true
            },this.onTransferCouponComplete);
         }
         else
         {
            this._currentTargetUser = cEvt.myPara.targetUser.name;
            this._currentTargetUserID = cEvt.myPara.targetUser.id;
            Logger.print("Transfer coupon: " + this._currentCoupon + " TO USER: " + this._currentTargetUserID + " With Message: " + this._currentMessage);
            this.request(DataID.TRANSFER_COUPON,{
               "coupon":this._currentCoupon,
               "targetUser":this._currentTargetUserID,
               "needCheckID":false
            },this.onTransferCouponComplete);
         }
      }
      
      private function onTransferCouponComplete(cRes:Object) : void
      {
         var mailObj:MailObj = null;
         if(cRes.result == 1)
         {
            mailObj = new MailObj();
            mailObj.receivers = StringUtil.stringToReceivers(this._currentTargetUser);
            mailObj.addAttachment(this._currentCoupon);
            mailObj.message = this._currentMessage;
            this._waitingSendingGiftMail = true;
            this.hideMsg();
            this.showMsg(Dict.SEND_GIFT_IN_PROGRESS);
            this.broadcast(BCEvent.EVT_SEND_MAIL,mailObj);
         }
         else
         {
            this.hideMsg();
            this.showMsg(Dict.PURCHASE_GIFT_FAILED,MsgBtnCount.ONE);
            this.broadcast(BCEvent.EVT_SEND_COUPON_GIFT_FAILED);
         }
      }
      
      private function onMailSentHandle(cEvt:ParaEvent) : void
      {
         Logger.print("CouponController::onMailSendHandle");
         if(this._waitingSendingGiftMail)
         {
            this._waitingSendingGiftMail = false;
            if(Boolean(cEvt.myPara.result))
            {
               this.broadcast(BCEvent.EVT_SEND_COUPON_GIFT_COMPLETED);
               this.hideMsg();
               this.showMsg(Dict.SEND_GIFT_SUCCESS,MsgBtnCount.ONE);
            }
            else
            {
               this.showMsg(Dict.SEND_GIFT_FAILED,MsgBtnCount.ONE);
            }
         }
      }
      
      private function onRefreshPendingAndOwnedCoupon(cEvt:ParaEvent) : void
      {
      }
      
      private function onClaimCouponArrayHandle(cEvt:ParaEvent) : void
      {
         if(this._mailToDelArray.length > 0)
         {
            Logger.print("Error in onClaimCouponArrayHandle!");
            return;
         }
         var newMailToBeClaimed:Array = cEvt.myPara;
         var _autoClaimCouponIDStringArray:Array = new Array();
         this._mailToDelArray = this._mailToDelArray.concat(newMailToBeClaimed);
         this._bAutoClaimCoupon = true;
         for(var i:int = 0; i < newMailToBeClaimed.length; i++)
         {
            _autoClaimCouponIDStringArray = _autoClaimCouponIDStringArray.concat(newMailToBeClaimed[i].getAttachmentStringArray());
         }
         this.request(DataID.CLAIM_COUPON,_autoClaimCouponIDStringArray,this.onRedeemCouponCompleted);
      }
      
      private function onRedeemCoupon(cEvt:ParaEvent) : void
      {
         var _couponIDString:String = cEvt.myPara.data.couponID;
         this.request(DataID.REDEEM_COUPON,[_couponIDString],this.onRedeemCouponCompleted);
      }
      
      private function onRedeemCouponCompleted(cRes:Object) : void
      {
         Logger.print("cRes.data.errorCode : " + cRes.data.errorCode);
         var errorCode:int = int(cRes.data.errorCode);
         var detailCode:int = int(cRes.data.detailCode);
         this.hideMsg();
         var hasError:Boolean = false;
         var needDeleteMail:Boolean = false;
         var errorString:String = "";
         if(errorCode == REDEEM_COUPON_SUCCESS)
         {
            hasError = false;
            needDeleteMail = true;
         }
         else if(errorCode == CLAIM_COUPON_FAIL_WHENCLAIM)
         {
            hasError = true;
            needDeleteMail = false;
            errorString = Dict.REDEEM_COUPON_FAILED;
         }
         else if(errorCode == CLAIM_COUPON_FAIL_WHENUPDATE)
         {
            hasError = false;
            needDeleteMail = true;
         }
         else if(errorCode == CLAIM_COUPON_FAIL_WHENREDEEM)
         {
            hasError = false;
            if(detailCode == BD_MARKETPLACE_ITEM_MULTIPLE_PURCHASE_ERROR)
            {
               errorString = Dict.REDEEM_FAIL_EXIST_PERMANENT;
            }
            else
            {
               errorString = Dict.REDEEM_COUPON_FAILED;
            }
            needDeleteMail = true;
         }
         if(needDeleteMail)
         {
            this.broadcast(BCEvent.EVT_ON_COUPON_CLAIMED,{"mail":this._mailToDelArray});
            this._bRedeemed = true;
         }
         if(hasError)
         {
            this.showMsg(errorString,MsgBtnCount.ONE);
         }
         else
         {
            this.showMsg(Dict.REDEEM_COUPON_SUCCESS,MsgBtnCount.ONE);
            this.broadcast(BCEvent.EVT_MARKET_UPDATE_INVENTORY);
         }
         this._mailToDelArray.splice(0);
      }
   }
}

