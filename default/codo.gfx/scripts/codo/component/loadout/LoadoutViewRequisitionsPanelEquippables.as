package codo.component.loadout
{
   import codo.component.factory.MarketFactory;
   import codo.localization.Dict;
   import codo.localization.DictMarket;
   import codo.objects.ScrollGridSettings;
   import codo.objects.ScrollListSettings;
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   import codo.utils.LocalizeUtil;
   
   public class LoadoutViewRequisitionsPanelEquippables extends LoadoutViewBadgesBase
   {
      
      private static const INSTRUCTIONS_WIDTH_BADGES:Number = 200;
      
      private static const INSTRUCTIONS_WIDTH_CONSUMABLE:Number = 506;
      
      private static const IMAGE_SCALE:Number = 0.95;
      
      private static const MASK_SIZE_Y:Number = 587;
      
      public static const SHOW_BADGES:int = 0;
      
      public static const SHOW_ADVANCED_CONSUMABLES:int = 1;
      
      private var mShowType:int = -1;
      
      public function LoadoutViewRequisitionsPanelEquippables()
      {
         super();
      }
      
      override protected function onInit() : void
      {
         super.onInit();
         myBadgeSlot0.scaleImage(IMAGE_SCALE);
         myBadgeSlot1.scaleImage(IMAGE_SCALE);
         myBadgeSlot2.scaleImage(IMAGE_SCALE);
         myConsumableSlot.visible = false;
         myConsumableCount.visible = false;
         var labelStyle:TextStyle = new TextStyle();
         labelStyle.fontSize = GlobalGuide.FONT_SIZE_MEDIUM;
         labelStyle.font = GlobalGuide.FONT_FACE_NUMBERS;
         labelStyle.fontColor = GlobalGuide.WHITE;
         myConsumableCount.textStyle = labelStyle;
         var gridSettings:ScrollGridSettings = new ScrollGridSettings();
         gridSettings.orientation = ScrollListSettings.SCROLL_VERTICAL;
         gridSettings.buildGridItemRenderMethod = MarketFactory.BUILD_MARKET_ITEM_SMALL_CARD_WITH_MARKET_TOOLS;
         gridSettings.useNavArrows = false;
         myScrollGrid.initGrid(gridSettings,MASK_SIZE_Y,true,3);
         myHeaderTitle.width = INSTRUCTIONS_WIDTH_BADGES;
         myHeaderTitle.text = LocalizeUtil.localize(DictMarket.CATEGORY_CALLSIGN_BADGES).toUpperCase();
         myInstructions.width = INSTRUCTIONS_WIDTH_BADGES;
         myInstructions.height = 110;
         myInstructions.text = LocalizeUtil.localize(Dict.REQUISITIONS_EQUIPPABLES_INSTRUCTIONS);
      }
      
      public function changeGridToType(showType:int) : void
      {
         if(showType == this.mShowType)
         {
            return;
         }
         this.mShowType = showType;
         if(showType == SHOW_BADGES)
         {
            myConsumableSlot.visible = false;
            myConsumableCount.visible = false;
            this.setBadgeSlotsVisibility(true);
            myHeaderTitle.width = INSTRUCTIONS_WIDTH_BADGES;
            myInstructions.width = INSTRUCTIONS_WIDTH_BADGES;
            myHeaderTitle.text = LocalizeUtil.localize(DictMarket.CATEGORY_CALLSIGN_BADGES).toUpperCase();
            myInstructions.text = LocalizeUtil.localize(Dict.REQUISITIONS_EQUIPPABLES_INSTRUCTIONS);
            showBadges();
         }
         else
         {
            myConsumableSlot.visible = true;
            myConsumableCount.visible = true;
            this.setBadgeSlotsVisibility(false);
            myHeaderTitle.width = INSTRUCTIONS_WIDTH_CONSUMABLE;
            myInstructions.width = INSTRUCTIONS_WIDTH_CONSUMABLE;
            myHeaderTitle.text = LocalizeUtil.localize(DictMarket.MARKET_ITEM_ADVANCED_CONSUMABLE).toUpperCase();
            myInstructions.text = LocalizeUtil.localize(Dict.REQUISITIONS_ADV_CONSUMABLES_INSTRUCTIONS);
            showConsumables();
         }
      }
      
      public function setBadgeSlotsVisibility(visible:Boolean) : void
      {
         myBadgeSlot0.visible = visible;
         myBadgeSlot1.visible = visible;
         myBadgeSlot2.visible = visible;
      }
   }
}

