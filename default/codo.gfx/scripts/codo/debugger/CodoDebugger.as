package codo.debugger
{
   import codo.constants.GameInfo;
   import codo.objects.CustomObject;
   import codo.style.GlobalGuide;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.utils.describeType;
   import flash.utils.getQualifiedClassName;
   
   public class CodoDebugger extends MovieClip
   {
      
      public var myInputWindow:DebugInputWindow;
      
      public var myListContainer:DebugBrowser;
      
      public var myEditModeContainer:DebugEditor;
      
      private var mCurrentTarget:Object;
      
      private var mCurrentFunction:String;
      
      public function CodoDebugger()
      {
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.init);
      }
      
      public static function drawGrid() : Sprite
      {
         var _loc1_:Shape = null;
         var _loc5_:TextField = null;
         var _loc8_:Sprite = null;
         var _loc2_:Number = GlobalGuide.COMPONENT_PADDING;
         var _loc3_:Number = GlobalGuide.DESIGN_GRID_WIDTH;
         var _loc4_:Number = GlobalGuide.COMPONENT_PADDING;
         var _loc6_:uint = 0;
         var _loc7_:TextFormat = new TextFormat();
         _loc7_.size = 20;
         _loc7_.font = GameInfo.GAME_FONT_S;
         _loc7_.align = TextFormatAlign.CENTER;
         _loc8_ = new Sprite();
         while(_loc2_ < GameInfo.DEFAULT_WIDTH)
         {
            _loc1_ = new Shape();
            _loc1_.graphics.beginFill(16711680);
            _loc1_.graphics.drawRect(0,0,_loc3_,GameInfo.DEFAULT_HEIGHT);
            _loc1_.graphics.endFill();
            _loc8_.addChild(_loc1_);
            _loc5_ = new TextField();
            _loc5_.x = _loc2_;
            _loc5_.y = GameInfo.DEFAULT_HEIGHT - 25;
            _loc5_.width = _loc3_;
            _loc5_.textColor = 16777215;
            _loc5_.defaultTextFormat = _loc7_;
            _loc5_.setTextFormat(_loc7_);
            _loc5_.text = String(_loc6_);
            _loc8_.addChild(_loc5_);
            _loc1_.x = _loc2_;
            _loc2_ += _loc3_ + GlobalGuide.COMPONENT_PADDING;
            _loc4_ += _loc3_ + GlobalGuide.COMPONENT_PADDING;
            _loc6_++;
         }
         _loc8_.mouseChildren = _loc8_.mouseEnabled = false;
         _loc8_.x = GameInfo.DEFAULT_WIDTH * 0.5 - _loc4_ * 0.5;
         _loc8_.alpha = 0.3;
         return _loc8_;
      }
      
      private function init(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.init);
         this.myEditModeContainer.registerEditEndCallback(this.onEditCompleteClicked);
         this.myEditModeContainer.disable();
         this.myEditModeContainer.visible = false;
         this.myInputWindow.visible = false;
         if(null == this.mCurrentTarget)
         {
            this.inspectElement(root.stage);
         }
      }
      
      private function inspectElement(param1:Object) : void
      {
         var data:Object;
         var disp:DisplayObject = null;
         var info:XML = null;
         var rowData:CustomObject = null;
         var node:XML = null;
         var len:int = 0;
         var i:int = 0;
         var readable:Boolean = false;
         var element:Object = param1;
         var listData:Vector.<CustomObject> = new Vector.<CustomObject>();
         this.mCurrentTarget = element;
         rowData = new CustomObject();
         rowData.label = "Root";
         rowData.clickEvent = this.inspectElement;
         rowData.clickEventData = root.stage;
         listData.push(rowData);
         if(null != this.mCurrentTarget && null != this.mCurrentTarget.parent)
         {
            rowData = new CustomObject();
            rowData.label = "Parent";
            rowData.clickEvent = this.inspectElement;
            rowData.clickEventData = this.mCurrentTarget.parent;
            listData.push(rowData);
         }
         if(this.mCurrentTarget is DisplayObject && this.mCurrentTarget.hasOwnProperty("numChildren"))
         {
            len = int(this.mCurrentTarget.numChildren);
            i = 0;
            while(i < len)
            {
               disp = this.mCurrentTarget.getChildAt(i);
               rowData = new CustomObject();
               rowData.label = disp.name;
               rowData.subLabel = getQualifiedClassName(disp);
               rowData.clickEvent = this.inspectElement;
               rowData.clickEventData = disp;
               listData.push(rowData);
               i++;
            }
         }
         info = describeType(this.mCurrentTarget);
         if(this.myListContainer.showFunctions)
         {
            for each(node in info..method)
            {
               rowData = new CustomObject();
               rowData.label = node.@name;
               rowData.subLabel = "Function";
               rowData.clickEvent = this.callFunction;
               rowData.clickEventData = node;
               listData.push(rowData);
            }
         }
         if(this.myListContainer.showVariables)
         {
            for each(node in info..variable)
            {
               rowData = new CustomObject();
               rowData.label = node.@name;
               rowData.subLabel = this.mCurrentTarget[node.@name];
               rowData.clickEvent = this.modifyVariable;
               rowData.clickEventData = node;
               listData.push(rowData);
            }
            for each(node in info..constant)
            {
               rowData = new CustomObject();
               rowData.label = node.@name;
               rowData.subLabel = "Constant: " + this.mCurrentTarget[node.@name];
               listData.push(rowData);
            }
            for each(node in info..accessor)
            {
               rowData = new CustomObject();
               rowData.label = node.@name;
               readable = true;
               try
               {
                  rowData.subLabel = this.mCurrentTarget[node.@name];
               }
               catch(e:Error)
               {
                  trace("Not readable");
                  readable = false;
               }
               if(readable && node.@access != "readonly")
               {
                  rowData.clickEvent = this.modifyVariable;
                  rowData.clickEventData = node;
               }
               listData.push(rowData);
            }
         }
         data = new Object();
         data.listData = listData;
         data.target = this.mCurrentTarget;
         data.variableToggleCallback = this.onBrowserUpdated;
         data.functionToggleCallback = this.onBrowserUpdated;
         data.editButtonCallback = this.onEditButtonClicked;
         this.myListContainer.setData(data);
      }
      
      private function onBrowserUpdated() : void
      {
         this.inspectElement(this.mCurrentTarget);
      }
      
      private function callFunction(param1:XML) : void
      {
         var _loc4_:Object = null;
         var _loc6_:XML = null;
         var _loc2_:XMLList = param1.children();
         this.myInputWindow.registerCompleteCallback(this.onCallFunctionComplete);
         this.mCurrentFunction = param1.@name;
         var _loc3_:Array = new Array();
         var _loc5_:int = _loc2_.length();
         if(_loc5_ == 0)
         {
            trace(this.mCurrentTarget[this.mCurrentFunction]());
         }
         else
         {
            for each(_loc6_ in _loc2_)
            {
               _loc4_ = new Object();
               _loc4_.type = _loc6_.@type;
               _loc4_.inputText = "ENTER VALUE";
               _loc3_.push(_loc4_);
            }
            this.myInputWindow.setData(_loc3_);
            this.myInputWindow.visible = true;
            this.myListContainer.visible = false;
         }
      }
      
      private function onCallFunctionComplete(param1:Vector.<CustomObject>) : void
      {
         var _loc2_:String = "";
         var _loc3_:int = int(param1.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            if(_loc4_ > 0)
            {
               _loc2_ += ", ";
            }
            _loc2_ += param1[_loc4_].value;
            _loc4_++;
         }
         trace("\n\nFUNCTION CALL RETURN: " + this.mCurrentTarget[this.mCurrentFunction](_loc2_) + "\n\n");
         this.myInputWindow.visible = false;
         this.myListContainer.visible = true;
         this.inspectElement(this.mCurrentTarget);
      }
      
      private function modifyVariable(param1:XML) : void
      {
         if(null != this.mCurrentTarget)
         {
            this.myInputWindow.registerCompleteCallback(this.onModifyVariableComplete);
            this.myInputWindow.setData([{
               "label":param1.@name,
               "inputText":this.mCurrentTarget[param1.@name]
            }]);
            this.myInputWindow.visible = true;
            this.myListContainer.visible = false;
         }
      }
      
      private function onModifyVariableComplete(param1:Vector.<CustomObject>) : void
      {
         var _loc2_:int = int(param1.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            this.mCurrentTarget[param1[_loc3_].property] = param1[_loc3_].value;
            _loc3_++;
         }
         this.myInputWindow.visible = false;
         this.myListContainer.visible = true;
         this.inspectElement(this.mCurrentTarget);
      }
      
      private function onEditButtonClicked() : void
      {
         var _loc1_:MovieClip = null;
         if(null != this.mCurrentTarget && this.mCurrentTarget is DisplayObject)
         {
            this.myListContainer.visible = false;
            _loc1_ = this.mCurrentTarget as MovieClip;
            this.myEditModeContainer.setTarget(_loc1_);
            this.myEditModeContainer.enable();
            this.myEditModeContainer.visible = true;
         }
      }
      
      private function onEditCompleteClicked() : void
      {
         this.myListContainer.visible = true;
         this.myEditModeContainer.disable();
         this.myEditModeContainer.visible = false;
      }
   }
}

