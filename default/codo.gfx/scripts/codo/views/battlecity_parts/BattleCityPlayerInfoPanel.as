package codo.views.battlecity_parts
{
   import codo.common.CFunctionContainer;
   import codo.component.FilterToggleButton2;
   import codo.constants.DataID;
   import codo.localization.DictBattleCity;
   import codo.utils.StringUtil;
   import flash.text.TextField;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   
   public class BattleCityPlayerInfoPanel extends BattleCityBaseSubPanel
   {
      
      private static const INVALID_DATA:String = "--";
      
      private static const TOGGLE_INIT_X:int = 22;
      
      private static const TOGGLE_INIT_Y:int = 28;
      
      private static const TOGGLE_GAP:int = 10;
      
      public var myToggleBtn:FilterToggleButton2;
      
      public var myWinLabel:TextField;
      
      public var myWinTF:TextField;
      
      public var myTotalPlayedLabel:TextField;
      
      public var myTotalPlayedTF:TextField;
      
      public var myAvgGearRatingLabel:TextField;
      
      public var myAvgGearRatingTF:TextField;
      
      public var myKillLabel:TextField;
      
      public var myKillTF:TextField;
      
      public var myAvgLabel:TextField;
      
      public var myAvgTF:TextField;
      
      public var myHeadShotLabel:TextField;
      
      public var myHeadShotTF:TextField;
      
      public var myMostKillLabel:TextField;
      
      public var myMostKillTF:TextField;
      
      public var myReviveLabel:TextField;
      
      public var myReviveTF:TextField;
      
      public var myTotalPlayTimeLabel:TextField;
      
      public var myTotalPlayTimeTF:TextField;
      
      public var myAvgSurvivalLabel:TextField;
      
      public var myAvgSurvivalTF:TextField;
      
      private var mToggles:Vector.<FilterToggleButton2> = new Vector.<FilterToggleButton2>();
      
      private var mPlaylistIDs:Vector.<int> = new Vector.<int>();
      
      private var mToggleInited:Boolean = false;
      
      private var mCurrentSelectedIndex:int = -1;
      
      private var mSupportedPlaylist:Array;
      
      public function BattleCityPlayerInfoPanel()
      {
         var className:String = null;
         var classDef:Class = null;
         var newInstance:FilterToggleButton2 = null;
         super();
         this.setLocalization();
         this.mSupportedPlaylist = CFunctionContainer.AS_GetPlayerStatePlaylistConfig();
         this.mToggles.push(this.myToggleBtn);
         for(var i:int = 1; i < this.mSupportedPlaylist.length; i++)
         {
            className = getQualifiedClassName(this.myToggleBtn);
            classDef = getDefinitionByName(className) as Class;
            newInstance = new classDef() as FilterToggleButton2;
            addChild(newInstance);
            newInstance.x = this.myToggleBtn.x;
            newInstance.y = this.myToggleBtn.y;
            this.mToggles.push(newInstance);
         }
      }
      
      public function setLocalization() : void
      {
         this.myWinLabel.text = DictBattleCity.BATTLECITY_PLAYER_STATE_WINS;
         this.myTotalPlayedLabel.text = DictBattleCity.BATTLECITY_PLAYER_STATE_TOTAL_MATCHES;
         this.myAvgGearRatingLabel.text = DictBattleCity.BATTLECITY_PLAYER_STATE_AVG_GEAR_RATING;
         this.myKillLabel.text = DictBattleCity.BATTLECITY_PLAYER_STATE_TOTAL_KILL;
         this.myAvgLabel.text = DictBattleCity.BATTLECITY_PLAYER_STATE_AVG_PLACE;
         this.myHeadShotLabel.text = DictBattleCity.BATTLECITY_PLAYER_STATE_HEADSHOTS;
         this.myMostKillLabel.text = DictBattleCity.BATTLECITY_PLAYER_STATE_MOST_KILLED;
         this.myReviveLabel.text = DictBattleCity.BATTLECITY_PLAYER_STATE_REVIVES;
         this.myTotalPlayTimeLabel.text = DictBattleCity.BATTLECITY_PLAYER_STATE_TOTAL_TIME_PLAYED;
         this.myAvgSurvivalLabel.text = DictBattleCity.BATTLECITY_PLAYER_STATE_AVG_SURVIVAL_TIME;
      }
      
      override public function active() : void
      {
         var battleCityPlayList:Array = null;
         var i:int = 0;
         var playlist:Object = null;
         super.active();
         if(!this.mToggleInited)
         {
            battleCityPlayList = getDP(DataID.LIST_PLAY_LIST_BATTLECITY,[false]);
            for(i = battleCityPlayList.length - 1; i >= 0; i--)
            {
               playlist = battleCityPlayList[i];
               if(this.mSupportedPlaylist.indexOf(playlist.index) == -1)
               {
                  battleCityPlayList.splice(i,1);
               }
            }
            this.setToggleButton(battleCityPlayList);
            this.mToggleInited = true;
         }
      }
      
      private function setToggleButton(playlist:Array) : void
      {
         var toggleX:Number = NaN;
         var i:int = 0;
         toggleX = TOGGLE_INIT_X;
         for(i = 0; i < this.mToggles.length; i++)
         {
            this.mToggles[i].visible = false;
            if(i < playlist.length)
            {
               this.mToggles[i].label = playlist[i].name;
               this.mToggles[i].registerClickEvent(this.onSetTab,i);
               this.mToggles[i].visible = true;
               this.mToggles[i].x = toggleX;
               this.mToggles[i].y = TOGGLE_INIT_Y;
               toggleX += TOGGLE_GAP + this.mToggles[i].width;
               this.mPlaylistIDs.push(playlist[i].index);
            }
         }
         this.onSetTab(0);
      }
      
      private function onSetTab(index:int) : void
      {
         var i:int = 0;
         if(this.mCurrentSelectedIndex != index)
         {
            for(i = 0; i < this.mToggles.length; i++)
            {
               this.mToggles[i].setBar(index == i);
            }
            this.switchSubPanel(index);
            this.mCurrentSelectedIndex = index;
         }
      }
      
      private function switchSubPanel(playlistIndex:int) : void
      {
         var playlistID:int = this.mPlaylistIDs[playlistIndex];
         var playerState:Object = CFunctionContainer.AS_GetPlayerBattleCityStateByPlaylistID(playlistID);
         this.setData(playerState);
      }
      
      private function setData(playerState:Object) : void
      {
         if(Boolean(playerState.numMatches))
         {
            this.myWinTF.text = playerState.wins;
            this.myTotalPlayedTF.text = playerState.numMatches;
            this.myAvgGearRatingTF.text = String(int(playerState.gearTotal / playerState.numMatches));
            this.myKillTF.text = playerState.kills;
            this.myAvgTF.text = String(int(playerState.placeTotal / playerState.numMatches));
            this.myHeadShotTF.text = playerState.headshots;
            this.myMostKillTF.text = playerState.killsMax;
            this.myReviveTF.text = playerState.revives;
            this.myTotalPlayTimeTF.text = StringUtil.formatSecondsHHMMSS(playerState.timePlayedTotal);
            this.myAvgSurvivalTF.text = StringUtil.formatSeconds(int(playerState.timeSurvivalTotal / playerState.numMatches));
         }
         else
         {
            this.myWinTF.text = this.myTotalPlayedTF.text = this.myAvgGearRatingTF.text = INVALID_DATA;
            this.myKillTF.text = this.myAvgTF.text = this.myHeadShotTF.text = this.myMostKillTF.text = this.myReviveTF.text = INVALID_DATA;
            this.myTotalPlayTimeTF.text = this.myAvgSurvivalTF.text = INVALID_DATA;
         }
         this.myReviveLabel.visible = this.myReviveTF.visible = playerState.revives != -1;
      }
   }
}

