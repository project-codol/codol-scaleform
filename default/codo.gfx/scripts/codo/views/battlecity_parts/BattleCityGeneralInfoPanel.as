package codo.views.battlecity_parts
{
   import codo.common.CFunctionContainer;
   import codo.component.matchselect.RandomRewardSkinedTextButton;
   import codo.component.matchselect.RandomRewardSlideshow;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.constants.MsgBtnCount;
   import codo.constants.WebImgData;
   import codo.localization.Dict;
   import codo.localization.DictBattleCity;
   import codo.objects.AccountObj;
   import codo.objects.BattleCityLeagueGlobalObj;
   import codo.objects.GamemodeTutorialContentObj;
   import codo.objects.ModeObj;
   import codo.objects.PlayListObj;
   import codo.objects.ProductObj;
   import codo.services.MatchService;
   import codo.services.TutorialService;
   import codo.utils.ItemUtil;
   import codo.utils.MathUtil;
   
   public class BattleCityGeneralInfoPanel extends BattleCityBaseSubPanel
   {
      
      private static const MAX_REWARD_SLIDE:int = 6;
      
      public var myModeInfo:BattleCityModeInfo;
      
      public var myModeInfoLeagueAddon:BattleCityModeInfoLeagueAddon;
      
      public var myRandomRewardSlideshow:RandomRewardSlideshow;
      
      public var myRandomRewardButton:RandomRewardSkinedTextButton;
      
      private var mLeagueADImages:Vector.<GamemodeTutorialContentObj>;
      
      private var mIsLeagueRewardButton:Boolean = false;
      
      public function BattleCityGeneralInfoPanel()
      {
         super();
         this.initStage();
      }
      
      private function initStage() : void
      {
         this.myRandomRewardButton.isInteractiveEnabled = true;
         this.myRandomRewardButton.registerClickEvent(this.onClickRewardButton);
         this.mLeagueADImages = new Vector.<GamemodeTutorialContentObj>();
      }
      
      override public function active() : void
      {
         super.active();
         bind(DataID.WEB_IMG_STATUS,this.bindWebImgStatus);
         bind(DataID.MY_ACCOUNT,this.bindAccountInfo);
         bind(DataID.BATTLE_CITY_LEAGUE_LEADERBOARD_TOP100,this.bindBattleCityLeaguePlayerRank);
         broadcast(BCEvent.EVT_FETCH_BATTLECITY_LEAGUE_LEADERBOARD);
      }
      
      override public function deactive() : void
      {
         super.deactive();
         unbind(DataID.WEB_IMG_STATUS,this.bindWebImgStatus);
         unbind(DataID.MY_ACCOUNT,this.bindAccountInfo);
         unbind(DataID.BATTLE_CITY_LEAGUE_PLAYER_RANK,this.bindBattleCityLeaguePlayerRank);
      }
      
      override public function onPlaylistSelect(playlistObj:PlayListObj) : void
      {
         super.onPlaylistSelect(playlistObj);
         this.myModeInfo.setModeName(playlistObj.modes[0].name);
         this.myModeInfo.setGameName(playlistObj.name);
         this.myModeInfo.setModeDescription(playlistObj.description);
         this.myModeInfo.setPlayerLimit(this.playerRangeString(playlistObj.minRoomSize,playlistObj.maxRoomSize));
         this.myModeInfo.setOpenLevel(playlistObj);
         this.myModeInfo.setNumMaps(playlistObj);
         if(playlistObj.isBattleCityLeague())
         {
            if(this.mLeagueADImages.length > 0)
            {
               this.myModeInfo.setMaps([],this.mLeagueADImages);
            }
            else
            {
               this.myModeInfo.setMaps(playlistObj.maps,this.getTutorialVideos(playlistObj));
            }
            this.myModeInfoLeagueAddon.loadPlayerInfo();
            this.myModeInfoLeagueAddon.title = playlistObj.name;
            this.myModeInfoLeagueAddon.description = playlistObj.description;
            this.myModeInfoLeagueAddon.visible = true;
            this.myModeInfo.myModeName.visible = false;
            this.myModeInfo.myGameName.visible = false;
            this.myModeInfo.myModeDescription.visible = false;
         }
         else
         {
            this.myModeInfo.setMaps(playlistObj.maps,this.getTutorialVideos(playlistObj));
            this.myModeInfo.myModeName.visible = true;
            this.myModeInfo.myGameName.visible = true;
            this.myModeInfo.myModeDescription.visible = true;
            this.myModeInfoLeagueAddon.visible = false;
         }
         var numXPRate:Number = MathUtil.roundDecimal(playlistObj.xpScale * 100,2);
         var numGPRate:Number = MathUtil.roundDecimal(playlistObj.gpScale * 100,2);
         var xpgpBonusInfoObj:Object = CFunctionContainer.AS_GetXPGPScalerForPlaylist(playlistObj.index);
         var xpScale:Number = Math.round(xpgpBonusInfoObj.xpScale * 10) / 10;
         var gpScale:Number = Math.round(xpgpBonusInfoObj.gpScale * 10) / 10;
         var firstWinXPScale:Number = Math.round(xpgpBonusInfoObj.firstWinXpScale * 10) / 10;
         var firstWinGPScale:Number = Math.round(xpgpBonusInfoObj.firstWinGpScale * 10) / 10;
         var partyFirstWinXPScale:Number = Math.round(xpgpBonusInfoObj.partyFirstWinXpScale * 10) / 10;
         var partyFirstWinGPScale:Number = Math.round(xpgpBonusInfoObj.partyFirstWinGpScale * 10) / 10;
         this.myModeInfo.setXPandGPRate(numXPRate,numGPRate,xpScale,gpScale,firstWinXPScale,firstWinGPScale,partyFirstWinXPScale,partyFirstWinGPScale);
         this.myModeInfo.setOnboardBonus(playlistObj);
         this.setRandomRewards(this.gatherADRandomRewards(playlistObj.isBattleCityLeague()));
         this.setRandomRewardButtonOpenPopup(playlistObj.isBattleCityLeague());
         this.setLeagueOpenState();
      }
      
      private function playerRangeString(minPlayers:int, maxPlayers:int) : String
      {
         return minPlayers + " ~ " + maxPlayers;
      }
      
      private function getOpenLevel(cDat:PlayListObj) : String
      {
         var openLevels:Array = cDat.unlockedLevels;
         var openLevelStr:String = "";
         for(var i:int = 0; i < openLevels.length; i++)
         {
            if(openLevels[i].end == 70)
            {
               openLevelStr += openLevels[i].start + " + ";
            }
            else
            {
               openLevelStr += openLevels[i].start + " - " + openLevels[i].end;
            }
         }
         return openLevelStr;
      }
      
      private function getTutorialVideos(playlist:PlayListObj) : Vector.<GamemodeTutorialContentObj>
      {
         var mode:ModeObj = null;
         var modeStr:String = null;
         var contents:Vector.<GamemodeTutorialContentObj> = null;
         var supportedModes:Array = playlist.modes;
         var len:int = int(supportedModes.length);
         for(var i:int = 0; i < len; i++)
         {
            mode = supportedModes[i];
            modeStr = mode.id;
            if(MatchService.getInstance().getPlayListHasRule(playlist,"dmz_circle_reversed 1"))
            {
               modeStr = "rdmz";
            }
            contents = TutorialService.getInstance().getContentByGameType(modeStr);
            if(contents.length > 0)
            {
               return contents;
            }
         }
         return null;
      }
      
      private function getLeagueTutorialVideos(images:Array) : Vector.<GamemodeTutorialContentObj>
      {
         var tutorialContent:GamemodeTutorialContentObj = null;
         for(var i:int = 0; i < images.length; i++)
         {
            tutorialContent = new GamemodeTutorialContentObj();
            tutorialContent.contentSubTitle = DictBattleCity.BATTLECITY_LEAGUE_AD_DESC_HEADER + String(i);
            tutorialContent.imagePath = images[i];
            tutorialContent.videoPath = "";
            this.mLeagueADImages.push(tutorialContent);
         }
         return this.mLeagueADImages;
      }
      
      private function bindWebImgStatus(result:Object) : void
      {
         var adObj:Array = null;
         var j:int = 0;
         var images:Array = [];
         var imgCheckerData:Array = result.data;
         for(var i:uint = 0; i < imgCheckerData.length; i++)
         {
            adObj = imgCheckerData[i];
            for(j = 0; j < adObj.length; j++)
            {
               if(adObj[j].imgData.id == WebImgData.BATTLECITY_LEAGUE_AD.id)
               {
                  images.push(WebImgData.getWebImgURL(adObj[j].imgData.id,j));
               }
            }
         }
         if(images.length > 0)
         {
            this.myModeInfo.setMaps([],this.getLeagueTutorialVideos(images));
         }
      }
      
      private function bindAccountInfo(cResult:Object) : void
      {
         var leagueGlobalObj:BattleCityLeagueGlobalObj = getDP(DataID.BATTLE_CITY_LEAGUE_GLOBAL_OBJ);
         var accountObj:AccountObj = new AccountObj(cResult.data);
         this.myModeInfoLeagueAddon.setTicketCount(accountObj.dmzlFreeTicket,leagueGlobalObj.freeTicketHoldLimit,accountObj.dmzlBattleTicket,leagueGlobalObj.battleTicketHoldLimit);
      }
      
      private function bindBattleCityLeaguePlayerRank(cResult:Object) : void
      {
         var leaderBoardData:Object = cResult.data;
         var selfStats:Object = leaderBoardData.selfStats;
         this.myModeInfoLeagueAddon.setRank(selfStats.rank);
      }
      
      private function setLeagueOpenState() : void
      {
         var leagueGlobalObj:BattleCityLeagueGlobalObj = getDP(DataID.BATTLE_CITY_LEAGUE_GLOBAL_OBJ);
         this.myModeInfoLeagueAddon.rule = leagueGlobalObj.enabled ? DictBattleCity.BATTLECITY_TICKET_RULE : "@" + leagueGlobalObj.disableReason;
      }
      
      private function setRandomRewards(items:Array) : void
      {
         var paginationItems:Vector.<ProductObj> = new Vector.<ProductObj>();
         var len:int = int(items.length);
         var i:int = 0;
         while(i < MAX_REWARD_SLIDE && i < len)
         {
            paginationItems.push(items[i]);
            i++;
         }
         this.myRandomRewardSlideshow.setData(paginationItems);
      }
      
      private function setRandomRewardButtonOpenPopup(isLeague:Boolean) : void
      {
         this.mIsLeagueRewardButton = isLeague;
      }
      
      private function gatherADRandomRewards(isLeague:Boolean = false) : Array
      {
         var products:Array = [];
         var adProds:Array = CFunctionContainer.AS_GetBattleCityADProductsID(isLeague);
         var i:int = 0;
         while(Boolean(adProds) && i < adProds.length)
         {
            products.push(ItemUtil.getProductObjByProductId(adProds[i]));
            i++;
         }
         return products;
      }
      
      private function onClickRewardButton() : void
      {
         if(Boolean(getDP(DataID.IS_MARKETPLACE_READY)) && !getDP(DataID.IS_MARKETPLACE_MAINTAIN))
         {
            if(this.mIsLeagueRewardButton)
            {
               broadcast(BCEvent.EVT_SHOW_BATTLECITY_LEAGUE_REWARD);
            }
            else
            {
               broadcast(BCEvent.EVT_SHOW_MAP_REWARDS,{"index":0});
            }
         }
         else
         {
            showMsg(Dict.DW_MARKETPLACE_MAINTAIN,MsgBtnCount.ONE);
         }
      }
   }
}

