package components.fsgpopups_part
{
   import codo.base.PopupView;
   import codo.component.TextField;
   import codo.component.loadout.LoadoutButton;
   import codo.constants.BCEvent;
   import codo.localization.Dict;
   import codo.services.MarketService;
   import codo.style.GlobalGuide;
   import flash.display.MovieClip;
   
   public class FsgKillstreakSwapViewContent extends PopupView
   {
      
      private static const STREAK_WIDTH:Number = 125;
      
      private static const STREAK_HEIGHT:Number = 125;
      
      public var myStreak0:LoadoutButton;
      
      public var myStreak1:LoadoutButton;
      
      public var myMessage:TextField;
      
      public var mySwapArrow:MovieClip;
      
      public function FsgKillstreakSwapViewContent()
      {
         super();
         headerTitle = Dict.KILLSTREAK_SELECT_SWAP_POPUP_TITLE;
         this.myMessage.textStyle = GlobalGuide.stylePopupDescription;
         this.myMessage.width = myPopup.popupWidth - this.myMessage.x * 2;
         this.myStreak0.width = STREAK_WIDTH;
         this.myStreak0.height = STREAK_HEIGHT;
         this.myStreak1.width = STREAK_WIDTH;
         this.myStreak1.height = STREAK_HEIGHT;
         myPopup.configConfirmButton(Dict.KILLSTREAK_SWAP_POPUP_CONFIRM,this.onConfirm);
         myPopup.configCancelButton(Dict.CANCEL,this.onCancel);
      }
      
      override public function set routeData(data:*) : void
      {
         super.routeData = data;
         var equippedStreakID:int = int(data.equippedStreakID);
         var newStreakID:int = int(data.newStreakID);
         var equippedItemData:Object = MarketService.getInstance().getItemInfoObj(equippedStreakID);
         var newItemData:Object = MarketService.getInstance().getItemInfoObj(newStreakID);
         this.myStreak0.setData(equippedItemData);
         this.myStreak1.setData(newItemData);
         this.mySwapArrow.visible = true;
      }
      
      override protected function enableData() : void
      {
         super.enableData();
         this.myMessage.text = Dict.KILLSTREAK_SWAP_POPUP_DESCRIPTION;
         myPopup.height = this.myStreak0.y + this.myStreak0.height + this.myMessage.y + this.myMessage.height - 100;
      }
      
      protected function onConfirm() : void
      {
         this.broadcast(BCEvent.EVT_CONFIRM_KILLSTREAK_SWAP);
         closePopupView();
      }
      
      protected function onCancel() : void
      {
         closePopupView();
      }
   }
}

