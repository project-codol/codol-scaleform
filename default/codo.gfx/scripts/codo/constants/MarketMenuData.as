package codo.constants
{
   import codo.cpp.UiCppItemListView;
   import codo.cpp.UiCppNewItems;
   import codo.cpp.UiCppOnboarding;
   import codo.localization.Dict;
   import codo.localization.DictBattleCity;
   import codo.localization.DictMarket;
   
   public class MarketMenuData
   {
      
      public static const TYPE_CALLSIGN:String = "callsign";
      
      public static const TYPE_CHARACTER:String = "cha";
      
      public static const TYPE_GAMEMODE:String = "itm";
      
      public static const TYPE_PERK:String = "per";
      
      public static const TYPE_CALLSIGN_BKG:String = "pcb";
      
      public static const TYPE_CALLSIGN_TITLE:String = "pct";
      
      public static const TYPE_CALLSIGN_EMBLEM:String = "pci";
      
      public static const TYPE_CALLSIGN_NAMEPLATE:String = "pcn";
      
      public static const TYPE_CALLSIGN_FRAME:String = "pcf";
      
      public static const TYPE_GAMEMODE_TOKEN:String = "tok";
      
      public static const TYPE_GAMEMODE_SHARD:String = "sha";
      
      public static const TYPE_GAMEMODE_ASYM_ROBOTS:String = "asy";
      
      public static const TYPE_CALLSIGN_BADGE:String = "bdg";
      
      public static const TYPE_CALLSIGN_CHANGE_NAME:String = "cnc";
      
      public static const SLOT_PRIMARY:String = "primary";
      
      public static const SLOT_SECONDARY:String = "secondary";
      
      public static const SLOT_MELEE:String = "sword";
      
      public static const SLOT_EQUIPMENT:String = "equipment";
      
      public static const SLOT_PERK:String = "perk";
      
      public static const SLOT_BUNDLE:String = "bundle";
      
      public static const TYPE_WEAPON:String = "wea";
      
      public static const TYPE_EQUIPMENT:String = "equ";
      
      public static const SLOT_COSMETIC:String = "cosm1";
      
      public static const SLOT_COSMETIC2:String = "cosm2";
      
      public static const SLOT_CAMO:String = "cam";
      
      public static const SLOT_ATTACH:Vector.<String> = new <String>["func1","func2","func3"];
      
      public static const TYPE_ATTACH:String = "wat";
      
      public static const SLOT_DECAL:String = "dec";
      
      public static const GRP_WPN_ASSAULT:String = "ast";
      
      public static const GRP_WPN_SMG:String = "smg";
      
      public static const GRP_WPN_LMG:String = "lmg";
      
      public static const GRP_WPN_SHOTGUN:String = "sho";
      
      public static const GRP_WPN_SNIPER:String = "snp";
      
      public static const GRP_WPN_OTHER:String = "oth";
      
      public static const GRP_WPN_MELEE_SWORD:String = "swd";
      
      public static const GRP_WPN_MELEE_KNIFE:String = "mel";
      
      public static const GRP_WPN_PISTOL:String = "pst";
      
      public static const GRP_WPN_MPISTOL:String = "mps";
      
      public static const GRP_WPN_LAUNCHER:String = "rkt";
      
      public static const GRP_SCOPE:String = "sco";
      
      public static const GRP_MUZZLE:String = "muz";
      
      public static const GRP_BASE:String = "bas";
      
      public static const GRP_BIPOD:String = "bip";
      
      public static const GRP_RAIL:String = "rai";
      
      public static const GRP_SIDERAIL:String = "sra";
      
      public static const GRP_GRIP:String = "gri";
      
      public static const GRP_CLOSE_QUARTERS:String = "cqc";
      
      public static const GRP_MAGAZINE:String = "mag";
      
      public static const GRP_STOCK:String = "sto";
      
      public static const GRP_RETICLE:String = "ret";
      
      public static const GRP_IRONSIGHT:String = "iro";
      
      public static const GRP_LETHAL:String = "let";
      
      public static const GRP_SPECIAL:String = "spe";
      
      public static const GRP_TACTICAL:String = "tac";
      
      public static const TYPE_KILLSTREAK:String = "kis";
      
      public static const GRP_KIS_STANDARD:String = "std";
      
      public static const GRP_KIS_PRO:String = "pro";
      
      public static const GRP_PERK1:String = "pk1";
      
      public static const GRP_PERK2:String = "pk2";
      
      public static const GRP_PERK3:String = "pk3";
      
      public static const GRP_HEADGEAR:String = "heg";
      
      public static const GRP_EYEWEAR:String = "eye";
      
      public static const GRP_TATTOO:String = "elp";
      
      public static const GRP_JACKET:String = "fja";
      
      public static const GRP_GLOVE:String = "han";
      
      public static const GRP_VEST:String = "ves";
      
      public static const GRP_PANTS:String = "fpa";
      
      public static const GRP_KNIFE:String = "mel";
      
      public static const GRP_EMOTE:String = "emo";
      
      public static const GRP_SUPPLY_DROP:String = "sup";
      
      public static const GRP_EQUIPPABLE_TOKEN:String = "etk";
      
      public static const GRP_WILDCARD:String = "wld";
      
      public static const GRP_LOADOUT_SLOT:String = "cac";
      
      public static const GRP_BUNDLE:String = "bnd";
      
      public static const GRP_OUTFIT:String = "oft";
      
      public static const GRP_GIFTBOX:String = "gbx";
      
      public static const GRP_SUPPLY_DROP_BUNDLE:String = "sdb";
      
      public static const GRP_WEAPON_BUNDLE:String = "wbd";
      
      public static const GRP_LOADOUT_BUNDLE:String = "lob";
      
      public static const GRP_CLAN:String = "clan";
      
      public static const CLAN_EXCLUSIVE_BRONZE:String = "clan_1";
      
      public static const CLAN_EXCLUSIVE_SILVER:String = "clan_2";
      
      public static const CLAN_EXCLUSIVE_GOLD:String = "clan_3";
      
      public static const CLAN_EXCLUSIVE_PLATINUM:String = "clan_4";
      
      public static const CLAN_EXCLUSIVE_DIAMOND:String = "clan_5";
      
      public static const GRP_WARGOD:String = "wargod";
      
      public static const GRP_SENIOR_WARGOD:String = "senior_wargod";
      
      public static const WARGOD_MKT_J1:String = "wargod_1";
      
      public static const WARGOD_MKT_J2:String = "wargod_2";
      
      public static const WARGOD_MKT_J3:String = "wargod_3";
      
      public static const WARGOD_MKT_J4:String = "wargod_4";
      
      public static const WARGOD_MKT_J5:String = "wargod_5";
      
      public static const WARGOD_MKT_J6:String = "wargod_6";
      
      public static const WARGOD_MKT_BRONZE:String = "wargod_7";
      
      public static const WARGOD_MKT_SILVER:String = "wargod_8";
      
      public static const WARGOD_MKT_GOLD:String = "wargod_9";
      
      public static const WARGOD_MKT_PLATINUM:String = "wargod_10";
      
      public static const WARGOD_MKT_DIAMOND:String = "wargod_11";
      
      public static const WARGOD_MKT_HEROIC:String = "wargod_12";
      
      public static const GRP_NOTSALE:String = "notsale";
      
      public static const NOTSALE_MKT_EVENT:String = "notsale_evt";
      
      public static const NOTSALE_MKT_PVE:String = "notsale_pve";
      
      public static const NOTSALE_MKT_PVP:String = "notsale_pvp";
      
      public static const NOTSALE_MKT_OTHER:String = "notsale_oth";
      
      public static const NOTSALE_MKT_EXTINCTION:String = "notsale_ext";
      
      public static const SUPPLY_DROP_BASIC:int = 60216;
      
      public static const SUPPLY_DROP_ADVANCED:int = 60217;
      
      public static const SUPPLY_DROP_EVENT:int = 11861;
      
      public static const CURRENCY_GAME_POINT:int = 1;
      
      public static const CURRENCY_BSD_POINTS:int = 5;
      
      public static const CURRENCY_ASD_POINTS:int = 6;
      
      public static const CURRENCY_LSD_POINTS:int = 7;
      
      public static const CURRENCY_HERO_POINT:int = 8;
      
      public static const CURRENCY_EPIC_HERO_POINT:int = 9;
      
      public static const CURRENCY_BCL_FREE:int = 10;
      
      public static const CURRENCY_BCL_BATTLE:int = 11;
      
      public static const SORT_OPTION_NORMAL:int = 0;
      
      public static const SORT_OPTION_WARGOD:int = 1;
      
      public static const SORT_OPTION_NOTSALE:int = 2;
      
      public static const SORT_OPTION_BRAND:int = 3;
      
      public static const SECONDARY_FILTER_OPTION_NULL:int = 0;
      
      public static const SECONDARY_FILTER_OPTION_NOTSALE:int = 1;
      
      public static const PREVIEWABLE_ITEM_CATEGORY_MAPPING:Vector.<String> = new <String>[TYPE_WEAPON,TYPE_CHARACTER,GRP_HEADGEAR,GRP_EYEWEAR,GRP_JACKET,GRP_VEST,GRP_TATTOO,GRP_GLOVE,GRP_PANTS];
      
      public static const TAB_FEATURED:int = 0;
      
      public static const TAB_BUNDLE:int = 1;
      
      public static const TAB_WEAPONS:int = 2;
      
      public static const TAB_CHARS:int = 3;
      
      public static const TAB_GAMEPLAY:int = 4;
      
      public static const TAB_PLAYER:int = 5;
      
      public static const TAB_CLAN:int = 6;
      
      public static const TAB_WARGOD:int = 7;
      
      public static const TAB_WEAPON_ILLUSTRATION:int = 8;
      
      public static const MARKET_CATEGORY_LABELS_PRIMARY:Object = {
         "id":SLOT_PRIMARY,
         "label":DictMarket.ITEM_MENU_PRIMARY,
         "categoryFunc":UiCppItemListView.FUNC_USE_WPN_PRI,
         "breadcrumb":UiCppNewItems.CRUMB_PRIMARIES,
         "child":[{
            "allItems":true,
            "label":DictMarket.CATEGORY_ALL
         },{
            "id":GRP_WPN_ASSAULT,
            "label":DictMarket.CATEGORY_ASSAULT_RIFLE,
            "breadcrumb":UiCppNewItems.CRUMB_ASSAULT_RIFLES
         },{
            "id":GRP_WPN_SMG,
            "label":DictMarket.CATEGORY_SMG,
            "breadcrumb":UiCppNewItems.CRUMB_SMGS
         },{
            "id":GRP_WPN_LMG,
            "label":DictMarket.CATEGORY_LMG,
            "breadcrumb":UiCppNewItems.CRUMB_LMGS
         },{
            "id":GRP_WPN_SHOTGUN,
            "label":DictMarket.CATEGORY_SHOTGUN,
            "breadcrumb":UiCppNewItems.CRUMB_SHOTGUNS
         },{
            "id":GRP_WPN_SNIPER,
            "label":DictMarket.CATEGORY_SNIPER,
            "breadcrumb":UiCppNewItems.CRUMB_SNIPERS
         },{
            "id":GRP_WPN_OTHER,
            "label":DictMarket.CATEGORY_OTHER,
            "breadcrumb":UiCppNewItems.CRUMB_OTHER_PRIMARIES
         }]
      };
      
      public static const MARKET_CATEGORY_LABELS_SECONDARY:Object = {
         "id":SLOT_SECONDARY,
         "label":DictMarket.ITEM_MENU_SECONDARYWEAP,
         "categoryFunc":UiCppItemListView.FUNC_USE_WPN_SEC,
         "breadcrumb":UiCppNewItems.CRUMB_SECONDARIES,
         "child":[{
            "allItems":true,
            "label":DictMarket.CATEGORY_ALL
         },{
            "id":GRP_WPN_PISTOL,
            "label":DictMarket.CATEGORY_PISTOL,
            "breadcrumb":UiCppNewItems.CRUMB_PISTOLS
         },{
            "id":GRP_WPN_MPISTOL,
            "label":DictMarket.CATEGORY_MACHINE_PISTOL,
            "breadcrumb":UiCppNewItems.CRUMB_MACHINE_PISTOLS
         },{
            "id":GRP_WPN_LAUNCHER,
            "label":DictMarket.CATEGORY_LAUNCHER,
            "breadcrumb":UiCppNewItems.CRUMB_LAUNCHERS
         }]
      };
      
      public static const MARKET_CATEGORY_LABELS_PRIMARY_OVERKILL:Object = {
         "id":SLOT_PRIMARY,
         "label":DictMarket.ITEM_MENU_PRIMARY,
         "categoryFunc":UiCppItemListView.FUNC_USE_WPN_SEC,
         "breadcrumb":UiCppNewItems.CRUMB_PRIMARIES,
         "child":[{
            "allItems":true,
            "label":DictMarket.CATEGORY_ALL
         },{
            "id":GRP_WPN_ASSAULT,
            "label":DictMarket.CATEGORY_ASSAULT_RIFLE,
            "breadcrumb":UiCppNewItems.CRUMB_ASSAULT_RIFLES
         },{
            "id":GRP_WPN_SMG,
            "label":DictMarket.CATEGORY_SMG,
            "breadcrumb":UiCppNewItems.CRUMB_SMGS
         },{
            "id":GRP_WPN_LMG,
            "label":DictMarket.CATEGORY_LMG,
            "breadcrumb":UiCppNewItems.CRUMB_LMGS
         },{
            "id":GRP_WPN_SHOTGUN,
            "label":DictMarket.CATEGORY_SHOTGUN,
            "breadcrumb":UiCppNewItems.CRUMB_SHOTGUNS
         },{
            "id":GRP_WPN_SNIPER,
            "label":DictMarket.CATEGORY_SNIPER,
            "breadcrumb":UiCppNewItems.CRUMB_SNIPERS
         },{
            "id":GRP_WPN_OTHER,
            "label":DictMarket.CATEGORY_OTHER,
            "breadcrumb":UiCppNewItems.CRUMB_OTHER_PRIMARIES
         }]
      };
      
      public static const MARKET_CATEGORY_LABLES_MELEE:Object = {
         "id":SLOT_MELEE,
         "label":DictMarket.ITEM_MENU_MELEE,
         "categoryFunc":UiCppItemListView.FUNC_USE_WPN_SWD,
         "breadcrumb":UiCppNewItems.CRUMB_MELEES,
         "child":[{
            "allItems":true,
            "label":DictMarket.CATEGORY_ALL
         },{
            "id":GRP_WPN_MELEE_SWORD,
            "label":DictMarket.CATEGORY_OTHER,
            "breadcrumb":UiCppNewItems.CRUMB_OTHER_SECONDARIES,
            "onboardLock":UiCppOnboarding.FEATURE_MELEE
         },{
            "id":GRP_WPN_MELEE_KNIFE,
            "label":Dict.CHARACTERLOADOUT_COMBATKNIFE,
            "breadcrumb":UiCppNewItems.CRUMB_COMBAT_KNIFE
         }]
      };
      
      public static const MARKET_CATEGORY_LABLES_SWORD:Object = {
         "id":SLOT_MELEE,
         "label":DictMarket.ITEM_MENU_MELEE,
         "categoryFunc":UiCppItemListView.FUNC_USE_WPN_SWD,
         "breadcrumb":UiCppNewItems.CRUMB_OTHER_SECONDARIES,
         "child":[{
            "id":GRP_WPN_MELEE_SWORD,
            "label":DictMarket.CATEGORY_OTHER,
            "breadcrumb":UiCppNewItems.CRUMB_OTHER_SECONDARIES,
            "onboardLock":UiCppOnboarding.FEATURE_MELEE
         }]
      };
      
      public static const MARKET_CATEGORY_LABLES_KNIFE:Object = {
         "id":SLOT_MELEE,
         "label":DictMarket.ITEM_MENU_MELEE,
         "categoryFunc":UiCppItemListView.FUNC_USE_WPN_KNF,
         "breadcrumb":UiCppNewItems.CRUMB_COMBAT_KNIFE,
         "child":[{
            "id":GRP_WPN_MELEE_KNIFE,
            "label":Dict.CHARACTERLOADOUT_COMBATKNIFE,
            "breadcrumb":UiCppNewItems.CRUMB_COMBAT_KNIFE
         }]
      };
      
      public static const ATTACHMENT_FILTERS:Array = [{
         "allItems":true,
         "label":DictMarket.CATEGORY_ALL
      },{
         "id":GRP_SCOPE,
         "label":DictMarket.CATEGORY_SIGHTS
      },{
         "id":GRP_MUZZLE,
         "label":DictMarket.CATEGORY_MUZZLES
      },{
         "id":GRP_BASE,
         "label":DictMarket.CATEGORY_UNDERBARREL
      },{
         "id":GRP_MAGAZINE,
         "label":DictMarket.CATEGORY_MAGAZINES
      },{
         "id":GRP_STOCK,
         "label":DictMarket.CATEGORY_STOCKS
      },{
         "id":GRP_CLOSE_QUARTERS,
         "label":DictMarket.CATEGORY_CLOSE_QUARTERS
      },{
         "id":GRP_SIDERAIL,
         "label":DictMarket.CATEGORY_ATTACH_TECH
      }];
      
      public static const CATEGORY_PLAYER:Object = {
         "id":MarketMenuData.TYPE_CALLSIGN,
         "label":DictMarket.CATEGORY_PLAYERCARD,
         "aggregate":true,
         "child":[{
            "allItems":true,
            "label":DictMarket.CATEGORY_ALL
         },{
            "id":MarketMenuData.TYPE_CALLSIGN_BKG,
            "label":DictMarket.CATEGORY_CALLSIGN_PCB,
            "breadcrumb":UiCppNewItems.CRUMB_CARD_BKGS,
            "onboardLock":UiCppOnboarding.FEATURE_PLAYERCARD_BKG
         },{
            "id":MarketMenuData.TYPE_CALLSIGN_FRAME,
            "label":DictMarket.CATEGORY_CALLSIGN_PCF,
            "breadcrumb":UiCppNewItems.CRUMB_CARD_FRAMES
         },{
            "id":MarketMenuData.TYPE_CALLSIGN_TITLE,
            "label":DictMarket.CATEGORY_CALLSIGN_TITLE,
            "breadcrumb":UiCppNewItems.CRUMB_CARD_TITLES
         },{
            "id":MarketMenuData.TYPE_CALLSIGN_EMBLEM,
            "label":DictMarket.CATEGORY_CALLSIGN_EMBLEM,
            "breadcrumb":UiCppNewItems.CRUMB_CARD_EMBLEMS
         },{
            "id":MarketMenuData.TYPE_CALLSIGN_NAMEPLATE,
            "label":DictMarket.CATEGORY_CALLSIGN_NAMEPLATE,
            "breadcrumb":UiCppNewItems.CRUMB_CARD_NAMEPLATE
         },{
            "id":MarketMenuData.TYPE_CALLSIGN_CHANGE_NAME,
            "label":DictMarket.CATEGORY_CALLSIGN_CHANGE_NAME_CARD,
            "breadcrumb":UiCppNewItems.CRUMB_NAME_TOKENS
         }]
      };
      
      public static const CATEGORY_REQUISITIONS:Object = {
         "id":"",
         "label":DictMarket.ITEM_MENU_REQUISITIONS,
         "aggregate":true,
         "breadcrumb":UiCppNewItems.CRUMB_REQUISITIONS,
         "child":[{
            "allItems":true,
            "label":DictMarket.CATEGORY_ALL
         },{
            "id":MarketMenuData.TYPE_CALLSIGN_BADGE,
            "label":DictMarket.CATEGORY_CALLSIGN_BADGES,
            "breadcrumb":UiCppNewItems.CRUMB_BADGES
         },{
            "id":MarketMenuData.TYPE_GAMEMODE_TOKEN,
            "label":DictMarket.MARKET_ITEM_CONSUMABLE,
            "breadcrumb":UiCppNewItems.CRUMB_TOKENS
         },{
            "id":MarketMenuData.GRP_EQUIPPABLE_TOKEN,
            "label":DictMarket.MARKET_ITEM_ADVANCED_CONSUMABLE,
            "breadcrumb":UiCppNewItems.CRUMB_ADV_TOKENS
         }]
      };
      
      public static const CATEGORY_KILLSTREAKS:Object = {
         "id":"",
         "label":DictMarket.ITEM_MENU_KILLSTREAK,
         "aggregate":true,
         "breadcrumb":UiCppNewItems.CRUMB_STREAKS,
         "child":[{
            "allItems":true,
            "label":DictMarket.CATEGORY_ALL,
            "breadcrumb":UiCppNewItems.CRUMB_NULL
         },{
            "id":MarketMenuData.GRP_KIS_STANDARD,
            "label":DictMarket.CATEGORY_KIS_STANDARD,
            "breadcrumb":UiCppNewItems.CRUMB_STREAKS_STANDARD
         },{
            "id":MarketMenuData.GRP_KIS_PRO,
            "label":DictMarket.CATEGORY_KIS_PRO,
            "breadcrumb":UiCppNewItems.CRUMB_STREAKS_PRO
         }]
      };
      
      public static const CATEGORY_GEAR:Object = {
         "id":"",
         "label":Dict.LOADOUT_CATEGORY_GEAR,
         "aggregate":true,
         "breadcrumb":UiCppNewItems.CRUMB_GEAR,
         "child":[{
            "allItems":true,
            "label":DictMarket.CATEGORY_ALL,
            "breadcrumb":UiCppNewItems.CRUMB_NULL
         },{
            "id":MarketMenuData.GRP_EMOTE,
            "label":DictMarket.ITEM_MENU_EMO,
            "breadcrumb":UiCppNewItems.CRUMB_EMOTES
         },{
            "id":GRP_HEADGEAR,
            "label":Dict.CHARACTERLOADOUT_HEADWEAR,
            "breadcrumb":UiCppNewItems.CRUMB_HEADGEAR
         },{
            "id":GRP_EYEWEAR,
            "label":Dict.CHARACTERLOADOUT_EYEWEAR,
            "breadcrumb":UiCppNewItems.CRUMB_EYEWEAR
         },{
            "id":GRP_JACKET,
            "label":Dict.CHARACTERLOADOUT_JACKET,
            "breadcrumb":UiCppNewItems.CRUMB_JACKETS
         },{
            "id":GRP_VEST,
            "label":Dict.CHARACTERLOADOUT_VEST,
            "breadcrumb":UiCppNewItems.CRUMB_VESTS
         },{
            "id":GRP_TATTOO,
            "label":Dict.CHARACTERLOADOUT_TATTOO,
            "breadcrumb":UiCppNewItems.CRUMB_TATTOOS
         },{
            "id":GRP_GLOVE,
            "label":Dict.CHARACTERLOADOUT_GLOVES,
            "breadcrumb":UiCppNewItems.CRUMB_GLOVES
         },{
            "id":GRP_PANTS,
            "label":Dict.CHARACTERLOADOUT_PANTS,
            "breadcrumb":UiCppNewItems.CRUMB_PANTS
         },{
            "id":GRP_OUTFIT,
            "label":Dict.CHARACTERLOADOUT_OUTFIT,
            "breadcrumb":UiCppNewItems.CRUMB_NULL
         }]
      };
      
      public static const CATEGORY_LOBBY_GEAR:Object = {
         "id":"",
         "label":Dict.LOADOUT_CATEGORY_GEAR,
         "aggregate":true,
         "child":[{
            "allItems":true,
            "label":DictMarket.CATEGORY_ALL
         },{
            "id":TYPE_CHARACTER,
            "label":"AVATAR"
         },{
            "id":MarketMenuData.GRP_EMOTE,
            "label":DictMarket.ITEM_MENU_EMO
         },{
            "id":GRP_HEADGEAR,
            "label":Dict.CHARACTERLOADOUT_HEADWEAR
         },{
            "id":GRP_EYEWEAR,
            "label":Dict.CHARACTERLOADOUT_EYEWEAR
         },{
            "id":GRP_JACKET,
            "label":Dict.CHARACTERLOADOUT_JACKET
         },{
            "id":GRP_VEST,
            "label":Dict.CHARACTERLOADOUT_VEST
         },{
            "id":GRP_TATTOO,
            "label":Dict.CHARACTERLOADOUT_TATTOO
         },{
            "id":GRP_GLOVE,
            "label":Dict.CHARACTERLOADOUT_GLOVES
         },{
            "id":GRP_PANTS,
            "label":Dict.CHARACTERLOADOUT_PANTS
         },{
            "id":GRP_OUTFIT,
            "label":Dict.CHARACTERLOADOUT_OUTFIT
         },{
            "id":GRP_KNIFE,
            "label":Dict.CHARACTERLOADOUT_COMBATKNIFE
         }]
      };
      
      public static const CATEGORY_STORAGE_GEAR:Object = {
         "id":"",
         "label":Dict.LOADOUT_CATEGORY_GEAR,
         "aggregate":true,
         "child":[{
            "allItems":true,
            "label":DictMarket.CATEGORY_ALL
         },{
            "id":GRP_HEADGEAR,
            "label":Dict.CHARACTERLOADOUT_HEADWEAR
         },{
            "id":GRP_EYEWEAR,
            "label":Dict.CHARACTERLOADOUT_EYEWEAR
         },{
            "id":GRP_JACKET,
            "label":Dict.CHARACTERLOADOUT_JACKET
         },{
            "id":GRP_VEST,
            "label":Dict.CHARACTERLOADOUT_VEST
         },{
            "id":GRP_TATTOO,
            "label":Dict.CHARACTERLOADOUT_TATTOO
         },{
            "id":GRP_GLOVE,
            "label":Dict.CHARACTERLOADOUT_GLOVES
         },{
            "id":GRP_PANTS,
            "label":Dict.CHARACTERLOADOUT_PANTS
         },{
            "id":GRP_OUTFIT,
            "label":Dict.CHARACTERLOADOUT_OUTFIT
         }]
      };
      
      public static const CATEGORIES_CHARACTER:Array = [{
         "id":MarketMenuData.TYPE_CHARACTER,
         "label":DictMarket.ITEM_MENU_CHA,
         "breadcrumb":UiCppNewItems.CRUMB_CHARACTERS
      },CATEGORY_GEAR];
      
      public static const CATEGORY_GAMEMODE:Object = {
         "id":MarketMenuData.TYPE_GAMEMODE,
         "label":DictMarket.ITEM_MENU_GAMEMODE,
         "child":[{
            "allItems":true,
            "label":DictMarket.CATEGORY_ALL
         },{
            "id":MarketMenuData.TYPE_GAMEMODE_ASYM_ROBOTS,
            "label":DictMarket.CATEGORY_ASYM_ROBOTS
         },{
            "id":MarketMenuData.GRP_LOADOUT_SLOT,
            "label":Dict.LOADOUT_CATEGORY_LOADOUTS
         }]
      };
      
      public static const EQUIPPABLES_TAB:int = 0;
      
      public static const CONSUMABLES_TAB:int = 1;
      
      public static const CONSUMABLES_TAB_ADVANCED:int = 2;
      
      public static const CONSUMABLES_TAB_SHARDS:int = 3;
      
      public static const INVENTORY_REQUISITIONS:Array = [{
         "id":0,
         "label":Dict.LOADOUT_CATEGORY_REQUISITIONS,
         "child":[{
            "id":EQUIPPABLES_TAB,
            "label":DictMarket.CATEGORY_CALLSIGN_BADGES,
            "breadcrumb":UiCppNewItems.CRUMB_BADGES
         },{
            "id":CONSUMABLES_TAB,
            "label":DictMarket.MARKET_ITEM_CONSUMABLE,
            "breadcrumb":UiCppNewItems.CRUMB_TOKENS
         },{
            "id":CONSUMABLES_TAB_ADVANCED,
            "label":DictMarket.MARKET_ITEM_ADVANCED_CONSUMABLE,
            "breadcrumb":UiCppNewItems.CRUMB_ADV_TOKENS
         },{
            "id":CONSUMABLES_TAB_SHARDS,
            "label":DictMarket.MARKET_ITEM_SHARD,
            "breadcrumb":UiCppNewItems.CRUMB_SHARDS
         }]
      }];
      
      public static const INVENTORY_REQUISITIONS_OTHER:Array = [{
         "id":0,
         "label":Dict.LOADOUT_CATEGORY_REQUISITIONS,
         "child":[{
            "id":EQUIPPABLES_TAB,
            "label":DictMarket.CATEGORY_CALLSIGN_BADGES,
            "breadcrumb":UiCppNewItems.CRUMB_BADGES
         },{
            "id":CONSUMABLES_TAB_ADVANCED,
            "label":DictMarket.MARKET_ITEM_ADVANCED_CONSUMABLE,
            "breadcrumb":UiCppNewItems.CRUMB_ADV_TOKENS
         }]
      }];
      
      public static const INVENTORY_KILLSTREAKS:Array = [CATEGORY_KILLSTREAKS];
      
      public static const CURRENCY_ID_INFO_MAP:Array = [{
         "id":1,
         "name":Dict.GP,
         "desc":"",
         "image":"scaleform_ash/miscicons/gold_coin_s"
      },{
         "id":8,
         "name":DictMarket.HP,
         "desc":DictMarket.HP_TIP,
         "image":"scaleform_ash/miscicons/hp_icon"
      },{
         "id":9,
         "name":DictMarket.EHP,
         "desc":DictMarket.EHP_TIP,
         "image":"scaleform_ash/miscicons/ehp_icon"
      },{
         "id":10,
         "name":DictBattleCity.BATTLECITY_FREE_TICKET_NAME,
         "desc":DictBattleCity.BATTLECITY_FREE_TICKET_DESCRIPTION,
         "image":"scaleform_ash/miscicons/bcl_free_ticket"
      },{
         "id":11,
         "name":DictBattleCity.BATTLECITY_BATTLE_TICKET_NAME,
         "desc":DictBattleCity.BATTLECITY_BATTLE_TICKET_DESCRIPTION,
         "image":"scaleform_ash/miscicons/bcl_battle_ticket"
      }];
      
      public static const CURRENCY_ID_DESCRIPTION_MAP:Array = [{
         "id":8,
         "desc":DictMarket.HP_TIP
      },{
         "id":9,
         "desc":DictMarket.EHP_TIP
      },{
         "id":10,
         "desc":DictBattleCity.BATTLECITY_FREE_TICKET_DESCRIPTION
      },{
         "id":11,
         "desc":DictBattleCity.BATTLECITY_BATTLE_TICKET_DESCRIPTION
      }];
      
      public function MarketMenuData()
      {
         super();
      }
      
      public static function getCurrencyObjById(id:int) : Object
      {
         for(var i:int = 0; i < CURRENCY_ID_INFO_MAP.length; i++)
         {
            if(CURRENCY_ID_INFO_MAP[i].id == id)
            {
               return CURRENCY_ID_INFO_MAP[i];
            }
         }
         return null;
      }
      
      public static function getCurrencyNameById(id:int) : String
      {
         var currencyObj:Object = getCurrencyObjById(id);
         if(Boolean(currencyObj))
         {
            return currencyObj.name;
         }
         return "";
      }
      
      public static function getCurrencyDescriptionById(id:int) : String
      {
         var currencyObj:Object = getCurrencyObjById(id);
         if(Boolean(currencyObj))
         {
            return currencyObj.desc;
         }
         return "";
      }
      
      public static function getCurrencyImageById(id:int) : String
      {
         var currencyObj:Object = getCurrencyObjById(id);
         if(Boolean(currencyObj))
         {
            return currencyObj.image;
         }
         return "";
      }
   }
}

