package codo.views.supplyDrop_parts
{
   import codo.base.BaseSubElement;
   import codo.component.Button;
   import codo.component.TextField;
   import codo.constants.BCEvent;
   import codo.event.ParaEvent;
   import codo.objects.ProductObj;
   import codo.style.SupplyDropGuide;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   public class SupplyDropRewardItemPanel extends BaseSubElement
   {
      
      public var myHeaderTF:codo.component.TextField;
      
      public var myImageIconContainer:SupplyDropRewardItemSamplesContainer;
      
      public var myContentHeaderTF:flash.text.TextField;
      
      public var myContentDescriptionTF:flash.text.TextField;
      
      public var myCallToActionBtn:Button;
      
      public var myBkg:Sprite;
      
      public var myFlash:MovieClip;
      
      public var myProgressCircleLarge:SupplyDropRewardItemCircleDiagram;
      
      private var mDecorator:BaseSupplyDropRewardPanelDecorator;
      
      private var mItems:Vector.<ProductObj>;
      
      private var mRefreshUIAfterInventoryChangeCallback:Function;
      
      private var mCallToActionBtnClickedCallback:Function;
      
      public function SupplyDropRewardItemPanel()
      {
         super();
         mouseInteractivity = true;
         this.myHeaderTF.textStyle = SupplyDropGuide.styleSupplyDropHeader;
         this.myCallToActionBtn.myLabel.textStyle = SupplyDropGuide.styleSupplyDropViewItemsButton;
         this.myCallToActionBtn.height = 30;
         this.myCallToActionBtn.width = 200;
         this.myProgressCircleLarge.visible = false;
         this.myFlash.gotoAndStop(1);
      }
      
      public function registerRefreshUIAfterInventoryChangeCallback(callback:Function) : void
      {
         this.mRefreshUIAfterInventoryChangeCallback = callback;
      }
      
      public function registerCalltoActionBtnClickedCallback(callback:Function) : void
      {
         this.mCallToActionBtnClickedCallback = callback;
      }
      
      public function set items(items:Vector.<ProductObj>) : void
      {
         this.mItems = items;
      }
      
      override public function active() : void
      {
         super.active();
         this.myImageIconContainer.resetTimer();
         this.myImageIconContainer.setData(this.mItems);
         listen(BCEvent.EVT_REFRESH_UI_AFTER_INVENTORY_CHANGE,this.onRefreshUIAfterInventoryChange);
         this.onRefreshUIAfterInventoryChange();
         this.myCallToActionBtn.registerClickEvent(this.onCallToActionBtnClicked);
      }
      
      override public function deactive() : void
      {
         super.deactive();
         this.myImageIconContainer.killAllTweens();
         this.myImageIconContainer.resetTimer();
         unlisten(BCEvent.EVT_REFRESH_UI_AFTER_INVENTORY_CHANGE,this.onRefreshUIAfterInventoryChange);
         this.myCallToActionBtn.unRegisterClickEvent(this.onCallToActionBtnClicked);
      }
      
      public function openItemsToWinPopup(isFeatured:Boolean) : void
      {
         if(!isFeatured)
         {
            broadcast(BCEvent.EVT_GOTO_SUPPLY_DROP_ITEMS_TO_WIN_POPUP);
            return;
         }
         broadcast(BCEvent.EVT_GOTO_SUPPLY_DROP_ITEMS_TO_WIN_POPUP,{"isFeatured":true});
      }
      
      public function set decorator(decorator:BaseSupplyDropRewardPanelDecorator) : void
      {
         this.mDecorator = decorator;
         this.mDecorator.decorate();
      }
      
      private function onRefreshUIAfterInventoryChange(cEvt:ParaEvent = null) : void
      {
         if(this.mRefreshUIAfterInventoryChangeCallback != null)
         {
            this.mRefreshUIAfterInventoryChangeCallback();
         }
      }
      
      private function onCallToActionBtnClicked() : void
      {
         if(this.mCallToActionBtnClickedCallback != null)
         {
            this.mCallToActionBtnClickedCallback();
         }
      }
   }
}

