package codo.common
{
   import codo.base.BaseView;
   import codo.utils.Logger;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.filters.GlowFilter;
   import flash.ui.Keyboard;
   import shaui.component.core.UIComponent;
   
   public class ThreeDAdjuster extends UIComponent
   {
      
      private static const KEY_ADJUSTER:Array = [Keyboard.X,Keyboard.Y,Keyboard.Z,Keyboard.A,Keyboard.B,Keyboard.C,Keyboard.S,Keyboard.D,Keyboard.F];
      
      private static const PROPERTIES:Array = ["x","y","z","rotationX","rotationY","rotationZ","scaleX","scaleY","scaleZ"];
      
      private static const SELECTED_FILTER:Array = [new GlowFilter(16711680)];
      
      private static const RESET_KEY:int = Keyboard.R;
      
      private static const OUTPUT_KEY:int = Keyboard.SPACE;
      
      private static const ENTER_KEY:int = Keyboard.ENTER;
      
      private static const ELDER_BROTHER_KEY:int = Keyboard.LEFT;
      
      private static const YOUNGER_BROTHER_KEY:int = Keyboard.RIGHT;
      
      private static const ADJUST_ADD_KEY:int = Keyboard.UP;
      
      private static const ADJUST_SUB_KEY:int = Keyboard.DOWN;
      
      private static const PARENT_KEY:int = Keyboard.BACKSPACE;
      
      private var _adjustee:DisplayObject;
      
      private var _reseverProperty:Object;
      
      private var _reseverFilters:Array;
      
      private var _working:Boolean = false;
      
      private var _currentFocusProperty:String = "";
      
      public function ThreeDAdjuster()
      {
         super();
         this._reseverProperty = new Object();
      }
      
      public function receiveKeyDownCode(keyCode:int) : void
      {
         var i:int = 0;
         if(keyCode == Keyboard.F11)
         {
            this.toggleEditMode();
         }
         else if(this._working)
         {
            this.adjustProperties(keyCode);
            for(i = 0; i < KEY_ADJUSTER.length; i++)
            {
               if(keyCode == KEY_ADJUSTER[i])
               {
                  this._currentFocusProperty = PROPERTIES[i];
                  Logger.print("INFO: Current Focus Property Is: ",this._currentFocusProperty);
                  break;
               }
            }
         }
      }
      
      private function adjustProperties(keyCode:int) : void
      {
         if(keyCode == RESET_KEY)
         {
            this.resetProperties();
         }
         else if(keyCode == OUTPUT_KEY)
         {
            this.outputProperties();
         }
         else if(keyCode == ENTER_KEY)
         {
            this.enterChildren();
         }
         else if(keyCode == PARENT_KEY)
         {
            this.selectParent();
         }
         else if(keyCode == ELDER_BROTHER_KEY)
         {
            this.selectElderBrother();
         }
         else if(keyCode == YOUNGER_BROTHER_KEY)
         {
            this.selectYoungerBrother();
         }
         else if(keyCode == ADJUST_ADD_KEY)
         {
            this.realAdjust(true);
         }
         else if(keyCode == ADJUST_SUB_KEY)
         {
            this.realAdjust(false);
         }
      }
      
      private function selectParent() : void
      {
         if(this._adjustee != null && this._adjustee.parent != null && this._adjustee.parent != this.stage)
         {
            this.selectTarget(this._adjustee.parent);
         }
         else
         {
            Logger.print("INFO: NO PARENT!!!!");
         }
      }
      
      private function resetProperties() : void
      {
         var i:int = 0;
         if(this._adjustee != null)
         {
            for(i = 0; i < PROPERTIES.length; i++)
            {
               this._adjustee[PROPERTIES[i]] = this._reseverProperty[PROPERTIES[i]];
            }
         }
      }
      
      private function outputProperties() : void
      {
         var i:int = 0;
         if(this._adjustee != null)
         {
            Logger.print("======I AM DIVIDER======");
            for(i = 0; i < PROPERTIES.length; i++)
            {
               Logger.print(PROPERTIES[i],": ",this._adjustee[PROPERTIES[i]]);
            }
            Logger.print("======I AM DIVIDER TOO======");
         }
      }
      
      private function enterChildren() : void
      {
         if(this._adjustee != null && this._adjustee is DisplayObjectContainer && (this._adjustee as DisplayObjectContainer).numChildren > 0)
         {
            this.selectTarget((this._adjustee as DisplayObjectContainer).getChildAt(0));
         }
         else
         {
            Logger.print("INFO: NOTHING CAN ENTER!!!");
         }
      }
      
      private function selectTarget(target:DisplayObject) : void
      {
         if(this._adjustee != null)
         {
            this._adjustee.filters = [];
         }
         this._adjustee = target;
         this._reseverFilters = this._adjustee.filters;
         for(var i:int = 0; i < PROPERTIES.length; i++)
         {
            this._reseverProperty[PROPERTIES[i]] = this._adjustee[PROPERTIES[i]];
         }
         this._adjustee.filters = SELECTED_FILTER;
      }
      
      private function selectElderBrother() : void
      {
         var index:int = 0;
         var target:DisplayObject = null;
         if(this._adjustee != null && this._adjustee.parent != null)
         {
            index = this._adjustee.parent.getChildIndex(this._adjustee);
            if(index > 0)
            {
               target = this._adjustee.parent.getChildAt(--index);
               this.selectTarget(target);
            }
         }
      }
      
      private function selectYoungerBrother() : void
      {
         var index:int = 0;
         var target:DisplayObject = null;
         if(this._adjustee != null && this._adjustee.parent != null)
         {
            index = this._adjustee.parent.getChildIndex(this._adjustee);
            if(index < this._adjustee.parent.numChildren - 1)
            {
               target = this._adjustee.parent.getChildAt(++index);
               this.selectTarget(target);
            }
         }
      }
      
      private function realAdjust(isAdd:Boolean = true) : void
      {
         var factor:Number = NaN;
         if(this._adjustee != null)
         {
            factor = 1;
            if(this._currentFocusProperty.indexOf("scale") != -1)
            {
               factor /= 100;
            }
            this._adjustee[this._currentFocusProperty] += isAdd ? factor : -1 * factor;
            Logger.print("ADJUST: ",this._currentFocusProperty,": ",this._adjustee[this._currentFocusProperty]);
         }
      }
      
      private function toggleEditMode() : void
      {
         var target:DisplayObject = null;
         this._working = !this._working;
         if(this._working == false)
         {
            Logger.print("INFO:TURN OFF 3D Adjuster");
            if(this._adjustee != null)
            {
               this._adjustee.filters = this._reseverFilters;
               this._adjustee = null;
            }
         }
         else
         {
            Logger.print("INFO:TURN ON 3D Adjuster");
            target = this.getFirstView(this.stage);
            if(target != null)
            {
               this.selectTarget(target);
            }
         }
      }
      
      private function getFirstView(root:DisplayObjectContainer) : DisplayObject
      {
         var candidate:DisplayObject = null;
         var target:DisplayObject = null;
         for(var i:int = 0; i < root.numChildren; i++)
         {
            candidate = root.getChildAt(i);
            if(candidate is BaseView)
            {
               return candidate;
            }
            if(candidate is DisplayObjectContainer)
            {
               target = this.getFirstView(candidate as DisplayObjectContainer);
               if(target != null)
               {
                  return target;
               }
            }
         }
         return null;
      }
   }
}

