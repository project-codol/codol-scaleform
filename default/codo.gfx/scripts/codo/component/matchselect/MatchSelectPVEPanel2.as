package codo.component.matchselect
{
   import codo.base.BaseView;
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.component.CustomList;
   import codo.component.LockButton;
   import codo.component.TextField;
   import codo.component.TokenButton;
   import codo.component.core.UIInteractiveComponent;
   import codo.constants.BCEvent;
   import codo.constants.ButtonTLog;
   import codo.constants.DataID;
   import codo.constants.GlobalBottomBtnStatus;
   import codo.constants.MsgBtnCount;
   import codo.constants.PlayListType;
   import codo.constants.QuickMatchType;
   import codo.constants.WebImgData;
   import codo.cpp.UiCppMatchSelectView;
   import codo.cpp.UiCppView;
   import codo.cpp.UiCppViewPanel;
   import codo.localization.Dict;
   import codo.localization.DictRoom;
   import codo.manager.DataManager;
   import codo.manager.EventManager;
   import codo.objects.FeaturedAdObj;
   import codo.objects.MapObj;
   import codo.objects.MatchSelectDifficultyObj;
   import codo.objects.MatchSelectModeObj;
   import codo.objects.PlayListObj;
   import codo.objects.ProductObj;
   import codo.objects.RewardItemList;
   import codo.objects.WebAdObj;
   import codo.services.MatchService;
   import codo.style.GlobalGuide;
   import codo.style.MatchSelectGuide;
   import codo.utils.MathUtil;
   import codo.utils.ScaleformUtil;
   import codo.utils.TLogUtil;
   import com.society.comscore.DAXDispatcher;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import flash.utils.getDefinitionByName;
   
   public class MatchSelectPVEPanel2 extends MatchSelectPanelBase2
   {
      
      private static const DIFFICULTY_MOUNT_AREA:Number = 341;
      
      public var difficultyList:CustomList;
      
      public var myDifficultyBg:MovieClip;
      
      public var myDifficultyMount:MovieClip;
      
      public var myDifficultyHeader:TextField;
      
      public var myAdSlideShow:MatchSelectAdSlideShow;
      
      public var myRandomRewardSlideshow:RandomRewardSlideshow;
      
      public var myRandomRewardButton:RandomRewardTextButton;
      
      public var myTokenButton:TokenButton;
      
      private var mDifficultyButtons:Vector.<LockButton>;
      
      private var mStartStatus:int;
      
      private var mPreviewBeingFocused:Boolean = false;
      
      private var mPlaylistType:uint;
      
      private var mPlaylistTypeADConfig:Dictionary;
      
      private var mADImages:Dictionary = new Dictionary();
      
      public function MatchSelectPVEPanel2()
      {
         super();
         this.difficultyList = new CustomList(this.makeDifficultyButtons);
         this.mPlaylistTypeADConfig = new Dictionary();
         this.mPlaylistTypeADConfig[PlayListType.ZHUNTER] = {
            "id":WebImgData.ZHCRAFTING_AD.id,
            "event":BCEvent.EVT_WEBPAGE_OPEN_ZHCRAFTING
         };
         this.mPlaylistTypeADConfig[PlayListType.TD] = {
            "id":WebImgData.TDCRAFTING_AD.id,
            "event":BCEvent.EVT_WEBPAGE_OPEN_TDCRAFTING
         };
      }
      
      override protected function initStage() : void
      {
         super.initStage();
         myGameTypeHeader.text = Dict.MATCH_SELECT_MENU_OPTION_PVE;
         this.myDifficultyHeader.textStyle = MatchSelectGuide.styleDifficultyHeader;
         this.myDifficultyHeader.width = 300;
         this.myDifficultyHeader.height = 25;
         this.myDifficultyHeader.x = 527;
         this.myDifficultyHeader.y = 266;
         this.myDifficultyHeader.text = Dict.SELECT_DIFFICULTY;
         this.myDifficultyMount.x = 527;
         this.myDifficultyMount.y = 299;
         this.myRandomRewardSlideshow.registerFocusEvent(this.onRandomRewardFocused);
         this.myRandomRewardSlideshow.registerUnfocusEvent(this.onRandomRewardUnfocused);
         this.myRandomRewardSlideshow.myPaginationList.addEventListener(Event.CHANGE,this.onRewardPageChanged);
         this.myRandomRewardButton.isInteractiveEnabled = true;
         this.myRandomRewardButton.registerClickEvent(this.onClickMapRewards);
         this.myTokenButton.setImage("zom_token_gold_icon.tga");
         this.myTokenButton.registerClickEvent(this.onTokensClick);
         this.myTokenButton.width = 164;
         this.myTokenButton.height = 60;
         this.myTokenButton.myLabel.fontSize = 28;
         this.myTokenButton.myIcon.width = 45;
         this.myTokenButton.myIcon.height = 45;
      }
      
      override protected function enableData() : void
      {
         super.enableData();
         EventManager.getInstance().listen(BCEvent.EVT_REFRESH_UI_AFTER_INVENTORY_CHANGE,this.showTokens);
         this.myAdSlideShow.myAdMount.addEventListener(MouseEvent.CLICK,this.onADSlideClicked);
         DataManager.getInstance().addDP(DataID.MATCH_MPCT_PLAYLIST_SELECTED_DATA,this.getSelectedPlaylist);
         DataManager.getInstance().addDP(DataID.QUICK_MATCH_COOP_DATA,this.getQuickMatchCoopData);
         DataManager.getInstance().bind(DataID.WEB_IMG_STATUS,this.bindWebImgStatus);
         this.showTokens();
      }
      
      override protected function disableData() : void
      {
         super.disableData();
         EventManager.getInstance().unlisten(BCEvent.EVT_REFRESH_UI_AFTER_INVENTORY_CHANGE,this.showTokens);
         this.myAdSlideShow.myAdMount.removeEventListener(MouseEvent.CLICK,this.onADSlideClicked);
         DataManager.getInstance().removeDP(DataID.MATCH_MPCT_PLAYLIST_SELECTED_DATA,this.getSelectedPlaylist);
         DataManager.getInstance().removeDP(DataID.QUICK_MATCH_COOP_DATA,this.getQuickMatchCoopData);
         DataManager.getInstance().unbind(DataID.WEB_IMG_STATUS,this.bindWebImgStatus);
      }
      
      private function onRandomRewardFocused() : void
      {
         EventManager.getInstance().broadcast(BCEvent.EVT_SHOW_ITEM_INFO_PREVIEW,{
            "product":this.myRandomRewardSlideshow.currentItem,
            "compare":false
         });
         this.mPreviewBeingFocused = true;
      }
      
      private function onRandomRewardUnfocused() : void
      {
         EventManager.getInstance().broadcast(BCEvent.EVT_HIDE_ITEM_INFO_PREVIEW);
         this.mPreviewBeingFocused = false;
      }
      
      private function onRewardPageChanged() : void
      {
         if(this.mPreviewBeingFocused)
         {
            EventManager.getInstance().broadcast(BCEvent.EVT_SHOW_ITEM_INFO_PREVIEW,{
               "product":this.myRandomRewardSlideshow.currentItem,
               "compare":false
            });
         }
      }
      
      private function onClickMapRewards() : void
      {
         EventManager.getInstance().broadcast(BCEvent.EVT_SHOW_MAP_REWARDS,{"index":0});
      }
      
      private function setRandomRewards(items:Array) : void
      {
         var paginationItems:Vector.<ProductObj> = new Vector.<ProductObj>();
         var len:int = int(items.length);
         var i:int = 0;
         while(i < 6 && i < len)
         {
            paginationItems.push(items[i]);
            i++;
         }
         paginationItems.sort(this.sortByTier);
         this.myRandomRewardSlideshow.setData(paginationItems);
      }
      
      private function sortByTier(a:Object, b:Object) : int
      {
         var prodA:ProductObj = a as ProductObj;
         var prodB:ProductObj = b as ProductObj;
         return prodB.tier - prodA.tier;
      }
      
      private function showTokens() : void
      {
         var tokenAmount:uint = ScaleformUtil.isScaleform ? uint(CFunctionCommonContainer.GetCyborgTokenCount()) : 21;
         this.myTokenButton.updateCount(tokenAmount);
      }
      
      public function getSelectedPlaylist() : PlayListObj
      {
         return myMiddleList.selectedData as PlayListObj;
      }
      
      private function getQuickMatchCoopData() : Object
      {
         var mapData:MapObj = this.getSelectedHeroOpsMap();
         return {
            "map":mapData,
            "leagueIndex":DataManager.getInstance().getDP(DataID.LIST_LEAGUE)[0]
         };
      }
      
      public function getSelectedHeroOpsMap() : MapObj
      {
         return myMiddleList.selectedData as MapObj;
      }
      
      public function onDifficultySelect() : void
      {
      }
      
      private function bindWebImgStatus(cResult:Object) : void
      {
         var key:Object = null;
         var imgData:Array = null;
         var i:uint = 0;
         var adObj:Array = null;
         var j:uint = 0;
         var playlistType:uint = 0;
         this.mADImages = new Dictionary();
         var imgIDToPlaylistType:Dictionary = new Dictionary();
         for(key in this.mPlaylistTypeADConfig)
         {
            this.mADImages[key] = new Array();
            imgIDToPlaylistType[this.mPlaylistTypeADConfig[key].id] = key;
         }
         imgData = cResult.data;
         for(i = 0; i < imgData.length; i++)
         {
            adObj = imgData[i];
            for(j = 0; j < adObj.length; j++)
            {
               if(imgIDToPlaylistType[adObj[j].imgData.id] != null)
               {
                  playlistType = uint(imgIDToPlaylistType[adObj[j].imgData.id]);
                  this.mADImages[playlistType].push(WebImgData.getWebImgURL(adObj[j].imgData.id,j));
               }
            }
         }
         this.setupCraftingImages(this.mPlaylistType);
      }
      
      private function clearDifficulties() : void
      {
         while(this.myDifficultyMount.numChildren > 0)
         {
            this.myDifficultyMount.removeChildAt(0);
         }
         this.mDifficultyButtons = new Vector.<LockButton>();
      }
      
      private function makeDifficultyButtons(num:uint) : Vector.<UIInteractiveComponent>
      {
         var button:LockButton = null;
         var items:Vector.<UIInteractiveComponent> = null;
         this.clearDifficulties();
         var buttonClass:Class = getDefinitionByName("codo.share.matchselect.difficultiesButton") as Class;
         var curX:int = 0;
         var buttonWidth:Number = Math.ceil(DIFFICULTY_MOUNT_AREA / num);
         items = new Vector.<UIInteractiveComponent>(0);
         for(var i:int = 0; i < num; i++)
         {
            buttonWidth = curX + buttonWidth < DIFFICULTY_MOUNT_AREA ? buttonWidth : buttonWidth - (curX + buttonWidth - DIFFICULTY_MOUNT_AREA);
            button = new buttonClass() as LockButton;
            button.labelFocusColor = GlobalGuide.WHITE;
            button.labelUnfocusColor = 10990528;
            button.width = buttonWidth;
            button.height = 30;
            button.x = curX;
            this.myDifficultyMount.addChild(button);
            this.mDifficultyButtons.push(button);
            items.push(button);
            curX += buttonWidth;
         }
         return items;
      }
      
      override public function onModeSelect() : void
      {
         super.onModeSelect();
         this.switchShowModeInfo(false);
         if(myLeftList.selectedIndex == UiCppMatchSelectView.PVE_IDX_HERO_OPS)
         {
            this.clearDifficulties();
            this.mStartStatus = GlobalBottomBtnStatus.STATUS_IDLE_COOP_STAGE_CHOOSE;
            this.showDifficultyPanel(false);
            myMissionHeader.text = Dict.TRAINING_CAREER_MISSIONS;
         }
         else
         {
            this.mStartStatus = GlobalBottomBtnStatus.STATUS_IDLE_MP_PLAYLIST_CHOOSE;
            this.showDifficultyPanel(true);
            myMissionHeader.text = DictRoom.PLAYLIST;
         }
         EventManager.getInstance().broadcast(BCEvent.EVT_SET_BOTTOM_START_STATUS,this.mStartStatus);
      }
      
      private function showDifficultyPanel(show:Boolean) : void
      {
         this.myDifficultyBg.visible = show;
         this.myDifficultyHeader.visible = show;
         if(show)
         {
            myMiddleList.height = 521;
            myMiddleList.y = 366;
         }
         else
         {
            myMiddleList.height = 677;
            myMiddleList.y = 273;
         }
      }
      
      public function onMapDisplay(mode:uint, difficulty:uint, map:uint, isSelection:Boolean) : void
      {
         this.myRandomRewardSlideshow.visible = this.myRandomRewardButton.visible = this.myTokenButton.visible = false;
         this.myAdSlideShow.visible = false;
         if(mode == UiCppMatchSelectView.PVE_IDX_HERO_OPS)
         {
            this.updateHeroOpsDisplay(map,isSelection);
         }
         else
         {
            this.showPlaylistInfo(mode,difficulty,map,isSelection);
         }
      }
      
      override protected function setMarketReady(ready:Boolean) : void
      {
         super.setMarketReady(ready);
         this.myRandomRewardButton.enabled = ready;
         this.myTokenButton.setMarketReadyMode(ready);
      }
      
      private function updateHeroOpsDisplay(idx:uint, isSelection:Boolean) : void
      {
         this.switchShowModeInfo(true);
         this.arrangePartyButton(null);
         myModeInfo.heroOpsMode(true);
         myModeInfo.showNoLevelProgressWarning(true);
         myModeInfo.setOnboardBonus(null);
         myModeInfo.setXPandGPRate(0,0);
         var modeObj:MatchSelectModeObj = this.getHeroOpsMode();
         if(modeObj == null || idx >= modeObj.heroOpsMaps.length)
         {
            return;
         }
         var mapObj:MapObj = modeObj.heroOpsMaps[idx] as MapObj;
         myModeInfo.setModeName(mapObj.name);
         myModeInfo.setGameName("");
         myModeInfo.setModeDescription(mapObj.description);
         myModeInfo.setMaps([mapObj],null);
         if(isSelection)
         {
            EventManager.getInstance().broadcast(BCEvent.EVT_SET_MATCH_TYPE,QuickMatchType.makeHeroOps());
            PlayListObj.setSelectedPlaylist(null);
            DAXDispatcher.setGameVariant("coop");
            TLogUtil.TLog_UserInput(ButtonTLog.BUTTON_GAMEMODE_MISSION_SELECT,mapObj.id);
         }
         var rewards:RewardItemList = this.gatherRandomRewards(mapObj.id,"coop");
         if(rewards.all.length > 0)
         {
            this.setRandomRewards(rewards.all);
            this.myRandomRewardSlideshow.visible = this.myRandomRewardButton.visible = true;
         }
      }
      
      private function gatherRandomRewards(map:String, mode:String) : RewardItemList
      {
         var list:RewardItemList = new RewardItemList();
         list.SetData(CFunctionContainer.AS_GetRewardsForModeAndMap(mode,map,false),true);
         return list;
      }
      
      public function getHeroOpsMode() : MatchSelectModeObj
      {
         return myLeftList.listData[UiCppMatchSelectView.PVE_IDX_HERO_OPS] as MatchSelectModeObj;
      }
      
      private function showPlaylistInfo(mode:uint, difficulty:uint, map:uint, isSelection:Boolean) : void
      {
         var cDat:PlayListObj = null;
         var data:MatchSelectModeObj = null;
         var difficObj:MatchSelectDifficultyObj = null;
         var matchType:QuickMatchType = null;
         myModeInfo.heroOpsMode(false);
         myModeInfo.showNoLevelProgressWarning(false);
         var modes:Vector.<Object> = myLeftList.listData;
         if(mode < modes.length)
         {
            data = modes[mode] as MatchSelectModeObj;
            if(difficulty < data.pveDifficulties.length)
            {
               difficObj = data.pveDifficulties[difficulty];
               if(map < difficObj.playlists.length)
               {
                  cDat = difficObj.playlists[map];
               }
            }
         }
         if(cDat == null)
         {
            return;
         }
         this.switchShowModeInfo(true);
         this.arrangePartyButton(cDat);
         myModeInfo.setModeName(cDat.name);
         myModeInfo.setGameName(data.name);
         myModeInfo.setModeDescription(cDat.description);
         myModeInfo.setNumMaps(cDat);
         myModeInfo.setMaps(cDat.maps,getTutorialVideos(cDat));
         myModeInfo.setOpenLevel(cDat);
         if(cDat.vsrule == "")
         {
            myModeInfo.setPlayerLimit(playerRangeString(cDat.minRoomSize,cDat.maxRoomSize));
         }
         else
         {
            myModeInfo.setPlayerLimit(cDat.vsrule);
         }
         var numXPRate:Number = MathUtil.roundDecimal(cDat.xpScale * 100,2);
         var numGPRate:Number = MathUtil.roundDecimal(cDat.gpScale * 100,2);
         var xpgpBonusInfoObj:Object = CFunctionContainer.AS_GetXPGPScalerForPlaylist(cDat.index);
         var xpScale:Number = Math.round(xpgpBonusInfoObj.xpScale * 10) / 10;
         var gpScale:Number = Math.round(xpgpBonusInfoObj.gpScale * 10) / 10;
         var firstWinXPScale:Number = Math.round(xpgpBonusInfoObj.firstWinXpScale * 10) / 10;
         var firstWinGPScale:Number = Math.round(xpgpBonusInfoObj.firstWinGpScale * 10) / 10;
         var partyFirstWinXPScale:Number = Math.round(xpgpBonusInfoObj.partyFirstWinXpScale * 10) / 10;
         var partyFirstWinGPScale:Number = Math.round(xpgpBonusInfoObj.partyFirstWinGpScale * 10) / 10;
         myModeInfo.setXPandGPRate(numXPRate,numGPRate,xpScale,gpScale,firstWinXPScale,firstWinGPScale,partyFirstWinXPScale,partyFirstWinGPScale);
         myModeInfo.setOnboardBonus(cDat);
         this.myRandomRewardSlideshow.visible = this.myRandomRewardButton.visible = this.myTokenButton.visible = true;
         this.myAdSlideShow.visible = false;
         this.mPlaylistType = cDat.type;
         if(this.mPlaylistTypeADConfig[this.mPlaylistType] != null)
         {
            this.myRandomRewardButton.visible = this.myRandomRewardSlideshow.visible = false;
            this.myAdSlideShow.visible = true;
            this.setupCraftingImages(this.mPlaylistType);
         }
         if(isSelection)
         {
            matchType = QuickMatchType.fromPlaylistType(cDat.type);
            EventManager.getInstance().broadcast(BCEvent.EVT_SET_MATCH_TYPE,matchType);
            PlayListObj.setSelectedPlaylist(cDat);
            DAXDispatcher.setGameVariantByType(matchType);
            TLogUtil.TLog_UserInput(ButtonTLog.BUTTON_GAMEMODE_PLAYLIST_SELECT,cDat.name);
         }
         var matchTypeString:String = MatchService.getPlaylistRewardID(cDat);
         this.setRandomRewards(this.gatherRandomRewards("all",matchTypeString).gold);
      }
      
      override protected function onStartMatch() : void
      {
         var mapData:MapObj = null;
         super.onStartMatch();
         EventManager.getInstance().broadcast(BCEvent.EVT_SET_BOTTOM_START_STATUS,this.mStartStatus);
         if(myLeftList.selectedIndex == UiCppMatchSelectView.PVE_IDX_HERO_OPS)
         {
            mapData = this.getSelectedHeroOpsMap();
            TLogUtil.TLog_UserInput(ButtonTLog.BUTTON_GAMEMODE_START_MISSION_TRAINING,mapData.id);
            EventManager.getInstance().broadcast(BCEvent.EVT_BOTTOM_START_GAME);
         }
         else
         {
            TLogUtil.TLog_UserInput(ButtonTLog.BUTTON_GAMEMODE_BATTLE_PREP,this.getSelectedPlaylist().id.toString());
            EventManager.getInstance().broadcast(BCEvent.EVT_BOTTOM_START_GAME);
         }
      }
      
      private function onTokensClick() : void
      {
         EventManager.getInstance().broadcast(BCEvent.EVT_TRY_BUY_TOKEN);
      }
      
      override protected function arrangePartyButton(playlist:PlayListObj) : void
      {
         super.arrangePartyButton(playlist);
         if(myPartyButton.visible)
         {
            this.myTokenButton.x = myPartyButton.x - 6 - this.myTokenButton.width;
         }
         else
         {
            this.myTokenButton.x = myConfirmButton.x - 6 - this.myTokenButton.width;
         }
      }
      
      override protected function makeUiCpp() : UiCppView
      {
         return new UiCppViewPanel(this);
      }
      
      override protected function switchShowModeInfo(isShow:Boolean) : void
      {
         super.switchShowModeInfo(isShow);
         this.myTokenButton.visible = isShow;
      }
      
      private function setupCraftingImages(playlistType:uint) : void
      {
         var webAd:WebAdObj = null;
         var featureAd:FeaturedAdObj = null;
         var i:int = 0;
         var adData:Vector.<FeaturedAdObj> = new Vector.<FeaturedAdObj>();
         var imgs:Array = this.mADImages[playlistType];
         if(imgs != null)
         {
            for(i = 0; i < imgs.length; i++)
            {
               webAd = new WebAdObj(imgs[i],null);
               featureAd = new FeaturedAdObj("codo.shared.matchselect.adslide",webAd);
               adData.push(featureAd);
            }
         }
         this.myAdSlideShow.setData(adData);
      }
      
      private function onADSlideClicked(e:MouseEvent) : void
      {
         var dataManager:DataManager = DataManager.getInstance();
         var configObj:Object = this.mPlaylistTypeADConfig[this.mPlaylistType];
         if(Boolean(configObj != null) && Boolean(dataManager.getDP(DataID.IS_MARKETPLACE_READY)) && !dataManager.getDP(DataID.IS_MARKETPLACE_MAINTAIN))
         {
            EventManager.getInstance().broadcast(configObj.event,{"index":this.myAdSlideShow.currentPage});
         }
         else
         {
            BaseView.staticShowMsg(Dict.DW_MARKETPLACE_MAINTAIN,MsgBtnCount.ONE);
         }
      }
   }
}

