package codo.views.hud.popups
{
   import codo.common.CFunctionCommonContainer;
   import codo.constants.BCInGameEvent;
   import codo.constants.GameInfo;
   import codo.constants.HUDPopupComponentTypes;
   import codo.utils.ScaleformUtil;
   import codo.views.hud.HUDPopupComponent;
   import codo.views.hud.popups.HudShoppingPopup_parts.HudShoppingPopupOptionPanel;
   import codo.views.hud.popups.HudShoppingPopup_parts.HudShoppingPopupPurchaseBtn;
   import codo.views.hud.shared.HUDSimpleButton;
   import flash.display.MovieClip;
   import flash.events.KeyboardEvent;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   
   public class HudShoppingPopup extends HUDPopupComponent
   {
      
      public static const MSG_CLOSE:int = 1;
      
      public static const MSG_UPGRADE:int = 2;
      
      public static const MSG_COPY_WEAPON:int = 3;
      
      public static const MSG_PURCHASE_SKILL:int = 4;
      
      public static const MSG_CHANGE_LOADOUT:int = 5;
      
      public var myTitleBar:MovieClip;
      
      public var myPanel:MovieClip;
      
      public var myCloseBtn:HUDSimpleButton;
      
      public function HudShoppingPopup()
      {
         var stageSize:Point = null;
         super();
         stageSize = new Point(1280,960);
         var stagePosition:Point = new Point(0,0);
         if(ScaleformUtil.isScaleform)
         {
            stageSize = GameInfo.stageSize;
            stagePosition = GameInfo.stagePosition;
         }
         this.myTitleBar.x = stagePosition.x;
         this.myPanel.x = stagePosition.x + (stageSize.x - this.myPanel.width) / 2;
         this.myCloseBtn.x = this.myPanel.x + this.myPanel.width - this.myCloseBtn.width / 2 - 20;
         var upgradeBtn:HudShoppingPopupPurchaseBtn = this["myPanel"]["myUpgradeBtn"];
         var copyWeaponBtn:HudShoppingPopupPurchaseBtn = this["myPanel"]["myCopyWeaponBtn"];
         var purchaseSkillBtn:HudShoppingPopupPurchaseBtn = this["myPanel"]["myPurchaseSkillBtn"];
         var changeLoadoutBtn:HudShoppingPopupPurchaseBtn = this["myPanel"]["myChangeLoadoutBtn"];
         var myUpgradeOption:HudShoppingPopupOptionPanel = this["myPanel"]["myUpgradeOption"];
         var myCopyWeaponOption:HudShoppingPopupOptionPanel = this["myPanel"]["myCopyWeaponOption"];
         var myPurchaseSkillOption:HudShoppingPopupOptionPanel = this["myPanel"]["myPurchaseSkillOption"];
         var myChangeLoadoutOption:HudShoppingPopupOptionPanel = this["myPanel"]["myChangeLoadoutOption"];
         upgradeBtn.keyBinding = "1";
         copyWeaponBtn.keyBinding = "2";
         purchaseSkillBtn.keyBinding = "4";
         changeLoadoutBtn.keyBinding = "3";
         upgradeBtn.message = 1;
         copyWeaponBtn.message = 2;
         purchaseSkillBtn.message = 4;
         changeLoadoutBtn.message = 3;
         myUpgradeOption.message = 1;
         myCopyWeaponOption.message = 2;
         myPurchaseSkillOption.message = 4;
         myChangeLoadoutOption.message = 3;
         upgradeBtn.clickHandler = this.onUpgradeBtnClicked;
         copyWeaponBtn.clickHandler = this.onCopyWeaponBtnClicked;
         purchaseSkillBtn.clickHandler = this.onPurchaseSkillBtnClicked;
         changeLoadoutBtn.clickHandler = this.onChangeLoadoutBtnClicked;
         myUpgradeOption.clickHandler = this.onUpgradeBtnClicked;
         myCopyWeaponOption.clickHandler = this.onCopyWeaponBtnClicked;
         myPurchaseSkillOption.clickHandler = this.onPurchaseSkillBtnClicked;
         myChangeLoadoutOption.clickHandler = this.onChangeLoadoutBtnClicked;
         this.myCloseBtn.clickHandler = this.onClose;
      }
      
      override protected function showView() : void
      {
         super.showView();
         var upgradeBtn:HudShoppingPopupPurchaseBtn = this["myPanel"]["myUpgradeBtn"];
         upgradeBtn.reset();
         upgradeBtn.bindListeners();
         var myUpgradeOption:HudShoppingPopupOptionPanel = this["myPanel"]["myUpgradeOption"];
         myUpgradeOption.reset();
         myUpgradeOption.bindListeners();
         var copyWeaponBtn:HudShoppingPopupPurchaseBtn = this["myPanel"]["myCopyWeaponBtn"];
         copyWeaponBtn.reset();
         copyWeaponBtn.bindListeners();
         var myCopyWeaponOption:HudShoppingPopupOptionPanel = this["myPanel"]["myCopyWeaponOption"];
         myCopyWeaponOption.reset();
         myCopyWeaponOption.bindListeners();
         var purchaseSkillBtn:HudShoppingPopupPurchaseBtn = this["myPanel"]["myPurchaseSkillBtn"];
         purchaseSkillBtn.reset();
         purchaseSkillBtn.bindListeners();
         var myPurchaseSkillOption:HudShoppingPopupOptionPanel = this["myPanel"]["myPurchaseSkillOption"];
         myPurchaseSkillOption.reset();
         myPurchaseSkillOption.bindListeners();
         var changeLoadoutBtn:HudShoppingPopupPurchaseBtn = this["myPanel"]["myChangeLoadoutBtn"];
         changeLoadoutBtn.reset();
         changeLoadoutBtn.bindListeners();
         var myChangeLoadoutOption:HudShoppingPopupOptionPanel = this["myPanel"]["myChangeLoadoutOption"];
         myChangeLoadoutOption.reset();
         myChangeLoadoutOption.bindListeners();
         var point:Point = this.myPanel.localToGlobal(new Point(myPurchaseSkillOption.x,myPurchaseSkillOption.y));
         CFunctionCommonContainer.setdvar("ui_zhunt_purchase_consumable_option_x",point.x.toString());
         CFunctionCommonContainer.setdvar("ui_zhunt_purchase_consumable_option_y",point.y.toString());
         broadcast(BCInGameEvent.EVT_SET_ZHUNT_OBTAIN_CONSUMABLE_SPLASH_BG_VISIBILITY,true);
      }
      
      override protected function hideView() : void
      {
         super.hideView();
         CFunctionCommonContainer.setdvar("ui_zhunt_purchase_consumable_option_x","0");
         CFunctionCommonContainer.setdvar("ui_zhunt_purchase_consumable_option_y","0");
         var upgradeBtn:HudShoppingPopupPurchaseBtn = this["myPanel"]["myUpgradeBtn"];
         upgradeBtn.unbindListeners();
         var myUpgradeOption:HudShoppingPopupOptionPanel = this["myPanel"]["myUpgradeOption"];
         myUpgradeOption.bindListeners();
         var copyWeaponBtn:HudShoppingPopupPurchaseBtn = this["myPanel"]["myCopyWeaponBtn"];
         copyWeaponBtn.unbindListeners();
         var myCopyWeaponOption:HudShoppingPopupOptionPanel = this["myPanel"]["myCopyWeaponOption"];
         myCopyWeaponOption.unbindListeners();
         var purchaseSkillBtn:HudShoppingPopupPurchaseBtn = this["myPanel"]["myPurchaseSkillBtn"];
         purchaseSkillBtn.unbindListeners();
         var myPurchaseSkillOption:HudShoppingPopupOptionPanel = this["myPanel"]["myPurchaseSkillOption"];
         myPurchaseSkillOption.unbindListeners();
         var changeLoadoutBtn:HudShoppingPopupPurchaseBtn = this["myPanel"]["myChangeLoadoutBtn"];
         changeLoadoutBtn.unbindListeners();
         var myChangeLoadoutOption:HudShoppingPopupOptionPanel = this["myPanel"]["myChangeLoadoutOption"];
         myChangeLoadoutOption.unbindListeners();
         broadcast(BCInGameEvent.EVT_SET_ZHUNT_OBTAIN_CONSUMABLE_SPLASH_BG_VISIBILITY,false);
      }
      
      override public function get CompType() : int
      {
         return HUDPopupComponentTypes.SHOPPING;
      }
      
      private function onClose() : void
      {
         Notify(MSG_CLOSE,{});
      }
      
      private function onUpgradeBtnClicked() : void
      {
         Notify(MSG_UPGRADE,{});
      }
      
      private function onCopyWeaponBtnClicked() : void
      {
         Notify(MSG_COPY_WEAPON,{});
      }
      
      private function onPurchaseSkillBtnClicked() : void
      {
         Notify(MSG_PURCHASE_SKILL,{});
      }
      
      private function onChangeLoadoutBtnClicked() : void
      {
         Notify(MSG_CHANGE_LOADOUT,{});
      }
      
      override public function onKeyboardEvent(cEvt:KeyboardEvent) : void
      {
         if(cEvt.type == KeyboardEvent.KEY_DOWN)
         {
            switch(cEvt.keyCode)
            {
               case Keyboard.NUMBER_1:
                  this.onUpgradeBtnClicked();
                  break;
               case Keyboard.NUMBER_2:
                  this.onCopyWeaponBtnClicked();
                  break;
               case Keyboard.NUMBER_3:
                  this.onChangeLoadoutBtnClicked();
                  break;
               case Keyboard.NUMBER_4:
                  this.onPurchaseSkillBtnClicked();
                  break;
               default:
                  this.onClose();
            }
         }
      }
   }
}

