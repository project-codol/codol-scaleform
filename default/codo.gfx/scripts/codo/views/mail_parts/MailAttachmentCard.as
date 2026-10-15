package codo.views.mail_parts
{
   import codo.component.core.ItemCardBase;
   import codo.style.GlobalGuide;
   import codo.style.MarketGuide;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import scaleform.gfx.TextFieldEx;
   
   public class MailAttachmentCard extends ItemCardBase
   {
      
      public var myInnerOutline:MovieClip;
      
      public var myTierCornerFill:MovieClip;
      
      public var mySubNameTF:TextField;
      
      public function MailAttachmentCard()
      {
         super();
      }
      
      override public function setData(data:*) : void
      {
         super.setData(data);
         TextFieldEx.setVerticalAlign(myItemNameTF,TextFieldEx.VALIGN_BOTTOM);
         GlobalGuide.formatComponentsByTier(MarketGuide.COLOR_BY_TIER[data.tier],new <DisplayObject>[this.myInnerOutline,this.myTierCornerFill]);
         this.mySubNameTF.text = data.attachmentDesc;
         myItemCategoryTF.visible = myBuffs.visible = false;
      }
      
      override public function get height() : Number
      {
         return myHitArea.height;
      }
      
      override protected function checkUseIconHolderForImage() : Boolean
      {
         return false;
      }
   }
}

