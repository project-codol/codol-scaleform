package codo.cpp
{
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.constants.QuickMatchType;
   import codo.event.ParaEvent;
   import codo.manager.DataManager;
   import codo.manager.EventManager;
   import codo.objects.CharacterObj;
   import codo.objects.ResultObj;
   import codo.services.CharacterLoadoutService;
   
   public dynamic class UiCppMainMenu extends UiCpp
   {
      
      private static var _instance:UiCppMainMenu;
      
      public static var CPP_TYPE:uint;
      
      private var _newItems:UiCppNewItems;
      
      private var _onboarding:UiCppOnboarding;
      
      private var _newModes:UiCppNewModes;
      
      public function UiCppMainMenu()
      {
         super();
         this._newItems = new UiCppNewItems();
         this._onboarding = new UiCppOnboarding();
         this._newModes = new UiCppNewModes();
      }
      
      public static function get instance() : UiCppMainMenu
      {
         return _instance;
      }
      
      public static function Init() : void
      {
         if(_instance == null)
         {
            _instance = new UiCppMainMenu();
         }
      }
      
      override public function GetUiCppType() : uint
      {
         return CPP_TYPE;
      }
      
      public function CPP_GetQuickMatchType() : QuickMatchType
      {
         return DataManager.getInstance().getDP(DataID.CURRENT_MATCH_TYPE);
      }
      
      public function CPP_InitInventoryChangeEvent(uiCpp:UiCpp, func:String) : void
      {
         this.ListenEvent(BCEvent.EVT_REFRESH_UI_AFTER_INVENTORY_CHANGE,function(evt:ParaEvent):void
         {
            uiCpp[func]();
         });
      }
      
      public function CPP_InitEquippedEvent(uiCpp:UiCpp, func:String) : void
      {
         this.ListenEvent(BCEvent.EVT_EQUIPPED,function(evt:ParaEvent):void
         {
            uiCpp[func]();
         });
      }
      
      public function CPP_InitFactionChangeEvent(uiCpp:UiCpp, func:String) : void
      {
         this.BindData(DataID.CHARACTERLOADOUT_SELECTED_FACTION,function(evt:ResultObj):void
         {
            uiCpp[func]();
         });
      }
      
      public function CPP_InitCharacterChangeEvent(uiCpp:UiCpp, func:String) : void
      {
         this.BindData(DataID.CHARACTERLOADOUT_CHARACTERS_CURRENT_SHOWN_ID,function(evt:ResultObj):void
         {
            uiCpp[func]();
         });
      }
      
      public function CPP_InitGroupCountsChangeEvent(uiCpp:UiCpp, func:String) : void
      {
         this.BindData(DataID.GROUP_COUNTS,function(evt:ResultObj):void
         {
            uiCpp[func]();
         });
      }
      
      public function CPP_InitFullClientDownloadedEvent(uiCpp:UiCpp, func:String) : void
      {
         this.ListenEvent(BCEvent.EVT_FULLCLIENT_DOWNLOADED,function(evt:ParaEvent):void
         {
            uiCpp[func]();
         });
      }
      
      public function CPP_InitRoomsListedEvent(uiCpp:UiCpp, func:String) : void
      {
         this.ListenEvent(BCEvent.EVT_ON_ROOM_LISTED,function(evt:ParaEvent):void
         {
            uiCpp[func](evt.myPara.finished,evt.myPara.rooms);
         });
      }
      
      public function CPP_InitRoomListExpiredEvent(uiCpp:UiCpp, func:String) : void
      {
         this.ListenEvent(BCEvent.ROOM_LIST_SESSION_EXPIRED,function(evt:ParaEvent):void
         {
            uiCpp[func]();
         });
      }
      
      public function CPP_InitRoomListAlmostViewedFinishEvent(uiCpp:UiCpp, func:String) : void
      {
         this.ListenEvent(BCEvent.ROOM_LIST_VIEW_ALMOST_VIEWED_FINISH,function(evt:ParaEvent):void
         {
            uiCpp[func](evt.myPara);
         });
      }
      
      public function CPP_InitBattleCityLeagueOpenStateChangeEvent(uiCpp:UiCpp, func:String) : void
      {
         this.ListenEvent(BCEvent.EVT_BATTLECITY_OPEN_STATE_CHANGE,function(evt:ParaEvent):void
         {
            uiCpp[func]();
         });
      }
      
      public function CPP_SetCharacter(index:uint) : void
      {
         var curId:int = DataManager.getInstance().getDP(DataID.CHARACTERLOADOUT_CHARACTERS_CURRENT_SHOWN_ID);
         var characters:Vector.<CharacterObj> = CharacterLoadoutService.getInstance().getAssignedCharacterArray();
         var character:CharacterObj = characters[index];
         if(character.id != curId)
         {
            EventManager.getInstance().broadcast(BCEvent.EVT_CHARACTERLOADOUT_CHANGED,character);
            EventManager.getInstance().broadcast(BCEvent.EVT_SET_DEFAULT_CHARACTER,{"character":character});
         }
      }
      
      private function ListenEvent(evt:String, func:Function) : void
      {
         EventManager.getInstance().listen(evt,func,false,0,false);
      }
      
      private function BindData(id:*, func:Function) : void
      {
         DataManager.getInstance().bind(id,func,null,false);
      }
   }
}

