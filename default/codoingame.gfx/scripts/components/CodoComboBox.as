package components
{
   import codo.constants.TweenParam;
   import codo.event.ParaEvent;
   import com.greensock.TweenLite;
   import components.combobox_part.ComboBoxBtn;
   import components.list_part.ListItemRendererBase;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class CodoComboBox extends CodoList874
   {
      
      private static const COLOR_LABEL:Array = [3309198,9583135];
      
      private static const DIRECTION_UP:String = "direction_up";
      
      private static const DIRECTION_DOWN:String = "direction_down";
      
      public static const EVT_CHANGE:String = "evt_change";
      
      public static const EVT_ITEM_OVER:String = "evt_item_over";
      
      public static const EVT_ITEM_OUT:String = "evt_item_out";
      
      public static const EVT_PRE_OPEN:String = "evt_pre_open";
      
      public static const EVT_OPEN:String = "evt_open";
      
      public static const EVT_CLOSE:String = "evt_close";
      
      public static const EVT_BTN_OVER:String = "evt_btn_over";
      
      public var myLabelTF:TextField;
      
      public var myBtn:ComboBoxBtn;
      
      private var _spaceLineToLine:int = 0;
      
      private var _spaceLineToBtn:int = 0;
      
      private var _spaceBgToBtn:int = 0;
      
      private var _spaceBgToLine:int = 0;
      
      protected var _currentSelectedIndex:int = -1;
      
      protected var _currentFocusIndex:int = -1;
      
      protected var _currentSelectedItemRenderer:ListItemRendererBase;
      
      protected var _currentFocusItemRenderer:ListItemRendererBase;
      
      private var _itemDirection:String = "direction_down";
      
      private var _opened:Boolean = false;
      
      private var _wheelEnable:Boolean = true;
      
      private var _enabled:Boolean = true;
      
      private var _scrollOffsetY:int = 0;
      
      private var _isCustomIptValue:Boolean = false;
      
      private var _currentTextFont:String;
      
      private var _originalContainerY:Number;
      
      public function CodoComboBox()
      {
         super();
      }
      
      override protected function onInit() : void
      {
         this.mouseEnabled = this.mouseChildren = true;
         if(this.myBtn.y > this.myItemRenderer.y)
         {
            this._spaceLineToBtn = this.myBtn.y - this.myItemRenderer.y - this.myItemRenderer.height;
         }
         else
         {
            this._spaceLineToBtn = this.myItemRenderer.y - this.myBtn.y - this.myBtn.height;
         }
         if(this.myBg != null)
         {
            this._spaceBgToBtn = this.myBg.y - (this.myBtn.y + this.myBtn.height);
            this._spaceBgToLine = this.myItemRenderer.y - this.myBg.y;
            this.myBg.visible = false;
         }
         if(this.myScrollBar != null)
         {
            this.myScrollBar.height = 88;
         }
         super.onInit();
         this._originalContainerY = this._lineContainer.y;
         if(this.myScrollBar != null)
         {
            this.myScrollBar.height = 305;
         }
         this._lineContainer.visible = false;
         if(this.myScrollBar != null)
         {
            this.myScrollBar.visible = false;
         }
         if(this.myLabelTF != null)
         {
            this.myLabelTF.mouseEnabled = false;
         }
         if(this.myHitarea != null)
         {
            this.myHitarea.visible = false;
         }
         this.myHitarea.height = 1;
         this.onStyleChangeForMatchType();
      }
      
      override protected function onInitListener() : void
      {
         super.onInitListener();
         if(this.myBg != null)
         {
            this.myBg.addEventListener(MouseEvent.CLICK,function(cEvt:Event):void
            {
            });
         }
         this.myBtn.addEventListener(BaseButton.EVT_CLICK,this.onBtnClickHandle);
         this.myBtn.addEventListener(ComboBoxBtn.EVT_IPT_CHANGED,this.onCustomIptChangedHandle);
         this.myBtn.addEventListener(BaseButton.EVT_MOUSE_OVER,this.onBtnOverHandle);
      }
      
      public function set label(cStr:String) : void
      {
         if(this.myLabelTF != null)
         {
            this.myLabelTF.text = cStr;
         }
      }
      
      public function set textFont(cFont:String) : void
      {
         var tempLineTF:TextFormat = null;
         var i:uint = 0;
         this._currentTextFont = cFont;
         var tempTF:TextFormat = this.myBtn.myLabel.getTextFormat();
         tempTF.font = this._currentTextFont;
         this.myBtn.myLabel.defaultTextFormat = tempTF;
         this.myBtn.myLabel.setTextFormat(tempTF);
         if(this.myItemRenderer.myLabelTF != null)
         {
            tempLineTF = this.myItemRenderer.myLabelTF.getTextFormat();
            tempLineTF.font = this._currentTextFont;
            for(i = 0; i < this._lineInstancesVector.length; i++)
            {
               this._lineInstancesVector[i].myLabelTF.defaultTextFormat = tempLineTF;
               this._lineInstancesVector[i].myLabelTF.setTextFormat(tempLineTF);
            }
         }
      }
      
      override public function set dataProvider(cDP:Array) : void
      {
         var tempOldSelectedValue:Object = this.selectedValue;
         super.dataProvider = cDP;
         this.refreshLayout(tempOldSelectedValue == null || this.selectedValue != tempOldSelectedValue);
      }
      
      private function refreshLayout(autoSelect:Boolean = true) : void
      {
         if(this.totalLineSize < this._area.height)
         {
            this.myBg.height = this.totalLineSize + 2 * this._spaceBgToLine;
         }
         else
         {
            this.myBg.height = this._area.height + 2 * this._spaceBgToLine;
         }
         if(this.myScrollBar != null)
         {
            this.myScrollBar.height = this.myBg.height - 5;
            this.myScrollBar.y = this._lineContainer.y;
         }
         if(this._itemDirection == DIRECTION_DOWN)
         {
            this._lineContainer.y = this._originalContainerY;
            if(this.lineContainerMask != null)
            {
               this.lineContainerMask.y = this._lineContainer.y;
            }
            this.myBg.y = this.myBtn.y + this.myBtn.height + this._spaceBgToBtn;
         }
         else
         {
            this._lineContainer.y = this.myBtn.y - this.myBg.height + 3;
            this.myBg.y = this.myBtn.y - this.myBg.height + this._spaceBgToBtn + 5;
            this.lineContainerMask.y = this._lineContainer.y;
         }
         if(this.myScrollBar != null)
         {
            this.myScrollBar.y = this._lineContainer.y;
         }
         if(this.dataProvider.length > 0 && autoSelect == true)
         {
            this.selectedDataIndex = 0;
         }
         this.setChildIndex(this.myBtn,this.numChildren - 1);
         if(this.myLabelTF != null)
         {
            this.setChildIndex(this.myLabelTF,this.numChildren - 1);
         }
      }
      
      public function set inputAble(cSwi:Boolean) : void
      {
         this.myBtn.inputAble = cSwi;
      }
      
      public function get inputAble() : Boolean
      {
         return this.myBtn.inputAble;
      }
      
      public function set customLabel(cLabel:String) : void
      {
         if(this.myBtn.inputAble == true)
         {
            this._isCustomIptValue = true;
            this.myBtn.myLabel.text = cLabel;
         }
      }
      
      public function get customLabel() : String
      {
         return this.myBtn.myLabel.text;
      }
      
      public function get isCustomIptValue() : Boolean
      {
         return this._isCustomIptValue;
      }
      
      [Inspectable(type="Boolean",defaultValue="true")]
      public function set dropDown(cSwi:Boolean) : void
      {
         if(cSwi == true)
         {
            this._itemDirection = DIRECTION_DOWN;
         }
         else
         {
            this._itemDirection = DIRECTION_UP;
         }
      }
      
      public function setDropDownAtRuntime(cSwi:Boolean) : void
      {
         if(cSwi == true)
         {
            this._itemDirection = DIRECTION_DOWN;
         }
         else
         {
            this._itemDirection = DIRECTION_UP;
         }
         this.refreshLayout(false);
      }
      
      override public function get selectedValue() : *
      {
         var tempResult:* = null;
         if(this._isCustomIptValue == true)
         {
            tempResult = this.myBtn.myLabel.text;
         }
         else if(this._currentSelectedDataIndex >= 0 || this._currentSelectedDataIndex < this._dataProvider.length)
         {
            tempResult = this._dataProvider[this._currentSelectedDataIndex];
         }
         return tempResult;
      }
      
      override public function set selectedDataIndex(cIndex:int) : void
      {
         super.selectedDataIndex = cIndex;
         if(cIndex < 0)
         {
            this.myBtn.data = "";
         }
         else if(this._dataProvider != null)
         {
            this.myBtn.data = this._dataProvider[cIndex];
         }
         if(cIndex >= 0)
         {
            this.dispatchEvent(new ParaEvent(EVT_CHANGE));
         }
      }
      
      override public function set enabled(cSwi:Boolean) : void
      {
         this._enabled = cSwi;
         if(cSwi == true)
         {
            this.alpha = 1;
            this.myBtn.enable = true;
         }
         else
         {
            this.alpha = 0.3;
            this.myBtn.enable = false;
         }
      }
      
      override public function get enabled() : Boolean
      {
         return this._enabled;
      }
      
      public function open() : void
      {
         var targetBgHeight:Number = NaN;
         var targetBgY:Number = NaN;
         var targetY:Number = NaN;
         this._opened = true;
         this._lineContainer.visible = true;
         if(this.myScrollBar != null)
         {
            this.myScrollBar.visible = this.myScrollBar.itemAmount > 0;
         }
         if(this.myBg != null)
         {
            this.myBg.visible = true;
         }
         if(this.myHitarea != null)
         {
            this.myHitarea.visible = true;
         }
         this.removeAllListener();
         if(this.myBg != null)
         {
            TweenLite.killTweensOf(this.myBg,true);
            targetBgHeight = this.myBg.height;
            targetBgY = this.myBg.y;
            if(this._itemDirection == DIRECTION_UP)
            {
               this.myBg.y = targetBgHeight;
            }
            this.myBg.height = 0;
            TweenLite.to(this.myBg,TweenParam.SPD_GENERAL,{
               "height":targetBgHeight,
               "y":targetBgY
            });
         }
         for(var i:uint = 0; i < this._lineInstancesVector.length; i++)
         {
            targetY = this._lineInstancesVector[i].y;
            if(this._itemDirection == DIRECTION_UP)
            {
               this._lineInstancesVector[i].y = targetBgHeight;
            }
            else
            {
               this._lineInstancesVector[i].y = -this._lineInstancesVector[i].height;
            }
            TweenLite.to(this._lineInstancesVector[i],TweenParam.SPD_GENERAL,{
               "y":targetY,
               "onComplete":this.onOpenedHandle
            });
         }
         this.stage.addEventListener(MouseEvent.CLICK,this.onStageClickHandle);
         this.dispatchEvent(new ParaEvent(EVT_OPEN));
      }
      
      private function onOpenedHandle() : void
      {
         this.onInitListener();
      }
      
      public function close() : void
      {
         var targetY:Number = NaN;
         this._opened = false;
         this._lineContainer.visible = false;
         if(this.myScrollBar != null)
         {
            this.myScrollBar.visible = false;
         }
         if(this.myBg != null)
         {
            this.myBg.visible = false;
         }
         if(this.myHitarea != null)
         {
            this.myHitarea.visible = false;
         }
         if(this.stage != null)
         {
            this.stage.removeEventListener(MouseEvent.CLICK,this.onStageClickHandle);
         }
         for(var i:uint = 0; i < this._lineInstancesVector.length; i++)
         {
            targetY = this._lineInstancesVector[i].y;
            TweenLite.killTweensOf(this._lineInstancesVector[i],true);
         }
         this.dispatchEvent(new ParaEvent(EVT_CLOSE));
      }
      
      public function get wheelEnable() : Boolean
      {
         return this._wheelEnable;
      }
      
      public function set wheelEnable(value:Boolean) : void
      {
         this._wheelEnable = value;
      }
      
      override protected function onMouseWheelHandler(cEvt:MouseEvent) : void
      {
         var tempDelta:Number = NaN;
         if(this._wheelEnable == true)
         {
            if(this._opened == true)
            {
               super.onMouseWheelHandler(cEvt);
            }
            else
            {
               tempDelta = cEvt.delta;
               if(tempDelta > 0)
               {
                  this.selectPrev();
               }
               else
               {
                  this.selectNext();
               }
            }
         }
      }
      
      private function onStageClickHandle(cEvt:MouseEvent) : void
      {
         if(this.stage == null || this.myBtn.hitTestPoint(stage.mouseX,stage.mouseY) == false && (this.myScrollBar == null || this.myScrollBar.hitTestPoint(stage.mouseX,stage.mouseY) == false))
         {
            this.close();
         }
      }
      
      private function onBtnClickHandle(cEvt:Event) : void
      {
         if(this._enabled == true)
         {
            if(this._opened == true)
            {
               this.close();
            }
            else if(this._dataProvider != null && this._dataProvider.length > 0)
            {
               dispatchEvent(new ParaEvent(EVT_PRE_OPEN));
               this.open();
            }
         }
      }
      
      protected function onCustomIptChangedHandle(cEvt:ParaEvent) : void
      {
         this._isCustomIptValue = true;
         this.dispatchEvent(new ParaEvent(EVT_CHANGE));
      }
      
      override protected function refresh() : void
      {
         super.refresh();
         if(this._dataProvider.length > 0)
         {
            if(this._currentSelectedDataIndex < 0)
            {
               this._currentSelectedDataIndex = 0;
            }
            this.myBtn.data = this._dataProvider[this._currentSelectedDataIndex];
         }
         else
         {
            this.myBtn.data = "";
         }
         this._isCustomIptValue = false;
         if(this._opened == true && this.myScrollBar != null)
         {
            this.myScrollBar.visible = this.myScrollBar.itemAmount > 0;
         }
      }
      
      private function onBtnOverHandle(cEvt:ParaEvent) : void
      {
         this.dispatchEvent(new ParaEvent(EVT_BTN_OVER));
      }
      
      override public function onStyleChangeForMatchType() : void
      {
         if(this.myBg != null && this.myBg.totalFrames > 1)
         {
            this.myBg.gotoAndStop(this.currentMatchType + 1);
            if(this.myLabelTF != null)
            {
               this.myLabelTF.textColor = COLOR_LABEL[this.currentMatchType];
            }
         }
      }
   }
}

