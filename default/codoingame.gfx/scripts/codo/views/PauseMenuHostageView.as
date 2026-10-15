package codo.views
{
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionInGameContainer;
   import codo.component.ItemPreviewBox;
   import codo.component.ScrollGrid;
   import codo.component.TextField;
   import codo.component.loadout.HostageChampionListItem;
   import codo.component.loadout.HostageChampionListPlayerNameTip;
   import codo.component.loadout.HostageCustomizationListItem;
   import codo.constants.BCInGameEvent;
   import codo.constants.Common;
   import codo.constants.DataInGameID;
   import codo.constants.GameInfo;
   import codo.event.ParaEvent;
   import codo.objects.HostageChampionObj;
   import codo.objects.ProductObj;
   import codo.objects.ScrollListSettings;
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   import codo.utils.PauseUtil;
   import flash.display.MovieClip;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   
   public class PauseMenuHostageView extends FsgPauseMenuBaseView
   {
      
      public var myScrollList:ScrollGrid;
      
      public var myFaction:TextField;
      
      public var myFactionBG:MovieClip;
      
      public var myTimeLeftLabel:TextField;
      
      public var myTimeLeftValue:TextField;
      
      public var myTimeLeftBG:MovieClip;
      
      public var myCustomizationList:ScrollGrid;
      
      public var myCustomizationBG:MovieClip;
      
      public var myItemPreviewBox:ItemPreviewBox;
      
      public var myNameToolTip:HostageChampionListPlayerNameTip;
      
      private var mCurrChampionIdx:int = 0;
      
      private var mCurrCustomizeIdx:int = 0;
      
      private var _selectionDebounce:Timer;
      
      private var _inSelectionDebounce:Boolean;
      
      private var _inPrematch:Boolean;
      
      private var _selectionCounts:Array = [];
      
      private var _hitTestPoint:Point = new Point();
      
      private var _mouseHitItem:HostageChampionListItem = null;
      
      private var _weaponSelectionDict:Dictionary = new Dictionary();
      
      private var _isAttacking:Boolean = false;
      
      public function PauseMenuHostageView()
      {
         super();
      }
      
      override protected function onInit() : void
      {
         super.onInit();
         var listSettings:ScrollListSettings = new ScrollListSettings();
         listSettings.orientation = ScrollListSettings.SCROLL_VERTICAL;
         listSettings.useNavArrows = false;
         listSettings.itemLinkage = "codo.shared.pause.HostageChampionListItem";
         listSettings.itemPadding = 10;
         this.myScrollList.initGrid(listSettings,2,false,3);
         this.myScrollList.width = 800;
         this.myScrollList.height = 600;
         this.myScrollList.selectionChangeCallback = this.onListItemClicked;
         this.myScrollList.visible = false;
         var listSettings2:ScrollListSettings = new ScrollListSettings();
         listSettings2.orientation = ScrollListSettings.SCROLL_VERTICAL;
         listSettings2.useNavArrows = false;
         listSettings2.itemLinkage = "codo.shared.pause.HostageCustomizationListItem";
         listSettings2.itemPadding = 5;
         this.myCustomizationList.initGrid(listSettings2,2,false,2);
         this.myCustomizationList.width = 455;
         this.myCustomizationList.height = 411;
         this.myCustomizationList.visible = false;
         this.myCustomizationList.listItemClickCallback = this.onSelectCustomization;
         this.myCustomizationList.listItemFocusCallback = this.onCustomizationListItemFocused;
         this.myCustomizationList.listItemUnfocusCallback = this.onCustomizationListItemUnfocused;
         this.myCustomizationBG.x = GameInfo.stagePosition.x;
         this.myCustomizationBG.y = GameInfo.stagePosition.y;
         this.myCustomizationBG.width = GameInfo.stageSize.x;
         this.myCustomizationBG.height = GameInfo.stageSize.y;
         this.myCustomizationBG.visible = false;
         this.myFaction.font = GlobalGuide.FONT_FACE_BOLD;
         this.myFaction.fontSize = GlobalGuide.FONT_SIZE_MEDIUM;
         this.myFaction.alignment = TextStyle.HALIGN_CENTER;
         this.myFaction.width = 256;
         this.myFaction.visible = this.myFactionBG.visible = false;
         this.myTimeLeftLabel.width = 200;
         this.myTimeLeftValue.font = GlobalGuide.FONT_FACE_NUMBERS;
         this.myTimeLeftValue.fontSize = GlobalGuide.FONT_SIZE_MEDIUM;
         this.myTimeLeftValue.alignment = TextStyle.HALIGN_CENTER;
         this.myTimeLeftValue.width = 200;
         this.myTimeLeftLabel.visible = this.myTimeLeftValue.visible = this.myTimeLeftBG.visible = false;
         this.myTimeLeftLabel.text = "@UI_HUD_PURCHASING_TIME_LEFT";
         this._selectionDebounce = new Timer(100,1);
         this._selectionDebounce.addEventListener(TimerEvent.TIMER,this.onSelectionDebounceComplete);
         this._inSelectionDebounce = false;
         this._inPrematch = false;
         myOptions.myTitleTF.visible = false;
         this.myNameToolTip.visible = false;
      }
      
      override protected function onInitListener() : void
      {
         super.onInitListener();
         bind(DataInGameID.SD_ATTACKING,this.bindAttacking);
         bind(DataInGameID.SD_PREMATCH_TIMER,this.bindPrematchTimer);
         bind(DataInGameID.CHAMPION_SELECTIONS,this.bindChampionSelections);
         listen(BCInGameEvent.EVT_HOSTAGE_CUSTOMIZE_CHAMPION,this.onCustomizeChampion);
         addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
         addEventListener(MouseEvent.ROLL_OUT,this.mouseRollOutHandler);
      }
      
      override protected function showView() : void
      {
         super.showView();
         myTitle.y = m_cachedTitleY - 10;
         myTabNavigation.visible = false;
         PauseUtil.disableMap();
      }
      
      override protected function refreshLayout() : void
      {
         super.refreshLayout();
         gotoAndStop(1);
         myTitle.x = 68;
         myTabNavigation.x = myFrame.x = 67;
         myFrame.width = 1207;
         myFrame.height = 742;
      }
      
      override protected function backToGame() : void
      {
         broadcast(BCInGameEvent.BACK_TO_GAME);
      }
      
      override public function onKeyboardEvent(cEvt:KeyboardEvent) : void
      {
         if(cEvt.keyCode == Keyboard.ESCAPE && this.myCustomizationList.visible)
         {
            this.myCustomizationList.visible = this.myCustomizationBG.visible = false;
         }
         else
         {
            super.onKeyboardEvent(cEvt);
         }
      }
      
      private function onListItemClicked() : void
      {
         var paraString:String = null;
         var savedWeaponSelection:Object = null;
         if(this._inSelectionDebounce || !this._inPrematch)
         {
            return;
         }
         this._inSelectionDebounce = true;
         this._selectionDebounce.reset();
         this._selectionDebounce.start();
         this.myScrollList.mouseChildren = false;
         var champion:HostageChampionObj = this.getSelectedChampion();
         if(this.mCurrChampionIdx != champion.id)
         {
            paraString = champion.id.toString();
            savedWeaponSelection = this.withdrawWeaponSelection(champion.id);
            if(savedWeaponSelection != null)
            {
               paraString = paraString + "|" + String(savedWeaponSelection as int);
            }
            CFunctionCommonContainer.ScriptMenuResponse("hostage_changeclass",paraString);
            this.setLocalChampionSelected(champion.id);
         }
         myTitle.text = champion.name;
      }
      
      private function onSelectCustomization(item:HostageCustomizationListItem) : void
      {
         if(this._inSelectionDebounce || !this._inPrematch)
         {
            return;
         }
         this._inSelectionDebounce = true;
         this._selectionDebounce.reset();
         this._selectionDebounce.start();
         this.myScrollList.mouseChildren = false;
         var weapon:ProductObj = item.getData() as ProductObj;
         this.saveWeaponSelection(this.mCurrCustomizeIdx,weapon.id);
         CFunctionCommonContainer.ScriptMenuResponse("hostage_changeclass",this.mCurrCustomizeIdx.toString() + "|" + weapon.id.toString());
         this.myCustomizationList.visible = this.myCustomizationBG.visible = false;
      }
      
      private function bindAttacking(cRes:Object) : void
      {
         var newIsAttacking:Boolean = Boolean(cRes.data);
         if(this._isAttacking != newIsAttacking)
         {
            this._isAttacking = newIsAttacking;
            this.mCurrChampionIdx = 0;
            this._weaponSelectionDict = new Dictionary();
         }
         if(this._isAttacking)
         {
            this.myFactionBG.gotoAndStop(1);
            this.myFaction.text = "@UI_HUD_SDP_ATTACKER";
         }
         else
         {
            this.myFactionBG.gotoAndStop(2);
            this.myFaction.text = "@UI_HUD_SDP_DEFENDER";
         }
         this.myFactionBG.width = this.myFaction.textWidth + 40;
         this.myFactionBG.x = this.myFaction.x + this.myFaction.width * 0.5 - this.myFactionBG.width * 0.5;
         this.myFaction.visible = this.myFactionBG.visible = true;
         var listData:Vector.<Object> = Vector.<Object>(CFunctionInGameContainer.AS_HostageGetChampionList(this._isAttacking));
         this.myScrollList.addItemsByVector(listData);
         this.myScrollList.selectedIndex = this.mCurrChampionIdx;
         this.myScrollList.visible = true;
         var champion:HostageChampionObj = this.getSelectedChampion();
         myTitle.text = champion.name;
         this.refreshSelections();
      }
      
      private function bindPrematchTimer(cRes:Object) : void
      {
         var time:int = int(cRes.data);
         this._inPrematch = time > 0;
         this.myTimeLeftValue.text = time.toString();
         this.myTimeLeftLabel.visible = this.myTimeLeftValue.visible = this.myTimeLeftBG.visible = this._inPrematch;
         this.myScrollList.mouseChildren = this._inPrematch && !this._inSelectionDebounce;
         if(!this._inPrematch && this.myCustomizationList.visible)
         {
            this.myCustomizationList.visible = this.myCustomizationBG.visible = false;
         }
      }
      
      private function bindChampionSelections(cRes:Object) : void
      {
         this._selectionCounts = cRes.data;
         this.addSelfSelection();
         this.refreshSelections();
      }
      
      private function addSelfSelection() : void
      {
         var mySelectedChampion:Object = this._selectionCounts[this.mCurrChampionIdx];
         if(null == mySelectedChampion)
         {
            mySelectedChampion = new Object();
            mySelectedChampion.count = 1;
            mySelectedChampion.members = [CFunctionCommonContainer.GetPlayerName().name];
            this._selectionCounts[this.mCurrChampionIdx] = mySelectedChampion;
         }
         else
         {
            ++mySelectedChampion.count;
            mySelectedChampion.members.push(CFunctionCommonContainer.GetPlayerName().name);
         }
      }
      
      private function setLocalChampionSelected(selection:int) : void
      {
         var champion:HostageChampionObj = null;
         this.mCurrChampionIdx = selection;
         if(this.myScrollList.numberOfItems > this.mCurrChampionIdx)
         {
            this.myScrollList.selectedIndex = this.mCurrChampionIdx;
            champion = this.getSelectedChampion();
            myTitle.text = champion.name;
         }
      }
      
      private function onCustomizeChampion(cEvt:ParaEvent) : void
      {
         var champion:HostageChampionObj = null;
         var item:ProductObj = null;
         var listData:Vector.<Object> = null;
         champion = cEvt.myPara;
         var baseWeapon:int = champion.primary[HostageChampionListItem.WEAPON_INDEX].baseID > 0 ? champion.primary[HostageChampionListItem.WEAPON_INDEX].baseID : champion.primary[HostageChampionListItem.WEAPON_INDEX].id;
         var variants:Array = CFunctionCommonContainer.AS_GetWeaponVariantList(baseWeapon,Common.LIST_TYPE_All,ProductObj.TIER_EPIC);
         if(variants.length < 2)
         {
            return;
         }
         for each(item in variants)
         {
            if(item.id == champion.primary[HostageChampionListItem.WEAPON_INDEX].id)
            {
               item.stackNumber = 1;
               break;
            }
         }
         listData = Vector.<Object>(variants);
         listData.sort(this.sortByTier);
         listData.sort(this.sortByOwned);
         this.myCustomizationList.addItemsByVector(listData);
         this.myCustomizationList.visible = this.myCustomizationBG.visible = true;
         this.mCurrCustomizeIdx = champion.id;
      }
      
      private function onSelectionDebounceComplete(e:TimerEvent) : void
      {
         this._inSelectionDebounce = false;
         this.myScrollList.mouseChildren = this._inPrematch;
      }
      
      private function refreshSelections() : void
      {
         var item:HostageChampionListItem = null;
         var listLen:int = this.myScrollList.numberOfItems;
         var dataLen:int = int(this._selectionCounts.length);
         var i:int = 0;
         while(i < listLen && i < dataLen)
         {
            item = this.myScrollList.getItem(i) as HostageChampionListItem;
            item.setSelection(this._selectionCounts[i]);
            i++;
         }
         this.forceUpdateTooltipDisplay();
      }
      
      private function getSelectedChampion() : HostageChampionObj
      {
         var btn:HostageChampionListItem = this.myScrollList.getSelectedItem() as HostageChampionListItem;
         return new HostageChampionObj(btn.getData());
      }
      
      private function onCustomizationListItemFocused(item:Object) : void
      {
         var prodData:ProductObj = null;
         if(null != item)
         {
            prodData = item as ProductObj;
            this.myItemPreviewBox.setItemData(prodData);
            this.myItemPreviewBox.showBox();
         }
      }
      
      private function onCustomizationListItemUnfocused(item:Object) : void
      {
         this.myItemPreviewBox.hideBox();
      }
      
      private function sortByTier(a:Object, b:Object) : int
      {
         var prodA:ProductObj = a as ProductObj;
         var prodB:ProductObj = b as ProductObj;
         return prodA.tier - prodB.tier;
      }
      
      private function sortByOwned(a:Object, b:Object) : int
      {
         var prodA:ProductObj = a as ProductObj;
         var prodB:ProductObj = b as ProductObj;
         if(prodA.isOwned() != prodB.isOwned())
         {
            return prodA.isOwned() ? -1 : 1;
         }
         return 0;
      }
      
      private function forceUpdateTooltipDisplay() : void
      {
         this.updateTooltipDisplay(this._mouseHitItem);
      }
      
      private function updateTooltipDisplay(target:HostageChampionListItem) : Boolean
      {
         var selections:Object = null;
         var needShow:Boolean = false;
         if(Boolean(target))
         {
            selections = target.getSelection();
            if(Boolean(selections) && Boolean(selections.members) && selections.members.length > 0)
            {
               this.myNameToolTip.setNames(selections.members);
               needShow = true;
            }
         }
         return needShow;
      }
      
      private function mouseMoveHandler(e:MouseEvent) : void
      {
         var item:HostageChampionListItem = null;
         var localPoint:Point = null;
         var needShow:Boolean = false;
         var numItems:int = this.myScrollList.numberOfItems;
         for(var i:int = 0; i < numItems; i++)
         {
            item = this.myScrollList.getItem(i) as HostageChampionListItem;
            if(Boolean(item) && item.hitTestPoint(e.stageX,e.stageY))
            {
               this._mouseHitItem = item;
               this._hitTestPoint.x = e.stageX + 5;
               this._hitTestPoint.y = e.stageY + 5;
               localPoint = globalToLocal(this._hitTestPoint);
               this.myNameToolTip.x = localPoint.x;
               this.myNameToolTip.y = localPoint.y;
               needShow = this.updateTooltipDisplay(this._mouseHitItem);
               break;
            }
         }
         this.myNameToolTip.visible = needShow;
      }
      
      private function mouseRollOutHandler(e:MouseEvent) : void
      {
         this.myNameToolTip.visible = false;
      }
      
      private function saveWeaponSelection(championIndex:int, weaponId:int) : void
      {
         this._weaponSelectionDict[championIndex] = weaponId;
      }
      
      private function withdrawWeaponSelection(championIndex:int) : Object
      {
         return this._weaponSelectionDict[championIndex];
      }
   }
}

