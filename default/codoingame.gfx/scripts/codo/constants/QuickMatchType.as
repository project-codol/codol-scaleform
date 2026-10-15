package codo.constants
{
   import codo.common.CFunctionCommonContainer;
   import codo.localization.Dict;
   
   public class QuickMatchType
   {
      
      public static const ID_SURVIVAL:String = "survival";
      
      public static const ID_KILL_CONFIRMED:String = "conf";
      
      public static const ID_LOOT_DROP:String = "tag";
      
      public static const ID_FUTURE_CYBORGS:String = "zm";
      
      public static const ID_ZARENA:String = "zarena";
      
      public static const ID_ZOMBIESURVIVAL:String = "zsurv";
      
      public static const ID_ZCHAMP:String = "zchamp";
      
      public static const ID_COOP_HERO_OPS_SURVIVAL:String = "coop";
      
      public static const ID_ASYMETRICAL:String = "asym";
      
      public static const ID_INFECTED:String = "infect";
      
      public static const ID_BORG:String = "borg";
      
      public static const ID_MODE_SEARCH_AND_RESCUE:String = "sr";
      
      public static const ID_MODE_SEARCH_AND_DESTROY:String = "sd";
      
      public static const ID_MODE_DEMOLITION:String = "dd";
      
      private static const DVAR_NAME:String = "ui_match_select_id";
      
      private static const DVAR_DIV:String = "@";
      
      private var _mapType:uint;
      
      private var _coopMapType:uint;
      
      private var _isWarGod:Boolean;
      
      private var _isRoom:Boolean;
      
      private var _isBattleCity:Boolean;
      
      private var _isTheatre:Boolean;
      
      public function QuickMatchType(_mapType:uint = 0, _coopMapType:uint = 0, _isWarGod:Boolean = false, _isRoom:Boolean = false, _isBattleCity:Boolean = false, _isTheatre:Boolean = false)
      {
         super();
         this._mapType = _mapType;
         this._coopMapType = _coopMapType;
         this._isWarGod = _isWarGod;
         this._isRoom = _isRoom;
         this._isBattleCity = _isBattleCity;
         this._isTheatre = _isTheatre;
      }
      
      public static function fromPlaylistType(type:uint) : QuickMatchType
      {
         switch(type)
         {
            case PlayListType.RANKED:
            case PlayListType.COMBAT:
               return makePvp();
            case PlayListType.SURVIVAL:
               return makeSurvival();
            case PlayListType.CYBORG:
               return makeCyborg();
            case PlayListType.ZARENA:
               return makeZArena();
            case PlayListType.ZOMBIESURVIVAL:
               return makeZombieSurvival();
            case PlayListType.ZCHAMP:
               return makeZombieChampions();
            case PlayListType.ZHUNTER:
               return makeZombieHunter();
            case PlayListType.TD:
               return makeTD();
            default:
               return new QuickMatchType();
         }
      }
      
      public static function makeDefault() : QuickMatchType
      {
         return new QuickMatchType();
      }
      
      public static function makePvp() : QuickMatchType
      {
         return new QuickMatchType(MapType.MP);
      }
      
      public static function makeHeroOps() : QuickMatchType
      {
         return new QuickMatchType(MapType.COOP,CoopMapType.STORY);
      }
      
      public static function makeSurvival() : QuickMatchType
      {
         return new QuickMatchType(MapType.COOP,CoopMapType.SURVIVAL);
      }
      
      public static function makeCyborg() : QuickMatchType
      {
         return new QuickMatchType(MapType.COOP,CoopMapType.ZOMBIE);
      }
      
      public static function makeZArena() : QuickMatchType
      {
         return new QuickMatchType(MapType.COOP,CoopMapType.ZARENA);
      }
      
      public static function makeZombieSurvival() : QuickMatchType
      {
         return new QuickMatchType(MapType.COOP,CoopMapType.ZOMBIESURVIVAL);
      }
      
      public static function makeZombieChampions() : QuickMatchType
      {
         return new QuickMatchType(MapType.COOP,CoopMapType.ZCHAMP);
      }
      
      public static function makeZombieHunter() : QuickMatchType
      {
         return new QuickMatchType(MapType.COOP,CoopMapType.ZHUNTER);
      }
      
      public static function makeTD() : QuickMatchType
      {
         return new QuickMatchType(MapType.COOP,CoopMapType.TD);
      }
      
      public static function makeWarGod() : QuickMatchType
      {
         return new QuickMatchType(MapType.MP,CoopMapType.NONE,true);
      }
      
      public static function makeBattleCity() : QuickMatchType
      {
         return new QuickMatchType(MapType.MP,CoopMapType.NONE,false,false,true);
      }
      
      public static function makeRoom() : QuickMatchType
      {
         return new QuickMatchType(MapType.MP,CoopMapType.NONE,false,true);
      }
      
      public static function makeTheatre() : QuickMatchType
      {
         return new QuickMatchType(MapType.NONE,CoopMapType.NONE,false,false,false,true);
      }
      
      public static function loadFromPersistent() : QuickMatchType
      {
         var fields:Array = null;
         var loaded:QuickMatchType = new QuickMatchType();
         var dvar:String = CFunctionCommonContainer.Dvar_GetString(DVAR_NAME);
         if(dvar != null && dvar.length > 0)
         {
            fields = dvar.split(DVAR_DIV);
            if(fields.length == 6)
            {
               loaded._mapType = int(fields[0]);
               loaded._coopMapType = int(fields[1]);
               loaded._isWarGod = Boolean(int(fields[2]));
               loaded._isRoom = Boolean(int(fields[3]));
               loaded._isBattleCity = Boolean(int(fields[4]));
               loaded._isTheatre = Boolean(int(fields[5]));
            }
         }
         return loaded;
      }
      
      public static function saveToPersistent(type:QuickMatchType) : void
      {
         var str:String = String(type._mapType) + DVAR_DIV + String(type._coopMapType) + DVAR_DIV;
         str += (type._isWarGod ? "1" : "0") + DVAR_DIV;
         str += (type._isRoom ? "1" : "0") + DVAR_DIV;
         str += type._isBattleCity ? "1" : "0" + DVAR_DIV;
         str += type._isTheatre ? "1" : "0";
         CFunctionCommonContainer.setdvar(DVAR_NAME,str);
      }
      
      public static function clearPersistent() : void
      {
         CFunctionCommonContainer.setdvar(DVAR_NAME,"");
      }
      
      public function equals(other:QuickMatchType) : Boolean
      {
         return this.modeEquals(other) && this._isWarGod == other._isWarGod && this._isRoom == other._isRoom && this._isBattleCity == other._isBattleCity && this._isTheatre == other._isTheatre;
      }
      
      public function modeEquals(other:QuickMatchType) : Boolean
      {
         return this._mapType == other._mapType && this._coopMapType == other._coopMapType;
      }
      
      public function isPvp() : Boolean
      {
         return this._mapType == MapType.MP && this._coopMapType == CoopMapType.NONE;
      }
      
      public function isMpMap() : Boolean
      {
         return this._mapType == MapType.MP;
      }
      
      public function isPve() : Boolean
      {
         return this._mapType == MapType.COOP && this._coopMapType != CoopMapType.STORY;
      }
      
      public function isCoopMap() : Boolean
      {
         return this._mapType == MapType.COOP;
      }
      
      public function isCyborgs() : Boolean
      {
         return this._coopMapType == CoopMapType.ZOMBIE;
      }
      
      public function isZArena() : Boolean
      {
         return this._coopMapType == CoopMapType.ZARENA;
      }
      
      public function isZombieSurvival() : Boolean
      {
         return this._coopMapType == CoopMapType.ZOMBIESURVIVAL;
      }
      
      public function isZombieChampions() : Boolean
      {
         return this._coopMapType == CoopMapType.ZCHAMP;
      }
      
      public function isHeroOps() : Boolean
      {
         return this._coopMapType == CoopMapType.STORY;
      }
      
      public function isSurvival() : Boolean
      {
         return this._coopMapType == CoopMapType.SURVIVAL;
      }
      
      public function get mapType() : uint
      {
         return this._mapType;
      }
      
      public function get coopMapType() : uint
      {
         return this._coopMapType;
      }
      
      public function get isWarGod() : Boolean
      {
         return this._isWarGod;
      }
      
      public function get isRoom() : Boolean
      {
         return this._isRoom;
      }
      
      public function get isBattleCity() : Boolean
      {
         return this._isBattleCity;
      }
      
      public function get isTheatre() : Boolean
      {
         return this._isTheatre;
      }
      
      public function modeLabel() : String
      {
         if(this._mapType == MapType.MP)
         {
            if(this._coopMapType == CoopMapType.TRAIN)
            {
               return Dict.MAIN_MENU_LABEL_QUICKMATCH_CT;
            }
            if(this.isBattleCity)
            {
               return Dict.MAIN_MENU_LABEL_QUICKMATCH_BATTLECITY;
            }
            return Dict.MAIN_MENU_LABEL_QUICKMATCH_MP;
         }
         switch(this._coopMapType)
         {
            case CoopMapType.STORY:
               return Dict.MAIN_MENU_LABEL_QUICKMATCH_COOP;
            case CoopMapType.SURVIVAL:
               return Dict.MAIN_MENU_LABEL_QUICKMATCH_SURVIVAL;
            case CoopMapType.ZOMBIE:
               return Dict.MAIN_MENU_LABEL_QUICKMATCH_ZOMBIE;
            case CoopMapType.ZARENA:
               return "@MPUI_ZARENA";
            case CoopMapType.ZOMBIESURVIVAL:
               return "@MPUI_ZSURV";
            case CoopMapType.ZCHAMP:
               return "@MPUI_ZCHAMP";
            default:
               return "";
         }
      }
      
      public function serverChannel() : uint
      {
         if(this._mapType == MapType.MP)
         {
            if(this._coopMapType == CoopMapType.TRAIN)
            {
               return ServerChannel.TRAINING_ROOM;
            }
            return ServerChannel.MP_ROOM;
         }
         if(this._mapType == MapType.COOP)
         {
            return ServerChannel.COOP;
         }
         return ServerChannel.NONE;
      }
      
      public function getCoopModeID() : String
      {
         if(this.isSurvival())
         {
            return ID_SURVIVAL;
         }
         if(this.isCyborgs())
         {
            return ID_FUTURE_CYBORGS;
         }
         if(this.isZArena())
         {
            return ID_ZARENA;
         }
         if(this.isZombieSurvival())
         {
            return ID_ZOMBIESURVIVAL;
         }
         if(this.isZombieChampions())
         {
            return ID_ZCHAMP;
         }
         return ID_COOP_HERO_OPS_SURVIVAL;
      }
      
      public function toString() : String
      {
         return "mapType " + this._mapType + " coopMapType " + this._coopMapType + " isWargod " + this._isWarGod + " isRoom " + this._isRoom + " isBattleCity" + this._isBattleCity;
      }
   }
}

