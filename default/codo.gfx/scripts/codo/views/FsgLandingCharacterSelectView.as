package codo.views
{
   import codo.base.BaseView;
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.component.CharacterSwitchModule;
   import codo.constants.BCEvent;
   import codo.constants.Common;
   import codo.constants.DataID;
   import codo.constants.ItemType;
   import codo.constants.PageID;
   import codo.event.ParaEvent;
   import codo.objects.BindDataHelper;
   import codo.objects.CharacterObj;
   import codo.objects.ProductObj;
   import codo.objects.RoomMemberObj;
   import codo.services.CharacterLoadoutService;
   import codo.services.WeaponLoadoutService;
   import codo.utils.LocalizeUtil;
   import com.greensock.TweenLite;
   import flash.events.Event;
   
   public class FsgLandingCharacterSelectView extends BaseView
   {
      
      private static const MODULE_FADE_DURATION:Number = 0.25;
      
      public var myCharacterSwitchModule:CharacterSwitchModule;
      
      private var m_bindCharacter:BindDataHelper;
      
      private var m_bindRoomInfo:BindDataHelper;
      
      private var m_bindDataReceive:BindDataHelper;
      
      private var m_bindMktMaintainState:BindDataHelper;
      
      private var m_bindLoadoutSlots:BindDataHelper;
      
      private var m_pendingReveal:Boolean = false;
      
      public function FsgLandingCharacterSelectView()
      {
         super();
      }
      
      override protected function onInit() : void
      {
         super.onInit();
         this.m_bindCharacter = createBindHelper(DataID.CHARACTERLOADOUT_CHARACTERS,this.bindData_characters);
         this.m_bindRoomInfo = createBindHelper(DataID.ROOM_INFO,this.bindData_roomInfo);
         this.m_bindDataReceive = createBindHelper(DataID.DATA_RECEIVE,this.bind_dataReceived);
         this.m_bindMktMaintainState = createBindHelper(DataID.MARKETPLACE_MAINTAIN_STATE,this.bind_mktMaintainState);
         this.m_bindLoadoutSlots = createBindHelper(DataID.WEAPONLOADOUT_SLOTSDATA,this.refreshLoadouts);
         this.myCharacterSwitchModule.registerGotoNextLoadoutCallback(this.onNextLoadout);
         this.myCharacterSwitchModule.registerGotoPrevLoadoutCallback(this.onPrevLoadout);
      }
      
      override protected function enableData() : void
      {
         this.m_bindCharacter.bind();
         this.m_bindRoomInfo.bind();
         this.m_bindDataReceive.bind();
         this.m_bindMktMaintainState.bind();
         this.m_bindLoadoutSlots.bind();
         listen(BCEvent.EVT_MAIN_PAGE_ID_CHANGED,this.onPageChangeHandle);
         listen(BCEvent.EVT_EQUIP,this.onMarketPreview);
         listen(BCEvent.EVT_PREVIEW_REMOVE,this.onMarketPreviewRemove);
         listen(BCEvent.EVT_PREVIEW_REMOVE_ALL,this.onMarketPreviewRemoveAll);
         listen(BCEvent.EVT_REFRESH_UI_AFTER_INVENTORY_CHANGE,this.onInventoryChanged);
      }
      
      private function refreshLoadouts() : void
      {
         var currentCharacterIndex:int = CFunctionCommonContainer.CL_GetCurrentCharacterLoadoutIndex();
         var maxNumSlots:int = CFunctionCommonContainer.WL_GetMaxNumLoadouts();
         var weaponIndex:int = CFunctionCommonContainer.WL_GetCurrentWeaponLoadoutIndex();
         var loadoutIndex:int = currentCharacterIndex * maxNumSlots + weaponIndex;
         var name:String = CFunctionContainer.WL_GetLoadoutName(loadoutIndex,weaponIndex);
         this.myCharacterSwitchModule.setCurrentLoadout(weaponIndex + 1,LocalizeUtil.localize(name));
      }
      
      private function onMarketPreviewRemove(e:ParaEvent) : void
      {
         var item:Object = e.myPara.item;
         if(item.type == ItemType.CHA)
         {
            this.myCharacterSwitchModule.killPreviewImage();
         }
      }
      
      private function onMarketPreviewRemoveAll(e:ParaEvent) : void
      {
         this.myCharacterSwitchModule.killPreviewImage();
      }
      
      private function onInventoryChanged(e:ParaEvent) : void
      {
         this.myCharacterSwitchModule.refreshDisplay();
      }
      
      private function onMarketPreview(e:ParaEvent) : void
      {
         var isPreviewing:Boolean = Boolean(e.myPara.isPreviewing);
         var item:ProductObj = e.myPara.item as ProductObj;
         if(isPreviewing && item.type == ItemType.CHA)
         {
            this.myCharacterSwitchModule.setPreviewCharacter(item.imageURL);
         }
      }
      
      override protected function disableData() : void
      {
         this.m_bindCharacter.unbind();
         this.m_bindRoomInfo.unbind();
         this.m_bindDataReceive.unbind();
         this.m_bindMktMaintainState.unbind();
         this.m_bindLoadoutSlots.unbind();
         unlisten(BCEvent.EVT_MAIN_PAGE_ID_CHANGED,this.onPageChangeHandle);
         unlisten(BCEvent.EVT_EQUIP,this.onMarketPreview);
         unlisten(BCEvent.EVT_PREVIEW_REMOVE,this.onMarketPreviewRemove);
         unlisten(BCEvent.EVT_PREVIEW_REMOVE_ALL,this.onMarketPreviewRemove);
      }
      
      override protected function showView() : void
      {
         super.showView();
         var closing:Boolean = hasEventListener(Event.ENTER_FRAME);
         if(closing)
         {
            removeEventListener(Event.ENTER_FRAME,this.onCheckFrame);
         }
         if(this.dataIsReady())
         {
            this.m_pendingReveal = false;
            this.initForPage();
         }
         else
         {
            this.m_pendingReveal = true;
            this.myCharacterSwitchModule.hide();
         }
      }
      
      private function onPageChangeHandle(cEvt:ParaEvent) : void
      {
         this.initForPage();
      }
      
      private function initForPage() : void
      {
         var charSwitchable:Boolean = false;
         var charVisible:Boolean = false;
         var id:String = getDP(DataID.CURRENT_MAIN_PAGE_ID);
         switch(id)
         {
            case PageID.LOADOUT_SELECTION:
               charSwitchable = false;
               charVisible = true;
               break;
            case PageID.MARKET_ITEM_DETAILS:
            case PageID.MATCH_SELECT:
            case PageID.SUPPLY_DROP:
            case PageID.SUPPLY_DROP_REWARD_SELECTION:
            case PageID.MOTD_CHECKIN_REWARDS:
               charSwitchable = false;
               charVisible = false;
               break;
            default:
               charSwitchable = true;
               charVisible = true;
         }
         if(charSwitchable)
         {
            this.myCharacterSwitchModule.show();
         }
         else
         {
            this.myCharacterSwitchModule.hide();
         }
         if(charVisible && !this.myCharacterSwitchModule.visible)
         {
            this.myCharacterSwitchModule.visible = true;
            this.myCharacterSwitchModule.alpha = 0;
            TweenLite.to(this.myCharacterSwitchModule,MODULE_FADE_DURATION,{"alpha":1});
         }
         else if(!charVisible)
         {
            this.myCharacterSwitchModule.visible = false;
         }
      }
      
      override protected function hideView() : void
      {
         this.m_pendingReveal = false;
         this.myCharacterSwitchModule.hide();
         super.hideView();
      }
      
      private function onCheckFrame(evt:Event) : void
      {
         if(evt.currentTarget.currentFrame == 1)
         {
            removeEventListener(Event.ENTER_FRAME,this.onCheckFrame);
            super.hideView();
         }
      }
      
      private function bind_dataReceived(cRes:Object) : void
      {
         if(cRes.result == 1 && (cRes.data == Common.MARKET_RECEIVED || cRes.data == Common.PLAYERDATA_RECEIVED))
         {
            this.checkDataReady();
         }
      }
      
      private function bind_mktMaintainState(cRes:Object) : void
      {
         var closing:Boolean = false;
         var isDataAvailable:Boolean = getDP(DataID.IS_DATA_AVAILABLE);
         if(!isDataAvailable)
         {
            this.m_pendingReveal = true;
            this.mouseEnabled = this.mouseChildren = false;
         }
         else
         {
            this.m_pendingReveal = false;
            closing = hasEventListener(Event.ENTER_FRAME);
            if(closing)
            {
               removeEventListener(Event.ENTER_FRAME,this.onCheckFrame);
            }
            this.visible = true;
            this.mouseEnabled = this.mouseChildren = true;
         }
      }
      
      private function checkDataReady() : void
      {
         if(this.m_pendingReveal)
         {
            if(this.dataIsReady())
            {
               this.m_pendingReveal = false;
               this.initForPage();
            }
         }
      }
      
      private function dataIsReady() : Boolean
      {
         var chars:Vector.<CharacterObj> = null;
         var isDataAvailable:Boolean = getDP(DataID.IS_DATA_AVAILABLE);
         if(isDataAvailable)
         {
            chars = CharacterLoadoutService.getInstance().getAssignedCharacterArray();
            if(chars != null && chars.length > 0)
            {
               this.mouseEnabled = this.mouseChildren = true;
               return true;
            }
         }
         this.mouseEnabled = this.mouseChildren = false;
         return false;
      }
      
      private function bindData_characters(cResult:Object) : void
      {
         this.checkDataReady();
      }
      
      private function bindData_roomInfo(cRes:Object) : void
      {
         var roomMemberObj:RoomMemberObj = null;
         if(cRes.data == null)
         {
            return;
         }
         var isInRankedMatch:Boolean = getDP(DataID.IS_IN_RANKED_MATCH) as Boolean;
         if(isInRankedMatch)
         {
            roomMemberObj = getDP(DataID.ROOM_MEMBER_OBJ,[getDP(DataID.PLAYER_USER_NAME)]);
            if(roomMemberObj != null)
            {
               CharacterLoadoutService.getInstance().changeFactionIdx(roomMemberObj.team);
               this.myCharacterSwitchModule.refreshFaction();
            }
         }
      }
      
      private function onNextLoadout() : void
      {
         this.selectLoadout(1);
      }
      
      private function onPrevLoadout() : void
      {
         this.selectLoadout(-1);
      }
      
      private function selectLoadout(dir:int) : void
      {
         var maxLoadouts:int = CFunctionCommonContainer.WL_GetMaxNumLoadouts();
         var curLoadout:int = CFunctionCommonContainer.WL_GetCurrentWeaponLoadoutIndex();
         var tryNext:Boolean = true;
         while(tryNext)
         {
            curLoadout += dir;
            if(curLoadout < 0)
            {
               curLoadout = maxLoadouts - 1;
            }
            else if(curLoadout >= maxLoadouts)
            {
               curLoadout = 0;
            }
            tryNext = !CFunctionCommonContainer.isLoadoutUsable(curLoadout);
         }
         WeaponLoadoutService.getInstance().changeLoadout(curLoadout);
      }
   }
}

