package codo.controllers
{
   import codo.base.BaseController;
   import codo.common.CFunctionInGameContainer;
   import codo.constants.BCInGameEvent;
   import codo.constants.CodoInGamePageDB;
   import codo.constants.DataID;
   import codo.constants.ViewState;
   import codo.event.ParaEvent;
   import codo.manager.PageInGameManager;
   
   public class DMZLoadoutController extends BaseController
   {
      
      private var mDraggingItemType:int;
      
      private var mDraggingItemLootIndex:int;
      
      private var mDraggingItemWeaponLootIndex:int;
      
      private var mDraggingItemAmmoType:String;
      
      public function DMZLoadoutController()
      {
         super();
         listen(BCInGameEvent.EVT_DMZ_FORCE_REFRESH_LOADOUT,this.onForceRefreshLoadout);
         listen(BCInGameEvent.EVT_DMZ_LOADOUT_SET_DRAGGING_ITEM_PARAM,this.onSetDraggingItemParam);
         addDP(DataID.DMZ_DRAGGING_ITEM_PARAM,this.onGetDraggingItemParam);
      }
      
      public function cppShowLoadoutView() : void
      {
         PageInGameManager.getInstance().showPage(CodoInGamePageDB.PAGE_DMZ_LOADOUT,false,ViewState.ACTIVATED,null);
      }
      
      public function cppHideLoadoutView() : void
      {
         PageInGameManager.getInstance().cleanPageLayer(CodoInGamePageDB.PAGE_DMZ_LOADOUT.owner);
      }
      
      public function cppRefreshLoadout(loadoutState:Object) : void
      {
         broadcast(BCInGameEvent.EVT_DMZ_REFRESH_LOADOUT,loadoutState);
      }
      
      private function onForceRefreshLoadout(evt:ParaEvent) : void
      {
         CFunctionInGameContainer.AS_DMZ_RefreshLoadout();
      }
      
      private function onSetDraggingItemParam(evt:ParaEvent) : void
      {
         if(Boolean(CFunctionInGameContainer.AS_IsPlayerDead()))
         {
            return;
         }
         this.mDraggingItemType = evt.myPara.type;
         this.mDraggingItemLootIndex = evt.myPara.lootIndex;
         this.mDraggingItemWeaponLootIndex = evt.myPara.weaponLootIndex;
         this.mDraggingItemAmmoType = evt.myPara.ammoType;
      }
      
      private function onGetDraggingItemParam() : Object
      {
         return {
            "type":this.mDraggingItemType,
            "lootIndex":this.mDraggingItemLootIndex,
            "weaponLootIndex":this.mDraggingItemWeaponLootIndex,
            "ammoType":this.mDraggingItemAmmoType
         };
      }
   }
}

