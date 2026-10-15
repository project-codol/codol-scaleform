package codo.views.hud.popups.hudTdLoadoutView_parts
{
   import codo.common.CFunctionInGameContainer;
   import codo.component.CloseButton;
   import codo.constants.BCInGameEvent;
   import codo.manager.EventManager;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import fsg.util.FsgImageHolder;
   
   public class HudTdLoadoutViewSlotBase extends MovieClip
   {
      
      public var myDropButton:CloseButton;
      
      public var myImage:FsgImageHolder;
      
      public var myHitArea:MovieClip;
      
      protected var mLootItemIndex:int;
      
      public function HudTdLoadoutViewSlotBase()
      {
         super();
         this.myHitArea.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         this.myHitArea.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         this.myHitArea.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseClick);
         if(this.myDropButton != null)
         {
            this.myDropButton.addEventListener(MouseEvent.MOUSE_DOWN,this.onDropButtonClick);
         }
         this.lootItemIndex = 0;
      }
      
      public function set lootItemIndex(lootItemIndex:int) : void
      {
         this.mLootItemIndex = lootItemIndex;
         var itemInfo:Object = CFunctionInGameContainer.AS_TD_GetLootItemInfo(lootItemIndex);
         if(itemInfo == null)
         {
            this.myImage.setImage("");
            return;
         }
         this.myImage.setImage(itemInfo.icon);
      }
      
      public function get lootItemIndex() : int
      {
         return this.mLootItemIndex;
      }
      
      private function onMouseOver(cEvt:MouseEvent) : void
      {
         var x:Number = this.myHitArea.x + this.myHitArea.width / 2;
         var y:Number = this.myHitArea.y + this.myHitArea.height / 2;
         var position:Point = localToGlobal(new Point(x,y));
         EventManager.getInstance().broadcast(BCInGameEvent.EVT_TD_SHOW_ITEM_DETAIL_BOX,{
            "lootItemIndex":this.mLootItemIndex,
            "position":position
         });
      }
      
      private function onMouseOut(cEvt:MouseEvent) : void
      {
         EventManager.getInstance().broadcast(BCInGameEvent.EVT_TD_HIDE_ITEM_DETAIL_BOX);
      }
      
      private function onMouseClick(cEvt:MouseEvent) : void
      {
         this.onClick();
      }
      
      private function onDropButtonClick(cEvt:MouseEvent) : void
      {
         this.onDrop();
      }
      
      protected function onClick() : void
      {
      }
      
      protected function onDrop() : void
      {
      }
   }
}

