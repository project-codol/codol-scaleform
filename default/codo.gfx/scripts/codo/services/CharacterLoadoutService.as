package codo.services
{
   import codo.base.ServiceBase;
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.constants.Common;
   import codo.constants.DataID;
   import codo.constants.ServiceID;
   import codo.objects.CharacterObj;
   import codo.objects.ResultObj;
   import codo.utils.Logger;
   import codo.utils.ScaleformUtil;
   
   public class CharacterLoadoutService extends ServiceBase
   {
      
      private static var instance:CharacterLoadoutService;
      
      public static var MAX_LOADOUT_CHARACTERS:int = 12;
      
      private var _currentCategory:String = "fja";
      
      private var _currentLoadoutType:uint = 0;
      
      private var _bIsInMarket:Boolean = false;
      
      private var _bIsAllUnlocked:Boolean = false;
      
      private var _currentListDP:Array;
      
      private var m_bShowAvatarLoadout:Boolean = false;
      
      private var m_cachedSortedCharacters:Vector.<CharacterObj> = new Vector.<CharacterObj>();
      
      private var m_cachedUnassignedCharacters:Vector.<CharacterObj> = new Vector.<CharacterObj>();
      
      private var m_showExceededCharacterLimit:Boolean = false;
      
      public function CharacterLoadoutService()
      {
         super(ServiceID.AVATAR);
      }
      
      public static function getInstance() : CharacterLoadoutService
      {
         if(CharacterLoadoutService.instance == null)
         {
            CharacterLoadoutService.instance = new CharacterLoadoutService();
         }
         return CharacterLoadoutService.instance;
      }
      
      public function get currentCategory() : String
      {
         return this._currentCategory;
      }
      
      public function set currentCategory(value:String) : void
      {
         this._currentCategory = value;
      }
      
      public function get currentLoadoutType() : uint
      {
         return this._currentLoadoutType;
      }
      
      public function get bIsAllUnlocked() : Boolean
      {
         return this._bIsAllUnlocked;
      }
      
      public function set bIsAllUnlocked(value:Boolean) : void
      {
         if(this._bIsAllUnlocked != value)
         {
            this._bIsAllUnlocked = value;
         }
      }
      
      public function unlockAllItems(bVal:Boolean) : void
      {
         this.bIsAllUnlocked = bVal;
      }
      
      override public function init() : void
      {
         register(DataID.CHARACTERLOADOUT_CHARACTERS,this.updateCharacters);
         setData(ResultObj.getObj(DataID.CHARACTERLOADOUT_SELECTED_FACTION,this._currentLoadoutType));
      }
      
      override public function postActivate() : void
      {
         if(Boolean(CFunctionCommonContainer.IsMarketplaceReady()))
         {
            this.updateCharacters();
         }
      }
      
      public function getActiveCharacterLoadout() : Object
      {
         return CFunctionContainer.CL_GetActiveCharacterLoadout();
      }
      
      public function changeFactionIdx(faction:uint) : void
      {
         if(this._currentLoadoutType == faction)
         {
            return;
         }
         this._currentLoadoutType = faction;
         CFunctionContainer.UIViewer_SetFaction(this._currentLoadoutType);
         setData(ResultObj.getObj(DataID.CHARACTERLOADOUT_SELECTED_FACTION,this._currentLoadoutType));
      }
      
      public function requestCharacterLoadout() : void
      {
         CFunctionContainer.CL_GetActiveCharacterLoadout();
      }
      
      public function getCharactersByType(type:uint) : Vector.<CharacterObj>
      {
         var _fullList:Vector.<CharacterObj> = this.getAssignedCharacters();
         var _filteredList:Vector.<CharacterObj> = new Vector.<CharacterObj>();
         for(var i:uint = 0; i < _fullList.length; i++)
         {
            if(_fullList[i].type == Common.LOADOUT_TYPES[type])
            {
               _filteredList.push(_fullList[i]);
            }
         }
         return _filteredList;
      }
      
      public function getDefaultCharacter(type:uint) : CharacterObj
      {
         var _fullList:Vector.<CharacterObj> = this.getAssignedCharacters();
         for(var i:uint = 0; i < _fullList.length; i++)
         {
            if(_fullList[i].type == Common.LOADOUT_TYPES[type] && _fullList[i].isDefault)
            {
               return _fullList[i];
            }
         }
         return null;
      }
      
      public function updateCharacters() : void
      {
         var i:uint = 0;
         var oldAssignCharacterCount:int = int(this.m_cachedSortedCharacters.length);
         var oldUnassignCharacterCount:int = int(this.m_cachedUnassignedCharacters.length);
         var fullSortedCharacters:Vector.<CharacterObj> = this.getAssignedCharacters();
         var unassignedCharacters:Vector.<CharacterObj> = this.getUnassignedCharacters();
         var shouldSetData:Boolean = true;
         if(this.m_cachedSortedCharacters.length == fullSortedCharacters.length && this.m_cachedUnassignedCharacters.length == unassignedCharacters.length)
         {
            shouldSetData = false;
            for(i = 0; i < fullSortedCharacters.length; i++)
            {
               if(fullSortedCharacters[i].id != this.m_cachedSortedCharacters[i].id)
               {
                  shouldSetData = true;
                  break;
               }
               if(this.m_cachedSortedCharacters[i].isPermanentHave != fullSortedCharacters[i].isPermanentHave)
               {
                  shouldSetData = true;
                  break;
               }
               if(this.m_cachedSortedCharacters[i].isPermanentHave == false && (this.m_cachedSortedCharacters[i].remainSecond > 0 && fullSortedCharacters[i].remainSecond <= 0 || this.m_cachedSortedCharacters[i].remainSecond <= 0 && fullSortedCharacters[i].remainSecond > 0))
               {
                  shouldSetData = true;
                  break;
               }
               if(this.m_cachedSortedCharacters[i].showBreadcrumb != fullSortedCharacters[i].showBreadcrumb)
               {
                  shouldSetData = true;
                  break;
               }
            }
            if(!shouldSetData)
            {
               for(i = 0; i < unassignedCharacters.length; i++)
               {
                  if(unassignedCharacters[i].id != this.m_cachedUnassignedCharacters[i].id)
                  {
                     shouldSetData = true;
                     break;
                  }
                  if(this.m_cachedUnassignedCharacters[i].isPermanentHave != unassignedCharacters[i].isPermanentHave)
                  {
                     shouldSetData = true;
                     break;
                  }
                  if(this.m_cachedUnassignedCharacters[i].isPermanentHave == false && (this.m_cachedUnassignedCharacters[i].remainSecond > 0 && unassignedCharacters[i].remainSecond <= 0 || this.m_cachedUnassignedCharacters[i].remainSecond <= 0 && unassignedCharacters[i].remainSecond > 0))
                  {
                     shouldSetData = true;
                     break;
                  }
               }
            }
         }
         if(shouldSetData)
         {
            Logger.print("CharacterLoadoutService:::updateCharacters");
            this.m_cachedSortedCharacters = fullSortedCharacters;
            this.m_cachedUnassignedCharacters = unassignedCharacters;
            setData(ResultObj.getObj(DataID.CHARACTERLOADOUT_CHARACTERS,fullSortedCharacters));
         }
         this.m_showExceededCharacterLimit = false;
         if(oldAssignCharacterCount > 1 && oldAssignCharacterCount <= MAX_LOADOUT_CHARACTERS && oldUnassignCharacterCount == 0 && this.m_cachedSortedCharacters.length == MAX_LOADOUT_CHARACTERS && this.m_cachedUnassignedCharacters.length > 0)
         {
            this.m_showExceededCharacterLimit = true;
         }
      }
      
      public function showExceededCharacterLimit() : Boolean
      {
         return this.m_showExceededCharacterLimit;
      }
      
      public function resetShowExceededCharacterLimit() : void
      {
         this.m_showExceededCharacterLimit = false;
      }
      
      public function isCharacterLoadoutFull() : Boolean
      {
         return this.m_cachedSortedCharacters.length == MAX_LOADOUT_CHARACTERS;
      }
      
      public function hasCharactersInReserve() : Boolean
      {
         return this.m_cachedUnassignedCharacters.length > 0;
      }
      
      public function isLoadoutCharacter(charID:int) : Boolean
      {
         var charObj:Object = null;
         for each(charObj in this.m_cachedSortedCharacters)
         {
            if(charObj.id == charID)
            {
               return true;
            }
         }
         return false;
      }
      
      public function updateTFCharacters() : void
      {
         Logger.print("CharacterLoadoutService::updateTFCharacters");
         var characters:Vector.<CharacterObj> = this.getCharactersByType(Common.LOADOUT_TYPE_TF);
         if(characters.length > 0)
         {
            this.setData(ResultObj.getObj(DataID.CHARACTERLOADOUT_CHARACTERS_TF,characters));
         }
      }
      
      public function updateSCCharacters() : void
      {
         Logger.print("CharacterLoadoutService::updateSCCharacters");
         var characters:Vector.<CharacterObj> = this.getCharactersByType(Common.LOADOUT_TYPE_SC);
         if(characters.length > 0)
         {
            this.setData(ResultObj.getObj(DataID.CHARACTERLOADOUT_CHARACTERS_SC,characters));
         }
      }
      
      public function updateZMCharacters() : void
      {
         Logger.print("CharacterLoadoutService::updateZMCharacters");
         var characters:Vector.<CharacterObj> = this.getCharactersByType(Common.LOADOUT_TYPE_ZM);
         if(characters.length > 0)
         {
            this.setData(ResultObj.getObj(DataID.CHARACTERLOADOUT_CHARACTERS_CYBORGS,characters));
         }
      }
      
      private function getAssignedCharacters() : Vector.<CharacterObj>
      {
         var numCharacters:int = 0;
         var i:int = 0;
         var product:Object = null;
         var fullCharacters:Vector.<CharacterObj> = new Vector.<CharacterObj>();
         if(ScaleformUtil.isScaleform)
         {
            if(Boolean(CFunctionCommonContainer.IsMarketplaceReady()) && Boolean(CFunctionContainer.IsPlayerStatsReady()) && Boolean(CFunctionCommonContainer.IsRewardDataReady()))
            {
               fullCharacters = Vector.<CharacterObj>(CFunctionContainer.CL_GetCharacters(true));
            }
            numCharacters = int(fullCharacters.length);
            for(i = numCharacters - 1; i >= 0; i--)
            {
               product = fullCharacters[i];
               if(!product.isPermanentHave && product.remainSecond <= 0)
               {
                  fullCharacters.splice(i,1);
               }
            }
         }
         else
         {
            fullCharacters.push({
               "id":116,
               "name":"@SF_UI_HEA_SOCOMC_NAME",
               "description":"@SF_UI_HEA_SOCOMC_DESC",
               "type":"sc",
               "isDefault":true,
               "imageURL":""
            });
            fullCharacters.push({
               "id":162,
               "name":"@SF_UI_HEA_CONCEPT_NAME",
               "description":"@SF_UI_HEA_CONCEPT_DESC",
               "type":"sc",
               "isDefault":false,
               "imageURL":""
            });
            fullCharacters.push({
               "id":189,
               "name":"@SF_UI_HEA_HJELMAA_NAME",
               "description":"@SF_UI_HEA_HJELMAA_DESC",
               "type":"tf",
               "isDefault":true,
               "imageURL":""
            });
            fullCharacters.push({
               "id":218,
               "name":"@SF_UI_HEA_ZMLUBU_NAME",
               "description":"@SF_UI_HEA_ZMLUBU_DESC",
               "type":"zm",
               "isDefault":true,
               "imageURL":""
            });
         }
         Logger.print("CharacterLoadoutService::getAssignedCharacters count " + fullCharacters.length);
         return fullCharacters;
      }
      
      public function getAssignedCharacterArray(skipExpired:Boolean = false) : Vector.<CharacterObj>
      {
         var chars:Vector.<CharacterObj> = null;
         var i:int = 0;
         if(this.m_cachedSortedCharacters == null || this.m_cachedSortedCharacters.length == 0)
         {
            this.updateCharacters();
         }
         if(skipExpired)
         {
            chars = new Vector.<CharacterObj>(0);
            for(i = 0; i < this.m_cachedSortedCharacters.length; i++)
            {
               if(!this.m_cachedSortedCharacters[i].hasExpired)
               {
                  chars.push(this.m_cachedSortedCharacters[i]);
               }
            }
            return chars;
         }
         return this.m_cachedSortedCharacters;
      }
      
      public function getUnassignedCharacterArray(skipExpired:Boolean = false) : Vector.<CharacterObj>
      {
         var chars:Vector.<CharacterObj> = null;
         var i:int = 0;
         if(skipExpired)
         {
            chars = new Vector.<CharacterObj>(0);
            for(i = 0; i < this.m_cachedUnassignedCharacters.length; i++)
            {
               if(!this.m_cachedUnassignedCharacters[i].hasExpired)
               {
                  chars.push(this.m_cachedUnassignedCharacters[i]);
               }
            }
            return chars;
         }
         return this.m_cachedUnassignedCharacters;
      }
      
      public function getTotalCharsOwned() : int
      {
         return this.getAssignedCharacterArray(true).length + this.getUnassignedCharacterArray(true).length;
      }
      
      private function getUnassignedCharacters() : Vector.<CharacterObj>
      {
         var numCharacters:int = 0;
         var i:int = 0;
         var product:Object = null;
         var unassignedCharacters:Vector.<CharacterObj> = new Vector.<CharacterObj>();
         if(ScaleformUtil.isScaleform)
         {
            if(Boolean(CFunctionCommonContainer.IsMarketplaceReady()) && Boolean(CFunctionContainer.IsPlayerStatsReady()) && Boolean(CFunctionCommonContainer.IsRewardDataReady()))
            {
               unassignedCharacters = Vector.<CharacterObj>(CFunctionContainer.CL_GetCharacters(false));
            }
            numCharacters = int(unassignedCharacters.length);
            for(i = numCharacters - 1; i >= 0; i--)
            {
               product = unassignedCharacters[i];
               if(!product.isPermanentHave && product.remainSecond <= 0)
               {
                  unassignedCharacters.splice(i,1);
               }
            }
         }
         Logger.print("CharacterLoadoutService::getUnassignedCharacters count " + unassignedCharacters.length);
         return unassignedCharacters;
      }
      
      private function sortByLoadout(a:Object, b:Object) : int
      {
         if(a.loadoutIdx < b.loadoutIdx)
         {
            return -1;
         }
         if(a.loadoutIdx > b.loadoutIdx)
         {
            return 1;
         }
         return 0;
      }
      
      public function setDefaultCharacterID(characterID:int) : void
      {
         Logger.print("CharacterLoadoutService::setDefaultCharacter");
         if(ScaleformUtil.isScaleform)
         {
            CFunctionContainer.CL_SetDefaultCharacter(characterID);
         }
      }
      
      public function setCurrentCharacterID(characterID:int) : void
      {
         Logger.print("CharacterLoadoutService::setCurrentCharacter");
         if(ScaleformUtil.isScaleform && characterID > 0)
         {
            CFunctionContainer.CL_SetCurrentCharacterID(characterID);
         }
      }
      
      public function set showAvatarLoadout(bFlag:Boolean) : void
      {
         this.m_bShowAvatarLoadout = bFlag;
      }
      
      public function get showAvatarLoadout() : Boolean
      {
         return this.m_bShowAvatarLoadout;
      }
   }
}

