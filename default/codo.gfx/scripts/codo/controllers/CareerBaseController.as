package codo.controllers
{
   import codo.base.BaseController;
   import codo.common.CFunctionCommonContainer;
   import codo.constants.BCEvent;
   import codo.constants.DataCommonID;
   import codo.constants.DataID;
   import codo.event.ParaEvent;
   import codo.objects.PlayerLevelObj;
   import codo.objects.PlayerObj;
   import codo.utils.StringUtil;
   
   public class CareerBaseController extends BaseController
   {
      
      protected var _currentLevelInfo:PlayerLevelObj = null;
      
      public function CareerBaseController()
      {
         super();
      }
      
      override protected function onInitialized() : void
      {
         this.addDP(DataCommonID.CAREER_CURRENT_LEVEL_INFO,this.getLevelInfo);
         this.addDP(DataID.PLAYER_NAME_WITH_CLANTAG,this.getPlayerNameWithTag);
         this.listen(BCEvent.EVT_ON_CLAN_JOINED,this.onUpdatClanInfo);
         this.listen(BCEvent.EVT_ON_CLAN_LEFT,this.onUpdatClanInfo);
         this.listen(BCEvent.EVT_ON_CLAN_NAME_CHANGED,this.onUpdatClanInfo);
      }
      
      protected function getLevelInfo() : PlayerLevelObj
      {
         var playerObj:PlayerObj = null;
         var currentLevel:uint = 0;
         var nextLevel:uint = 0;
         var xpNextLevel:int = 0;
         if(this._currentLevelInfo == null)
         {
            playerObj = PlayerObj.getObj();
            currentLevel = CFunctionCommonContainer.GetPlayerLevel();
            nextLevel = CFunctionCommonContainer.GetPlayerNextLevel();
            xpNextLevel = CFunctionCommonContainer.GetXpForNextLevel();
            this._currentLevelInfo = new PlayerLevelObj();
            this._currentLevelInfo.currentLevel = currentLevel;
            this._currentLevelInfo.currentLevelName = PlayerObj.getRankName(currentLevel);
            this._currentLevelInfo.currentLevelDisplay = uint(CFunctionCommonContainer.GetDisplayLevel(currentLevel));
            this._currentLevelInfo.nextLevel = nextLevel;
            this._currentLevelInfo.nextLevelName = PlayerObj.getRankName(nextLevel);
            this._currentLevelInfo.nextLevelDisplay = uint(CFunctionCommonContainer.GetDisplayLevel(nextLevel));
            this._currentLevelInfo.currentExp = playerObj.careerData.xpEarned;
            this._currentLevelInfo.totalExp = xpNextLevel - this._currentLevelInfo.currentExp;
            this._currentLevelInfo.totalEarnedXP = CFunctionCommonContainer.GetPlayerXP();
            this._currentLevelInfo.changeExp = 0;
         }
         return this._currentLevelInfo;
      }
      
      private function getPlayerNameWithTag() : String
      {
         var playerObj:PlayerObj = PlayerObj.getObj();
         return StringUtil.addTag(playerObj.clanTag,this.getDP(DataID.PLAYER_USER_NAME));
      }
      
      private function onUpdatClanInfo(cEvt:ParaEvent) : void
      {
         PlayerObj.updatePlayerClanInfo(true);
      }
   }
}

