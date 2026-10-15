package codo.component
{
   import codo.base.BaseSubElement;
   import codo.common.CFunctionCommonContainer;
   import codo.component.factory.ButtonFactory;
   import codo.component.factory.GlobalFactory;
   import codo.component.playerAccount.PlayerAccountInfoCurrency;
   import codo.component.playerAccount.PlayerAccountInfoPrivileges;
   import codo.constants.BCEvent;
   import codo.constants.ButtonTLog;
   import codo.constants.DataCommonID;
   import codo.constants.DataID;
   import codo.constants.WebImgData;
   import codo.cpp.UiCppOnboarding;
   import codo.event.ParaEvent;
   import codo.localization.DictMarket;
   import codo.objects.AccountObj;
   import codo.objects.WarGodGlobalSettingObj;
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   import codo.utils.LocalizeUtil;
   import codo.utils.Logger;
   import codo.utils.ScaleformUtil;
   import codo.utils.TLogUtil;
   import com.society.comscore.DAXDispatcher;
   import flash.display.MovieClip;
   import flash.geom.Point;
   
   public class PlayerAccountInfo extends BaseSubElement
   {
      
      public static const CPGPMode:int = 0;
      
      public static const HPEHPMode:int = 1;
      
      public var myBackground:MovieClip;
      
      public var myReplenishButton:Button;
      
      public var myCCButton:IconButton;
      
      public var myCP:PlayerAccountInfoCurrency;
      
      public var myGP:PlayerAccountInfoCurrency;
      
      public var myHP:PlayerAccountInfoCurrency;
      
      public var myEHP:PlayerAccountInfoCurrency;
      
      public var myPlayerPrivileges:PlayerAccountInfoPrivileges;
      
      private var mDisplayCurrencyOnly:Boolean;
      
      private var mAccountDataReady:Boolean;
      
      private var mForceHide:Boolean;
      
      private var mXStartPos:Number;
      
      private var mMode:int = 0;
      
      public function PlayerAccountInfo()
      {
         var BAR_SIZE:uint = 0;
         var textStyle:TextStyle = null;
         var settings:WarGodGlobalSettingObj = null;
         super();
         BAR_SIZE = 28;
         if(ScaleformUtil.isScaleform)
         {
            this.accountDataReady = false;
         }
         this.myReplenishButton = addChild(ButtonFactory.BUILD_REPLENSISH_BUTTON(32)) as Button;
         textStyle = new TextStyle();
         textStyle.font = GlobalGuide.FONT_FACE_NUMBERS;
         textStyle.fontSize = GlobalGuide.FONT_SIZE_SMALL;
         this.myCCButton.myLabel.textStyle = textStyle;
         this.myCCButton.myLabel.alignment = TextStyle.HALIGN_LEFT;
         this.myCCButton.setImage("cc_icon");
         this.myCCButton.setLabelPadding(11);
         this.myCCButton.swapIconAlignment(true);
         this.myCCButton.setIconPadding(11);
         this.myCCButton.registerClickEvent(this.onCraftingClicked);
         this.myCCButton.height = 32;
         this.myCCButton.enabled = true;
         this.myCCButton.setMarketReadyMode(true);
         this.updateCCButton(0);
         this.myReplenishButton.setClickCallback(this.onReplenishCPClick);
         this.myPlayerPrivileges.init();
         this.myGP.icon = GlobalFactory.BUILD_ICON_GP(BAR_SIZE);
         this.myCP.icon = GlobalFactory.BUILD_ICON_CP(24);
         this.myHP.icon = GlobalFactory.BUILD_ICON_HP(32);
         this.myEHP.icon = GlobalFactory.BUILD_ICON_EHP(32);
         var isInGame:Boolean = getDP(DataCommonID.IS_IN_GAME);
         if(!isInGame)
         {
            settings = getDP(DataID.WARGOD_GLOBAL_SETTING);
            this.myHP.enableTooltip(true,LocalizeUtil.param(LocalizeUtil.localize(DictMarket.HP_TIP),[settings.hpMaxStorage]));
            this.myEHP.enableTooltip(true,LocalizeUtil.param(LocalizeUtil.localize(DictMarket.EHP_TIP),[settings.ehpMaxStorage]));
         }
      }
      
      private static function dax_setGPCP(amountGP:int, amountCP:int) : void
      {
         try
         {
            DAXDispatcher.setGP(amountGP);
            DAXDispatcher.setCP(amountCP);
         }
         catch(e:Error)
         {
            Logger.print("*** DAXDispatcher: " + e.message);
         }
      }
      
      public function set displayCurrencyOnly(currencyOnly:Boolean) : void
      {
         this.mDisplayCurrencyOnly = currencyOnly;
      }
      
      public function set accountDataReady(value:Boolean) : void
      {
         this.mAccountDataReady = value;
         this.refreshVisible();
      }
      
      public function set forceHide(value:Boolean) : void
      {
         this.mForceHide = value;
         this.refreshVisible();
      }
      
      private function refreshVisible() : void
      {
         visible = this.mAccountDataReady && !this.mForceHide;
      }
      
      override public function active() : void
      {
         super.active();
         this.switchShowCurrencyMode(this.mMode);
         this.myPlayerPrivileges.visible = !this.mDisplayCurrencyOnly;
         if(ScaleformUtil.isScaleform)
         {
            this.myCCButton.visible = !this.mDisplayCurrencyOnly && CFunctionCommonContainer.CraftingEnabled() && CFunctionCommonContainer.GetOnboardUnlockLevel(UiCppOnboarding.FEATURE_SUPPLY_DROPS) == null;
         }
         bind(DataID.MY_ACCOUNT,this.bindAccountInfo);
         bind(DataID.DATA_RECEIVE,this.bindDataReceived);
         bind(DataID.MARKETPLACE_MAINTAIN_STATE,this.bindMarketplaceMaintainState);
         bind(DataID.CRAFTING_SHARD_COUNT,this.bindCraftingShardCount);
         listen(BCEvent.EVT_SWITCH_HP_EHP_CURRENCY_MODE,this.onSwitchHpEhpCurrencyMode);
         this.myReplenishButton.enabled = true;
      }
      
      override public function deactive() : void
      {
         super.deactive();
         unbind(DataID.MY_ACCOUNT,this.bindAccountInfo);
         unbind(DataID.DATA_RECEIVE,this.bindDataReceived);
         unbind(DataID.MARKETPLACE_MAINTAIN_STATE,this.bindMarketplaceMaintainState);
         unbind(DataID.CRAFTING_SHARD_COUNT,this.bindCraftingShardCount);
         unlisten(BCEvent.EVT_SWITCH_HP_EHP_CURRENCY_MODE,this.onSwitchHpEhpCurrencyMode);
      }
      
      public function positionAssets() : void
      {
         var ASSET_PADDING:uint = 0;
         var ccWidth:Number = NaN;
         var SPACING_IN_FROM_RIGHT_EDGE:Number = 40;
         ASSET_PADDING = 20;
         x = this.mXStartPos;
         this.myReplenishButton.x = -(this.myReplenishButton.width + SPACING_IN_FROM_RIGHT_EDGE);
         var cpStartX:Number = this.myReplenishButton.visible ? this.myReplenishButton.x : -SPACING_IN_FROM_RIGHT_EDGE;
         var ehpStartX:Number = this.myReplenishButton.visible ? this.myReplenishButton.x : -SPACING_IN_FROM_RIGHT_EDGE;
         var cpWidth:Number = this.myCP.width + ASSET_PADDING;
         var gpWidth:Number = this.myGP.width + ASSET_PADDING;
         var ehpWidth:Number = this.myEHP.width + ASSET_PADDING;
         var hpWidth:Number = this.myHP.width + ASSET_PADDING;
         ccWidth = this.myCCButton.visible ? this.myCCButton.width + 5 : 0;
         this.myCP.x = cpStartX - cpWidth;
         this.myGP.x = this.myCP.x - gpWidth;
         this.myEHP.x = ehpStartX - ehpWidth;
         this.myHP.x = this.myEHP.x - hpWidth;
         this.myReplenishButton.y = this.myGP.y - 3;
         this.myCCButton.y = this.myGP.y - 3;
         this.myCCButton.x = (this.mMode == CPGPMode ? this.myGP.x : this.myHP.x) - ccWidth;
         this.myBackground.width = -cpStartX + cpWidth + gpWidth + ccWidth + 70;
         this.myPlayerPrivileges.x = this.myBackground.x - this.myBackground.width - ASSET_PADDING;
      }
      
      public function set startXPos(xPos:Number) : void
      {
         this.mXStartPos = xPos;
      }
      
      public function bindAccountInfo(cResult:Object) : void
      {
         var accountObj:AccountObj = new AccountObj(cResult.data);
         this.myCP.visible = this.mMode == CPGPMode && Boolean(this.getDP(DataID.IS_CP_COUNT_ENABLED));
         this.myReplenishButton.visible = Boolean(this.getDP(DataID.IS_CP_RECHARGE_ENABLED)) && !this.mDisplayCurrencyOnly;
         this.myReplenishButton.enabled = this.getDP(DataID.IS_WEBIMG_VALID,[WebImgData.RECHARGE,0]);
         this.myGP.setData(accountObj.codPoint.toString());
         this.myCP.setData(accountObj.moneyPoint.toString());
         this.myHP.setData(accountObj.heroPoint.toString());
         this.myEHP.setData(accountObj.epicHeroPoint.toString());
         this.myPlayerPrivileges.showLocalPlayerPrivileges();
         try
         {
            dax_setGPCP(accountObj.codPoint,accountObj.moneyPoint);
         }
         catch(e:Error)
         {
            Logger.print("*** DAXDispatcher: " + e.message);
         }
         this.accountDataReady = true;
         this.positionAssets();
      }
      
      private function bindDataReceived() : void
      {
         var count:int = 0;
         var isAvailable:Boolean = getDP(DataID.IS_DATA_AVAILABLE);
         this.myCCButton.setMarketReadyMode(isAvailable);
         if(isAvailable)
         {
            count = getDP(DataID.CRAFTING_SHARD_COUNT);
            this.updateCCButton(count);
            this.positionAssets();
         }
      }
      
      private function bindMarketplaceMaintainState(res:Object) : void
      {
         var isAvailable:Boolean = getDP(DataID.IS_DATA_AVAILABLE);
         this.myCCButton.setMarketReadyMode(isAvailable);
      }
      
      private function bindCraftingShardCount(cRes:Object) : void
      {
         this.updateCCButton(cRes.data);
         this.positionAssets();
      }
      
      private function onSwitchHpEhpCurrencyMode(evt:ParaEvent) : void
      {
         var mode:int = evt.myPara as int;
         this.switchShowCurrencyMode(mode);
      }
      
      public function switchShowCurrencyMode(mode:int) : void
      {
         this.mMode = mode;
         if(mode == CPGPMode)
         {
            this.myReplenishButton.visible = Boolean(getDP(DataID.IS_CP_RECHARGE_ENABLED)) && !this.mDisplayCurrencyOnly;
            this.myCCButton.visible = !this.mDisplayCurrencyOnly && CFunctionCommonContainer.CraftingEnabled() && CFunctionCommonContainer.GetOnboardUnlockLevel(UiCppOnboarding.FEATURE_SUPPLY_DROPS) == null;
            this.myCP.visible = getDP(DataID.IS_CP_COUNT_ENABLED);
            this.myGP.visible = true;
            this.myHP.visible = false;
            this.myEHP.visible = false;
         }
         else
         {
            this.myCP.visible = this.myGP.visible = false;
            this.myHP.visible = this.myEHP.visible = true;
         }
         this.positionAssets();
      }
      
      private function updateCCButton(count:int) : void
      {
         this.myCCButton.label = count.toString();
         this.myCCButton.customIconButtonSize = new Point(this.myCCButton.myLabel.textWidth + 30,32);
         this.myCCButton.width = this.myCCButton.myLabel.textWidth + 10;
         this.myCCButton.myLabel.y = 4;
      }
      
      private function onReplenishCPClick() : void
      {
         TLogUtil.TLog_UserInput(ButtonTLog.BUTTON_REPLENISH);
         broadcast(BCEvent.EVT_SHOW_RECHARGE);
      }
      
      private function onCraftingClicked() : void
      {
         TLogUtil.TLog_UserInput(ButtonTLog.BUTTON_CRAFTING);
         broadcast(BCEvent.EVT_SHOW_CRAFTING);
      }
   }
}

