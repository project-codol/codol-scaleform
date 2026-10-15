package codo.views
{
   import codo.constants.BCEvent;
   import codo.event.ParaEvent;
   import codo.localization.Dict;
   import codo.utils.LocalizeUtil;
   import com.greensock.TweenLite;
   import com.greensock.easing.Linear;
   import components.asympvp_part.AsymPurchasePopupViewContent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import fsg.shared.popups.PopupBaseView;
   
   public class AsymPurchasePopupView extends PopupBaseView
   {
      
      private var mContent:AsymPurchasePopupViewContent;
      
      public var myPopupTitleTF:TextField;
      
      public var myPopupSubTitleTF:TextField;
      
      public function AsymPurchasePopupView()
      {
         super();
         this.mContent = myContent as AsymPurchasePopupViewContent;
         this.myPopupTitleTF.autoSize = this.myPopupSubTitleTF.autoSize = TextFieldAutoSize.LEFT;
         this.myPopupSubTitleTF.multiline = true;
         this.myPopupSubTitleTF.wordWrap = true;
         this.myPopupTitleTF.alpha = this.myPopupSubTitleTF.alpha = 0;
      }
      
      override public function set routeData(data:*) : void
      {
         this.mContent.refreshButtons(data == true);
      }
      
      override protected function onInit() : void
      {
         this.mContent.initContent(closePopupView);
      }
      
      override protected function showView() : void
      {
         this.mContent.refreshLoadout();
         super.showView();
         listen(BCEvent.EVT_REFRESH_UI_AFTER_INVENTORY_CHANGE,this.onInventoryChangedHandler);
      }
      
      override protected function hideView() : void
      {
         TweenLite.to(this.myPopupTitleTF,ANIMATION_SPEED,{
            "alpha":0,
            "ease":Linear.easeOut,
            "overwrite":1
         });
         TweenLite.to(this.myPopupSubTitleTF,ANIMATION_SPEED,{
            "alpha":0,
            "ease":Linear.easeOut,
            "overwrite":1
         });
         unlisten(BCEvent.EVT_REFRESH_UI_AFTER_INVENTORY_CHANGE,this.onInventoryChangedHandler);
         super.hideView();
      }
      
      private function onInventoryChangedHandler(cEvt:ParaEvent) : void
      {
         this.mContent.refreshLoadout();
      }
      
      override protected function positionView() : void
      {
         super.positionView();
         this.myPopupTitleTF.text = LocalizeUtil.localize(Dict.ASYM_PURCHASE_POPUP_TITLE).toUpperCase();
         this.myPopupSubTitleTF.htmlText = LocalizeUtil.localize(Dict.ASYM_PURCHASE_POPUP_DESC);
         this.myPopupSubTitleTF.y = myContent.y - (this.myPopupSubTitleTF.height + 10);
         this.myPopupTitleTF.y = this.myPopupSubTitleTF.y - this.myPopupTitleTF.height;
         this.myPopupTitleTF.x = this.myPopupSubTitleTF.x = myContent.x;
      }
      
      override protected function transitionInComplete() : void
      {
         TweenLite.to(this.myPopupTitleTF,ANIMATION_SPEED,{
            "alpha":1,
            "ease":Linear.easeIn,
            "overwrite":1
         });
         TweenLite.to(this.myPopupSubTitleTF,ANIMATION_SPEED,{
            "alpha":1,
            "ease":Linear.easeIn,
            "overwrite":1
         });
      }
   }
}

