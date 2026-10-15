package codo.views.hud.popups.HudTdTurretManageView_parts
{
   import codo.common.CFunctionCommonContainer;
   import codo.component.CallToActionButton;
   import codo.localization.DictTD;
   import codo.views.hud.td.TurretSlot;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class HudTdTurretManageSlot extends MovieClip
   {
      
      private const COST_AFFORDABLE_COLOR:uint = 16549896;
      
      private const COST_UNAFFORDABLE_COLOR:uint = 15617100;
      
      private const BUTTON_WIDTH:Number = 158;
      
      private const BUTTON_HEIGHT:Number = 40;
      
      public var myState:TextField;
      
      public var myCostTitle:TextField;
      
      public var myCostValue:TextField;
      
      public var myInfo:HudTdTurretManageTurretInfo;
      
      public var myEmptyIcon:MovieClip;
      
      public var myButton:CallToActionButton;
      
      public var myDisabledBtn:MovieClip;
      
      private var mSlotState:int;
      
      private var mSlotIndex:int;
      
      private var mPlayerCash:int;
      
      private var mSlotPrice:int;
      
      public function HudTdTurretManageSlot()
      {
         super();
         this.myCostTitle.text = DictTD.COST;
         this.myState.text = DictTD.TURRET_PLACED;
         this.myButton.width = this.BUTTON_WIDTH;
         this.myButton.height = this.BUTTON_HEIGHT;
         this.myButton.setLabelFontSize(20);
         this.myButton.registerClickEvent(this.onButtonClicked);
         (this.myDisabledBtn.myLabel as TextField).text = DictTD.PURCHASE;
      }
      
      public function setData(data:Object) : void
      {
         this.myCostTitle.visible = this.myCostValue.visible = this.myInfo.visible = this.myEmptyIcon.visible = this.myButton.visible = this.myDisabledBtn.visible = false;
         this.mSlotState = data.state;
         switch(data.state)
         {
            case TurretSlot.STATE_EMPTY:
               this.myEmptyIcon.visible = this.myCostTitle.visible = this.myCostValue.visible = true;
               this.myButton.label = DictTD.PURCHASE;
               break;
            case TurretSlot.STATE_UNPLACE:
               this.myInfo.visible = this.myButton.visible = true;
               this.myButton.label = DictTD.TURRET_PLACEABLE;
               break;
            case TurretSlot.STATE_PLACED:
               this.myInfo.visible = true;
               break;
            case TurretSlot.STATE_NONE:
            case TurretSlot.STATE_LOCK:
            default:
               return;
         }
         if(this.myInfo.visible)
         {
            this.myInfo.setData(data.turretInfo);
         }
      }
      
      public function set slotIndex(index:int) : void
      {
         this.mSlotIndex = index;
      }
      
      public function set slotPrice(price:int) : void
      {
         this.mSlotPrice = price;
         this.myCostValue.text = "$" + this.mSlotPrice;
         this.updateAffordableState();
      }
      
      public function set playerCash(cash:int) : void
      {
         this.mPlayerCash = cash;
         this.updateAffordableState();
      }
      
      private function onButtonClicked() : void
      {
         switch(this.mSlotState)
         {
            case TurretSlot.STATE_EMPTY:
               CFunctionCommonContainer.ScriptMenuResponse("td_turret_manage","buy|" + this.mSlotIndex);
               break;
            case TurretSlot.STATE_UNPLACE:
               CFunctionCommonContainer.ScriptMenuResponse("td_turret_manage","put|" + this.mSlotIndex);
         }
      }
      
      private function updateAffordableState() : void
      {
         var affordable:Boolean = false;
         if(this.mSlotState == TurretSlot.STATE_EMPTY)
         {
            affordable = this.mPlayerCash >= this.mSlotPrice;
            this.myCostValue.textColor = affordable ? this.COST_AFFORDABLE_COLOR : this.COST_UNAFFORDABLE_COLOR;
            this.myButton.visible = affordable;
            this.myDisabledBtn.visible = !affordable;
         }
      }
   }
}

