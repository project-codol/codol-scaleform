package codo.component.filter
{
   import codo.component.TextField;
   import codo.component.core.UIInteractiveComponent;
   import codo.component.loadout.LoadoutViewPanelBase;
   import codo.constants.MarketMenuData;
   import codo.cpp.IUiCppListFilter;
   import codo.cpp.IUiCppListMutable;
   import codo.cpp.UiCpp;
   import codo.cpp.UiCppListFilter;
   import codo.cpp.UiCppNewItems;
   import codo.objects.CharacterObj;
   import codo.objects.FilterObj;
   import codo.style.ButtonGuide;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.utils.getDefinitionByName;
   import fsg.util.FsgImageHolder;
   
   public class LoadoutFilter extends UIInteractiveComponent implements IUiCppListFilter, IUiCppListMutable
   {
      
      private static const LIST_MARGIN:Number = 60;
      
      private static const FADE_DURATION:Number = 0.2;
      
      private static const UNFOCUS_FRAME:int = 1;
      
      private static const TOGGLED_FRAME:int = 2;
      
      private static const UNTOGGLED_FOCUS_FRAME:int = 3;
      
      public var myLabel:TextField;
      
      public var myImage:FsgImageHolder;
      
      public var myListBackground:Sprite;
      
      public var myListFooter:Sprite;
      
      public var myPortraitFocus:Sprite;
      
      public var myCategoryMount:MovieClip;
      
      public var myCharacterList:LoadoutFilterCharacterList;
      
      public var myBackground:MovieClip;
      
      private var mItems:Vector.<UIInteractiveComponent>;
      
      private var mCurrentCategoryIndex:int = 0;
      
      private var mOnSubCategoryChecked:Function;
      
      private var mOnTourFilterClicked:Function;
      
      private var mOnCharacterSelected:Function;
      
      protected var _uiCpp:UiCppListFilter;
      
      protected var _panel:LoadoutViewPanelBase;
      
      protected var _cancelCategoryChange:Function;
      
      public var GEAR_DATA:Object = MarketMenuData.CATEGORY_GEAR;
      
      public function LoadoutFilter()
      {
         super();
         isInteractiveEnabled = true;
         this.myLabel.textStyle = ButtonGuide.styleFilterCategoryButton;
         this.myLabel.width = myHitArea.width - this.myLabel.x;
         this.myPortraitFocus.alpha = 0;
         this.myCharacterList.addOnCharacterSelectedCallback(this.onCharacterSelected);
         this.myCharacterList.addOnCharactersUpdatedCallback(this.onCharsUpdated);
         this.myBackground.gotoAndStop(TOGGLED_FRAME);
         this._uiCpp = new UiCppListFilter(this);
         UiCppNewItems.instance.InitBreadcrumb(this,UiCppNewItems.CRUMB_CHARACTERS,0,0);
      }
      
      public function refreshCharacters(panel:LoadoutViewPanelBase) : void
      {
         this.showCurCharacter();
         this._panel = panel;
      }
      
      private function showCurCharacter() : void
      {
         var char:CharacterObj = this.myCharacterList.currentCharacter;
         this.myImage.setImage(char.imageURL);
         this.myLabel.text = char.name;
      }
      
      public function set label(l:String) : void
      {
         this.myLabel.text = l;
      }
      
      public function SetCategories(cats:Array, defaultIndex:int) : void
      {
         var itemData:FilterObj = null;
         var item:FilterOption = null;
         this.clearItems();
         this.mItems = new Vector.<UIInteractiveComponent>();
         this.mCurrentCategoryIndex = defaultIndex;
         var curY:Number = 0;
         var len:int = int(cats.length);
         for(var i:int = 0; i < len; i++)
         {
            itemData = cats[i];
            item = this.addOption(itemData,i,curY,defaultIndex == i);
            if(itemData.lockedForPurchase)
            {
               item.lockedForPurchase = itemData.lockedForPurchase;
            }
            curY += item.height;
         }
         this.myListBackground.height = curY + LIST_MARGIN;
         this.myListFooter.y = this.myListBackground.y + this.myListBackground.height + 2;
      }
      
      public function get currentCategoryIndex() : int
      {
         return this.mCurrentCategoryIndex;
      }
      
      public function addOnSubCategoryCheckedCallback(cb:Function) : void
      {
         this.mOnSubCategoryChecked = cb;
      }
      
      public function clearOnSubCategoryCheckedCallback() : void
      {
         this.mOnSubCategoryChecked = null;
      }
      
      public function addOnTourFilterClicked(cb:Function) : void
      {
         this.mOnTourFilterClicked = cb;
      }
      
      public function clearOnTourFilterClicked() : void
      {
         this.mOnTourFilterClicked = null;
      }
      
      private function addOption(data:FilterObj, idx:int, yPos:Number, checked:Boolean) : FilterOption
      {
         var option:FilterOption = null;
         var checkBoxClass:Class = getDefinitionByName("codo.shared.FilterOption") as Class;
         option = new checkBoxClass();
         option.width = this.myListBackground.width;
         option.label = data.label;
         option.index = idx;
         option.enabled = !data.locked;
         option.setData(data);
         this.myCategoryMount.addChild(option);
         this.mItems.push(option);
         option.y = yPos;
         if(checked)
         {
            option.checked = true;
         }
         option.addCheckedCallback(this.onSubCategoryChecked,idx);
         return option;
      }
      
      public function setCancelCategoryChange(callback:Function) : void
      {
         this._cancelCategoryChange = callback;
      }
      
      private function onSubCategoryChecked(index:int) : void
      {
         var item:FilterOption = null;
         var option:FilterOption = null;
         if(this.mCurrentCategoryIndex == index)
         {
            return;
         }
         if(this._cancelCategoryChange != null && Boolean(this._cancelCategoryChange(index)))
         {
            item = this.mItems[index] as FilterOption;
            item.checked = false;
            return;
         }
         var len:int = int(this.mItems.length);
         for(var i:int = 0; i < len; i++)
         {
            option = this.mItems[i] as FilterOption;
            if(option.index != index)
            {
               option.checked = false;
            }
         }
         this.mCurrentCategoryIndex = index;
         if(null != this.mOnSubCategoryChecked)
         {
            this.mOnSubCategoryChecked(index);
         }
         if(this.mOnTourFilterClicked != null)
         {
            this.mOnTourFilterClicked();
         }
      }
      
      public function setCategorySelection(index:int) : void
      {
         this.onSubCategoryChecked(index);
         var item:FilterOption = this.mItems[index] as FilterOption;
         item.checked = true;
      }
      
      private function clearItems() : void
      {
         while(this.myCategoryMount.numChildren > 0)
         {
            this.myCategoryMount.removeChildAt(0);
         }
      }
      
      public function addOnCharacterSelectCallback(c:Function) : void
      {
         this.mOnCharacterSelected = c;
      }
      
      private function onCharsUpdated() : Boolean
      {
         if(this._panel == null || !this._panel.isShown())
         {
            return false;
         }
         this.showCurCharacter();
         return true;
      }
      
      private function onCharacterSelected() : void
      {
         if(this.onCharsUpdated() && this.mOnCharacterSelected != null)
         {
            this.mOnCharacterSelected();
         }
      }
      
      override protected function onMouseOver() : void
      {
         TweenLite.to(this.myPortraitFocus,FADE_DURATION,{"alpha":1});
      }
      
      override protected function onMouseOut() : void
      {
         TweenLite.to(this.myPortraitFocus,FADE_DURATION,{"alpha":0});
      }
      
      override protected function onMouseClick() : void
      {
         if(false == this.myCharacterList.isShowing)
         {
            this.myCharacterList.show();
         }
         else
         {
            this.myCharacterList.hide();
         }
      }
      
      public function getUiCpp() : UiCppListFilter
      {
         return this._uiCpp;
      }
      
      public function uiCppGetListData() : Array
      {
         var filter:FilterObj = null;
         var categoryArr:Array = new Array();
         var characters:Vector.<CharacterObj> = this.myCharacterList.characters;
         var numCharacters:uint = characters.length;
         for(var i:uint = 0; i < numCharacters; i++)
         {
            filter = new FilterObj(i,characters[i].name,this.GEAR_DATA.child);
            filter.aggregate = true;
            categoryArr.push(filter);
         }
         return categoryArr;
      }
      
      public function uiCppGetSelectedIndex() : int
      {
         return this.myCharacterList.currentCharacterIndex;
      }
      
      public function uiCppInitClickEvent(uiCpp:UiCpp, func:String) : void
      {
      }
      
      public function uiCppSetListData(data:Array) : void
      {
         var child:Object = null;
         var filterObj:FilterObj = null;
         var gearCategs:Array = this.GEAR_DATA.child;
         var filters:Array = [];
         for(var i:int = 0; i < gearCategs.length; i++)
         {
            child = gearCategs[i];
            filterObj = new FilterObj(i,child.label);
            filterObj.breadcrumb = child.breadcrumb;
            filters.push(filterObj);
         }
         this.SetCategories(filters,this.mCurrentCategoryIndex);
      }
      
      public function uiCppSelectIndex(index:int) : void
      {
      }
      
      public function uiCppSetSelectableFilters(selectableFilters:Array) : void
      {
         for(var i:int = 0; i < selectableFilters.length; i++)
         {
            this.mItems[i].enabled = selectableFilters[i];
         }
         if(!this.mItems[this.mCurrentCategoryIndex].enabled)
         {
            (this.mItems[this.mCurrentCategoryIndex] as FilterOption).checked = false;
            (this.mItems[0] as FilterOption).checked = true;
         }
      }
      
      public function uiCppSetFilterStates(states:Array) : void
      {
      }
      
      public function uiCppGetFilterStates() : Array
      {
         var states:Array = [];
         for(var i:int = 0; i < this.mItems.length; i++)
         {
            states[i] = i == this.mCurrentCategoryIndex;
         }
         return states;
      }
      
      public function uiCppInitFilterChangeEvent(uiCpp:UiCpp, func:String) : void
      {
         this.addOnSubCategoryCheckedCallback(function():void
         {
            uiCpp[func]();
         });
      }
   }
}

