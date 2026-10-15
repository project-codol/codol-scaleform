package codo.component
{
   import codo.constants.BCEvent;
   import codo.constants.ItemType;
   import codo.localization.Dict;
   import codo.manager.EventManager;
   import codo.objects.ProductObj;
   import codo.objects.WeaponStatsObj;
   import codo.style.GlobalGuide;
   import codo.style.MarketGuide;
   import codo.style.TextStyle;
   import codo.utils.LocalizeUtil;
   import codo.utils.MarketItemUtil;
   import com.greensock.TweenLite;
   import com.greensock.easing.Linear;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.geom.ColorTransform;
   import flash.utils.Timer;
   
   public class MarketItemModule extends MovieClip
   {
      
      private static const DESCRIPTION_WIDTH:Number = 300;
      
      private static const CATEGORY_WIDTH:Number = 222;
      
      private static const DESCRIPTION_HEIGHT:Number = 175;
      
      private static const NAME_WIDTH:Number = 800;
      
      private static const MODULE_HEIGHT:Number = 389;
      
      private static const SLIDE_DURATION:Number = 0.2;
      
      private static const PREVIEW_ITEM_X:Number = 668;
      
      private static const DUAL_STATS_SWITCH_INTERVAL:Number = 4000;
      
      public var myItemName:TextField;
      
      public var myItemCategory:TextField;
      
      public var myItemDescription:ScrollingTextField;
      
      public var myTierColor:Sprite;
      
      public var myTierColorSecondary:Sprite;
      
      public var myTimerProgressBar:Sprite;
      
      public var myStatGraph:WeaponStatsGraph;
      
      public var myCompareToBaseButton:Button;
      
      public var myItemListBackground:MovieClip;
      
      public var myStatsDescText:TextField;
      
      public var myStatsDescriptionBackground:Sprite;
      
      public var myItemStatsButton:Button;
      
      private var mShowingPreviewItem:Boolean = false;
      
      private var mItemID:int = 0;
      
      private var mBaseID:int = 0;
      
      private var myItemStats:int = 0;
      
      private var myStatsTimer:Timer;
      
      private var mItemData:ProductObj;
      
      public function MarketItemModule()
      {
         super();
         this.myItemDescription.width = DESCRIPTION_WIDTH;
         this.myItemDescription.height = DESCRIPTION_HEIGHT;
         this.myItemName.textStyle = MarketGuide.styleMarketItemDetailsHeader;
         this.myItemName.width = NAME_WIDTH;
         this.myItemCategory.width = CATEGORY_WIDTH;
         this.myItemCategory.alignment = TextStyle.HALIGN_LEFT;
         this.myItemCategory.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         this.myItemCategory.fontColor = GlobalGuide.BLACK;
         this.myCompareToBaseButton.label = LocalizeUtil.localize("@SF_UI_COMPARE_TO_BASE");
         this.myCompareToBaseButton.width = 267;
         this.myCompareToBaseButton.height = 35;
         this.myCompareToBaseButton.registerClickEvent(this.onCompareToBaseClicked);
         this.myStatsDescText.visible = false;
         this.myStatsDescText.fontSize = GlobalGuide.FONT_SIZE_SMALL;
         this.myStatsDescText.fontColor = GlobalGuide.BLACK;
         this.myStatsDescText.text = LocalizeUtil.localize(Dict.WEAPON_STATS);
         this.myStatsDescriptionBackground.visible = false;
         this.myItemStatsButton.visible = false;
         this.myItemStatsButton.myLabel.fontSize = GlobalGuide.FONT_SIZE_MEDIUM_SMALL;
         this.myItemStatsButton.myTabAccent.visible = false;
         this.myItemStatsButton.myOutline.visible = false;
         this.myItemStatsButton.registerClickEvent(this.onItemStatsClicked);
         this.myStatsTimer = new Timer(DUAL_STATS_SWITCH_INTERVAL);
         this.myStatsTimer.addEventListener(TimerEvent.TIMER,this.onDualStatsTimer);
         this.stopTimerAnim();
      }
      
      private function changeWeaponStats() : void
      {
         if(this.myItemStats == 0)
         {
            return;
         }
         if(this.myItemStats == 1)
         {
            this.myItemStats = 2;
         }
         else
         {
            this.myItemStats = 1;
         }
         this.setWeaponData();
      }
      
      private function onDualStatsTimer(e:TimerEvent) : void
      {
         this.changeWeaponStats();
         this.startTimerAnim();
      }
      
      private function setWeaponData() : void
      {
         var newColor:ColorTransform = null;
         if(this.mItemData.type != ItemType.WEAPON)
         {
            return;
         }
         if(this.myItemStats == 0)
         {
            this.myStatsDescText.visible = false;
            this.myStatsDescriptionBackground.visible = false;
            this.myItemStatsButton.visible = false;
         }
         else
         {
            this.myStatsDescText.visible = true;
            this.myStatsDescriptionBackground.visible = true;
            this.myItemStatsButton.label = this.myItemStats == 1 ? LocalizeUtil.localize(Dict.WEAPON_BASIC_STATS) : LocalizeUtil.localize(Dict.WEAPON_CLASH_STATS);
            this.myItemStatsButton.myLabel.fontColor = this.myItemStats == 1 ? GlobalGuide.CODO_BLUE_LIGHT : GlobalGuide.GREEN;
            this.myItemStatsButton.labelFocusColor = this.myItemStats == 1 ? GlobalGuide.CODO_BLUE_LIGHT : GlobalGuide.GREEN;
            this.myItemStatsButton.labelUnfocusColor = this.myItemStats == 1 ? GlobalGuide.CODO_BLUE_LIGHT : GlobalGuide.GREEN;
            this.myItemStatsButton.visible = true;
            newColor = new ColorTransform();
            newColor.color = this.myItemStats == 1 ? GlobalGuide.CODO_BLUE_LIGHT : GlobalGuide.GREEN;
            this.myTimerProgressBar.transform.colorTransform = newColor;
         }
         var data:WeaponStatsObj = new WeaponStatsObj(this.mItemData,false,this.myItemStats == 2);
         this.myStatGraph.setData(data);
         this.myStatGraph.visible = true;
      }
      
      private function onItemStatsClicked() : void
      {
         this.myStatsTimer.reset();
         this.myStatsTimer.start();
         this.changeWeaponStats();
      }
      
      public function setData(prodData:ProductObj) : void
      {
         this.mShowingPreviewItem = false;
         this.myItemName.text = prodData.name;
         this.myItemDescription.text = prodData.description;
         this.myItemCategory.text = LocalizeUtil.localize(MarketItemUtil.ITEM_TIER_LABELS[prodData.tier]).toUpperCase() + " " + LocalizeUtil.localize(MarketItemUtil.GET_ITEM_CATEGORY_BY_GROUP(prodData.group));
         this.myItemCategory.visible = Boolean(this.myItemCategory.text) && this.myItemCategory.text != "";
         this.myStatsTimer.reset();
         this.myItemStats = 0;
         if(prodData.type == ItemType.WEAPON)
         {
            this.mItemData = prodData;
            if(prodData.group == "swd" && prodData.clashProperties != null)
            {
               this.myStatsTimer.start();
               this.startTimerAnim();
               this.myItemStats = 1;
            }
            this.setWeaponData();
         }
         else
         {
            this.myStatGraph.visible = false;
            this.myStatsDescText.visible = false;
            this.myStatsDescriptionBackground.visible = false;
            this.myItemStatsButton.visible = false;
         }
         var tierColor:uint = uint(MarketGuide.COLOR_BY_TIER[prodData.tier]);
         GlobalGuide.formatComponentsByTier(tierColor,new <DisplayObject>[this.myTierColor,this.myTierColorSecondary]);
         this.myTierColorSecondary.alpha = 0.6;
         this.mItemID = prodData.id;
         this.mBaseID = prodData.baseID;
         this.myCompareToBaseButton.visible = this.mBaseID > 0;
         if(this.myCompareToBaseButton.visible)
         {
            this.myItemDescription.height = DESCRIPTION_HEIGHT - this.myCompareToBaseButton.height;
         }
         else
         {
            this.myItemDescription.height = DESCRIPTION_HEIGHT;
         }
      }
      
      override public function get height() : Number
      {
         return MODULE_HEIGHT;
      }
      
      public function refreshStats(baseStats:WeaponStatsObj, modifiedStats:WeaponStatsObj) : void
      {
         this.myStatGraph.setData(modifiedStats,baseStats);
      }
      
      private function onCompareToBaseClicked() : void
      {
         EventManager.getInstance().broadcast(BCEvent.EVT_GOTO_MARKET_COMPARE,{
            "id1":this.mBaseID,
            "id2":this.mItemID
         });
      }
      
      public function clearDualStatsTimer() : void
      {
         this.myStatsTimer.reset();
         this.myItemStats = 0;
         this.mItemData = null;
         this.stopTimerAnim();
      }
      
      private function startTimerAnim() : void
      {
         TweenLite.killTweensOf(this.myTimerProgressBar);
         this.myTimerProgressBar.width = 0;
         TweenLite.to(this.myTimerProgressBar,DUAL_STATS_SWITCH_INTERVAL * 0.001,{
            "width":177,
            "ease":Linear.easeNone
         });
      }
      
      private function stopTimerAnim() : void
      {
         TweenLite.killTweensOf(this.myTimerProgressBar);
         this.myTimerProgressBar.width = 0;
      }
   }
}

