package codo.component.lobby
{
   import codo.component.Button;
   import codo.component.TextField;
   import codo.component.core.UIInteractiveComponent;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.constants.VoteMapType;
   import codo.event.ParaEvent;
   import codo.localization.Dict;
   import codo.localization.DictRoom;
   import codo.localization.DictWarGod;
   import codo.manager.DataManager;
   import codo.manager.EventManager;
   import codo.objects.RoomInfoObj;
   import codo.objects.RoomObj;
   import codo.style.TextStyle;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   import flash.text.TextFormatAlign;
   
   public class LobbyMatchOptionsPanel extends UIInteractiveComponent
   {
      
      public static const MAP_IMAGE_WIDTH:int = 512;
      
      public static const MAP_IMAGE_HEIGHT:int = 288;
      
      public static const MAP_TEXT_WIDTH:int = 290;
      
      public static const BACKGROUND_NORMAL_HEIGHT:Number = 429.05;
      
      public static const BACKGROUND_SHORT_HEIGHT:Number = 238;
      
      public static const BACKGROUND_ALL_VOTES_HEIGHT:Number = 550;
      
      public static const BACKGROUND_SKIP_VOTE_HEIGHT:Number = 312;
      
      public static const VOTE_BUTTON_TEXT_WIDTH:int = 272;
      
      public var myAdvancedOptions:LobbyAdvancedOptions;
      
      public var myRestrictedItemsButton:Button;
      
      public var myTitleText:TextField;
      
      public var myMapSelectionButton:LobbyMapSelectionButton;
      
      public var myMapInfoPanelBackground:MovieClip;
      
      public var myMapSettingsBackground:MovieClip;
      
      public var myMapLabelBackground:MovieClip;
      
      public var myMapImage0:MovieClip;
      
      public var myMapImage1:MovieClip;
      
      public var myVoteButton0:LobbyVoteButton;
      
      public var myVoteButton1:LobbyVoteButton;
      
      public var myVoteButton2:LobbyVoteButton;
      
      public var mCurrentVote:int = -1;
      
      private var _roomInfo:RoomInfoObj;
      
      private var _currentIndex:int;
      
      private var m_voteMode:Boolean;
      
      private var _roomDLCLevel:uint = 0;
      
      private var _roomClashMode:int = 0;
      
      private var _resetMapList:Boolean = true;
      
      public function LobbyMatchOptionsPanel()
      {
         super();
         this.myTitleText.width = MAP_TEXT_WIDTH;
         this.myRestrictedItemsButton.myLabel.alignment = TextStyle.HALIGN_LEFT;
         this.myRestrictedItemsButton.label = Dict.ITEM_RESTRICTIONS;
         this.myRestrictedItemsButton.registerClickEvent(this.onRestrictedItemsClicked);
         this.myMapSelectionButton.gotoAndStop("Normal");
         this.myMapSelectionButton.setChangedMapCallback(this.onMapChanged);
         this.myMapImage0.myTextField0.width = MAP_TEXT_WIDTH;
         this.myMapImage0.myTextField0.alignment = TextFormatAlign.RIGHT;
         this.myMapImage1.myTextField0.width = MAP_TEXT_WIDTH;
         this.myMapImage1.myTextField0.alignment = TextFormatAlign.RIGHT;
         this.myMapImage0.myImageHolder.keepWHRatio = false;
         this.myMapImage1.myImageHolder.keepWHRatio = false;
         this.myVoteButton0.setVoteCallback(this.onVoteChanged);
         this.myVoteButton1.setVoteCallback(this.onVoteChanged);
         this.myVoteButton2.setVoteCallback(this.onVoteChanged);
         this.myVoteButton0.votingType = VoteMapType.NEXT;
         this.myVoteButton0.myTextField0.width = VOTE_BUTTON_TEXT_WIDTH;
         this.myVoteButton0.myTextField0.alignment = TextFormatAlign.RIGHT;
         this.myVoteButton1.myTextField0.width = VOTE_BUTTON_TEXT_WIDTH;
         this.myVoteButton1.myTextField0.alignment = TextFormatAlign.RIGHT;
         this.myVoteButton2.myTextField0.width = VOTE_BUTTON_TEXT_WIDTH;
         this.myVoteButton2.myTextField0.alignment = TextFormatAlign.RIGHT;
         this.myVoteButton2.myVoteButtonFrame.visible = false;
         this.myMapImage0.myImageHolder.width = MAP_IMAGE_WIDTH;
         this.myMapImage0.myImageHolder.height = MAP_IMAGE_HEIGHT;
         this.myMapImage1.myImageHolder.width = MAP_IMAGE_WIDTH;
         this.myMapImage1.myImageHolder.height = MAP_IMAGE_HEIGHT;
         EventManager.getInstance().listen(BCEvent.REFRESH_MAP_VOTING,this.onRefreshMapVotingHandle);
      }
      
      public function showPanel() : void
      {
         enabled = true;
         visible = true;
         DataManager.getInstance().bind(DataID.ROOM_INFO,this.bind_onRoomInfoUpdated,null,true,true,false);
      }
      
      public function hidePanel() : void
      {
         enabled = false;
         visible = false;
         DataManager.getInstance().unbind(DataID.ROOM_INFO,this.bind_onRoomInfoUpdated);
      }
      
      public function reupdateMapList() : void
      {
         this._resetMapList = true;
      }
      
      public function onMapChanged(mapIndex:int) : void
      {
         EventManager.getInstance().broadcast(BCEvent.CHANGE_ROOM_INFO,{
            "type":"map",
            "data":this._roomInfo.maps[mapIndex]
         });
      }
      
      public function onVoteChanged(votingType:int) : void
      {
         switch(this.mCurrentVote)
         {
            case VoteMapType.PREVIOUS:
               this.myVoteButton1.toggled = false;
               break;
            case VoteMapType.NEXT:
               this.myVoteButton0.toggled = false;
               break;
            case VoteMapType.RANDOM:
               if(this.myVoteButton2.visible)
               {
                  this.myVoteButton2.toggled = false;
               }
               else
               {
                  this.myVoteButton1.toggled = false;
               }
         }
         this.mCurrentVote = votingType;
         EventManager.getInstance().broadcast(BCEvent.VOTE_MAP,votingType);
      }
      
      public function setUpOptions() : void
      {
         this.myAdvancedOptions.SetUpOptions();
         this.myVoteButton0.toggled = false;
         this.myVoteButton1.toggled = false;
         this.myVoteButton2.toggled = false;
      }
      
      public function set mapSelectionEnabled(enabled:Boolean) : void
      {
         this.myMapSelectionButton.enabled = enabled;
      }
      
      protected function onRefreshMapVotingHandle(cEvt:ParaEvent) : void
      {
         this.roomInfo = cEvt.myPara;
      }
      
      public function set roomInfo(roomObj:RoomObj) : void
      {
         var data:Array = null;
         var newDataElement:Object = null;
         if(roomObj == null)
         {
            return;
         }
         var i:int = 0;
         this._roomInfo = roomObj.forces;
         if(this._roomDLCLevel != roomObj.roomDLCLevel)
         {
            this._roomDLCLevel = roomObj.roomDLCLevel;
            this._roomInfo.enableChangeMapBtn = this._roomInfo.showChangeMapBtn;
            this._resetMapList = true;
         }
         if(this._roomClashMode != roomObj.options.clashMode)
         {
            this._roomClashMode = roomObj.options.clashMode;
            this._resetMapList = true;
         }
         this.m_voteMode = this._roomInfo.votes.show;
         if(this._resetMapList)
         {
            this.myMapSelectionButton.visible = this._roomInfo.showChangeMapBtn;
            this.myMapSelectionButton.enabled = this._roomInfo.enableChangeMapBtn;
         }
         this.myMapInfoPanelBackground.height = BACKGROUND_NORMAL_HEIGHT;
         this.myMapSettingsBackground.visible = true;
         this.myMapImage0.myMapObstructor.visible = false;
         this.myMapImage1.myMapObstructor.visible = false;
         if(this.m_voteMode == false)
         {
            this.myTitleText.visible = this.myMapLabelBackground.visible = true;
            this.myAdvancedOptions.visible = this._roomInfo.showAdvancedOptions;
            this._currentIndex = this._roomInfo.selectedMapIndex;
            if(Boolean(this._roomInfo.maps) && Boolean(this._currentIndex < this._roomInfo.maps.length) && Boolean(this._roomInfo.maps[this._currentIndex]))
            {
               this.myMapImage0.myTextField0.visible = false;
               this.myMapImage0.myImageHolder.setImage(this._roomInfo.maps[this._currentIndex].imageURL || "");
               if(roomObj.isWarGod)
               {
                  this.myTitleText.text = DictWarGod.WARGOD_MAP_HIDDEN;
                  this.myMapImage0.myMapObstructor.visible = true;
                  this.myMapImage0.myImageHolder.visible = false;
               }
               else
               {
                  this.myTitleText.text = this._roomInfo.maps[this._currentIndex].name || "";
                  this.myMapImage0.myImageHolder.visible = true;
               }
               if(!this.myAdvancedOptions.visible)
               {
                  this.myMapInfoPanelBackground.height = BACKGROUND_SHORT_HEIGHT;
                  this.myMapSettingsBackground.visible = false;
               }
            }
            if(this._resetMapList)
            {
               this._resetMapList = false;
               if(this.myMapSelectionButton.enabled)
               {
                  data = new Array();
                  for(i = 0; i < this._roomInfo.maps.length; i++)
                  {
                     newDataElement = new Object();
                     newDataElement.name = this._roomInfo.maps[i].name || "";
                     newDataElement.id = i;
                     data.push(newDataElement);
                  }
                  this.myMapSelectionButton.setData(data);
                  this.myMapSelectionButton.setSelectedIndex(this._roomInfo.selectedMapIndex);
               }
            }
            this.myVoteButton0.visible = false;
            this.myVoteButton1.visible = false;
            this.myVoteButton2.visible = false;
            this.myMapImage1.visible = false;
         }
         else
         {
            this.myTitleText.visible = this.myAdvancedOptions.visible = this.myMapLabelBackground.visible = false;
            this.myVoteButton0.visible = this._roomInfo.votes.nextMap != null;
            this.myVoteButton1.visible = this.myMapImage1.visible = this._roomInfo.votes.previousMap != null;
            if(this.myVoteButton1.visible)
            {
               this.myVoteButton1.myVoteButtonFrame.visible = true;
               this.myVoteButton1.myHitArea.height = this.myVoteButton1.myVoteButtonFrame.height;
               this.myVoteButton2.visible = this._roomInfo.votes.randomMap != null;
            }
            else
            {
               this.myVoteButton1.myVoteButtonFrame.visible = false;
               this.myVoteButton1.myHitArea.height = 45;
               this.myVoteButton1.visible = this._roomInfo.votes.randomMap != null;
               this.myVoteButton2.visible = false;
            }
            if(this.myVoteButton0.visible)
            {
               this.myVoteButton0.myVoteText0.text = String(this._roomInfo.votes.next);
               this.myMapImage0.myImageHolder.setImage(this._roomInfo.votes.nextMap.imageURL || "");
               this.myMapImage0.myImageHolder.visible = true;
               if(roomObj.isWarGod)
               {
                  this.myMapImage0.myMapObstructor.visible = true;
                  this.myMapImage0.myImageHolder.visible = false;
               }
               this.myMapImage0.myTextField0.text = LocalizeUtil.localize(this._roomInfo.votes.nextMap.name) + " - " + LocalizeUtil.localize(this._roomInfo.votes.gameMode);
               this.myMapImage0.myTextField0.visible = true;
            }
            if(this.myVoteButton1.visible && this.myVoteButton2.visible)
            {
               this.myVoteButton1.myVoteText0.text = String(this._roomInfo.votes.previous);
               this.myMapImage1.myImageHolder.setImage(this._roomInfo.votes.previousMap.imageURL || "");
               this.myMapImage1.myTextField0.text = LocalizeUtil.localize(this._roomInfo.votes.previousMap.name) + " - " + LocalizeUtil.localize(this._roomInfo.votes.gameMode);
               this.myVoteButton2.myVoteText0.text = String(this._roomInfo.votes.random);
               this.myVoteButton1.votingType = VoteMapType.PREVIOUS;
               this.myVoteButton2.votingType = VoteMapType.RANDOM;
            }
            else
            {
               this.myVoteButton1.myVoteText0.text = String(this._roomInfo.votes.random);
               this.myVoteButton1.votingType = VoteMapType.RANDOM;
            }
            if(this.myVoteButton0.visible && this.myVoteButton1.visible && !this.myVoteButton2.visible)
            {
               this.myVoteButton0.myTextField0.text = DictRoom.MAP_VOTING_VOTE;
               this.myVoteButton1.myTextField0.text = DictRoom.MAP_VOTING_SKIP_NEXT;
               this.myMapInfoPanelBackground.height = BACKGROUND_SKIP_VOTE_HEIGHT;
               this.myMapSettingsBackground.visible = false;
            }
            if(this.myVoteButton0.visible && this.myVoteButton1.visible && this.myVoteButton2.visible)
            {
               this.myVoteButton0.myTextField0.text = DictRoom.MAP_VOTING_NEXT;
               this.myVoteButton1.myTextField0.text = DictRoom.MAP_VOTING_PRE;
               this.myVoteButton2.myTextField0.text = DictRoom.MAP_VOTING_SKIP_NEXT;
            }
            if(this.myVoteButton0.visible && this.myVoteButton1.visible && this.myVoteButton2.visible)
            {
               this.myMapInfoPanelBackground.height = BACKGROUND_ALL_VOTES_HEIGHT;
            }
         }
         this.myRestrictedItemsButton.y = this.myMapInfoPanelBackground.y + this.myMapInfoPanelBackground.height - this.myRestrictedItemsButton.height + 2;
      }
      
      private function bind_onRoomInfoUpdated(cRes:Object) : void
      {
         if(cRes.data == null)
         {
            return;
         }
         var roomObj:RoomObj = cRes.data;
         var isHost:Boolean = roomObj.forces.isHost;
         this.myAdvancedOptions.setOptionsEnabled(!roomObj.isPlayList && isHost);
         this.myRestrictedItemsButton.visible = roomObj.numItemBans > 0;
      }
      
      private function onRestrictedItemsClicked() : void
      {
         var itemList:Vector.<Object> = new Vector.<Object>();
         EventManager.getInstance().broadcast(BCEvent.SHOW_MATCH_ITEM_RESTRICTIONS,itemList);
      }
   }
}

