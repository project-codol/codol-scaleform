package codo.component.matchselect
{
   import codo.common.CFunctionCommonContainer;
   import codo.component.TextField;
   import codo.localization.Dict;
   import codo.localization.DictRoom;
   import codo.objects.GamemodeTutorialContentObj;
   import codo.objects.MapIllustrationObj;
   import codo.objects.MapObj;
   import codo.objects.PlayListObj;
   import codo.style.MatchSelectGuide;
   import flash.display.MovieClip;
   
   public class MatchSelectModeInfo2 extends MovieClip
   {
      
      private static const FRAME_WIDTH:Number = 906;
      
      private static const FRAME_HEIGHT:Number = 696;
      
      private static const ONBOARD_BONUS_MAX_LEVEL_BASE1:int = 19;
      
      public var myFrame:MovieClip;
      
      public var myModeName:TextField;
      
      public var myGameName:TextField;
      
      public var myModeDescription:TextField;
      
      public var myNoLevelProgressLabel:TextField;
      
      public var myPlayListLimit:PlayListLimit;
      
      public var myMapIntroduction:MatchSelectMapIntroduction;
      
      public var myBonusTab:MatchSelectBonusTab;
      
      public var myPartyBonusTab:MatchSelectBonusTab;
      
      public var myOnboardBonusTab:MatchSelectBonusTab;
      
      public function MatchSelectModeInfo2()
      {
         super();
         this.initStage();
      }
      
      protected function initStage() : void
      {
         this.myFrame.width = FRAME_WIDTH;
         this.myFrame.height = FRAME_HEIGHT;
         this.myFrame.gotoAndStop(4);
         this.myModeName.textStyle = MatchSelectGuide.styleDetailModeName;
         this.myModeName.width = 400;
         this.myModeName.height = 36;
         this.myModeName.x = 26;
         this.myModeName.y = 33;
         this.myGameName.textStyle = MatchSelectGuide.styleDetailGameName;
         this.myGameName.width = 400;
         this.myGameName.height = 27;
         this.myGameName.x = 26;
         this.myGameName.y = 72;
         this.myModeDescription.textStyle = MatchSelectGuide.styleModeDescription;
         this.myModeDescription.width = 283;
         this.myModeDescription.height = 386;
         this.myModeDescription.x = 576;
         this.myModeDescription.y = 132;
         this.myNoLevelProgressLabel.textStyle = MatchSelectGuide.styleNoLevelProgressLabel;
         this.myNoLevelProgressLabel.width = 283;
         this.myNoLevelProgressLabel.height = 386;
         this.myNoLevelProgressLabel.x = 576;
         this.myNoLevelProgressLabel.text = DictRoom.NO_CHALLENGE_PROGRESS_INFO;
      }
      
      public function setModeName(value:String) : void
      {
         this.myModeName.text = value;
      }
      
      public function setGameName(value:String) : void
      {
         this.myGameName.text = value;
      }
      
      public function setPlayerLimit(value:String) : void
      {
         this.myPlayListLimit.setPlayersLimit(value);
      }
      
      public function setNumMaps(cDat:PlayListObj) : void
      {
         if(cDat != null)
         {
            this.myPlayListLimit.setMapsLimit(cDat.maps.length.toString());
         }
      }
      
      public function setOpenLevel(cDat:PlayListObj) : void
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
         this.myPlayListLimit.setLevelLimit(openLevelStr);
      }
      
      public function setModeDescription(description:String) : void
      {
         this.myModeDescription.text = description;
         this.myNoLevelProgressLabel.y = this.myModeDescription.y + this.myModeDescription.textHeight + 30;
      }
      
      public function showNoLevelProgressWarning(show:Boolean) : void
      {
         this.myNoLevelProgressLabel.visible = show;
      }
      
      public function setMaps(maps:Array, videos:Vector.<GamemodeTutorialContentObj>) : void
      {
         var tutorial:GamemodeTutorialContentObj = null;
         var mapIllustrationObj:MapIllustrationObj = null;
         var mapObj:MapObj = null;
         var mapIllustrations:Vector.<Object> = new Vector.<Object>();
         var i:int = 0;
         while(Boolean(videos) && i < videos.length)
         {
            tutorial = videos[i];
            mapIllustrationObj = new MapIllustrationObj();
            mapIllustrationObj.mode = tutorial.mode;
            mapIllustrationObj.imageURL = tutorial.imagePath;
            mapIllustrationObj.videoURL = tutorial.videoPath;
            mapIllustrationObj.desc = tutorial.contentSubTitle;
            mapIllustrations.push(mapIllustrationObj);
            i++;
         }
         if(mapIllustrations.length == 0)
         {
            for(i = 0; i < maps.length; i++)
            {
               mapObj = maps[i] as MapObj;
               mapIllustrationObj = new MapIllustrationObj();
               mapIllustrationObj.imageURL = mapObj.imageURL;
               mapIllustrationObj.videoURL = "";
               mapIllustrationObj.desc = mapObj.description;
               mapIllustrations.push(mapIllustrationObj);
            }
         }
         this.myMapIntroduction.setData(mapIllustrations);
      }
      
      public function setOnboardBonus(playlist:PlayListObj) : void
      {
         var levelBase1:int = 0;
         var prestige:int = 0;
         var showOnboardBonus:Boolean = false;
         if(playlist != null && playlist.onboardBonus)
         {
            this.myOnboardBonusTab.setType(MatchSelectBonusTab.TYPE_1BONUS);
            this.myOnboardBonusTab.setLabel(Dict.MATCH_SELECT_ONBOARD_LABEL);
            this.myOnboardBonusTab.setBonus1("+20%","XP");
            levelBase1 = CFunctionCommonContainer.GetPlayerLevel() + 1;
            prestige = CFunctionCommonContainer.GetPlayerPrestige();
            showOnboardBonus = levelBase1 <= ONBOARD_BONUS_MAX_LEVEL_BASE1 && prestige == 0;
         }
         this.myOnboardBonusTab.visible = showOnboardBonus;
      }
      
      public function setXPandGPRate(xpRate:Number, gpRate:Number, xpScale:Number = 1, gpScale:Number = 1, firstWinXPScale:Number = 1, firstWinGPScale:Number = 1, partyFirstWinXPScale:Number = 1, partyFirstWinGPScale:Number = 1) : void
      {
         var xpPartyDisplayVal:Number = NaN;
         var gpPartyDisplayVal:Number = NaN;
         this.myBonusTab.visible = this.myPartyBonusTab.visible = false;
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
            this.myBonusTab.setLabel(Dict.USER_STATUS_NO_PARTY_ONLY);
            this.myBonusTab.setBonus1(xpDisplayVal + "%",Dict.XP);
            this.myBonusTab.setBonus2(gpDisplayVal + "%",Dict.GP);
            this.myBonusTab.visible = true;
            if(bShowParty)
            {
               xpPartyDisplayVal = xpRate * (xpScale + partyFirstWinXPScale - 1);
               gpPartyDisplayVal = gpRate * (gpScale + partyFirstWinGPScale - 1);
               this.myBonusTab.setLabel(Dict.USER_STATUS_NO_PARTY);
               if(xpPartyDisplayVal > 400)
               {
                  xpPartyDisplayVal = 400;
               }
               if(gpPartyDisplayVal > 400)
               {
                  gpPartyDisplayVal = 400;
               }
               this.myPartyBonusTab.setLabel(Dict.USER_STATUS_IN_PARTY);
               this.myPartyBonusTab.setBonus1(xpPartyDisplayVal + "%",Dict.XP);
               this.myPartyBonusTab.setBonus2(gpPartyDisplayVal + "%",Dict.GP);
               this.myPartyBonusTab.visible = true;
            }
         }
      }
      
      public function heroOpsMode(value:Boolean) : void
      {
         this.myPlayListLimit.visible = !value;
         this.myMapIntroduction.myMapList.visible = this.myMapIntroduction.myMapDesc.visible = this.myMapIntroduction.myMapDescBg.visible = !value;
      }
      
      public function resetInfo() : void
      {
         this.setModeName("");
         this.setGameName("");
         this.setModeDescription("");
         this.setNumMaps(null);
         this.setPlayerLimit("");
         this.myPartyBonusTab.visible = this.myBonusTab.visible = false;
         this.showNoLevelProgressWarning(false);
         this.setOnboardBonus(null);
      }
   }
}

