package codo.views
{
   import codo.base.PopupView;
   import codo.common.CFunctionContainer;
   import codo.component.TextField;
   import codo.constants.BCEvent;
   import codo.event.ParaEvent;
   import codo.localization.DictSetting;
   import codo.style.GlobalGuide;
   import codo.style.MOTDGuide;
   import codo.utils.LocalizeUtil;
   import codo.views.motd_parts.MOTDFilter;
   import flash.events.Event;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import fsg.util.ImageHolderSimple;
   
   public class MOTDPopupBaseView extends PopupView
   {
      
      protected static const CONTENT_PADDING:int = 10;
      
      protected static const CONTENT_GUTTER:int = 20;
      
      protected static const LOCALIZE:Function = LocalizeUtil.localize;
      
      protected static const MAX_POPUP_WEB_WIDTH:int = 1076;
      
      protected static const MAX_POPUP_WEB_HEIGHT:int = 768;
      
      protected static const MAX_POPUP_CONTENT_WIDTH:int = 967;
      
      protected static const MAX_POPUP_TEXT_ONLY_WIDTH:int = 760;
      
      public var myPopupHeaderTF:codo.component.TextField;
      
      public var myContentTitleTF:codo.component.TextField;
      
      public var myContentBodyTF:flash.text.TextField;
      
      public var myContentDateTF:codo.component.TextField;
      
      public var myFilter:MOTDFilter;
      
      public var myContentImageHolder:ImageHolderSimple;
      
      private var mImageURL:String;
      
      public function MOTDPopupBaseView()
      {
         var FRAME_BORDER_OFFSET:int = 0;
         super();
         FRAME_BORDER_OFFSET = 14;
         this.myPopupHeaderTF.textStyle = GlobalGuide.styleTextHeader;
         this.myContentTitleTF.textStyle = MOTDGuide.styleMOTDTitle;
         this.myContentDateTF.textStyle = MOTDGuide.styleMOTDDate;
         myPopup.configConfirmButton(DictSetting.CLOSE_SETTING,this.onClosePopup,true);
         myPopup.header.visible = false;
         this.myFilter.y += this.myPopupHeaderTF.textHeight + CONTENT_PADDING;
         myPopup.y = this.myFilter.y - FRAME_BORDER_OFFSET;
         this.myFilter.singleOptionMode = true;
         this.myFilter.addOnCategoryClickCallback(this.onCategoryCheckedCallback);
         this.myFilter.addOnSubCategoryCheckedCallback(this.onSubCategoryCheckedCallback);
         this.myContentBodyTF.autoSize = TextFieldAutoSize.LEFT;
      }
      
      override protected function enableData() : void
      {
         super.enableData();
         this.listen(BCEvent.EVT_DOWNLOAD_MOTD_IMAGE_COMPLETE,this.onMOTDImageDownloadComplete);
         this.listen(BCEvent.EVT_WEBPAGE_OPEN_INGAME_URL,this.onWebPageOpenInGameUrl);
      }
      
      override protected function disableData() : void
      {
         super.disableData();
         this.unlisten(BCEvent.EVT_DOWNLOAD_MOTD_IMAGE_COMPLETE,this.onMOTDImageDownloadComplete);
         this.unlisten(BCEvent.EVT_WEBPAGE_OPEN_INGAME_URL,this.onWebPageOpenInGameUrl);
      }
      
      private function onMOTDImageDownloadComplete(cEvt:ParaEvent) : void
      {
         var success:Boolean = Boolean(cEvt.myPara.success);
         if(success)
         {
            this.myContentImageHolder.addEventListener(Event.COMPLETE,this.onImageLoaded);
            this.myContentImageHolder.setImage(this.mImageURL);
         }
      }
      
      private function onWebPageOpenInGameUrl(cEvt:ParaEvent) : void
      {
         this.onClosePopup();
         this.hideView();
      }
      
      override public function set headerTitle(txt:String) : void
      {
         this.myPopupHeaderTF.text = txt;
      }
      
      protected function set motdTitle(txt:String) : void
      {
         this.myContentTitleTF.text = LOCALIZE(txt);
         this.myContentTitleTF.visible = txt == "" ? false : true;
      }
      
      protected function set motdBody(txt:String) : void
      {
         this.myContentBodyTF.text = LOCALIZE(txt);
         this.myContentBodyTF.visible = txt == "" ? false : true;
      }
      
      protected function set motdDate(txt:String) : void
      {
         this.myContentDateTF.text = txt;
         this.myContentDateTF.visible = txt == "" ? false : true;
      }
      
      protected function set motdImage(imgURL:String) : void
      {
         this.mImageURL = imgURL;
         if(this.mImageURL.length > 0)
         {
            CFunctionContainer.AS_RequestDownloadImage(imgURL);
         }
      }
      
      protected function onImageLoaded(e:Event) : void
      {
         if(this.mImageURL.length <= 0)
         {
            return;
         }
         this.myContentImageHolder.removeEventListener(Event.COMPLETE,this.onImageLoaded);
         this.myContentImageHolder.visible = true;
         this.positionAssets();
      }
      
      protected function clearContent() : void
      {
         this.motdDate = "";
         this.motdTitle = "";
         this.motdBody = "";
         this.myContentImageHolder.clearImage();
         this.myContentImageHolder.visible = false;
      }
      
      protected function positionAssets() : void
      {
         this.myContentDateTF.x = this.myContentTitleTF.x = this.myContentBodyTF.x = myPopup.x + 28;
         this.myContentImageHolder.x = this.myContentDateTF.x + 3;
         this.myContentDateTF.y = this.myContentTitleTF.y = myPopup.y + 45;
         if(this.myContentDateTF.visible)
         {
            this.myContentTitleTF.y = this.myContentDateTF.y + this.myContentDateTF.textHeight + CONTENT_PADDING;
         }
         if(this.myContentBodyTF.visible)
         {
            this.myContentBodyTF.y = this.myContentTitleTF.y + this.myContentTitleTF.textHeight + CONTENT_PADDING;
         }
      }
      
      protected function onCategoryCheckedCallback() : void
      {
      }
      
      protected function onSubCategoryCheckedCallback() : void
      {
      }
      
      override protected function hideView() : void
      {
         super.hideView();
         this.clearContent();
      }
      
      private function onClosePopup() : void
      {
         closePopupView();
      }
   }
}

