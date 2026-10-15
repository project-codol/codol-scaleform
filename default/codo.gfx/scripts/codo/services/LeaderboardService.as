package codo.services
{
   import codo.base.ServiceBase;
   import codo.constants.AsyncTaskGroup;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.constants.ServiceID;
   import codo.constants.table.Leaderboard;
   import codo.localization.Dict;
   import codo.objects.LeaderboardElementObj;
   import codo.objects.ResultObj;
   import codo.utils.Logger;
   import codo.utils.ScaleformUtil;
   import codo.utils.TableUtil;
   
   public class LeaderboardService extends ServiceBase
   {
      
      private static var _instance:LeaderboardService;
      
      private var _lbTable:String = "LB_KILLS";
      
      private var _lbFilter0:String = "";
      
      private var _lbFilter1:String = "";
      
      private var _lbFilter2:String = "";
      
      private var _lbParams:String = "";
      
      private var _lbTimeFilter:String = "";
      
      private var _paramList:Array = [];
      
      private var _timeList:Array = [];
      
      private var _filter0List:Array = [];
      
      private var _filter1List:Array = [];
      
      private var _filter2List:Array = [];
      
      private var _leaderboardList:Array = [];
      
      private var _fakeLeaderboard:Array = null;
      
      private var _optionArray:Array = ["user","type","gameType","parameter"];
      
      public function LeaderboardService()
      {
         super(ServiceID.LEADERBOARD);
      }
      
      public static function getInstance() : LeaderboardService
      {
         if(LeaderboardService._instance == null)
         {
            LeaderboardService._instance = new LeaderboardService();
         }
         return LeaderboardService._instance;
      }
      
      override public function init() : void
      {
         this.register(DataID.LEADERBOARD_SEARCHDATE,this.getSearchDate);
         this.register(DataID.LEADERBOARD_FILTER0,this.getFilter0);
         this.register(DataID.LEADERBOARD_FILTER1,this.getFilter1);
         this.register(DataID.LEADERBOARD_FILTER2,this.getFilter2);
         this.register(DataID.LEADERBOARD_PARAMETER0,this.getParameter0);
         this.addToFilterList(this._timeList,[{
            "name":"ALLTIME",
            "index":0
         },{
            "name":"MON",
            "index":1
         },{
            "name":"WK",
            "index":2
         }]);
         this._lbTimeFilter = this._timeList[0].id;
         this.parseLeaderboardTable();
      }
      
      public function parseLeaderboardTable() : void
      {
         var rowNum:int = 0;
         var row:int = 0;
         var enableFlag:int = 0;
         var leaderboardElementObj:LeaderboardElementObj = null;
         Logger.print("LeaderboardService:::parseLeaderboardTable");
         if(this._leaderboardList.length <= 0)
         {
            if(ScaleformUtil.isScaleform == false)
            {
               this._leaderboardList.push(new LeaderboardElementObj({
                  "index":100,
                  "name":"LB_MP_ALL_SCORE0",
                  "user":"PLAYER",
                  "type":"MP",
                  "gameType":"ALL",
                  "parameter":"Total Score",
                  "time":"ALL"
               }));
               this._leaderboardList.push(new LeaderboardElementObj({
                  "index":101,
                  "name":"LB_MP_ALL_SCORE1",
                  "user":"PLAYER",
                  "type":"MP",
                  "gameType":"TDM",
                  "parameter":"Kills",
                  "time":"ALL"
               }));
               this._leaderboardList.push(new LeaderboardElementObj({
                  "index":102,
                  "name":"LB_MP_ALL_SCORE2",
                  "user":"PLAYER",
                  "type":"SP",
                  "gameType":"Crash",
                  "parameter":"Total Score",
                  "time":"ALL"
               }));
               this._leaderboardList.push(new LeaderboardElementObj({
                  "index":103,
                  "name":"LB_MP_ALL_SCORE3",
                  "user":"CLAN",
                  "type":"MP",
                  "gameType":"ALL",
                  "parameter":"Total Score",
                  "time":"ALL"
               }));
               this._leaderboardList.push(new LeaderboardElementObj({
                  "index":104,
                  "name":"LB_MP_ALL_SCORE4",
                  "user":"CLAN",
                  "type":"MP",
                  "gameType":"TDM",
                  "parameter":"Kills",
                  "time":"ALL"
               }));
               this._leaderboardList.push(new LeaderboardElementObj({
                  "index":105,
                  "name":"LB_MP_ALL_SCORE5",
                  "user":"CLAN",
                  "type":"SP",
                  "gameType":"Crash",
                  "parameter":"Total Score",
                  "time":"ALL"
               }));
            }
            else
            {
               rowNum = TableUtil.getRowCount(Leaderboard.PATH);
               for(row = 0; row < rowNum; row++)
               {
                  enableFlag = int(TableUtil.getValue(Leaderboard.PATH,row,Leaderboard.FLAG));
                  if(enableFlag != 0)
                  {
                     leaderboardElementObj = new LeaderboardElementObj();
                     leaderboardElementObj.index = int(TableUtil.getValue(Leaderboard.PATH,row,Leaderboard.INDEX));
                     leaderboardElementObj.name = TableUtil.getValue(Leaderboard.PATH,row,Leaderboard.NAME);
                     leaderboardElementObj.user = TableUtil.getValue(Leaderboard.PATH,row,Leaderboard.USER);
                     leaderboardElementObj.type = TableUtil.getValue(Leaderboard.PATH,row,Leaderboard.TYPE);
                     leaderboardElementObj.gameType = TableUtil.getValue(Leaderboard.PATH,row,Leaderboard.GAME_TYPE);
                     leaderboardElementObj.parameter = TableUtil.getValue(Leaderboard.PATH,row,Leaderboard.PARAMETER);
                     leaderboardElementObj.time = TableUtil.getValue(Leaderboard.PATH,row,Leaderboard.TIME);
                     this._leaderboardList.push(leaderboardElementObj);
                  }
               }
            }
         }
      }
      
      private function setDynamicParameters(step:int) : void
      {
         var resultList:Array = null;
         switch(step)
         {
            case 0:
               resultList = this.getUniqueOptions([]);
               this.addToFilterList(this._filter0List,resultList);
               this._lbFilter0 = resultList[0].name;
               this.getFilter0();
            case 1:
               resultList = this.getUniqueOptions([this._lbFilter0]);
               this.addToFilterList(this._filter1List,resultList);
               this._lbFilter1 = resultList[0].name;
               this.getFilter1();
            case 2:
               resultList = this.getUniqueOptions([this._lbFilter0,this._lbFilter1]);
               this.addToFilterList(this._filter2List,resultList);
               this._lbFilter2 = resultList[0].name;
               this.getFilter2();
            case 3:
               resultList = this.getUniqueOptions([this._lbFilter0,this._lbFilter1,this._lbFilter2]);
               this.addToFilterList(this._paramList,resultList);
               this._lbParams = resultList[0].name;
               this.getParameter0();
         }
         this.broadcast(BCEvent.LEADERBOARD_COMBOBOXRESET,step);
      }
      
      private function addToFilterList(filterList:Array, sourceList:Array) : void
      {
         filterList.splice(0);
         for(var i:int = 0; i < sourceList.length; i++)
         {
            filterList.push({
               "label":this.getLeaderboardLocalization(sourceList[i].name),
               "id":sourceList[i].name
            });
         }
      }
      
      private function getLeaderboardLocalization(name:String) : String
      {
         if(ScaleformUtil.isScaleform)
         {
            return "@" + TableUtil.lookup("mp/leaderboardsLocalization.csv",0,name,1);
         }
         return name;
      }
      
      private function getUniqueOptions(settledOptions:Array) : Array
      {
         var key:String = null;
         var keyOption:String = null;
         var valueOption:String = null;
         var bMatchSettledOptions:Boolean = false;
         var optionIndex:int = 0;
         var _targetPos:int = int(settledOptions.length);
         var _uniqueOptions:Object = new Object();
         for(var i:int = 0; i < this._leaderboardList.length; i++)
         {
            keyOption = this._optionArray[_targetPos];
            valueOption = this._leaderboardList[i][keyOption];
            bMatchSettledOptions = true;
            for(optionIndex = 0; optionIndex < _targetPos; optionIndex++)
            {
               if(this._leaderboardList[i][this._optionArray[optionIndex]] != settledOptions[optionIndex])
               {
                  bMatchSettledOptions = false;
                  break;
               }
            }
            if(bMatchSettledOptions)
            {
               if(!_uniqueOptions.hasOwnProperty(valueOption))
               {
                  _uniqueOptions[valueOption] = i;
               }
            }
         }
         var _uniqueOptionList:Array = new Array();
         for(key in _uniqueOptions)
         {
            _uniqueOptionList.push({
               "name":key,
               "index":_uniqueOptions[key]
            });
         }
         return _uniqueOptionList.sortOn("index");
      }
      
      private function get fakeLeaderboard() : Array
      {
         var rankList:Array = null;
         var i:uint = 0;
         if(ScaleformUtil.isScaleform)
         {
            return null;
         }
         if(this._fakeLeaderboard == null)
         {
            rankList = [];
            for(i = 1; i <= 50; i++)
            {
               rankList.push({
                  "name":"Player" + i,
                  "id":i,
                  "rank":i,
                  "value":50 - i + 1
               });
            }
            this._fakeLeaderboard = [rankList,{"rank":51},""];
         }
         return this._fakeLeaderboard;
      }
      
      public function listLeaderboard(cObj:Object, showPopup:Boolean) : void
      {
         Logger.print("LeaderboardService::listLeaderboard - " + cObj.leaderboard.toString());
         if(this.createTask(DataID.LIST_LEADERBOARD,AsyncTaskGroup.LEADERBOARD,cObj,this.fakeLeaderboard))
         {
            if(showPopup)
            {
               this.showMsg(Dict.NOTE_LIST_LEADERBOARD);
            }
         }
      }
      
      private function getLBTable(user:String, type:String, gameType:String, parameter:String, time:String) : String
      {
         var i:int = 0;
         for(i = 0; i < this._leaderboardList.length; i++)
         {
            if(this._leaderboardList[i].user == user && this._leaderboardList[i].type == type && this._leaderboardList[i].gameType == gameType && this._leaderboardList[i].parameter == parameter && this._leaderboardList[i].time == time)
            {
               return this._leaderboardList[i].name;
            }
         }
         return "";
      }
      
      public function fsgUpdateLeaderboard(lbName:String, filter:int, bShowPopup:Boolean = true) : void
      {
         this.listLeaderboard({
            "leaderboard":lbName,
            "filter":filter
         },bShowPopup);
      }
      
      public function updateLeaderboard(bShowPopup:Boolean = true) : void
      {
         Logger.print("LeaderboardService:::updateLeaderboard: " + this._lbFilter0 + "|" + this._lbFilter1 + "|" + this._lbFilter2 + "|" + this._lbParams + "|" + this._lbTimeFilter);
         this._lbTable = this.getLBTable(this._lbFilter0,this._lbFilter1,this._lbFilter2,this._lbParams,this._lbTimeFilter);
         if(this._lbTable != "")
         {
            this.listLeaderboard({
               "leaderboard":this._lbTable,
               "filter":0
            },bShowPopup);
         }
         else
         {
            this.parseLeaderboardTable();
            this.setDynamicParameters(0);
            this.updateLeaderboard(bShowPopup);
         }
      }
      
      public function changeTime(cParams:Object) : void
      {
         if(this._lbTimeFilter != this._timeList[cParams].id)
         {
            this._lbTimeFilter = this._timeList[cParams].id;
            this.updateLeaderboard();
         }
      }
      
      public function changeFilter0(cParams:Object) : void
      {
         if(this._lbFilter0 != this._filter0List[cParams].id)
         {
            this._lbFilter0 = this._filter0List[cParams].id;
            this.setDynamicParameters(1);
            this.updateLeaderboard();
         }
      }
      
      public function changeFilter1(cParams:Object) : void
      {
         if(this._lbFilter1 != this._filter1List[cParams].id)
         {
            this._lbFilter1 = this._filter1List[cParams].id;
            this.setDynamicParameters(2);
            this.updateLeaderboard();
         }
      }
      
      public function changeFilter2(cParams:Object) : void
      {
         if(this._lbFilter2 != this._filter2List[cParams].id)
         {
            this._lbFilter2 = this._filter2List[cParams].id;
            this.setDynamicParameters(3);
            this.updateLeaderboard();
         }
      }
      
      public function changeParam(cParams:Object) : void
      {
         if(this._lbParams != this._paramList[cParams].id)
         {
            this._lbParams = this._paramList[cParams].id;
            this.updateLeaderboard();
         }
      }
      
      public function resetAll() : void
      {
         if(this._timeList.length != 0)
         {
            this._lbTimeFilter = this._timeList[0].id;
         }
         if(this._filter0List.length != 0)
         {
            this._lbFilter0 = this._filter0List[0].id;
         }
         if(this._filter1List.length != 0)
         {
            this._lbFilter1 = this._filter1List[0].id;
         }
         if(this._filter2List.length != 0)
         {
            this._lbFilter2 = this._filter2List[0].id;
         }
         if(this._paramList.length != 0)
         {
            this._lbParams = this._paramList[0].id;
         }
      }
      
      private function getFilter0() : void
      {
         this.setData(ResultObj.getObj(DataID.LEADERBOARD_FILTER0,this._filter0List));
      }
      
      private function getFilter1() : void
      {
         this.setData(ResultObj.getObj(DataID.LEADERBOARD_FILTER1,this._filter1List));
      }
      
      private function getFilter2() : void
      {
         this.setData(ResultObj.getObj(DataID.LEADERBOARD_FILTER2,this._filter2List));
      }
      
      private function getParameter0() : void
      {
         this.setData(ResultObj.getObj(DataID.LEADERBOARD_PARAMETER0,this._paramList));
      }
      
      private function getSearchDate() : void
      {
         this.setData(ResultObj.getObj(DataID.LEADERBOARD_SEARCHDATE,this._timeList));
      }
   }
}

