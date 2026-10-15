package codo.component.social
{
   import codo.component.core.UIInteractiveComponent;
   
   public class PageListSelector extends UIInteractiveComponent
   {
      
      public static const PREV_BTN_INDEX:int = 0;
      
      public static const NEXT_BTN_INDEX:int = 1;
      
      private static const BTN_GAP:int = 5;
      
      public var myPrevBtn:PageListSelectorBtn;
      
      public var myNextBtn:PageListSelectorBtn;
      
      public var mHasPrevPage:Boolean;
      
      public var mHasNextPage:Boolean;
      
      private var mSelectorClickedHandler:Function;
      
      public function PageListSelector()
      {
         super();
         this.initStage();
      }
      
      private function initStage() : void
      {
         this.myPrevBtn.setButtonType(PageListSelectorBtn.PREV_BTN);
         this.myNextBtn.setButtonType(PageListSelectorBtn.NEXT_BTN);
         this.myPrevBtn.registerClickEvent(this.onBtnClickHandler,this.myPrevBtn);
         this.myNextBtn.registerClickEvent(this.onBtnClickHandler,this.myNextBtn);
      }
      
      public function set hasPrevPage(value:Boolean) : void
      {
         this.mHasPrevPage = value;
         this.myPrevBtn.enabled = value;
      }
      
      public function set hasNextPage(value:Boolean) : void
      {
         this.mHasNextPage = value;
         this.myNextBtn.enabled = value;
      }
      
      public function registerClickedHandler(handler:Function) : void
      {
         this.mSelectorClickedHandler = handler;
      }
      
      private function onBtnClickHandler(btn:PageListSelectorBtn) : void
      {
         if(null != this.mSelectorClickedHandler)
         {
            this.mSelectorClickedHandler(btn == this.myPrevBtn ? PREV_BTN_INDEX : NEXT_BTN_INDEX);
         }
      }
   }
}

