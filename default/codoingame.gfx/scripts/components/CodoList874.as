package components
{
   import codo.constants.TweenParam;
   import codo.event.ParaEvent;
   import codo.interfaces.IList;
   import codo.localization.Dict;
   import com.greensock.TweenLite;
   import components.list_part.ListItemRendererBase8;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.clearInterval;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   import flash.utils.setInterval;
   import shaui.component.core.InteractiveComponent;
   
   public class CodoList874 extends InteractiveComponent implements IList
   {
      
      public static const EVT_SELECTED_CHANGED:String = "evt_selected_changed";
      
      public static const EVT_FOCUS_CHANGED:String = "evt_focus_changed";
      
      public static const EVT_LINE_CLICK:String = "evt_line_click";
      
      public static const EVT_LINE_RIGHT_CLICK:String = "evt_line_right_click";
      
      public static const EVT_LINE_DOUBLE_CLICK:String = "evt_line_double_click";
      
      public static const EVT_LINE_ROLLOVER:String = "evt_line_rollover";
      
      public static const EVT_LINE_ROLLOUT:String = "evt_line_rollout";
      
      public static const EVT_WHEEL:String = "evt_wheel";
      
      public static const EVT_TWEENING:String = "evt_tweening";
      
      public var myHitarea:Sprite;
      
      public var myScrollBar:ScrollBar;
      
      public var myItemRenderer:ListItemRendererBase8;
      
      public var myBg:MovieClip;
      
      public var myNoDataLabel:Sprite;
      
      protected var _lineRendererClass:Class;
      
      protected var _lineRendererScaleX:Number = 1;
      
      protected var _lineContainer:Sprite;
      
      protected var _lineContainerMask:Sprite;
      
      protected var _lineInstancesVector:Vector.<ListItemRendererBase8> = new Vector.<ListItemRendererBase8>();
      
      protected var _selectAble:Boolean = true;
      
      protected var _currentSelectedDataIndex:int = -1;
      
      protected var _currentFocusDataIndex:int = -1;
      
      protected var _lineEventsAry:Array = [];
      
      protected var _totalShowLines:int = -1;
      
      protected var _lineSpace:int = 0;
      
      protected var _doubleClickEnabled:Boolean = false;
      
      protected var _offSetTarget:Number = 0;
      
      protected var _rollTargetDataIndex:int = -1;
      
      protected var _rollTweenInterval:Number = -1;
      
      protected var _rollIntervalPerKeyFrame:Number = 30;
      
      protected var _rollAxis:String = "y";
      
      protected var _rollSize:String = "height";
      
      protected var _otherAxis:String = "x";
      
      protected var _otherSize:String = "width";
      
      private var _targetPos:Number = 0;
      
      private var _currentPos:Number = 0;
      
      protected var _dataProvider:Array = [];
      
      protected var _area:Object = {
         "x":0,
         "y":0
      };
      
      private var _dragAble:Boolean = false;
      
      private var _mouseDownPos:Number;
      
      private var _wheelSpd:uint = 30;
      
      private var _enableRightClick:Boolean = true;
      
      private var _enableScroll:Boolean = true;
      
      private var _isNoLabelCustom:Boolean = false;
      
      public function CodoList874()
      {
         super();
      }
      
      override protected function onInit() : void
      {
         var tempHeight:Number = NaN;
         var tempWidth:Number = width;
         tempHeight = height;
         this._lineRendererScaleX = this.myItemRenderer.scaleX;
         this._lineRendererClass = getDefinitionByName(getQualifiedClassName(this.myItemRenderer)) as Class;
         this._lineInstancesVector.push(this.myItemRenderer);
         this.initLineEvt(this.myItemRenderer);
         this.initLineCustomEvt(this.myItemRenderer);
         this.myItemRenderer.container = this;
         this.myItemRenderer.dataIndex = -1;
         removeChild(this.myItemRenderer);
         this._lineContainer = new Sprite();
         addChild(this._lineContainer);
         this._lineContainer.x = this.myItemRenderer.x;
         this._lineContainer.y = this.myItemRenderer.y;
         this._area = {
            "x":0,
            "y":0,
            "width":tempWidth,
            "height":tempHeight
         };
         this.dragAble = this._dragAble;
         if(this._rollAxis == "x")
         {
            this._rollSize = "width";
            this._otherAxis = "y";
            this._otherSize = "height";
         }
         this.myItemRenderer[this._otherAxis] = 0;
         if(this.myHitarea == null)
         {
            this.myHitarea = new Sprite();
            this.myHitarea.graphics.beginFill(255);
            this.myHitarea.graphics.drawRect(0,0,100,100);
            this.myHitarea.graphics.endFill();
            this.myHitarea.alpha = 0;
            addChild(this.myHitarea);
         }
         this.refreshDisplayArea();
         this.refresh();
         hitArea = this.myHitarea;
         if(this.myScrollBar != null)
         {
            this.myScrollBar.moveBarBySelf = false;
            addChildAt(this.myScrollBar,numChildren - 1);
         }
         if(this.myNoDataLabel != null && this._isNoLabelCustom == false)
         {
            this.myNoDataLabel["myLabelTF"].text = Dict.NO_DATA;
         }
         this._lineContainer.mask = this.lineContainerMask;
      }
      
      protected function get lineContainerMask() : Sprite
      {
         if(this._lineContainerMask == null)
         {
            this._lineContainerMask = new Sprite();
            this._lineContainerMask.graphics.beginFill(255);
            this._lineContainerMask.graphics.drawRect(0,0,this._area.width,this._area.height);
            this._lineContainerMask.graphics.endFill();
            this._lineContainerMask.x = this._lineContainer.x;
            this._lineContainerMask.y = this._lineContainer.y;
            addChild(this._lineContainerMask);
            this._lineContainerMask.mouseEnabled = false;
         }
         return this._lineContainerMask;
      }
      
      override protected function onInitListener() : void
      {
         addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheelHandler,false,0,true);
         if(this.myScrollBar != null)
         {
            this.myScrollBar.addEventListener(Event.SCROLL,this.onScrollBarHandle,false,0,true);
            this.myScrollBar.addEventListener(Event.CHANGE,this.onScrollBarHandle,false,0,true);
         }
      }
      
      protected function removeAllListener() : void
      {
         removeEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheelHandler);
         if(this.myScrollBar != null)
         {
            this.myScrollBar.removeEventListener(Event.SCROLL,this.onScrollBarHandle);
            this.myScrollBar.removeEventListener(Event.CHANGE,this.onScrollBarHandle);
         }
      }
      
      public function enableMask(cSwi:Boolean) : void
      {
         if(cSwi == true)
         {
            this.lineContainerMask.visible = true;
            this._lineContainer.mask = this.lineContainerMask;
         }
         else
         {
            this.lineContainerMask.visible = false;
            this._lineContainer.mask = null;
         }
      }
      
      [Inspectable(type="Boolean",defaultValue="false")]
      public function set doubleClickAble(cSwi:Boolean) : void
      {
         this._doubleClickEnabled = cSwi;
         if(this._doubleClickEnabled)
         {
            this.myItemRenderer.enableDoubleClick();
         }
         for(var i:uint = 0; i < this._lineInstancesVector.length; i++)
         {
            if(this._doubleClickEnabled == true)
            {
               this._lineInstancesVector[i].enableDoubleClick();
            }
            else
            {
               this._lineInstancesVector[i].disableDoubleClick();
            }
         }
      }
      
      [Inspectable(type="Boolean",defaultValue="false")]
      public function set dragAble(cSwi:Boolean) : void
      {
         this._dragAble = cSwi;
         if(this._lineContainer != null)
         {
            if(this._dragAble == true)
            {
               if(this.myHitarea != null)
               {
                  this.myHitarea.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDownHandle);
               }
               this._lineContainer.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDownHandle);
            }
            else
            {
               if(this.myHitarea != null)
               {
                  this.myHitarea.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDownHandle);
               }
               this._lineContainer.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDownHandle);
            }
         }
      }
      
      public function get dragAble() : Boolean
      {
         return this._dragAble;
      }
      
      [Inspectable(type="Number",defaultValue="0")]
      public function set lineSpace(cSize:int) : void
      {
         this._lineSpace = cSize;
      }
      
      [Inspectable(type="Boolean",defaultValue="true")]
      public function set selectAble(cSwi:Boolean) : void
      {
         this._selectAble = cSwi;
      }
      
      public function set noDataLabel(cTxt:String) : void
      {
         if(this.myNoDataLabel != null)
         {
            this._isNoLabelCustom = true;
            this.myNoDataLabel["myLabelTF"].text = cTxt;
         }
      }
      
      [Inspectable(type="String",defaultValue="y",enumeration="x,y")]
      public function set rollAxis(cAxis:String) : void
      {
         this._rollAxis = cAxis;
      }
      
      public function get totalRollSize() : Number
      {
         var tempRollSize:Number = this.totalLineSize - this._area[this._rollSize];
         if(tempRollSize < 0)
         {
            tempRollSize = 0;
         }
         return tempRollSize;
      }
      
      public function get totalLineSize() : Number
      {
         return this._dataProvider.length * (this.myItemRenderer[this._rollSize] + this._lineSpace) - this._lineSpace;
      }
      
      public function getFullLineSpace() : int
      {
         return this.myItemRenderer[this._rollSize] + this._lineSpace;
      }
      
      public function set dataProvider(cDP:Array) : void
      {
         this._dataProvider = cDP;
         this.detectDataLength();
         this.refresh();
      }
      
      public function refeshData() : void
      {
         this.refresh();
      }
      
      public function get dataProvider() : Array
      {
         return this._dataProvider;
      }
      
      public function getDataByIndex(cDataIndex:int) : Object
      {
         var tempDat:Object = null;
         if(this._dataProvider != null && cDataIndex < this._dataProvider.length)
         {
            tempDat = this._dataProvider[cDataIndex];
         }
         return tempDat;
      }
      
      public function changeSelectedDataIndex(cIndex:int, cBroadCast:Boolean = false) : void
      {
         if(this._selectAble == true)
         {
            if(this.currentSelectedItemRenderer != null)
            {
               this.currentSelectedItemRenderer.selected = false;
            }
            this._currentSelectedDataIndex = cIndex;
            if(this.currentSelectedItemRenderer != null)
            {
               this.currentSelectedItemRenderer.selected = true;
            }
            else if(this._currentSelectedDataIndex > this._dataProvider.length - 1)
            {
               this._currentSelectedDataIndex = -1;
            }
            if(cBroadCast == true)
            {
               dispatchEvent(new ParaEvent(EVT_SELECTED_CHANGED));
            }
         }
      }
      
      public function set selectedDataIndex(cIndex:int) : void
      {
         this.changeSelectedDataIndex(cIndex,true);
      }
      
      public function get currentSelectedItemRenderer() : ListItemRendererBase8
      {
         return this.getItemRendererByDataIndex(this._currentSelectedDataIndex);
      }
      
      public function get selectedDataIndex() : int
      {
         return this._currentSelectedDataIndex;
      }
      
      public function rollToLineByDataIndex(cIndex:int, cSelectTarget:Boolean = false, cTween:Boolean = true) : void
      {
         if(this._rollTargetDataIndex != cIndex)
         {
            this._offSetTarget = 0;
            if(cIndex > this._dataProvider.length - 1)
            {
               cIndex = this._dataProvider.length - 1;
            }
            else if(cIndex < 0)
            {
               cIndex = 0;
            }
            this._rollTargetDataIndex = cIndex;
            if(cSelectTarget == true)
            {
               this.selectedDataIndex = cIndex;
            }
            this.tryRoll(cTween);
         }
      }
      
      public function selectPrev() : void
      {
         this.rollToLineByDataIndex(this._currentSelectedDataIndex - 1,true,true);
      }
      
      public function selectNext() : void
      {
         this.rollToLineByDataIndex(this._currentSelectedDataIndex + 1,true,true);
      }
      
      public function set focusDataIndex(cIndex:int) : void
      {
         this._currentFocusDataIndex = cIndex;
         if(this._currentFocusDataIndex > this._dataProvider.length - 1)
         {
            this._currentFocusDataIndex = -1;
         }
         dispatchEvent(new ParaEvent(EVT_FOCUS_CHANGED));
      }
      
      public function get focusDataIndex() : int
      {
         return this._currentFocusDataIndex;
      }
      
      public function get currentFocusItemRenderer() : ListItemRendererBase8
      {
         return this.getItemRendererByDataIndex(this._currentFocusDataIndex);
      }
      
      public function get selectedValue() : *
      {
         var tempResult:* = null;
         if(this._currentSelectedDataIndex >= 0 || this._currentSelectedDataIndex < this._dataProvider.length)
         {
            tempResult = this._dataProvider[this._currentSelectedDataIndex];
         }
         return tempResult;
      }
      
      public function get focusedValue() : *
      {
         var tempResult:* = null;
         if(this._currentFocusDataIndex >= 0 || this._currentFocusDataIndex < this._dataProvider.length)
         {
            tempResult = this._dataProvider[this._currentFocusDataIndex];
         }
         return tempResult;
      }
      
      public function cleanUp() : void
      {
         this._dataProvider.splice(0,this._dataProvider.length);
         this.dataProvider = this._dataProvider;
      }
      
      public function setStyle(cStyleID:uint) : void
      {
         var targetLine:ListItemRendererBase8 = null;
         for(var i:uint = 0; i < this._lineInstancesVector.length; i++)
         {
            targetLine = this._lineInstancesVector[i];
            targetLine.style = cStyleID;
         }
      }
      
      public function get totalShowLines() : uint
      {
         if(this._totalShowLines == -1 && this._lineInstancesVector.length > 0)
         {
            this._totalShowLines = 0;
            this._totalShowLines = Math.floor((this._area[this._rollSize] + this._lineSpace) / (this._lineInstancesVector[0][this._rollSize] + this._lineSpace));
         }
         return this._totalShowLines;
      }
      
      public function set targetPos(cPos:Number) : void
      {
         if(isNaN(cPos) == false)
         {
            this._targetPos = cPos;
         }
      }
      
      public function get targetPos() : Number
      {
         return this._targetPos;
      }
      
      public function rollToTargetPos(cPos:Number) : void
      {
         this._targetPos = cPos;
         TweenLite.to(this,TweenParam.SPD_SCROLLBAR_ROLL,{
            "targetPos":cPos,
            "onUpdate":this.onRollUpdateHandle,
            "onUpdateParams":[cPos]
         });
      }
      
      private function onRollUpdateHandle(cPos:Number) : void
      {
         var tempOffset:Number = this._targetPos - this._currentPos;
         if(tempOffset > this._area[this._rollSize])
         {
            tempOffset = Number(this._area[this._rollSize]);
         }
         else if(tempOffset < -this._area[this._rollSize])
         {
            tempOffset = -this._area[this._rollSize];
         }
         this.rollByOffset(tempOffset);
      }
      
      public function rollByOffset(cOffset:int, cEnableRollBack:Boolean = true) : void
      {
         var tempFirstDataLine:ListItemRendererBase8 = null;
         var tempLastDataLine:ListItemRendererBase8 = null;
         var tempItemRenderer:ListItemRendererBase8 = null;
         var tempTargetPos:Number = NaN;
         var i:uint = 0;
         this._currentPos += cOffset;
         if(cOffset != 0 && this._dataProvider.length > 0)
         {
            tempFirstDataLine = this.getFirstDataLineItemRenderer();
            tempLastDataLine = this.getLastDataLineItemRenderer();
            if(cEnableRollBack == true && (tempFirstDataLine != null && tempFirstDataLine[this._rollAxis] >= this._area[this._rollAxis]) && (tempLastDataLine != null && tempLastDataLine[this._rollAxis] + tempLastDataLine[this._rollSize] <= this._area[this._rollSize]))
            {
               this.tryRollBack();
               return;
            }
            for(i = 0; i < this._lineInstancesVector.length; i++)
            {
               tempItemRenderer = this._lineInstancesVector[i];
               if(tempItemRenderer.parent != null)
               {
                  tempTargetPos = tempItemRenderer[this._rollAxis] + cOffset;
                  if(tempTargetPos + tempItemRenderer[this._rollSize] < this._area[this._rollAxis])
                  {
                     this._lineContainer.removeChild(tempItemRenderer);
                     if(tempItemRenderer.dataIndex == this._currentSelectedDataIndex)
                     {
                        tempItemRenderer.selected = false;
                     }
                     tempItemRenderer.dataIndex = -1;
                     tempItemRenderer[this._rollAxis] = tempTargetPos;
                  }
                  else if(tempTargetPos > this._area[this._rollAxis] + this._area[this._rollSize])
                  {
                     this._lineContainer.removeChild(tempItemRenderer);
                     if(tempItemRenderer.dataIndex == this._currentSelectedDataIndex)
                     {
                        tempItemRenderer.selected = false;
                     }
                     tempItemRenderer.dataIndex = -1;
                     tempItemRenderer[this._rollAxis] = tempTargetPos;
                  }
                  else
                  {
                     tempItemRenderer[this._rollAxis] = tempTargetPos;
                  }
               }
            }
            this.tryAddItemRendererToEmptyArea();
            if(cEnableRollBack == true)
            {
               this.tryRollBack();
            }
         }
         this.refreshScrollbar();
         dispatchEvent(new ParaEvent(EVT_TWEENING));
      }
      
      override public function set height(value:Number) : void
      {
         this.refreshDisplayArea();
      }
      
      public function addLineEventListener(cEvtType:String, cCallBackHandle:Function, cUseCapture:Boolean = false, cPriority:int = 0) : void
      {
         var i:uint = 0;
         for(i = 0; i < this._lineEventsAry.length; i++)
         {
            if(this._lineEventsAry[i].type == cEvtType && this._lineEventsAry[i].handle == cCallBackHandle)
            {
               return;
            }
         }
         this._lineEventsAry.push({
            "type":cEvtType,
            "handle":cCallBackHandle,
            "useCapture":cUseCapture,
            "priority":cPriority
         });
         this.initAllLineCustomEvt();
      }
      
      public function removeAllLineEventListener() : void
      {
         this.removeAllLineCustomEvt();
      }
      
      private function initAllLineCustomEvt() : void
      {
         for(var i:uint = 0; i < this._lineInstancesVector.length; i++)
         {
            this.initLineCustomEvt(this._lineInstancesVector[i]);
         }
      }
      
      private function removeAllLineCustomEvt() : void
      {
         for(var i:uint = 0; i < this._lineInstancesVector.length; i++)
         {
            this.removeLineCustomEvt(this._lineInstancesVector[i]);
         }
         this._lineEventsAry = [];
      }
      
      private function initLineCustomEvt(cTargetLineItemRenderer:ListItemRendererBase8) : void
      {
         for(var k:uint = 0; k < this._lineEventsAry.length; k++)
         {
            cTargetLineItemRenderer.addEventListener(this._lineEventsAry[k].type,this._lineEventsAry[k].handle,this._lineEventsAry[k].useCapture,this._lineEventsAry[k].priority);
         }
      }
      
      private function removeLineCustomEvt(cTargetLineItemRenderer:ListItemRendererBase8) : void
      {
         for(var k:uint = 0; k < this._lineEventsAry.length; k++)
         {
            cTargetLineItemRenderer.removeEventListener(this._lineEventsAry[k].type,this._lineEventsAry[k].handle,this._lineEventsAry[k].useCapture);
         }
      }
      
      protected function refreshDisplayArea() : void
      {
         if(scaleY != 1 || scaleX != 1)
         {
            this.myHitarea.width = this._area.width;
            this.myHitarea.height = this._area.height;
            if(this.myScrollBar != null)
            {
               this.myScrollBar.scaleX = this.myScrollBar.scaleY = 1;
               if(this._rollAxis == "y")
               {
                  this.myScrollBar.height = this._area.height;
               }
               else
               {
                  this.myScrollBar.height = this._area.width;
               }
               this.myScrollBar.enabled = false;
               this.myScrollBar.itemAmount = 0;
            }
            scaleX = scaleY = 1;
            this.tryAddItemRendererToEmptyArea();
         }
      }
      
      protected function refresh() : void
      {
         var tempItemRenderer:ListItemRendererBase8 = null;
         var tempOffsetPos:Number = NaN;
         this._lineInstancesVector = this._lineInstancesVector.sort(this.sortByRollAxis);
         var tempNextDataIndex:int = 0;
         var tempCount:uint = 0;
         for(var i:uint = 0; i < this._lineInstancesVector.length; i++)
         {
            tempItemRenderer = this._lineInstancesVector[i];
            if(tempItemRenderer.parent != null)
            {
               if(tempItemRenderer.dataIndex >= 0)
               {
                  if(tempItemRenderer.dataIndex <= this._dataProvider.length - 1)
                  {
                     tempNextDataIndex = tempItemRenderer.dataIndex;
                  }
                  else if(tempItemRenderer.dataIndex > this._dataProvider.length - 1)
                  {
                     if(tempCount == 0)
                     {
                        tempNextDataIndex = this._dataProvider.length - 1;
                     }
                     else
                     {
                        tempNextDataIndex = -1;
                     }
                  }
               }
               else if(tempCount == 0 && tempItemRenderer.dataIndex == -1)
               {
                  tempNextDataIndex = 0;
               }
               if(tempNextDataIndex > this._dataProvider.length - 1)
               {
                  tempNextDataIndex = -1;
               }
               tempItemRenderer.dataIndex = tempNextDataIndex;
               if(tempNextDataIndex != -1)
               {
                  tempNextDataIndex++;
               }
               tempCount++;
            }
         }
         this.tryAddItemRendererToEmptyArea();
         if(this._dataProvider.length > 0 && this._dataProvider.length > this.totalShowLines)
         {
            if(this.myScrollBar != null)
            {
               this.myScrollBar.enabled = true;
               this.myScrollBar.itemAmount = this._dataProvider.length - this.totalShowLines;
            }
            this._enableScroll = true;
         }
         else
         {
            if(this.myScrollBar != null)
            {
               this.myScrollBar.enabled = false;
               this.myScrollBar.itemAmount = 0;
            }
            this._enableScroll = false;
         }
         var tempFirstInAreaLineItem:ListItemRendererBase8 = this.getFirstInAreaLineItemRenderer(true,false);
         if(tempFirstInAreaLineItem != null)
         {
            tempOffsetPos = tempFirstInAreaLineItem.dataIndex * (this.myItemRenderer[this._rollSize] + this._lineSpace) - tempFirstInAreaLineItem[this._rollAxis];
            this._currentPos = -tempOffsetPos;
            this.refreshScrollbar();
         }
         this.tryRollBack();
      }
      
      protected function tryAddItemRendererToEmptyArea() : void
      {
         var tempItemRenderer:ListItemRendererBase8 = null;
         this._lineInstancesVector = this._lineInstancesVector.sort(this.sortByRollAxis);
         var minPos:int = 0;
         var maxPos:int = 0;
         var firstInAreaDataIndex:int = -1;
         var firstInAreaItemRenderer:ListItemRendererBase8 = this.getFirstInAreaLineItemRenderer(false);
         if(firstInAreaItemRenderer != null)
         {
            firstInAreaDataIndex = firstInAreaItemRenderer.dataIndex;
            minPos = int(firstInAreaItemRenderer[this._rollAxis]);
         }
         var lastInAreaDataIndex:int = -1;
         var lastInAreaItemRenderer:ListItemRendererBase8 = this.getLastInAreaLineItemRenderer(false);
         if(lastInAreaItemRenderer != null)
         {
            lastInAreaDataIndex = lastInAreaItemRenderer.dataIndex;
            maxPos = lastInAreaItemRenderer[this._rollAxis] + lastInAreaItemRenderer[this._rollSize];
         }
         while(firstInAreaDataIndex > 0)
         {
            tempItemRenderer = this.getEmptyItemRenderer();
            tempItemRenderer[this._otherAxis] = 0;
            if(minPos < this._area[this._rollAxis])
            {
               break;
            }
            tempItemRenderer[this._otherAxis] = 0;
            minPos -= tempItemRenderer[this._rollSize] + this._lineSpace;
            tempItemRenderer[this._rollAxis] = minPos;
            if(firstInAreaDataIndex != -1)
            {
               firstInAreaDataIndex--;
            }
            if(firstInAreaDataIndex < 0)
            {
               firstInAreaDataIndex = -1;
            }
            this._lineContainer.addChild(tempItemRenderer);
            tempItemRenderer.dataIndex = firstInAreaDataIndex;
         }
         while(maxPos < this._area[this._rollSize])
         {
            tempItemRenderer = this.getEmptyItemRenderer();
            this._lineContainer.addChild(tempItemRenderer);
            maxPos += this._lineSpace;
            tempItemRenderer[this._rollAxis] = maxPos;
            maxPos += tempItemRenderer[this._rollSize];
            tempItemRenderer[this._otherAxis] = 0;
            if(lastInAreaDataIndex != -1)
            {
               lastInAreaDataIndex++;
            }
            if(lastInAreaDataIndex > this._dataProvider.length - 1)
            {
               lastInAreaDataIndex = -1;
            }
            tempItemRenderer.dataIndex = lastInAreaDataIndex;
            if(this._currentSelectedDataIndex != -1 && lastInAreaDataIndex == this._currentSelectedDataIndex)
            {
               tempItemRenderer.selected = true;
            }
         }
      }
      
      protected function getEmptyItemRenderer() : ListItemRendererBase8
      {
         var tempResult:ListItemRendererBase8 = null;
         for(var i:uint = 0; i < this._lineInstancesVector.length; i++)
         {
            if(this._lineInstancesVector[i].parent == null)
            {
               tempResult = this._lineInstancesVector[i];
            }
         }
         if(tempResult == null)
         {
            tempResult = new this._lineRendererClass() as ListItemRendererBase8;
            tempResult.scaleX = this._lineRendererScaleX;
            tempResult.container = this;
            if(this._doubleClickEnabled == true)
            {
               tempResult.enableDoubleClick();
            }
            this.initLineEvt(tempResult);
            this.initLineCustomEvt(tempResult);
            this._lineInstancesVector.push(tempResult);
         }
         return tempResult;
      }
      
      public function getFirstInAreaLineItemRenderer(cValidData:Boolean = true, cWholeLineInArea:Boolean = false) : ListItemRendererBase8
      {
         var targetLine:ListItemRendererBase8 = null;
         for(var i:uint = 0; i < this._lineInstancesVector.length; i++)
         {
            if(this._lineInstancesVector[i].parent != null)
            {
               if(this._lineInstancesVector[i][this._rollAxis] + this._lineInstancesVector[i][this._rollSize] >= this._area[this._rollAxis])
               {
                  if(!(cValidData == true && this._lineInstancesVector[i].dataIndex == -1))
                  {
                     if(!(cWholeLineInArea == true && (this._lineInstancesVector[i][this._rollAxis] < this._area[this._rollAxis] || this._lineInstancesVector[i][this._rollAxis] > this._area[this._rollSize])))
                     {
                        if(targetLine == null)
                        {
                           targetLine = this._lineInstancesVector[i];
                        }
                        else if(targetLine[this._rollAxis] > this._lineInstancesVector[i][this._rollAxis])
                        {
                           targetLine = this._lineInstancesVector[i];
                        }
                     }
                  }
               }
            }
         }
         return targetLine;
      }
      
      public function getLastInAreaLineItemRenderer(cValidData:Boolean = true) : ListItemRendererBase8
      {
         var targetLine:ListItemRendererBase8 = null;
         for(var i:uint = 0; i < this._lineInstancesVector.length; i++)
         {
            if(this._lineInstancesVector[i].parent != null)
            {
               if(this._lineInstancesVector[i][this._rollAxis] < this._area[this._rollSize])
               {
                  if(!(cValidData == true && this._lineInstancesVector[i].dataIndex == -1))
                  {
                     if(targetLine == null)
                     {
                        targetLine = this._lineInstancesVector[i];
                     }
                     else if(targetLine[this._rollAxis] < this._lineInstancesVector[i][this._rollAxis])
                     {
                        targetLine = this._lineInstancesVector[i];
                     }
                  }
               }
            }
         }
         return targetLine;
      }
      
      public function getFirstDataLineItemRenderer(cFirstIsZero:Boolean = true) : ListItemRendererBase8
      {
         var targetLine:ListItemRendererBase8 = null;
         var minDataIndex:int = 9999;
         for(var i:uint = 0; i < this._lineInstancesVector.length; i++)
         {
            if(this._lineInstancesVector[i].parent != null)
            {
               if(cFirstIsZero == true)
               {
                  if(this._lineInstancesVector[i].dataIndex == 0)
                  {
                     targetLine = this._lineInstancesVector[i];
                     break;
                  }
               }
               else if(this._lineInstancesVector[i].dataIndex >= 0 && this._lineInstancesVector[i].dataIndex < minDataIndex)
               {
                  minDataIndex = this._lineInstancesVector[i].dataIndex;
                  targetLine = this._lineInstancesVector[i];
               }
            }
         }
         return targetLine;
      }
      
      public function getLastDataLineItemRenderer(cLastDataIndex:Boolean = true) : ListItemRendererBase8
      {
         var targetLine:ListItemRendererBase8 = null;
         var maxDataIndex:int = -9999;
         for(var i:int = this._lineInstancesVector.length - 1; i >= 0; i--)
         {
            if(this._lineInstancesVector[i].parent != null)
            {
               if(cLastDataIndex == true)
               {
                  if(this._lineInstancesVector[i].dataIndex == this._dataProvider.length - 1)
                  {
                     targetLine = this._lineInstancesVector[i];
                     break;
                  }
               }
               else if(this._lineInstancesVector[i].dataIndex > maxDataIndex)
               {
                  maxDataIndex = this._lineInstancesVector[i].dataIndex;
                  targetLine = this._lineInstancesVector[i];
               }
            }
         }
         return targetLine;
      }
      
      public function getItemRendererByDataIndex(cIndex:int) : ListItemRendererBase8
      {
         var result:ListItemRendererBase8 = null;
         for(var i:uint = 0; i < this._lineInstancesVector.length; i++)
         {
            if(this._lineInstancesVector[i].dataIndex == cIndex)
            {
               result = this._lineInstancesVector[i];
               break;
            }
         }
         return result;
      }
      
      [Inspectable(type="Number",defaultValue="20")]
      public function set wheelSpd(cSpd:uint) : void
      {
         this._wheelSpd = cSpd;
      }
      
      public function get currentPos() : Number
      {
         return this._currentPos;
      }
      
      public function set enableRightClick(cSwi:Boolean) : void
      {
         this._enableRightClick = cSwi;
      }
      
      public function get enableRightClick() : Boolean
      {
         return this._enableRightClick;
      }
      
      private function sortByDataIndex(cItem1:ListItemRendererBase8, cItem2:ListItemRendererBase8) : int
      {
         return cItem1.dataIndex - cItem2.dataIndex;
      }
      
      private function sortByRollAxis(cItem1:ListItemRendererBase8, cItem2:ListItemRendererBase8) : int
      {
         return cItem1[this._rollAxis] - cItem2[this._rollAxis];
      }
      
      protected function onMouseWheelHandler(cEvt:MouseEvent) : void
      {
         var tempDelta:Number = NaN;
         if(this._enableScroll == true)
         {
            tempDelta = cEvt.delta;
            if(tempDelta > 0)
            {
               tempDelta = this._wheelSpd;
            }
            else
            {
               tempDelta = -this._wheelSpd;
            }
            this.rollByOffset(tempDelta);
         }
      }
      
      private function onMouseDownHandle(cEvt:MouseEvent) : void
      {
         this._mouseDownPos = mouseY;
         if(this._rollAxis == "x")
         {
            this._mouseDownPos = mouseX;
         }
         addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMoveHandle);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUpHandle);
      }
      
      private function onMouseMoveHandle(cEvt:MouseEvent) : void
      {
         var currentMousePos:int = 0;
         var tempOffset:Number = NaN;
         if(this._enableScroll == true)
         {
            currentMousePos = mouseY;
            if(this._rollAxis == "x")
            {
               currentMousePos = mouseX;
            }
            if(currentMousePos > this._area[this._rollSize])
            {
               currentMousePos = int(this._area[this._rollSize]);
            }
            else if(currentMousePos < this._area[this._rollAxis])
            {
               currentMousePos = int(this._area[this._rollAxis]);
            }
            tempOffset = currentMousePos - this._mouseDownPos;
            this._mouseDownPos = currentMousePos;
            this.rollByOffset(tempOffset);
         }
      }
      
      private function onMouseUpHandle(cEvt:MouseEvent) : void
      {
         cEvt.stopPropagation();
         removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMoveHandle);
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUpHandle);
      }
      
      private function tryRollBack() : void
      {
         var tempFirstDataLine:ListItemRendererBase8 = this.getFirstDataLineItemRenderer();
         var tempLastDataLine:ListItemRendererBase8 = this.getLastDataLineItemRenderer();
         if(tempFirstDataLine != null && tempFirstDataLine[this._rollAxis] >= 0)
         {
            this._offSetTarget = -tempFirstDataLine[this._rollAxis];
            this.rollByOffset(this._offSetTarget,false);
            this._offSetTarget = 0;
         }
         else if(tempLastDataLine != null && tempLastDataLine[this._rollAxis] + tempLastDataLine[this._rollSize] <= this._area[this._rollSize])
         {
            this._offSetTarget = this._area[this._rollSize] - (tempLastDataLine[this._rollAxis] + tempLastDataLine[this._rollSize]);
            this.rollByOffset(this._offSetTarget,false);
            this._offSetTarget = 0;
         }
      }
      
      private function initLineEvt(cTargetLineItemRenderer:ListItemRendererBase8) : void
      {
         cTargetLineItemRenderer.addEventListener(BaseButton.EVT_CLICK,this.onLineEvtHandle,false,0,true);
         cTargetLineItemRenderer.addEventListener(BaseButton.EVT_RIGHT_CLICK,this.onLineEvtHandle,false,0,true);
         cTargetLineItemRenderer.addEventListener(BaseButton.EVT_DOUBLE_CLICK,this.onLineEvtHandle,false,0,true);
         cTargetLineItemRenderer.addEventListener(BaseButton.EVT_MOUSE_OVER,this.onLineEvtHandle,false,0,true);
         cTargetLineItemRenderer.addEventListener(BaseButton.EVT_MOUSE_OUT,this.onLineEvtHandle,false,0,true);
      }
      
      protected function onLineEvtHandle(cEvt:ParaEvent) : void
      {
         var type:String = null;
         var renderer:ListItemRendererBase8 = cEvt.currentTarget as ListItemRendererBase8;
         var rendererIndex:int = renderer.dataIndex;
         switch(cEvt.type)
         {
            case BaseButton.EVT_CLICK:
               this.selectedDataIndex = rendererIndex;
               type = EVT_LINE_CLICK;
               break;
            case BaseButton.EVT_RIGHT_CLICK:
               if(this._enableRightClick == true)
               {
                  this.selectedDataIndex = rendererIndex;
                  type = EVT_LINE_RIGHT_CLICK;
               }
               break;
            case BaseButton.EVT_MOUSE_OVER:
               this.focusDataIndex = rendererIndex;
               type = EVT_LINE_ROLLOVER;
               break;
            case BaseButton.EVT_MOUSE_OUT:
               this.focusDataIndex = -1;
               type = EVT_LINE_ROLLOUT;
               break;
            case BaseButton.EVT_DOUBLE_CLICK:
               this.selectedDataIndex = rendererIndex;
               type = EVT_LINE_DOUBLE_CLICK;
         }
         if(type != "" && type != null && renderer != null)
         {
            dispatchEvent(new ParaEvent(type,{"targetLine":renderer}));
         }
      }
      
      protected function tryRoll(cTween:Boolean = true) : void
      {
         if(this._rollTweenInterval == -1)
         {
            clearInterval(this._rollTweenInterval);
            this._rollTweenInterval = -1;
            if(cTween == true)
            {
               this._rollTweenInterval = setInterval(this.rollLineContainer,this._rollIntervalPerKeyFrame);
            }
            else
            {
               while(true)
               {
                  if(this.rollLineContainer() == false)
                  {
                     break;
                  }
               }
            }
         }
      }
      
      protected function rollLineContainer() : Boolean
      {
         var resultContinueRoll:Boolean = true;
         var tempTargetDataIndexLineItem:ListItemRendererBase8 = this.getItemRendererByDataIndex(this._rollTargetDataIndex);
         var tempFirstInAreaLineItem:ListItemRendererBase8 = this.getFirstInAreaLineItemRenderer(true,true);
         var tempLastInAreaLineItem:ListItemRendererBase8 = this.getLastInAreaLineItemRenderer();
         if(tempFirstInAreaLineItem != null && tempLastInAreaLineItem != null)
         {
            if(tempTargetDataIndexLineItem != null && tempTargetDataIndexLineItem[this._rollAxis] == 0 || this._rollTargetDataIndex >= tempFirstInAreaLineItem.dataIndex && tempLastInAreaLineItem.dataIndex == this._dataProvider.length - 1)
            {
               clearInterval(this._rollTweenInterval);
               this._rollTweenInterval = -1;
               this._rollTargetDataIndex = -1;
               resultContinueRoll = false;
            }
            else if(this._rollTargetDataIndex > tempFirstInAreaLineItem.dataIndex)
            {
               this.rollByOffset(-(tempFirstInAreaLineItem[this._rollSize] + tempFirstInAreaLineItem[this._rollAxis]));
            }
            else
            {
               this.rollByOffset(tempFirstInAreaLineItem[this._rollSize]);
            }
         }
         else
         {
            resultContinueRoll = false;
         }
         return resultContinueRoll;
      }
      
      protected function onScrollBarHandle(cEvt:Event) : void
      {
         this.followScrollBar();
      }
      
      protected function followScrollBar() : void
      {
         this.rollToTargetPos(-this.totalRollSize * this.myScrollBar.targetPosition);
      }
      
      protected function refreshScrollbar() : void
      {
         if(this.myScrollBar != null)
         {
            this.myScrollBar.position = -this._currentPos / this.totalRollSize;
         }
      }
      
      protected function detectDataLength() : void
      {
         if(this.myNoDataLabel != null)
         {
            if(this._dataProvider == null || this._dataProvider.length == 0)
            {
               this.myNoDataLabel.visible = true;
            }
            else
            {
               this.myNoDataLabel.visible = false;
            }
         }
      }
      
      public function autoHideScrollBarBg(value:Boolean) : void
      {
         this.myScrollBar.autoHideBg = value;
      }
   }
}

