package codo.controllers
{
   import codo.base.BaseController;
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.constants.BCEvent;
   import codo.constants.Common;
   import codo.constants.DataID;
   import codo.constants.table.CharacterDef;
   import codo.utils.ScaleformUtil;
   
   public class CharacterCreationController extends BaseController
   {
      
      private var _currentSelection:int = -1;
      
      public function CharacterCreationController()
      {
         super();
      }
      
      override protected function onInitialized() : void
      {
         this.addDP(DataID.HAS_MP_CHARACTER,this.hasCharacter);
         this.addDP(DataID.HAS_CYBORGS_CHARACTER,this.hasCyborgsCharacter);
         this.addDP(DataID.IS_TCLS_LOGON,this.isTCLSLogOn);
         this.bind(DataID.CHARACTER_CREATION_EVENT,this.onHandleCharacterCreationEvent);
      }
      
      private function hasCharacter() : Boolean
      {
         return ScaleformUtil.isScaleform ? Boolean(CFunctionContainer.HasCharacter()) : true;
      }
      
      private function hasCyborgsCharacter() : Boolean
      {
         return ScaleformUtil.isScaleform ? Boolean(CFunctionContainer.HaveZombieCharacter()) : true;
      }
      
      private function isTCLSLogOn() : Boolean
      {
         return Boolean(CFunctionContainer.IsTCLSLogOn());
      }
      
      private function GetCharacterInfo(iFaction:int, headID:int) : Object
      {
         var characterInfo:Object = new Object();
         if(iFaction == Common.LOADOUT_TYPE_TF)
         {
            characterInfo.forceName = "@SF_UI_CHARACTER_CREATE_TF141";
            characterInfo.forceIntro = "@SF_UI_CHARACTER_CREATE_TF141_DESC";
         }
         else if(iFaction == Common.LOADOUT_TYPE_SC)
         {
            characterInfo.forceName = "@SF_UI_CHARACTER_CREATE_SC";
            characterInfo.forceIntro = "@SF_UI_CHARACTER_CREATE_SC_DESC";
         }
         else
         {
            characterInfo.forceName = null;
            characterInfo.forceIntro = null;
         }
         characterInfo.item = CFunctionCommonContainer.GetItemInfo(headID);
         characterInfo.characterName = characterInfo.item.name;
         characterInfo.characterIntro = characterInfo.item.description;
         characterInfo.characterHeight = "@" + CFunctionCommonContainer.StringTableLookup(CharacterDef.PATH,CharacterDef.NAMEID,characterInfo.item.nameid,CharacterDef.HEIGHT);
         characterInfo.characterWeight = "@" + CFunctionCommonContainer.StringTableLookup(CharacterDef.PATH,CharacterDef.NAMEID,characterInfo.item.nameid,CharacterDef.WEIGHT);
         characterInfo.characterSpec = "@" + CFunctionCommonContainer.StringTableLookup(CharacterDef.PATH,CharacterDef.NAMEID,characterInfo.item.nameid,CharacterDef.SPEC);
         return characterInfo;
      }
      
      private function onHandleCharacterCreationEvent(cRes:Object) : void
      {
         var bShow:Boolean = cRes.data.bShow == 1;
         var iFaction:int = int(cRes.data.iFaction);
         var iPlayer:int = int(cRes.data.iPlayer);
         var headID:int = int(cRes.data.headID);
         this._currentSelection = iPlayer;
         if(bShow)
         {
            this.broadcast(BCEvent.EVT_SHOW_CHARACTER_CREATION_DETAIL,{"index":iPlayer});
         }
         this.setBindData(DataID.CHARACTER_CREATION_CURRRENT_DETAIL_DATA,this.GetCharacterInfo(iFaction,headID));
      }
   }
}

