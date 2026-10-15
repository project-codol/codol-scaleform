package codo.views
{
   import codo.common.CFunctionCommonContainer;
   import codo.component.Button;
   import codo.component.ScrollList;
   import codo.component.lobby.ZombieChampionDetailInGame;
   import codo.component.lobby.ZombieChampionListItem;
   import codo.constants.BCInGameEvent;
   import codo.constants.DataInGameID;
   import codo.objects.ScrollListSettings;
   import codo.objects.ZombieChampionObj;
   import codo.style.GlobalGuide;
   import codo.utils.PauseUtil;
   
   public class PauseMenuZombieSurvivalView extends FsgPauseMenuBaseView
   {
      
      private static const FRAME_HEIGHT:Number = 706;
      
      private static const BUTTON_Y:Number = 855;
      
      private static const SELECTION_OFFSET_Y:Number = -170;
      
      public var myScrollList:ScrollList;
      
      public var myZombieChampionDetailPanel:ZombieChampionDetailInGame;
      
      private var mCurrChampionIdx:int;
      
      public function PauseMenuZombieSurvivalView()
      {
         super();
      }
      
      override protected function onInit() : void
      {
         super.onInit();
         this.initChampList();
      }
      
      private function initChampList() : void
      {
         var champion:ZombieChampionObj = null;
         var listSettings:ScrollListSettings = new ScrollListSettings();
         listSettings.orientation = ScrollListSettings.SCROLL_HORIZONTAL;
         listSettings.useNavArrows = false;
         listSettings.itemLinkage = "codo.shared.pause.ZombieChampionListItem";
         listSettings.itemPadding = 5;
         this.myScrollList.settings = listSettings;
         this.myScrollList.width = 800;
         this.myScrollList.height = 600;
         this.myScrollList.selectionChangeCallback = this.onFilterItemClicked;
         this.myScrollList.x = myFrame.x;
         this.myScrollList.y = myFrame.y + 40;
         var listData:Vector.<Object> = new Vector.<Object>();
         var len:int = int(ZombieChampionObj.ORDERED_CLASSES.length);
         for(var i:int = 0; i < len; i++)
         {
            champion = CFunctionCommonContainer.AS_GetZombieChampionForClassID(ZombieChampionObj.ORDERED_CLASSES[i]) as ZombieChampionObj;
            champion.index = i;
            listData.push(champion);
         }
         this.myScrollList.addItemsByVector(listData);
      }
      
      private function playerHasSelectedChampion() : Boolean
      {
         return getDP(DataInGameID.HIDE_CLASS_SELECTION_MENU);
      }
      
      override protected function showView() : void
      {
         var selectedChampID:uint = 0;
         var len:int = 0;
         var i:int = 0;
         var button:Button = null;
         var champion:ZombieChampionObj = null;
         super.showView();
         myTitle.y = 100;
         selectedChampID = CFunctionCommonContainer.AS_GetSelectedChampionClassID();
         if(this.playerHasSelectedChampion())
         {
            this.myScrollList.visible = false;
            this.showChampionInfo(selectedChampID);
         }
         else
         {
            this.myZombieChampionDetailPanel.hide();
            this.myScrollList.visible = true;
            len = this.myScrollList.numberOfItems;
            for(i = 0; i < len; i++)
            {
               button = this.myScrollList.getItem(i) as Button;
               champion = button.getData() as ZombieChampionObj;
               if(selectedChampID == champion.id)
               {
                  this.mCurrChampionIdx = champion.index;
                  button.setToggled(true);
                  this.myScrollList.selectedIndex = i;
               }
               else
               {
                  button.setToggled(false);
               }
            }
         }
         myTabNavigation.visible = false;
         PauseUtil.disableMap();
      }
      
      override protected function refreshLayout() : void
      {
         super.refreshLayout();
         if(this.playerHasSelectedChampion())
         {
            myFrame.visible = false;
            myFrame.height = FRAME_HEIGHT;
            myOptions.visible = myQTBtn.visible = myComplainsBtn.visible = myRecordBtn.visible = true;
            myQuitBtn.y = myBackBtn.y = BUTTON_Y;
            myTitle.fontColor = GlobalGuide.CODO_BLACK;
         }
         else
         {
            myFrame.visible = true;
            myFrame.height = FRAME_HEIGHT + SELECTION_OFFSET_Y;
            myOptions.visible = myQTBtn.visible = myComplainsBtn.visible = myRecordBtn.visible = false;
            myQuitBtn.y = myBackBtn.y = BUTTON_Y + SELECTION_OFFSET_Y;
            myTitle.fontColor = GlobalGuide.WHITE;
         }
         gotoAndStop(1);
         myFrame.x = myTitle.x = 67;
         myFrame.width = FRAME_WIDTH;
      }
      
      override protected function backToGame() : void
      {
         var champion:ZombieChampionObj = null;
         if(!this.playerHasSelectedChampion())
         {
            broadcast(BCInGameEvent.SELECT_WEAPON_LOADOUT,this.mCurrChampionIdx);
            champion = CFunctionCommonContainer.AS_GetZombieChampionForClassID(ZombieChampionObj.ORDERED_CLASSES[this.mCurrChampionIdx]) as ZombieChampionObj;
            CFunctionCommonContainer.AS_SelectChampionByClassID(champion.id);
         }
         broadcast(BCInGameEvent.BACK_TO_GAME);
      }
      
      private function onFilterItemClicked() : void
      {
         var btn:ZombieChampionListItem = this.myScrollList.getSelectedItem() as ZombieChampionListItem;
         var champion:ZombieChampionObj = btn.getData() as ZombieChampionObj;
         this.mCurrChampionIdx = champion.index;
         myTitle.text = champion.name;
      }
      
      private function showChampionInfo(selectedID:int) : void
      {
         var champion:ZombieChampionObj = CFunctionCommonContainer.AS_GetZombieChampionForClassID(selectedID) as ZombieChampionObj;
         myTitle.text = champion.name;
         this.myZombieChampionDetailPanel.show(champion);
      }
   }
}

