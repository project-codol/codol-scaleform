package codo.component.factory
{
   import codo.component.Button;
   import codo.component.CharacterRosterGridItem;
   import codo.component.ItemFooterButton;
   import codo.component.NumberButton;
   import codo.component.RestrictionOption;
   import codo.component.ScrollListTabButton;
   import codo.component.SupplyDropButton;
   import codo.component.SupplyDropRewardDetailsButton;
   import codo.component.home.HomeChallengeListItem;
   import codo.component.matchselect.MatchSelectModeOption;
   import codo.component.matchselect.MatchSelectOption;
   import codo.component.matchselect.MatchSelectTheatreOption;
   import codo.component.navigation.parts.NavigationButton;
   import codo.localization.DictMarket;
   import codo.style.ButtonGuide;
   import codo.style.PopupGuide;
   import codo.utils.LocalizeUtil;
   import codo.views.wargod_parts.WarGodSeasonHistoryRow;
   import flash.utils.getDefinitionByName;
   
   public class ButtonFactory
   {
      
      public static const GENERIC_BUTTON_LINKAGE:String = "codo.shared.Button";
      
      public static const ITEM_FOOTER_BUTTON_LINKAGE:String = "codo.shared.ItemFooterButton";
      
      public static const ITEM_FOOTER_INDICATOR_LINKAGE:String = "codo.shared.ItemFooterIndicator";
      
      public static const CALL_TO_ACTION_BUTTON_LINKAGE:String = "codo.shared.callToActionButton";
      
      public static const NAVIGATION_BUTTON_LINKAGE:String = "codo.shared.NavigationButton";
      
      public static const NUMBER_BUTTON_LINKAGE:String = "codo.shared.NumberButton";
      
      public static const SCROLL_LIST_TAB_BUTTON_LINKAGE:String = "codo.shared.ScrollListTabButton";
      
      public static const CHARACTER_ROSTER_GRID_ITEM_LINKAGE:String = "codo.shared.CharacterRosterGridItem";
      
      public static const TAB_NAVIGATION_BUTTON_LINKAGE:String = "codo.shared.TabNavigationButton";
      
      public static const SUPPLY_DROP_BUTTON_LINKAGE:String = "codo.shared.supplyDropButton";
      
      public static const SUPPLY_DROP_REWARD_DETAILS_BUTTON_LINKAGE:String = "codo.shared.supplyDropRewardDetailsButton";
      
      public static const MATCH_SELECT_OPTION_LINKAGE:String = "codo.shared.matchselect.matchSelectOption";
      
      public static const MATCH_SELECT_MODE_OPTION_LINKAGE:String = "codo.shared.matchselect.matchSelectModeOption";
      
      public static const MATCH_SELECT_THEATRE_OPTION_LINKAGE:String = "codo.shared.matchselect.matchSelectTheatreOption";
      
      public static const HOME_CHALLENGE_LIST_ITEM:String = "codo.shared.home.homeChallengeListItem";
      
      public static const ONBOARDING_CHECKLIST_LIST_ITEM:String = "codo.shared.home.onboardingChecklistListItem";
      
      public static const ONBOARDING_CHECKLIST_CHALLENGE_ITEM:String = "codo.shared.home.onboardingChecklistChallengeItem";
      
      public static const AAR_CHALLENGE_LIST_ITEM:String = "codo.shared.aar.aarChallengeListItem";
      
      public static const RESTRICTION_OPTION_LINKAGE:String = "codo.shared.restrictionOption";
      
      public static const RESTRICTION_PREVIEW_OPTION_LINKAGE:String = "codo.shared.restrictionPreviewOption";
      
      public static const WARGOD_SEASON_HISTORY_ROW_LINKAGE:String = "codo.shared.wargod.warGodSeasonHistoryRow";
      
      public function ButtonFactory()
      {
         super();
      }
      
      public static function BUILD_CALL_TO_ACTION_BUTTON() : Button
      {
         var cls:Class = getDefinitionByName(CALL_TO_ACTION_BUTTON_LINKAGE) as Class;
         return new cls() as Button;
      }
      
      public static function BUILD_SECONDARY_MENU_BUTTON() : NavigationButton
      {
         var cls:Class = getDefinitionByName(NAVIGATION_BUTTON_LINKAGE) as Class;
         var itm:NavigationButton = new cls() as NavigationButton;
         itm.textStyle = ButtonGuide.styleSecondaryNavButton;
         itm.height = 44;
         return itm;
      }
      
      public static function BUILD_GENERIC_BUTTON() : Button
      {
         var cls:Class = getDefinitionByName(GENERIC_BUTTON_LINKAGE) as Class;
         return new cls() as Button;
      }
      
      public static function BUILD_MATCH_SELECT_OPTION() : MatchSelectOption
      {
         var cls:Class = getDefinitionByName(MATCH_SELECT_OPTION_LINKAGE) as Class;
         return new cls() as MatchSelectOption;
      }
      
      public static function BUILD_MATCH_SELECT_MODE_OPTION() : MatchSelectModeOption
      {
         var cls:Class = getDefinitionByName(MATCH_SELECT_MODE_OPTION_LINKAGE) as Class;
         return new cls() as MatchSelectModeOption;
      }
      
      public static function BUILD_SELECT_THEATRE_OPTION() : MatchSelectTheatreOption
      {
         var cls:Class = getDefinitionByName(MATCH_SELECT_THEATRE_OPTION_LINKAGE) as Class;
         return new cls() as MatchSelectTheatreOption;
      }
      
      public static function BUILD_HOME_CHALLENGE_LIST_ITEM(style:int = 1) : HomeChallengeListItem
      {
         var cls:Class = getDefinitionByName(HOME_CHALLENGE_LIST_ITEM) as Class;
         var itm:HomeChallengeListItem = new cls() as HomeChallengeListItem;
         itm.setupStyle(style);
         return itm;
      }
      
      public static function BUILD_ITEM_FOOTER_BUTTON(bIsToggleButton:Boolean) : ItemFooterButton
      {
         var cls:Class = getDefinitionByName(ITEM_FOOTER_BUTTON_LINKAGE) as Class;
         var itm:ItemFooterButton = new cls() as ItemFooterButton;
         itm.isTypeToggle = bIsToggleButton;
         return itm;
      }
      
      public static function BUILD_ITEM_FOOTER_INDICATOR() : ItemFooterButton
      {
         var cls:Class = getDefinitionByName(ITEM_FOOTER_INDICATOR_LINKAGE) as Class;
         return new cls() as ItemFooterButton;
      }
      
      public static function BUILD_REPLENSISH_BUTTON(height:uint) : Button
      {
         var itm:Button = ButtonFactory.BUILD_GENERIC_BUTTON();
         itm.myLabel.textStyle = ButtonGuide.styleReplenishButton;
         itm.enabled = false;
         itm.label = LocalizeUtil.localize(DictMarket.REPLENISH);
         itm.width = itm.myLabel.textWidth + 30;
         itm.height = height;
         return itm;
      }
      
      public static function BUILD_POPUP_BUTTON(height:int = -1) : Button
      {
         var itm:Button = ButtonFactory.BUILD_GENERIC_BUTTON();
         itm.myLabel.textStyle = PopupGuide.stylePopupButton;
         itm.enabled = false;
         itm.label = LocalizeUtil.localize(DictMarket.REPLENISH);
         itm.width = itm.myLabel.textWidth + 30;
         if(height > 0)
         {
            itm.height = height;
         }
         return itm;
      }
      
      public static function BUILD_NUMBER_BUTTON() : NumberButton
      {
         var cls:Class = getDefinitionByName(NUMBER_BUTTON_LINKAGE) as Class;
         return new cls() as NumberButton;
      }
      
      public static function BUILD_SCROLL_LIST_TAB_BUTTON(label:String) : ScrollListTabButton
      {
         var cls:Class = getDefinitionByName(SCROLL_LIST_TAB_BUTTON_LINKAGE) as Class;
         return new cls() as ScrollListTabButton;
      }
      
      public static function BUILD_CHARACTER_ROSTER_GRID_ITEM() : CharacterRosterGridItem
      {
         var cls:Class = getDefinitionByName(CHARACTER_ROSTER_GRID_ITEM_LINKAGE) as Class;
         return new cls() as CharacterRosterGridItem;
      }
      
      public static function BUILD_SUPPLY_DROP_REWARD_DETAILS_BUTTON() : SupplyDropRewardDetailsButton
      {
         var cls:Class = getDefinitionByName(SUPPLY_DROP_REWARD_DETAILS_BUTTON_LINKAGE) as Class;
         return new cls() as SupplyDropRewardDetailsButton;
      }
      
      public static function BUILD_SUPPLY_DROP_BUTTON() : SupplyDropButton
      {
         var cls:Class = getDefinitionByName(SUPPLY_DROP_BUTTON_LINKAGE) as Class;
         return new cls() as SupplyDropButton;
      }
      
      public static function BUILD_RESTRICTION_ITEM() : RestrictionOption
      {
         var cls:Class = getDefinitionByName(RESTRICTION_OPTION_LINKAGE) as Class;
         return new cls() as RestrictionOption;
      }
      
      public static function BUILD_RESTRICTION_PREVIEW_ITEM() : RestrictionOption
      {
         var cls:Class = getDefinitionByName(RESTRICTION_PREVIEW_OPTION_LINKAGE) as Class;
         return new cls() as RestrictionOption;
      }
      
      public static function BUILD_WARGOD_SEASON_HISTORY_ROW() : WarGodSeasonHistoryRow
      {
         var cls:Class = getDefinitionByName(WARGOD_SEASON_HISTORY_ROW_LINKAGE) as Class;
         return new cls() as WarGodSeasonHistoryRow;
      }
   }
}

