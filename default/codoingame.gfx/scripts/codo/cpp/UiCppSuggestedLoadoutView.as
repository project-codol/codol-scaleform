package codo.cpp
{
   import codo.common.CFunctionContainer;
   import codo.objects.SuggestedLoadoutTypeObj;
   import codo.objects.WeaponLoadoutObj;
   import codo.utils.LocalizeUtil;
   import codo.views.FsgRecommendedLoadoutPopupView;
   
   public dynamic class UiCppSuggestedLoadoutView extends UiCppView
   {
      
      private static var _styles:Vector.<SuggestedLoadoutTypeObj>;
      
      public static var CPP_TYPE:uint;
      
      public static const STYLE_RUNNER:uint = 0;
      
      public static const STYLE_CONTROLLER:uint = 1;
      
      public static const STYLE_SNIPER:uint = 2;
      
      public static const STYLE_HOT:uint = 3;
      
      public static const NUM_VARIANTS:uint = 2;
      
      public var CPP_filter:UiCppListFilter;
      
      private var _view:FsgRecommendedLoadoutPopupView;
      
      public function UiCppSuggestedLoadoutView(view:FsgRecommendedLoadoutPopupView)
      {
         this._view = view;
         this.CPP_filter = new UiCppListFilter(this._view.myRecommendedLoadoutPanel.myLoadoutsFilter);
         super();
      }
      
      public static function getStyles() : Vector.<SuggestedLoadoutTypeObj>
      {
         if(_styles == null)
         {
            _styles = new Vector.<SuggestedLoadoutTypeObj>(0);
            _styles.push(new SuggestedLoadoutTypeObj(STYLE_RUNNER,"@SF_UI_SUGGESTED_LOADOUT_1","@SF_UI_SUGGESTED_LOADOUT_1_DESC"));
            _styles.push(new SuggestedLoadoutTypeObj(STYLE_CONTROLLER,"@SF_UI_SUGGESTED_LOADOUT_2","@SF_UI_SUGGESTED_LOADOUT_2_DESC"));
            _styles.push(new SuggestedLoadoutTypeObj(STYLE_SNIPER,"@SF_UI_SUGGESTED_LOADOUT_3","@SF_UI_SUGGESTED_LOADOUT_3_DESC"));
            if(Boolean(CFunctionContainer.AS_HasHotRecommendedLoadout()))
            {
               _styles.push(new SuggestedLoadoutTypeObj(STYLE_HOT,"@SF_UI_SUGGESTED_LOADOUT_4","@SF_UI_SUGGESTED_LOADOUT_4_DESC"));
            }
         }
         return _styles;
      }
      
      public function CPP_InitList(numRanks:uint) : void
      {
         var children:Array = null;
         var j:int = 0;
         var level:int = 0;
         var categ:Object = null;
         var child:Object = null;
         var listData:Array = [];
         for(var i:int = 0; i < numRanks; i++)
         {
            children = [];
            for(j = 0; j < NUM_VARIANTS; j++)
            {
               child = {
                  "id":j,
                  "label":LocalizeUtil.replaceConversionString(LocalizeUtil.localize("@SF_UI_SUGGESTED_LOADOUT_VARIANT"),[j + 1])
               };
               children.push(child);
            }
            level = Math.max(1,i * 10);
            categ = {
               "id":i,
               "label":LocalizeUtil.replaceConversionString(LocalizeUtil.localize("@SF_UI_CAREER_X_LEVEL"),[level]),
               "child":children
            };
            listData.push(categ);
         }
         this._view.myRecommendedLoadoutPanel.initList(listData);
      }
      
      public function CPP_InitHotList(loadouts:Array) : void
      {
         var child:Object = null;
         var listData:Array = [];
         var children:Array = [];
         for(var i:int = 0; i < loadouts.length; i++)
         {
            child = {
               "id":i,
               "label":LocalizeUtil.localize(loadouts[i])
            };
            children.push(child);
         }
         var categ:Object = {
            "id":0,
            "label":LocalizeUtil.localize("@UI_MARKET_ITEM_MENU_ALL"),
            "child":children
         };
         listData.push(categ);
         this._view.myRecommendedLoadoutPanel.initList(listData);
      }
      
      public function CPP_SetLoadoutData(data:WeaponLoadoutObj, items:Array, isSkuID:Boolean) : void
      {
         this._view.myRecommendedLoadoutPanel.myLoadout.updateLoadout(data);
         this._view.myRecommendedLoadoutPanel.updateSelectionTitle(items,isSkuID);
      }
      
      public function CPP_GetStyle() : uint
      {
         return this._view.myRecommendedLoadoutPanel.getLoadoutType().id;
      }
      
      override public function GetUiCppType() : uint
      {
         return CPP_TYPE;
      }
   }
}

