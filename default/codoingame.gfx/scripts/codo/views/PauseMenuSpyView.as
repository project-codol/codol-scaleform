package codo.views
{
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionInGameContainer;
   import codo.component.TextField;
   import codo.constants.BCEvent;
   import codo.constants.BCInGameEvent;
   import codo.constants.SpyModeRoleType;
   import codo.constants.SpyRoundType;
   import codo.localization.Dict;
   import codo.localization.DictHud;
   import codo.localization.DictSpy;
   import codo.pausemenu.pauseMenuSpyViewSkillItem;
   import codo.style.SpyHudGuide;
   import codo.utils.PauseUtil;
   import codo.views.PauseMenuSpyView_parts.PauseMenuSpyViewAllRoleDescPanel;
   import codo.views.PauseMenuSpyView_parts.PauseMenuSpyViewRoleInfoPanel;
   import codo.views.PauseMenuSpyView_parts.PauseMenuSpyViewSkillItem;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.filters.DropShadowFilter;
   import flash.utils.getDefinitionByName;
   import fsg.shared.BehaviourAnimatedClickable;
   import fsg.shared.BehaviourAudio;
   import fsg.shared.BehaviourClickable;
   
   public class PauseMenuSpyView extends FsgPauseMenuBaseView
   {
      
      public const MAX_DISPLAY_TIPS:int = 10;
      
      public const TIPS_PADDING:int = 43;
      
      public const TIPS_MARGIN_X:int = 10;
      
      public const TIPS_MARGIN_Y:int = 30;
      
      private const SKILL_PANEL_TOTAL_HEIGHT:int = 528;
      
      private const SKILL_ITEM_HEIGHT:int = 55;
      
      private const SKILL_MAX_MARGIN_SIZE:int = 44;
      
      public var myItemsHolder:MovieClip;
      
      public var myRoleDescPanel:PauseMenuSpyViewRoleInfoPanel;
      
      public var myItemsTitleTF:TextField;
      
      public var myAllRoleDescPanel:PauseMenuSpyViewAllRoleDescPanel;
      
      public var myTipsBg:MovieClip;
      
      public var myKickBtn:MovieClip;
      
      private var mItems:Vector.<DisplayObject>;
      
      private var mKickBehavior:BehaviourClickable;
      
      private var mKickAnimatedBehavior:BehaviourAnimatedClickable;
      
      private var mKickAudioBehavior:BehaviourAudio;
      
      public function PauseMenuSpyView()
      {
         super();
      }
      
      override protected function onInit() : void
      {
         super.onInit();
         myOptions.myBrightness.visible = false;
         myOptions.myMouseSensitivityY.visible = false;
         this.mItems = new Vector.<DisplayObject>(0);
      }
      
      override protected function onInitListener() : void
      {
         super.onInitListener();
         this.myKickBtn.myComplainsTextTF.text = Dict.KICK_USER;
         this.mKickBehavior = new BehaviourClickable(this.myKickBtn.myHitArea);
         this.mKickAnimatedBehavior = new BehaviourAnimatedClickable(this.myKickBtn,this.mKickBehavior,1,2,2,3);
         this.mKickAudioBehavior = new BehaviourAudio(this.mKickBehavior);
         this.mKickBehavior.addClickCallback(this.onKickButtonClicked);
      }
      
      override protected function showView() : void
      {
         var role:int = 0;
         super.showView();
         var blur:Number = 2;
         CFunctionCommonContainer.SetUIBlur(blur);
         CFunctionInGameContainer.AS_SpyMode_HideSelectSkillPanel();
         broadcast(BCInGameEvent.HIDE_NOTIFICATION_POPUP);
         role = CFunctionInGameContainer.AS_SpyMode_GetSelfRole();
         var isCasualRound:Boolean = CFunctionInGameContainer.AS_SpyMode_GetRoundType() != SpyRoundType.ROUND_NORMAL;
         if(role == SpyModeRoleType.SPY_ROLE_NONE || isCasualRound)
         {
            this.myRoleDescPanel.visible = false;
            this.myAllRoleDescPanel.visible = true;
            this.updateTipsList();
         }
         else if(role == SpyModeRoleType.SPY_ROLE_CIVILIAN)
         {
            this.myRoleDescPanel.visible = true;
            this.myAllRoleDescPanel.visible = false;
            this.myRoleDescPanel.setData(SpyModeRoleType.SPY_ROLE_CIVILIAN);
            this.updateSkillList(role);
         }
         else
         {
            this.myRoleDescPanel.visible = true;
            this.myAllRoleDescPanel.visible = false;
            this.myRoleDescPanel.setData(role);
            this.updateSkillList(role);
         }
         myFrame.visible = false;
         myTitle.visible = false;
         myTabNavigation.visible = false;
         PauseUtil.disableMap();
      }
      
      private function updateSkillList(role:int) : void
      {
         var i:int = 0;
         var skillObj:Object = null;
         var item:PauseMenuSpyViewSkillItem = null;
         var totalGapSize:int = 0;
         var gapSize:int = 0;
         var nextSkillItemYPos:int = 0;
         var skillItem:PauseMenuSpyViewSkillItem = null;
         this.myTipsBg.visible = false;
         this.myItemsTitleTF.text = DictHud.SPY_SKILL_TITLE;
         var skillsArr:Object = CFunctionInGameContainer.AS_SpyMode_GetSkillsByRole(role);
         if(role == SpyModeRoleType.SPY_ROLE_SPY)
         {
            this.myItemsTitleTF.textStyle = SpyHudGuide.PauseMenuSpyViewSkillTitleSpy;
         }
         else if(role == SpyModeRoleType.SPY_ROLE_INVESTIGATOR)
         {
            this.myItemsTitleTF.textStyle = SpyHudGuide.PauseMenuSpyViewSkillTitleInvestigator;
         }
         else
         {
            this.myItemsTitleTF.textStyle = SpyHudGuide.PauseMenuSpyViewSkillTitleCivilian;
            this.myItemsTitleTF.text = DictHud.SPY_AIRDROP_TITLE;
            skillsArr = CFunctionInGameContainer.AS_SpyGetAirdropSkills();
         }
         while(this.myItemsHolder.numChildren > 0)
         {
            this.myItemsHolder.removeChildAt(0);
         }
         this.mItems = new Vector.<DisplayObject>(0);
         for(i = 0; i < skillsArr.length; i++)
         {
            skillObj = skillsArr[i];
            item = new pauseMenuSpyViewSkillItem();
            this.myItemsHolder.addChild(item);
            item.gotoAndStop(role);
            this.mItems.push(item);
            item.setData(skillObj);
         }
         if(this.mItems.length > 0)
         {
            totalGapSize = this.SKILL_PANEL_TOTAL_HEIGHT - this.mItems.length * this.SKILL_ITEM_HEIGHT;
            gapSize = this.mItems.length > 1 ? int(totalGapSize / (this.mItems.length - 1)) : 0;
            if(gapSize > this.SKILL_MAX_MARGIN_SIZE)
            {
               gapSize = this.SKILL_MAX_MARGIN_SIZE;
            }
            nextSkillItemYPos = 0;
            for(i = 0; i < this.mItems.length; i++)
            {
               skillItem = this.mItems[i] as PauseMenuSpyViewSkillItem;
               skillItem.x = 0;
               skillItem.y = nextSkillItemYPos;
               nextSkillItemYPos += gapSize + this.SKILL_ITEM_HEIGHT;
            }
         }
      }
      
      private function updateTipsList() : void
      {
         var i:int = 0;
         var ix1:int = 0;
         var ix2:int = 0;
         var tmp:String = null;
         var cls:Class = null;
         var tipTF:TextField = null;
         this.myTipsBg.visible = true;
         this.myItemsTitleTF.text = DictSpy.PAUSE_MENU_ALLROLE_TIPS_TITLE;
         this.myItemsTitleTF.textStyle = SpyHudGuide.PauseMenuSpyViewTipsTitle;
         while(this.myItemsHolder.numChildren > 0)
         {
            this.myItemsHolder.removeChildAt(0);
         }
         var tips:Array = CFunctionInGameContainer.AS_SpyMode_GetPauseMenuTips();
         for(i = 0; i < tips.length; i++)
         {
            ix1 = Math.floor(Math.random() * tips.length);
            ix2 = Math.floor(Math.random() * tips.length);
            ix1 = ix1 < tips.length ? ix1 : int(tips.length - 1);
            ix2 = ix2 < tips.length ? ix2 : int(tips.length - 1);
            tmp = tips[ix1];
            tips[ix1] = tips[ix2];
            tips[ix2] = tmp;
         }
         i = 0;
         while(i < tips.length && i < this.MAX_DISPLAY_TIPS)
         {
            cls = getDefinitionByName("codo.shared.TextField") as Class;
            tipTF = this.myItemsHolder.addChild(new cls()) as TextField;
            this.mItems.push(tipTF);
            tipTF.textStyle = SpyHudGuide.PauseMenuAllRoleTip;
            tipTF.text = "@" + tips[i];
            tipTF.filters = [new DropShadowFilter(4,45,0,1,2,2,0.6,1)];
            tipTF.x = this.TIPS_MARGIN_X;
            tipTF.y = i * this.TIPS_PADDING + this.TIPS_MARGIN_Y;
            i++;
         }
      }
      
      override protected function hideView() : void
      {
         super.hideView();
         broadcast(BCEvent.EVT_KICK_CANCEL);
         broadcast(BCEvent.EVT_COMPLAINT_CANCEL);
         var blur:Number = 0;
         CFunctionCommonContainer.SetUIBlur(blur);
      }
      
      private function onKickButtonClicked() : void
      {
         broadcast(BCEvent.EVT_VOTE_ACTIVE_PLAYER);
      }
   }
}

