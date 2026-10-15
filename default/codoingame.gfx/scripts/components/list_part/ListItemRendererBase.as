package components.list_part
{
   import components.BaseButton;
   import components.interfaces.IListItemRendererBase;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class ListItemRendererBase extends BaseButton implements IListItemRendererBase
   {
      
      public static const EVT_SIZE_CHANGED:String = "evt_size_changed";
      
      public static const EVT_EXPAND:String = "evt_expand";
      
      public var myLabelTF:TextField;
      
      protected var _dataIndex:int = 0;
      
      protected var _positionIndex:int = 0;
      
      protected var _columnIndex:int = 0;
      
      protected var _fold:Boolean = true;
      
      protected var _selected:Boolean = false;
      
      protected var _data:Object;
      
      protected var _anotherAxisPositionIndex:int;
      
      protected var _styleID:uint = 0;
      
      public function ListItemRendererBase()
      {
         super();
      }
      
      public function get index() : int
      {
         return this._dataIndex;
      }
      
      public function set index(cIndex:int) : void
      {
         this._dataIndex = cIndex;
      }
      
      public function get positionIndex() : int
      {
         return this._positionIndex;
      }
      
      public function set positionIndex(cPos:int) : void
      {
         this._positionIndex = cPos;
      }
      
      public function get columnIndex() : int
      {
         return this._columnIndex;
      }
      
      public function set columnIndex(cPos:int) : void
      {
         this._columnIndex = cPos;
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
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
      
      public function get style() : uint
      {
         return this._styleID;
      }
      
      public function set style(cStyleID:uint) : void
      {
         this._styleID = cStyleID;
         this.onStyleChanged();
      }
      
      public function get anotherAxisPositionIndex() : int
      {
         return this._anotherAxisPositionIndex;
      }
      
      public function set anotherAxisPositionIndex(cPos:int) : void
      {
         this._anotherAxisPositionIndex = cPos;
      }
      
      public function get size() : Number
      {
         return height;
      }
      
      public function get fold() : Boolean
      {
         return this._fold;
      }
      
      public function set fold(cSwi:Boolean) : void
      {
         if(this._fold != cSwi)
         {
            this._fold = cSwi;
            if(this._fold == true)
            {
               this.onFold();
            }
            else
            {
               this.onUnfold();
            }
         }
      }
      
      override protected function onInit() : void
      {
         super.onInit();
         if(this.myLabelTF != null)
         {
            this.myLabelTF.mouseEnabled = false;
         }
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
      
      protected function onFold() : void
      {
      }
      
      protected function onUnfold() : void
      {
      }
      
      protected function onStyleChanged() : void
      {
      }
      
      override protected function onButtonMouseOutHandler(cEvt:MouseEvent) : void
      {
         if(!this._selected)
         {
            _isFocusIn = false;
            setToNormal();
            dispatchEvent(new Event(EVT_MOUSE_OUT));
         }
      }
   }
}

