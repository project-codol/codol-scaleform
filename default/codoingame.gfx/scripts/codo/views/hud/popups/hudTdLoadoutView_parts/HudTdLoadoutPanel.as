package codo.views.hud.popups.hudTdLoadoutView_parts
{
   import codo.common.CFunctionCommonContainer;
   import codo.component.CallToActionButton;
   import codo.constants.BCInGameEvent;
   import codo.event.ParaEvent;
   import codo.localization.DictTD;
   import codo.manager.EventManager;
   import codo.utils.LocalizeUtil;
   import codo.views.hud.popups.hudTdShare.HudTdItemDetailBox;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.text.TextField;
   
   public class HudTdLoadoutPanel extends MovieClip
   {
      
      public static const PACKAGE_SLOT_COUNT:int = 28;
      
      public var myEquipmentsTitle:TextField;
      
      public var myPackageTitle:TextField;
      
      public var myWeapon1Slot:HudTdLoadoutWeaponSlot;
      
      public var myWeapon2Slot:HudTdLoadoutWeaponSlot;
      
      public var myLethalSlot:HudTdEquipmentSlot;
      
      public var myTacticalSlot:HudTdEquipmentSlot;
      
      public var mySyringeSlot:HudTdEquipmentSlot;
      
      public var myArrangeBtn:CallToActionButton;
      
      public var myDetailBox:HudTdItemDetailBox;
      
      public var myBackground:MovieClip;
      
      public var myLockSlotsCover:MovieClip;
      
      private var mPackageSlots:Vector.<HudTdPackageSlot>;
      
      public function HudTdLoadoutPanel()
      {
         super();
         this.myEquipmentsTitle.text = DictTD.EQUIPMENT;
         this.myPackageTitle.text = DictTD.PACKAGE;
         this.myWeapon1Slot.slot = 0;
         this.myWeapon2Slot.slot = 1;
         this.myLethalSlot.key = LocalizeUtil.localizeFirstKeyBindingForCommand("+frag").toUpperCase();
         this.myLethalSlot.emptyHint = DictTD.LETHAL_EMPTY_HINT;
         this.myTacticalSlot.key = LocalizeUtil.localizeFirstKeyBindingForCommand("+smoke").toUpperCase();
         this.myTacticalSlot.emptyHint = DictTD.TACTICAL_EMPTY_HINT;
         this.mySyringeSlot.key = LocalizeUtil.localizeFirstKeyBindingForCommand("+actionslot 2").toUpperCase();
         this.mySyringeSlot.emptyHint = DictTD.SYRINGE_EMPTY_HINT;
         this.mPackageSlots = new Vector.<HudTdPackageSlot>(0);
         for(var i:int = 0; i < PACKAGE_SLOT_COUNT; i++)
         {
            this.mPackageSlots[i] = getChildByName("myPackageSlot" + (i + 1).toString()) as HudTdPackageSlot;
         }
         this.myArrangeBtn.width = 90;
         this.myArrangeBtn.height = 30;
         this.myArrangeBtn.label = DictTD.LOADOUT_ARRANGE;
         this.myArrangeBtn.setClickCallback(this.onArrange);
      }
      
      public function show() : void
      {
         this.myDetailBox.visible = false;
         EventManager.getInstance().listen(BCInGameEvent.EVT_TD_SHOW_ITEM_DETAIL_BOX,this.onShowItemDetailBox);
         EventManager.getInstance().listen(BCInGameEvent.EVT_TD_HIDE_ITEM_DETAIL_BOX,this.onHideItemDetailBox);
      }
      
      public function hide() : void
      {
         EventManager.getInstance().unlisten(BCInGameEvent.EVT_TD_SHOW_ITEM_DETAIL_BOX,this.onShowItemDetailBox);
         EventManager.getInstance().unlisten(BCInGameEvent.EVT_TD_HIDE_ITEM_DETAIL_BOX,this.onHideItemDetailBox);
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
      
      private function onArrange() : void
      {
         CFunctionCommonContainer.ScriptMenuResponse("td_package_arrange","arrange");
      }
      
      public function set usableSlotNum(num:int) : void
      {
         this.myLockSlotsCover.visible = num != PACKAGE_SLOT_COUNT;
         for(var i:int = 0; i < PACKAGE_SLOT_COUNT; i++)
         {
            this.mPackageSlots[i].visible = i < num;
         }
      }
   }
}

