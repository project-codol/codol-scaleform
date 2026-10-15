package codo.cpp
{
   public dynamic class UiCppListFilter extends UiCppList
   {
      
      public static var CPP_TYPE:uint;
      
      protected var _filter:IUiCppListFilter;
      
      public function UiCppListFilter(filter:IUiCppListFilter)
      {
         this._filter = filter;
         super(filter);
      }
      
      override public function GetUiCppType() : uint
      {
         return CPP_TYPE;
      }
      
      public function CPP_SetSelectableFilters(selectableFilters:Array) : void
      {
         this._filter.uiCppSetSelectableFilters(selectableFilters);
      }
      
      public function CPP_GetFilterStates() : Array
      {
         return this._filter.uiCppGetFilterStates();
      }
      
      public function CPP_SetFilterStates(states:Array) : void
      {
         this._filter.uiCppSetFilterStates(states);
      }
      
      public function CPP_InitFilterChangeEvent(uiCpp:UiCpp, func:String) : void
      {
         this._filter.uiCppInitFilterChangeEvent(uiCpp,func);
      }
   }
}

