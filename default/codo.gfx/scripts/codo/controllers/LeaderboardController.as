package codo.controllers
{
   import codo.base.BaseController;
   import codo.common.CFunctionContainer;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.event.ParaEvent;
   import codo.services.LeaderboardService;
   
   public class LeaderboardController extends BaseController
   {
      
      public static const LB_WIN:int = 0;
      
      public static const LB_WR:int = 1;
      
      public static const LB_KILL:int = 2;
      
      public static const LB_KDR:int = 3;
      
      public static const LB_ACC:int = 4;
      
      public static const FILTER_TOP_RANK:int = 0;
      
      public static const FILTER_FRIEND:int = 1;
      
      public static const FILTER_CLAN:int = 2;
      
      public static const LB_TABLES:Array = ["100_LB_MP_ALL_WIN","101_LB_MP_ALL_WR","102_LB_MP_ALL_KILL","103_LB_MP_ALL_KDR","104_LB_MP_ALL_ACCURACY"];
      
      public function LeaderboardController()
      {
         super();
      }
      
      override protected function onInitialized() : void
      {
         this.listen(BCEvent.EVT_FSG_REFRESH_LEADERBOARD,this.onFsgRefreshLeaderBoard);
         this.listen(BCEvent.EVT_CLOSE_LEADERBOARD,this.onCloseLeaderboardHandle);
         this.listen(BCEvent.EVT_REFRESH_LEADERBOARD,this.onRefreshLeaderboardHandle);
         this.listen(BCEvent.LEADERBOARD_FILTER0_CHANGED,this.onFilter0ChangedHandle);
         this.listen(BCEvent.LEADERBOARD_FILTER1_CHANGED,this.onFilter1ChangedHandle);
         this.listen(BCEvent.LEADERBOARD_FILTER2_CHANGED,this.onFilter2ChangedHandle);
         this.listen(BCEvent.LEADERBOARD_PARAMETER0_CHANGED,this.onParam0ChangedHandle);
         this.listen(BCEvent.EVT_REQUEST_LEADERBOARD,this.onRequestLeaderBoard);
         this.addDP(DataID.ENABLE_MP_LEADERBOARD,this.enableMpLeaderboard);
         this.addDP(DataID.LEADERBOARD_LIST,this.getLeaderBoardList);
         this.addDP(DataID.LEADERBOARD_NOTICE,this.getLeaderboardNotice);
      }
      
      private function onFsgRefreshLeaderBoard(cEvt:ParaEvent) : void
      {
         var leaderboard:String = cEvt.myPara["leaderboard"];
         var leaderboardName:String = LB_TABLES[leaderboard];
         var filter:int = int(cEvt.myPara["filter"]);
         if(filter == LeaderboardController.FILTER_CLAN && !this.getDP(DataID.IS_IN_CLAN))
         {
            this.setBindData(DataID.LIST_LEADERBOARD,[[]]);
            return;
         }
         LeaderboardService.getInstance().fsgUpdateLeaderboard(leaderboardName,filter,false);
      }
      
      private function onCloseLeaderboardHandle(cEvt:ParaEvent) : void
      {
         this.prevPage();
      }
      
      private function onRefreshLeaderboardHandle(cEvt:ParaEvent) : void
      {
         LeaderboardService.getInstance().resetAll();
         LeaderboardService.getInstance().updateLeaderboard(true);
      }
      
      private function onFilter0ChangedHandle(cEvt:ParaEvent) : void
      {
         LeaderboardService.getInstance().changeFilter0(cEvt.myPara);
      }
      
      private function onFilter1ChangedHandle(cEvt:ParaEvent) : void
      {
         LeaderboardService.getInstance().changeFilter1(cEvt.myPara);
      }
      
      private function onFilter2ChangedHandle(cEvt:ParaEvent) : void
      {
         LeaderboardService.getInstance().changeFilter2(cEvt.myPara);
      }
      
      private function onParam0ChangedHandle(cEvt:ParaEvent) : void
      {
         LeaderboardService.getInstance().changeParam(cEvt.myPara);
      }
      
      private function enableMpLeaderboard() : Boolean
      {
         return this.getDvarBool("ui_enable_mp_leaderboard");
      }
      
      public function cppRefreshLeaderboard(leaderboardData:*) : void
      {
         setBindData(DataID.LEADERBOARD_DATA_RESPONDED,leaderboardData);
      }
      
      private function getLeaderBoardList() : Object
      {
         return CFunctionContainer.GetLeaderboardDefs();
      }
      
      private function onRequestLeaderBoard(cEvt:ParaEvent) : void
      {
         CFunctionContainer.ListLeaderboard(cEvt.myPara);
      }
      
      private function getLeaderboardNotice() : Object
      {
         return this.getDvarString("leaderboard_notice");
      }
   }
}

