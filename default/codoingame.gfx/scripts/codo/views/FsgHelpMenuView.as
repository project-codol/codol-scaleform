package codo.views
{
   import codo.base.BaseView;
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionInGameContainer;
   import codo.constants.GameInfo;
   import codo.constants.HelpMenuData;
   import codo.constants.QuickMatchType;
   import codo.constants.SpyModeRoleType;
   import codo.services.InGameService;
   import codo.utils.AsymPvpUtil;
   import codo.utils.LocalizeUtil;
   import codo.views.hudSpy.HelpMenuRoleInfo;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.text.TextField;
   import fsg.shared.InputIconUtility;
   import fsg.util.FsgImageHolder;
   
   public class FsgHelpMenuView extends BaseView
   {
      
      private static const TIP_TOP_MARGIN:Number = 20;
      
      private static const TIP_PADDING:Number = 20;
      
      private static const CONTROL_TIP_PADDING:Number = 50;
      
      private static const ANIM_DURATION:Number = 0.1;
      
      private static const FADED_OUT_Z:Number = -40;
      
      private static const CONTROLS_DEFAULT_X:Number = 662;
      
      private static const CONTROLS_CENTER_X:Number = 516;
      
      private static const NUM_ZCHAMP_ICONS:uint = 4;
      
      private static const SPY_ROLE_INFO_PADDING:Number = 100;
      
      public var myTitleText:MovieClip;
      
      public var myBG:MovieClip;
      
      public var myTips:Vector.<MovieClip>;
      
      public var myTip1:MovieClip;
      
      public var myTip2:MovieClip;
      
      public var myTip3:MovieClip;
      
      public var myControls:Vector.<MovieClip>;
      
      public var myControl1:MovieClip;
      
      public var myControl2:MovieClip;
      
      public var myControl3:MovieClip;
      
      public var myZombieArenaSkills:MovieClip;
      
      public var myZombieChampionIconLegend:MovieClip;
      
      public var mySpyInvestigaterInfo:HelpMenuRoleInfo;
      
      public var mySpySpyInfo:HelpMenuRoleInfo;
      
      public var myHUDHelpers:Vector.<MovieClip>;
      
      public var myHUDHelper1:MovieClip;
      
      public var myHUDHelper2:MovieClip;
      
      public var myHUDHelper3:MovieClip;
      
      public var myHUDHelper4:MovieClip;
      
      public var myHUDHelper5:MovieClip;
      
      public var myHUDHelper6:MovieClip;
      
      public var myHUDHelper7:MovieClip;
      
      public var myHUDHelper8:MovieClip;
      
      public var myTopDivider:MovieClip;
      
      public var myTopDividerGlow:MovieClip;
      
      public var myMostTopDivider:MovieClip;
      
      public var myBottomDivider:MovieClip;
      
      public var myScrim:MovieClip;
      
      private var m_gameMode:String;
      
      private var m_controlsHeight:Number;
      
      private var m_tipsHeight:Number;
      
      private var m_isAsymMonster:Boolean;
      
      private var mTransitionTween:TweenLite;
      
      public function FsgHelpMenuView()
      {
         super();
         this.myTips = new <MovieClip>[this.myTip1,this.myTip2,this.myTip3];
         this.myControls = new <MovieClip>[this.myControl1,this.myControl2,this.myControl3];
         this.myHUDHelpers = new <MovieClip>[this.myHUDHelper1,this.myHUDHelper2,this.myHUDHelper3,this.myHUDHelper4,this.myHUDHelper5,this.myHUDHelper6,this.myHUDHelper7,this.myHUDHelper8];
         this.m_gameMode = "";
         this.alpha = 0;
         this.z = FADED_OUT_Z;
      }
      
      override protected function onInit() : void
      {
      }
      
      override protected function showView() : void
      {
         var i:uint = 0;
         var helpMenuData:HelpMenuData = null;
         var bHasTips:Boolean = false;
         super.showView();
         var setGameMode:String = CFunctionCommonContainer.Dvar_GetString("ui_gametype");
         if(setGameMode == QuickMatchType.ID_COOP_HERO_OPS_SURVIVAL && InGameService.getInstance().curMapIsSurvival())
         {
            setGameMode = QuickMatchType.ID_SURVIVAL;
         }
         var setIsAsymMonster:Boolean = Boolean(CFunctionCommonContainer.GametypeUsesAsymRobots(setGameMode)) && AsymPvpUtil.instance.isAsymMonster;
         var bModeChanged:Boolean = this.m_gameMode != setGameMode || this.m_isAsymMonster != setIsAsymMonster || this.m_gameMode == "spy";
         var bStageChanged:Boolean = this.myBG.width != GameInfo.stageSize.x || this.myBG.height != GameInfo.stageSize.y;
         if(bModeChanged || bStageChanged)
         {
            helpMenuData = new HelpMenuData();
            if(bModeChanged)
            {
               this.myTitleText.myTitleTF.text = LocalizeUtil.localize(CFunctionCommonContainer.AS_GetGameTypeDisplayName()).toUpperCase();
               this.m_gameMode = setGameMode;
               this.m_isAsymMonster = setIsAsymMonster;
               if(this.m_gameMode == "spy")
               {
                  this.myZombieArenaSkills.visible = false;
                  this.myZombieChampionIconLegend.visible = false;
                  this.myScrim.visible = false;
                  this.myTopDivider.visible = false;
                  this.myTopDividerGlow.visible = false;
                  this.myMostTopDivider.visible = false;
                  this.myBottomDivider.visible = false;
                  this.myTitleText.visible = false;
                  for(i = 0; i < this.myTips.length; i++)
                  {
                     this.myTips[i].visible = false;
                  }
                  for(i = 0; i < this.myControls.length; i++)
                  {
                     this.myControls[i].visible = false;
                  }
                  this.mySpyInvestigaterInfo.visible = true;
                  this.mySpySpyInfo.visible = true;
                  this.mySpyInvestigaterInfo.setRole(SpyModeRoleType.SPY_ROLE_INVESTIGATOR);
                  this.mySpySpyInfo.setRole(SpyModeRoleType.SPY_ROLE_SPY);
               }
               else
               {
                  this.myTitleText.visible = true;
                  this.mySpyInvestigaterInfo.visible = false;
                  this.mySpySpyInfo.visible = false;
                  this.myScrim.visible = true;
                  this.myTopDivider.visible = true;
                  this.myTopDividerGlow.visible = true;
                  this.myMostTopDivider.visible = true;
                  this.myBottomDivider.visible = true;
                  if(!CFunctionInGameContainer.IsZombieMPGametype(this.m_gameMode))
                  {
                     bHasTips = this.updateGameModeTips();
                     this.updateGameModeControls(helpMenuData.ControlData,!bHasTips);
                     this.myZombieArenaSkills.visible = false;
                     this.myZombieChampionIconLegend.visible = false;
                  }
                  else
                  {
                     for(i = 0; i < this.myTips.length; i++)
                     {
                        this.myTips[i].visible = false;
                     }
                     for(i = 0; i < this.myControls.length; i++)
                     {
                        this.myControls[i].visible = false;
                     }
                     this.myZombieArenaSkills.visible = true;
                     this.myZombieChampionIconLegend.visible = this.m_gameMode == "zchamp";
                  }
               }
               this.redrawVisuals();
            }
            if(bStageChanged)
            {
               this.myBG.width = GameInfo.stageSize.x;
               this.myBG.height = GameInfo.stageSize.y;
               this.myBG.x = GameInfo.stagePosition.x;
               this.myBG.y = GameInfo.stagePosition.y;
            }
            this.updateHUDHelpers(helpMenuData.HUDHelperData);
            helpMenuData = null;
         }
         if(Boolean(CFunctionInGameContainer.IsZombieMPGametype(this.m_gameMode)))
         {
            this.updateZombieArenaSkills();
            if(this.m_gameMode == "zchamp")
            {
               this.updateZombieChampionIcons();
            }
         }
         if(this.mTransitionTween != null)
         {
            this.mTransitionTween.pause();
         }
         this.mTransitionTween = new TweenLite(this,ANIM_DURATION,{
            "z":0,
            "alpha":1
         });
      }
      
      override protected function hideView() : void
      {
         if(this.mTransitionTween != null)
         {
            this.mTransitionTween.pause();
         }
         this.mTransitionTween = new TweenLite(this,ANIM_DURATION,{
            "z":FADED_OUT_Z,
            "alpha":0,
            "onComplete":this.onHideComplete
         });
      }
      
      private function onHideComplete() : void
      {
         super.hideView();
      }
      
      private function updateGameModeTips() : Boolean
      {
         var currentTip:MovieClip = null;
         var itemHeight:Number = NaN;
         var textField:TextField = null;
         var isTipEnabled:int = 0;
         var tipText:String = "";
         itemHeight = 0;
         var currentY:Number = this.myScrim.y + TIP_TOP_MARGIN;
         var bHasTips:Boolean = false;
         this.m_tipsHeight = 0;
         for(var i:uint = 0; i < this.myTips.length; i++)
         {
            currentTip = this.myTips[i];
            isTipEnabled = CFunctionCommonContainer.Dvar_GetInt("loadHintEnable_" + i);
            itemHeight = 0;
            if(isTipEnabled != 0)
            {
               textField = currentTip.myTipTitle;
               textField.text = LocalizeUtil.localize("@" + CFunctionCommonContainer.Dvar_GetString("loadHintName_" + i)).toUpperCase();
               itemHeight += textField.textHeight;
               textField = currentTip.myTipText;
               tipText = LocalizeUtil.getLocalizationWithKeyBinding("@" + CFunctionCommonContainer.Dvar_GetString("loadHintDesc_" + i));
               textField.text = LocalizeUtil.removeColorTags(tipText);
               itemHeight += textField.textHeight;
               currentTip.y = currentY;
               currentY += itemHeight + TIP_PADDING;
               this.m_tipsHeight += itemHeight + TIP_PADDING;
               currentTip.visible = true;
               bHasTips = true;
            }
            else
            {
               currentTip.visible = false;
            }
         }
         return bHasTips;
      }
      
      private function updateGameModeControls(data:Vector.<Object>, bCenterControls:Boolean) : void
      {
         var dataForMode:Array = null;
         var textField:TextField = null;
         var currentControl:MovieClip = null;
         var currentControlKey:InputIconUtility = null;
         var myBlankKey:MovieClip = null;
         var controlData:Object = null;
         var i:uint = 0;
         var j:uint = 0;
         var currentY:Number = this.myScrim.y + TIP_TOP_MARGIN;
         this.m_controlsHeight = 0;
         loop0:
         for(i = 0; i < data.length - 1; i++)
         {
            for(j = 0; j < data[i].modes.length; j++)
            {
               if(data[i].modes[j] == this.m_gameMode)
               {
                  if(!this.m_isAsymMonster)
                  {
                     dataForMode = data[i].data;
                  }
                  else
                  {
                     dataForMode = data[i].data2;
                  }
                  break loop0;
               }
            }
         }
         if(!dataForMode)
         {
            dataForMode = data[data.length - 1].data;
         }
         for(var k:uint = 0; k < this.myControls.length; k++)
         {
            currentControl = this.myControls[k];
            currentControlKey = currentControl.myKeyBinding;
            myBlankKey = currentControl.myBlankKey;
            if(Boolean(dataForMode) && Boolean(k < dataForMode.length) && Boolean(dataForMode[k]))
            {
               controlData = dataForMode[k];
               myBlankKey.visible = !currentControlKey.setForCommand(controlData.command);
               textField = currentControl.myCommandTitle;
               textField.text = controlData.title;
               currentControl.x = bCenterControls ? CONTROLS_CENTER_X : CONTROLS_DEFAULT_X;
               currentControl.y = currentY;
               currentY += textField.textHeight + CONTROL_TIP_PADDING;
               this.m_controlsHeight += textField.textHeight + CONTROL_TIP_PADDING;
               currentControl.visible = true;
            }
            else
            {
               currentControlKey.clear();
               currentControl.visible = false;
            }
         }
      }
      
      private function updateZombieArenaSkills() : void
      {
         var skills:Array = null;
         var slot:MovieClip = null;
         var image:FsgImageHolder = null;
         var index:TextField = null;
         var title:TextField = null;
         var desc:TextField = null;
         var len:uint = 0;
         var maxVisible:uint = 0;
         var i:uint = 0;
         var skillData:Object = CFunctionInGameContainer.AS_ZombieArenaGetMySkillInfo();
         if(Boolean(skillData))
         {
            skills = skillData.skills;
            image = new FsgImageHolder();
            index = new TextField();
            title = new TextField();
            desc = new TextField();
            len = skills.length;
            maxVisible = 7;
            if(this.m_gameMode == "zsurv")
            {
               maxVisible = 3;
            }
            else if(this.m_gameMode == "zchamp")
            {
               maxVisible = 4;
            }
            for(i = 0; i < len; i++)
            {
               slot = this.myZombieArenaSkills["ability" + i];
               slot.visible = i < maxVisible;
               if(slot.visible)
               {
                  image = slot.myImage;
                  if(Boolean(image))
                  {
                     image.setImage(skills[i].image);
                  }
                  index = slot.myIndex;
                  if(Boolean(index))
                  {
                     index.text = LocalizeUtil.localizeFirstKeyBindingForCommand(skills[i].keybind);
                  }
                  title = slot.myTitle;
                  if(Boolean(title))
                  {
                     title.text = skills[i].label;
                  }
                  desc = slot.myDesc;
                  if(Boolean(desc))
                  {
                     desc.text = skills[i].description;
                  }
               }
            }
            image = this.myZombieArenaSkills["role"];
            if(Boolean(image))
            {
               image.setImage(skillData.roleInfo.image);
            }
            title = this.myZombieArenaSkills["roleTitle"];
            if(Boolean(title))
            {
               title.text = skillData.roleInfo.label;
            }
         }
      }
      
      private function updateZombieChampionIcons() : void
      {
         var beacons:Array = null;
         var clip:MovieClip = null;
         beacons = CFunctionInGameContainer.AS_ZChampGetBeacons();
         var len:uint = beacons.length;
         var image:FsgImageHolder = new FsgImageHolder();
         var title:TextField = new TextField();
         var desc:TextField = new TextField();
         for(var i:uint = 0; i < NUM_ZCHAMP_ICONS; i++)
         {
            clip = this.myZombieChampionIconLegend["myClip" + i];
            if(Boolean(clip))
            {
               if(i < len)
               {
                  image = clip.myImage;
                  title = clip.myTitle;
                  desc = clip.myDesc;
                  image.setImage(beacons[i].image);
                  title.text = beacons[i].title;
                  desc.text = beacons[i].desc;
                  clip.visible = true;
               }
               else
               {
                  clip.visible = false;
               }
            }
         }
         var stageCoord:Point = GameInfo.getStageCoordForAnchorAndOffset(GameInfo.TOP_LEFT,new Point(20,450));
         this.myZombieChampionIconLegend.x = stageCoord.x;
         this.myZombieChampionIconLegend.y = stageCoord.y;
      }
      
      private function updateHUDHelpers(data:Vector.<Object>) : void
      {
         var dataForMode:Array = null;
         var currentHelper:MovieClip = null;
         var helperData:Object = null;
         var anchor:Point = null;
         var offset:Point = null;
         var stageCoord:Point = null;
         var i:uint = 0;
         var j:uint = 0;
         loop0:
         for(i = 0; i < data.length - 1; i++)
         {
            for(j = 0; j < data[i].modes.length; j++)
            {
               if(data[i].modes[j] == this.m_gameMode)
               {
                  if(!this.m_isAsymMonster)
                  {
                     dataForMode = data[i].data;
                  }
                  else
                  {
                     dataForMode = data[i].data2;
                  }
                  break loop0;
               }
            }
         }
         if(!dataForMode)
         {
            dataForMode = data[data.length - 1].data;
         }
         for(var k:uint = 0; k < this.myHUDHelpers.length; k++)
         {
            currentHelper = this.myHUDHelpers[k];
            if(Boolean(dataForMode) && Boolean(k < dataForMode.length) && Boolean(dataForMode[k]))
            {
               helperData = dataForMode[k];
               currentHelper.myHelperText.width = helperData.width;
               currentHelper.myHelperTitle.text = LocalizeUtil.localize(helperData.title);
               currentHelper.myHelperText.text = LocalizeUtil.localize(helperData.desc);
               anchor = helperData.anchor;
               offset = new Point(helperData.x,helperData.y);
               stageCoord = GameInfo.getStageCoordForAnchorAndOffset(anchor,offset);
               currentHelper.x = stageCoord.x;
               currentHelper.y = stageCoord.y;
               currentHelper.visible = true;
            }
            else
            {
               currentHelper.visible = false;
            }
         }
      }
      
      private function redrawVisuals() : void
      {
         var height:Number = (this.m_controlsHeight > this.m_tipsHeight ? this.m_controlsHeight : this.m_tipsHeight) + TIP_TOP_MARGIN;
         this.myScrim.height = height;
         this.myBottomDivider.y = this.myScrim.y + height;
         this.mySpyInvestigaterInfo.x = this.myBG.width / 2 + this.myBG.x - this.mySpyInvestigaterInfo.width - SPY_ROLE_INFO_PADDING;
         this.mySpySpyInfo.x = this.myBG.width / 2 + this.myBG.x + SPY_ROLE_INFO_PADDING;
      }
   }
}

