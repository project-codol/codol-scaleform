package codo.component.matchselect
{
   import codo.component.Button;
   import codo.component.CallToActionButton;
   import codo.component.ScrollList;
   import codo.component.TextField;
   import codo.component.ViewPanelBase;
   import codo.component.factory.ButtonFactory;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.constants.PageID;
   import codo.localization.DictParty;
   import codo.localization.DictRoom;
   import codo.manager.DataManager;
   import codo.manager.EventManager;
   import codo.objects.GamemodeTutorialContentObj;
   import codo.objects.MapObj;
   import codo.objects.MatchSelectModeObj;
   import codo.objects.ModeObj;
   import codo.objects.PartyObj;
   import codo.objects.PlayListObj;
   import codo.objects.ScrollListSettings;
   import codo.services.MatchService;
   import codo.services.TutorialService;
   import codo.style.MatchSelectGuide;
   import codo.utils.LocalizeUtil;
   import codo.utils.ScaleformUtil;
   import flash.display.MovieClip;
   
   public class MatchSelectPanelBase2 extends ViewPanelBase
   {
      
      public var myGameTypeHeader:TextField;
      
      public var myMissionHeader:TextField;
      
      public var myConfirmButton:CallToActionButton;
      
      public var myPartyButton:Button;
      
      public var myGameTypeBG:MovieClip;
      
      public var myLeftList:ScrollList;
      
      public var myLeftListBackground:MovieClip;
      
      public var myPlayListBG:MovieClip;
      
      public var myMiddleList:ScrollList;
      
      public var myMiddleListBackground:MovieClip;
      
      public var myHeader:TextField;
      
      public var myModeInfo:MatchSelectModeInfo2;
      
      public var myNoModeInfo:MovieClip;
      
      public function MatchSelectPanelBase2()
      {
         super();
         this.initStage();
         if(!ScaleformUtil.isScaleform)
         {
            visible = true;
            alpha = 1;
         }
      }
      
      protected function initStage() : void
      {
         var leftListSettings:ScrollListSettings = null;
         leftListSettings = new ScrollListSettings();
         leftListSettings.orientation = ScrollListSettings.SCROLL_VERTICAL;
         leftListSettings.useNavArrows = false;
         leftListSettings.autoSize = false;
         leftListSettings.autoSizeItems = true;
         leftListSettings.buildGridItemRenderMethod = ButtonFactory.BUILD_MATCH_SELECT_MODE_OPTION;
         leftListSettings.itemPadding = 6;
         leftListSettings.hideScrollBar = true;
         this.myLeftList.settings = leftListSettings;
         var rightListSettings:ScrollListSettings = new ScrollListSettings();
         rightListSettings.orientation = ScrollListSettings.SCROLL_VERTICAL;
         rightListSettings.useNavArrows = false;
         rightListSettings.autoSize = false;
         rightListSettings.autoSizeItems = true;
         rightListSettings.buildGridItemRenderMethod = ButtonFactory.BUILD_MATCH_SELECT_OPTION;
         rightListSettings.itemPadding = 6;
         this.myMiddleList.settings = rightListSettings;
         this.myMiddleList.listItemDoubleClickCallback = this.onStartMatch;
         this.myGameTypeHeader.textStyle = MatchSelectGuide.styleHeader;
         this.myGameTypeHeader.width = 250;
         this.myGameTypeHeader.height = 32;
         this.myGameTypeHeader.x = 241;
         this.myGameTypeHeader.y = 213;
         this.myMissionHeader.textStyle = MatchSelectGuide.styleHeader;
         this.myMissionHeader.width = 250;
         this.myMissionHeader.height = 32;
         this.myMissionHeader.x = 528;
         this.myMissionHeader.y = 213;
         this.myMissionHeader.text = "";
         this.myGameTypeBG.myBackground.width = this.myLeftListBackground.width;
         this.myPlayListBG.myBackground.width = this.myMiddleListBackground.width;
         this.myLeftList.x = 126;
         this.myLeftList.y = 273;
         this.myLeftList.height = 653;
         this.myLeftList.width = 350;
         this.myMiddleList.width = 379;
         this.myMiddleList.height = 653;
         this.myConfirmButton.registerClickEvent(this.onStartMatch);
         this.myConfirmButton.width = 280;
         this.myConfirmButton.height = 60;
         this.myConfirmButton.x = 1792 - this.myConfirmButton.width;
         this.myConfirmButton.y = 885;
         this.myConfirmButton.label = DictRoom.JOIN;
         this.myConfirmButton.myLabel.fontSize = 28;
         this.myPartyButton.registerClickEvent(this.onCreateParty);
         this.myPartyButton.width = 280;
         this.myPartyButton.height = 60;
         this.myPartyButton.x = this.myConfirmButton.x - 6 - this.myPartyButton.width;
         this.myPartyButton.y = 885;
         this.myPartyButton.label = DictParty.PARTY;
         this.myPartyButton.myLabel.fontSize = 28;
         this.myNoModeInfo.myFrame.width = 906;
         this.myNoModeInfo.myFrame.height = 696;
         var noInfoTF:TextField = this.myNoModeInfo.myNoRoomText;
         noInfoTF.textStyle = MatchSelectGuide.styleNoRoomModeInfo;
         noInfoTF.width = 906;
         noInfoTF.height = 30;
         noInfoTF.x = 0;
         noInfoTF.y = 233;
         noInfoTF.text = DictRoom.NOTE_NO_PLAYLIST_FOUND;
         this.switchShowModeInfo(false);
      }
      
      override protected function enableData() : void
      {
         super.enableData();
         DataManager.getInstance().bind(DataID.DATA_RECEIVE,this.checkReadyFlags,null,false);
         DataManager.getInstance().bind(DataID.MARKETPLACE_MAINTAIN_STATE,this.checkReadyFlags,null,false);
         this.checkReadyFlags();
      }
      
      override protected function disableData() : void
      {
         super.disableData();
      }
      
      protected function checkReadyFlags(cRes:Object = null) : void
      {
         var isMarketplaceReady:Boolean = DataManager.getInstance().getDP(DataID.IS_MARKETPLACE_READY);
         var isMarketplaceMaintain:Boolean = DataManager.getInstance().getDP(DataID.IS_MARKETPLACE_MAINTAIN);
         this.setMarketReady(isMarketplaceReady && !isMarketplaceMaintain);
      }
      
      public function onModeSelect() : void
      {
         var mapObj:MapObj = null;
         var playlist:PlayListObj = null;
         var image:String = "SP_Multi_Gamemode_.tga";
         var modeData:MatchSelectModeObj = this.myLeftList.selectedData as MatchSelectModeObj;
         if(modeData != null)
         {
            if(modeData.heroOpsMaps != null && modeData.heroOpsMaps.length > 0)
            {
               mapObj = modeData.heroOpsMaps[0] as MapObj;
               image = mapObj.imageURL;
            }
            else
            {
               playlist = modeData.getPlaylist(0);
               if(playlist != null)
               {
                  image = playlist.getImage();
               }
            }
         }
      }
      
      protected function playerRangeString(minPlayers:int, maxPlayers:int) : String
      {
         return minPlayers + " ~ " + maxPlayers;
      }
      
      protected function onCreateParty() : void
      {
         EventManager.getInstance().broadcast(BCEvent.EVT_OPEN_SOCIAL_POPUP,PageID.PARTY);
         var isInParty:Boolean = DataManager.getInstance().getDP(DataID.IS_IN_PARTY);
         if(!isInParty)
         {
            EventManager.getInstance().broadcast(BCEvent.PARTY_CREATE);
         }
      }
      
      protected function arrangePartyButton(playlist:PlayListObj) : void
      {
         var needPartyButton:Boolean = Boolean(playlist) && (playlist.minPartySize != 0 || playlist.maxPartySize != 0);
         this.myPartyButton.visible = needPartyButton;
      }
      
      protected function onStartMatch() : void
      {
      }
      
      protected function setMarketReady(ready:Boolean) : void
      {
      }
      
      protected function getTutorialVideos(playlist:PlayListObj) : Vector.<GamemodeTutorialContentObj>
      {
         var mode:ModeObj = null;
         var modeStr:String = null;
         var contents:Vector.<GamemodeTutorialContentObj> = null;
         var map:MapObj = null;
         var supportedModes:Array = playlist.modes;
         var len:int = int(supportedModes.length);
         for(var i:int = 0; i < len; i++)
         {
            mode = supportedModes[i];
            modeStr = mode.id;
            if(modeStr == "dmz")
            {
               if(MatchService.getInstance().getPlayListHasRule(playlist,"dmz_circle_reversed 1"))
               {
                  modeStr = "rdmz";
               }
            }
            else if(modeStr == "zhunt")
            {
               if(playlist != null && playlist.maps != null && playlist.maps.length > 0)
               {
                  map = playlist.maps[0] as MapObj;
                  if(map.id == "mp_deathmarch_chap1_c" || map.id == "mp_deathmarch_chap1_d")
                  {
                     modeStr = "zhunt_1";
                  }
                  if(map.id == "mp_deathmarch_chap3_a" || map.id == "mp_deathmarch_chap3_b")
                  {
                     modeStr = "zhunt_2";
                  }
                  if(map.id == "mp_deathmarch_chap4_a" || map.id == "mp_deathmarch_chap4_b")
                  {
                     modeStr = "zhunt_3";
                  }
               }
            }
            contents = TutorialService.getInstance().getContentByGameType(modeStr);
            if(contents.length > 0)
            {
               return contents;
            }
         }
         return null;
      }
      
      public function updatePartyButtonText() : void
      {
         var partyInfo:PartyObj = DataManager.getInstance().getDP(DataID.PARTY_INFO);
         var partyMember:int = 0;
         if(Boolean(partyInfo))
         {
            partyMember = int(partyInfo.members.length);
         }
         if(partyMember > 0)
         {
            this.myPartyButton.label = LocalizeUtil.param(DictParty.MATCH_SELECT_IN_PARTY,[String(partyMember)]);
         }
         else
         {
            this.myPartyButton.label = DictParty.CREATE_PARTY;
         }
      }
      
      protected function switchShowModeInfo(isShow:Boolean) : void
      {
         this.myModeInfo.visible = isShow;
         this.myConfirmButton.visible = isShow;
         this.myPartyButton.visible = isShow;
         this.myNoModeInfo.visible = !isShow;
      }
   }
}

