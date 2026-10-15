package codo.cpp
{
   public interface IUiCppListFilter extends IUiCppList
   {
      
      function uiCppSetSelectableFilters(param1:Array) : void;
      
      function uiCppGetFilterStates() : Array;
      
      function uiCppSetFilterStates(param1:Array) : void;
      
      function uiCppInitFilterChangeEvent(param1:UiCpp, param2:String) : void;
   }
}

