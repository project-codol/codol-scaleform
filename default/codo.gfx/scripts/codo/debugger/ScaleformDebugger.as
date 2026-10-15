package codo.debugger
{
   import codo.constants.GameInfo;
   import codo.style.GlobalGuide;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.ui.Keyboard;
   import flash.utils.describeType;
   import flash.utils.getQualifiedClassName;
   
   public class ScaleformDebugger extends MovieClip
   {
      
      public var myInputWindow:DebugInputWindow;
      
      public var myListContainer:DebugBrowser;
      
      public var myEditModeContainer:DebugEditor;
      
      private var mCurrentTarget:Object;
      
      private var mCurrentFunction:String;
      
      public function ScaleformDebugger()
      {
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.init);
      }
      
      public static function drawGrid() : Sprite
      {
         var col:Shape = null;
         var tf:TextField = null;
         var colIndex:uint = 0;
         var format:TextFormat = null;
         var grid:Sprite = null;
         var colX:Number = GlobalGuide.COMPONENT_PADDING;
         var colWidth:Number = GlobalGuide.DESIGN_GRID_WIDTH;
         var totalWidth:Number = GlobalGuide.COMPONENT_PADDING;
         colIndex = 0;
         format = new TextFormat();
         format.size = 20;
         format.font = GameInfo.GAME_FONT_S;
         format.align = TextFormatAlign.CENTER;
         grid = new Sprite();
         while(colX < GameInfo.DEFAULT_WIDTH)
         {
            col = new Shape();
            col.graphics.beginFill(16711680);
            col.graphics.drawRect(0,0,colWidth,GameInfo.DEFAULT_HEIGHT);
            col.graphics.endFill();
            grid.addChild(col);
            tf = new TextField();
            tf.x = colX;
            tf.y = GameInfo.DEFAULT_HEIGHT - 25;
            tf.width = colWidth;
            tf.textColor = 16777215;
            tf.defaultTextFormat = format;
            tf.setTextFormat(format);
            tf.text = String(colIndex);
            grid.addChild(tf);
            col.x = colX;
            colX += colWidth + GlobalGuide.COMPONENT_PADDING;
            totalWidth += colWidth + GlobalGuide.COMPONENT_PADDING;
            colIndex++;
         }
         grid.mouseChildren = grid.mouseEnabled = false;
         grid.x = GameInfo.DEFAULT_WIDTH * 0.5 - totalWidth * 0.5;
         grid.alpha = 0.3;
         return grid;
      }
      
      private function init(evt:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.init);
         stage.addEventListener(KeyboardEvent.KEY_DOWN,this.handleKeyEvent);
         this.myEditModeContainer.registerEditEndCallback(this.onEditCompleteClicked);
         this.myEditModeContainer.disable();
         this.myEditModeContainer.visible = false;
         this.myInputWindow.visible = false;
         if(null == this.mCurrentTarget)
         {
            this.inspectElement(root.stage);
         }
         this.myListContainer.x = GameInfo.gameWidth * 0.5 - this.myListContainer.width * 0.5;
         this.myInputWindow.x = GameInfo.gameWidth * 0.5 - this.myInputWindow.width * 0.5;
         this.myEditModeContainer.y = GameInfo.gameHeight - this.myEditModeContainer.height;
      }
      
      public function dispose() : void
      {
         stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.handleKeyEvent);
      }
      
      public function testFunctionOne(a:int) : void
      {
         trace("testFunctionOne: " + a);
      }
      
      public function testFunctionTwo(a:int, b:int) : void
      {
         trace("testFunctionTwo: " + a,b);
      }
      
      public function testFunctionThree(a:int, b:int, c:int) : void
      {
         trace("testFunctionThree: " + a,b,c);
      }
      
      public function canClose() : Boolean
      {
         if(this.myInputWindow.visible == true)
         {
            return false;
         }
         return true;
      }
      
      private function handleKeyEvent(evt:KeyboardEvent) : void
      {
         if(evt.keyCode == Keyboard.H)
         {
            this.visible = !this.visible;
         }
      }
      
      private function inspectElement(element:Object) : void
      {
         var data:Object;
         var disp:DisplayObject = null;
         var info:XML = null;
         var rowData:Object = null;
         var node:XML = null;
         var len:int = 0;
         var i:int = 0;
         var readable:Boolean = false;
         var listData:Vector.<Object> = new Vector.<Object>();
         this.mCurrentTarget = element;
         rowData = new Object();
         rowData.label = "Root";
         rowData.clickEvent = this.inspectElement;
         rowData.clickEventData = root.stage;
         listData.push(rowData);
         if(null != this.mCurrentTarget && null != this.mCurrentTarget.parent)
         {
            rowData = new Object();
            rowData.label = "Parent";
            rowData.clickEvent = this.inspectElement;
            rowData.clickEventData = this.mCurrentTarget.parent;
            listData.push(rowData);
         }
         if(this.mCurrentTarget is DisplayObject && this.mCurrentTarget.hasOwnProperty("numChildren"))
         {
            len = int(this.mCurrentTarget.numChildren);
            for(i = 0; i < len; i++)
            {
               disp = this.mCurrentTarget.getChildAt(i);
               rowData = new Object();
               rowData.label = disp.name;
               rowData.subLabel = getQualifiedClassName(disp);
               rowData.clickEvent = this.inspectElement;
               rowData.clickEventData = disp;
               listData.push(rowData);
            }
         }
         info = describeType(this.mCurrentTarget);
         if(this.myListContainer.showFunctions)
         {
            for each(node in info..method)
            {
               rowData = new Object();
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
               rowData = new Object();
               rowData.label = node.@name;
               rowData.subLabel = this.mCurrentTarget[node.@name];
               rowData.clickEvent = this.modifyVariable;
               rowData.clickEventData = node;
               listData.push(rowData);
            }
            for each(node in info..constant)
            {
               rowData = new Object();
               rowData.label = node.@name;
               rowData.subLabel = "Constant: " + this.mCurrentTarget[node.@name];
               listData.push(rowData);
            }
            for each(node in info..accessor)
            {
               rowData = new Object();
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
         data.parentClip = this.mCurrentTarget;
         this.myListContainer.setData(data);
      }
      
      private function onBrowserUpdated() : void
      {
         this.inspectElement(this.mCurrentTarget);
      }
      
      private function callFunction(node:XML) : void
      {
         var input:Object = null;
         var label:String = null;
         var child:XML = null;
         var counter:int = 0;
         trace("CALLING FUNCTION: " + node);
         var params:XMLList = node.child("parameter");
         this.myInputWindow.registerCompleteCallback(this.onCallFunctionComplete);
         this.myInputWindow.registerCancelCallback(this.onCallFunctionCancelled);
         this.mCurrentFunction = node.@name;
         var inputData:Vector.<Object> = new Vector.<Object>();
         var len:int = params.length();
         if(len == 0)
         {
            trace("RETURN VALUE: " + this.mCurrentTarget[this.mCurrentFunction]());
         }
         else
         {
            label = String(node.@name) + "(";
            counter = 0;
            for each(child in params)
            {
               input = new Object();
               if(true == child.hasOwnProperty("@type"))
               {
                  input.label = child.@type;
               }
               else
               {
                  input.label = "Object";
               }
               if("true" == child.@optional)
               {
                  input.label += " (optional)";
               }
               input.inputText = "ENTER VALUE";
               label += child.@type;
               counter++;
               if(len > 1 && counter < len)
               {
                  label += ", ";
               }
               inputData.push(input);
            }
            label += "):" + node.@returnType;
            this.myInputWindow.label = label;
            this.myInputWindow.setData(inputData);
            this.myInputWindow.show();
            this.myListContainer.visible = false;
         }
      }
      
      private function onCallFunctionComplete(data:Vector.<Object>) : void
      {
         var parameters:Array = new Array();
         var len:int = int(data.length);
         for(var i:int = 0; i < len; i++)
         {
            parameters.push(data[i].value);
         }
         switch(len)
         {
            case 1:
               trace("\n\nFUNCTION CALL RETURN: " + this.mCurrentTarget[this.mCurrentFunction](parameters[0]) + "\n\n");
               break;
            case 2:
               trace("\n\nFUNCTION CALL RETURN: " + this.mCurrentTarget[this.mCurrentFunction](parameters[0],parameters[1]) + "\n\n");
               break;
            case 3:
               trace("\n\nFUNCTION CALL RETURN: " + this.mCurrentTarget[this.mCurrentFunction](parameters[0],parameters[1],parameters[2]) + "\n\n");
               break;
            case 4:
               trace("\n\nFUNCTION CALL RETURN: " + this.mCurrentTarget[this.mCurrentFunction](parameters[0],parameters[1],parameters[2],parameters[3]) + "\n\n");
               break;
            case 5:
               trace("\n\nFUNCTION CALL RETURN: " + this.mCurrentTarget[this.mCurrentFunction](parameters[0],parameters[1],parameters[2],parameters[3],parameters[4]) + "\n\n");
               break;
            case 6:
               trace("\n\nFUNCTION CALL RETURN: " + this.mCurrentTarget[this.mCurrentFunction](parameters[0],parameters[1],parameters[2],parameters[3],parameters[4],parameters[5]) + "\n\n");
               break;
            case 7:
               trace("\n\nFUNCTION CALL RETURN: " + this.mCurrentTarget[this.mCurrentFunction](parameters[0],parameters[1],parameters[2],parameters[3],parameters[4],parameters[5],parameters[6]) + "\n\n");
               break;
            case 8:
               trace("\n\nFUNCTION CALL RETURN: " + this.mCurrentTarget[this.mCurrentFunction](parameters[0],parameters[1],parameters[2],parameters[3],parameters[4],parameters[5],parameters[6],parameters[7]) + "\n\n");
               break;
            case 9:
               trace("\n\nFUNCTION CALL RETURN: " + this.mCurrentTarget[this.mCurrentFunction](parameters[0],parameters[1],parameters[2],parameters[3],parameters[4],parameters[5],parameters[6],parameters[7],parameters[8]) + "\n\n");
               break;
            case 10:
               trace("\n\nFUNCTION CALL RETURN: " + this.mCurrentTarget[this.mCurrentFunction](parameters[0],parameters[1],parameters[2],parameters[3],parameters[4],parameters[5],parameters[6],parameters[7],parameters[8],parameters[9]) + "\n\n");
         }
         this.myInputWindow.hide();
         this.myListContainer.visible = true;
         this.inspectElement(this.mCurrentTarget);
      }
      
      private function onCallFunctionCancelled() : void
      {
         this.myInputWindow.hide();
         this.myListContainer.visible = true;
      }
      
      private function modifyVariable(node:XML) : void
      {
         var data:Vector.<Object> = null;
         if(null != this.mCurrentTarget)
         {
            this.myInputWindow.registerCompleteCallback(this.onModifyVariableComplete);
            data = new <Object>[{
               "label":node.@name,
               "inputText":this.mCurrentTarget[node.@name]
            }];
            this.myInputWindow.setData(data);
            this.myInputWindow.show();
            this.myListContainer.visible = false;
         }
      }
      
      private function onModifyVariableComplete(data:Vector.<Object>) : void
      {
         var len:int = int(data.length);
         for(var i:int = 0; i < len; i++)
         {
            this.mCurrentTarget[data[i].property] = data[i].value;
         }
         this.myInputWindow.hide();
         this.myListContainer.visible = true;
         this.inspectElement(this.mCurrentTarget);
      }
      
      private function onEditButtonClicked(target:Object) : void
      {
         var disp:MovieClip = target as MovieClip;
         if(null != disp && disp is DisplayObject)
         {
            this.myListContainer.visible = false;
            this.myEditModeContainer.setTarget(disp);
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

