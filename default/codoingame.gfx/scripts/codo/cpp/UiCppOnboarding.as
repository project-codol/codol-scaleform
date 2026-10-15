package codo.cpp
{
   import codo.base.BaseView;
   import codo.common.CFunctionCommonContainer;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.constants.PageID;
   import codo.constants.SystemMsgPriority;
   import codo.constants.UITutorialFlags;
   import codo.manager.DataManager;
   import codo.manager.EventManager;
   
   public dynamic class UiCppOnboarding extends UiCpp
   {
      
      private static var _instance:UiCppOnboarding;
      
      public static var CPP_TYPE:uint;
      
      public static const TYPE_PRE_MR5:uint = 0;
      
      public static const TYPE_MR5_NOVICE:uint = 1;
      
      public static const TYPE_MR5_EXPERT:uint = 2;
      
      public static const FEATURE_LOADOUT_2:String = "31861";
      
      public static const FEATURE_LOADOUT_3:String = "31862";
      
      public static const FEATURE_INVENTORY_MARKET:String = "31863";
      
      public static const FEATURE_GEAR:String = "31864";
      
      public static const FEATURE_THEATER:String = "31866";
      
      public static const FEATURE_PERKS:String = "31868";
      
      public static const FEATURE_STREAKS:String = "31869";
      
      public static const FEATURE_REQUISITIONS:String = "31870";
      
      public static const FEATURE_SUPPLY_DROPS:String = "31871";
      
      public static const FEATURE_MELEE:String = "31872";
      
      public static const FEATURE_CLANS:String = "31873";
      
      public static const FEATURE_PLAYERCARD:String = "31877";
      
      public static const FEATURE_PLAYERCARD_BKG:String = "31878";
      
      public static const FEATURE_WILDCARDS:String = "31879";
      
      public static const FEATURE_LEADERBOARDS:String = "31886";
      
      public static const FEATURE_WARGOD:String = "31887";
      
      public static const FEATURE_ROOMS:String = "31888";
      
      public function UiCppOnboarding()
      {
         super();
         CFunctionCommonContainer.Assert(_instance == null,new Error("Multiple UiCppOnboarding instances"));
         _instance = this;
      }
      
      public static function get instance() : UiCppOnboarding
      {
         return _instance;
      }
      
      public function StartUI() : void
      {
         this["AS_StartUI"]();
      }
      
      public function FinishCharacterStep(charID:int) : void
      {
         this["AS_FinishCharacterStep"](charID);
      }
      
      public function FinishExperienceStep(isExpert:Boolean) : void
      {
         this["AS_FinishExperienceStep"](isExpert);
      }
      
      public function FinishControlsStep() : void
      {
         this["AS_FinishControlsStep"]();
      }
      
      public function FinishTutorialIntroStep(skipMatch:Boolean) : void
      {
         this["AS_FinishTutorialIntroStep"](skipMatch);
      }
      
      public function GetJustPlayedMission() : Boolean
      {
         return this["AS_GetJustPlayedMission"]();
      }
      
      public function CPP_StartFirstLoginStep() : void
      {
         this.OpenPage(PageID.ONBOARDING_WELCOME_NEW_PLAYER);
      }
      
      public function CPP_StartCharacterStep() : void
      {
         this.OpenPage(PageID.CHARACTER_SELECT);
      }
      
      public function CPP_StartExperienceStep() : void
      {
         this.OpenPage(PageID.ONBOARDING_EXPERIENCE_SELECT);
      }
      
      public function CPP_StartTutorialMapStep() : void
      {
         this.OpenPage(PageID.ONBOARDING_PLAYER_TRAINING_INTRO);
      }
      
      public function CPP_StartControlsStep() : void
      {
         this.OpenPage(PageID.ONBOARDING_KEYBOARD_SELECT);
      }
      
      public function CPP_TryLaunchTutorialMap() : void
      {
         var params:Object = {
            "map":"mp_nuked",
            "mode":"train",
            "difficulty":1,
            "trainingType":1
         };
         DataManager.getInstance().request(DataID.JUMP_GAME,params);
      }
      
      public function CPP_OnProfileReset() : void
      {
         BaseView.staticShowMsg("@SF_UI_PROFILE_RECOVER",1,SystemMsgPriority.WARNING);
      }
      
      public function CPP_OnIntroDone() : void
      {
         if(this.GetJustPlayedMission())
         {
            UITutorialFlags.setNextOnboardingStep(UITutorialFlags.UI_TOUR_AAR_NEW_USER_GP_VIEWED);
         }
         EventManager.getInstance().broadcast(BCEvent.EVT_ONBOARD_INIT_UI);
      }
      
      protected function OpenPage(id:String) : void
      {
         EventManager.getInstance().broadcast(BCEvent.EVT_ROUTE_TO_PAGE,{"page":id});
      }
      
      override public function GetUiCppType() : uint
      {
         return CPP_TYPE;
      }
   }
}

