package codo.views
{
   import codo.base.BaseView;
   import codo.common.CFunctionInGameContainer;
   import codo.component.CloseButton;
   import codo.constants.GameInfo;
   import codo.utils.LocalizeUtil;
   import codo.utils.ScaleformUtil;
   import codo.views.hudDMZLoadout.HudDMZLoadoutPanel;
   import flash.events.KeyboardEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.ui.Keyboard;
   
   public class HudDMZLoadoutView extends BaseView
   {
      
      public var myTitle:TextField;
      
      public var myCloseButton:CloseButton;
      
      public var myPanel:HudDMZLoadoutPanel;
      
      public function HudDMZLoadoutView()
      {
         super();
         var stageSize:Point = new Point(1280,960);
         var stagePosition:Point = new Point(0,0);
         if(ScaleformUtil.isScaleform)
         {
            stageSize = GameInfo.stageSize;
            stagePosition = GameInfo.stagePosition;
         }
         this.myPanel.x = (stageSize.x - this.myPanel.width) / 2 + stagePosition.x;
         this.myPanel.y = (stageSize.y - this.myPanel.height) / 2 + stagePosition.y;
         this.myTitle.x = this.myPanel.x;
         this.myTitle.y = this.myPanel.y - 54;
         this.myCloseButton.x = this.myPanel.x + this.myPanel.width - this.myCloseButton.width / 2;
         this.myCloseButton.y = this.myPanel.y - this.myCloseButton.width / 2;
         this.myCloseButton.setClickCallback(this.onCloseButtonClicked);
      }
      
      override protected function onInit() : void
      {
         var matchStatus:Object = CFunctionInGameContainer.GetMatchStatus();
         if(matchStatus != null)
         {
            this.myTitle.text = LocalizeUtil.localize(matchStatus.map);
         }
      }
      
      override protected function onInitListener() : void
      {
      }
      
      override protected function showView() : void
      {
         super.showView();
         this.myPanel.onShow();
         stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDownHandler);
      }
      
      override protected function hideView() : void
      {
         this.myPanel.onHide();
         super.hideView();
         stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDownHandler);
      }
      
      protected function onKeyDownHandler(cEvt:KeyboardEvent) : void
      {
         if(cEvt.keyCode == Keyboard.ESCAPE)
         {
            CFunctionInGameContainer.AS_DMZ_CloseLoadoutView();
            return;
         }
         var key:String = String.fromCharCode(cEvt.charCode).toUpperCase();
         var keyToggleLoadoutMenu:String = LocalizeUtil.localizeFirstKeyBindingForCommand("toggleloadoutmenu").toUpperCase();
         var keyActionSlot1:String = LocalizeUtil.localizeFirstKeyBindingForCommand("+actionslot 1").toUpperCase();
         var keyActionSlot2:String = LocalizeUtil.localizeFirstKeyBindingForCommand("+actionslot 2").toUpperCase();
         var keyActionSlot3:String = LocalizeUtil.localizeFirstKeyBindingForCommand("+actionslot 3").toUpperCase();
         var keyActionSlot4:String = LocalizeUtil.localizeFirstKeyBindingForCommand("+actionslot 4").toUpperCase();
         if(key == keyToggleLoadoutMenu)
         {
            CFunctionInGameContainer.AS_DMZ_CloseLoadoutView();
         }
         else if(key == keyActionSlot1)
         {
            CFunctionInGameContainer.AS_ActionSlotDown(0);
         }
         else if(key == keyActionSlot2)
         {
            CFunctionInGameContainer.AS_ActionSlotDown(1);
         }
         else if(key == keyActionSlot3)
         {
            CFunctionInGameContainer.AS_ActionSlotDown(2);
         }
         else if(key == keyActionSlot4)
         {
            CFunctionInGameContainer.AS_ActionSlotDown(3);
         }
      }
      
      private function onCloseButtonClicked() : void
      {
         CFunctionInGameContainer.AS_DMZ_CloseLoadoutView();
      }
   }
}

