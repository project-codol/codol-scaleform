package codo.objects
{
   import codo.constants.MailType;
   
   public dynamic class MailObj extends CustomObject
   {
      
      public var id:String = "";
      
      public var receivers:Array = [];
      
      public var senderName:String = "";
      
      public var senderID:String = "";
      
      public var timeStamp:String = "";
      
      public var formattedTime:String = "";
      
      public var title:String = "";
      
      public var message:String = "";
      
      public var isRead:Boolean = true;
      
      public var isAttached:Boolean = false;
      
      public var isAlerted:Boolean = false;
      
      public var isExpired:Boolean = false;
      
      public var mailAttachmentArray:Array = [];
      
      public var mailSize:int = 0;
      
      public var mailType:int = MailType.NORMAL;
      
      public function MailObj(cObj:Object = null)
      {
         super(cObj);
      }
      
      public function addAttachment(att:String, attName:String = "", attDesc:String = "", attImgURL:String = "") : void
      {
         var newAttachment:MailAttachmentObjForMailObj = new MailAttachmentObjForMailObj();
         newAttachment.attachment = att;
         newAttachment.attachmentName = attName;
         newAttachment.attachmentDesc = attDesc;
         newAttachment.attachmentImgURL = attImgURL;
         this.mailAttachmentArray.push(newAttachment);
      }
      
      public function removeAttachmentByIdx(idx:int) : void
      {
         this.mailAttachmentArray.splice(idx,1);
      }
      
      public function getAttachmentStringArray() : Array
      {
         var i:int = 0;
         for(var tarray:Array = new Array(); i < this.mailAttachmentArray.length; )
         {
            tarray.push(this.mailAttachmentArray[i].attachment);
            i++;
         }
         return tarray;
      }
   }
}

