package codo.views.hudDMZLoadout
{
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionInGameContainer;
   import codo.constants.BCInGameEvent;
   import codo.constants.DMZLootItemSlotType;
   import codo.constants.DataID;
   import codo.event.ParaEvent;
   import codo.localization.DictDmz;
   import codo.manager.DataManager;
   import codo.manager.EventManager;
   import codo.objects.ProductObj;
   import codo.utils.CursorUtil;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   import fsg.util.FsgImageHolder;
   
   public class HudDMZLoadoutPanel extends MovieClip
   {
      
      public const PANEL_WIDTH:Number = 986;
      
      public const PANEL_HEIGHT:Number = 749;
      
      public var myDraggingItem:FsgImageHolder;
      
      public var myWeaponTitle:TextField;
      
      public var myWeapon1Loadout:HudDMZWeaponLoadout;
      
      public var myWeapon2Loadout:HudDMZWeaponLoadout;
      
      public var myPerksLoadout:HudDMZPerksLoadout;
      
      public var myInventory:HudDMZInventory;
      
      public var myAmmoInfo:HudDMZAmmoInfo;
      
      public var myGearScore:TextField;
      
      public var myGearTitle:TextField;
      
      public var myGearBg:MovieClip;
      
      public var myArmorInfo:TextField;
      
      public var myHealthInfo:TextField;
      
      public var myBg:MovieClip;
      
      private var mDraggingItemWidth:int;
      
      private var mDraggingItemHeight:int;
      
      public function HudDMZLoadoutPanel()
      {
         super();
         this.gearScore = 0;
         this.myGearTitle.text = DictDmz.LOADOUT_GEAR_SCORE;
         this.myWeaponTitle.text = DictDmz.LOADOUT_WEAPON_TITLE;
         this.myGearBg.gotoAndStop(1);
      }
      
      public function onShow() : void
      {
         EventManager.getInstance().listen(BCInGameEvent.EVT_DMZ_REFRESH_LOADOUT,this.onRefreshLoadout);
         EventManager.getInstance().listen(BCInGameEvent.EVT_DMZ_LOADOUT_SET_DRAGGING_ITEM_PARAM,this.onBeginDrag);
         EventManager.getInstance().broadcast(BCInGameEvent.EVT_DMZ_FORCE_REFRESH_LOADOUT);
         this.stage.addEventListener(MouseEvent.MOUSE_UP,this.onStageMouseUpHandle);
         this.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onStageMouseMoveHandle);
         this.myDraggingItem.visible = false;
         this.myDraggingItem.mouseEnabled = false;
         this.myDraggingItem.mouseChildren = false;
      }
      
      public function onHide() : void
      {
         EventManager.getInstance().unlisten(BCInGameEvent.EVT_DMZ_REFRESH_LOADOUT,this.onRefreshLoadout);
         EventManager.getInstance().unlisten(BCInGameEvent.EVT_DMZ_LOADOUT_SET_DRAGGING_ITEM_PARAM,this.onBeginDrag);
         this.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onStageMouseUpHandle);
         this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onStageMouseMoveHandle);
         this.myDraggingItem.visible = false;
         CursorUtil.EndCursor(CursorUtil.CURSOR_OVER_BUTTON);
      }
      
      private function onStageMouseUpHandle(cEvt:MouseEvent) : void
      {
         var dragParam:Object = DataManager.getInstance().getDP(DataID.DMZ_DRAGGING_ITEM_PARAM);
         EventManager.getInstance().broadcast(BCInGameEvent.EVT_DMZ_LOADOUT_SET_DRAGGING_ITEM_PARAM,{
            "type":DMZLootItemSlotType.NONE,
            "lootIndex":0,
            "weaponLootIndex":0,
            "ammoType":"undefined"
         });
         if(dragParam.lootIndex == 0 && dragParam.ammoType != "arlmg" && dragParam.ammoType != "pstsmg" && dragParam.ammoType != "shotgun" && dragParam.ammoType != "sniper")
         {
            return;
         }
         var mousePoint:Point = new Point(stage.mouseX,stage.mouseY);
         var localMousePoint:Point = this.globalToLocal(mousePoint);
         var localX:Number = localMousePoint.x;
         var localY:Number = localMousePoint.y;
         if(localX < 0 || localY < 0 || localX > this.PANEL_WIDTH || localY > this.PANEL_HEIGHT)
         {
            CFunctionCommonContainer.ScriptMenuResponse("dmz_loadout_drag","4_" + dragParam.type + "_" + dragParam.lootIndex + "_" + dragParam.weaponLootIndex + "_" + dragParam.ammoType);
         }
      }
      
      private function updateDragItemPosition() : void
      {
         var mousePoint:Point = new Point(stage.mouseX,stage.mouseY);
         var localMousePoint:Point = this.globalToLocal(mousePoint);
         this.myDraggingItem.x = localMousePoint.x - this.mDraggingItemWidth / 2;
         this.myDraggingItem.y = localMousePoint.y - this.mDraggingItemHeight / 2;
      }
      
      private function onStageMouseMoveHandle(cEvt:MouseEvent) : void
      {
         if(!this.myDraggingItem.visible)
         {
            return;
         }
         this.updateDragItemPosition();
      }
      
      private function setDraggingItemImage(url:String, width:int, height:int) : void
      {
         this.mDraggingItemWidth = width * scaleX;
         this.mDraggingItemHeight = height * scaleY;
         if(url == null || url == "")
         {
            this.myDraggingItem.visible = false;
         }
         else
         {
            this.myDraggingItem.visible = true;
            this.myDraggingItem.addEventListener(Event.COMPLETE,this.onDraggingItemImageLoaded);
            this.myDraggingItem.setImage(url);
         }
      }
      
      protected function onDraggingItemImageLoaded(e:Event) : void
      {
         var bmpImage:DisplayObject = this.myDraggingItem.loadedAsset;
         this.myDraggingItem.removeEventListener(Event.COMPLETE,this.onDraggingItemImageLoaded);
         bmpImage.width = this.mDraggingItemWidth;
         bmpImage.height = this.mDraggingItemHeight;
         this.updateDragItemPosition();
      }
      
      private function onBeginDrag(cEvt:ParaEvent) : void
      {
         var itemID:int = 0;
         var prod:ProductObj = null;
         var itemName:String = null;
         var equippedAttachInfo:Object = null;
         var inventoryAttachInfo:Object = null;
         var healthPackInfo:Object = null;
         if(Boolean(CFunctionInGameContainer.AS_IsPlayerDead()))
         {
            return;
         }
         var dragParam:Object = cEvt.myPara as Object;
         if(dragParam == null)
         {
            this.myDraggingItem.visible = false;
            this.myDraggingItem.setImage(null);
         }
         else
         {
            this.myDraggingItem.visible = true;
            itemName = CFunctionInGameContainer.AS_DMZ_GetItemByLootIndex(dragParam.lootIndex);
            switch(dragParam.type)
            {
               case DMZLootItemSlotType.WEAPON:
                  if(itemName != null)
                  {
                     itemID = CFunctionCommonContainer.GetItemIDByName(itemName);
                     prod = CFunctionCommonContainer.GetItemInfo(itemID);
                     if(prod != null)
                     {
                        this.setDraggingItemImage(prod.imageURL,363,283);
                     }
                  }
                  break;
               case DMZLootItemSlotType.EQUIPPED_ATTACHMENT:
                  if(itemName != null)
                  {
                     equippedAttachInfo = CFunctionInGameContainer.AS_DMZ_GetAttachmentInfo(itemName);
                     if(equippedAttachInfo != null)
                     {
                        this.setDraggingItemImage(equippedAttachInfo.icon,60,60);
                     }
                  }
                  break;
               case DMZLootItemSlotType.INVENTORY_ATTACHMENT:
                  if(itemName != null)
                  {
                     inventoryAttachInfo = CFunctionInGameContainer.AS_DMZ_GetAttachmentInfo(itemName);
                     if(inventoryAttachInfo != null)
                     {
                        this.setDraggingItemImage(inventoryAttachInfo.icon,80,80);
                     }
                  }
                  break;
               case DMZLootItemSlotType.PERK:
                  if(itemName != null)
                  {
                     itemID = CFunctionCommonContainer.GetItemIDByName(itemName);
                     prod = CFunctionCommonContainer.GetItemInfo(itemID);
                     if(prod != null)
                     {
                        this.setDraggingItemImage(prod.imageURL,80,80);
                     }
                  }
                  break;
               case DMZLootItemSlotType.HEALTH_PACK:
                  if(itemName != null)
                  {
                     if(dragParam.lootIndex > 0)
                     {
                        healthPackInfo = CFunctionInGameContainer.AS_DMZ_GetHealthPackInfo(dragParam.lootIndex - 1);
                        if(healthPackInfo != null)
                        {
                           this.setDraggingItemImage(healthPackInfo.icon,80,80);
                        }
                     }
                  }
                  break;
               case DMZLootItemSlotType.AMMO:
                  if(dragParam.ammoType == "arlmg")
                  {
                     this.setDraggingItemImage("dmz_ammo_arlmg_icon",30,30);
                  }
                  else if(dragParam.ammoType == "pstsmg")
                  {
                     this.setDraggingItemImage("dmz_ammo_pstsmg_icon",30,30);
                  }
                  else if(dragParam.ammoType == "shotgun")
                  {
                     this.setDraggingItemImage("dmz_ammo_shotgun_icon",30,30);
                  }
                  else if(dragParam.ammoType == "sniper")
                  {
                     this.setDraggingItemImage("dmz_ammo_sniper_icon",30,30);
                  }
                  else
                  {
                     this.myDraggingItem.visible = false;
                     this.myDraggingItem.setImage(null);
                  }
                  break;
               case DMZLootItemSlotType.LETHAL:
               case DMZLootItemSlotType.TACTICAL:
                  if(itemName != null)
                  {
                     itemID = CFunctionCommonContainer.GetItemIDByName(itemName);
                     prod = CFunctionCommonContainer.GetItemInfo(itemID);
                     if(prod != null)
                     {
                        this.setDraggingItemImage(prod.imageURL,80,80);
                     }
                  }
                  break;
               default:
                  this.myDraggingItem.visible = false;
                  this.myDraggingItem.setImage(null);
            }
         }
      }
      
      public function onRefreshLoadout(cEvt:ParaEvent) : void
      {
         var loadoutState:Object = null;
         var i:int = 0;
         var j:int = 0;
         loadoutState = cEvt.myPara as Object;
         var newWeapons:Array = [];
         var weapon1Updated:Boolean = false;
         var weapon2Updated:Boolean = false;
         for(i = 0; i < loadoutState.weapons.length; i++)
         {
            if(this.myWeapon1Loadout.myWeaponSlot.getWeapon() == loadoutState.weapons[i].weapon)
            {
               this.refreshWeaponLoadout(this.myWeapon1Loadout,loadoutState.weapons[i]);
               weapon1Updated = true;
            }
            else if(this.myWeapon2Loadout.myWeaponSlot.getWeapon() == loadoutState.weapons[i].weapon)
            {
               this.refreshWeaponLoadout(this.myWeapon2Loadout,loadoutState.weapons[i]);
               weapon2Updated = true;
            }
            else
            {
               newWeapons.push(loadoutState.weapons[i]);
            }
         }
         if(!weapon1Updated)
         {
            this.myWeapon1Loadout.reset();
         }
         if(!weapon2Updated)
         {
            this.myWeapon2Loadout.reset();
         }
         for(i = 0; i < newWeapons.length; i++)
         {
            if(this.myWeapon1Loadout.myWeaponSlot.getWeapon() == 0)
            {
               this.refreshWeaponLoadout(this.myWeapon1Loadout,newWeapons[i]);
            }
            else if(this.myWeapon2Loadout.myWeaponSlot.getWeapon() == 0)
            {
               this.refreshWeaponLoadout(this.myWeapon2Loadout,newWeapons[i]);
            }
         }
         this.myWeapon1Loadout.myWeaponSlot.myActiveTag.visible = false;
         this.myWeapon2Loadout.myWeaponSlot.myActiveTag.visible = false;
         if(Boolean(loadoutState.currentWeapon))
         {
            if(this.myWeapon1Loadout.myWeaponSlot.getWeapon() == loadoutState.currentWeapon)
            {
               this.myWeapon1Loadout.myWeaponSlot.myActiveTag.visible = true;
            }
            if(this.myWeapon2Loadout.myWeaponSlot.getWeapon() == loadoutState.currentWeapon)
            {
               this.myWeapon2Loadout.myWeaponSlot.myActiveTag.visible = true;
            }
         }
         this.setLethal(loadoutState.lethal,loadoutState.lethalAmmoInClip);
         this.setTactical(loadoutState.tactical,loadoutState.tacticalAmmoInClip);
         this.myPerksLoadout.reset();
         for(i = 0; i < loadoutState.perks.length; i++)
         {
            this.setPerk(i,loadoutState.perks[i]);
         }
         this.pstsmgAmmo = loadoutState.ammos[0];
         this.shotgunAmmo = loadoutState.ammos[1];
         this.arlmgAmmo = loadoutState.ammos[2];
         this.sniperAmmo = loadoutState.ammos[3];
         this.myInventory.reset();
         for(i = 0; i < loadoutState.inventoryAttachments.length; i++)
         {
            this.setInventoryAttachment(i,loadoutState.inventoryAttachments[i]);
         }
         this.setInventoryHealthPack(loadoutState.healthPack);
         this.gearScore = loadoutState.gearScore;
         this.setHealthState(loadoutState.health,loadoutState.maxHealth);
         this.setArmorState(loadoutState.armor,loadoutState.maxArmor);
      }
      
      private function refreshWeaponLoadout(weaponLoadout:HudDMZWeaponLoadout, weaponLoadoutState:Object) : void
      {
         var i:int = 0;
         weaponLoadout.reset();
         this.setEquipedWeapon(weaponLoadout,weaponLoadoutState.weapon);
         for(i = 0; i < weaponLoadoutState.fixedAttachments.length; i++)
         {
            this.setEquippedFixedAttachment(weaponLoadout,i,weaponLoadoutState.fixedAttachments[i]);
         }
         for(i = 0; i < weaponLoadoutState.replacableAttachments.length; i++)
         {
            this.setEquippedReplaceableAttachment(weaponLoadout,i,weaponLoadoutState.replacableAttachments[i]);
         }
      }
      
      public function set gearScore(score:int) : void
      {
         if(score < 1000)
         {
            this.myGearBg.gotoAndStop(1);
         }
         else if(score < 2500)
         {
            this.myGearBg.gotoAndStop(2);
         }
         else if(score < 3500)
         {
            this.myGearBg.gotoAndStop(3);
         }
         else
         {
            this.myGearBg.gotoAndStop(4);
         }
         this.myGearScore.text = score.toString();
      }
      
      public function setHealthState(health:int, maxHealth:int) : void
      {
         this.myHealthInfo.text = health.toString() + "/" + maxHealth.toString();
      }
      
      public function setArmorState(armor:int, maxArmor:int) : void
      {
         this.myArmorInfo.text = armor.toString() + "/" + maxArmor.toString();
      }
      
      public function set arlmgAmmo(num:int) : void
      {
         this.myAmmoInfo.arlmgAmmo = num;
      }
      
      public function set pstsmgAmmo(num:int) : void
      {
         this.myAmmoInfo.pstsmgAmmo = num;
      }
      
      public function set shotgunAmmo(num:int) : void
      {
         this.myAmmoInfo.shotgunAmmo = num;
      }
      
      public function set sniperAmmo(num:int) : void
      {
         this.myAmmoInfo.sniperAmmo = num;
      }
      
      public function setInventoryAttachment(slot:int, lootIndex:int) : void
      {
         this.myInventory.setAttachment(slot,lootIndex);
      }
      
      public function setInventoryHealthPack(healthPackIndex:int) : void
      {
         var healthPackInfo:Object = CFunctionInGameContainer.AS_DMZ_GetHealthPackInfo(healthPackIndex);
         if(healthPackInfo == null)
         {
            this.myInventory.myHealthPackSlot.myImage.setImage(null);
            this.myInventory.myHealthPackSlot.lootIndex = 0;
            this.myInventory.myHealthPackSlot.myDropButton.visible = false;
            return;
         }
         this.myInventory.myHealthPackSlot.myImage.setImage(healthPackInfo.icon);
         this.myInventory.myHealthPackSlot.lootIndex = healthPackIndex + 1;
         this.myInventory.myHealthPackSlot.myDropButton.visible = true;
         if(Boolean(CFunctionInGameContainer.AS_IsPlayerDead()))
         {
            this.myInventory.myHealthPackSlot.myDropButton.visible = false;
         }
      }
      
      public function setPerk(slot:int, lootIndex:int) : void
      {
         this.myPerksLoadout.setPerk(slot,lootIndex);
      }
      
      public function setEquipedWeapon(weaponLoadout:HudDMZWeaponLoadout, lootIndex:int) : void
      {
         weaponLoadout.setWeapon(lootIndex);
      }
      
      public function setEquippedFixedAttachment(weaponLoadout:HudDMZWeaponLoadout, slot:int, prod:ProductObj) : void
      {
         weaponLoadout.setFixedAttachment(slot,prod);
      }
      
      public function setEquippedReplaceableAttachment(weaponLoadout:HudDMZWeaponLoadout, slot:int, lootIndex:int) : void
      {
         weaponLoadout.setReplaceableAttachment(slot,lootIndex);
      }
      
      public function setLethal(lootIndex:int, ammoInClip:int) : void
      {
         var itemName:String = CFunctionInGameContainer.AS_DMZ_GetItemByLootIndex(lootIndex);
         trace(itemName);
         if(itemName == null || itemName == "")
         {
            this.myInventory.myLethalSlot.myImage.setImage(null);
            this.myInventory.myLethalSlot.myDropButton.visible = false;
            this.myInventory.myLethalSlot.lootIndex = 0;
            return;
         }
         var itemID:int = CFunctionCommonContainer.GetItemIDByName(itemName);
         var prod:ProductObj = CFunctionCommonContainer.GetItemInfo(itemID);
         if(prod == null)
         {
            this.myInventory.myLethalSlot.myImage.setImage(null);
            this.myInventory.myLethalSlot.myDropButton.visible = false;
            this.myInventory.myLethalSlot.lootIndex = 0;
            return;
         }
         this.myInventory.myLethalSlot.myImage.setImage(prod.imageURL);
         this.myInventory.myLethalSlot.lootIndex = lootIndex;
         this.myInventory.myLethalSlot.myDropButton.visible = false;
         this.myInventory.myLethalSlot.isDraggable = false;
         if(ammoInClip > 0)
         {
            this.myInventory.myLethalSlot.myDropButton.visible = true;
            this.myInventory.myLethalSlot.isDraggable = true;
         }
         if(Boolean(CFunctionInGameContainer.AS_IsPlayerDead()))
         {
            this.myInventory.myLethalSlot.myDropButton.visible = false;
         }
      }
      
      public function setTactical(lootIndex:int, ammoInClip:int) : void
      {
         var itemName:String = CFunctionInGameContainer.AS_DMZ_GetItemByLootIndex(lootIndex);
         trace(itemName);
         if(itemName == null || itemName == "")
         {
            this.myInventory.myTacticalSlot.myImage.setImage(null);
            this.myInventory.myTacticalSlot.myDropButton.visible = false;
            this.myInventory.myTacticalSlot.lootIndex = 0;
            return;
         }
         var itemID:int = CFunctionCommonContainer.GetItemIDByName(itemName);
         var prod:ProductObj = CFunctionCommonContainer.GetItemInfo(itemID);
         if(prod == null)
         {
            this.myInventory.myTacticalSlot.myImage.setImage(null);
            this.myInventory.myTacticalSlot.myDropButton.visible = false;
            this.myInventory.myTacticalSlot.lootIndex = 0;
            return;
         }
         this.myInventory.myTacticalSlot.myImage.setImage(prod.imageURL);
         this.myInventory.myTacticalSlot.lootIndex = lootIndex;
         this.myInventory.myTacticalSlot.myDropButton.visible = false;
         this.myInventory.myTacticalSlot.isDraggable = false;
         if(ammoInClip > 0)
         {
            this.myInventory.myTacticalSlot.myDropButton.visible = true;
            this.myInventory.myTacticalSlot.isDraggable = true;
         }
         if(Boolean(CFunctionInGameContainer.AS_IsPlayerDead()))
         {
            this.myInventory.myTacticalSlot.myDropButton.visible = false;
         }
      }
   }
}

