package codo.cpp
{
   public interface IUiCppListReadOnly
   {
      
      function uiCppGetListData() : Array;
      
      function uiCppGetSelectedIndex() : int;
      
      function uiCppInitClickEvent(param1:UiCpp, param2:String) : void;
   }
}

