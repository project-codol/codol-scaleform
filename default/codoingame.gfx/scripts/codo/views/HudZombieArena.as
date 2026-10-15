package codo.views
{
   import codo.base.BaseView;
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionInGameContainer;
   import codo.constants.GameInfo;
   import codo.localization.DictHud;
   import codo.objects.ZombieArenaSpecializationObj;
   import codo.style.ZombieHudGuide;
   import codo.utils.LocalizeUtil;
   import codo.utils.ShoutcastUtil;
   import codo.views.hudZombieArena.ZombieArenaGamblerHUD;
   import codo.views.hudZombieArena.ZombieArenaIntro;
   import codo.views.hudZombieArena.ZombieArenaRoleSelection;
   import codo.views.hudZombieArena.ZombieArenaSelectedSpecializations;
   import codo.views.hudZombieArena.ZombieArenaSpecializationReroll;
   import codo.views.hudZombieArena.ZombieArenaSpecializationSelection;
   import codo.views.hudZombieArena.ZombieChampionHealthbar;
   import codo.views.hudZombieArena.ZombieChampionsAttributes;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.events.KeyboardEvent;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   
   public class HudZombieArena extends BaseView
   {
      
      private static const FADE_DURATION:Number = 0.2;
      
      private static const MAX_SCOREBOARD_ROWS:uint = 4;
      
      private static const MAX_ABILITIES:uint = 7;
      
      public var myIntro:ZombieArenaIntro;
      
      public var myRoleSelection:ZombieArenaRoleSelection;
      
      public var mySpecializationSelection:ZombieArenaSpecializationSelection;
      
      public var mySelectedSpecializations:ZombieArenaSelectedSpecializations;
      
      public var mySpecializationReroll:ZombieArenaSpecializationReroll;
      
      public var myLeftContainer:MovieClip;
      
      public var myScoreboard:MovieClip;
      
      public var myBossHealthBar:MovieClip;
      
      public var myGamblerHUD:ZombieArenaGamblerHUD;
      
      public var myZombieChampionHealthbar:ZombieChampionHealthbar;
      
      public var myBombHUD:MovieClip;
      
      public var myZChampAttributes:ZombieChampionsAttributes;
      
      public var myZChampUpgrade:ZombieArenaSpecializationSelection;
      
      public var myAttributesHint:MovieClip;
      
      private var mIsZSurv:Boolean;
      
      public function HudZombieArena()
      {
         super();
         this.myIntro.visible = false;
         this.myRoleSelection.visible = false;
         this.mySpecializationSelection.visible = false;
         this.myBossHealthBar.visible = false;
         this.myZombieChampionHealthbar.visible = false;
         this.myBombHUD.visible = false;
         this.myZChampAttributes.visible = false;
         this.myZChampUpgrade.visible = false;
         this.myAttributesHint.myAnim.myText.text = "@ZCHAMP_ATTRIBUTE_HINT";
      }
      
      override public function init() : void
      {
         super.init();
      }
      
      override protected function showView() : void
      {
         var stagePosition:Point = null;
         var curClip:MovieClip = null;
         var j:uint = 0;
         super.showView();
         this.mIsZSurv = CFunctionCommonContainer.Dvar_GetString("ui_gametype") == "zsurv";
         var stageSize:Point = GameInfo.stageSize;
         stagePosition = GameInfo.stagePosition;
         this.mySelectedSpecializations.x = stagePosition.x + (stageSize.x - GameInfo.DEFAULT_WIDTH);
         this.mySelectedSpecializations.y = stagePosition.y + (stageSize.y - GameInfo.DEFAULT_HEIGHT);
         this.myLeftContainer.x = stagePosition.x;
         this.myLeftContainer.y = stagePosition.y + (stageSize.y - GameInfo.DEFAULT_HEIGHT);
         this.myScoreboard.x = GameInfo.DEFAULT_WIDTH * 0.5 - this.myScoreboard.width * 0.5;
         this.myScoreboard.y = GameInfo.DEFAULT_HEIGHT * 0.5;
         this.mySelectedSpecializations.myEmpoweredIcon.setImage("za_support_empower");
         var colorTransform:ColorTransform = new ColorTransform();
         colorTransform.color = ZombieHudGuide.getSpecializationColor(ZombieArenaSpecializationObj.SPECIALIZATION_NONE);
         colorTransform.alphaMultiplier = 0.4;
         var maxVisible:uint = this.mIsZSurv ? 3 : MAX_ABILITIES;
         for(var i:uint = 0; i < MAX_SCOREBOARD_ROWS; i++)
         {
            curClip = this.myScoreboard["myRow" + i];
            curClip.myTreeColor.transform.colorTransform = colorTransform;
            for(j = 0; j < MAX_ABILITIES; j++)
            {
               curClip["bg" + j].visible = curClip["ability" + j].visible = j < maxVisible;
            }
         }
         if(this.mIsZSurv)
         {
            this.myGamblerHUD.y += 300;
            this.mySpecializationReroll.y += 300;
         }
         if(CFunctionCommonContainer.Dvar_GetString("ui_gametype") == "zchamp")
         {
            this.myZombieChampionHealthbar.x = this.myLeftContainer.x;
            this.myBombHUD.x = this.myLeftContainer.x;
            this.myLeftContainer.gotoAndStop(2);
            this.myBossHealthBar.myFrame.gotoAndStop(2);
            this.myZombieChampionHealthbar.visible = true;
            this.myBombHUD.visible = true;
         }
         CFunctionInGameContainer.AS_RegisterHUDView(CFunctionInGameContainer.HVT_ZArena,this);
         ShoutcastUtil.getInstance().registerView(this);
      }
      
      override protected function hideView() : void
      {
         super.hideView();
      }
      
      public function showIntro() : void
      {
         this.myIntro.visible = true;
         this.myIntro.playIntro();
      }
      
      public function hideIntro() : void
      {
         this.myIntro.visible = false;
      }
      
      public function showRoleSelection() : void
      {
         this.myRoleSelection.visible = true;
         TweenLite.to(this.myRoleSelection,FADE_DURATION,{"alpha":1});
      }
      
      public function hideRoleSelection() : void
      {
         TweenLite.to(this.myRoleSelection,FADE_DURATION,{
            "alpha":0,
            "onComplete":this.onHideElementComplete,
            "onCompleteParams":this.myRoleSelection
         });
      }
      
      public function showSpecializationSelection() : void
      {
         this.mySpecializationSelection.visible = true;
         TweenLite.to(this.mySpecializationSelection,FADE_DURATION,{"alpha":1});
      }
      
      public function hideSpecializationSelection() : void
      {
         TweenLite.to(this.mySpecializationSelection,FADE_DURATION,{
            "alpha":0,
            "onComplete":this.onHideElementComplete,
            "onCompleteParams":this.mySpecializationSelection
         });
      }
      
      private function onHideElementComplete(element:MovieClip) : void
      {
         element.visible = false;
      }
      
      public function cppSetZombieArenaRerollData(data:Object) : void
      {
         this.mySpecializationReroll.setData(data,this.mIsZSurv);
      }
      
      public function cppSetZombieArenaRoleSelectionData(data:Object) : void
      {
         this.myRoleSelection.setData(data);
      }
      
      public function cppSetZombieArenaSpecializationSelectionData(data:Object) : void
      {
         this.mySpecializationSelection.setData(data,false);
         this.mySpecializationSelection.setHeader(LocalizeUtil.localize(DictHud.ZOMBIE_ARENA_SPECIALIZATION_SELECTION_HEADER));
      }
      
      public function cppSetZombieSkillScoreboardData(data:Array) : void
      {
         var curData:Object = null;
         var curClip:MovieClip = null;
         var curHudPlayerRow:MovieClip = null;
         var colorTransform:ColorTransform = null;
         var skillsLength:uint = 0;
         var j:uint = 0;
         var curSkillClip:MovieClip = null;
         var length:uint = data.length;
         for(var i:uint = 0; i < length; i++)
         {
            curData = data[i];
            curClip = this.myScoreboard["myRow" + curData.client];
            if(Boolean(curData.roleInfo))
            {
               curHudPlayerRow = this.mySelectedSpecializations["hudPlayerRow" + curData.client];
               curClip.myTree.setImage(curData.roleInfo.image);
               colorTransform = new ColorTransform();
               colorTransform.color = ZombieHudGuide.getSpecializationColor(curData.roleInfo.type);
               colorTransform.alphaMultiplier = 0.4;
               curClip.myTreeColor.transform.colorTransform = colorTransform;
               curHudPlayerRow.myImage.setImage(curData.roleInfo.image);
            }
            if(Boolean(curData.skills))
            {
               skillsLength = uint(curData.skills.length);
               for(j = 0; j < skillsLength; j++)
               {
                  curSkillClip = curClip["ability" + j];
                  curSkillClip.setImage(curData.skills[j]);
               }
            }
         }
      }
      
      public function cppQueueGamblerRoll(data:Object) : void
      {
         this.myGamblerHUD.animateRoll(data);
      }
      
      public function cppSetZombieChampionUpgradeData(data:Object) : void
      {
         this.myZChampUpgrade.setData(data,true);
         this.myZChampUpgrade.setHeader(LocalizeUtil.localize(DictHud.ZOMBIE_ARENA_UPGRADE_SELECTION_HEADER));
      }
      
      public function cppSetAttributeBalance(balance:int = 0) : void
      {
         this.myZChampAttributes.setBalance(balance);
      }
      
      public function cppShowAttributes(allocations:Array = null) : void
      {
         this.myZChampAttributes.show(allocations);
         this.myAttributesHint.alpha = 0.1;
      }
      
      public function cppHideAttributes() : void
      {
         this.myZChampAttributes.hide();
         this.myAttributesHint.alpha = 1;
      }
      
      public function cppSetStageListenersActive() : void
      {
         stage.addEventListener(KeyboardEvent.KEY_DOWN,this.handleSelectionMade);
      }
      
      public function cppSetStageListenersDeactive() : void
      {
         stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.handleSelectionMade);
      }
      
      private function handleSelectionMade(evt:KeyboardEvent) : void
      {
         if(CFunctionCommonContainer.GetKeyBindingValuesFromCommand("+tact").indexOf(evt.charCode) != -1)
         {
            CFunctionInGameContainer.AS_ZombieArenaHandleSelection(0);
         }
         else if(CFunctionCommonContainer.GetKeyBindingValuesFromCommand("+melee").indexOf(evt.charCode) != -1)
         {
            CFunctionInGameContainer.AS_ZombieArenaHandleSelection(1);
         }
      }
   }
}

