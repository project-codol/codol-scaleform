package codo.component
{
   import codo.component.core.UIInteractiveComponent;
   import codo.component.factory.GlobalFactory;
   import codo.component.filter.FilterOption;
   import codo.constants.SE_ID;
   import codo.cpp.IUiCppList;
   import codo.cpp.IUiCppListMutable;
   import codo.cpp.UiCpp;
   import codo.cpp.UiCppList;
   import codo.event.ParaEvent;
   import codo.objects.ScrollListSettings;
   import codo.style.GlobalGuide;
   import com.greensock.TimelineLite;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import fsg.util.FsgAudioUtil;
   
   public class ComboBox extends UIInteractiveComponent implements IUiCppList, IUiCppListMutable
   {
      
      public static const EVT_CHANGE:String = "evt_change";
      
      private static const UP_STATE_FRAME:int = 1;
      
      private static const OVER_STATE_FRAME:int = 2;
      
      private static const DOWN_STATE_FRAME:int = 3;
      
      private static const DISABLED_STATE_FRAME:int = 4;
      
      private static const BACKGROUND_COLOR:Number = 2303784;
      
      private static const BACKGROUND_ALPHA:Number = 0.8;
      
      private static const BLUE_HIGHLIGHT_OFFSET_Y:Number = 5;
      
      private static const BLUE_HIGHLIGHT_WIDTH:Number = 54;
      
      private static const BLUE_HIGHLIGHT_HEIGHT:Number = 4;
      
      private static const SLIDE_DURATION:Number = 0.1;
      
      private static const HIGHLIGHT_SCALE_DURATION:Number = 0.1;
      
      private static const BACKGROUND_GROW_DURATION:Number = 0.2;
      
      private static const DEFAULT_LIST_WIDTH:Number = 240;
      
      private static const DEFAULT_LIST_HEIGHT:Number = 300;
      
      private static const LIST_MARGIN_X:Number = 10;
      
      private static const MASK_MARGIN:Number = 20;
      
      private static const SCROLL_MARGIN:Number = 20;
      
      private static const HIGHLIGHT_GLOW_OFFSET_X:Number = 22;
      
      private static const HIGHLIGHT_GLOW_OFFSET_Y:Number = 16;
      
      private static const HIGHLIGHT_GLOW_FOCUS_ALPHA:Number = 0.5;
      
      public var myScrollList:ScrollList;
      
      public var myMask:MovieClip;
      
      public var myBackground:MovieClip;
      
      public var myListBackground:MovieClip;
      
      public var myArrow:MovieClip;
      
      public var myBlueHighlight:Sprite;
      
      public var myGlow:Sprite;
      
      public var myHighlightGlow:Sprite;
      
      public var myLabel:TextField;
      
      private var mToggled:Boolean = false;
      
      private var mClearOnSelect:Boolean = false;
      
      private var mSelectedIndex:int;
      
      private var mDataProvider:Array;
      
      private var mTextFocusColor:Number = 16777215;
      
      private var mTextUnfocusColor:Number = 16777215;
      
      private var mTextClickColor:Number = 16777215;
      
      private var mWidth:Number;
      
      private var mHeight:Number;
      
      private var mListWidth:Number;
      
      private var mListHeight:Number;
      
      private var mToggleAnimTimeline:TimelineLite;
      
      private var mSingleOptionMode:Boolean = false;
      
      private var mShowSelectionInHeader:Boolean;
      
      private var mAllowScrolling:Boolean;
      
      private var mScrollHeight:Number;
      
      private var mScrollListFullHeight:Number;
      
      private var mClickedOffCallback:Function;
      
      private var mEntryEnabledCallback:Function;
      
      private var mPreserveIndex:Boolean;
      
      protected var _uiCpp:UiCppList;
      
      public function ComboBox()
      {
         super();
         isInteractiveEnabled = true;
         this.myLabel.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         this.myLabel.fontColor = this.mTextUnfocusColor;
         this.myLabel.y = 5;
         var listSettings:ScrollListSettings = new ScrollListSettings();
         listSettings.orientation = ScrollListSettings.SCROLL_VERTICAL;
         listSettings.useNavArrows = false;
         listSettings.autoSize = false;
         listSettings.autoSizeItems = true;
         this.myScrollList.settings = listSettings;
         this.myListBackground.alpha = 0;
         this.myListBackground.height = 10;
         this.myBlueHighlight.width = 0;
         this.myScrollList.alpha = 0;
         this.myGlow.alpha = 0;
         this.myHighlightGlow.alpha = 0;
         this.setListVisibility(false);
         this.mListWidth = DEFAULT_LIST_WIDTH;
         this.mListHeight = DEFAULT_LIST_HEIGHT;
         this.mAllowScrolling = false;
         this.mScrollHeight = 0;
         this.mScrollListFullHeight = 0;
         this.width = myHitArea.width;
         this.height = 30;
         this.myBackground.gotoAndStop(UP_STATE_FRAME);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      public function makeUiCpp() : void
      {
         this._uiCpp = new UiCppList(this);
      }
      
      public function getUiCpp() : UiCppList
      {
         return this._uiCpp;
      }
      
      public function set preserveIndex(val:Boolean) : void
      {
         this.mPreserveIndex = val;
      }
      
      public function set singleOptionMode(b:Boolean) : void
      {
         this.mSingleOptionMode = b;
      }
      
      public function get label() : String
      {
         return this.myLabel.text;
      }
      
      public function set label(cText:String) : void
      {
         this.myLabel.text = cText.toUpperCase();
      }
      
      public function get selectedIndex() : int
      {
         return this.mSelectedIndex;
      }
      
      public function set selectedIndex(cIndex:int) : void
      {
         this.mSelectedIndex = cIndex;
         this.onSelectedIndexChanged();
      }
      
      public function set showSelectionInHeader(val:Boolean) : void
      {
         this.mShowSelectionInHeader = val;
      }
      
      public function get clearOnSelect() : Boolean
      {
         return this.mClearOnSelect;
      }
      
      public function set clearOnSelect(s:Boolean) : void
      {
         this.mClearOnSelect = s;
      }
      
      public function get selectedData() : *
      {
         if(this.mSelectedIndex < this.mDataProvider.length)
         {
            return this.mDataProvider[this.mSelectedIndex];
         }
         return null;
      }
      
      public function get dataProvider() : Array
      {
         return this.mDataProvider;
      }
      
      public function set dataProvider(value:Array) : void
      {
         var itemData:Object = null;
         var item:UIInteractiveComponent = null;
         this.mDataProvider = value;
         var array:Array = this.mDataProvider;
         var len:int = int(array.length);
         var newIndex:uint = this.mPreserveIndex && this.mSelectedIndex < len ? uint(this.mSelectedIndex) : 0;
         this.myScrollList.resetList();
         this.mScrollListFullHeight = 0;
         for(var i:int = 0; i < len; i++)
         {
            itemData = array[i];
            if(true == this.mClearOnSelect)
            {
               itemData.checked = false;
            }
            else
            {
               itemData.checked = i == newIndex;
            }
            itemData.index = i;
            if(false == this.mSingleOptionMode)
            {
               item = this.addCheckBox(itemData);
            }
            else
            {
               item = this.addSingleOption(itemData);
            }
            this.mScrollListFullHeight += item.height + GlobalGuide.COMPONENT_PADDING;
         }
         this.setListVisibility(this.myScrollList.visible);
         this.mScrollListFullHeight += GlobalGuide.COMPONENT_PADDING;
         this.refreshScrollListHeight();
         this.myScrollList.width = this.mListWidth;
         this.myScrollList.refreshVisuals();
         this.draw();
      }
      
      public function get toggled() : Boolean
      {
         return this.mToggled;
      }
      
      public function set toggled(toggled:Boolean) : void
      {
         var len:int = 0;
         var option:FilterOption = null;
         var i:int = 0;
         if(toggled == this.mToggled)
         {
            return;
         }
         this.mToggled = toggled;
         if(null == this.mToggleAnimTimeline)
         {
            this.mToggleAnimTimeline = new TimelineLite();
         }
         else
         {
            this.mToggleAnimTimeline.killTweensOf(this.myScrollList);
            this.mToggleAnimTimeline.killTweensOf(this.myListBackground);
            this.mToggleAnimTimeline.killTweensOf(this.myBlueHighlight);
            this.mToggleAnimTimeline.killTweensOf(this.myGlow);
            this.mToggleAnimTimeline.killTweensOf(this.myHighlightGlow);
            this.mToggleAnimTimeline = new TimelineLite();
         }
         if(true == this.mToggled)
         {
            this.setListVisibility(true);
            this.mToggleAnimTimeline.append(new TweenLite(this.myBlueHighlight,HIGHLIGHT_SCALE_DURATION,{"width":BLUE_HIGHLIGHT_WIDTH}));
            this.mToggleAnimTimeline.append(new TweenLite(this.myHighlightGlow,SLIDE_DURATION,{"alpha":HIGHLIGHT_GLOW_FOCUS_ALPHA}));
            this.mToggleAnimTimeline.append(new TweenLite(this.myListBackground,BACKGROUND_GROW_DURATION,{
               "height":this.mListHeight,
               "alpha":1
            }));
            this.mToggleAnimTimeline.append(new TweenLite(this.myScrollList,SLIDE_DURATION,{"alpha":1}));
            this.mToggleAnimTimeline.append(new TweenLite(this.myGlow,SLIDE_DURATION,{"alpha":1}));
            stage.addEventListener(MouseEvent.CLICK,this.onStageClickHandle);
         }
         else
         {
            this.mToggleAnimTimeline.append(new TweenLite(this.myGlow,SLIDE_DURATION,{"alpha":0}));
            this.mToggleAnimTimeline.append(new TweenLite(this.myScrollList,SLIDE_DURATION,{"alpha":0}));
            this.mToggleAnimTimeline.append(new TweenLite(this.myListBackground,BACKGROUND_GROW_DURATION,{
               "height":10,
               "alpha":0
            }));
            this.mToggleAnimTimeline.append(new TweenLite(this.myHighlightGlow,SLIDE_DURATION,{"alpha":0}));
            this.mToggleAnimTimeline.append(new TweenLite(this.myBlueHighlight,HIGHLIGHT_SCALE_DURATION,{
               "width":0,
               "onComplete":this.setListVisibility
            }));
            if(this.stage != null)
            {
               stage.removeEventListener(MouseEvent.CLICK,this.onStageClickHandle);
            }
            if(true == this.mClearOnSelect)
            {
               len = this.myScrollList.numberOfItems;
               for(i = 0; i < len; i++)
               {
                  option = this.myScrollList.getItem(i) as FilterOption;
                  option.checked = false;
               }
            }
         }
         this.mToggleAnimTimeline.play();
      }
      
      public function getOptionById(id:int) : UIInteractiveComponent
      {
         return this.myScrollList.getItem(id);
      }
      
      public function set clickedOffCallback(callback:Function) : void
      {
         this.mClickedOffCallback = callback;
      }
      
      public function set entryEnabledCallback(callback:Function) : void
      {
         this.mEntryEnabledCallback = callback;
      }
      
      private function onStageClickHandle(cEvt:MouseEvent) : void
      {
         if(myHitArea.hitTestPoint(stage.mouseX,stage.mouseY,true) == false)
         {
            if(this.myListBackground.hitTestPoint(stage.mouseX,stage.mouseY) == false)
            {
               this.closeList();
               if(this.mClickedOffCallback != null)
               {
                  this.mClickedOffCallback();
               }
            }
         }
      }
      
      private function addCheckBox(data:Object) : UIInteractiveComponent
      {
         data.canUnselectClick = false;
         var item:CheckBox = this.myScrollList.addItem(data,GlobalFactory.CHECKBOX_LINKAGE) as CheckBox;
         item.addCheckedCallback(this.onItemChecked,item);
         return item;
      }
      
      private function addSingleOption(data:Object) : UIInteractiveComponent
      {
         var item:FilterOption = this.myScrollList.addItem(data,GlobalFactory.FILTER_OPTION_LINKAGE) as FilterOption;
         item.highlightBackground = true;
         item.width = this.mListWidth;
         if(data.label != null)
         {
            item.label = data.label;
         }
         if(data.name != null)
         {
            item.label = data.name;
         }
         item.index = data.index;
         item.checked = null != data.checked ? Boolean(data.checked) : false;
         item.allowReselect = this.mClearOnSelect;
         item.enabled = null != data.enabled ? Boolean(data.enabled) : true;
         item.addCheckedCallback(this.onOptionSelected,item);
         if(this.mShowSelectionInHeader && item.checked)
         {
            this.label = item.label;
         }
         return item;
      }
      
      override public function set width(w:Number) : void
      {
         this.mWidth = w;
         this.draw();
      }
      
      override public function get width() : Number
      {
         return this.mWidth;
      }
      
      override public function set height(h:Number) : void
      {
         this.mHeight = h;
         this.draw();
      }
      
      public function set listWidth(w:Number) : void
      {
         this.mListWidth = w;
         this.draw();
      }
      
      public function set listHeight(h:Number) : void
      {
         this.mListHeight = h;
         this.draw();
      }
      
      public function set allowScrolling(allow:Boolean) : void
      {
         this.mAllowScrolling = allow;
         this.refreshScrollListHeight();
         this.draw();
      }
      
      public function set scrollListHeight(h:Number) : void
      {
         this.mScrollHeight = h;
         this.refreshScrollListHeight();
         this.draw();
      }
      
      private function onOptionSelected(box:FilterOption) : void
      {
         var option:FilterOption = null;
         var len:int = 0;
         var i:int = 0;
         var newIndex:int = int(box.getData().index);
         if(newIndex != this.selectedIndex || true == this.mClearOnSelect)
         {
            this.selectedIndex = newIndex;
            FsgAudioUtil.getInstance().playSound(SE_ID.UI_MENU_ROLLOUT_PROCEED);
         }
         else
         {
            box.checked = true;
         }
         if(true == this.mSingleOptionMode && false == this.mClearOnSelect)
         {
            len = this.myScrollList.numberOfItems;
            for(i = 0; i < len; i++)
            {
               option = this.myScrollList.getItem(i) as FilterOption;
               if(option.index != newIndex)
               {
                  option.checked = false;
               }
            }
         }
         if(this.mShowSelectionInHeader)
         {
            this.label = box.label;
         }
         this.closeList();
      }
      
      private function onItemChecked(box:CheckBox) : void
      {
         var newIndex:int = int(box.getData().index);
         if(newIndex != this.selectedIndex)
         {
            this.selectedIndex = newIndex;
            FsgAudioUtil.getInstance().playSound(SE_ID.UI_MENU_ROLLOUT_PROCEED);
         }
         else
         {
            box.checked = true;
         }
         this.closeList();
      }
      
      private function onRemovedFromStage(evt:Event) : void
      {
         this.closeList();
      }
      
      private function closeList() : void
      {
         this.myBackground.gotoAndStop(UP_STATE_FRAME);
         this.myArrow.gotoAndStop(UP_STATE_FRAME);
         this.myLabel.fontColor = this.mTextUnfocusColor;
         this.toggled = false;
      }
      
      private function onSelectedIndexChanged() : void
      {
         var option:FilterOption = null;
         var i:int = 0;
         var checkBox:CheckBox = null;
         var x:int = 0;
         var len:int = this.myScrollList.numberOfItems;
         if(true == this.mSingleOptionMode)
         {
            for(i = 0; i < len; i++)
            {
               option = this.myScrollList.getItem(i) as FilterOption;
               option.checked = i == this.mSelectedIndex && !this.mClearOnSelect;
            }
         }
         else
         {
            for(x = 0; x < len; x++)
            {
               checkBox = this.myScrollList.getItem(x) as CheckBox;
               checkBox.checked = x == this.mSelectedIndex;
            }
         }
         dispatchEvent(new ParaEvent(EVT_CHANGE,this));
      }
      
      private function setListVisibility(show:Boolean = false) : void
      {
         this.myScrollList.visible = show;
         this.myListBackground.visible = show;
         this.myGlow.visible = show;
         this.myHighlightGlow.visible = show;
         this.myBlueHighlight.visible = show;
         this.myMask.visible = show;
      }
      
      override protected function onMouseOver() : void
      {
         super.onMouseOver();
         if(false == this.mToggled)
         {
            this.myBackground.gotoAndStop(OVER_STATE_FRAME);
            this.myArrow.gotoAndStop(OVER_STATE_FRAME);
            this.myLabel.fontColor = this.mTextFocusColor;
         }
      }
      
      override protected function onMouseOut() : void
      {
         super.onMouseOut();
         if(false == this.mToggled)
         {
            this.myBackground.gotoAndStop(UP_STATE_FRAME);
            this.myArrow.gotoAndStop(UP_STATE_FRAME);
            this.myLabel.fontColor = this.mTextUnfocusColor;
         }
      }
      
      override protected function onMouseClick() : void
      {
         super.onMouseClick();
         if(myHitArea.hitTestPoint(stage.mouseX,stage.mouseY,true) == true)
         {
            this.myBackground.gotoAndStop(DOWN_STATE_FRAME);
            this.myArrow.gotoAndStop(DOWN_STATE_FRAME);
            this.myLabel.fontColor = this.mTextClickColor;
            this.toggled = !this.mToggled;
         }
      }
      
      override protected function onMouseClickUp() : void
      {
         if(false == this.mToggled)
         {
            if(myHitArea.hitTestPoint(stage.mouseX,stage.mouseY,true) == false)
            {
               this.myBackground.gotoAndStop(UP_STATE_FRAME);
               this.myArrow.gotoAndStop(UP_STATE_FRAME);
               this.myLabel.fontColor = this.mTextUnfocusColor;
            }
            else
            {
               this.myArrow.gotoAndStop(OVER_STATE_FRAME);
               this.myBackground.gotoAndStop(OVER_STATE_FRAME);
               this.myLabel.fontColor = this.mTextFocusColor;
            }
         }
      }
      
      private function draw() : void
      {
         var halfWidth:Number = this.mWidth * 0.5;
         this.myBlueHighlight.x = halfWidth - BLUE_HIGHLIGHT_WIDTH * 0.5;
         this.myBlueHighlight.y = this.mHeight + BLUE_HIGHLIGHT_OFFSET_Y;
         this.myListBackground.width = this.mListWidth + MASK_MARGIN;
         this.myListBackground.height = this.mListHeight;
         this.myListBackground.x = halfWidth - (this.mListWidth + MASK_MARGIN) * 0.5;
         this.myListBackground.y = this.myBlueHighlight.y + BLUE_HIGHLIGHT_HEIGHT;
         myHitArea.width = this.mWidth + 2;
         myHitArea.height = this.mHeight + 2;
         this.myLabel.width = this.mWidth - this.myArrow.width;
         this.myLabel.height = 22;
         this.myArrow.y = this.mHeight * 0.5 - this.myArrow.height * 0.5;
         this.myBackground.width = this.mWidth;
         this.myBackground.height = this.mHeight;
         this.myHighlightGlow.x = this.myBlueHighlight.x - HIGHLIGHT_GLOW_OFFSET_X;
         this.myHighlightGlow.y = this.myBlueHighlight.y - HIGHLIGHT_GLOW_OFFSET_Y;
         this.myMask.width = this.myListBackground.width;
         this.myMask.height = this.mListHeight + MASK_MARGIN;
         this.myMask.x = this.myListBackground.x - MASK_MARGIN * 0.5;
         this.myMask.y = this.mHeight;
         this.myScrollList.x = this.myListBackground.x + LIST_MARGIN_X;
         this.myScrollList.y = this.myListBackground.y + MASK_MARGIN * 0.5;
         this.myGlow.width = this.myListBackground.width;
         this.myGlow.x = this.myListBackground.x;
         this.myGlow.y = this.myListBackground.y;
      }
      
      private function refreshScrollListHeight() : void
      {
         if(this.mAllowScrolling && this.mScrollHeight > 0 && this.mScrollListFullHeight > this.mScrollHeight)
         {
            this.mListHeight = this.mScrollHeight + SCROLL_MARGIN;
            this.myScrollList.height = this.mScrollHeight;
         }
         else
         {
            this.mListHeight = this.mScrollListFullHeight;
            this.myScrollList.height = this.mScrollListFullHeight;
         }
      }
      
      public function uiCppGetListData() : Array
      {
         return this.dataProvider;
      }
      
      public function uiCppGetSelectedIndex() : int
      {
         return this.selectedIndex;
      }
      
      public function uiCppInitClickEvent(uiCpp:UiCpp, func:String) : void
      {
         addEventListener(ComboBox.EVT_CHANGE,function(evt:ParaEvent):void
         {
            uiCpp[func]();
         });
      }
      
      public function uiCppSetListData(data:Array) : void
      {
         this.dataProvider = data;
      }
      
      public function uiCppSelectIndex(index:int) : void
      {
         this.selectedIndex = index;
      }
      
      public function updateEntriesEnabled() : void
      {
         var i:int = 0;
         var option:FilterOption = null;
         if(this.mEntryEnabledCallback == null)
         {
            return;
         }
         var len:int = this.myScrollList.numberOfItems;
         for(i = 0; i < this.myScrollList.numberOfItems; i++)
         {
            option = this.myScrollList.getItem(i) as FilterOption;
            option.enabled = this.mEntryEnabledCallback(this,option.getData());
         }
         var selectedOption:FilterOption = this.myScrollList.getItem(this.selectedIndex) as FilterOption;
         if(!selectedOption.enabled)
         {
            for(i = this.selectedIndex; i >= 0; i--)
            {
               option = this.myScrollList.getItem(i) as FilterOption;
               if(option.enabled)
               {
                  this.onOptionSelected(option);
                  return;
               }
            }
            for(i = this.selectedIndex; i < this.myScrollList.numberOfItems; i++)
            {
               option = this.myScrollList.getItem(i) as FilterOption;
               if(option.enabled)
               {
                  this.onOptionSelected(option);
                  return;
               }
            }
         }
      }
   }
}

