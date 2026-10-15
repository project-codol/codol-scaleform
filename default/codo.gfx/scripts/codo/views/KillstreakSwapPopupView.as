package codo.views
{
   import codo.base.PopupView;
   import codo.component.TextField;
   import codo.component.loadout.LoadoutButton;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.localization.Dict;
   import codo.objects.BindDataHelper;
   import codo.objects.ItemSlotObj;
   import codo.objects.WeaponLoadoutObj;
   import codo.services.MarketService;
   import codo.style.GlobalGuide;
   
   public class KillstreakSwapPopupView extends PopupView
   {
      
      private static const STREAK_WIDTH:Number = 125;
      
      private static const STREAK_HEIGHT:Number = 125;
      
      public var myStreak0:LoadoutButton;
      
      public var myStreak1:LoadoutButton;
      
      public var myStreak2:LoadoutButton;
      
      public var myMessage:TextField;
      
      private var mBindWeaponLoadoutSlotsData:BindDataHelper;
      
      private var killstreakToEquip:Object;
      
      public function KillstreakSwapPopupView()
      {
         super();
         this.mBindWeaponLoadoutSlotsData = new BindDataHelper(DataID.WEAPONLOADOUT_SLOTSDATA,this.bindLoadoutData);
         headerTitle = Dict.KILLSTREAK_SELECT_SWAP_POPUP_TITLE;
         this.myMessage.textStyle = GlobalGuide.stylePopupDescription;
         this.myStreak0.width = STREAK_WIDTH;
         this.myStreak0.height = STREAK_HEIGHT;
         this.myStreak1.width = STREAK_WIDTH;
         this.myStreak1.height = STREAK_HEIGHT;
         this.myStreak2.width = STREAK_WIDTH;
         this.myStreak2.height = STREAK_HEIGHT;
         this.myMessage.width = myPopup.popupWidth - this.myMessage.x * 2;
         this.myStreak0.registerClickEvent(this.onKillstreakClicked,0);
         this.myStreak1.registerClickEvent(this.onKillstreakClicked,1);
         this.myStreak2.registerClickEvent(this.onKillstreakClicked,2);
         myPopup.configCancelButton(Dict.CANCEL,this.onCancel);
      }
      
      override public function set routeData(data:*) : void
      {
         this.killstreakToEquip = MarketService.getInstance().getItemInfoObj(data.newStreakID);
      }
      
      override protected function enableData() : void
      {
         super.enableData();
         this.mBindWeaponLoadoutSlotsData.bind();
         this.myMessage.text = Dict.KILLSTREAK_SELECT_SWAP_POPUP_DESC;
         myPopup.height = this.myStreak0.y + this.myStreak0.height + this.myMessage.y + this.myMessage.height - 100;
      }
      
      override protected function disableData() : void
      {
         this.mBindWeaponLoadoutSlotsData.unbind();
      }
      
      private function bindLoadoutData(cResult:Object) : void
      {
         var loadoutButton:LoadoutButton = null;
         var item:ItemSlotObj = null;
         var weaponLoadout:WeaponLoadoutObj = new WeaponLoadoutObj(cResult.data);
         for(var i:int = 0; i < 3; i++)
         {
            item = new ItemSlotObj(weaponLoadout["killStreakSlot_" + i]);
            loadoutButton = this["myStreak" + i];
            loadoutButton.setData(item);
         }
      }
      
      private function onKillstreakClicked(index:int) : void
      {
         var loadoutButton:LoadoutButton = this["myStreak" + index];
         EventManager.broadcast(BCEvent.EVT_WEAPONLOADOUT_UNEQUIP_ITEM,{"data":loadoutButton.getData()});
         EventManager.broadcast(BCEvent.EVT_EQUIP,{"item":this.killstreakToEquip});
         closePopupView();
      }
      
      private function onCancel() : void
      {
         closePopupView();
      }
   }
}

