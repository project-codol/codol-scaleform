package codo.views
{
   import codo.common.CFunctionCommonContainer;
   import codo.component.ScrollList;
   import codo.component.ScrollingTextField;
   import codo.component.TextField;
   import codo.constants.BCEvent;
   import codo.constants.DataInGameID;
   import codo.localization.DictMarket;
   import codo.objects.ClashLoadoutObj;
   import codo.objects.ScrollListSettings;
   import codo.style.GlobalGuide;
   import codo.style.MarketGuide;
   import codo.utils.ClashPvpUtil;
   import codo.utils.LocalizeUtil;
   import codo.utils.MarketItemUtil;
   import codo.utils.PauseUtil;
   import components.clash.ClashWeaponLoadoutLocked;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import fsg.util.FsgImageHolder;
   
   public class PauseMenuClashView extends FsgPauseMenuBaseView
   {
      
      private static const INACTIVE_ALPHA:Number = 0.35;
      
      private static const ACTIVE_ALPHA:Number = 1;
      
      private static const DEFAULT_LOADOUT_INDEX:uint = 0;
      
      private static const GREEN_IDX:int = 0;
      
      private static const ORANGE_IDX:int = 1;
      
      private static const RED_IDX:int = 2;
      
      public var myImage:FsgImageHolder;
      
      public var myLoadoutList:ScrollList;
      
      public var myLockedIcon:ClashWeaponLoadoutLocked;
      
      public var myAttackGreenArrows:MovieClip;
      
      public var myAttackOrangeArrows:MovieClip;
      
      public var myAttackRedArrows:MovieClip;
      
      public var myMoveGreenArrows:MovieClip;
      
      public var myMoveOrangeArrows:MovieClip;
      
      public var myMoveRedArrows:MovieClip;
      
      public var myTierColor:MovieClip;
      
      public var myAttackSpeedHeader:TextField;
      
      public var myMoveSpeedHeader:TextField;
      
      public var myItemCategory:TextField;
      
      public var myHeader:TextField;
      
      public var myItemDescription:ScrollingTextField;
      
      public var myContentBackground:MovieClip;
      
      public var myListBackground:MovieClip;
      
      public var myDecoration:MovieClip;
      
      private var mAttackArrows:Vector.<MovieClip>;
      
      private var mMoveArrows:Vector.<MovieClip>;
      
      public function PauseMenuClashView()
      {
         var listSettings:ScrollListSettings = null;
         var m:MovieClip = null;
         super();
         this.mAttackArrows = new <MovieClip>[this.myAttackGreenArrows,this.myAttackOrangeArrows,this.myAttackRedArrows];
         this.mMoveArrows = new <MovieClip>[this.myMoveGreenArrows,this.myMoveOrangeArrows,this.myMoveRedArrows];
         listSettings = new ScrollListSettings();
         listSettings.orientation = ScrollListSettings.SCROLL_VERTICAL;
         listSettings.useNavArrows = false;
         listSettings.autoSize = false;
         listSettings.autoSizeItems = true;
         listSettings.itemLinkage = "codo.shared.clash.clashListOption";
         listSettings.itemPadding = 0;
         this.myLoadoutList.settings = listSettings;
         this.myLoadoutList.listItemFocusCallback = this.onLoadoutItemFocused;
         this.myLoadoutList.listItemUnfocusCallback = this.onListRollOut;
         this.myLoadoutList.listItemClickCallback = this.onListItemClicked;
         this.myLoadoutList.width = 205;
         this.myLoadoutList.height = 500;
         this.myLockedIcon.lockedText = DictMarket.AVAILABLE;
         this.myItemDescription.width = 413;
         this.myItemDescription.height = 72;
         this.myHeader.fontSize = GlobalGuide.FONT_SIZE_MEDIUM;
         this.myHeader.font = GlobalGuide.FONT_FACE_BOLD;
         this.myHeader.width = 200;
         this.myHeader.text = LocalizeUtil.localize("@SF_UI_CLASH_SELECT_WEAPON");
         this.myItemCategory.fontColor = GlobalGuide.BLACK;
         this.myItemCategory.fontSize = GlobalGuide.FONT_SIZE_MEDIUM_SMALL;
         this.myItemCategory.width = 400;
         this.myAttackSpeedHeader.width = 400;
         this.myMoveSpeedHeader.width = 400;
         this.myAttackSpeedHeader.text = LocalizeUtil.localize("@CLASH_DESC_ATTACKSPEED_NAME");
         this.myMoveSpeedHeader.text = LocalizeUtil.localize("@CLASH_DESC_MOVESPEED_NAME");
         this.myAttackSpeedHeader.visible = false;
         this.myMoveSpeedHeader.visible = false;
         for each(m in this.mAttackArrows)
         {
            m.visible = false;
         }
         for each(m in this.mMoveArrows)
         {
            m.visible = false;
         }
      }
      
      override protected function onInit() : void
      {
         super.onInit();
         myOptions.setTitle("");
      }
      
      private function onLoadoutItemFocused(data:Object) : void
      {
         if(!isClassSelected())
         {
            return;
         }
         var focusedLoadout:ClashLoadoutObj = data as ClashLoadoutObj;
         this.updateWeaponView(focusedLoadout);
      }
      
      private function onListRollOut(data:Object) : void
      {
         var focusIndex:uint = this.myLoadoutList.selectedIndex;
         var focusedLoadout:ClashLoadoutObj = ClashPvpUtil.instance.getLoadoutsArrayByClass(_currentClassIndex)[focusIndex] as ClashLoadoutObj;
         this.updateWeaponView(focusedLoadout);
      }
      
      private function onListItemClicked(data:Object) : void
      {
         var selectedIndex:uint = this.myLoadoutList.selectedIndex;
         var selectedLoadout:ClashLoadoutObj = ClashPvpUtil.instance.getLoadoutsArrayByClass(_currentClassIndex)[selectedIndex] as ClashLoadoutObj;
         this.updateWeaponView(selectedLoadout);
         if(Boolean(data.getData().locked))
         {
            return;
         }
         ClashPvpUtil.instance.setSelectedLoadout(_currentClassIndex,selectedIndex);
      }
      
      override protected function hideClassSelection(hide:Boolean) : void
      {
         super.hideClassSelection(hide);
         this.myImage.visible = !hide;
         this.myLoadoutList.visible = !hide;
         this.myTierColor.visible = !hide;
         this.myItemCategory.visible = !hide;
         this.myHeader.visible = !hide;
         this.myItemDescription.visible = !hide;
         this.myContentBackground.visible = !hide;
         this.myListBackground.visible = !hide;
      }
      
      override protected function displayLoadoutDetail(classIdx:int) : void
      {
         super.displayLoadoutDetail(classIdx);
         _currentClassIndex = classIdx;
         var loadouts:Array = ClashPvpUtil.instance.getLoadoutsArrayByClass(classIdx);
         this.myLoadoutList.addItemsByVector(Vector.<Object>(loadouts));
         var loadoutIndex:int = ClashPvpUtil.instance.getSelectedLoadoutByClass(classIdx);
         this.myLoadoutList.selectedIndex = loadoutIndex;
         var data:ClashLoadoutObj = ClashPvpUtil.instance.getSelectedLoadoutObj(classIdx);
         if(data == null)
         {
            return;
         }
         this.updateWeaponView(data);
      }
      
      private function setPerk(perkimg:FsgImageHolder, path:String) : void
      {
         if(path == "")
         {
            perkimg.visible = false;
         }
         else
         {
            perkimg.visible = true;
            perkimg.setImage(path);
         }
      }
      
      override protected function isLoadoutSlotUnlocked(idx:int) : Boolean
      {
         return getDP(DataInGameID.GAME_TYPE) == ClashPvpUtil.MODE_ID;
      }
      
      override protected function refreshLayout() : void
      {
         super.refreshLayout();
         if(PauseUtil.getPauseMapHidden())
         {
            myFrame.width = SMALL_FRAME_WIDTH - 34;
            myFrame.height = FRAME_HEIGHT + 11;
            this.myTierColor.x = 555;
            this.myTierColor.y = 289;
            this.myAttackGreenArrows.y = this.myAttackOrangeArrows.y = this.myAttackRedArrows.y = 660;
            this.myMoveGreenArrows.y = this.myMoveOrangeArrows.y = this.myMoveRedArrows.y = 770;
            this.myAttackGreenArrows.x = this.myMoveGreenArrows.x = 820;
            this.myAttackOrangeArrows.x = this.myMoveOrangeArrows.x = 707;
            this.myAttackRedArrows.x = this.myMoveRedArrows.x = 595;
            this.myDecoration.visible = false;
         }
         else
         {
            myFrame.width = FRAME_WIDTH;
            myFrame.height = FRAME_HEIGHT + 30;
            this.myTierColor.x = 303;
            this.myTierColor.y = 298;
            this.myAttackGreenArrows.y = this.myAttackOrangeArrows.y = this.myAttackRedArrows.y = 669;
            this.myMoveGreenArrows.y = this.myMoveOrangeArrows.y = this.myMoveRedArrows.y = 779;
            this.myAttackGreenArrows.x = this.myMoveGreenArrows.x = 568;
            this.myAttackOrangeArrows.x = this.myMoveOrangeArrows.x = 455;
            this.myAttackRedArrows.x = this.myMoveRedArrows.x = 343;
            this.myDecoration.visible = true;
         }
         var status:int = CFunctionCommonContainer.GetGameMomentsStatus();
         this.broadcast(BCEvent.EVT_GAMEMOMENTS_STATUS_CHANGED,status);
      }
      
      private function updateWeaponView(data:ClashLoadoutObj) : void
      {
         this.myLockedIcon.visible = data.locked;
         this.myItemCategory.text = LocalizeUtil.localize(MarketItemUtil.ITEM_TIER_LABELS[data.tier]).toUpperCase() + " " + LocalizeUtil.localize(MarketItemUtil.GET_ITEM_CATEGORY_BY_GROUP(data.group));
         this.myItemDescription.text = data.description;
         this.myTierColor.width = this.myItemCategory.textWidth + 40;
         var tierColor:uint = uint(MarketGuide.COLOR_BY_TIER[data.tier]);
         GlobalGuide.formatComponentsByTier(tierColor,new <DisplayObject>[this.myTierColor]);
         this.myImage.setImage(data.image);
      }
      
      private function updateArrows(speed:String, arrows:Vector.<MovieClip>) : void
      {
         switch(speed)
         {
            case "@CLASH_DESC_FAST":
               arrows[GREEN_IDX].alpha = ACTIVE_ALPHA;
               arrows[ORANGE_IDX].alpha = INACTIVE_ALPHA;
               arrows[RED_IDX].alpha = INACTIVE_ALPHA;
               arrows[GREEN_IDX].gotoAndStop(1);
               arrows[ORANGE_IDX].gotoAndStop(1);
               arrows[RED_IDX].gotoAndStop(1);
               break;
            case "@CLASH_DESC_NORMAL":
               arrows[GREEN_IDX].alpha = INACTIVE_ALPHA;
               arrows[ORANGE_IDX].alpha = ACTIVE_ALPHA;
               arrows[RED_IDX].alpha = INACTIVE_ALPHA;
               arrows[GREEN_IDX].gotoAndStop(2);
               arrows[ORANGE_IDX].gotoAndStop(1);
               arrows[RED_IDX].gotoAndStop(1);
               break;
            case "@CLASH_DESC_SLOW":
               arrows[GREEN_IDX].alpha = INACTIVE_ALPHA;
               arrows[ORANGE_IDX].alpha = ACTIVE_ALPHA;
               arrows[RED_IDX].alpha = INACTIVE_ALPHA;
               arrows[GREEN_IDX].gotoAndStop(2);
               arrows[ORANGE_IDX].gotoAndStop(1);
               arrows[RED_IDX].gotoAndStop(1);
         }
      }
   }
}

