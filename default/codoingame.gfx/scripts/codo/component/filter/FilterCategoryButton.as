package codo.component.filter
{
   import codo.component.Button;
   import codo.component.CheckBox;
   import codo.component.core.UIInteractiveComponent;
   import codo.component.marketplaceitem.MarketplaceNewTag;
   import codo.cpp.UiCppNewItems;
   import codo.style.ButtonGuide;
   import codo.style.GlobalGuide;
   import codo.utils.Logger;
   import com.greensock.TweenLite;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextFormatAlign;
   import flash.utils.getDefinitionByName;
   
   public class FilterCategoryButton extends Button
   {
      
      private static const LIST_MARGIN:Number = 20;
      
      private static const SLIDE_DURATION:Number = 0.15;
      
      private static const GLOW_FOCUS_ALPHA:Number = 0.33;
      
      private static const TOGGLED_HEIGHT:Number = 54;
      
      private static const UNFOCUS_FRAME:int = 1;
      
      private static const TOGGLED_FRAME:int = 2;
      
      private static const UNTOGGLED_FOCUS_FRAME:int = 3;
      
      public var mySubCategoryMount:Sprite;
      
      public var mySubCategoryMask:Sprite;
      
      public var myTexture:Sprite;
      
      public var myGlow:Sprite;
      
      public var myArrow:MovieClip;
      
      public var myListBackground:Sprite;
      
      public var myFocusLine:Sprite;
      
      public var myNewTag:MarketplaceNewTag;
      
      private var mCheckedCategories:Array;
      
      private var mOnSubCategoryChecked:Function;
      
      private var mOnSubCategoryUnchecked:Function;
      
      private var mSingleOptionMode:Boolean = false;
      
      private var mUseAlternateOptionRowStyles:Boolean = false;
      
      private var mListHeight:Number = 0;
      
      private var mListHeightMax:Number = -1;
      
      private var mBreadcrumbEnabled:Boolean = true;
      
      protected var mItems:Vector.<UIInteractiveComponent>;
      
      protected var mFocusLineEndScaleX:Number = 1;
      
      protected var _data:Array;
      
      public function FilterCategoryButton()
      {
         super();
         myLabel.textStyle = ButtonGuide.styleFilterCategoryButton;
         myLabel.alignment = TextFormatAlign.LEFT;
         myLabel.alpha = 0.5;
         this.mCheckedCategories = new Array();
         this.myGlow.alpha = 0;
         this.myTexture.alpha = 0;
         myBackground.gotoAndStop(UNFOCUS_FRAME);
         this.myArrow.gotoAndStop(UNFOCUS_FRAME);
         mToggled = true;
         this.mFocusLineEndScaleX = this.myFocusLine.scaleX;
         this.myFocusLine.scaleX = 0;
         this.myNewTag.visible = false;
      }
      
      public function set breadcrumbEnabled(enabled:Boolean) : void
      {
         this.mBreadcrumbEnabled = enabled;
      }
      
      override public function setData(data:*) : void
      {
         super.setData(data);
         this.subCategories = data.child;
         var breadcrumb:uint = data.breadcrumb != null && this.mBreadcrumbEnabled ? uint(data.breadcrumb) : UiCppNewItems.CRUMB_NULL;
         UiCppNewItems.instance.InitBreadcrumb(this,breadcrumb);
      }
      
      override public function setToggled(toggled:Boolean) : void
      {
         if(toggled == mToggled)
         {
            return;
         }
         mToggled = toggled;
         super.setToggled(mToggled);
         this.doToggleAnim();
      }
      
      protected function doToggleAnim(instant:Boolean = false) : void
      {
         var targetY:Number = NaN;
         TweenLite.killTweensOf(this.subCategoryMount);
         TweenLite.killTweensOf(myBackground);
         TweenLite.killTweensOf(this.myListBackground);
         TweenLite.killTweensOf(this.myTexture);
         TweenLite.killTweensOf(this.myGlow);
         this.myFocusLine.scaleX = 0;
         var duration:Number = instant ? 0 : SLIDE_DURATION;
         if(mToggled)
         {
            if(this.subCategoryMount.numChildren > 0)
            {
               TweenLite.to(this.optionListAnimTarget,duration,{"y":this.mySubCategoryMask.y});
               TweenLite.to(this.myListBackground,duration,{
                  "alpha":0.5,
                  "y":this.mySubCategoryMask.y
               });
               this.subCategoryMount.visible = true;
            }
            TweenLite.to(this.myTexture,duration,{"alpha":1});
            TweenLite.to(this.myGlow,duration,{"alpha":GLOW_FOCUS_ALPHA});
            TweenLite.to(myLabel,duration,{"alpha":1});
            myBackground.gotoAndStop(TOGGLED_FRAME);
            this.myArrow.gotoAndStop(TOGGLED_FRAME);
            myLabel.fontColor = GlobalGuide.WHITE;
         }
         else
         {
            if(this.subCategoryMount.numChildren > 0)
            {
               targetY = this.mySubCategoryMask.y - this.mListHeight - LIST_MARGIN * 2;
               TweenLite.to(this.optionListAnimTarget,duration,{"y":targetY});
               TweenLite.to(this.myListBackground,duration,{"y":targetY});
               this.subCategoryMount.visible = false;
            }
            TweenLite.to(this.myListBackground,duration,{"alpha":0});
            TweenLite.to(this.myTexture,duration,{"alpha":0});
            TweenLite.to(this.myGlow,duration,{"alpha":0});
            TweenLite.to(myLabel,duration,{"alpha":0.5});
            myBackground.gotoAndStop(UNFOCUS_FRAME);
            this.myArrow.gotoAndStop(UNFOCUS_FRAME);
            myLabel.fontColor = GlobalGuide.CODO_BLUE_LIGHT;
         }
      }
      
      override public function get height() : Number
      {
         if(true == mToggled)
         {
            return this.subCategoryMount.numChildren > 0 ? TOGGLED_HEIGHT + this.mListHeight + LIST_MARGIN * 2 : TOGGLED_HEIGHT;
         }
         return TOGGLED_HEIGHT;
      }
      
      public function get subCategoryMount() : DisplayObjectContainer
      {
         return this.mySubCategoryMount;
      }
      
      public function get optionListAnimTarget() : DisplayObjectContainer
      {
         return this.mySubCategoryMount;
      }
      
      public function set isNewCategory(b:Boolean) : void
      {
         this.myNewTag.visible = b;
      }
      
      public function get isNewCategory() : Boolean
      {
         return this.myNewTag.visible;
      }
      
      public function set singleOptionMode(b:Boolean) : void
      {
         this.mSingleOptionMode = b;
      }
      
      public function set listHeightMax(maxHeight:Number) : void
      {
         this.mListHeightMax = maxHeight;
      }
      
      public function get subcategoryStates() : Array
      {
         return this.mCheckedCategories;
      }
      
      public function set subcategoryStates(states:Array) : void
      {
         for(var i:int = 0; i < states.length; i++)
         {
            if(this.mCheckedCategories[i] != states[i])
            {
               this.setItemState(i,states[i]);
            }
         }
      }
      
      private function setItemState(idx:uint, selected:Boolean) : void
      {
         var filter:FilterOption = null;
         var checkBox:CheckBox = this.mItems[idx] as CheckBox;
         if(Boolean(checkBox))
         {
            checkBox.checked = selected;
         }
         else
         {
            filter = this.mItems[idx] as FilterOption;
            filter.checked = selected;
         }
      }
      
      public function get selectedIndex() : int
      {
         if(!this.mSingleOptionMode)
         {
            Logger.print("FilterCategoryButton::selectedIndex called on multi-select filter, bad!");
         }
         for(var i:int = 0; i < this.mCheckedCategories.length; i++)
         {
            if(Boolean(this.mCheckedCategories[i]))
            {
               return i;
            }
         }
         return -1;
      }
      
      public function selectIndex(idx:int) : void
      {
         this.setItemState(idx,true);
      }
      
      public function set subCategories(data:Array) : void
      {
         var i:int = 0;
         var numSame:int = 0;
         var curY:Number = NaN;
         var component:UIInteractiveComponent = null;
         var padding:Number = NaN;
         this.mItems = new Vector.<UIInteractiveComponent>();
         while(this.subCategoryMount.numChildren > 0)
         {
            this.subCategoryMount.removeChildAt(0);
         }
         this.mListHeight = 0;
         if(data == null)
         {
            data = [];
         }
         if(this._data != null && data.length == this._data.length)
         {
            numSame = 0;
            for(i = 0; i < data.length; i++)
            {
               if(this._data[i] == data[i])
               {
                  numSame++;
               }
            }
            if(numSame == data.length)
            {
               return;
            }
         }
         this._data = data;
         this.mCheckedCategories = new Array();
         if(data.length == 0)
         {
            this.myListBackground.height = this.mySubCategoryMask.height = 0;
         }
         else
         {
            curY = LIST_MARGIN;
            padding = 0;
            for(i = 0; i < data.length; i++)
            {
               if(false == this.mSingleOptionMode)
               {
                  component = this.addCheckBox(data[i],i,curY);
                  curY += component.height + GlobalGuide.COMPONENT_PADDING;
                  padding = i == data.length - 1 ? 0 : GlobalGuide.COMPONENT_PADDING;
                  this.mListHeight += component.height + padding;
               }
               else
               {
                  component = this.addOption(data[i],i,curY);
                  curY += component.height;
                  this.mListHeight += component.height;
               }
            }
            if(this.mListHeightMax > 0)
            {
               this.mListHeight = Math.min(this.mListHeightMax,this.mListHeight);
            }
            this.myListBackground.height = this.mySubCategoryMask.height = this.mListHeight + LIST_MARGIN * 2;
         }
         this.doToggleAnim(true);
      }
      
      public function setSelectableFilters(selectableFilters:Array) : void
      {
         var reset:Boolean = false;
         for(var i:int = 0; i < selectableFilters.length; i++)
         {
            this.mItems[i].enabled = selectableFilters[i];
            if(!selectableFilters[i] && Boolean(this.mCheckedCategories[i]))
            {
               reset = true;
            }
         }
         if(this.mSingleOptionMode && reset)
         {
            this.selectIndex(0);
         }
      }
      
      public function addOnSubCategoryCheckedCallback(cb:Function) : void
      {
         this.mOnSubCategoryChecked = cb;
      }
      
      public function addOnSubCategoryUncheckedCallback(cb:Function) : void
      {
         this.mOnSubCategoryUnchecked = cb;
      }
      
      private function addCheckBox(data:Object, idx:int, yPos:Number) : UIInteractiveComponent
      {
         var checkBox:CheckBox = null;
         var checkBoxClass:Class = getDefinitionByName("codo.shared.CheckBox") as Class;
         checkBox = new checkBoxClass();
         checkBox.width = this.myListBackground.width - LIST_MARGIN;
         checkBox.label = data.label;
         this.subCategoryMount.addChild(checkBox);
         this.mItems.push(checkBox);
         checkBox.x = LIST_MARGIN;
         checkBox.y = yPos;
         if(idx == 0)
         {
            checkBox.checked = true;
            this.mCheckedCategories[idx] = true;
         }
         else
         {
            this.mCheckedCategories[idx] = false;
         }
         checkBox.addCheckedCallback(this.onSubCategoryChecked,idx);
         checkBox.addUncheckedCallback(this.onSubCategoryUnchecked,idx);
         return checkBox;
      }
      
      protected function addOption(data:Object, idx:int, yPos:Number) : UIInteractiveComponent
      {
         var option:FilterOption = null;
         var checkBoxClass:Class = getDefinitionByName(this.filterCategoryOptionClassPath) as Class;
         option = new checkBoxClass();
         option.width = this.myListBackground.width;
         option.breadcrumbEnabled = this.mBreadcrumbEnabled;
         option.setData(data);
         option.label = data.label;
         option.index = idx;
         this.subCategoryMount.addChild(option);
         this.mItems.push(option);
         option.y = yPos;
         if(idx == 0)
         {
            option.checked = true;
            this.mCheckedCategories[idx] = true;
         }
         else
         {
            this.mCheckedCategories[idx] = false;
         }
         option.addCheckedCallback(this.onSubCategoryChecked,idx);
         option.addUncheckedCallback(this.onSubCategoryUnchecked,idx);
         if(this.mUseAlternateOptionRowStyles)
         {
            this.handleAltRowStyles(idx,option);
         }
         return option;
      }
      
      public function set styleAlternateRows(useAlt:Boolean) : void
      {
         this.mUseAlternateOptionRowStyles = useAlt;
      }
      
      protected function handleAltRowStyles(index:int, option:FilterOption) : void
      {
         if(Boolean(index & 1))
         {
            option.setAlternatingRowStyleOdd();
         }
         else
         {
            option.setAlternatingRowStyleEven();
         }
      }
      
      protected function get filterCategoryOptionClassPath() : String
      {
         return "codo.shared.FilterOption";
      }
      
      private function onSubCategoryChecked(index:int) : void
      {
         var len:int = 0;
         var i:int = 0;
         var option:FilterOption = null;
         if(Boolean(this.mCheckedCategories[index]))
         {
            return;
         }
         if(true == this.mSingleOptionMode)
         {
            len = int(this.mItems.length);
            for(i = 0; i < len; i++)
            {
               option = this.mItems[i] as FilterOption;
               if(option.index != index)
               {
                  option.checked = false;
               }
            }
         }
         this.mCheckedCategories[index] = true;
         if(null != this.mOnSubCategoryChecked)
         {
            this.mOnSubCategoryChecked();
         }
      }
      
      private function onSubCategoryUnchecked(index:int) : void
      {
         if(!this.mCheckedCategories[index])
         {
            return;
         }
         this.mCheckedCategories[index] = false;
         if(null != this.mOnSubCategoryUnchecked)
         {
            this.mOnSubCategoryUnchecked();
         }
      }
      
      override public function draw() : void
      {
         myHitArea.width = mWidth;
      }
      
      override protected function onMouseOver() : void
      {
         super.onMouseOver();
         if(!mToggled)
         {
            TweenLite.killTweensOf(myLabel);
            TweenLite.killTweensOf(this.myFocusLine);
            TweenLite.to(myLabel,SLIDE_DURATION,{"alpha":1});
            TweenLite.to(this.myFocusLine,SLIDE_DURATION,{"scaleX":this.mFocusLineEndScaleX});
            myLabel.fontColor = GlobalGuide.CODO_BLUE_LIGHT;
            myBackground.gotoAndStop(UNTOGGLED_FOCUS_FRAME);
            this.myArrow.gotoAndStop(UNTOGGLED_FOCUS_FRAME);
         }
      }
      
      override protected function onMouseOut() : void
      {
         super.onMouseOut();
         if(!mToggled)
         {
            TweenLite.killTweensOf(myLabel);
            TweenLite.killTweensOf(this.myFocusLine);
            TweenLite.to(myLabel,SLIDE_DURATION,{"alpha":0.5});
            TweenLite.to(this.myFocusLine,SLIDE_DURATION,{"scaleX":0});
            myLabel.fontColor = GlobalGuide.CODO_BLUE_LIGHT;
            myBackground.gotoAndStop(UNFOCUS_FRAME);
            this.myArrow.gotoAndStop(UNFOCUS_FRAME);
         }
      }
   }
}

