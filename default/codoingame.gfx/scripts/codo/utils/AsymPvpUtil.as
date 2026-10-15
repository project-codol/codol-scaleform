package codo.utils
{
   import codo.common.CFunctionCommonContainer;
   import codo.constants.ChangeClassType;
   import codo.constants.Common;
   import codo.constants.DataID;
   import codo.constants.QuickMatchType;
   import codo.manager.DataManager;
   import codo.objects.AsymPvpHumanWeaponUpgrade;
   import codo.objects.AsymPvpLoadoutObj;
   
   public class AsymPvpUtil
   {
      
      private static var _instance:AsymPvpUtil;
      
      private static var DEFAULT_LOADOUT_INDEX:uint = 0;
      
      public static const NUM_CLASSES:int = 3;
      
      private static const CLASS_HOVER:int = 0;
      
      private static const CLASS_SPIDER:int = 1;
      
      private static const CLASS_HULK:int = 2;
      
      private static const LOADOUT_TABLE:String = "mp/asymLoadouts.csv";
      
      private static const COL_ID:int = 0;
      
      private static const COL_NAME:int = 1;
      
      private static const COL_DESC:int = 2;
      
      private static const COL_IMAGE:int = 3;
      
      private static const COL_CLASS:int = 4;
      
      private static const COL_ITEM_ID:int = 19;
      
      private static const COL_MODEL_REF:int = 24;
      
      private static const COL_MELEE_POWER_DESC:int = 5;
      
      private static const COL_FIRST_POWER_DESC:int = 8;
      
      private static const COL_SECOND_POWER_DESC:int = 11;
      
      private static const COL_THIRD_POWER_DESC:int = 14;
      
      private static const COL_FIRST_POWER:int = 6;
      
      private static const COL_SECOND_POWER:int = 9;
      
      private static const COL_THIRD_POWER:int = 12;
      
      private static const ABILITY_TABLE:String = "mp/asymPowers.csv";
      
      private static const ABILITY_COL_ID:int = 0;
      
      private static const ABILITY_COL_NAME:int = 1;
      
      private static const WEAPON_UPGRADE_TABLE:String = "mp/asymWeaponUpgrades.csv";
      
      private static const WEAPON_COL_IMAGE:int = 1;
      
      private static const WEAPON_COL_NAME:int = 2;
      
      private static const WEAPON_COL_DESC:int = 3;
      
      public static const ABILITY_COL_ICON:int = 2;
      
      public static const ABILITY_COL_CHARGES:int = 5;
      
      public static const WEAPON_LEVELICON_TABLE:String = "mp/asymWeaponLevelIcon.csv";
      
      private static const LEVEL_ICON_IMAGE:int = 1;
      
      private var _isAsymMonster:Boolean;
      
      private var _loadoutCategories:Array;
      
      private var _loadoutsBySpeciesName:Array;
      
      private var _loadoutsByClass:Vector.<Array>;
      
      private var _selectedLoadoutByClass:Vector.<int>;
      
      private var _cachedClassIdx:int = -1;
      
      private var _weaponUpgrade:Vector.<AsymPvpHumanWeaponUpgrade>;
      
      private var _weaponUpgradeLevelIcon:Vector.<String>;
      
      public function AsymPvpUtil()
      {
         super();
         this._isAsymMonster = false;
         this.initAsymLoadouts();
         this.initAsymLoadoutsHuman();
      }
      
      public static function get instance() : AsymPvpUtil
      {
         if(_instance == null)
         {
            _instance = new AsymPvpUtil();
         }
         return _instance;
      }
      
      private function initAsymLoadouts() : void
      {
         var i:int = 0;
         var ability:String = null;
         var curLoadout:AsymPvpLoadoutObj = null;
         var modelRef:String = null;
         var tableCateg:String = null;
         var categ:int = 0;
         this._loadoutCategories = [{"name":"@ASYMCOMMON_LOADOUT_HOVER_DEFAULT_NAME"},{"name":"@ASYMCOMMON_LOADOUT_SPIDER_DEFAULT_NAME"},{"name":"@ASYMCOMMON_LOADOUT_HULK_DEFAULT_NAME"}];
         this._loadoutsByClass = new Vector.<Array>(NUM_CLASSES);
         this._loadoutsByClass[CLASS_HOVER] = [];
         this._loadoutsByClass[CLASS_SPIDER] = [];
         this._loadoutsByClass[CLASS_HULK] = [];
         this._selectedLoadoutByClass = new Vector.<int>(NUM_CLASSES);
         for(i = 0; i < this._loadoutsByClass.length; i++)
         {
            this._selectedLoadoutByClass[i] = 0;
         }
         this._loadoutsBySpeciesName = new Array();
         var tableClassMap:Object = {};
         tableClassMap["0"] = CLASS_HOVER;
         tableClassMap["1"] = CLASS_HULK;
         tableClassMap["2"] = CLASS_SPIDER;
         var tableRows:int = CFunctionCommonContainer.StringTableRowCount(LOADOUT_TABLE);
         var ABILITY_DEFAULT_MELEE:String = "melee";
         var dataReady:Boolean = CFunctionCommonContainer.IsMarketplaceReady() == true;
         if(dataReady == false)
         {
            DataManager.getInstance().bind(DataID.DATA_RECEIVE,this.bind_dataReceived);
         }
         for(i = 0; i < tableRows; i++)
         {
            curLoadout = new AsymPvpLoadoutObj();
            curLoadout.id = CFunctionCommonContainer.StringTableLookupByRow(LOADOUT_TABLE,i,COL_ID);
            curLoadout.name = "@" + CFunctionCommonContainer.StringTableLookupByRow(LOADOUT_TABLE,i,COL_NAME);
            curLoadout.desc = "@" + CFunctionCommonContainer.StringTableLookupByRow(LOADOUT_TABLE,i,COL_DESC);
            curLoadout.image = CFunctionCommonContainer.StringTableLookupByRow(LOADOUT_TABLE,i,COL_IMAGE);
            curLoadout.itemID = parseInt(CFunctionCommonContainer.StringTableLookupByRow(LOADOUT_TABLE,i,COL_ITEM_ID));
            modelRef = CFunctionCommonContainer.StringTableLookupByRow(LOADOUT_TABLE,i,COL_MODEL_REF);
            curLoadout.isDefault = modelRef.lastIndexOf("00") > -1;
            curLoadout.isPurchased = CFunctionCommonContainer.IsMarketplaceItemOwned(curLoadout.itemID) as Boolean;
            curLoadout.isExpired = CFunctionCommonContainer.AS_IsExpiredInventoryItem(curLoadout.itemID) as Boolean;
            curLoadout.isPurchaseable = dataReady ? CFunctionCommonContainer.IsMarketplaceItemPurchasable(curLoadout.itemID) as Boolean : false;
            tableCateg = CFunctionCommonContainer.StringTableLookupByRow(LOADOUT_TABLE,i,COL_CLASS);
            categ = int(tableClassMap[tableCateg]);
            curLoadout.categoryType = categ;
            curLoadout.category = this._loadoutCategories[categ].name;
            curLoadout.meleeAbilityName = "@" + CFunctionCommonContainer.StringTableLookup(ABILITY_TABLE,ABILITY_COL_ID,ABILITY_DEFAULT_MELEE,ABILITY_COL_NAME);
            curLoadout.meleeAbilityIcon = CFunctionCommonContainer.StringTableLookup(ABILITY_TABLE,ABILITY_COL_ID,ABILITY_DEFAULT_MELEE,ABILITY_COL_ICON);
            curLoadout.meleeAbilityDesc = "@" + CFunctionCommonContainer.StringTableLookupByRow(LOADOUT_TABLE,i,COL_MELEE_POWER_DESC);
            ability = CFunctionCommonContainer.StringTableLookupByRow(LOADOUT_TABLE,i,COL_FIRST_POWER);
            curLoadout.firstAbilityName = "@" + CFunctionCommonContainer.StringTableLookup(ABILITY_TABLE,ABILITY_COL_ID,ability,ABILITY_COL_NAME);
            curLoadout.firstAbilityIcon = CFunctionCommonContainer.StringTableLookup(ABILITY_TABLE,ABILITY_COL_ID,ability,ABILITY_COL_ICON);
            curLoadout.firstAbilityDesc = "@" + CFunctionCommonContainer.StringTableLookupByRow(LOADOUT_TABLE,i,COL_FIRST_POWER_DESC);
            ability = CFunctionCommonContainer.StringTableLookupByRow(LOADOUT_TABLE,i,COL_SECOND_POWER);
            curLoadout.secondAbilityName = "@" + CFunctionCommonContainer.StringTableLookup(ABILITY_TABLE,ABILITY_COL_ID,ability,ABILITY_COL_NAME);
            curLoadout.secondAbilityIcon = CFunctionCommonContainer.StringTableLookup(ABILITY_TABLE,ABILITY_COL_ID,ability,ABILITY_COL_ICON);
            curLoadout.secondAbilityDesc = "@" + CFunctionCommonContainer.StringTableLookupByRow(LOADOUT_TABLE,i,COL_SECOND_POWER_DESC);
            ability = CFunctionCommonContainer.StringTableLookupByRow(LOADOUT_TABLE,i,COL_THIRD_POWER);
            curLoadout.thirdAbilityName = "@" + CFunctionCommonContainer.StringTableLookup(ABILITY_TABLE,ABILITY_COL_ID,ability,ABILITY_COL_NAME);
            curLoadout.thirdAbilityIcon = CFunctionCommonContainer.StringTableLookup(ABILITY_TABLE,ABILITY_COL_ID,ability,ABILITY_COL_ICON);
            curLoadout.thirdAbilityDesc = "@" + CFunctionCommonContainer.StringTableLookupByRow(LOADOUT_TABLE,i,COL_THIRD_POWER_DESC);
            if(this.isValidForShip(curLoadout))
            {
               this._loadoutsByClass[categ].push(curLoadout);
               this._loadoutsBySpeciesName[curLoadout.id] = curLoadout;
            }
         }
      }
      
      public function initAsymLoadoutsHuman() : void
      {
         var tableRows:int = 0;
         var i:int = 0;
         var weaponupgrade:AsymPvpHumanWeaponUpgrade = null;
         var levelIcon:String = null;
         if(this._weaponUpgradeLevelIcon != null)
         {
            return;
         }
         this._weaponUpgrade = new Vector.<AsymPvpHumanWeaponUpgrade>();
         tableRows = CFunctionCommonContainer.StringTableRowCount(WEAPON_UPGRADE_TABLE);
         for(i = 0; i < tableRows; i++)
         {
            weaponupgrade = new AsymPvpHumanWeaponUpgrade();
            weaponupgrade.image = CFunctionCommonContainer.StringTableLookupByRow(WEAPON_UPGRADE_TABLE,i,WEAPON_COL_IMAGE);
            weaponupgrade.name = "@" + CFunctionCommonContainer.StringTableLookupByRow(WEAPON_UPGRADE_TABLE,i,WEAPON_COL_NAME);
            weaponupgrade.desc = "@" + CFunctionCommonContainer.StringTableLookupByRow(WEAPON_UPGRADE_TABLE,i,WEAPON_COL_DESC);
            this._weaponUpgrade.push(weaponupgrade);
         }
         this._weaponUpgradeLevelIcon = new Vector.<String>();
         tableRows = CFunctionCommonContainer.StringTableRowCount(WEAPON_LEVELICON_TABLE);
         for(i = 0; i < tableRows; i++)
         {
            levelIcon = "";
            levelIcon = CFunctionCommonContainer.StringTableLookupByRow(WEAPON_LEVELICON_TABLE,i,LEVEL_ICON_IMAGE);
            this._weaponUpgradeLevelIcon.push(levelIcon);
         }
      }
      
      public function setLoadoutsAvailable(isAvailable:Boolean) : void
      {
         var loadouts:Array = null;
         var loadout:AsymPvpLoadoutObj = null;
         for(var i:uint = 0; i < NUM_CLASSES; )
         {
            loadouts = this._loadoutsByClass[i];
            for each(loadout in loadouts)
            {
               if(!loadout.isDefault)
               {
                  loadout.loadoutTempDisabled = !isAvailable;
               }
            }
            i++;
         }
      }
      
      private function isValidForShip(loadoutToCheck:AsymPvpLoadoutObj) : Boolean
      {
         return loadoutToCheck.isDefault || loadoutToCheck.isPurchaseable || loadoutToCheck.isPurchased && !loadoutToCheck.isExpired;
      }
      
      public function preOpenPauseMenu(changeClassType:int) : void
      {
         var monsterTeam:int = 0;
         if(Boolean(CFunctionCommonContainer.Dvar_GetBool("ui_asym_robot_axis")))
         {
            monsterTeam = ChangeClassType.TEAM_AXIS;
         }
         else
         {
            monsterTeam = ChangeClassType.TEAM_ALLIES;
         }
         if(Boolean(CFunctionCommonContainer.Dvar_GetBool("ui_asym_force_robot_loadout_menu")))
         {
            this._isAsymMonster = true;
         }
         else
         {
            this._isAsymMonster = changeClassType == monsterTeam;
         }
      }
      
      public function get isAsymMonster() : Boolean
      {
         return this._isAsymMonster;
      }
      
      public function get loadoutCategories() : Array
      {
         return this._loadoutCategories;
      }
      
      public function getClassLoadouts(classIdx:int) : Array
      {
         return this._loadoutsByClass[classIdx];
      }
      
      public function getWeaponUpgradeModImage(weaponType:int) : String
      {
         return this._weaponUpgrade[weaponType].image;
      }
      
      public function getWeaponUpgradeModName(weaponType:int) : String
      {
         return this._weaponUpgrade[weaponType].name;
      }
      
      public function getWeaponUpgradeModDesc(weaponType:int) : String
      {
         return this._weaponUpgrade[weaponType].desc;
      }
      
      public function getWeaponUpgradeLevelIcon(_level:int) : String
      {
         var index:int = _level - 1;
         if(index > 2 || index < 0)
         {
            index = 0;
         }
         return this._weaponUpgradeLevelIcon[index];
      }
      
      public function getSelectedLoadout(classIdx:int) : int
      {
         return this._selectedLoadoutByClass[classIdx];
      }
      
      public function getLoadoutBySpeciesName(speciesName:String) : AsymPvpLoadoutObj
      {
         return this._loadoutsBySpeciesName[speciesName];
      }
      
      public function setSelectedLoadout(classIdx:int, loadout:int) : void
      {
         this._selectedLoadoutByClass[classIdx] = loadout;
      }
      
      public function getSelectedLoadoutObj(classIdx:int) : AsymPvpLoadoutObj
      {
         var loadouts:Array = this.getClassLoadouts(classIdx);
         var loadoutIdx:int = this.getSelectedLoadout(classIdx);
         return loadouts[loadoutIdx];
      }
      
      public function setCachedClassIdx(idx:int) : void
      {
         this._cachedClassIdx = idx;
      }
      
      public function getCachedClassIdx() : int
      {
         return this._cachedClassIdx;
      }
      
      public function isAsymGameMode(modeToCheck:String) : Boolean
      {
         return modeToCheck == QuickMatchType.ID_ASYMETRICAL || modeToCheck == QuickMatchType.ID_INFECTED || modeToCheck == QuickMatchType.ID_BORG;
      }
      
      public function isInfectedGameMode(modeToCheck:String) : Boolean
      {
         return modeToCheck == QuickMatchType.ID_INFECTED || modeToCheck == QuickMatchType.ID_BORG;
      }
      
      private function bind_dataReceived(cRes:Object) : void
      {
         if(cRes.result == 1 && cRes.data == Common.MARKET_RECEIVED)
         {
            DataManager.getInstance().unbind(DataID.DATA_RECEIVE,this.bind_dataReceived);
            this.initAsymLoadouts();
         }
      }
   }
}

