package codo.component.object
{
   import codo.cpp.UiCppNewItems;
   
   public class NavigationObj
   {
      
      public var index:*;
      
      public var label:String;
      
      public var enabled:Boolean;
      
      public var clickEvent:Function;
      
      public var clickEventData:*;
      
      public var focusCallback:Function;
      
      public var isMarketReadyRequiredToActive:Boolean;
      
      public var iconLinkage:String;
      
      public var dataIdx:int;
      
      public var checked:Boolean;
      
      public var breadcrumb:uint = UiCppNewItems.CRUMB_NULL;
      
      public var lockLevel:String;
      
      public var toggle:Boolean;
      
      public function NavigationObj(index:*, label:String = null, enabled:Boolean = true, clickEvent:Function = null, clickEventData:* = null, isMarketReadyRequiredToActive:Boolean = false, focusCallback:Function = null, toggle:Boolean = true)
      {
         super();
         this.index = index;
         this.label = label;
         this.enabled = enabled;
         this.clickEvent = clickEvent;
         this.clickEventData = clickEventData;
         this.isMarketReadyRequiredToActive = isMarketReadyRequiredToActive;
         this.focusCallback = focusCallback;
         this.toggle = toggle;
      }
   }
}

