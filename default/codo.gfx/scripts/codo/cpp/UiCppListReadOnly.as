package codo.cpp
{
   public dynamic class UiCppListReadOnly extends UiCpp
   {
      
      public static var CPP_TYPE:uint;
      
      protected var _readOnlyList:IUiCppListReadOnly;
      
      public function UiCppListReadOnly(list:IUiCppListReadOnly)
      {
         super();
         this._readOnlyList = list;
      }
      
      override public function GetUiCppType() : uint
      {
         return CPP_TYPE;
      }
      
      public function CPP_GetListData() : Array
      {
         return this._readOnlyList.uiCppGetListData();
      }
      
      public function CPP_GetSelectedIndex() : int
      {
         return this._readOnlyList.uiCppGetSelectedIndex();
      }
      
      public function CPP_InitClickEvent(uiCpp:UiCpp, func:String) : void
      {
         this._readOnlyList.uiCppInitClickEvent(uiCpp,func);
      }
   }
}

