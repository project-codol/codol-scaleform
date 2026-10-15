package codo.views.hudDMZLoadout
{
   import codo.common.CFunctionCommonContainer;
   import codo.component.CloseButton;
   import codo.constants.BCInGameEvent;
   import codo.constants.DMZLootItemSlotType;
   import codo.manager.EventManager;
   import codo.utils.CursorUtil;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import fsg.util.FsgImageHolder;
   
   public class HudDMZAmmoSlot extends MovieClip
   {
      
      public var myDropButton:CloseButton;
      
      public var myCount:TextField;
      
      public var myIcon:FsgImageHolder;
      
      private var mAmmoType:String;
      
      public function HudDMZAmmoSlot()
      {
         super();
         this.myDropButton.addEventListener(MouseEvent.MOUSE_DOWN,this.onDropButtonClick);
         addEventListener(MouseEvent.MOUSE_DOWN,this.onItemMouseDown);
         addEventListener(MouseEvent.MOUSE_OVER,this.onItemMouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.onItemMouseOut);
         this.mAmmoType = "undefined";
      }
      
      public function set ammoType(ammoType:String) : void
      {
         this.mAmmoType = ammoType;
         if(this.mAmmoType == "arlmg")
         {
            this.myIcon.setImage("dmz_ammo_arlmg_icon");
         }
         else if(this.mAmmoType == "pstsmg")
         {
            this.myIcon.setImage("dmz_ammo_pstsmg_icon");
         }
         else if(this.mAmmoType == "shotgun")
         {
            this.myIcon.setImage("dmz_ammo_shotgun_icon");
         }
         else if(this.mAmmoType == "sniper")
         {
            this.myIcon.setImage("dmz_ammo_sniper_icon");
         }
      }
      
      private function onDropButtonClick(cEvt:MouseEvent) : void
      {
         CFunctionCommonContainer.ScriptMenuResponse("dmz_loadout_drag","4_" + DMZLootItemSlotType.AMMO + "_" + "0" + "_" + "0" + "_" + this.mAmmoType);
      }
      
      private function onItemMouseOver(cEvt:MouseEvent) : void
      {
         if(this.myCount.text == "0")
         {
            return;
         }
         CursorUtil.BeginCursor(CursorUtil.CURSOR_OVER_BUTTON);
      }
      
      private function onItemMouseOut(cEvt:MouseEvent) : void
      {
         CursorUtil.EndCursor(CursorUtil.CURSOR_OVER_BUTTON);
      }
      
      private function onItemMouseDown(cEvt:MouseEvent) : void
      {
         if(this.myCount.text == "0")
         {
            return;
         }
         EventManager.getInstance().broadcast(BCInGameEvent.EVT_DMZ_LOADOUT_SET_DRAGGING_ITEM_PARAM,{
            "type":DMZLootItemSlotType.AMMO,
            "lootIndex":0,
            "weaponLootIndex":0,
            "ammoType":this.mAmmoType
         });
      }
   }
}

