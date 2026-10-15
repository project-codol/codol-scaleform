package codo.utils
{
   import codo.common.CFunctionCommonContainer;
   import codo.objects.ClashLoadoutObj;
   import codo.objects.ProductObj;
   
   public class ClashPvpUtil
   {
      
      public static const MODE_ID:String = "clash";
      
      private static var _instance:ClashPvpUtil = null;
      
      public static const CLASH_MODE_ELIMINATION:uint = 0;
      
      public static const CLASH_MODE_FFA:uint = 1;
      
      public static const CLASH_MODE_TDM:uint = 2;
      
      public static const CLASH_MODE_CTF:uint = 3;
      
      public static const CLASH_MODE_HARDCORE:uint = 4;
      
      public static const CLASH_FOV_FIRSTPERSION:uint = 0;
      
      public static const CLASH_FOV_THIRDPERSION:uint = 0;
      
      public static const CLASH_FOV_FREE:uint = 2;
      
      private var _loadoutCategories:Array;
      
      private const LOADOUT_TABLE:String = "mp/clashWeaponList.csv";
      
      private const PERK_TABLE:String = "mp/coPerkStatsTable.csv";
      
      private const COL_INDEX:int = 0;
      
      private const COL_ID:int = 1;
      
      private const COL_IMAGE:int = 2;
      
      private const COL_NAME:int = 3;
      
      private const COL_ISDEFAULT:int = 4;
      
      private const COL_PERK1:int = 5;
      
      private const COL_PERK2:int = 6;
      
      private const COL_PERK3:int = 7;
      
      private const COL_CATEGORY:int = 8;
      
      private const COL_ATTACKSPEED:int = 9;
      
      private const COL_MOVESPEED:int = 10;
      
      private const COL_PERKTABLE_NAME:int = 1;
      
      private const COL_PERKTABLE_IMG:int = 3;
      
      private const NUM_CLASSES:int = 3;
      
      private const CAT_SHORT:int = 0;
      
      private const CAT_MEDIUM:int = 1;
      
      private const CAT_LONG:int = 2;
      
      private var _loadoutsByClass:Vector.<Array>;
      
      private var _selectedLoadoutByClass:Vector.<int>;
      
      public function ClashPvpUtil()
      {
         super();
         this.init();
      }
      
      public static function Instantiate() : void
      {
         if(_instance == null)
         {
            _instance = new ClashPvpUtil();
         }
      }
      
      public static function get instance() : ClashPvpUtil
      {
         return _instance;
      }
      
      public static function isClashHardcore() : Boolean
      {
         return CFunctionCommonContainer.AS_GetClashSubMode() == CLASH_MODE_HARDCORE;
      }
      
      public static function isClashTDM() : Boolean
      {
         return CFunctionCommonContainer.AS_GetClashSubMode() == CLASH_MODE_TDM;
      }
      
      public static function isClashCTF() : Boolean
      {
         return CFunctionCommonContainer.AS_GetClashSubMode() == CLASH_MODE_CTF;
      }
      
      public static function getClashDetailedMode(clashMode:uint) : String
      {
         if(clashMode == CLASH_MODE_CTF)
         {
            return MODE_ID + "_ctf";
         }
         return MODE_ID;
      }
      
      public static function getClashDetailModeString() : String
      {
         if(isClashTDM())
         {
            return MODE_ID + "_tdm";
         }
         if(isClashCTF())
         {
            return MODE_ID + "_ctf";
         }
         if(isClashHardcore())
         {
            return MODE_ID + "_hardcore";
         }
         return MODE_ID;
      }
      
      private function init() : void
      {
         var i:int = 0;
         var meleeObj:ClashLoadoutObj = null;
         var tstr:String = null;
         var itemID:int = 0;
         var prodData:ProductObj = null;
         var categString:String = null;
         var categInt:int = 0;
         var tableClassMap:Object = {};
         tableClassMap["0"] = this.CAT_SHORT;
         tableClassMap["1"] = this.CAT_MEDIUM;
         tableClassMap["2"] = this.CAT_LONG;
         this._loadoutCategories = [{"name":"@CLASH_CATEGORY_SHORT"},{"name":"@CLASH_CATEGORY_MEDIUM"},{"name":"@CLASH_CATEGORY_LONG"}];
         this._loadoutsByClass = new Vector.<Array>(this.NUM_CLASSES);
         this._loadoutsByClass[this.CAT_SHORT] = [];
         this._loadoutsByClass[this.CAT_MEDIUM] = [];
         this._loadoutsByClass[this.CAT_LONG] = [];
         this._selectedLoadoutByClass = new Vector.<int>(this.NUM_CLASSES);
         for(i = 0; i < this.NUM_CLASSES; i++)
         {
            this._selectedLoadoutByClass[i] = 0;
         }
         var tableRows:int = CFunctionCommonContainer.StringTableRowCount(this.LOADOUT_TABLE);
         for(i = 0; i < tableRows; i++)
         {
            meleeObj = new ClashLoadoutObj();
            tstr = CFunctionCommonContainer.StringTableLookupByRow(this.LOADOUT_TABLE,i,this.COL_NAME);
            meleeObj.index = int(CFunctionCommonContainer.StringTableLookupByRow(this.LOADOUT_TABLE,i,this.COL_INDEX));
            meleeObj.nameid = CFunctionCommonContainer.StringTableLookupByRow(this.LOADOUT_TABLE,i,this.COL_ID);
            meleeObj.image = "scaleform_ash/weapicons/" + CFunctionCommonContainer.StringTableLookupByRow(this.LOADOUT_TABLE,i,this.COL_IMAGE);
            meleeObj.name = "@" + tstr.toUpperCase();
            meleeObj.isDefault = Boolean(CFunctionCommonContainer.StringTableLookupByRow(this.LOADOUT_TABLE,i,this.COL_ISDEFAULT) == "1");
            meleeObj.perk1 = CFunctionCommonContainer.StringTableLookupByRow(this.LOADOUT_TABLE,i,this.COL_PERK1);
            meleeObj.perk2 = CFunctionCommonContainer.StringTableLookupByRow(this.LOADOUT_TABLE,i,this.COL_PERK2);
            meleeObj.perk3 = CFunctionCommonContainer.StringTableLookupByRow(this.LOADOUT_TABLE,i,this.COL_PERK3);
            meleeObj.descattackspeed = "@" + CFunctionCommonContainer.StringTableLookupByRow(this.LOADOUT_TABLE,i,this.COL_ATTACKSPEED);
            meleeObj.descmovespeed = "@" + CFunctionCommonContainer.StringTableLookupByRow(this.LOADOUT_TABLE,i,this.COL_MOVESPEED);
            meleeObj.locked = !meleeObj.isDefault && Boolean(CFunctionCommonContainer.AS_IsExpiredInventoryItem(CFunctionCommonContainer.GetItemIDByName(meleeObj.nameid)));
            itemID = CFunctionCommonContainer.GetItemIDByName(meleeObj.nameid);
            prodData = CFunctionCommonContainer.GetItemInfo(itemID);
            meleeObj.tier = prodData.tier;
            meleeObj.group = prodData.group;
            meleeObj.description = prodData.description;
            if(itemID == 0)
            {
               meleeObj.description = "@CLASH_" + meleeObj.nameid.toUpperCase() + "_NONEMKT_ITEM_DESC";
            }
            categString = CFunctionCommonContainer.StringTableLookupByRow(this.LOADOUT_TABLE,i,this.COL_CATEGORY);
            categInt = int(tableClassMap[categString]);
            this._loadoutsByClass[categInt].push(meleeObj);
         }
         this._loadoutsByClass[this.CAT_SHORT].sortOn(["isDefault","tier"],[Array.DESCENDING,Array.NUMERIC]);
         this._loadoutsByClass[this.CAT_MEDIUM].sortOn(["isDefault","tier"],[Array.DESCENDING,Array.NUMERIC]);
         this._loadoutsByClass[this.CAT_LONG].sortOn(["isDefault","tier"],[Array.DESCENDING,Array.NUMERIC]);
      }
      
      private function IsItemInLoadout(itemId:int, itemArray:Array) : Boolean
      {
         for(var i:int = 0; i < itemArray.length; i++)
         {
            if(itemArray[i].secondary.id == itemId)
            {
               return true;
            }
         }
         return false;
      }
      
      public function getLoadoutCategories() : Array
      {
         return this._loadoutCategories;
      }
      
      public function getPerkImage(name:String) : String
      {
         var row:int = CFunctionCommonContainer.StringTableLookupRowNumForValue(this.PERK_TABLE,this.COL_PERKTABLE_NAME,name);
         if(row == -1)
         {
            return "";
         }
         return CFunctionCommonContainer.StringTableLookupByRow(this.PERK_TABLE,row,this.COL_PERKTABLE_IMG);
      }
      
      public function getSelectedLoadoutByClass(classIdx:int) : int
      {
         return this._selectedLoadoutByClass[classIdx];
      }
      
      public function getLoadoutsArrayByClass(classIdx:int) : Array
      {
         return this._loadoutsByClass[classIdx];
      }
      
      public function getSelectedLoadoutObj(classIdx:int) : ClashLoadoutObj
      {
         var i:int = 0;
         var j:int = 0;
         var loadouts:Array = this.getLoadoutsArrayByClass(classIdx);
         var loadoutIdx:int = this.getSelectedLoadoutByClass(classIdx);
         if(Boolean(loadouts[loadoutIdx].isLocked))
         {
            loop0:
            for(i = 0; i < this.NUM_CLASSES; )
            {
               j = 0;
               while(true)
               {
                  if(j >= this._loadoutsByClass[i].length)
                  {
                     i++;
                     continue loop0;
                  }
                  if(!this._loadoutsByClass[i][j].isLocked)
                  {
                     break;
                  }
                  j++;
               }
               return this._loadoutsByClass[i][j];
            }
            Logger.print("Error: no available default weapon found!");
            return this._loadoutsByClass[0][0];
         }
         return loadouts[loadoutIdx];
      }
      
      public function setSelectedLoadout(classIdx:int, loadout:int) : void
      {
         this._selectedLoadoutByClass[classIdx] = loadout;
      }
   }
}

