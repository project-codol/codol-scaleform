package codo.controllers
{
   import codo.base.BaseController;
   import codo.common.CFunctionCommonContainer;
   import codo.constants.BCEvent;
   import codo.constants.Common;
   import codo.constants.DataCommonID;
   import codo.event.ParaEvent;
   import codo.objects.UnlockItemObj;
   import codo.utils.Logger;
   import codo.utils.ScaleformUtil;
   
   public class SummaryBaseController extends BaseController
   {
      
      protected const MIN_ESTIMATION_AVAILABLE_RANK:uint = 1;
      
      protected const MIN_MINUTES_TO_SHOW_PLAYER_LEVELUP:uint = 30;
      
      protected const MIN_MINUTES_TO_SHOW_WEAPON_LEVELUP:uint = 60;
      
      private var _isInGame:Boolean = false;
      
      protected var _unlockObjAll:Array = null;
      
      protected var _unlockObjPrestige:int = -1;
      
      public function SummaryBaseController()
      {
         super();
      }
      
      override protected function onInit() : void
      {
         this.addDP(DataCommonID.SUMMARY_DATA,this.getSummaryData);
         this.addDP(DataCommonID.ESTIMATED_LEVELUP_MINUTES,this.getEstimatedLevelUpMinutes);
         this.addDP(DataCommonID.CLOSEST_WEAPON_UNLOCK,this.getClosestWeaponUnlock);
         this.addDP(DataCommonID.CAREER_UNLOCK_OBJ_ALL_FOR_REAL,this.getForRealAllUnlockObj);
         this.listen(BCEvent.EVT_TRY_CLOSE_REWARD_NOTIFY,this.onTryCloseRewardNotifyHandle);
      }
      
      protected function getEstimatedLevelUpMinutes() : int
      {
         var rank:uint = 0;
         var rankNext:uint = 0;
         var xpNextRank:int = 0;
         var currentXP:int = 0;
         var levelupXP:uint = 0;
         var secondsPlayed:int = 0;
         var averageExpPerSec:Number = NaN;
         var levelupSeconds:Number = NaN;
         var levelupMinutes:int = 0;
         if(ScaleformUtil.isScaleform)
         {
            rank = CFunctionCommonContainer.GetPlayerLevel();
            rankNext = CFunctionCommonContainer.GetPlayerNextLevel();
            xpNextRank = CFunctionCommonContainer.GetXpForNextLevel();
            currentXP = CFunctionCommonContainer.GetPlayerXP();
            levelupXP = xpNextRank - currentXP;
            secondsPlayed = CFunctionCommonContainer.GetPlayerDataInt("timePlayedOverAll",true);
            if(rank < this.MIN_ESTIMATION_AVAILABLE_RANK || levelupXP <= 0)
            {
               return Common.RESULT_NOT_AVAILABLE;
            }
            averageExpPerSec = currentXP / secondsPlayed;
            if(averageExpPerSec <= 0)
            {
               return Common.RESULT_NOT_AVAILABLE;
            }
            levelupSeconds = levelupXP / averageExpPerSec;
            levelupMinutes = Math.round(levelupSeconds / 60);
            Logger.print("We estimate the player will level up in " + levelupMinutes.toString());
            if(levelupMinutes <= this.MIN_MINUTES_TO_SHOW_PLAYER_LEVELUP)
            {
               return levelupMinutes;
            }
            return Common.RESULT_NOT_AVAILABLE;
         }
         return 30;
      }
      
      protected function getClosestWeaponUnlock() : Object
      {
         var retWeaponObject:Object = null;
         var retUnlockObjects:Array = null;
         var _currentWeaponLoadout:Object = null;
         var _currentPrimaryWeaponID:int = 0;
         var _currentSecondaryWeaponID:int = 0;
         var _weaponID:int = 0;
         var _weaponObject:Object = null;
         var _weaponUnlockObjects:Array = null;
         var levelupSeconds:Number = NaN;
         var levelupMinutes:int = 0;
         Logger.print("SummaryControllerCommon::getClosestWeaponUnlock");
         var i:int = 0;
         var loadoutNum:uint = CFunctionCommonContainer.WL_GetUnlockedLoadoutNum();
         var uniqueWeaponArray:Array = new Array();
         var maxRatio:Number = 0;
         var currentXP:int = CFunctionCommonContainer.GetPlayerXP();
         var secondsPlayed:int = CFunctionCommonContainer.GetPlayerDataInt("timePlayedOverAll",true);
         var averageExpPerSec:Number = currentXP / secondsPlayed;
         for(i = 0; i < loadoutNum; i++)
         {
            _currentWeaponLoadout = CFunctionCommonContainer.AS_RequestWeaponLoadout(i);
            _currentPrimaryWeaponID = int(_currentWeaponLoadout.primaryWeapSlot.item_id);
            _currentSecondaryWeaponID = int(_currentWeaponLoadout.secondaryWeapSlot.item_id);
            if(uniqueWeaponArray.indexOf(_currentPrimaryWeaponID) == -1)
            {
               uniqueWeaponArray.push(_currentPrimaryWeaponID);
            }
            if(uniqueWeaponArray.indexOf(_currentSecondaryWeaponID) == -1)
            {
               uniqueWeaponArray.push(_currentSecondaryWeaponID);
            }
         }
         for(i = 0; i < uniqueWeaponArray.length; i++)
         {
            _weaponID = int(uniqueWeaponArray[i]);
            _weaponObject = CFunctionCommonContainer.GetItemInfo(_weaponID);
            Logger.printObj(_weaponObject);
            _weaponUnlockObjects = CFunctionCommonContainer.WL_GetWeaponCareerInfoAtLevel(_weaponID,int(_weaponObject.level) + 1);
            if(_weaponUnlockObjects.length > 0)
            {
               if(_weaponObject.totalExp > 0)
               {
                  if(_weaponObject.currentExp / _weaponObject.totalExp > maxRatio)
                  {
                     maxRatio = _weaponObject.currentExp / _weaponObject.totalExp;
                     retWeaponObject = _weaponObject;
                     retUnlockObjects = _weaponUnlockObjects;
                  }
               }
            }
         }
         if(averageExpPerSec <= 0)
         {
            return {"levelUpMinutes":Common.RESULT_NOT_AVAILABLE};
         }
         if(maxRatio > 0)
         {
            levelupSeconds = (_weaponObject.totalExp - _weaponObject.currentExp) / averageExpPerSec;
            levelupMinutes = Math.round(levelupSeconds / 60);
            if(levelupMinutes > this.MIN_MINUTES_TO_SHOW_WEAPON_LEVELUP)
            {
               return {"levelUpMinutes":Common.RESULT_NOT_AVAILABLE};
            }
            return {
               "levelUpMinutes":levelupMinutes,
               "weaponObj":retWeaponObject,
               "unlockObject":retUnlockObjects[0]
            };
         }
         return {"levelUpMinutes":Common.RESULT_NOT_AVAILABLE};
      }
      
      protected function getSummaryData() : Object
      {
         var summary:Object = CFunctionCommonContainer.FetchGameSummary();
         if(this._isInGame)
         {
            CFunctionCommonContainer.AS_NeedUpdateGameSummary();
         }
         return summary;
      }
      
      private function onTryCloseRewardNotifyHandle(cEvt:ParaEvent) : void
      {
         this.prevPage();
      }
      
      public function set isInGame(cInGame:Boolean) : void
      {
         this._isInGame = cInGame;
      }
      
      protected function getForRealAllUnlockObj() : Array
      {
         if(!CFunctionCommonContainer.IsMarketplaceReady())
         {
            this._unlockObjAll = null;
         }
         else if(this._unlockObjPrestige != 8675309)
         {
            this._unlockObjPrestige = 8675309;
            this._unlockObjAll = CFunctionCommonContainer.ListForRealAllUnlockObj();
         }
         return this._unlockObjAll;
      }
      
      protected function makeFakeUnlockObj(cDest:Array, cMinLevel:int, cMaxLevel:int) : void
      {
         var unlockArr:Array = null;
         var unlockObjNum:int = 0;
         var j:int = 0;
         if(cDest == null)
         {
            return;
         }
         for(var i:int = cMinLevel; i <= cMaxLevel; i++)
         {
            unlockArr = [];
            unlockObjNum = 1 + Math.round(100 + Math.random()) % 5;
            for(j = 0; j < unlockObjNum; j++)
            {
               unlockArr.push(new UnlockItemObj({
                  "name":"name" + i + j,
                  "description":"description" + i + j,
                  "imageURL":"image" + i + j,
                  "category":i % 2
               }));
            }
            if(unlockArr.length > 0)
            {
               cDest.push({
                  "level":i + 1,
                  "items":unlockArr
               });
            }
         }
      }
   }
}

