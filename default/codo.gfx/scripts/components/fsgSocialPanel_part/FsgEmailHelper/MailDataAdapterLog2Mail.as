package components.fsgSocialPanel_part.FsgEmailHelper
{
   import codo.utils.LocalizeUtil;
   
   public class MailDataAdapterLog2Mail extends MailDataAdapterFriendInvites2Mail
   {
      
      public function MailDataAdapterLog2Mail()
      {
         super();
      }
      
      override public function adaptOneObject(rawObj:Object) : Object
      {
         var adaptedObj:Object = null;
         if(Boolean(rawObj.isLog))
         {
            adaptedObj = super.adaptOneObject(rawObj);
            adaptedObj.isInvites = false;
            adaptedObj.title = LocalizeUtil.param(rawObj.title,[rawObj.senderName]);
            adaptedObj.message = rawObj.message;
            adaptedObj.fsgMailType = FsgMailType.MAIL_TYPE_SYSTEM;
            return adaptedObj;
         }
         return null;
      }
   }
}

