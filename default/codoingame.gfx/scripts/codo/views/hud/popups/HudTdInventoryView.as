package codo.views.hud.popups
{
   import codo.common.CFunctionCommonContainer;
   import codo.component.CloseButton;
   import codo.constants.BCInGameEvent;
   import codo.constants.HUDPopupComponentTypes;
   import codo.event.ParaEvent;
   import codo.views.hud.HUDPopupComponent;
   import codo.views.hud.popups.hudTdShare.HudTdItemDetailBox;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   
   public class HudTdInventoryView extends HUDPopupComponent
   {
      
      public var myDetailBox:HudTdItemDetailBox;
      
      public var myCloseBtn:CloseButton;
      
      public function HudTdInventoryView()
      {
         super();
      }
      
      override public function get CompType() : int
      {
         return HUDPopupComponentTypes.TD_INVENTORY;
      }
      
      override protected function showView() : void
      {
         super.showView();
         this.myDetailBox.visible = false;
         listen(BCInGameEvent.EVT_TD_SHOW_ITEM_DETAIL_BOX,this.onShowItemDetailBox);
         listen(BCInGameEvent.EVT_TD_HIDE_ITEM_DETAIL_BOX,this.onHideItemDetailBox);
         this.myCloseBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.onCloseBtnClicked);
      }
      
      override protected function hideView() : void
      {
         super.hideView();
         unlisten(BCInGameEvent.EVT_TD_SHOW_ITEM_DETAIL_BOX,this.onShowItemDetailBox);
         unlisten(BCInGameEvent.EVT_TD_HIDE_ITEM_DETAIL_BOX,this.onHideItemDetailBox);
         this.myCloseBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.onCloseBtnClicked);
      }
      
      public function onShowItemDetailBox(evt:ParaEvent) : void
      {
         var lootItemIndex:int = evt.myPara.lootItemIndex as int;
         var position:Point = evt.myPara.position as Point;
         if(lootItemIndex == 0)
         {
            this.myDetailBox.visible = false;
            return;
         }
         position = this.globalToLocal(position);
         this.myDetailBox.lootItemIndex = lootItemIndex;
         this.myDetailBox.x = position.x;
         this.myDetailBox.y = position.y;
         this.myDetailBox.visible = true;
      }
      
      public function onHideItemDetailBox(evt:ParaEvent) : void
      {
         this.myDetailBox.visible = false;
      }
      
      private function onCloseBtnClicked(cEvt:MouseEvent) : void
      {
         CFunctionCommonContainer.ScriptMenuResponse("td_inventory","quit");
      }
      
      override public function onKeyboardEvent(cEvt:KeyboardEvent) : void
      {
         if(cEvt.keyCode == Keyboard.ESCAPE)
         {
            CFunctionCommonContainer.ScriptMenuResponse("td_inventory","quit");
         }
      }
   }
}

