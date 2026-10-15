package codo.component.loadout
{
   public class WeaponHotkeyLoadoutButton extends HotkeyLoadoutButton
   {
      
      private static const IMAGE_SIZE:Number = 220;
      
      public var myAttachment0:SDPlusAttachSlot;
      
      public var myAttachment1:SDPlusAttachSlot;
      
      public var myAttachment2:SDPlusAttachSlot;
      
      public var myAttachment3:SDPlusAttachSlot;
      
      public var myAttachment4:SDPlusAttachSlot;
      
      public function WeaponHotkeyLoadoutButton()
      {
         super();
      }
      
      override public function setData(data:*) : void
      {
         super.setData(data);
      }
      
      public function setAttachments(attachments:Array) : void
      {
         this.myAttachment0.setData(attachments[0]);
         this.myAttachment1.setData(attachments[1]);
         this.myAttachment2.setData(attachments[2]);
         this.myAttachment3.setData(attachments[3]);
         this.myAttachment4.setData(attachments[4]);
      }
      
      override public function draw() : void
      {
         mWidth = 265;
         mHeight = 200;
         super.draw();
         this.myAttachment0.x = this.myAttachment1.x = this.myAttachment2.x = myBackground.x + myBackground.width - 48;
         myImage.width = myImage.height = IMAGE_SIZE;
         myImage.x = 0;
         myImage.y = 0;
      }
      
      override protected function positionHotkey() : void
      {
      }
   }
}

