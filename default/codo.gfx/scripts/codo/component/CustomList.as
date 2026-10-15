package codo.component
{
   import codo.component.core.UIInteractiveComponent;
   import codo.cpp.IUiCppList;
   import codo.cpp.IUiCppListMutable;
   import codo.cpp.UiCpp;
   import codo.interfaces.ISelectable;
   import fsg.shared.CallbackList;
   
   public class CustomList implements IUiCppList, IUiCppListMutable
   {
      
      private var _listData:Array;
      
      private var _selectedIndex:uint;
      
      private var _clickCallbacks:CallbackList;
      
      private var _itemsFunc:Function;
      
      private var _items:Vector.<UIInteractiveComponent> = new Vector.<UIInteractiveComponent>(0);
      
      public function CustomList(itemsFactory:Function)
      {
         super();
         this._clickCallbacks = new CallbackList();
         this._itemsFunc = itemsFactory;
      }
      
      public function setListData(data:Array) : void
      {
         var item:UIInteractiveComponent = null;
         this._listData = data;
         this._selectedIndex = uint.MAX_VALUE;
         this._items = this._itemsFunc(this._listData.length);
         if(this._items == null)
         {
            this._items = new Vector.<UIInteractiveComponent>(0);
         }
         for(var i:int = 0; i < this._items.length; i++)
         {
            item = this._items[i];
            item.setData(this._listData[i]);
            item.setClickCallback(this.onItemClick,i);
         }
      }
      
      public function selectIndex(index:uint) : void
      {
         if(index == this._selectedIndex)
         {
            return;
         }
         var prev:ISelectable = this.getSelectedItem() as ISelectable;
         if(prev != null)
         {
            prev.selected = false;
         }
         this._selectedIndex = index;
         var item:ISelectable = this.getSelectedItem() as ISelectable;
         if(item != null)
         {
            item.selected = true;
         }
      }
      
      public function getSelectedIndex() : uint
      {
         return this._selectedIndex;
      }
      
      public function addClickCallback(func:Function) : void
      {
         this._clickCallbacks.addCallback(func);
      }
      
      public function getSelectedItem() : UIInteractiveComponent
      {
         if(this._selectedIndex < this._items.length)
         {
            return this._items[this._selectedIndex];
         }
         return null;
      }
      
      public function getSelectedData() : *
      {
         if(this._selectedIndex < this._listData.length)
         {
            return this._listData[this._selectedIndex];
         }
         return null;
      }
      
      private function onItemClick(index:int) : void
      {
         if(index == this._selectedIndex)
         {
            return;
         }
         this.selectIndex(index);
         this._clickCallbacks.call();
      }
      
      public function uiCppGetListData() : Array
      {
         return this._listData;
      }
      
      public function uiCppGetSelectedIndex() : int
      {
         return this.getSelectedIndex();
      }
      
      public function uiCppInitClickEvent(uiCpp:UiCpp, func:String) : void
      {
         this.addClickCallback(function():void
         {
            uiCpp[func]();
         });
      }
      
      public function uiCppSetListData(data:Array) : void
      {
         this.setListData(data);
      }
      
      public function uiCppSelectIndex(index:int) : void
      {
         this.selectIndex(index);
      }
   }
}

