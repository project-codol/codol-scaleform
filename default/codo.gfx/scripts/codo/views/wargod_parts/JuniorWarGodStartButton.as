package codo.views.wargod_parts
{
   import codo.component.CallToActionButton;
   import codo.component.IconButton;
   import codo.constants.DataID;
   import codo.localization.DictRoom;
   import codo.localization.DictWarGod;
   import codo.manager.DataManager;
   import codo.objects.PlayerWarGodRank;
   import codo.objects.WarGodGlobalSettingObj;
   import codo.objects.WarGodPlayerObj;
   import codo.objects.WarGodPlaylistObj;
   import codo.objects.WarGodSeasonObj;
   import codo.utils.LocalizeUtil;
   import codo.utils.WarGodUtility;
   import flash.display.MovieClip;
   import flash.geom.Point;
   
   public class JuniorWarGodStartButton extends MovieClip implements IWarGodUIElement
   {
      
      private static const BUTTON_WIDTH:int = 220;
      
      private static const BUTTON_HEIGHT:int = 52;
      
      private static const BUTTON_GAP:int = 9;
      
      private static const BUTTON_LIST_GAP:int = 5;
      
      public var myConfigButton:IconButton;
      
      public var myStartButton:CallToActionButton;
      
      public var myPlaylistSelector:WarGodPlaylistSelectList;
      
      public var myHint:MovieClip;
      
      private var mOptionChangeCallback:Function;
      
      private var mOpenStateChangeCallback:Function;
      
      private var mHintShown:Boolean = false;
      
      public function JuniorWarGodStartButton()
      {
         super();
         this.myConfigButton.customIconButtonSize = new Point(BUTTON_HEIGHT,BUTTON_HEIGHT);
         this.myConfigButton.setImage("setting_icon");
         this.myConfigButton.setMarketReadyMode(true);
         this.myStartButton.label = LocalizeUtil.localize(DictRoom.JOIN);
         this.myStartButton.width = BUTTON_WIDTH;
         this.myStartButton.height = BUTTON_HEIGHT;
         this.myStartButton.x = this.myConfigButton.x + BUTTON_HEIGHT + BUTTON_GAP;
         this.myStartButton.y = 0;
         this.myStartButton.myLabel.fontSize = 28;
         this.myHint.myTF.text = DictWarGod.START_BUTTON_HINT;
         this.myHint.myTF.width = this.myHint.myTF.textWidth + 10;
         this.myHint.myBg.width = this.myHint.myTF.x + this.myHint.myTF.width + 10;
         this.myHint.x = this.myConfigButton.x - this.myHint.width - 20;
         this.myHint.visible = false;
         this.myPlaylistSelector.visible = false;
         this.myConfigButton.registerClickEvent(this.onConfigButtonClicked);
         this.myPlaylistSelector.registerSelectionChangeEvent(this.onSelectionChangeEvent);
      }
      
      public function setData(seasonObj:WarGodSeasonObj, playerObj:WarGodPlayerObj, globalSetting:WarGodGlobalSettingObj) : void
      {
         if(WarGodUtility.isJuniorWarGod(playerObj))
         {
            this.updatePlaylist();
            if(playerObj.warGodRank.tier == PlayerWarGodRank.TIER_JWG2 && playerObj.warGodRank.division <= PlayerWarGodRank.DIVISION_TWO && !this.mHintShown)
            {
               this.myHint.visible = true;
            }
         }
         else
         {
            this.updateSeniorWarGodPlaylist();
         }
      }
      
      public function updatePlaylist() : void
      {
         var playlistWrapper:WarGodPlaylistObj = DataManager.getInstance().getDP(DataID.GET_JUNIOR_WARGOD_MATCHMAKING_PLAYLIST);
         this.myPlaylistSelector.setPlaylist(playlistWrapper);
         this.myPlaylistSelector.y = this.myConfigButton.y - this.myPlaylistSelector.height - BUTTON_LIST_GAP;
      }
      
      public function deactive() : void
      {
         if(this.myPlaylistSelector.visible)
         {
            this.togglePlaylistSelector();
         }
      }
      
      public function updateSeniorWarGodPlaylist() : void
      {
         this.myPlaylistSelector.setSeniorWarGodPlaylist();
         this.myPlaylistSelector.y = this.myConfigButton.y - this.myPlaylistSelector.height - BUTTON_LIST_GAP;
      }
      
      private function togglePlaylistSelector() : void
      {
         this.myPlaylistSelector.visible = !this.myPlaylistSelector.visible;
         if(this.mOpenStateChangeCallback is Function)
         {
            this.mOpenStateChangeCallback(this.myPlaylistSelector.visible);
         }
      }
      
      public function registerOptionChangeEvent(callback:Function) : void
      {
         this.mOptionChangeCallback = callback;
      }
      
      public function registerOptionOpenStateChange(callback:Function) : void
      {
         this.mOpenStateChangeCallback = callback;
      }
      
      public function forceOpenPlaylistSelector() : void
      {
         if(!this.myPlaylistSelector.visible)
         {
            this.togglePlaylistSelector();
         }
      }
      
      private function onConfigButtonClicked() : void
      {
         this.togglePlaylistSelector();
         this.myHint.visible = false;
         this.mHintShown = true;
      }
      
      private function onSelectionChangeEvent(data:WarGodPlaylistObj) : void
      {
         if(Boolean(this.mOptionChangeCallback is Function) && Boolean(data) && !data.othersPlaylist)
         {
            this.mOptionChangeCallback(data.playlist);
         }
      }
   }
}

