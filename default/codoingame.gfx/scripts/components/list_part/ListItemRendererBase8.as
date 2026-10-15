package components.list_part
{
   import codo.event.ParaEvent;
   import codo.interfaces.IList;
   import components.BaseButton;
   import components.interfaces.IListItemRendererBase;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class ListItemRendererBase8 extends BaseButton implements IListItemRendererBase
   {
      
      protected var _container:IList;
      
      public var myLabelTF:TextField;
      
      private var _dataIndex:int = -1;
      
      protected var _data:Object = {};
      
      protected var _selected:Boolean;
      
      private var _styleID:uint = 0;
      
      public function ListItemRendererBase8()
      {
         super();
      }
      
      override protected function onInit() : void
      {
         mouseChildren = mouseEnabled = true;
         if(this.myLabelTF != null)
         {
            this.myLabelTF.mouseEnabled = false;
         }
         setToNormal();
      }
      
      public function set container(cList:IList) : void
      {
         this._container = cList;
      }
      
      public function set dataIndex(cIndex:int) : void
      {
         var tempNewDat:Object = null;
         this._dataIndex = cIndex;
         if(this._container != null)
         {
            tempNewDat = this._container.getDataByIndex(this._dataIndex);
            this.setData(tempNewDat);
            this.selected = this._container.selectedDataIndex == this.dataIndex;
         }
      }
      
      public function get dataIndex() : int
      {
         return this._dataIndex;
      }
      
      public function set index(cIndex:int) : void
      {
         this.dataIndex = cIndex;
      }
      
      public function get index() : int
      {
         return this._dataIndex;
      }
      
      public function setData(cDat:Object) : void
      {
         this._data = cDat;
         if(this._data != null)
         {
            enable = true;
            this.onGetData();
         }
         else
         {
            enable = false;
            this.onNoData();
         }
      }
      
      public function getData() : Object
      {
         return this._data;
      }
      
      public function set selected(cSwi:Boolean) : void
      {
         if(this._selected != cSwi)
         {
            this._selected = cSwi;
            if(this._selected == true)
            {
               this.onSelected();
            }
            else
            {
               this.onUnselected();
            }
         }
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set style(cStyleID:uint) : void
      {
         this._styleID = cStyleID;
         this.onStyleChanged();
      }
      
      public function get style() : uint
      {
         return this._styleID;
      }
      
      protected function onStyleChanged() : void
      {
      }
      
      protected function onSelected() : void
      {
         setToRollOver();
      }
      
      protected function onUnselected() : void
      {
         setToNormal();
      }
      
      protected function onGetData() : void
      {
         if(this.myLabelTF != null)
         {
            this.myLabelTF.text = this._data.label || this._data.name || "";
         }
         visible = true;
      }
      
      protected function onNoData() : void
      {
         visible = false;
      }
      
      final override protected function onButtonMouseOutHandler(cEvt:MouseEvent) : void
      {
         if(!this._selected)
         {
            _isFocusIn = false;
            setToNormal();
            dispatchEvent(new ParaEvent(EVT_MOUSE_OUT));
         }
      }
   }
}

