package codo.views.hud.popups.HudShoppingPopup_parts
{
   import codo.constants.BCInGameEvent;
   import codo.event.ParaEvent;
   import codo.localization.DictHud;
   import codo.manager.EventManager;
   import codo.utils.LocalizeUtil;
   import codo.views.hud.shared.HUDSimpleButton;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import fsg.util.FsgAudioUtil;
   
   public class HudShoppingPopupPurchaseBtn extends HUDSimpleButton
   {
      
      public var myText:TextField;
      
      public var myHint:TextField;
      
      private var mKey:String;
      
      private var mMessage:int;
      
      private var mIsSoldOut:Boolean;
      
      public function HudShoppingPopupPurchaseBtn()
      {
         super();
         this.mIsSoldOut = false;
      }
      
      public function set message(message:int) : void
      {
         this.mMessage = message;
      }
      
      public function bindListeners() : void
      {
         EventManager.getInstance().listen(BCInGameEvent.EVT_HUD_SHOPPING_POPUP_OPTION_MOUSE_OVER,this.onOptionMouseOver);
         EventManager.getInstance().listen(BCInGameEvent.EVT_HUD_SHOPPING_POPUP_OPTION_MOUSE_OUT,this.onOptionMouseOut);
         EventManager.getInstance().listen(BCInGameEvent.EVT_HUD_SHOPPING_POPUP_OPTION_MOUSE_CLICK,this.onOptionMouseClick);
         EventManager.getInstance().listen(BCInGameEvent.EVT_HUD_SHOPPING_POPUP_OPTION_MOUSE_CLICK_UP,this.onOptionMouseClickUp);
      }
      
      public function unbindListeners() : void
      {
         EventManager.getInstance().unlisten(BCInGameEvent.EVT_HUD_SHOPPING_POPUP_OPTION_MOUSE_OVER,this.onOptionMouseOver);
         EventManager.getInstance().unlisten(BCInGameEvent.EVT_HUD_SHOPPING_POPUP_OPTION_MOUSE_OUT,this.onOptionMouseOut);
         EventManager.getInstance().unlisten(BCInGameEvent.EVT_HUD_SHOPPING_POPUP_OPTION_MOUSE_CLICK,this.onOptionMouseClick);
         EventManager.getInstance().unlisten(BCInGameEvent.EVT_HUD_SHOPPING_POPUP_OPTION_MOUSE_CLICK_UP,this.onOptionMouseClickUp);
      }
      
      public function set keyBinding(key:String) : void
      {
         this.mKey = key;
         this.refresh();
      }
      
      public function set isSoldOut(isSoldOut:Boolean) : void
      {
         this.mIsSoldOut = isSoldOut;
         this.refresh();
      }
      
      override protected function refresh() : void
      {
         super.refresh();
         if(!this.mIsSoldOut)
         {
            this.myText.text = LocalizeUtil.param(DictHud.PURCHASE,[this.mKey]);
            LocalizeUtil.paramColorized(this.myHint,DictHud.PURCHASE_BUTTON_HINT,[this.mKey],[16750082]);
         }
         else
         {
            this.myText.text = DictHud.SOLD_OUT;
         }
      }
      
      override protected function onMouseOver(cEvt:MouseEvent) : void
      {
         EventManager.getInstance().broadcast(BCInGameEvent.EVT_HUD_SHOPPING_POPUP_OPTION_MOUSE_OVER,this.mMessage);
      }
      
      override protected function onMouseOut(cEvt:MouseEvent) : void
      {
         EventManager.getInstance().broadcast(BCInGameEvent.EVT_HUD_SHOPPING_POPUP_OPTION_MOUSE_OUT,this.mMessage);
      }
      
      override protected function onMouseDown(cEvt:MouseEvent) : void
      {
         EventManager.getInstance().broadcast(BCInGameEvent.EVT_HUD_SHOPPING_POPUP_OPTION_MOUSE_CLICK,this.mMessage);
      }
      
      override protected function onMouseUp(cEvt:MouseEvent) : void
      {
         EventManager.getInstance().broadcast(BCInGameEvent.EVT_HUD_SHOPPING_POPUP_OPTION_MOUSE_CLICK_UP,this.mMessage);
      }
      
      private function onOptionMouseOver(evt:ParaEvent) : void
      {
         if(evt.myPara != this.mMessage)
         {
            return;
         }
         super.onMouseOver(null);
         FsgAudioUtil.getInstance().playSound("zh_ui_hover");
      }
      
      private function onOptionMouseOut(evt:ParaEvent) : void
      {
         if(evt.myPara != this.mMessage)
         {
            return;
         }
         super.onMouseOut(null);
      }
      
      private function onOptionMouseClick(evt:ParaEvent) : void
      {
         if(evt.myPara != this.mMessage)
         {
            return;
         }
         super.onMouseDown(null);
         FsgAudioUtil.getInstance().playSound("zh_ui_click");
      }
      
      private function onOptionMouseClickUp(evt:ParaEvent) : void
      {
         if(evt.myPara != this.mMessage)
         {
            return;
         }
         super.onMouseUp(null);
      }
   }
}

