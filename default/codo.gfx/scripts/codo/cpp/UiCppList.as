package codo.cpp
{
   public dynamic class UiCppList extends UiCpp
   {
      
      public static var CPP_TYPE:uint;
      
      private var _list:IUiCppList;
      
      private var _mutable:IUiCppListMutable;
      
      private var _focusable:IUiCppListFocusable;
      
      public function UiCppList(list:IUiCppList)
      {
         this._list = list;
         this._mutable = list as IUiCppListMutable;
         this._focusable = list as IUiCppListFocusable;
         super();
      }
      
      public function GetList() : IUiCppList
      {
         return this._list;
      }
      
      override public function GetUiCppType() : uint
      {
         return CPP_TYPE;
      }
      
      public function CPP_GetListData() : Array
      {
         return this._list.uiCppGetListData();
      }
      
      public function CPP_GetSelectedIndex() : int
      {
         return this._list.uiCppGetSelectedIndex();
      }
      
      public function CPP_InitClickEvent(uiCpp:UiCpp, func:String) : void
      {
         this._list.uiCppInitClickEvent(uiCpp,func);
      }
      
      public function CPP_SetListData(data:Array) : void
      {
         this._mutable.uiCppSetListData(data);
      }
      
      public function CPP_SelectIndex(index:int) : void
      {
         this._mutable.uiCppSelectIndex(index);
      }
      
      public function CPP_InitFocusEvent(uiCpp:UiCpp, func:String) : void
      {
         this._focusable.uiCppInitFocusEvent(uiCpp,func);
      }
   }
}

