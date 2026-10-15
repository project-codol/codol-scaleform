package components.fsgSocialPanel_part.FsgEmailHelper
{
   import codo.utils.LocalizeUtil;
   
   public class MailDataAdapterSystemMessage2Mail extends MailDataAdapterFriendInvites2Mail
   {
      
      public function MailDataAdapterSystemMessage2Mail()
      {
         super();
      }
      
      override public function adaptOneObject(rawObj:Object) : Object
      {
         var adaptedObj:Object = super.adaptOneObject(rawObj);
         adaptedObj.isInvites = false;
         adaptedObj.title = LocalizeUtil.param(rawObj.title,[rawObj.senderName]);
         adaptedObj.message = LocalizeUtil.localize(rawObj.content);
         adaptedObj.fsgMailType = FsgMailType.MAIL_TYPE_SYSTEM;
         return adaptedObj;
      }
   }
}

