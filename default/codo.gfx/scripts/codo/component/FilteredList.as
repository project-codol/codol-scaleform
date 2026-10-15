package codo.component
{
   import codo.component.object.NavigationObj;
   import codo.cpp.IUiCppList;
   import codo.cpp.IUiCppListFilter;
   import codo.cpp.IUiCppListMutable;
   import codo.cpp.UiCpp;
   import codo.cpp.UiCppListFilter;
   import codo.utils.DataUtil;
   
   public class FilteredList extends UiCppListFilter implements IUiCppListFilter, IUiCppListMutable
   {
      
      private var _list:IUiCppListMutable;
      
      private var _filterOps:IUiCppListMutable;
      
      private var _uiCppData:Array;
      
      public function FilteredList(list:IUiCppListMutable, filterOps:IUiCppListMutable)
      {
         super(this);
         this._list = list;
         this._filterOps = filterOps;
      }
      
      public function setFilterIdx(idx:int) : void
      {
         this._filterOps.uiCppSelectIndex(idx);
      }
      
      public function setFilters(filters:Vector.<NavigationObj>) : void
      {
         var filtersArray:Array = DataUtil.VectorToArray(filters);
         this._filterOps.uiCppSetListData(filtersArray);
      }
      
      public function set itemData(itemData:Array) : void
      {
         this._list.uiCppSetListData(itemData);
      }
      
      public function uiCppGetListData() : Array
      {
         return this._uiCppData;
      }
      
      public function uiCppGetSelectedIndex() : int
      {
         return 0;
      }
      
      public function uiCppInitClickEvent(uiCpp:UiCpp, func:String) : void
      {
      }
      
      public function uiCppSetListData(data:Array) : void
      {
         this._uiCppData = data;
      }
      
      public function uiCppSelectIndex(index:int) : void
      {
      }
      
      public function uiCppSetSelectableFilters(selectableFilters:Array) : void
      {
         var filterData:NavigationObj = null;
         var filters:Vector.<NavigationObj> = new Vector.<NavigationObj>(0);
         var children:Array = this._uiCppData[this.uiCppGetSelectedIndex()].child;
         for(var i:int = 0; i < selectableFilters.length; i++)
         {
            if(Boolean(selectableFilters[i]))
            {
               filterData = new NavigationObj(filters.length,children[i].label);
               filterData.dataIdx = i;
               filters.push(filterData);
            }
         }
         this.setFilters(filters);
      }
      
      public function uiCppGetFilterStates() : Array
      {
         var selected:NavigationObj = null;
         var children:Array = this._uiCppData[this.uiCppGetSelectedIndex()].child;
         var states:Array = [];
         for(var i:int = 0; i < children.length; i++)
         {
            states[i] = false;
         }
         var filterList:IUiCppList = this._filterOps as IUiCppList;
         var filtersData:Array = filterList.uiCppGetListData();
         var selectedFilter:int = filterList.uiCppGetSelectedIndex();
         if(selectedFilter >= 0 && selectedFilter < filtersData.length)
         {
            selected = filtersData[selectedFilter];
            states[selected.dataIdx] = true;
         }
         return states;
      }
      
      public function uiCppSetFilterStates(states:Array) : void
      {
      }
      
      public function uiCppInitFilterChangeEvent(uiCpp:UiCpp, func:String) : void
      {
         (this._filterOps as IUiCppList).uiCppInitClickEvent(uiCpp,func);
      }
   }
}

