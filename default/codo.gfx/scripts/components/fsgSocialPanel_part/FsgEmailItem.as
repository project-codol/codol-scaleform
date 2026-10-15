package components.fsgSocialPanel_part
{
   import codo.component.social.DeleteButton;
   import codo.constants.GameInfo;
   import codo.constants.SE_ID;
   import codo.localization.Dict;
   import codo.localization.DictMail;
   import codo.localization.DictSystem;
   import codo.objects.MailAttachmentObjForMailObj;
   import codo.objects.ProductObj;
   import codo.utils.ItemUtil;
   import codo.utils.StringUtil;
   import codo.utils.TextUtil;
   import codo.views.mail_parts.MailAttachmentCard;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextFieldAutoSize;
   import fsg.shared.BehaviourAnimatedClickable;
   import fsg.shared.BehaviourClickable;
   import fsg.util.FsgAudioUtil;
   
   public class FsgEmailItem extends MovieClip
   {
      
      public var MAIL_CONTEXT_MARGIN:Number = 44;
      
      public var myMailDelete:DeleteButton;
      
      public var myMailClosed:MovieClip;
      
      public var myMailOpen:MovieClip;
      
      public var myAttachment:MailAttachmentCard;
      
      public var m_onCallback:Function;
      
      public var m_onDeleteCallback:Function;
      
      public var m_declineBtn:Function;
      
      public var m_acceptBtn:Function;
      
      public var m_OrderNum:Number;
      
      public var m_invitationDLCLevel:uint = 0;
      
      private var m_Clickable:BehaviourClickable;
      
      private var m_ClickableAnim:BehaviourAnimatedClickable;
      
      private var m_header:String;
      
      private var m_subject:String;
      
      private var m_message:String;
      
      private var m_timeStamp:String;
      
      private var m_isRead:Boolean;
      
      private var m_isAttached:Boolean = false;
      
      private var m_isAcceptable:Boolean = false;
      
      private var m_isExpire:Boolean = false;
      
      private var m_isOpened:Boolean = false;
      
      private var m_attachmentArray:Array;
      
      private var m_currentAttachmentIndex:int = 0;
      
      private var m_mailHeight:Number;
      
      private var m_defaultOpenBgHeight:Number;
      
      public function FsgEmailItem()
      {
         super();
         this.myAttachment = this.myMailOpen.myAttachment as MailAttachmentCard;
         this.myMailOpen.myFooterBar.myAttachmentArrowLeft.myHitArea.addEventListener(MouseEvent.CLICK,this.onAttachmentLeftClicked);
         this.myMailOpen.myFooterBar.myAttachmentArrowRight.myHitArea.addEventListener(MouseEvent.CLICK,this.onAttachmentRightClicked);
         this.myMailOpen.myFooterBar.myAttachmentCountLabel.text = DictMail.ATTACHMENT;
         this.m_mailHeight = this.myMailClosed.height;
         this.m_Clickable = new BehaviourClickable(this.myMailClosed.myHitArea);
         this.m_ClickableAnim = new BehaviourAnimatedClickable(this.myMailClosed,this.m_Clickable,1,2,2);
         this.m_Clickable.addClickCallback(this.onSelectedCallback);
         this.addEventListener(MouseEvent.ROLL_OVER,this.onMouseRollOverHandle);
         this.myMailDelete.registerClickEvent(this.onDeleteCallback);
         this.myMailOpen.visible = false;
         this.myMailClosed.visible = true;
         this.m_defaultOpenBgHeight = this.myMailOpen.myMailBG.height;
      }
      
      public function set itemOrder(i_index:int) : void
      {
         this.m_OrderNum = i_index;
      }
      
      public function set emailRead(b_value:Boolean) : void
      {
         this.m_isRead = b_value;
         if(this.m_isRead)
         {
            this.myMailClosed.myEnvelope.gotoAndStop(2);
            this.myMailOpen.myEnvelope.gotoAndStop(2);
         }
         else
         {
            this.myMailClosed.myEnvelope.gotoAndStop(1);
            this.myMailOpen.myEnvelope.gotoAndStop(1);
         }
      }
      
      public function get emailRead() : Boolean
      {
         return this.m_isRead;
      }
      
      public function get isMailOpened() : Boolean
      {
         return this.m_isOpened;
      }
      
      public function set emailAttached(b_value:Boolean) : void
      {
         this.m_isAttached = b_value;
      }
      
      public function set emailAcceptable(b_value:Boolean) : void
      {
         this.m_isAcceptable = b_value;
      }
      
      public function set emailExpire(b_value:Boolean) : void
      {
         this.m_isExpire = b_value;
      }
      
      public function set emailTimeStamp(str:String) : void
      {
         this.m_timeStamp = str;
      }
      
      public function set emailHeader(str:String) : void
      {
         this.m_header = str;
      }
      
      public function set emailSubject(str:String) : void
      {
         this.m_subject = str;
      }
      
      public function set emailMessage(str:String) : void
      {
         this.m_message = str;
      }
      
      public function setAttachment(attachments:Array) : void
      {
         this.m_attachmentArray = attachments;
      }
      
      public function setMailOpened(bOpened:Boolean, playSound:Boolean = true) : void
      {
         this.m_isOpened = bOpened;
         if(this.m_isOpened)
         {
            this.gotoAndStop(2);
            if(playSound)
            {
               FsgAudioUtil.getInstance().playSound(SE_ID.UI_SOCIALPANEL_MSG_EXPAND);
            }
         }
         else
         {
            this.gotoAndStop(1);
         }
         this.myMailOpen.visible = this.m_isOpened;
         this.myMailClosed.visible = !this.m_isOpened;
         this.myMailOpen.myMailName.myTextTF.text = this.myMailClosed.myMailName.myTextTF.text = this.m_header;
         StringUtil.fitTextField(this.myMailOpen.myMailName.myTextTF);
         StringUtil.fitTextField(this.myMailClosed.myMailName.myTextTF);
         this.myMailOpen.myMailSubject.myTextTF.text = this.myMailClosed.myMailSubject.myTextTF.text = this.m_subject;
         StringUtil.fitTextField(this.myMailOpen.myMailSubject.myTextTF);
         StringUtil.fitTextField(this.myMailClosed.myMailSubject.myTextTF);
         TextUtil.replaceEnFont(this.myMailOpen.myMailTime.myTextTF,this.m_timeStamp,GameInfo.GAME_FONT_AENCY_FB,0,GameInfo.GAME_FONT_S,0);
         TextUtil.replaceEnFont(this.myMailClosed.myMailTime.myTextTF,this.m_timeStamp,GameInfo.GAME_FONT_AENCY_FB,0,GameInfo.GAME_FONT_S,0);
         this.myMailOpen.myAttachIcon.visible = this.myMailClosed.myAttachIcon.visible = this.m_isAttached;
         if(this.m_isOpened)
         {
            if(this.m_isAttached)
            {
               this.myMailOpen.myAttachment.visible = true;
               this.myMailOpen.myMailMessage.visible = false;
               this.myMailOpen.myMailAttMessage.visible = true;
               this.fillAttachment();
            }
            else
            {
               this.noAttachment();
               this.myMailOpen.myAttachment.visible = false;
               this.myMailOpen.myMailMessage.visible = true;
               this.myMailOpen.myMailAttMessage.visible = false;
            }
            this.myMailOpen.myMailMessage.myTextTF.wordWrap = true;
            this.myMailOpen.myMailMessage.myTextTF.autoSize = TextFieldAutoSize.LEFT;
            this.myMailOpen.myMailMessage.myTextTF.text = this.m_message;
            this.myMailOpen.myMailAttMessage.myTextTF.wordWrap = true;
            this.myMailOpen.myMailAttMessage.myTextTF.autoSize = TextFieldAutoSize.LEFT;
            this.myMailOpen.myMailAttMessage.myTextTF.text = this.m_message;
            if(this.m_isAcceptable)
            {
               if(this.m_isAttached)
               {
                  this.myMailOpen.myFooterBar.myDeclineBtn.visible = false;
                  this.myMailOpen.myFooterBar.acceptText = this.m_attachmentArray.length > 1 ? DictMail.MAIL_FETCH_ALL_ATTACHMENT : DictMail.MAIL_FETCH_ATTACHMENT;
               }
               else
               {
                  this.myMailOpen.myFooterBar.myDeclineBtn.visible = true;
                  this.myMailOpen.myFooterBar.acceptText = DictSystem.ACCEPT;
               }
               this.myMailOpen.myFooterBar.myAcceptBtn.visible = true;
               this.myMailOpen.myFooterBar.declineText = DictSystem.REFUSE;
               this.myMailOpen.myFooterBar.setDeclineCallback(this.onDeclineCallback);
               this.myMailOpen.myFooterBar.setAcceptCallback(this.onAcceptCallback);
               this.myMailOpen.myFooterBar.myAcceptBtn.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseRollOverHandle);
               this.myMailOpen.myFooterBar.myDeclineBtn.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseRollOverHandle);
            }
            else if(this.m_isExpire)
            {
               this.myMailOpen.myFooterBar.myDeclineBtn.visible = false;
               this.myMailOpen.myFooterBar.myAcceptBtn.visible = true;
               this.myMailOpen.myFooterBar.acceptText = Dict.SHOW_DETAIL;
               this.myMailOpen.myFooterBar.setAcceptCallback(this.onAcceptCallback);
            }
            else
            {
               this.myMailOpen.myFooterBar.myDeclineBtn.visible = false;
               this.myMailOpen.myFooterBar.myAcceptBtn.visible = false;
            }
            this.calculateEmailHeight();
         }
         else
         {
            this.m_mailHeight = this.myMailClosed.height;
         }
      }
      
      private function fillAttachment() : void
      {
         this.myMailOpen.myFooterBar.myAttachmentArrowLeft.visible = this.myMailOpen.myFooterBar.myAttachmentArrowRight.visible = this.m_attachmentArray.length > 1;
         this.myMailOpen.myFooterBar.myAttachmentCountLabel.visible = this.myMailOpen.myFooterBar.myAttachmentCountText.visible = true;
         this.m_currentAttachmentIndex = 0;
         this.showAttachmentByOrder(this.m_currentAttachmentIndex);
         this.refreshArrowState();
      }
      
      private function noAttachment() : void
      {
         this.myMailOpen.myFooterBar.myAttachmentArrowLeft.visible = this.myMailOpen.myFooterBar.myAttachmentArrowRight.visible = false;
         this.myMailOpen.myFooterBar.myAttachmentCountLabel.visible = this.myMailOpen.myFooterBar.myAttachmentCountText.visible = false;
      }
      
      private function showAttachmentByOrder(order:int) : void
      {
         var attachment:MailAttachmentObjForMailObj = this.m_attachmentArray[order] as MailAttachmentObjForMailObj;
         var prod:ProductObj = ItemUtil.getProductObjByProductId(attachment.attachmentProdId);
         this.myAttachment.setData(prod);
         this.myMailOpen.myFooterBar.myAttachmentCountText.text = String(order + 1) + "/" + String(this.m_attachmentArray.length);
      }
      
      private function onAttachmentLeftClicked(e:MouseEvent) : void
      {
         if(this.m_currentAttachmentIndex - 1 < 0)
         {
            return;
         }
         --this.m_currentAttachmentIndex;
         this.showAttachmentByOrder(this.m_currentAttachmentIndex);
         this.refreshArrowState();
      }
      
      private function onAttachmentRightClicked(e:MouseEvent) : void
      {
         if(this.m_currentAttachmentIndex + 1 >= this.m_attachmentArray.length)
         {
            return;
         }
         ++this.m_currentAttachmentIndex;
         this.showAttachmentByOrder(this.m_currentAttachmentIndex);
         this.refreshArrowState();
      }
      
      private function refreshArrowState() : void
      {
         if(this.m_attachmentArray.length > 1)
         {
            this.myMailOpen.myFooterBar.myAttachmentArrowLeft.visible = this.m_currentAttachmentIndex <= 0 ? false : true;
            this.myMailOpen.myFooterBar.myAttachmentArrowRight.visible = this.m_currentAttachmentIndex >= this.m_attachmentArray.length - 1 ? false : true;
         }
      }
      
      public function getEmailHeight() : Number
      {
         return this.m_mailHeight;
      }
      
      private function calculateEmailHeight() : void
      {
         var message:MovieClip = Boolean(this.myMailOpen.myMailMessage.visible) ? this.myMailOpen.myMailMessage : this.myMailOpen.myMailAttMessage;
         this.m_mailHeight = message.y + message.myTextTF.textHeight + this.MAIL_CONTEXT_MARGIN;
         if(this.m_mailHeight < this.m_defaultOpenBgHeight)
         {
            this.m_mailHeight = this.m_defaultOpenBgHeight;
         }
         this.myMailOpen.myMailBG.height = this.m_mailHeight;
         this.myMailOpen.myFooterBar.y = this.m_mailHeight - this.myMailOpen.myFooterBar.height - 1;
      }
      
      public function setAcceptCallback(func:Function) : void
      {
         this.m_acceptBtn = func;
      }
      
      public function onAcceptCallback() : void
      {
         FsgAudioUtil.getInstance().playSound(SE_ID.UI_MENU_ROLLOUT_PROCEED);
         this.m_acceptBtn(this.m_OrderNum);
      }
      
      public function setDeclineCallback(func:Function) : void
      {
         this.m_declineBtn = func;
      }
      
      public function onDeclineCallback() : void
      {
         FsgAudioUtil.getInstance().playSound(SE_ID.UI_MENU_ROLLOUT_PROCEED);
         this.m_declineBtn(this.m_OrderNum);
      }
      
      public function setDeleteCallback(func:Function) : void
      {
         this.m_onDeleteCallback = func;
      }
      
      public function onDeleteCallback() : void
      {
         FsgAudioUtil.getInstance().playSound(SE_ID.UI_SOCIALPANEL_MSG_DELETED);
         this.m_onDeleteCallback(this.m_OrderNum);
      }
      
      public function setBtnCallback(func:Function) : void
      {
         this.m_onCallback = func;
      }
      
      public function onSelectedCallback() : void
      {
         this.emailRead = true;
         this.setMailOpened(true);
         this.m_onCallback(this.m_OrderNum);
      }
      
      private function onMouseRollOverHandle(cEvt:MouseEvent) : void
      {
         FsgAudioUtil.getInstance().playSound(SE_ID.GENERAL_ROLLOVER);
      }
   }
}

