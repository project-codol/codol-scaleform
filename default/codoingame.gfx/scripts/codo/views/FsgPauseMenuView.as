package codo.views
{
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionInGameContainer;
   import codo.component.loadout.PauseMenuLoadoutDisplay;
   import codo.component.tutorial.UITourToolTip;
   import codo.constants.DataInGameID;
   import codo.constants.UITutorialFlags;
   import codo.constants.table.UINotifications;
   import codo.cpp.UiCppOnboarding;
   import codo.objects.uitour.UITourToolTipObj;
   import codo.utils.AsymPvpUtil;
   import codo.utils.PauseUtil;
   import codo.views.hud.popups.HudVIPSelectVIPCharacterPopup_parts.HudVIPSelectVIPCharacterCard;
   import components.fsg_pausemenu_part.WeaponUpgradePanel;
   import flash.geom.Point;
   import flash.utils.getDefinitionByName;
   
   public class FsgPauseMenuView extends FsgPauseMenuBaseView
   {
      
      public var myLoadoutDetailPanel:PauseMenuLoadoutDisplay;
      
      public var myWeaponUpgradePanel:WeaponUpgradePanel;
      
      public var myVIPCharacterCard:HudVIPSelectVIPCharacterCard;
      
      private var mHelpTipDisplay:UITourToolTip;
      
      private var mHelpTips:Vector.<UITourToolTipObj>;
      
      private var mKillswitchedTips:Object;
      
      public function FsgPauseMenuView()
      {
         super();
      }
      
      override protected function onInit() : void
      {
         var isspectator:Boolean = false;
         super.onInit();
         if(myFrame != null)
         {
            if(PauseUtil.getPauseMapHidden())
            {
               myFrame.width = 825;
            }
            else
            {
               myFrame.width = 1100;
            }
         }
         if(this.IsAsymMode())
         {
            isspectator = CFunctionInGameContainer.IsSpectator() as Boolean;
            if(isspectator)
            {
               this.myWeaponUpgradePanel.visible = false;
            }
            myOptions.setTitle("");
         }
      }
      
      override protected function hideClassSelection(hide:Boolean) : void
      {
         super.hideClassSelection(hide);
         this.myLoadoutDetailPanel.visible = !hide;
      }
      
      override protected function displayLoadoutDetail(loadoutIdx:int) : void
      {
         var currentCharacterIdx:int = 0;
         var asymWeaponUpgrades:Array = null;
         var onboardType:uint = 0;
         super.displayLoadoutDetail(loadoutIdx);
         if(Boolean(_classes))
         {
            this.myLoadoutDetailPanel.setLoadoutData(_classes[loadoutIdx],getDP(DataInGameID.IS_ZM));
            if(this.IsAsymMode())
            {
               currentCharacterIdx = CFunctionCommonContainer.CL_GetCurrentCharacterLoadoutIndex();
               asymWeaponUpgrades = CFunctionCommonContainer.WL_GetAsymWeaponUpgrades(currentCharacterIdx,loadoutIdx);
               this.myWeaponUpgradePanel.setData(asymWeaponUpgrades[0],asymWeaponUpgrades[1]);
            }
            if(this.mHelpTips == null)
            {
               this.mHelpTips = new Vector.<UITourToolTipObj>(0);
               onboardType = CFunctionCommonContainer.GetPlayerOnboardType();
               if(onboardType != UiCppOnboarding.TYPE_PRE_MR5)
               {
                  this.mKillswitchedTips = CFunctionCommonContainer.GetDisabledOnboardHelp();
                  if(!this.mKillswitchedTips["all"])
                  {
                     this.TryAddTip(new UITourToolTipObj(null,UITutorialFlags.NULL,"@UI_TUTORIAL_UI_TOUR_TOOL_TIP_LOADOUT_TITLE","@UI_TUTORIAL_UI_TOUR_TOOL_TIP_LOADOUT_DESC",new Point(160,0),true,UINotifications.ONBOARD_HELP_LOADOUT,null,null,UITourToolTip.STYLE_1_BTN,UITourToolTip.ARROW_DOWN));
                     this.TryAddTip(new UITourToolTipObj(null,UITutorialFlags.NULL,"@UI_TUTORIAL_UI_TOUR_TOOL_TIP_PERKS_TITLE","@UI_TUTORIAL_UI_TOUR_TOOL_TIP_PERKS_DESC",new Point(-64,337),true,UINotifications.ONBOARD_HELP_PERKS,null,null,UITourToolTip.STYLE_1_BTN,UITourToolTip.ARROW_RIGHT));
                     this.TryAddTip(new UITourToolTipObj(null,UITutorialFlags.NULL,"@UI_TUTORIAL_UI_TOUR_TOOL_TIP_MAP_TITLE","@UI_TUTORIAL_UI_TOUR_TOOL_TIP_MAP_DESC",new Point(696,0),true,UINotifications.ONBOARD_HELP_MAP,null,null,UITourToolTip.STYLE_1_BTN,UITourToolTip.ARROW_DOWN));
                  }
               }
            }
            this.ShowHelpTip();
         }
      }
      
      private function TryAddTip(tip:UITourToolTipObj) : void
      {
         if(!CFunctionCommonContainer.AS_IsNotified(tip.onboardNotif) && tip.featureIsUnlocked())
         {
            if(!this.mKillswitchedTips[tip.onboardNotif])
            {
               this.mHelpTips.push(tip);
            }
         }
      }
      
      private function ShowHelpTip() : void
      {
         var cls:Class = null;
         if(this.mHelpTips.length == 0)
         {
            return;
         }
         if(this.mHelpTipDisplay == null)
         {
            cls = getDefinitionByName("codo.shared.UITourToolTip") as Class;
            this.mHelpTipDisplay = new cls() as UITourToolTip;
            this.mHelpTipDisplay.clickCallback = this.onHelpClick;
            this.checkHelpEnabled();
         }
         var tip:UITourToolTipObj = this.mHelpTips[0];
         if(this.mHelpTipDisplay.getShownData() != tip)
         {
            this.mHelpTipDisplay.showHelpTip(tip);
         }
      }
      
      private function onHelpClick() : void
      {
         this.mHelpTipDisplay.deactive();
         var tip:UITourToolTipObj = this.mHelpTips.shift();
         CFunctionCommonContainer.AS_SetNotified(tip.onboardNotif);
         this.ShowHelpTip();
      }
      
      override protected function refreshLayout() : void
      {
         var characterIndex:int = 0;
         var characterInfo:Object = null;
         super.refreshLayout();
         myOptions.gotoAndStop(1);
         this.myVIPCharacterCard.visible = false;
         if(myFrame != null)
         {
            if(Boolean(getDP(DataInGameID.HIDE_CLASS_SELECTION_MENU)))
            {
               if(Boolean(getDP(DataInGameID.IS_VIP)))
               {
                  gotoAndStop(6);
                  this.myVIPCharacterCard.visible = true;
                  characterIndex = CFunctionInGameContainer.AS_VIPGetCurrentPlayerVIPSelectionIndex() - 1;
                  characterInfo = CFunctionInGameContainer.AS_GetVIPSelectCharacterInfo(characterIndex);
                  if(Boolean(characterInfo))
                  {
                     this.myVIPCharacterCard.setData(characterInfo);
                  }
                  myTitle.x = 86;
                  myTabNavigation.x = 90;
                  if(myFrame != null)
                  {
                     myFrame.x = 90;
                     myFrame.width = 1100;
                  }
               }
               else
               {
                  myFrame.width = MAP_FRAME_WIDTH;
               }
               myOptions.gotoAndStop(2);
            }
            else if(PauseUtil.getPauseMapHidden())
            {
               myFrame.width = 825;
            }
            else
            {
               myFrame.width = 1100;
            }
         }
         if(this.IsAsymMode())
         {
            myOptions.gotoAndStop(2);
            if(PauseUtil.getPauseMapHidden())
            {
               gotoAndStop(4);
               this.myWeaponUpgradePanel.gotoAndStop(1);
               myFrame.height = 500;
               myFrame.width = 930;
            }
            else
            {
               gotoAndStop(3);
               this.myWeaponUpgradePanel.gotoAndStop(2);
               myFrame.height = 600;
               myFrame.width = 1150;
            }
         }
         else
         {
            myOptions.setTitle("");
         }
         this.checkHelpEnabled();
      }
      
      private function checkHelpEnabled() : void
      {
         if(this.mHelpTipDisplay == null)
         {
            return;
         }
         var enabled:Boolean = !PauseUtil.getPauseMapHidden();
         if(enabled)
         {
            if(this.mHelpTipDisplay.parent == null)
            {
               addChild(this.mHelpTipDisplay);
            }
         }
         else if(this.mHelpTipDisplay.parent != null)
         {
            removeChild(this.mHelpTipDisplay);
         }
      }
      
      private function IsAsymMode() : Boolean
      {
         var gameMode:String = CFunctionCommonContainer.Dvar_GetString("ui_gametype");
         return AsymPvpUtil.instance.isAsymGameMode(gameMode);
      }
   }
}

