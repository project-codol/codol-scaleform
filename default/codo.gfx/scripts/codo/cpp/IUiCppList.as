package codo.cpp
{
   public interface IUiCppList
   {
      
      function uiCppGetListData() : Array;
      
      function uiCppGetSelectedIndex() : int;
      
      function uiCppInitClickEvent(param1:UiCpp, param2:String) : void;
   }
}

