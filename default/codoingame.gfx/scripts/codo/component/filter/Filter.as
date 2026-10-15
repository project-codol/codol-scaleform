package codo.component.filter
{
   import codo.cpp.IUiCppListFilter;
   import codo.cpp.IUiCppListMutable;
   import codo.cpp.UiCpp;
   import codo.cpp.UiCppListFilter;
   import codo.utils.ScaleformUtil;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.utils.getDefinitionByName;
   
   public class Filter extends MovieClip implements IUiCppListFilter, IUiCppListMutable
   {
      
      private static const SLIDE_DURATION:Number = 0.15;
      
      private static const LIST_PADDING:Number = 1;
      
      public var myCategoryMount:Sprite;
      
      private var mOnCategoryClickCallback:Function;
      
      private var mOnSubCategoryChecked:Function;
      
      private var mOnSubCategoryUnchecked:Function;
      
      private var mSingleOptionMode:Boolean = false;
      
      protected var mCategoryClips:Vector.<FilterCategoryButton>;
      
      protected var _uiCpp:UiCppListFilter;
      
      protected var _listData:Array;
      
      protected var _selectedIndex:int;
      
      public function Filter()
      {
         super();
         this._selectedIndex = 0;
         this._uiCpp = new UiCppListFilter(this);
      }
      
      public function setData(data:Array, defaultSelectedIndex:int = 0) : void
      {
         var categoryButton:FilterCategoryButton = null;
         var categoryData:Object = null;
         var i:int = 0;
         this.clearCategories();
         this._listData = data;
         this._selectedIndex = defaultSelectedIndex;
         var filterButton:Class = getDefinitionByName(this.filterCategoryButtonClassPath) as Class;
         for(i = 0; i < data.length; i++)
         {
            categoryData = data[i];
            categoryButton = new filterButton() as FilterCategoryButton;
            categoryButton.index = i;
            categoryButton.registerClickEvent(this.onCategoryClicked,categoryButton);
            categoryButton.addOnSubCategoryCheckedCallback(this.onSubCategoryChecked);
            categoryButton.addOnSubCategoryUncheckedCallback(this.onSubCategoryUnchecked);
            categoryButton.singleOptionMode = this.mSingleOptionMode;
            categoryButton.setToggled(i == this._selectedIndex);
            categoryButton.breadcrumbEnabled = ScaleformUtil.inFrontendLoadout || ScaleformUtil.inLobbyLoadout;
            categoryButton.setData(categoryData);
            this.myCategoryMount.addChild(categoryButton);
            this.mCategoryClips.push(categoryButton);
         }
         this.refreshLayout(true);
      }
      
      protected function get filterCategoryButtonClassPath() : String
      {
         return "codo.shared.filterCategoryButton";
      }
      
      public function getListData() : Array
      {
         return this._listData;
      }
      
      public function addOnCategoryClickCallback(func:Function) : void
      {
         this.mOnCategoryClickCallback = func;
      }
      
      public function set singleOptionMode(b:Boolean) : void
      {
         this.mSingleOptionMode = b;
      }
      
      public function get currentCategory() : FilterCategoryButton
      {
         return this.mCategoryClips[this._selectedIndex];
      }
      
      public function get categories() : Array
      {
         var data:Object = null;
         var len:int = int(this.mCategoryClips.length);
         var checkedCats:Array = new Array();
         for(var i:int = 0; i < len; i++)
         {
            data = new Object();
            data.categoryClip = this.mCategoryClips[i];
            checkedCats.push(data);
         }
         return checkedCats;
      }
      
      public function getCategoryByIndex(index:int) : FilterCategoryButton
      {
         return this.mCategoryClips[index];
      }
      
      public function addOnSubCategoryCheckedCallback(cb:Function) : void
      {
         this.mOnSubCategoryChecked = cb;
      }
      
      public function addOnSubCategoryUncheckedCallback(cb:Function) : void
      {
         this.mOnSubCategoryUnchecked = cb;
      }
      
      public function clearOnSubCategoryUncheckedCallback() : void
      {
         this.mOnSubCategoryUnchecked = null;
      }
      
      private function onSubCategoryChecked() : void
      {
         if(null != this.mOnSubCategoryChecked)
         {
            this.mOnSubCategoryChecked();
         }
      }
      
      private function onSubCategoryUnchecked() : void
      {
         if(null != this.mOnSubCategoryUnchecked)
         {
            this.mOnSubCategoryUnchecked();
         }
      }
      
      private function clearCategories() : void
      {
         this.mCategoryClips = new Vector.<FilterCategoryButton>();
         while(this.myCategoryMount.numChildren > 0)
         {
            this.myCategoryMount.removeChildAt(0);
         }
      }
      
      private function onCategoryClicked(button:FilterCategoryButton) : void
      {
         if(button.index == this._selectedIndex)
         {
            return;
         }
         this._selectedIndex = button.index;
         button.setToggled(!button.toggled);
         if(null != this.mOnCategoryClickCallback)
         {
            this.mOnCategoryClickCallback();
         }
         this.refreshLayout();
      }
      
      public function selectCategory(idx:int) : void
      {
         if(this.myCategoryMount.numChildren <= idx)
         {
            return;
         }
         var btn:FilterCategoryButton = this.myCategoryMount.getChildAt(idx) as FilterCategoryButton;
         this.onCategoryClicked(btn);
      }
      
      public function getSelectedIndex() : int
      {
         return this._selectedIndex;
      }
      
      private function refreshLayout(instant:Boolean = false) : void
      {
         var catButton:FilterCategoryButton = null;
         var curY:Number = 0;
         var padding:Number = 0;
         var len:int = int(this.mCategoryClips.length);
         for(var i:int = 0; i < len; i++)
         {
            catButton = this.mCategoryClips[i];
            if(i != this._selectedIndex)
            {
               catButton.setToggled(false);
            }
            TweenLite.killTweensOf(catButton);
            TweenLite.to(catButton,instant ? 0 : SLIDE_DURATION,{"y":curY});
            if(i == len - 1)
            {
               padding = 0;
            }
            else
            {
               padding = LIST_PADDING;
            }
            curY += catButton.height + padding;
         }
      }
      
      public function getUiCpp() : UiCppListFilter
      {
         return this._uiCpp;
      }
      
      public function uiCppGetListData() : Array
      {
         return this.getListData();
      }
      
      public function uiCppGetSelectedIndex() : int
      {
         return this.getSelectedIndex();
      }
      
      public function uiCppInitClickEvent(uiCpp:UiCpp, func:String) : void
      {
         this.addOnCategoryClickCallback(function():void
         {
            uiCpp[func]();
         });
      }
      
      public function uiCppSetListData(data:Array) : void
      {
         this.setData(data);
      }
      
      public function uiCppSelectIndex(index:int) : void
      {
         this.selectCategory(index);
      }
      
      public function uiCppSetSelectableFilters(selectableFilters:Array) : void
      {
         this.currentCategory.setSelectableFilters(selectableFilters);
      }
      
      public function uiCppGetFilterStates() : Array
      {
         return this.currentCategory.subcategoryStates;
      }
      
      public function uiCppSetFilterStates(states:Array) : void
      {
         this.currentCategory.subcategoryStates = states;
      }
      
      public function uiCppInitFilterChangeEvent(uiCpp:UiCpp, func:String) : void
      {
         this.addOnSubCategoryCheckedCallback(function():void
         {
            uiCpp[func]();
         });
      }
   }
}

