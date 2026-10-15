package codo.component.matchselect
{
   import codo.base.BaseView;
   import codo.common.CFunctionCommonContainer;
   import codo.component.IconButton;
   import codo.component.MarketScrollGrid;
   import codo.component.TextField;
   import codo.component.factory.ButtonFactory;
   import codo.constants.BCCommonEvent;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.constants.MsgBtnCount;
   import codo.constants.QuickMatchType;
   import codo.constants.SystemMsgPriority;
   import codo.cpp.UiCppMatchSelectView;
   import codo.cpp.UiCppView;
   import codo.cpp.UiCppViewPanel;
   import codo.localization.Dict;
   import codo.localization.DictParty;
   import codo.localization.DictRoom;
   import codo.localization.DictSystem;
   import codo.manager.DataManager;
   import codo.manager.EventManager;
   import codo.objects.MatchSelectTheatreOptionObj;
   import codo.objects.ScrollListSettings;
   import codo.objects.SystemMsgObj;
   import codo.services.MatchService;
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   
   public class MatchSelectTheatrePanel extends MatchSelectPanelBase
   {
      
      private static const CONFIRM_BUTTON_POS:Number = 699;
      
      private static const HEADER_HEIGHT:Number = 62;
      
      private static const HEADER_WIDTH:Number = 250;
      
      private static const CONFIRM_BUTTON_PADDING:Number = 21;
      
      private static const SAVE_BUTTON_PADDING:Number = 10;
      
      private static const EMPTY_TEXT_PADDING:Number = 80;
      
      private static const LIST_BACKGROUND_HEIGHT:Number = 769;
      
      private static const LIST_HEIGHT:Number = 686;
      
      private static const LIST_BACKGROUND_WIDTH:Number = 1038;
      
      private static const LIST_WIDTH:Number = 996;
      
      private static const LIST_BACKGROUND_X:Number = 116;
      
      public var myConfirmButton:IconButton;
      
      public var mySaveButton:IconButton;
      
      public var myDeleteButton:IconButton;
      
      public var myGameTypeHeader:TextField;
      
      public var mySaveCount:TextField;
      
      public var myEmptyText:TextField;
      
      public var myScrollList:MarketScrollGrid;
      
      public var myGameTypeBG:MovieClip;
      
      public var myTheatreInfo:TheatreSelectModeInfo;
      
      public function MatchSelectTheatrePanel()
      {
         super();
      }
      
      override protected function initStage() : void
      {
         var leftListSettings:ScrollListSettings = new ScrollListSettings();
         leftListSettings.orientation = ScrollListSettings.SCROLL_VERTICAL;
         leftListSettings.useNavArrows = false;
         leftListSettings.buildGridItemRenderMethod = ButtonFactory.BUILD_SELECT_THEATRE_OPTION;
         leftListSettings.itemPadding = 0;
         this.myScrollList.width = LIST_WIDTH;
         myLeftListBackground.width = LIST_BACKGROUND_WIDTH;
         this.myScrollList.height = LIST_HEIGHT;
         myLeftListBackground.height = LIST_BACKGROUND_HEIGHT;
         this.myScrollList.initGrid(leftListSettings,LIST_HEIGHT,true,1);
         this.myGameTypeHeader.width = HEADER_WIDTH;
         this.myGameTypeHeader.height = HEADER_HEIGHT;
         this.myGameTypeHeader.font = GlobalGuide.FONT_FACE_BOLD;
         this.myGameTypeHeader.fontSize = GlobalGuide.FONT_SIZE_SMALL;
         this.myGameTypeHeader.text = "@SF_UI_THEATER_AVAILABLE_REPLAYS";
         this.myGameTypeBG.myBackground.width = myLeftListBackground.width;
         this.mySaveCount.width = HEADER_WIDTH;
         this.mySaveCount.height = HEADER_HEIGHT;
         this.mySaveCount.font = GlobalGuide.FONT_FACE_BOLD;
         this.mySaveCount.fontSize = GlobalGuide.FONT_SIZE_SMALL;
         this.mySaveCount.alignment = TextStyle.HALIGN_RIGHT;
         this.myEmptyText.text = "@SF_UI_THEATER_LIST_EMPTY";
         this.myEmptyText.x = LIST_BACKGROUND_X + EMPTY_TEXT_PADDING;
         this.myEmptyText.width = LIST_BACKGROUND_WIDTH - EMPTY_TEXT_PADDING * 2;
         this.myEmptyText.alignment = TextStyle.HALIGN_CENTER;
         this.myConfirmButton.label = "@SF_UI_THEATER_BEGIN_REPLAY";
         this.myConfirmButton.setImage("information_icon.tga");
         this.myConfirmButton.registerClickEvent(this.onStartDemoClick);
         this.myConfirmButton.setMarketReadyMode(true);
         this.myConfirmButton.x = this.myTheatreInfo.x + this.myTheatreInfo.width - (this.myConfirmButton.width + CONFIRM_BUTTON_PADDING);
         this.myConfirmButton.y = CONFIRM_BUTTON_POS;
         this.mySaveButton.setIconPadding(11);
         this.mySaveButton.label = Dict.SAVE;
         this.mySaveButton.setImage("save_icon");
         this.mySaveButton.registerClickEvent(this.onFavouriteClick);
         this.mySaveButton.setMarketReadyMode(true);
         this.mySaveButton.x = this.myTheatreInfo.x;
         this.mySaveButton.y = this.myConfirmButton.y;
         this.mySaveButton.visible = true;
         this.myDeleteButton.setIconPadding(11);
         this.myDeleteButton.label = Dict.DELETE;
         this.myDeleteButton.setImage("trash_icon");
         this.myDeleteButton.registerClickEvent(this.onDeleteClick);
         this.myDeleteButton.setMarketReadyMode(true);
         this.myDeleteButton.x = this.mySaveButton.x + this.mySaveButton.width + SAVE_BUTTON_PADDING;
         this.myDeleteButton.y = this.myConfirmButton.y;
         this.myDeleteButton.visible = true;
         this.refreshGameMoments();
      }
      
      override protected function enableData() : void
      {
         super.enableData();
         var matchType:QuickMatchType = QuickMatchType.makeTheatre();
         EventManager.getInstance().broadcast(BCEvent.EVT_SET_MATCH_TYPE,matchType);
      }
      
      override protected function disableData() : void
      {
         super.disableData();
      }
      
      public function getSelectedOption() : MatchSelectTheatreOptionObj
      {
         return this.myScrollList.selectedData as MatchSelectTheatreOptionObj;
      }
      
      public function refreshSavedCounter(count:int) : void
      {
         this.mySaveCount.text = count + "/20 " + LocalizeUtil.localize("@SF_UI_THEATER_SAVED_FILES");
      }
      
      public function refreshGameMoments() : void
      {
         if(Boolean(CFunctionCommonContainer.GameMomentsIsLastMatchRecorded()))
         {
            EventManager.getInstance().broadcast(BCCommonEvent.EVT_GAMEMOMENTS_EDIT);
         }
      }
      
      public function selectTheatreOption(data:MatchSelectTheatreOptionObj = null) : void
      {
         if(data == null)
         {
            data = this.getSelectedOption();
         }
         this.myConfirmButton.visible = this.mySaveButton.visible = this.myDeleteButton.visible = true;
         this.myTheatreInfo.updateMatchInfo(data);
         this.mySaveButton.enabled = !data.saved;
         this.mySaveButton.alpha = data.saved ? 0.5 : 1;
      }
      
      public function clearTheatreOption() : void
      {
         this.myConfirmButton.visible = this.mySaveButton.visible = this.myDeleteButton.visible = false;
         this.myTheatreInfo.clearMatchInfo();
      }
      
      override protected function setMarketReady(ready:Boolean) : void
      {
         super.setMarketReady(ready);
      }
      
      private function onStartDemoClick() : void
      {
         if(MatchService.getInstance().isInRoom)
         {
            BaseView.staticShowMsg(DictRoom.NOTE_ALREADY_IN_RANKED_MATCH,MsgBtnCount.ONE);
            return;
         }
         if(Boolean(DataManager.getInstance().getDP(DataID.IS_IN_PARTY)))
         {
            BaseView.staticShowMsg("@SF_UI_THEATER_NO_PARTY",MsgBtnCount.TWO,0,null,DictSystem.CANCEL,this.leaveParty,DictParty.LEAVE_PARTY);
            return;
         }
         (_view.getUiCpp() as UiCppMatchSelectView).StartDemo();
      }
      
      private function leaveParty() : void
      {
         EventManager.getInstance().broadcast(BCEvent.PARTY_LEAVE);
      }
      
      private function onFavouriteClick() : void
      {
         (_view.getUiCpp() as UiCppMatchSelectView).FavouriteDemo();
      }
      
      private function onDeleteClick() : void
      {
         var systemMsg:SystemMsgObj = SystemMsgObj.getObj("@SF_UI_DELETE_DEMO_WARNING",2,SystemMsgPriority.NORMAL,this.onDeleteConfirm,Dict.CONFIRM,null,Dict.CANCEL,null,"",0,0,DictSystem.WARNING);
         EventManager.getInstance().broadcast(BCEvent.EVT_SHOW_SYSTEM_MSG,systemMsg);
      }
      
      private function onDeleteConfirm() : void
      {
         (_view.getUiCpp() as UiCppMatchSelectView).DeleteDemo();
      }
      
      override protected function makeUiCpp() : UiCppView
      {
         return new UiCppViewPanel(this);
      }
   }
}

