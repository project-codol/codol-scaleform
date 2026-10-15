package codo.views
{
   import codo.base.BaseView;
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.constants.QuickMatchType;
   import codo.constants.TutorialMap;
   import codo.constants.UIStencils;
   import codo.localization.Dict;
   import codo.localization.DictGameModeSummaryPopup;
   import codo.objects.GameModeSummaryPopupContentObj;
   import codo.objects.MatchSelectOptionObj;
   import codo.objects.ModeObj;
   import codo.objects.PlayerObj;
   import codo.services.TutorialService;
   import codo.utils.LocalizeUtil;
   import components.matchselect_part.MatchSelectBaseElems;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.utils.getDefinitionByName;
   
   public class MatchSelectBaseView extends BaseView
   {
      
      public static const LIST_ROWS:int = 6;
      
      private static const PLAYER_LEVEL_TRAINING_CAP:uint = 10;
      
      public var myBaseElems:MatchSelectBaseElems;
      
      private var _detect3DRotationOrgX:Number;
      
      private var _detect3DRotationOrgY:Number;
      
      private var _selectedGameMode:String;
      
      private var _gameModeButtonRef:DisplayObject;
      
      private var _selectedGameModeTutorial:String;
      
      public function MatchSelectBaseView()
      {
         super();
         this.myBaseElems.myImgSlider.myMissionLocked.visible = false;
         this.myBaseElems.my3DRotationHitarea.gotoAndStop(1);
         this.myBaseElems.my3DRotationHitarea.alpha = 0;
         this.myBaseElems.myTitleText.visible = false;
      }
      
      public static function SetHeader(param1:MovieClip, param2:String) : void
      {
         var _loc3_:TextField = param1["myHeader"];
         _loc3_.autoSize = TextFieldAutoSize.LEFT;
         _loc3_.text = LocalizeUtil.localize(param2).toUpperCase();
      }
      
      protected function onGamemodeTutorialButtonClick() : void
      {
         broadcast(BCEvent.EVT_OPEN_GAME_MODE_TUTORIAL,this._selectedGameModeTutorial);
      }
      
      public function set selectedGameModeTutorial(param1:String) : void
      {
         this._selectedGameModeTutorial = param1;
      }
      
      protected function get gameModeButtonRef() : DisplayObject
      {
         return this._gameModeButtonRef;
      }
      
      protected function set gameModeButtonRef(param1:DisplayObject) : void
      {
         this._gameModeButtonRef = param1;
      }
      
      protected function get selectedGameMode() : String
      {
         return this._selectedGameMode;
      }
      
      protected function set selectedGameMode(param1:String) : void
      {
         if(param1 == null)
         {
            return;
         }
         this._selectedGameMode = this._selectedGameModeTutorial = param1;
         TutorialService.getInstance().getContentByGameType(param1.toLowerCase()).length > 0;
      }
      
      public function checkGameModeHasTutorial(param1:String) : Boolean
      {
         return TutorialService.getInstance().getContentByGameType(param1).length > 0;
      }
      
      public function checkPlaylistHasTutorial(param1:Array) : Boolean
      {
         var _loc2_:ModeObj = null;
         this._gameModeButtonRef.visible = false;
         for each(_loc2_ in param1)
         {
            if(TutorialService.getInstance().getContentByGameType(_loc2_.id).length > 0)
            {
               this._gameModeButtonRef.visible = true;
               this._selectedGameModeTutorial = _loc2_.id;
               return true;
            }
         }
         this._gameModeButtonRef.visible = false;
         return false;
      }
      
      override protected function enableData() : void
      {
         super.enableData();
      }
      
      override protected function disableData() : void
      {
         super.disableData();
      }
      
      override protected function showView() : void
      {
         super.showView();
         if(currentFrame == 1)
         {
            gotoAndPlay(2);
         }
         if(hasEventListener(Event.ENTER_FRAME))
         {
            removeEventListener(Event.ENTER_FRAME,this.onCheckFrame);
            gotoAndPlay(2);
         }
      }
      
      override protected function hideView() : void
      {
         var _loc1_:Boolean = getDP(DataID.IS_IN_ROOM);
         if(_loc1_)
         {
            gotoAndStop(1);
            super.hideView();
         }
         else
         {
            this.playCloseAnim();
         }
      }
      
      protected function playCloseAnim() : void
      {
         gotoAndPlay("close");
         addEventListener(Event.ENTER_FRAME,this.onCheckFrame,false,0,true);
      }
      
      private function onCheckFrame(param1:Event) : void
      {
         if(param1.currentTarget.currentFrame == 1)
         {
            removeEventListener(Event.ENTER_FRAME,this.onCheckFrame);
            super.hideView();
         }
      }
      
      private function onDetect3DModelRotationHandle(param1:MouseEvent) : void
      {
         trace("yarp - matchselectbase - detect3dmodel");
         broadcast(BCEvent.CHARACTER3D_ROTATION_CHANGE,{
            "offsetX":stage.mouseX - this._detect3DRotationOrgX,
            "offsetY":stage.mouseY - this._detect3DRotationOrgY
         });
         this._detect3DRotationOrgX = stage.mouseX;
         this._detect3DRotationOrgY = stage.mouseY;
      }
      
      private function onStartDetect3DModelRotationHandle(param1:MouseEvent) : void
      {
         this._detect3DRotationOrgX = stage.mouseX;
         this._detect3DRotationOrgY = stage.mouseY;
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onDetect3DModelRotationHandle);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.onStopDetect3DModelRotationHandle);
      }
      
      private function onStopDetect3DModelRotationHandle(param1:MouseEvent) : void
      {
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onDetect3DModelRotationHandle);
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.onStopDetect3DModelRotationHandle);
      }
      
      private function isPlayerAboveTrainingLevelCap() : Boolean
      {
         var _loc1_:PlayerObj = getDP(DataID.CAREER_INFO) as PlayerObj;
         return int(_loc1_.careerData.currentLevel) >= PLAYER_LEVEL_TRAINING_CAP || _loc1_.careerData.prestige > 0;
      }
      
      public function doOpenSummaryPopup(param1:int, param2:String, param3:Object = null) : Boolean
      {
         if(this.isPlayerAboveTrainingLevelCap() || CFunctionContainer.IsOnboardCompleteShootingRange() as Boolean)
         {
            return false;
         }
         var _loc4_:Class = getDefinitionByName("fsgRecruitTrainingSummaryImage") as Class;
         var _loc5_:GameModeSummaryPopupContentObj = new GameModeSummaryPopupContentObj(DictGameModeSummaryPopup.GAMEMODE_SUMMARY_POPUP_RECRUIT_TRAINING_TITLE," ",_loc4_,UIStencils.SUMMARY_POPUP_RECRUIT_TRAINING_SUGGESTION_VIEWED,param2,TutorialMap.ONBOARD_SHOOTING_RANGE,DictGameModeSummaryPopup.GAMEMODE_SUMMARY_POPUP_PVE_TRAINING_SUGGESTION,param3);
         broadcast(BCEvent.EVT_OPEN_GAME_MODE_SUMMARY_CONFIRMATION_POPUP,_loc5_);
         return true;
      }
      
      public function getOptionObjGunship() : MatchSelectOptionObj
      {
         var _loc1_:Boolean = getDP(DataID.IS_EVACUATION_BTN_LOCKED);
         return new MatchSelectOptionObj(QuickMatchType.ID_CHOPPER_GUNNER,Dict.MAIN_MENU_LABEL_QUICKMATCH_GUNSHIP,Dict.QUICK_MATCH_GUNSHIP_INTRO,_loc1_,-1,false);
      }
      
      public function getOptionObjCyborg() : MatchSelectOptionObj
      {
         var _loc7_:Boolean = false;
         var _loc1_:Boolean = false;
         var _loc2_:int = MatchSelectOptionObj.UNLOCK_LEVEL_NONE;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = CFunctionCommonContainer.AS_IsNotificationUnlocked("un_cyborg_future") as Boolean;
         var _loc5_:int = CFunctionCommonContainer.AS_GetNotificationUnlockLevel("un_cyborg_future") as int;
         if(Boolean(getDP(DataID.IS_CYBORG_BTN_LOCKED)))
         {
            _loc1_ = true;
         }
         else
         {
            _loc7_ = getDP(DataID.IS_ONBOARD_COMPLETE);
            if(!_loc7_ || !_loc4_)
            {
               _loc1_ = true;
               _loc2_ = _loc5_;
            }
         }
         var _loc6_:Boolean = CFunctionCommonContainer.AS_IsNotified("ui_lockCyborg") as Boolean;
         if(_loc6_ == false && _loc4_ == true)
         {
            _loc3_ = true;
         }
         return new MatchSelectOptionObj(QuickMatchType.ID_FUTURE_CYBORGS,Dict.MAIN_MENU_LABEL_QUICKMATCH_ZOMBIE,Dict.QUICK_MATCH_CYBORG_INTRO,_loc1_,_loc2_,_loc3_);
      }
      
      public function getOptionObjDeathmarch() : MatchSelectOptionObj
      {
         var _loc1_:Boolean = getDP(DataID.IS_EVACUATION_BTN_LOCKED);
         return new MatchSelectOptionObj(QuickMatchType.ID_DEATHMARCH,Dict.MAIN_MENU_LABEL_QUICKMATCH_EVAC_DEATHMARCH,Dict.QUICK_MATCH_DEATHMARCH_INTRO,_loc1_);
      }
      
      public function getOptionObjSurv() : MatchSelectOptionObj
      {
         var _loc1_:Boolean = getDP(DataID.IS_SURVIVAL_BTN_LOCKED);
         return new MatchSelectOptionObj(QuickMatchType.ID_SURVIVAL,Dict.MAIN_MENU_LABEL_QUICKMATCH_SURVIVAL,Dict.QUICK_MATCH_SURVIVAL_INTRO,_loc1_,MatchSelectOptionObj.UNLOCK_LEVEL_NONE,false,true);
      }
      
      public function getOptionObjEvac() : MatchSelectOptionObj
      {
         var _loc1_:Boolean = getDP(DataID.IS_EVACUATION_BTN_LOCKED);
         return new MatchSelectOptionObj(QuickMatchType.ID_EVAC,Dict.MAIN_MENU_LABEL_QUICKMATCH_EVACUATION,Dict.QUICK_MATCH_EVACUATION_INTRO,_loc1_,MatchSelectOptionObj.UNLOCK_LEVEL_NONE,false,true);
      }
      
      public function getOptionObjAsym() : MatchSelectOptionObj
      {
         var _loc1_:Boolean = getDP(DataID.IS_EVACUATION_BTN_LOCKED);
         return new MatchSelectOptionObj(QuickMatchType.ID_EVAC,Dict.MAIN_MENU_LABEL_QUICKMATCH_EVACUATION,Dict.QUICK_MATCH_EVACUATION_INTRO,_loc1_,MatchSelectOptionObj.UNLOCK_LEVEL_NONE,false,true);
      }
      
      protected function setTitleText(param1:String) : void
      {
      }
      
      public function setSubtitleText(param1:String) : void
      {
         this.myBaseElems.myMissionTitle.myTextTF.text = LocalizeUtil.localize(param1).toUpperCase();
      }
      
      public function setGamemodeImage(param1:String) : void
      {
         this.myBaseElems.myImgSlider.myImg.setImage(param1);
      }
      
      public function setDefaultMapImage() : void
      {
         this.setGamemodeImage("SP_Multi_Gamemode_.tga");
      }
   }
}

