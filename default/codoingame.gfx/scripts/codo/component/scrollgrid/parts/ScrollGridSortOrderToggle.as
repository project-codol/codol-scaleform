package codo.component.scrollgrid.parts
{
   import codo.component.core.UIInteractiveComponent;
   import codo.cpp.IUiCppList;
   import codo.cpp.UiCpp;
   import codo.cpp.UiCppItemListView;
   import codo.cpp.UiCppList;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   
   public class ScrollGridSortOrderToggle extends UIInteractiveComponent implements IUiCppList
   {
      
      private static const UP_STATE_FRAME:int = 1;
      
      private static const OVER_STATE_FRAME:int = 2;
      
      private static const DOWN_STATE_FRAME:int = 3;
      
      private static const SLIDE_DURATION:Number = 0.2;
      
      private static const DESCENDING_ROTATION:Number = 180;
      
      private static const ASCENDING_ROTATION:Number = 0;
      
      public var myBackground:MovieClip;
      
      public var myArrow:MovieClip;
      
      private var mMouseOverGlowAdded:Boolean = false;
      
      private var mSortOrder:int = UiCppItemListView.DIR_ASCENDING;
      
      protected var _uiCpp:UiCppList;
      
      public function ScrollGridSortOrderToggle()
      {
         super();
         isInteractiveEnabled = true;
         myHitArea.width = this.myBackground.width;
         myHitArea.height = this.myBackground.height;
         this._uiCpp = new UiCppList(this);
      }
      
      public function getUiCpp() : UiCppList
      {
         return this._uiCpp;
      }
      
      override public function get width() : Number
      {
         return myHitArea.width;
      }
      
      override public function get height() : Number
      {
         return myHitArea.height;
      }
      
      public function get sortOrder() : int
      {
         return this.mSortOrder;
      }
      
      public function set sortOrder(order:int) : void
      {
         this.mSortOrder = order;
         TweenLite.killTweensOf(this.myArrow);
         TweenLite.to(this.myArrow,SLIDE_DURATION,{"rotation":(this.mSortOrder == UiCppItemListView.DIR_ASCENDING ? ASCENDING_ROTATION : DESCENDING_ROTATION)});
      }
      
      override protected function onMouseOver() : void
      {
         TweenLite.killTweensOf(this.myBackground);
         this.myBackground.gotoAndStop(OVER_STATE_FRAME);
         this.mMouseOverGlowAdded = true;
      }
      
      override protected function onMouseOut() : void
      {
         TweenLite.killTweensOf(this.myBackground);
         this.myBackground.gotoAndStop(UP_STATE_FRAME);
      }
      
      override protected function onMouseClickUp() : void
      {
         if(myHitArea.hitTestPoint(stage.mouseX,stage.mouseY) == true)
         {
            if(this.sortOrder == UiCppItemListView.DIR_ASCENDING)
            {
               this.sortOrder = UiCppItemListView.DIR_DESCENDING;
            }
            else
            {
               this.sortOrder = UiCppItemListView.DIR_ASCENDING;
            }
         }
         else
         {
            this.onMouseOut();
         }
      }
      
      public function uiCppGetListData() : Array
      {
         var cppData:Array = [];
         cppData[UiCppItemListView.DIR_ASCENDING] = {"id":UiCppItemListView.DIR_ASCENDING};
         cppData[UiCppItemListView.DIR_DESCENDING] = {"id":UiCppItemListView.DIR_DESCENDING};
         return cppData;
      }
      
      public function uiCppGetSelectedIndex() : int
      {
         return this.mSortOrder;
      }
      
      public function uiCppInitClickEvent(uiCpp:UiCpp, func:String) : void
      {
         registerClickEvent(function():void
         {
            uiCpp[func]();
         });
      }
   }
}

