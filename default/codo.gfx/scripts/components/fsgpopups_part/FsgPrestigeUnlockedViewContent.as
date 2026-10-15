package components.fsgpopups_part
{
   import codo.common.CFunctionCommonContainer;
   import codo.constants.BCEvent;
   import codo.constants.UIStencils;
   import codo.localization.Dict;
   import codo.localization.DictSystem;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import fsg.shared.popups.PopupContentBase;
   
   public class FsgPrestigeUnlockedViewContent extends PopupContentBase
   {
      
      public static const TEXT_PADDING:uint = 10;
      
      public var myDetailsTF:TextField;
      
      public var myAdditionalTF:TextField;
      
      public var myImageTitle:TextField;
      
      public var myImageSubtitle:TextField;
      
      public var myOutline:Sprite;
      
      public var myUnlockBG:Sprite;
      
      public function FsgPrestigeUnlockedViewContent()
      {
         super();
         this.myDetailsTF.autoSize = TextFieldAutoSize.LEFT;
         this.myDetailsTF.wordWrap = this.myDetailsTF.multiline = true;
         this.myAdditionalTF.autoSize = TextFieldAutoSize.LEFT;
         this.myAdditionalTF.wordWrap = this.myDetailsTF.multiline = true;
         this.myImageTitle.autoSize = TextFieldAutoSize.LEFT;
         this.myImageSubtitle.autoSize = TextFieldAutoSize.LEFT;
      }
      
      override protected function configPopUpBase() : void
      {
         myPopupBase.headerText = LOCALIZE(Dict.PRESTIGE_UNLOCKED_POPUP_TITLE).toUpperCase();
         myPopupBase.subheaderText = LOCALIZE(Dict.PRESTIGE_UNLOCKED_POPUP_SUBTITLE).toUpperCase();
         this.myDetailsTF.text = LOCALIZE(Dict.PRESTIGE_UNLOCKED_POPUP_DESCRIPTION).toUpperCase();
         this.myAdditionalTF.text = LOCALIZE(Dict.PRESTIGE_UNLOCKED_POPUP_ADDITIONAL).toUpperCase();
         this.myImageTitle.text = "REPLACE ME WITH DATA";
         this.myImageSubtitle.text = "REPLACE ME WITH DATA";
         this.myImageTitle.visible = false;
         this.myImageSubtitle.visible = false;
         super.configPopUpBase();
         var contentPos:Point = myPopupBase.contentPosition;
         var BOTTOM_PADDING:uint = 50;
         myPopupBase.animateFrame = true;
         this.myDetailsTF.x = contentPos.x + CONTENT_PADDING;
         this.myOutline.x = this.viewWidth * 0.5 - this.myOutline.width * 0.5;
         this.myUnlockBG.x = this.myOutline.x;
         this.myAdditionalTF.x = contentPos.x + CONTENT_PADDING;
         this.myImageTitle.x = this.myOutline.x + TEXT_PADDING;
         this.myImageSubtitle.x = this.myImageTitle.x;
         this.myImageSubtitle.y = this.myOutline.y + this.myOutline.height - this.myImageSubtitle.textHeight - TEXT_PADDING;
         this.myImageTitle.y = this.myImageSubtitle.y - this.myImageTitle.textHeight;
         myPopupBase.setSize(this.viewWidth,this.viewHeight);
         myPopupBase.configConfirmButton(LOCALIZE(DictSystem.CONFIRM).toUpperCase(),this.onProceedBtnClickHandle);
      }
      
      protected function onProceedBtnClickHandle() : void
      {
         this.broadcast(BCEvent.EVT_CLOSE_UI_UNLOCK_NOTI_VIEW);
         CFunctionCommonContainer.AS_SetStencilFlag(UIStencils.UI_PRESTIGE_UNLOCKED_POPUP_VIEWED);
      }
      
      override protected function get viewWidth() : uint
      {
         return 852;
      }
      
      override protected function get viewHeight() : uint
      {
         return 452;
      }
   }
}

