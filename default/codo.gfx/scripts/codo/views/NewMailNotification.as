package codo.views
{
   import codo.base.BaseView;
   import codo.component.Button;
   import codo.component.CloseButton;
   import codo.component.TextField;
   import codo.component.social.ArrowButton;
   import codo.constants.BCEvent;
   import codo.constants.InvitationType;
   import codo.event.ParaEvent;
   import codo.localization.Dict;
   import codo.localization.DictMail;
   import codo.localization.DictSystem;
   import codo.objects.MailAttachmentObjForMailObj;
   import codo.objects.ProductObj;
   import codo.style.SystemMessageGuide;
   import codo.utils.ItemUtil;
   import codo.utils.LocalizeUtil;
   import codo.views.mail_parts.MailAttachmentCard;
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import flash.display.MovieClip;
   
   public class NewMailNotification extends BaseView
   {
      
      private static const NO_ANIMATION:int = 0;
      
      private static const ARCHIVE_ANIMATION:int = 1;
      
      public var mySenderName:TextField;
      
      public var myTimeStamp:TextField;
      
      public var mySubject:TextField;
      
      public var myMessage:TextField;
      
      public var myAttachmentCount:TextField;
      
      public var myRejectBtn:Button;
      
      public var myAcceptBtn:Button;
      
      public var myCloseBtn:CloseButton;
      
      public var myAttachIcon:MovieClip;
      
      public var myLeftArrow:ArrowButton;
      
      public var myRightArrow:ArrowButton;
      
      public var myAttachment:MailAttachmentCard;
      
      public var myBg:MovieClip;
      
      private var mCurrentAttIndex:int = 0;
      
      private var mAttachments:Array;
      
      private var mMailObj:Object;
      
      private var mData:Object;
      
      private var showing:Boolean;
      
      public function NewMailNotification()
      {
         super();
         this.initStage();
      }
      
      private function initStage() : void
      {
         this.mySenderName.textStyle = SystemMessageGuide.styleSenderName;
         this.mySenderName.enableTruncate(true);
         this.mySenderName.width = 316;
         this.mySenderName.height = 32;
         this.myTimeStamp.textStyle = SystemMessageGuide.styleTimeStamp;
         this.myTimeStamp.height = 23;
         this.myTimeStamp.x = this.mySenderName.x + this.mySenderName.textWidth + 5;
         this.mySubject.textStyle = SystemMessageGuide.styleSubject;
         this.mySubject.enableTruncate(true);
         this.mySubject.width = 450;
         this.myMessage.textStyle = SystemMessageGuide.styleMessage;
         this.myAttachmentCount.textStyle = SystemMessageGuide.styleAttachmentCount;
         this.myAcceptBtn.width = this.myRejectBtn.width = SystemMessageGuide.BUTTON_WIDTH;
         this.myAcceptBtn.height = this.myRejectBtn.height = SystemMessageGuide.BUTTON_HEIGHT;
         this.myAcceptBtn.x = this.myBg.width - this.myAcceptBtn.width - 1;
         this.myRejectBtn.x = this.myAcceptBtn.x - this.myRejectBtn.width;
         this.myLeftArrow.registerClickEvent(this.onLeftArrowClicked);
         this.myRightArrow.registerClickEvent(this.onRightArrowClicked);
         this.myCloseBtn.registerClickEvent(this.onCloseButtonClicked);
         this.myAcceptBtn.registerClickEvent(this.onAcceptButtonClicked);
         this.myRejectBtn.registerClickEvent(this.onRejectButtonClicked);
         this.resetPosition();
      }
      
      private function setData(data:*) : void
      {
         this.mData = data;
         this.setMailObj(data.mailObj);
      }
      
      override protected function showView() : void
      {
         super.showView();
         this.resetPosition();
         broadcast(BCEvent.EVT_ON_MAIL_NOTIFICATION_READY);
      }
      
      override protected function hideView() : void
      {
         super.hideView();
         this.resetPosition();
         broadcast(BCEvent.EVT_ON_MAIL_NOTIFICATION_UNREADY);
      }
      
      override protected function enableData() : void
      {
         super.enableData();
         listen(BCEvent.EVT_SHOW_MAIL_NOTIFICATION_VIEW,this.onShowMailNotificationView);
         listen(BCEvent.EVT_FORCE_HIDE_MAIL_NOTIFICATION_VIEW,this.onForceHideMailNotificationView);
         listen(BCEvent.EVT_SHOW_PERSISTENT_VIEW,this.onShowEvt);
         listen(BCEvent.EVT_HIDE_PERSISTENT_VIEW,this.onHideEvt);
      }
      
      override protected function disableData() : void
      {
         super.disableData();
         unlisten(BCEvent.EVT_SHOW_MAIL_NOTIFICATION_VIEW,this.onShowMailNotificationView);
         unlisten(BCEvent.EVT_FORCE_HIDE_MAIL_NOTIFICATION_VIEW,this.onForceHideMailNotificationView);
         unlisten(BCEvent.EVT_SHOW_PERSISTENT_VIEW,this.onShowEvt);
         unlisten(BCEvent.EVT_HIDE_PERSISTENT_VIEW,this.onHideEvt);
      }
      
      private function onShowEvt(cEvt:ParaEvent) : void
      {
         visible = true;
         broadcast(BCEvent.EVT_ON_MAIL_NOTIFICATION_READY);
      }
      
      private function onHideEvt(cEvt:ParaEvent) : void
      {
         visible = false;
         broadcast(BCEvent.EVT_ON_MAIL_NOTIFICATION_UNREADY);
      }
      
      private function onShowMailNotificationView(cEvt:ParaEvent) : void
      {
         this.showing = true;
         this.setData(cEvt.myPara);
         this.playShowAnimation();
      }
      
      private function playShowAnimation() : void
      {
         visible = true;
         x = 1920;
         y = 770;
         scaleX = scaleY = 1;
         TweenLite.to(this,0.2,{"x":1394});
      }
      
      public function setMailObj(data:Object) : void
      {
         this.mMailObj = data;
         this.mySenderName.text = data.senderName;
         this.myTimeStamp.x = this.mySenderName.x + this.mySenderName.textWidth + 5;
         if(data.timeStamp == "")
         {
            this.myTimeStamp.text = Dict.INVALID_TIME;
         }
         else
         {
            this.myTimeStamp.text = data.timeStamp;
         }
         this.mySubject.text = data.title;
         this.myMessage.text = data.message;
         if(Boolean(data.isAttached))
         {
            this.myAttachIcon.visible = true;
            this.mySubject.x = this.myAttachIcon.x + this.myAttachIcon.width;
            this.myAttachment.visible = true;
            this.myMessage.x = 184;
            this.myMessage.width = 330;
            this.myMessage.height = 90;
            this.showAttachment(data.mailAttachmentArray,0);
            this.mAttachments = data.mailAttachmentArray;
         }
         else
         {
            this.myAttachIcon.visible = false;
            this.mySubject.x = this.myAttachIcon.x;
            this.myAttachment.visible = false;
            this.myMessage.x = this.myAttachment.x;
            this.myMessage.width = 507;
            this.myMessage.height = 90;
            this.mAttachments = null;
         }
         if(Boolean(data.isAttached) && data.mailAttachmentArray.length > 1)
         {
            this.myLeftArrow.visible = this.myRightArrow.visible = true;
            this.myAttachmentCount.visible = true;
         }
         else
         {
            this.myLeftArrow.visible = this.myRightArrow.visible = false;
            this.myAttachmentCount.visible = false;
         }
         this.arrangeButton(data.isAttached,data.isInvites,data.rawData.type == InvitationType.EXPIRE_MESSAGE);
      }
      
      private function showAttachment(atts:Array, index:int) : void
      {
         this.mCurrentAttIndex = index;
         var attachment:MailAttachmentObjForMailObj = atts[index] as MailAttachmentObjForMailObj;
         var prod:ProductObj = ItemUtil.getProductObjByProductId(attachment.attachmentProdId);
         this.myAttachment.setData(prod);
         var localizedStr:String = LocalizeUtil.localize(DictMail.ATTACHMENT);
         this.myAttachmentCount.text = localizedStr + String(index + 1) + "/" + String(atts.length);
         this.refreshArrowButtons(index,atts.length);
      }
      
      private function refreshArrowButtons(curIndex:int, totalCount:int) : void
      {
         this.myLeftArrow.enabled = curIndex > 0;
         this.myRightArrow.enabled = curIndex < totalCount - 1;
      }
      
      private function onLeftArrowClicked() : void
      {
         if(this.mCurrentAttIndex - 1 >= 0)
         {
            --this.mCurrentAttIndex;
            this.showAttachment(this.mAttachments,this.mCurrentAttIndex);
         }
      }
      
      private function onRightArrowClicked() : void
      {
         if(this.mAttachments == null)
         {
            return;
         }
         if(this.mCurrentAttIndex + 1 < this.mAttachments.length)
         {
            ++this.mCurrentAttIndex;
            this.showAttachment(this.mAttachments,this.mCurrentAttIndex);
         }
      }
      
      private function arrangeButton(isAttached:Boolean, isInvites:Boolean, isExpire:Boolean) : void
      {
         if(isAttached)
         {
            this.myAcceptBtn.visible = true;
            this.myRejectBtn.visible = false;
            this.myAcceptBtn.x = this.myBg.width - this.myAcceptBtn.width - 1;
            this.myAcceptBtn.label = DictMail.MAIL_FETCH_ATTACHMENT;
            return;
         }
         if(isInvites)
         {
            this.myAcceptBtn.visible = true;
            this.myRejectBtn.visible = true;
            this.myAcceptBtn.x = this.myBg.width - this.myAcceptBtn.width - 1;
            this.myRejectBtn.x = this.myAcceptBtn.x - this.myRejectBtn.width;
            this.myAcceptBtn.label = DictSystem.ACCEPT;
            this.myRejectBtn.label = DictSystem.REFUSE;
            return;
         }
         if(isExpire)
         {
            this.myAcceptBtn.visible = true;
            this.myRejectBtn.visible = false;
            this.myAcceptBtn.x = this.myBg.width - this.myAcceptBtn.width - 1;
            this.myAcceptBtn.label = Dict.SHOW_DETAIL;
            return;
         }
         this.myAcceptBtn.visible = false;
         this.myRejectBtn.visible = false;
      }
      
      private function onCloseButtonClicked() : void
      {
         this.mData.readHandler(this.mMailObj);
         this.closeNotification(ARCHIVE_ANIMATION);
      }
      
      private function onAcceptButtonClicked() : void
      {
         this.mData.acceptHandler(this.mMailObj);
         this.closeNotification(NO_ANIMATION);
      }
      
      private function onRejectButtonClicked() : void
      {
         this.mData.rejectHandler(this.mMailObj);
         this.closeNotification(NO_ANIMATION);
      }
      
      private function onDeleteButtonClicked() : void
      {
         this.mData.deleteHandler(this.mMailObj);
         this.closeNotification(NO_ANIMATION);
      }
      
      private function closeNotification(animationType:int) : void
      {
         if(animationType == ARCHIVE_ANIMATION)
         {
            TweenMax.to(this,1,{
               "x":37,
               "y":601,
               "width":0,
               "height":0,
               "bezierThrough":[{
                  "x":804,
                  "y":416
               }],
               "onComplete":this.closeAnimationDone
            });
         }
         else
         {
            this.showNotificationComplete();
         }
      }
      
      private function closeAnimationDone() : void
      {
         broadcast(BCEvent.EVT_PLAY_MAIL_ARCHIVE_ANIMATION);
         this.showNotificationComplete();
      }
      
      private function showNotificationComplete() : void
      {
         this.resetPosition();
         broadcast(BCEvent.CLOSE_NEW_MAIL_NOTIFICATION);
         this.showing = false;
      }
      
      private function onForceHideMailNotificationView(evt:ParaEvent) : void
      {
         this.showNotificationComplete();
      }
      
      private function resetPosition() : void
      {
         x = 1921;
         y = 770;
         visible = false;
      }
   }
}

