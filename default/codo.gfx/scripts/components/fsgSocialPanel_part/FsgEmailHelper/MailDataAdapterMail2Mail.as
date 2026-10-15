package components.fsgSocialPanel_part.FsgEmailHelper
{
   import codo.constants.MailType;
   
   public class MailDataAdapterMail2Mail implements IFsgMailDataAdapter
   {
      
      public function MailDataAdapterMail2Mail()
      {
         super();
      }
      
      public function adaptArray(rawArray:Array) : Array
      {
         var adaptedObj:Object = null;
         var adaptedArray:Array = new Array();
         var rawDataCount:int = int(rawArray.length);
         for(var i:int = 0; i < rawDataCount; i++)
         {
            adaptedObj = this.adaptOneObject(rawArray[i]);
            if(adaptedObj != null)
            {
               adaptedObj.rawData = rawArray[i];
               adaptedArray.push(adaptedObj);
            }
         }
         return adaptedArray;
      }
      
      public function adaptOneObject(rawObj:Object) : Object
      {
         rawObj.isInvites = false;
         if(Boolean(rawObj.isAttached))
         {
            rawObj.fsgMailType = FsgMailType.MAIL_TYPE_REWARD;
         }
         else
         {
            if(rawObj.mailType != MailType.SYSTEM)
            {
               return null;
            }
            rawObj.fsgMailType = FsgMailType.MAIL_TENCENT_MAIL;
         }
         return rawObj;
      }
   }
}

