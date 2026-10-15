package codo.debugger
{
   import codo.component.Button;
   import codo.component.ScrollList;
   import codo.component.TextField;
   import codo.objects.ScrollListSettings;
   import codo.style.GlobalGuide;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   
   public class DebugInputWindow extends MovieClip
   {
      
      private static const INFO_AREA_HEIGHT:Number = 50;
      
      private static const LIST_WIDTH:Number = 800;
      
      private static const LIST_HEIGHT:Number = 544;
      
      public var myItemList:ScrollList;
      
      public var myCompleteButton:Button;
      
      public var myBackground:Sprite;
      
      public var myLabel:TextField;
      
      private var mOnCompleteCallback:Function;
      
      private var mOnCancelCallback:Function;
      
      private var mProperties:Vector.<Object>;
      
      public function DebugInputWindow()
      {
         super();
         var settings:ScrollListSettings = new ScrollListSettings();
         settings.orientation = ScrollListSettings.SCROLL_VERTICAL;
         settings.itemLinkage = "codo.debugger.debugInputRow";
         settings.itemPadding = 2;
         settings.autoSize = false;
         settings.useNavArrows = false;
         this.myItemList.settings = settings;
         this.myLabel.width = LIST_WIDTH;
         this.myItemList.width = LIST_WIDTH;
         this.myItemList.height = LIST_HEIGHT;
         this.myItemList.y = this.myBackground.y + INFO_AREA_HEIGHT;
         this.myCompleteButton.label = "CONFIRM";
         this.myCompleteButton.registerClickEvent(this.onCompleteClicked);
         this.myBackground.width = LIST_WIDTH;
         this.myBackground.height = LIST_HEIGHT + INFO_AREA_HEIGHT;
         this.myCompleteButton.x = this.myBackground.x + this.myBackground.width - this.myCompleteButton.width - 4;
         this.myCompleteButton.y = this.myBackground.y + 4;
         this.myLabel.x = this.myBackground.x + GlobalGuide.COMPONENT_PADDING;
         this.myLabel.y = this.myBackground.y + INFO_AREA_HEIGHT * 0.5 - this.myLabel.textHeight * 0.5;
      }
      
      public function show() : void
      {
         stage.addEventListener(KeyboardEvent.KEY_DOWN,this.handleKeyEvent);
         visible = true;
      }
      
      public function hide() : void
      {
         if(null != stage)
         {
            stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.handleKeyEvent);
         }
         visible = false;
      }
      
      private function handleKeyEvent(evt:KeyboardEvent) : void
      {
         if(evt.keyCode == Keyboard.ESCAPE && visible == true)
         {
            this.onCancel();
         }
      }
      
      public function registerCompleteCallback(func:Function) : void
      {
         this.mOnCompleteCallback = func;
      }
      
      public function registerCancelCallback(func:Function) : void
      {
         this.mOnCancelCallback = func;
      }
      
      public function set label(s:String) : void
      {
         this.myLabel.text = s;
      }
      
      public function setData(data:Vector.<Object>) : void
      {
         this.mProperties = data;
         this.myItemList.addItemsByVector(this.mProperties);
      }
      
      override public function set width(w:Number) : void
      {
      }
      
      override public function get width() : Number
      {
         return this.myItemList.width;
      }
      
      private function onCompleteClicked() : void
      {
         var prop:Object = null;
         var row:DebugInputRow = null;
         var returnProps:Vector.<Object> = new Vector.<Object>();
         var len:int = this.myItemList.numberOfItems;
         for(var i:int = 0; i < len; i++)
         {
            row = this.myItemList.getItem(i) as DebugInputRow;
            prop = new Object();
            prop.property = this.mProperties[i].label;
            prop.value = row.inputText;
            returnProps.push(prop);
         }
         if(null != this.mOnCompleteCallback)
         {
            this.mOnCompleteCallback(returnProps);
         }
      }
      
      private function onCancel() : void
      {
         this.mOnCancelCallback();
      }
   }
}

