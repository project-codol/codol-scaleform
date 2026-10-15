package components
{
   import codo.event.ListEvent;
   import codo.localization.Dict;
   import codo.models.DataProvider;
   import codo.utils.DataUtil;
   import components.interfaces.IListItemRendererBase;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   import shaui.component.core.InteractiveComponent;
   
   public class CodoList extends InteractiveComponent
   {
      
      public static const EVT_LINE_CLICK:String = "evt_line_click";
      
      public static const EVT_LINE_RIGHT_CLICK:String = "evt_line_right_click";
      
      public static const EVT_LINE_DOUBLE_CLICK:String = "evt_line_double_click";
      
      public static const EVT_LINE_ROLLOVER:String = "evt_line_rollover";
      
      public static const EVT_LINE_ROLLOUT:String = "evt_line_rollout";
      
      public static const EVT_WHEEL:String = "evt_wheel";
      
      public var myHitarea:Sprite;
      
      public var myScrollBar:ScrollBar;
      
      public var myItemRenderer:IListItemRendererBase;
      
      public var myBg:Sprite;
      
      public var myNoDataLabel:Sprite;
      
      [Inspectable(type="Number",defaultValue="5")]
      public var row:uint = 5;
      
      protected var _dataProvider:DataProvider = new DataProvider();
      
      protected var _currentSelectedIndex:int = -1;
      
      protected var _currentFocusIndex:int = -1;
      
      protected var _currentSelectedItemRenderer:IListItemRendererBase;
      
      protected var _currentFocusItemRenderer:IListItemRendererBase;
      
      protected var _doubleClickEnabled:Boolean = false;
      
      protected var _currentDisplayOffsetRow:uint = 0;
      
      protected var _rowLines:uint = 5;
      
      protected var _columnLines:uint = 1;
      
      protected var _lineSpace:int = 0;
      
      protected var _columnSpace:int = 0;
      
      protected var _selectAble:Boolean = true;
      
      protected var _lineRendererClass:Class;
      
      protected var _lineInstancesAry:Array = [];
      
      protected var _lineEventsAry:Array = [];
      
      protected var _scrollbarOffsetX:Number = 0;
      
      protected var _autoSelectWhenDPChanged:Boolean = true;
      
      private var mListDisableBlocker:Sprite;
      
      protected var mDisableListRightClick:Boolean = false;
      
      public function CodoList()
      {
         super();
      }
      
      override protected function onInit() : void
      {
         this._rowLines = this.row;
         if(this.myHitarea != null)
         {
            this.hitArea = this.myHitarea;
         }
         if(this.myScrollBar != null)
         {
            if(this.myBg != null)
            {
               this._scrollbarOffsetX = this.myScrollBar.x - (this.myBg.x + this.myBg.width);
            }
            else
            {
               this._scrollbarOffsetX = this.myScrollBar.x - (this.myItemRenderer.x + this.myItemRenderer.width);
            }
            this.myScrollBar.enabled = false;
            this.myScrollBar.itemAmount = 0;
         }
         if(this.myNoDataLabel != null)
         {
            this.myNoDataLabel["myLabelTF"].text = Dict.NO_DATA;
         }
         this.createListItemRenderer();
      }
      
      public function set disableListRightClick(disable:Boolean) : void
      {
         this.mDisableListRightClick = disable;
         if(disable)
         {
            this.doubleClickEnabled = false;
         }
      }
      
      public function setListDisabled(isDisabled:Boolean) : void
      {
         if(isDisabled)
         {
            this.mListDisableBlocker = addChild(new Sprite()) as Sprite;
            this.mListDisableBlocker.graphics.beginFill(0,0);
            this.mListDisableBlocker.graphics.drawRect(0,0,this.myItemRenderer.width,this.height);
            this.mListDisableBlocker.graphics.endFill();
            this.alpha = 0.4;
         }
         else if(this.mListDisableBlocker != null)
         {
            this.mListDisableBlocker.graphics.clear();
            removeChild(this.mListDisableBlocker);
            this.alpha = 1;
         }
      }
      
      override protected function onInitListener() : void
      {
         if(this.myBg != null)
         {
            this.myBg.addEventListener(MouseEvent.CLICK,this.onBgClickHandle);
         }
         if(this.myScrollBar != null)
         {
            this.myScrollBar.addEventListener(Event.SCROLL,this.onScrollBarHandle,false,0,true);
            this.myScrollBar.addEventListener(Event.CHANGE,this.onScrollBarHandle,false,0,true);
         }
         this.addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheelHandle,false,0,true);
      }
      
      public function setRows(uRows:uint) : void
      {
         this._rowLines = uRows;
         this.createListItemRenderer();
      }
      
      public function addItem(cItemData:*) : int
      {
         this._dataProvider.push(cItemData);
         this.dataProvider = this._dataProvider;
         return this._dataProvider.length;
      }
      
      public function removeItem(cIndex:int) : *
      {
         var itemData:* = this._dataProvider[cIndex];
         this._dataProvider.splice(cIndex,1);
         this.dataProvider = this._dataProvider;
         if(this.selectedIndex >= this._dataProvider.length)
         {
            this.selectedIndex = this._dataProvider.length - 1;
         }
         return itemData;
      }
      
      public function refresh() : void
      {
         this.dataProvider = this._dataProvider;
      }
      
      public function cleanUp() : void
      {
         this._dataProvider.cleanUp();
         this.dataProvider = this._dataProvider;
      }
      
      public function setStyle(cStyleID:uint) : void
      {
         var targetLine:IListItemRendererBase = null;
         var j:uint = 0;
         for(var i:uint = 0; i < this._lineInstancesAry.length; i++)
         {
            for(j = 0; j < this._lineInstancesAry[i].length; j++)
            {
               targetLine = this._lineInstancesAry[i][j];
               targetLine.style = cStyleID;
            }
         }
      }
      
      public function get maxRowLine() : uint
      {
         var tempMaxRowLine:int = Math.ceil((this._dataProvider.length - this._columnLines * this._rowLines) / this._columnLines);
         if(tempMaxRowLine < 0)
         {
            tempMaxRowLine = 0;
         }
         return tempMaxRowLine;
      }
      
      public function set selectAble(cSwi:Boolean) : void
      {
         this._selectAble = cSwi;
      }
      
      public function set selectedIndex(cIndex:int) : void
      {
         if(this._selectAble == true)
         {
            this._currentSelectedIndex = cIndex;
            if(this._currentSelectedItemRenderer != null)
            {
               this._currentSelectedItemRenderer.selected = false;
            }
            this._currentSelectedItemRenderer = this.getItemRendererByDataIndex(this._currentSelectedIndex);
            if(this._currentSelectedItemRenderer != null)
            {
               this._currentSelectedItemRenderer.selected = true;
            }
         }
      }
      
      public function get selectedIndex() : int
      {
         return this._currentSelectedIndex;
      }
      
      public function rollToSelectedIndex() : void
      {
         var rollSize:int = 0;
         if(this._currentSelectedIndex != -1)
         {
            if(!(this._currentDisplayOffsetRow * this._columnLines <= 1 + this._currentSelectedIndex && (this._currentDisplayOffsetRow + this._rowLines) * this._columnLines >= 1 + this._currentSelectedIndex))
            {
               rollSize = this._currentSelectedIndex - this._currentDisplayOffsetRow * this._columnLines;
               while(rollSize != 0)
               {
                  if(rollSize < 0)
                  {
                     --this.currentDisplayOffsetRow;
                     rollSize++;
                  }
                  else if(rollSize > 0)
                  {
                     ++this.currentDisplayOffsetRow;
                     rollSize--;
                  }
                  this.refreshScrollbar();
               }
            }
         }
      }
      
      public function prevLine() : void
      {
         --this.selectedIndex;
      }
      
      public function nextLine() : void
      {
         ++this.selectedIndex;
      }
      
      public function set focusIndex(cIndex:int) : void
      {
         this._currentFocusIndex = cIndex;
         this._currentFocusItemRenderer = this.getItemRendererByDataIndex(this._currentFocusIndex);
      }
      
      public function get focusIndex() : int
      {
         return this._currentFocusIndex;
      }
      
      public function get currentFocusItemRenderer() : IListItemRendererBase
      {
         return this._currentFocusItemRenderer;
      }
      
      [Inspectable(type="Boolean",defaultValue="false")]
      override public function set doubleClickEnabled(cSwi:Boolean) : void
      {
         var targetLine:IListItemRendererBase = null;
         var j:uint = 0;
         this._doubleClickEnabled = cSwi;
         for(var i:uint = 0; i < this._lineInstancesAry.length; i++)
         {
            for(j = 0; j < this._lineInstancesAry[i].length; j++)
            {
               targetLine = this._lineInstancesAry[i][j];
               if(this._doubleClickEnabled == true)
               {
                  targetLine.enableDoubleClick();
               }
               else
               {
                  targetLine.disableDoubleClick();
               }
            }
         }
      }
      
      override public function get doubleClickEnabled() : Boolean
      {
         return this._doubleClickEnabled;
      }
      
      public function addLineEventListener(cEvtType:String, cCallBackHandle:Function, cUseCapture:Boolean = false, cPriority:int = 0) : void
      {
         this._lineEventsAry.push({
            "type":cEvtType,
            "handle":cCallBackHandle,
            "useCapture":cUseCapture,
            "priority":cPriority
         });
         this.initLineEvent();
      }
      
      public function removeLineEventListener(cEvtType:String, cCallBackHandle:Function) : void
      {
         var removeSuccess:Boolean = false;
         for(var i:uint = 0; i < this._lineEventsAry.length; )
         {
            if(this._lineEventsAry[i].type == cEvtType && this._lineEventsAry[i].handle == cCallBackHandle)
            {
               this._lineEventsAry.splice(i,1);
               removeSuccess = true;
            }
            else
            {
               i++;
            }
         }
         if(removeSuccess == true)
         {
            this.initLineEvent();
         }
      }
      
      [Inspectable(type="Number",defaultValue="1")]
      public function set column(cLines:uint) : void
      {
         if(this._columnLines != cLines)
         {
            this._columnLines = cLines;
         }
      }
      
      public function get column() : uint
      {
         return this._columnLines;
      }
      
      [Inspectable(type="Number",defaultValue="0")]
      public function set lineSpace(cSize:int) : void
      {
         this._lineSpace = cSize;
      }
      
      public function get lineSpace() : int
      {
         return this._lineSpace;
      }
      
      [Inspectable(type="Number",defaultValue="0")]
      public function set columnSpace(cSize:int) : void
      {
         this._columnSpace = cSize;
      }
      
      public function get columnSpace() : int
      {
         return this._columnSpace;
      }
      
      public function get currentDisplayRows() : int
      {
         var tempRows:uint = 0;
         if(this.myScrollBar == null)
         {
            tempRows = this._lineInstancesAry.length;
         }
         else if(this._dataProvider.length / this._columnLines < this._rowLines)
         {
            tempRows = this._dataProvider.length;
         }
         else
         {
            tempRows = this._rowLines;
         }
         return tempRows;
      }
      
      public function set dataProvider(cDP:Array) : void
      {
         if(cDP != null)
         {
            this._dataProvider = DataUtil.arrayToDP(cDP);
            if(this.myNoDataLabel != null)
            {
               this.myNoDataLabel.visible = this._dataProvider.length == 0;
            }
            this.refreshData();
            if(this._currentDisplayOffsetRow > this.maxRowLine)
            {
               this.currentDisplayOffsetRow = this.maxRowLine;
            }
            if(this._autoSelectWhenDPChanged == true && this.selectedIndex >= this._dataProvider.length)
            {
               this.selectedIndex = this._dataProvider.length - 1;
               this.dispatchEvent(new ListEvent(EVT_LINE_CLICK,this._currentSelectedItemRenderer,{"targetLine":this._currentSelectedItemRenderer}));
            }
            this.refreshScrollbar();
         }
         else if(this.myScrollBar != null)
         {
            this.myScrollBar.visible = false;
         }
      }
      
      public function set autoSelectWhenDPChanged(value:Boolean) : void
      {
         this._autoSelectWhenDPChanged = value;
      }
      
      public function get dataProvider() : Array
      {
         return this._dataProvider;
      }
      
      public function set noDataLabel(cTxt:String) : void
      {
         if(this.myNoDataLabel != null)
         {
            this.myNoDataLabel["myLabelTF"].text = cTxt;
         }
      }
      
      public function get selectedValue() : *
      {
         return this._currentSelectedIndex == -1 ? null : this._dataProvider[this._currentSelectedIndex];
      }
      
      public function get focusedValue() : *
      {
         return this._currentFocusIndex == -1 ? null : this._dataProvider[this._currentFocusIndex];
      }
      
      private function createListItemRenderer() : void
      {
         var targetLine:IListItemRendererBase = null;
         var i:uint = 0;
         var index:uint = 0;
         var j:uint = 0;
         var offsetX:Number = NaN;
         var offsetY:Number = NaN;
         if(this.myItemRenderer != null)
         {
            this._lineRendererClass = getDefinitionByName(getQualifiedClassName(this.myItemRenderer)) as Class;
            this._lineInstancesAry[0] = [];
            this._lineInstancesAry[0].push(this.myItemRenderer);
            i = 0;
            index = 0;
            while(i < this._rowLines)
            {
               j = 0;
               while(j < this._columnLines)
               {
                  if(this._lineInstancesAry[i] == null)
                  {
                     this._lineInstancesAry[i] = [];
                  }
                  if(this._lineInstancesAry[i][j] == null)
                  {
                     targetLine = new this._lineRendererClass() as IListItemRendererBase;
                     this._lineInstancesAry[i].push(targetLine);
                  }
                  else
                  {
                     targetLine = this._lineInstancesAry[i][j];
                  }
                  this.addChild(targetLine as DisplayObject);
                  if(this.myScrollBar != null)
                  {
                     this.addChild(this.myScrollBar);
                  }
                  targetLine.x = this.myItemRenderer.x + (this.myItemRenderer.width + this._columnSpace) * (j % this._columnLines);
                  targetLine.y = this.myItemRenderer.y + (this.myItemRenderer.height + this._lineSpace) * i;
                  targetLine.index = index;
                  targetLine["positionIndex"] = index;
                  targetLine["columnIndex"] = j;
                  j++;
                  index++;
               }
               i++;
            }
            if(this._lineInstancesAry.length > this._rowLines)
            {
               this._lineInstancesAry.length = this._rowLines;
            }
         }
         if(this.myBg != null)
         {
            offsetX = this.myItemRenderer.x - (this.myBg.x + this.myBg.scale9Grid.left);
            offsetY = this.myItemRenderer.y - (this.myBg.y + this.myBg.scale9Grid.top);
            this.myBg.width = this.myBg.scale9Grid.left + (this.myBg.width - this.myBg.scale9Grid.right) + offsetX * 2 + (this.myItemRenderer.width + this._columnSpace) * this._columnLines - this._columnSpace;
            this.myBg.height = this.myBg.scale9Grid.top + (this.myBg.height - this.myBg.scale9Grid.bottom) + offsetY * 2 + (this.myItemRenderer.height + this._lineSpace) * this._rowLines - this._lineSpace;
         }
         if(this.myHitarea != null)
         {
            this.myHitarea.width = this.myItemRenderer.width * this._columnLines;
            this.myHitarea.height = this._rowLines * (this.myItemRenderer.height + this._lineSpace) - this._lineSpace;
         }
         if(this.myScrollBar != null)
         {
            if(this.myBg != null)
            {
               this.myScrollBar.x = this.myBg.x + this.myBg.width + this._scrollbarOffsetX;
            }
            else
            {
               this.myScrollBar.x = this.myItemRenderer.x + ((this.myItemRenderer.width + this._columnSpace) * this._columnLines - this._columnSpace) + this._scrollbarOffsetX;
            }
            this.myScrollBar.height = (this.myItemRenderer.height + this._lineSpace) * this._rowLines - this._lineSpace;
         }
         this.initLineEvent();
         this.refreshData();
      }
      
      public function getItemRendererByDataIndex(cIndex:int) : IListItemRendererBase
      {
         var targetItemRenderer:IListItemRendererBase = null;
         var i:uint = 0;
         var j:uint = 0;
         if(cIndex >= 0)
         {
            for(i = 0; i < this._lineInstancesAry.length; i++)
            {
               for(j = 0; j < this._lineInstancesAry[i].length; j++)
               {
                  if(this._lineInstancesAry[i][j] != null && this._lineInstancesAry[i][j].index == cIndex)
                  {
                     targetItemRenderer = this._lineInstancesAry[i][j];
                     break;
                  }
               }
            }
         }
         else
         {
            targetItemRenderer = null;
         }
         return targetItemRenderer;
      }
      
      private function initLineEvent() : void
      {
         var j:uint = 0;
         var targetLine:IListItemRendererBase = null;
         var k:uint = 0;
         for(var i:uint = 0; i < this._lineInstancesAry.length; i++)
         {
            for(j = 0; j < this._lineInstancesAry[i].length; j++)
            {
               targetLine = this._lineInstancesAry[i][j];
               targetLine.addEventListener(BaseButton.EVT_CLICK,this.onLineEvtHandle,false,0,true);
               targetLine.addEventListener(BaseButton.EVT_RIGHT_CLICK,this.onLineEvtHandle,false,0,true);
               targetLine.addEventListener(BaseButton.EVT_DOUBLE_CLICK,this.onLineEvtHandle,false,0,true);
               targetLine.addEventListener(BaseButton.EVT_MOUSE_OVER,this.onLineEvtHandle,false,0,true);
               targetLine.addEventListener(BaseButton.EVT_MOUSE_OUT,this.onLineEvtHandle,false,0,true);
               for(k = 0; k < this._lineEventsAry.length; k++)
               {
                  targetLine.addEventListener(this._lineEventsAry[k].type,this._lineEventsAry[k].handle,this._lineEventsAry[k].useCapture,this._lineEventsAry[k].priority);
               }
               if(this._doubleClickEnabled == true)
               {
                  targetLine.enableDoubleClick();
               }
               else
               {
                  targetLine.disableDoubleClick();
               }
            }
         }
      }
      
      private function onBgClickHandle(cEvt:MouseEvent) : void
      {
      }
      
      protected function onLineEvtHandle(cEvt:Event) : void
      {
         var rendererIndex:int = 0;
         var type:String = null;
         var renderer:IListItemRendererBase = cEvt.currentTarget as IListItemRendererBase;
         if(renderer != null)
         {
            rendererIndex = renderer.index;
         }
         else
         {
            rendererIndex = -1;
         }
         switch(cEvt.type)
         {
            case BaseButton.EVT_CLICK:
               this.selectedIndex = rendererIndex;
               type = EVT_LINE_CLICK;
               break;
            case BaseButton.EVT_RIGHT_CLICK:
               if(this.mDisableListRightClick)
               {
                  return;
               }
               this.selectedIndex = rendererIndex;
               type = EVT_LINE_RIGHT_CLICK;
               break;
            case BaseButton.EVT_MOUSE_OVER:
               this.focusIndex = rendererIndex;
               type = EVT_LINE_ROLLOVER;
               break;
            case BaseButton.EVT_MOUSE_OUT:
               this.focusIndex = -1;
               type = EVT_LINE_ROLLOUT;
               break;
            case BaseButton.EVT_DOUBLE_CLICK:
               this.selectedIndex = rendererIndex;
               type = EVT_LINE_DOUBLE_CLICK;
         }
         if(type != "" && type != null && renderer != null)
         {
            this.dispatchEvent(new ListEvent(type,renderer,{"targetLine":renderer}));
         }
      }
      
      private function refreshData() : void
      {
         var i:uint = 0;
         var j:uint = 0;
         while(i < this._lineInstancesAry.length)
         {
            if(this._lineInstancesAry[i] != null)
            {
               for(j = 0; j < this._lineInstancesAry[i].length; j++)
               {
                  if(this._lineInstancesAry[i][j] != null)
                  {
                     this._lineInstancesAry[i][j].setData(this._dataProvider[this._lineInstancesAry[i][j].index]);
                  }
               }
            }
            i++;
         }
      }
      
      protected function onScrollBarHandle(event:Event) : void
      {
         var targetPos:int = Math.round(this.maxRowLine * this.myScrollBar.targetPosition);
         this.currentDisplayOffsetRow = targetPos;
      }
      
      protected function set currentDisplayOffsetRow(cRow:uint) : void
      {
         var targetLine:IListItemRendererBase = null;
         var i:uint = 0;
         var index:uint = 0;
         var j:uint = 0;
         if(this._currentDisplayOffsetRow != cRow && cRow >= 0 && cRow <= this.maxRowLine)
         {
            this._currentDisplayOffsetRow = cRow;
            for(index = 0; i < this._lineInstancesAry.length; i++)
            {
               if(this._lineInstancesAry[i] != null)
               {
                  j = 0;
                  while(j < this._lineInstancesAry[i].length)
                  {
                     targetLine = this._lineInstancesAry[i][j];
                     if(targetLine != null)
                     {
                        targetLine.index = cRow * this._columnLines + index;
                     }
                     j++;
                     index++;
                  }
               }
            }
            this.selectedIndex = this.selectedIndex;
            this.refreshData();
         }
      }
      
      protected function get currentDisplayOffsetRow() : uint
      {
         return this._currentDisplayOffsetRow;
      }
      
      protected function onMouseWheelHandle(cEvt:MouseEvent) : void
      {
         var tempDelta:Number = NaN;
         if(this._dataProvider.length > this._columnLines)
         {
            tempDelta = -cEvt.delta;
            if(tempDelta > 0)
            {
               ++this.currentDisplayOffsetRow;
               this.refreshScrollbar();
            }
            else
            {
               --this.currentDisplayOffsetRow;
               this.refreshScrollbar();
            }
            if(this._currentFocusItemRenderer != null)
            {
               this._currentFocusItemRenderer.dispatchEvent(new Event(BaseButton.EVT_MOUSE_OVER));
            }
            this.dispatchEvent(new ListEvent(EVT_WHEEL,this.currentFocusItemRenderer,{"targetLine":this.currentFocusItemRenderer}));
         }
      }
      
      protected function refreshScrollbar() : void
      {
         if(this.myScrollBar != null)
         {
            this.myScrollBar.visible = this.maxRowLine > 0;
            this.myScrollBar.itemAmount = this._dataProvider.length - this.currentDisplayRows;
            this.myScrollBar.position = this._currentDisplayOffsetRow / this.maxRowLine;
         }
      }
   }
}

