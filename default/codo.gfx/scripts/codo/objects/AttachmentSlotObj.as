package codo.objects
{
   public dynamic class AttachmentSlotObj extends ItemSlotObj
   {
      
      public static const ATTACHMENT_TYPE_FUNCTIONAL:int = 0;
      
      public static const ATTACHMENT_TYPE_COSMATIC:int = 1;
      
      public var attachmentType:int;
      
      public var isFunctional:Boolean = false;
      
      public function AttachmentSlotObj(cObj:Object = null)
      {
         super(cObj);
         this.isFunctional = this.attachmentType == ATTACHMENT_TYPE_FUNCTIONAL;
      }
   }
}

