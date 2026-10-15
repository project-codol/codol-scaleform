package codo.services
{
   import codo.base.ServiceBase;
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionInGameContainer;
   import codo.constants.DataCommonID;
   import codo.constants.DataInGameID;
   import codo.constants.ServiceID;
   import codo.objects.MatchStatusObj;
   import codo.objects.ResultObj;
   import codo.tasks.MatchStatusTask;
   import codo.utils.ScaleformUtil;
   
   public class InGameService extends ServiceBase
   {
      
      private static var _instance:InGameService;
      
      public function InGameService()
      {
         super(ServiceID.IN_GAME);
      }
      
      public static function getInstance() : InGameService
      {
         if(_instance == null)
         {
            _instance = new InGameService();
         }
         return _instance;
      }
      
      override public function init() : void
      {
         this.addDP(DataInGameID.IS_COOP,this.isHeroOpsOrSurvival);
         this.addDP(DataInGameID.IS_ZM,this.isZM);
         this.addDP(DataInGameID.IS_INFECT,this.isInfect);
         this.addDP(DataInGameID.IS_DMZ,this.isDMZ);
         this.addDP(DataInGameID.IS_SPY,this.isSpy);
         this.addDP(DataInGameID.IS_PH,this.isPh);
         this.addDP(DataInGameID.IS_TDMZ,this.isTDMZ);
         this.addDP(DataInGameID.IS_ZHUNT,this.isZHunt);
         this.addDP(DataInGameID.IS_VIP,this.isVIP);
         this.addDP(DataInGameID.GAME_TYPE,this.getGameType);
         this.addDP(DataCommonID.BIG_LOUD_SPEAKER_SHOW_DURATION,this.getBigLoudSpeakerShowDuration);
         this.addDP(DataCommonID.SMALL_LOUD_SPEAKER_SHOW_DURATION,this.getSmallLoudSpeakerShowDuration);
         this.register(DataCommonID.MATCH_STATUS,this.startMatchStatus);
      }
      
      private function isZM() : Boolean
      {
         return this.getGameType() == "zm";
      }
      
      public function isHeroOpsOrSurvival() : Boolean
      {
         return this.getGameType() == "coop";
      }
      
      public function isDMZ() : Boolean
      {
         return this.getGameType() == "dmz";
      }
      
      public function isSpy() : Boolean
      {
         return this.getGameType() == "spy";
      }
      
      public function isPh() : Boolean
      {
         return this.getGameType() == "ph";
      }
      
      public function isTDMZ() : Boolean
      {
         return this.getGameType() == "tdmz";
      }
      
      public function isZHunt() : Boolean
      {
         return this.getGameType() == "zhunt";
      }
      
      public function isVIP() : Boolean
      {
         return this.getGameType() == "vip";
      }
      
      public function isHeroOps() : Boolean
      {
         return this.isHeroOpsOrSurvival() && !this.curMapIsSurvival();
      }
      
      public function isSurvival() : Boolean
      {
         return this.isHeroOpsOrSurvival() && this.curMapIsSurvival();
      }
      
      private function isInfect() : Boolean
      {
         return this.getGameType() == "infect";
      }
      
      public function getGameType() : String
      {
         return ScaleformUtil.isScaleform ? CFunctionCommonContainer.Dvar_GetString("ui_gametype") : "war";
      }
      
      public function curMapIsSurvival() : Boolean
      {
         return CFunctionCommonContainer.Dvar_GetString("ui_mapname").indexOf("coop_survival_") == 0;
      }
      
      public function curMapIsFiringrangetTrain() : Boolean
      {
         return CFunctionCommonContainer.Dvar_GetString("ui_mapname") == "coop_train_mp_firingrange";
      }
      
      private function getBigLoudSpeakerShowDuration() : int
      {
         return getDvarInt("dw_bigLoudSpeakerShowDuration");
      }
      
      private function getSmallLoudSpeakerShowDuration() : int
      {
         return getDvarInt("dw_smallLoudSpeakerShowDuration");
      }
      
      override public function update(deltaTime:Number) : void
      {
         this.checkMatchStatus();
      }
      
      private function startMatchStatus() : void
      {
         this.createTask(DataCommonID.MATCH_STATUS);
      }
      
      private function checkMatchStatus() : void
      {
         var task:MatchStatusTask = this.getTask(DataCommonID.MATCH_STATUS) as MatchStatusTask;
         if(task == null)
         {
            return;
         }
         var result:ResultObj = new ResultObj();
         result.id = DataCommonID.MATCH_STATUS;
         result.result = 1;
         result.data = new MatchStatusObj(CFunctionInGameContainer.GetMatchStatus());
         this.setData(result);
      }
   }
}

