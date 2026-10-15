package codo.debugger
{
   import codo.component.CheckBox;
   import codo.component.ScrollList;
   import codo.component.TextField;
   import codo.objects.ScrollListSettings;
   import codo.style.GlobalGuide;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.utils.getQualifiedClassName;
   
   public class DebugBrowser extends MovieClip
   {
      
      private static const INFO_AREA_HEIGHT:Number = 130;
      
      private static const FOOTER_AREA_HEIGHT:Number = 48;
      
      private static const LIST_WIDTH:Number = 800;
      
      private static const LIST_HEIGHT:Number = 544;
      
      private static const TEXT_MARGIN:Number = 4;
      
      public var myList:ScrollList;
      
      public var myElementName:TextField;
      
      public var myElementPosition:TextField;
      
      public var myElementRotation:TextField;
      
      public var myElementSize:TextField;
      
      public var myElementAlpha:TextField;
      
      public var myFunctionToggle:CheckBox;
      
      public var myVariableToggle:CheckBox;
      
      public var myBackground:Sprite;
      
      private var mShowFunctions:Boolean = false;
      
      private var mShowVariables:Boolean = false;
      
      private var mCurrentTarget:Object;
      
      private var mVariableToggleClickedCallback:Function;
      
      private var mFunctionToggleClickedCallback:Function;
      
      private var mEditButtonCallback:Function;
      
      private var mParentClip:Object;
      
      private var mParentName:String;
      
      public function DebugBrowser()
      {
         super();
         this.myElementName.fontSize = this.myElementAlpha.fontSize = this.myElementSize.fontSize = this.myElementRotation.fontSize = this.myElementPosition.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         this.myElementName.width = 400;
         this.myElementPosition.width = 400;
         this.myElementRotation.width = 400;
         this.myElementSize.width = 400;
         this.myElementAlpha.width = 400;
         this.myFunctionToggle.label = "Show Functions";
         this.myVariableToggle.label = "Show Variables";
         this.myFunctionToggle.registerClickEvent(this.onFunctionToggleClicked);
         this.myVariableToggle.registerClickEvent(this.onVariableToggleClicked);
         var settings:ScrollListSettings = this.myList.settings;
         settings.orientation = ScrollListSettings.SCROLL_VERTICAL;
         settings.useNavArrows = false;
         settings.itemLinkage = "codo.debugger.debugButton";
         settings.itemPadding = 2;
         settings.autoSize = false;
         this.myList.settings = settings;
         this.myList.width = LIST_WIDTH;
         this.myList.height = LIST_HEIGHT;
         this.myList.y = this.myBackground.y + INFO_AREA_HEIGHT;
         this.myFunctionToggle.width = this.myVariableToggle.width = 140;
         this.myVariableToggle.x = this.myList.x + GlobalGuide.COMPONENT_PADDING;
         this.myFunctionToggle.x = this.myVariableToggle.x + this.myVariableToggle.width;
         this.myVariableToggle.y = this.myFunctionToggle.y = this.myBackground.y + LIST_HEIGHT + INFO_AREA_HEIGHT + GlobalGuide.COMPONENT_PADDING;
         this.myElementAlpha.x = this.myElementSize.x = this.myElementRotation.x = this.myElementPosition.x = this.myElementName.x = this.myList.x + GlobalGuide.COMPONENT_PADDING;
         this.myElementName.y = this.myBackground.y + GlobalGuide.COMPONENT_PADDING;
         this.myElementPosition.y = this.myElementName.y + this.myElementName.textHeight + TEXT_MARGIN;
         this.myElementSize.y = this.myElementPosition.y + this.myElementPosition.textHeight + TEXT_MARGIN;
         this.myElementRotation.y = this.myElementSize.y + this.myElementSize.textHeight + TEXT_MARGIN;
         this.myElementAlpha.y = this.myElementRotation.y + this.myElementRotation.textHeight + TEXT_MARGIN;
         this.myBackground.width = LIST_WIDTH;
         this.myBackground.height = LIST_HEIGHT + INFO_AREA_HEIGHT + FOOTER_AREA_HEIGHT;
      }
      
      override public function set width(w:Number) : void
      {
      }
      
      override public function get width() : Number
      {
         return this.myList.width;
      }
      
      public function get showFunctions() : Boolean
      {
         return this.mShowFunctions;
      }
      
      public function get showVariables() : Boolean
      {
         return this.mShowVariables;
      }
      
      public function setData(data:Object) : void
      {
         var listData:Vector.<Object> = data.listData;
         var len:int = int(listData.length);
         for(var i:int = 0; i < len; i++)
         {
            listData[i].mouseOverCallback = this.onRowMouseOver;
            if(null != listData[i].clickEventData && listData[i].clickEventData is DisplayObject)
            {
               listData[i].editClickCallback = this.onEditButtonClicked;
            }
         }
         this.myList.addItemsByVector(listData);
         this.mVariableToggleClickedCallback = data.variableToggleCallback;
         this.mFunctionToggleClickedCallback = data.functionToggleCallback;
         this.mEditButtonCallback = data.editButtonCallback;
         this.mParentName = data.parentClip.name;
         this.mParentClip = data.parentClip;
         this.updateDisplay(data.target);
      }
      
      public function updateDisplay(target:Object) : void
      {
         this.mCurrentTarget = target;
         if(this.mCurrentTarget is DisplayObject)
         {
            this.myElementPosition.text = "x: " + this.mCurrentTarget.x + " y: " + this.mCurrentTarget.y + " z: " + this.mCurrentTarget.z;
            this.myElementRotation.text = "rotation: " + this.mCurrentTarget.rotation;
            this.myElementSize.text = "w: " + this.mCurrentTarget.width + " h: " + this.mCurrentTarget.height;
            this.myElementAlpha.text = "alpha: " + this.mCurrentTarget.alpha + " visible: " + this.mCurrentTarget.visible;
            this.myElementName.text = this.mParentName + " -> " + this.mCurrentTarget.name;
         }
         else if(this.mCurrentTarget is XML)
         {
            this.myElementName.text = getQualifiedClassName(this.mParentClip) + "::" + this.mCurrentTarget.@name + "()";
            this.myElementPosition.text = "";
            this.myElementRotation.text = "";
            this.myElementSize.text = "";
            this.myElementAlpha.text = "";
         }
         else
         {
            this.myElementPosition.text = "";
            this.myElementRotation.text = "";
            this.myElementSize.text = "";
            this.myElementAlpha.text = "";
         }
      }
      
      private function onVariableToggleClicked() : void
      {
         this.mShowVariables = !this.mShowVariables;
         this.mVariableToggleClickedCallback();
      }
      
      private function onFunctionToggleClicked() : void
      {
         this.mShowFunctions = !this.mShowFunctions;
         this.mFunctionToggleClickedCallback();
      }
      
      private function onEditButtonClicked(button:*) : void
      {
         this.mEditButtonCallback(button.getData().clickEventData);
      }
      
      private function onRowMouseOver(button:*) : void
      {
         this.updateDisplay(button.getData().clickEventData);
      }
   }
}

