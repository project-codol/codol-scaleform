package components.fsgSocialPanel_part.FsgEmailHelper
{
   import codo.localization.DictInvitation;
   import codo.utils.LocalizeUtil;
   
   public class MailDataAdapterFriendInvites2Mail extends MailDataAdapterMail2Mail
   {
      
      public function MailDataAdapterFriendInvites2Mail()
      {
         super();
      }
      
      override public function adaptOneObject(rawObj:Object) : Object
      {
         var adaptedObj:Object = new Object();
         adaptedObj.id = rawObj.id;
         adaptedObj.senderID = rawObj.senderID;
         adaptedObj.senderName = rawObj.senderName;
         adaptedObj.title = rawObj.title;
         adaptedObj.message = LocalizeUtil.param(DictInvitation.FRIEND_RELATIONSHIP_REQUEST,[rawObj.senderName]);
         adaptedObj.timeStamp = rawObj.formattedTime;
         adaptedObj.isAttached = false;
         adaptedObj.isInvites = true;
         adaptedObj.isRead = rawObj.isRead;
         adaptedObj.fsgMailType = FsgMailType.MAIL_TYPE_FRIEND_INVITE;
         return adaptedObj;
      }
   }
}

