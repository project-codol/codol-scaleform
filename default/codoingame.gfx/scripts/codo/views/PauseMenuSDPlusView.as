package codo.views
{
   import codo.common.CFunctionCommonContainer;
   import codo.component.Button;
   import codo.component.TextField;
   import codo.component.loadout.EquipmentHotkeyLoadoutButton;
   import codo.component.loadout.HotkeyLoadoutButton;
   import codo.component.loadout.PerkHotkeyLoadoutButton;
   import codo.component.loadout.SDPlusCashTransferFlyout;
   import codo.component.loadout.SDPlusItemSelector;
   import codo.component.loadout.WeaponHotkeyLoadoutButton;
   import codo.constants.BCCommonEvent;
   import codo.constants.BCInGameEvent;
   import codo.constants.DataInGameID;
   import codo.constants.MarketMenuData;
   import codo.event.ParaEvent;
   import codo.localization.Dict;
   import codo.objects.ProductObj;
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   import codo.utils.LocalizeUtil;
   import codo.utils.PauseUtil;
   import codo.utils.SDPlusPvpUtil;
   import com.greensock.TweenLite;
   import com.greensock.easing.Cubic;
   import components.chatting_part.HudChatModule;
   import flash.display.MovieClip;
   import flash.events.KeyboardEvent;
   import flash.events.TimerEvent;
   import flash.ui.Keyboard;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import fsg.util.FsgUtil;
   
   public class PauseMenuSDPlusView extends FsgPauseMenuBaseView
   {
      
      private static const FRAME_WIDTH:Number = 1275;
      
      private static const FRAME_HEIGHT:Number = 730;
      
      private static const ITEM_SELECTOR_VISIBLE_X:Number = 588;
      
      private static const ITEM_SELECTOR_INVISIBLE_X:Number = 900;
      
      public var myItemSelector:SDPlusItemSelector;
      
      public var myFactionBG:MovieClip;
      
      public var myPrimaryWeapon:WeaponHotkeyLoadoutButton;
      
      public var mySecondaryWeapon:WeaponHotkeyLoadoutButton;
      
      public var myPerk:PerkHotkeyLoadoutButton;
      
      public var myLethal:EquipmentHotkeyLoadoutButton;
      
      public var myTactical:EquipmentHotkeyLoadoutButton;
      
      public var myKillstreak:HotkeyLoadoutButton;
      
      public var myBombKit:HotkeyLoadoutButton;
      
      public var myTransferFlyout:SDPlusCashTransferFlyout;
      
      public var myPurchaseLastButton:Button;
      
      public var myLoadoutCost:TextField;
      
      public var myTimeLeftLabel:TextField;
      
      public var myTimeLeftValue:TextField;
      
      public var myTimeLeftBG:MovieClip;
      
      public var myCashTotal:TextField;
      
      public var myFaction:TextField;
      
      public var myChatModule:HudChatModule;
      
      private var _itemSelectorShowing:Boolean = false;
      
      private var _currentSlot:HotkeyLoadoutButton;
      
      private var _hideChatTimer:Timer = new Timer(5000,1);
      
      private var mHotkeyMapping:Dictionary;
      
      public function PauseMenuSDPlusView()
      {
         super();
      }
      
      override protected function onInit() : void
      {
         super.onInit();
         myOptions.myTitleTF.visible = false;
         if(myOptions.myBrightness.visible)
         {
            myOptions.y -= 54;
            myOptions.myBrightness.y = 162;
         }
         myTitle.font = GlobalGuide.FONT_FACE_BOLD;
         myTitle.fontSize = GlobalGuide.FONT_SIZE_LARGE;
         myTitle.width = 400;
         myTitle.height = 50;
         this.myTimeLeftLabel.width = 200;
         this.myTimeLeftValue.font = GlobalGuide.FONT_FACE_NUMBERS;
         this.myTimeLeftValue.fontSize = GlobalGuide.FONT_SIZE_MEDIUM;
         this.myTimeLeftValue.alignment = TextStyle.HALIGN_CENTER;
         this.myTimeLeftValue.width = 200;
         this.myTimeLeftLabel.visible = this.myTimeLeftValue.visible = this.myTimeLeftBG.visible = false;
         this.myLoadoutCost.font = GlobalGuide.FONT_FACE_NUMBERS;
         this.myLoadoutCost.fontSize = GlobalGuide.FONT_SIZE_MEDIUM;
         this.myCashTotal.font = GlobalGuide.FONT_FACE_NUMBERS;
         this.myCashTotal.fontSize = GlobalGuide.FONT_SIZE_LARGE;
         this.myCashTotal.width = 200;
         this.myCashTotal.height = 50;
         this.myFaction.font = GlobalGuide.FONT_FACE_BOLD;
         this.myFaction.fontSize = GlobalGuide.FONT_SIZE_MEDIUM;
         this.myFaction.alignment = TextStyle.HALIGN_CENTER;
         this.myFaction.width = 256;
         this.myFaction.visible = this.myFactionBG.visible = false;
         myTitle.text = LocalizeUtil.localize("@UI_HUD_CURRENT_LOADOUT");
         this.myTimeLeftLabel.text = LocalizeUtil.localize("@UI_HUD_PURCHASING_TIME_LEFT");
         this.myPurchaseLastButton.registerClickEvent(this.onPurchaseLastClicked);
         this.myPurchaseLastButton.width = 220;
         this.myPurchaseLastButton.label = LocalizeUtil.localize("@UI_HUD_PURCHASE_LAST_LOADOUT");
         this.myPrimaryWeapon.setGroup(MarketMenuData.TYPE_WEAPON,"@UI_HUD_SDPLUS_WEAPON1",MarketMenuData.SLOT_PRIMARY);
         this.mySecondaryWeapon.setGroup(MarketMenuData.TYPE_WEAPON,"@UI_HUD_SDPLUS_WEAPON2",MarketMenuData.SLOT_SECONDARY);
         this.myTactical.setGroup(MarketMenuData.GRP_TACTICAL,Dict.LOADOUT_SLOT_TACTICAL);
         this.myLethal.setGroup(MarketMenuData.GRP_LETHAL,Dict.LOADOUT_SLOT_LETHAL);
         this.myPerk.setGroup(MarketMenuData.TYPE_PERK,Dict.WEAPONLOADOUT_PERK);
         this.myKillstreak.setGroup(MarketMenuData.TYPE_KILLSTREAK,"@UI_HUD_SDPLUS_TEAM_SUPPORT");
         this.myBombKit.setGroup(SDPlusPvpUtil.GROUP_BOMBKITS,"@UI_HUD_SDPLUS_BOMB_KIT");
         this.myPrimaryWeapon.setHotkey(Keyboard.NUMBER_1);
         this.mySecondaryWeapon.setHotkey(Keyboard.NUMBER_2);
         this.myPerk.setHotkey(Keyboard.NUMBER_3);
         this.myLethal.setHotkey(Keyboard.NUMBER_4);
         this.myTactical.setHotkey(Keyboard.NUMBER_5);
         this.myKillstreak.setHotkey(Keyboard.NUMBER_6);
         this.myBombKit.setHotkey(Keyboard.NUMBER_7);
         this.mHotkeyMapping = new Dictionary();
         this.mHotkeyMapping[this.myPrimaryWeapon.getHotkey()] = this.myPrimaryWeapon;
         this.mHotkeyMapping[this.mySecondaryWeapon.getHotkey()] = this.mySecondaryWeapon;
         this.mHotkeyMapping[this.myPerk.getHotkey()] = this.myPerk;
         this.mHotkeyMapping[this.myLethal.getHotkey()] = this.myLethal;
         this.mHotkeyMapping[this.myTactical.getHotkey()] = this.myTactical;
         this.mHotkeyMapping[this.myKillstreak.getHotkey()] = this.myKillstreak;
         this.mHotkeyMapping[this.myBombKit.getHotkey()] = this.myBombKit;
         this.myPrimaryWeapon.registerClickEvent(this.onSlotClicked,this.myPrimaryWeapon);
         this.mySecondaryWeapon.registerClickEvent(this.onSlotClicked,this.mySecondaryWeapon);
         this.myLethal.registerClickEvent(this.onSlotClicked,this.myLethal);
         this.myTactical.registerClickEvent(this.onSlotClicked,this.myTactical);
         this.myKillstreak.registerClickEvent(this.onSlotClicked,this.myKillstreak);
         this.myPerk.registerClickEvent(this.onSlotClicked,this.myPerk);
         this.myBombKit.registerClickEvent(this.onSlotClicked,this.myBombKit);
         this.myItemSelector.alpha = 0;
         this.myItemSelector.x = ITEM_SELECTOR_INVISIBLE_X;
         this.myPurchaseLastButton.visible = false;
         this.myLoadoutCost.visible = false;
         this.myTransferFlyout.visible = false;
      }
      
      override protected function onInitListener() : void
      {
         super.onInitListener();
         bind(DataInGameID.SDP_CAN_PURCHASE,this.bindCanPurchase);
         bind(DataInGameID.SD_ATTACKING,this.bindAttacking);
         bind(DataInGameID.SD_PREMATCH_TIMER,this.bindPrematchTimer);
         this._hideChatTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onHideChatTimerComplete);
         listen(BCInGameEvent.EVT_ON_CHAT_MSG_RECEIVED,this.onChatMsgReceived);
      }
      
      override protected function showView() : void
      {
         super.showView();
         this.updateCashTotal();
         if(this._itemSelectorShowing)
         {
            this.toggleItemSelector();
         }
         if(this._currentSlot != null)
         {
            this._currentSlot.selected = false;
            this._currentSlot = null;
         }
         myTitle.y = 119;
      }
      
      override protected function refreshLayout() : void
      {
         super.refreshLayout();
         myTitle.x = 8;
         myTitle.y = 119;
         myFrame.x = 15;
         myFrame.width = FRAME_WIDTH;
         myFrame.height = FRAME_HEIGHT;
      }
      
      private function bindPrematchTimer(cRes:Object) : void
      {
         var time:int = int(cRes.data);
         this.myTimeLeftValue.text = time.toString();
      }
      
      private function updateCashTotal() : void
      {
         var cash:int = CFunctionCommonContainer.GetPlayerDataInt("playingCardsCurrentBestSet",false);
         this.myCashTotal.text = "$" + FsgUtil.commaFormatNumber(cash);
      }
      
      private function toggleItemSelector() : void
      {
         this._itemSelectorShowing = !this._itemSelectorShowing;
         if(this._itemSelectorShowing)
         {
            this.myItemSelector.visible = true;
            TweenLite.to(this.myItemSelector,0.25,{
               "alpha":1,
               "x":ITEM_SELECTOR_VISIBLE_X,
               "ease":Cubic.easeOut
            });
            PauseUtil.hidePauseMap(true);
         }
         else
         {
            TweenLite.to(this.myItemSelector,0.25,{
               "alpha":0,
               "x":ITEM_SELECTOR_INVISIBLE_X,
               "ease":Cubic.easeOut,
               "onComplete":this.hideSelector
            });
            PauseUtil.hidePauseMap(false);
         }
      }
      
      override protected function displayLoadoutDetail(loadoutIdx:int) : void
      {
         var loadout:Object = null;
         var bombKit:ProductObj = null;
         if(Boolean(_classes) && _useOverrideLoadout)
         {
            loadout = _classes[loadoutIdx];
            this.myPrimaryWeapon.setData(loadout.primary);
            this.mySecondaryWeapon.setData(loadout.secondary);
            this.myPrimaryWeapon.setAttachments(loadout.primaryAttachments);
            this.mySecondaryWeapon.setAttachments(loadout.secondaryAttachments);
            this.myLethal.setData(loadout.equipments[0]);
            this.myTactical.setData(loadout.equipments[2]);
            this.myKillstreak.setData(loadout.killstreaks[0]);
            this.myLethal.setDoubleAmmo(loadout.equipments[1]);
            this.myTactical.setDoubleAmmo(loadout.equipments[3]);
            this.myPerk.setPerks(loadout.perks);
            bombKit = SDPlusPvpUtil.instance.getItemDataByIndex(loadout.extra[0]);
            this.myBombKit.setData(bombKit);
            this.updateCashTotal();
            if(this._itemSelectorShowing)
            {
               this.myItemSelector.setData(this._currentSlot.group);
            }
         }
      }
      
      private function onSlotClicked(slot:HotkeyLoadoutButton) : void
      {
         if(!slot.enabled)
         {
            return;
         }
         var equippedItem:ProductObj = new ProductObj(slot.getData());
         var subGroup:String = equippedItem.id > 0 ? equippedItem.group : null;
         this.myItemSelector.setData(slot.group,subGroup);
         if(!this._itemSelectorShowing)
         {
            this.toggleItemSelector();
         }
         SDPlusPvpUtil.instance.slotID = slot.slotID;
         switch(slot.slotID)
         {
            case MarketMenuData.SLOT_PRIMARY:
               this.myItemSelector.comparePrimaryWeapon(true);
               break;
            case MarketMenuData.SLOT_SECONDARY:
               this.myItemSelector.comparePrimaryWeapon(false);
         }
         if(null != this._currentSlot)
         {
            this._currentSlot.selected = false;
         }
         this._currentSlot = slot;
         this._currentSlot.selected = true;
      }
      
      override protected function backToGame() : void
      {
         broadcast(BCInGameEvent.BACK_TO_GAME);
      }
      
      override public function onKeyboardEvent(cEvt:KeyboardEvent) : void
      {
         if(cEvt.keyCode == Keyboard.ESCAPE)
         {
            if(_qtSettingShowing)
            {
               broadcast(BCCommonEvent.TRY_TOGGLE_GVOICE_SETTING);
            }
            else if(this._itemSelectorShowing)
            {
               this.onSelectorClosed();
            }
            else
            {
               this.backToGame();
            }
         }
         else if(cEvt.keyCode == Keyboard.B)
         {
            if(!getDP(DataInGameID.HAS_POPUP))
            {
               this.backToGame();
            }
         }
         else if(this.mHotkeyMapping.hasOwnProperty(cEvt.keyCode.toString()))
         {
            this.onSlotClicked(this.mHotkeyMapping[cEvt.keyCode]);
         }
      }
      
      private function onSelectorClosed() : void
      {
         this.toggleItemSelector();
         this._currentSlot.selected = false;
         this._currentSlot = null;
      }
      
      private function hideSelector() : void
      {
         this.myItemSelector.visible = false;
      }
      
      private function bindCanPurchase(cRes:Object) : void
      {
         var canPurchase:Boolean = Boolean(cRes.data);
         this.setPurchaseEnabled(canPurchase);
      }
      
      private function bindAttacking(cRes:Object) : void
      {
         var isAttacking:Boolean = Boolean(cRes.data);
         if(isAttacking)
         {
            this.myFactionBG.gotoAndStop(1);
            this.myFaction.text = "@UI_HUD_SDP_ATTACKER";
         }
         else
         {
            this.myFactionBG.gotoAndStop(2);
            this.myFaction.text = "@UI_HUD_SDP_DEFENDER";
         }
         this.myFactionBG.width = this.myFaction.textWidth + 40;
         this.myFactionBG.x = this.myFaction.x + this.myFaction.width * 0.5 - this.myFactionBG.width * 0.5;
         this.myFaction.visible = this.myFactionBG.visible = true;
      }
      
      private function setPurchaseEnabled(canPurchase:Boolean) : void
      {
         this.myTransferFlyout.enabled = canPurchase;
         this.myPurchaseLastButton.enabled = canPurchase;
         this.myTimeLeftLabel.visible = this.myTimeLeftValue.visible = this.myTimeLeftBG.visible = canPurchase;
         if(this._itemSelectorShowing)
         {
            this.myItemSelector.setData(this._currentSlot.group);
         }
      }
      
      private function onPurchaseLastClicked() : void
      {
         trace("PURCHASE LAST!");
      }
      
      override protected function onPopupShowStateChangeHandle(cEvt:ParaEvent) : void
      {
         super.onPopupShowStateChangeHandle(cEvt);
         if(this._itemSelectorShowing && cEvt.type == BCInGameEvent.SHOW_NOTIFICATION_POPUP)
         {
            this.toggleItemSelector();
            PauseUtil.hidePauseMap(true);
         }
      }
      
      private function onChatMsgReceived(cEvt:ParaEvent) : void
      {
         this.myChatModule.newMsg(cEvt.myPara);
         if(Boolean(cEvt.myPara.isNew))
         {
            this._hideChatTimer.reset();
            this._hideChatTimer.start();
            this.myChatModule.setMode(HudChatModule.SHOW_MODE);
         }
      }
      
      private function onHideChatTimerComplete(evt:TimerEvent) : void
      {
         this.myChatModule.setMode(HudChatModule.PLAY_MODE);
      }
      
      override protected function shouldShowNavigateTab() : Boolean
      {
         return false;
      }
   }
}

