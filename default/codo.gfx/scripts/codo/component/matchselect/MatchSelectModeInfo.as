package codo.component.matchselect
{
   import codo.common.CFunctionCommonContainer;
   import codo.component.Button;
   import codo.component.IconButton;
   import codo.component.TextField;
   import codo.constants.BCEvent;
   import codo.localization.Dict;
   import codo.localization.DictRoom;
   import codo.manager.EventManager;
   import codo.objects.ModeObj;
   import codo.objects.PlayListObj;
   import codo.services.TutorialService;
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextFieldAutoSize;
   import flash.utils.getDefinitionByName;
   import fsg.util.FsgImageHolder;
   
   public class MatchSelectModeInfo extends MovieClip
   {
      
      private static const DESCRIPTION_MARGIN:Number = 20;
      
      private static const FRAME_WIDTH:Number = 666;
      
      private static const FRAME_HEIGHT:Number = 617;
      
      private static const LABEL_WIDTH:Number = 204;
      
      private static const DESCRIPTION_DEFAULT_Y:int = 438;
      
      private static const DESCRIPTION_NO_STAT_BAR_Y:int = 383;
      
      private static const ONBOARD_BONUS_MAX_LEVEL_BASE1:int = 19;
      
      private static const NOLEVEL_PROGRESSLABEL_PADDING:int = 10;
      
      private static const TUTORIALBUTTON_PADDING:int = 63;
      
      public var myModeImage:FsgImageHolder;
      
      public var myModeTutorialButton:IconButton;
      
      public var myItemRestrictionButton:Button;
      
      public var myLoadingIndicator:MovieClip;
      
      public var myStatContainerBG:Sprite;
      
      public var myBonusTab:Sprite;
      
      public var myPartyBonusTab:Sprite;
      
      public var myFrame:MovieClip;
      
      public var myModeDescription:TextField;
      
      public var myModeName:TextField;
      
      public var myGameName:TextField;
      
      public var myModePlayerLimit:TextField;
      
      public var myModePlayerLimitLabel:TextField;
      
      public var myNumPlaylistMaps:TextField;
      
      public var myNumPlaylistMapsLabel:TextField;
      
      public var myOpenLevel:TextField;
      
      public var myOpenLevelLabel:TextField;
      
      public var myNoLevelProgressLabel:TextField;
      
      public var myLoadingLabel:TextField;
      
      public var myOnboardBonusLabel:TextField;
      
      public var myOnboardXPBonusLabel:TextField;
      
      public var myBonusXPLabel:TextField;
      
      public var myBonusGPLabel:TextField;
      
      public var myBonusLabel:TextField;
      
      public var myPartyBonusLabel:TextField;
      
      public var myPartyBonusXPLabel:TextField;
      
      public var myPartyBonusGPLabel:TextField;
      
      public var myOnboardBonusBG:Sprite;
      
      private var _selectedGameModeTutorial:String;
      
      protected var _isLoading:Boolean;
      
      private var mItemRestrictionClickedCallback:Function;
      
      public function MatchSelectModeInfo()
      {
         super();
         this.initStage();
      }
      
      private function initStage() : void
      {
         this.myFrame.width = FRAME_WIDTH;
         this.myFrame.height = FRAME_HEIGHT;
         this.myFrame.gotoAndStop(4);
         this.myModeName.height = 48;
         this.myNoLevelProgressLabel.width = this.myLoadingLabel.width = this.myModeName.width = this.myGameName.width = this.myModeDescription.width = this.myModeImage.width - DESCRIPTION_MARGIN;
         this.myNoLevelProgressLabel.height = this.myGameName.height = this.myLoadingLabel.height = 64;
         this.myPartyBonusGPLabel.width = this.myPartyBonusXPLabel.width = this.myBonusGPLabel.width = this.myBonusXPLabel.width = this.myOnboardXPBonusLabel.width = this.myOnboardBonusLabel.width = this.myOnboardBonusBG.width;
         this.myOpenLevel.width = this.myNumPlaylistMaps.width = this.myModePlayerLimit.width = this.myModePlayerLimitLabel.width = this.myNumPlaylistMapsLabel.width = this.myOpenLevelLabel.width = LABEL_WIDTH;
         this.myModeName.font = GlobalGuide.FONT_FACE_BOLD;
         this.myModeName.fontSize = GlobalGuide.FONT_SIZE_SMALL;
         this.myOpenLevelLabel.fontSize = this.myNumPlaylistMapsLabel.fontSize = this.myModePlayerLimitLabel.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         this.myModePlayerLimit.alignment = this.myNumPlaylistMaps.alignment = this.myOpenLevel.alignment = this.myOpenLevelLabel.alignment = this.myNumPlaylistMapsLabel.alignment = this.myModePlayerLimitLabel.alignment = TextStyle.HALIGN_CENTER;
         this.myPartyBonusLabel.fontSize = this.myBonusLabel.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         this.myPartyBonusLabel.font = this.myBonusLabel.font = GlobalGuide.FONT_FACE_BOLD;
         this.myPartyBonusLabel.alignment = this.myBonusLabel.alignment = TextStyle.HALIGN_CENTER;
         this.myPartyBonusLabel.width = this.myBonusLabel.width = this.myBonusTab.width;
         this.myPartyBonusLabel.height = this.myBonusLabel.height = this.myBonusTab.height;
         this.myOpenLevel.font = this.myNumPlaylistMaps.font = this.myModePlayerLimit.font = GlobalGuide.FONT_FACE_NUMBERS;
         this.myOpenLevel.fontSize = this.myNumPlaylistMaps.fontSize = this.myModePlayerLimit.fontSize = GlobalGuide.FONT_SIZE_MEDIUM;
         this.myModeDescription.font = this.myNoLevelProgressLabel.font = GlobalGuide.FONT_FACE_MEDIUM;
         this.myGameName.font = GlobalGuide.FONT_FACE_BOLD;
         this.myModeDescription.fontSize = this.myNoLevelProgressLabel.fontSize = GlobalGuide.FONT_SIZE_SMALL;
         this.myGameName.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         this.myModeDescription.multiline = this.myModeDescription.wordWrap = true;
         this.myModeDescription.autoSize = TextFieldAutoSize.LEFT;
         this.myLoadingLabel.alignment = TextStyle.HALIGN_CENTER;
         this.myNoLevelProgressLabel.text = LocalizeUtil.localize(DictRoom.NO_CHALLENGE_PROGRESS_INFO);
         this.myOpenLevelLabel.text = LocalizeUtil.localize(DictRoom.PLAYLIST_OPEN_AT).toUpperCase();
         this.myNumPlaylistMapsLabel.text = LocalizeUtil.localize("@SF_UI_GAMEMODES_NUM_MAPS");
         this.myModePlayerLimitLabel.text = LocalizeUtil.localize(DictRoom.LIST_LABEL_PLAYER_MIN_MAX);
         this.myModeTutorialButton.label = LocalizeUtil.localize(Dict.GAME_SUMMARY_BUTTON_LABLE_INFO);
         this.myModeTutorialButton.setImage("information_icon.tga");
         this.myModeTutorialButton.registerClickEvent(this.onGamemodeTutorialButtonClick);
         this.myModeTutorialButton.setMarketReadyMode(true);
         this.myOnboardXPBonusLabel.font = GlobalGuide.FONT_FACE_BOLD;
         this.myOnboardXPBonusLabel.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         this.myOnboardXPBonusLabel.alignment = this.myOnboardBonusLabel.alignment = TextStyle.HALIGN_CENTER;
         this.myOnboardBonusLabel.fontSize = GlobalGuide.FONT_SIZE_TINY;
         this.myOnboardBonusLabel.fontColor = GlobalGuide.CODO_BLUE_HIGHLIGHT;
         this.myOnboardXPBonusLabel.text = LocalizeUtil.localize(Dict.MATCH_SELECT_ONBOARD_XP_LABEL);
         this.myOnboardBonusLabel.text = LocalizeUtil.localize(Dict.MATCH_SELECT_ONBOARD_LABEL);
         var btnClass:Class = getDefinitionByName("codo.shared.Button") as Class;
         this.myItemRestrictionButton = new btnClass() as Button;
         addChild(this.myItemRestrictionButton);
         this.myItemRestrictionButton.registerClickEvent(this.onItemRestrictionClicked);
         this.myItemRestrictionButton.label = Dict.ITEM_RESTRICTIONS;
         this.myItemRestrictionButton.width = 128;
         this.myItemRestrictionButton.x = this.myModeTutorialButton.x;
         this.myItemRestrictionButton.y = this.myModeTutorialButton.y;
         this.myItemRestrictionButton.visible = false;
         this.resetInfo();
         this.showLoadingStatus(false);
      }
      
      public function showNoLevelProgressWarning(show:Boolean) : void
      {
         this.myNoLevelProgressLabel.visible = show;
      }
      
      public function showLoadingStatus(show:Boolean) : void
      {
         this.myLoadingLabel.visible = show;
         this.myLoadingIndicator.visible = show && this._isLoading;
      }
      
      public function setLoadingLabel(label:String, showLoading:Boolean = false) : void
      {
         this.myLoadingLabel.text = label.toUpperCase();
         this._isLoading = showLoading;
      }
      
      public function showOnboardBonus(playlist:PlayListObj) : void
      {
         var levelBase1:int = 0;
         var prestige:int = 0;
         var show:Boolean = false;
         if(playlist != null && playlist.onboardBonus)
         {
            levelBase1 = CFunctionCommonContainer.GetPlayerLevel() + 1;
            prestige = CFunctionCommonContainer.GetPlayerPrestige();
            show = levelBase1 <= ONBOARD_BONUS_MAX_LEVEL_BASE1 && prestige == 0;
         }
         this.myOnboardBonusBG.visible = this.myOnboardXPBonusLabel.visible = this.myOnboardBonusLabel.visible = show;
      }
      
      public function set FrameHeight(frameHeight:int) : void
      {
         this.myFrame.height = frameHeight;
         this.myModeTutorialButton.y = this.myFrame.y + frameHeight - TUTORIALBUTTON_PADDING;
         this.myItemRestrictionButton.y = this.myModeTutorialButton.y;
      }
      
      public function setImage(imgURL:String) : void
      {
         this.myModeImage.aspectMax = true;
         this.myModeImage.setImage(imgURL);
      }
      
      public function setModeName(modeName:String) : void
      {
         this.myModeName.text = LocalizeUtil.localize(modeName).toUpperCase();
      }
      
      public function setGameName(gameName:String) : void
      {
         this.myGameName.text = LocalizeUtil.localize(gameName).toUpperCase();
      }
      
      public function setModeDescription(description:String) : void
      {
         this.myModeDescription.htmlText = description;
         this.myNoLevelProgressLabel.y = this.myModeDescription.y + this.myModeDescription.myTextClip.height + NOLEVEL_PROGRESSLABEL_PADDING;
      }
      
      public function initTutorial(playlist:PlayListObj) : void
      {
         var mode:ModeObj = null;
         this.myModeTutorialButton.visible = false;
         this.myItemRestrictionButton.x = this.myModeTutorialButton.x;
         var supportedModes:Array = playlist.modes;
         var len:int = int(supportedModes.length);
         for(var i:int = 0; i < len; i++)
         {
            mode = supportedModes[i];
            if(this.initTutorialForMode(mode.id))
            {
               return;
            }
         }
      }
      
      public function initTutorialForMode(mode:String) : Boolean
      {
         this.myModeTutorialButton.visible = false;
         if(TutorialService.getInstance().getContentByGameType(mode).length > 0)
         {
            this._selectedGameModeTutorial = mode;
            this.myModeTutorialButton.visible = true;
            this.myItemRestrictionButton.x = this.myModeTutorialButton.x + this.myModeTutorialButton.width + GlobalGuide.COMPONENT_PADDING;
            return true;
         }
         return false;
      }
      
      public function setPlayerLimit(limit:String) : void
      {
         this.myModePlayerLimit.text = limit;
         this.myModePlayerLimitLabel.visible = limit != "";
      }
      
      public function setNumMaps(cDat:PlayListObj) : void
      {
         if(cDat != null)
         {
            this.myNumPlaylistMaps.text = cDat.maps.length.toString();
            this.myNumPlaylistMapsLabel.visible = true;
         }
         else
         {
            this.myNumPlaylistMaps.text = "";
            this.myNumPlaylistMapsLabel.visible = false;
         }
      }
      
      public function setOpenLevel(cDat:PlayListObj) : void
      {
         var openLevels:Array = null;
         var openLevelStr:String = null;
         var i:int = 0;
         if(cDat != null)
         {
            openLevels = cDat.unlockedLevels;
            openLevelStr = "";
            for(i = 0; i < openLevels.length; i++)
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
            this.myOpenLevel.text = openLevelStr;
            this.myOpenLevelLabel.visible = true;
         }
         else
         {
            this.myOpenLevel.text = "";
            this.myOpenLevelLabel.visible = false;
         }
      }
      
      protected function onGamemodeTutorialButtonClick() : void
      {
         EventManager.getInstance().broadcast(BCEvent.EVT_OPEN_GAME_MODE_TUTORIAL,this._selectedGameModeTutorial);
      }
      
      public function registerItemRestrictionCallback(func:Function) : void
      {
         this.mItemRestrictionClickedCallback = func;
      }
      
      public function setXPandGPRate(xpRate:Number, gpRate:Number, xpScale:Number = 1, gpScale:Number = 1, firstWinXPScale:Number = 1, firstWinGPScale:Number = 1, partyFirstWinXPScale:Number = 1, partyFirstWinGPScale:Number = 1) : void
      {
         var centerOffset:int = 0;
         var center:int = 0;
         var xpPartyDisplayVal:Number = NaN;
         var gpPartyDisplayVal:Number = NaN;
         var xpDisplayVal:Number = xpRate * (xpScale + firstWinXPScale - 1);
         var gpDisplayVal:Number = gpRate * (gpScale + firstWinGPScale - 1);
         var bShowParty:Boolean = partyFirstWinXPScale > 1 || partyFirstWinGPScale > 1;
         if(xpDisplayVal > 400)
         {
            xpDisplayVal = 400;
         }
         if(gpDisplayVal > 400)
         {
            gpDisplayVal = 400;
         }
         if(xpDisplayVal > 100 || gpDisplayVal > 100 || bShowParty)
         {
            this.myBonusLabel.text = LocalizeUtil.localize(Dict.USER_STATUS_NO_PARTY_ONLY);
            this.myBonusXPLabel.htmlText = xpDisplayVal + "% <font color=\'#F77808\' size=\'18\'>" + LocalizeUtil.localize(Dict.XP) + "</font>";
            this.myBonusGPLabel.htmlText = gpDisplayVal + "% <font color=\'#F77808\' size=\'18\'>" + LocalizeUtil.localize(Dict.GP) + "</font>";
            centerOffset = 2;
            center = this.myBonusTab.x + this.myBonusTab.width * 0.5 - centerOffset;
            this.myBonusXPLabel.x = center - this.myBonusXPLabel.textWidth * 0.5;
            this.myBonusGPLabel.x = center - this.myBonusGPLabel.textWidth * 0.5;
            this.myBonusTab.visible = true;
            if(bShowParty)
            {
               xpPartyDisplayVal = xpRate * (xpScale + partyFirstWinXPScale - 1);
               gpPartyDisplayVal = gpRate * (gpScale + partyFirstWinGPScale - 1);
               this.myBonusLabel.text = LocalizeUtil.localize(Dict.USER_STATUS_NO_PARTY);
               if(xpPartyDisplayVal > 400)
               {
                  xpPartyDisplayVal = 400;
               }
               if(gpPartyDisplayVal > 400)
               {
                  gpPartyDisplayVal = 400;
               }
               this.myPartyBonusLabel.text = LocalizeUtil.localize(Dict.USER_STATUS_IN_PARTY);
               this.myPartyBonusXPLabel.htmlText = xpPartyDisplayVal + "% <font color=\'#F77808\' size=\'18\'>" + LocalizeUtil.localize(Dict.XP) + "</font>";
               this.myPartyBonusGPLabel.htmlText = gpPartyDisplayVal + "% <font color=\'#F77808\' size=\'18\'>" + LocalizeUtil.localize(Dict.GP) + "</font>";
               center = this.myPartyBonusTab.x + this.myPartyBonusTab.width * 0.5 - centerOffset;
               this.myPartyBonusXPLabel.x = center - this.myPartyBonusXPLabel.textWidth * 0.5;
               this.myPartyBonusGPLabel.x = center - this.myPartyBonusGPLabel.textWidth * 0.5;
               this.myPartyBonusTab.visible = true;
            }
         }
      }
      
      public function resetInfo() : void
      {
         this.setImage("SP_Multi_Gamemode_.tga");
         this.setModeName("");
         this.setGameName("");
         this.setModeDescription("");
         this.setNumMaps(null);
         this.setOpenLevel(null);
         this.setPlayerLimit("");
         this.myPartyBonusLabel.text = this.myBonusLabel.text = "";
         this.myPartyBonusXPLabel.text = this.myPartyBonusGPLabel.text = this.myBonusXPLabel.text = this.myBonusGPLabel.text = "";
         this.myPartyBonusTab.visible = this.myBonusTab.visible = false;
         this.showNoLevelProgressWarning(false);
         this.myModeTutorialButton.visible = false;
         this.showOnboardBonus(null);
      }
      
      public function showStatBar(show:Boolean) : void
      {
         this.myStatContainerBG.visible = show;
         this.myModeDescription.y = show ? DESCRIPTION_DEFAULT_Y : DESCRIPTION_NO_STAT_BAR_Y;
      }
      
      private function onItemRestrictionClicked() : void
      {
         if(null != this.mItemRestrictionClickedCallback)
         {
            this.mItemRestrictionClickedCallback();
         }
      }
   }
}

