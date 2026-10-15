package codo.views
{
   import codo.common.CFunctionCommonContainer;
   import codo.event.ListEvent;
   import codo.localization.Dict;
   import codo.localization.DictMarket;
   import codo.objects.AsymPvpLoadoutObj;
   import codo.utils.AsymPvpUtil;
   import codo.utils.GraphicUtil;
   import codo.utils.PauseUtil;
   import codo.utils.ScaleformUtil;
   import components.CodoList;
   import components.asym.AsymAbilityList;
   import components.asym.AsymMonsterLoadoutLocked;
   import components.asym.AsymRobotsList;
   import components.asympvp_part.AsymMonsterLoadoutListItem;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import fsg.util.FsgImageHolder;
   
   public class PauseMenuAsymView extends FsgPauseMenuBaseView
   {
      
      private static const DEFAULT_LOADOUT_INDEX:uint = 0;
      
      private var mSelectedLoadoutIndex:uint = 0;
      
      private var mDataCheckTimer:Timer;
      
      private var mIsLoadoutOnly:Boolean;
      
      public var myLoadoutList:AsymRobotsList;
      
      public var myLockedIcon:AsymMonsterLoadoutLocked;
      
      public var myImage:FsgImageHolder;
      
      public var myAbilitiesList:AsymAbilityList;
      
      public function PauseMenuAsymView()
      {
         super();
         this.myLoadoutList.addEventListener(CodoList.EVT_LINE_ROLLOVER,this.onLoadoutItemFocused);
         this.myLoadoutList.addEventListener(CodoList.EVT_LINE_ROLLOUT,this.onListRollOut);
         this.myLoadoutList.addEventListener(CodoList.EVT_LINE_CLICK,this.onLoadoutClick);
         this.myLoadoutList.setRows(5);
         this.myAbilitiesList.setKeys();
         myTitle.visible = this.myLockedIcon.visible = false;
         _currentClassIndex = 0;
      }
      
      override public function set routeData(data:*) : void
      {
         this.mIsLoadoutOnly = data as Boolean;
         this.myImage.x = this.mIsLoadoutOnly ? 400 : 146;
      }
      
      override protected function onInit() : void
      {
         super.onInit();
         myOptions.setTitle("");
      }
      
      override protected function onInitListener() : void
      {
         super.onInitListener();
      }
      
      override protected function displayLoadoutDetail(classIdx:int) : void
      {
         var defaultLoadout:AsymPvpLoadoutObj = null;
         var dataAvailable:Boolean = CFunctionCommonContainer.Dvar_GetBool("ui_inventory_received") as Boolean;
         var loadouts:Array = AsymPvpUtil.instance.getClassLoadouts(classIdx);
         if(ScaleformUtil.isScaleform)
         {
            defaultLoadout = loadouts[DEFAULT_LOADOUT_INDEX];
            if(defaultLoadout != null)
            {
               defaultLoadout.isPurchased = true;
               defaultLoadout.isPurchaseable = false;
            }
         }
         if(!dataAvailable)
         {
            if(this.mDataCheckTimer == null)
            {
               this.mDataCheckTimer = new Timer(1000,0);
               this.mDataCheckTimer.addEventListener(TimerEvent.TIMER,this.updateBotList);
               this.mDataCheckTimer.start();
               AsymPvpUtil.instance.setLoadoutsAvailable(false);
            }
         }
         this.myLoadoutList.dataProvider = loadouts;
         var loadoutIndex:int = AsymPvpUtil.instance.getSelectedLoadout(classIdx);
         this.myLoadoutList.selectedIndex = loadoutIndex;
         var data:AsymPvpLoadoutObj = AsymPvpUtil.instance.getSelectedLoadoutObj(classIdx);
         if(data == null)
         {
            return;
         }
         this.myAbilitiesList.setData(data);
         this.setBotImage(data.image);
         this.setLockedState(data,loadoutIndex == DEFAULT_LOADOUT_INDEX);
      }
      
      private function updateBotList(e:TimerEvent) : void
      {
         var dataAvailable:Boolean = CFunctionCommonContainer.Dvar_GetBool("ui_inventory_received") as Boolean;
         if(dataAvailable)
         {
            this.mDataCheckTimer.stop();
            this.mDataCheckTimer.removeEventListener(TimerEvent.TIMER,this.updateBotList);
            this.mDataCheckTimer = null;
            AsymPvpUtil.instance.setLoadoutsAvailable(true);
            this.myLoadoutList.refresh();
            this.myLoadoutList.selectedIndex = 0;
         }
      }
      
      private function setLockedState(data:AsymPvpLoadoutObj, isDefault:Boolean = false) : void
      {
         var isPurchased:Boolean = false;
         if(isDefault)
         {
            GraphicUtil.desaturate(this.myImage,false);
            this.myLockedIcon.visible = false;
            this.myImage.alpha = 1;
            return;
         }
         data.isExpired = Boolean(CFunctionCommonContainer.AS_IsExpiredInventoryItem(data.itemID));
         isPurchased = data.isPurchased && !data.isExpired;
         this.myLockedIcon.visible = !isPurchased;
         this.myImage.alpha = isPurchased ? 1 : 0.5;
         if(!isPurchased || data.loadoutTempDisabled)
         {
            GraphicUtil.desaturate(this.myImage);
            if(!data.loadoutTempDisabled)
            {
               this.myLockedIcon.lockedText = DictMarket.AVAILABLE;
            }
            else
            {
               this.myLockedIcon.lockedText = Dict.UNAVAILABLE;
            }
         }
         else
         {
            GraphicUtil.desaturate(this.myImage,false);
         }
      }
      
      private function setBotImage(image:String) : void
      {
         this.myImage.setImage(image);
      }
      
      private function onListRollOut(cEvt:ListEvent) : void
      {
         this.displayLoadoutDetail(_currentClassIndex);
      }
      
      private function onLoadoutItemFocused(cEvt:ListEvent) : void
      {
         if(!isClassSelected())
         {
            return;
         }
         var focusIndex:uint = uint(this.myLoadoutList.focusIndex);
         var focusedLoadout:AsymPvpLoadoutObj = AsymPvpUtil.instance.getClassLoadouts(_currentClassIndex)[focusIndex] as AsymPvpLoadoutObj;
         this.setBotImage(focusedLoadout.image);
         this.setLockedState(focusedLoadout,focusIndex == DEFAULT_LOADOUT_INDEX);
         this.myAbilitiesList.setData(focusedLoadout);
      }
      
      private function onLoadoutClick(cEvt:ListEvent) : void
      {
         var selectedIndex:uint = this.mSelectedLoadoutIndex = this.myLoadoutList.selectedIndex;
         var selectedRenderer:AsymMonsterLoadoutListItem = this.myLoadoutList.getItemRendererByDataIndex(selectedIndex) as AsymMonsterLoadoutListItem;
         var selectedLoadout:AsymPvpLoadoutObj = AsymPvpUtil.instance.getClassLoadouts(_currentClassIndex)[selectedIndex] as AsymPvpLoadoutObj;
         if(selectedIndex != this.myLoadoutList.focusIndex)
         {
            return;
         }
         this.setBotImage(selectedLoadout.image);
         this.setLockedState(selectedLoadout,selectedIndex == DEFAULT_LOADOUT_INDEX);
         this.myAbilitiesList.setData(selectedLoadout);
         if(selectedIndex != DEFAULT_LOADOUT_INDEX && selectedLoadout.isExpired)
         {
            return;
         }
         if(selectedRenderer.isLocked || selectedLoadout.loadoutTempDisabled)
         {
            return;
         }
         AsymPvpUtil.instance.setSelectedLoadout(_currentClassIndex,selectedIndex);
      }
      
      override protected function refreshLayout() : void
      {
         super.refreshLayout();
         if(PauseUtil.getPauseMapHidden())
         {
            myFrame.width = SMALL_FRAME_WIDTH - 35;
            myFrame.height = FRAME_HEIGHT + 10;
         }
         else
         {
            myFrame.width = FRAME_WIDTH;
            myFrame.height = FRAME_HEIGHT + 30;
         }
      }
   }
}

