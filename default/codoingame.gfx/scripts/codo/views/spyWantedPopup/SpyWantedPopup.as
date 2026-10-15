package codo.views.spyWantedPopup
{
   import codo.constants.HUDPopupComponentTypes;
   import codo.views.hud.HUDPopupComponent;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   
   public class SpyWantedPopup extends HUDPopupComponent
   {
      
      private static const MSG_CLOSE:int = 0;
      
      private static const MSG_WANTED:int = 1;
      
      public var myConfirmDialog:WantedPopupConfirmDialog;
      
      public var myPopupDialog:SpyWantedPopupDialog;
      
      public function SpyWantedPopup()
      {
         super();
         this.myConfirmDialog.setCancelCallback(this.onCancelPlayerWanted);
         this.myConfirmDialog.setConfirmCallback(this.onConfirmPlayerWanted);
         this.myPopupDialog.setWantedClickCallback(this.onSetWanted);
         this.myPopupDialog.setCloseClickCallback(this.close);
      }
      
      override public function get CompType() : int
      {
         return HUDPopupComponentTypes.SPY_SELECT_WANTED;
      }
      
      override protected function showView() : void
      {
         super.showView();
         this.myConfirmDialog.visible = false;
         this.myPopupDialog.visible = true;
      }
      
      override protected function hideView() : void
      {
         super.hideView();
      }
      
      public function onSetWanted(playerData:Object) : void
      {
         this.myConfirmDialog.setMode(WantedPopupConfirmDialog.MODE_CONFIRM);
         this.myConfirmDialog.setWantedPlayerData(playerData);
         this.myPopupDialog.visible = false;
         this.myConfirmDialog.visible = true;
      }
      
      public function onConfirmPlayerWanted(clientNum:int) : void
      {
         var error:int = 0;
         this.myPopupDialog.visible = false;
         this.myConfirmDialog.visible = false;
         if(this.myConfirmDialog.isInErrorMode())
         {
            this.myPopupDialog.visible = true;
            this.myConfirmDialog.visible = false;
         }
         else
         {
            error = this.setPlayerToWanted(clientNum);
            if(error == WantedPopupConfirmDialog.ERROR_SUCCESS)
            {
               this.close();
            }
            else
            {
               this.myConfirmDialog.setMode(WantedPopupConfirmDialog.MODE_ERROR,error);
               this.myConfirmDialog.visible = true;
            }
         }
      }
      
      public function onCancelPlayerWanted() : void
      {
         this.myConfirmDialog.visible = false;
         this.myPopupDialog.visible = true;
      }
      
      public function cppSetData(data:Object) : void
      {
         this.myPopupDialog.setData(data);
      }
      
      private function close() : void
      {
         Notify(MSG_CLOSE,{});
      }
      
      private function setPlayerToWanted(clientNum:int) : int
      {
         return Notify(MSG_WANTED,{"clientNum":clientNum}) as int;
      }
      
      override public function onKeyboardEvent(cEvt:KeyboardEvent) : void
      {
         if(cEvt.type == KeyboardEvent.KEY_DOWN && cEvt.keyCode == Keyboard.ESCAPE)
         {
            this.close();
         }
      }
   }
}

