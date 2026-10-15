package codo.cpp
{
   import codo.localization.DictCareer;
   import codo.localization.DictMarket;
   import codo.objects.VetChallengeObj;
   import codo.utils.DataUtil;
   import codo.views.career_parts.CareerChallengesPanel;
   
   public dynamic class UiCppChallengesView extends UiCppView
   {
      
      public static var CPP_TYPE:uint;
      
      public var CPP_filter:UiCppListFilter;
      
      public var CPP_sortDirs:UiCppList;
      
      public var CPP_completeFilter:UiCppList;
      
      private var _view:CareerChallengesPanel;
      
      public function UiCppChallengesView(view:CareerChallengesPanel, filter:UiCppListFilter, sortDirs:UiCppList, completeFilter:UiCppList)
      {
         this._view = view;
         this.CPP_filter = filter;
         this.CPP_sortDirs = sortDirs;
         this.CPP_completeFilter = completeFilter;
         super();
      }
      
      public function CPP_GetFilterData() : Array
      {
         return [{
            "label":"@SF_UI_CAREER_PVP",
            "child":[{
               "allItems":true,
               "label":DictMarket.CATEGORY_ALL
            },{
               "id":"bootcamp",
               "label":"@CHALLENGE_BOOT_CAMP_CAPS"
            },{
               "id":"operation",
               "label":"@CHALLENGE_OPERATIONS_CAPS"
            },{
               "id":"elite",
               "label":"@CHALLENGE_ELITE_CAPS"
            },{
               "id":"dominance",
               "label":"@CHALLENGE_DOMINANCE_CAPS"
            },{
               "id":"robot",
               "label":"@SF_UI_ITEM_GAMEMODE_ASYM_ROBOTS"
            }]
         },{
            "label":"@SF_UI_CAREER_PVE",
            "child":[{
               "allItems":true,
               "label":DictMarket.CATEGORY_ALL
            },{
               "id":"zombies",
               "label":"@CHALLENGE_ZOMBIES_CAPS"
            },{
               "id":"zm_unique",
               "label":"@CHALLENGE_CYBORGS_CAPS"
            },{
               "id":"coop",
               "label":"@CHALLENGE_COOP_CAPS"
            }]
         },{
            "label":"@CHALLENGE_KILLS_CAPS",
            "child":[{
               "allItems":true,
               "label":DictMarket.CATEGORY_ALL
            },{
               "id":"finalkill",
               "label":"@CHALLENGE_FINALKILL_CAPS"
            },{
               "id":"humiliation",
               "label":"@CHALLENGE_HUMILIATION_CAPS"
            },{
               "id":"payback",
               "label":"@CHALLENGE_PAYBACK_CAPS"
            },{
               "id":"precision",
               "label":"@CHALLENGE_PRECISION_CAPS"
            }]
         },{
            "label":"@CHALLENGE_MASTERY_CAPS",
            "child":[{
               "allItems":true,
               "label":DictMarket.CATEGORY_ALL
            },{
               "id":"killstreak",
               "label":"@CHALLENGE_KILLSTREAK_CAPS"
            },{
               "id":"perk",
               "label":"@CHALLENGE_PERKS_CAPS"
            },{
               "id":"uniqueweapon",
               "label":"@CHALLENGE_UNIQUE_CAPS"
            }]
         },{
            "id":"prestige",
            "label":DictCareer.CAREER_PRESTIGE
         },{
            "label":"@CHALLENGE_WEAPON_CAPS",
            "child":[{
               "allItems":true,
               "label":DictMarket.CATEGORY_ALL
            },{
               "id":"weapon",
               "label":"@CHALLENGE_WEAPON_KILLS_CAPS"
            },{
               "id":"weapon_collection",
               "label":"@CHALLENGE_WEAPON_COLLECTION_CAPS"
            }]
         }];
      }
      
      public function CPP_SetChallenges(challenges:Array) : void
      {
         var vec:Vector.<VetChallengeObj> = DataUtil.copyElems(new Vector.<VetChallengeObj>(0),challenges);
         this._view.setChallenges(vec);
      }
      
      public function CPP_OnCategorySelect(category:Object, levelsCompleted:uint, levelsTotal:uint) : void
      {
         this._view.onCategorySelect(category.label,levelsCompleted,levelsTotal);
      }
      
      override public function GetUiCppType() : uint
      {
         return CPP_TYPE;
      }
   }
}

