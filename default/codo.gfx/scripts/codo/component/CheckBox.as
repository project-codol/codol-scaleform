package codo.component
{
   import codo.component.core.UIInteractiveComponent;
   import codo.cpp.IUiCppList;
   import codo.cpp.IUiCppListMutable;
   import codo.cpp.UiCpp;
   import codo.cpp.UiCppList;
   import codo.style.ButtonGuide;
   import codo.style.GlobalGuide;
   import flash.display.MovieClip;
   import fsg.shared.BehaviourSelectable;
   
   public class CheckBox extends UIInteractiveComponent implements IUiCppList, IUiCppListMutable
   {
      
      private static const OUTLINE_UNFOCUS_ALPHA:Number = 0.25;
      
      public var myLabel:TextField;
      
      public var myCheck:MovieClip;
      
      public var myOutline:MovieClip;
      
      protected var _uiCpp:UiCppList;
      
      protected var _uiCppData:Array;
      
      private var mSelectable:BehaviourSelectable;
      
      private var mIndex:int = 0;
      
      public function CheckBox()
      {
         super();
         isInteractiveEnabled = true;
         this.myLabel.textStyle = ButtonGuide.styleCheckBoxLabel;
         this.myCheck.visible = false;
         this.mSelectable = new BehaviourSelectable(mClickable,true);
         this.mSelectable.addSelectedCallback(this.onSelected);
         this.mSelectable.addUnselectedCallback(this.onUnselected);
         myHitArea.width = this.myLabel.x + this.myLabel.textWidth;
         myHitArea.height = this.myOutline.height;
         this.myOutline.alpha = OUTLINE_UNFOCUS_ALPHA;
         this.updateHighlightState();
      }
      
      public function makeUiCpp() : void
      {
         this._uiCpp = new UiCppList(this);
      }
      
      override public function setData(data:*) : void
      {
         super.setData(data);
         if(null != data.label)
         {
            this.label = data.label;
         }
         if(null != data.canUnselectClick)
         {
            this.mSelectable.dispose();
            this.mSelectable = new BehaviourSelectable(mClickable,data.canUnselectClick);
            this.mSelectable.addSelectedCallback(this.onSelected);
            this.mSelectable.addUnselectedCallback(this.onUnselected);
         }
         if(null != data.checked)
         {
            this.checked = data.checked;
         }
         if(null != data.clickEvent)
         {
            registerClickEvent(data.clickEvent,this);
         }
         if(null != data.checkEvent)
         {
            this.addCheckedCallback(data.checkEvent,this);
         }
         if(null != data.unCheckEvent)
         {
            this.addUncheckedCallback(data.unCheckEvent,this);
         }
      }
      
      override public function set width(w:Number) : void
      {
         myHitArea.width = w;
         this.myLabel.width = w - (this.myCheck.width + this.myCheck.x);
      }
      
      override public function get width() : Number
      {
         return myHitArea.width;
      }
      
      override public function get height() : Number
      {
         return myHitArea.height;
      }
      
      override public function set enabled(inEnabled:Boolean) : void
      {
         super.enabled = inEnabled;
         this.updateHighlightState();
      }
      
      override protected function onMouseOver() : void
      {
         super.onMouseOver();
         this.updateHighlightState();
         this.myOutline.alpha = 1;
      }
      
      override protected function onMouseOut() : void
      {
         super.onMouseOut();
         this.updateHighlightState();
         this.myOutline.alpha = OUTLINE_UNFOCUS_ALPHA;
      }
      
      public function set label(label:String) : void
      {
         this.myLabel.text = label;
         myHitArea.width = this.myLabel.x + this.myLabel.textWidth;
      }
      
      public function get label() : String
      {
         return this.myLabel.text;
      }
      
      public function set checked(value:Boolean) : void
      {
         this.mSelectable.state = value ? BehaviourSelectable.STATE_SELECTED : BehaviourSelectable.STATE_UNSELECTED;
         this.myCheck.visible = value;
         this.updateHighlightState();
      }
      
      public function get checked() : Boolean
      {
         return this.mSelectable.state == BehaviourSelectable.STATE_SELECTED;
      }
      
      public function set index(idx:int) : void
      {
         this.mIndex = idx;
      }
      
      public function get index() : int
      {
         return this.mIndex;
      }
      
      protected function updateHighlightState() : void
      {
         if(!enabled)
         {
            this.myLabel.fontColor = GlobalGuide.CODO_GRAY_LIGHT;
            this.myOutline.alpha = OUTLINE_UNFOCUS_ALPHA;
         }
         else if(this.checked || _isFocused)
         {
            this.myLabel.fontColor = GlobalGuide.WHITE;
         }
         else
         {
            this.myLabel.fontColor = GlobalGuide.CODO_BLUE_LIGHT;
         }
      }
      
      public function addCheckedCallback(fnCallback:Function, userData:Object = null) : void
      {
         this.mSelectable.addSelectedCallback(fnCallback,userData);
      }
      
      public function removeCheckedCallback(fnCallback:Function, userData:Object = null) : void
      {
         this.mSelectable.removeSelectedCallback(fnCallback,userData);
      }
      
      public function addUncheckedCallback(fnCallback:Function, userData:Object = null) : void
      {
         this.mSelectable.addUnselectedCallback(fnCallback,userData);
      }
      
      public function removeUncheckedCallback(fnCallback:Function, userData:Object = null) : void
      {
         this.mSelectable.removeUnselectedCallback(fnCallback,userData);
      }
      
      public function getUiCpp() : UiCppList
      {
         return this._uiCpp;
      }
      
      public function uiCppGetListData() : Array
      {
         return this._uiCppData;
      }
      
      public function uiCppGetSelectedIndex() : int
      {
         return this.checked ? 1 : 0;
      }
      
      public function uiCppInitClickEvent(uiCpp:UiCpp, func:String) : void
      {
         this.addCheckedCallback(function():void
         {
            uiCpp[func]();
         });
         this.addUncheckedCallback(function():void
         {
            uiCpp[func]();
         });
      }
      
      public function uiCppSetListData(data:Array) : void
      {
         this._uiCppData = data;
      }
      
      public function uiCppSelectIndex(index:int) : void
      {
         this.checked = index != 0;
      }
      
      private function onSelected() : void
      {
         this.myCheck.visible = true;
      }
      
      private function onUnselected() : void
      {
         this.myCheck.visible = false;
      }
   }
}

