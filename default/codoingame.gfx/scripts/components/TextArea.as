package components
{
   import codo.event.ParaEvent;
   import codo.utils.TextUtil;
   import flash.events.Event;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import shaui.component.core.InteractiveComponent;
   
   public class TextArea extends InteractiveComponent
   {
      
      public static const ALWAYS_BOTTOM:int = 0;
      
      public static const ALWAYS_CURRENT_LINE:int = 1;
      
      private static const FIRST_LINE:int = 1;
      
      public var myTextField:TextField;
      
      public var myScrollBar:ScrollBar2;
      
      private var _appendMode:int = 0;
      
      private var _scrollBarPosSet:Boolean = false;
      
      private var _prevScrollV:int = 1;
      
      private var _tfWidth:Number;
      
      private var _tfHeight:Number;
      
      private var _scrollBarGap:Number = 0;
      
      private var _inputable:Boolean = false;
      
      public function TextArea()
      {
         super();
      }
      
      [Inspectable(type="Number",defaultValue="100")]
      public function set textFieldWidth(value:Number) : void
      {
         this._tfWidth = value;
      }
      
      [Inspectable(type="Number",defaultValue="100")]
      public function set textFieldHeight(value:Number) : void
      {
         this._tfHeight = value;
      }
      
      [Inspectable(type="Number",defaultValue="0")]
      public function set scrollBarGap(value:Number) : void
      {
         this._scrollBarGap = value;
      }
      
      [Inspectable(type="Boolean",defaultValue="false")]
      public function set inputable(value:Boolean) : void
      {
         this._inputable = value;
      }
      
      override protected function onInit() : void
      {
         super.onInit();
         this.initLayout();
         this.refreshScrollBar();
         this.myScrollBar.pos = FIRST_LINE;
         if(this._inputable)
         {
            this.myTextField.type = TextFieldType.INPUT;
            this.myTextField.selectable = true;
            this.myTextField.mouseEnabled = true;
            this.myTextField.addEventListener(Event.CHANGE,this.onMessageIptChangeHandle);
         }
      }
      
      private function initLayout() : void
      {
         this.myTextField.x = this.myTextField.y = 0;
         this.myTextField.width = this._tfWidth;
         this.myTextField.height = this._tfHeight;
         this.myScrollBar.height = this._tfHeight;
         this.myScrollBar.x = this.myTextField.width + this._scrollBarGap;
         this.myScrollBar.y = 0;
      }
      
      override protected function onInitListener() : void
      {
         super.onInitListener();
         this.myTextField.addEventListener(Event.SCROLL,this.onTextFieldScroll);
         this.myScrollBar.addEventListener(Event.SCROLL,this.onScrollBarScroll);
         this.myScrollBar.addEventListener(ScrollBar2.STOP_SCROLL,this.onScrollBarStopScroll);
      }
      
      private function onMessageIptChangeHandle(e:Event) : void
      {
         dispatchEvent(e);
      }
      
      private function onTextFieldScroll(e:Event) : void
      {
         if(this._scrollBarPosSet == false)
         {
            this.refreshScrollBar();
            this.myScrollBar.pos = this.myTextField.scrollV;
         }
         else
         {
            this._scrollBarPosSet = false;
         }
         dispatchEvent(new ParaEvent(Event.SCROLL));
      }
      
      private function refreshScrollBar() : void
      {
         if(this.myTextField.maxScrollV > FIRST_LINE)
         {
            this.myScrollBar.visible = true;
            this.myScrollBar.setScrollRange(FIRST_LINE,this.myTextField.maxScrollV);
            this.myScrollBar.thumbSizeByPercent = (this.myTextField.bottomScrollV - this.myTextField.scrollV + 1) / this.myTextField.numLines;
         }
         else
         {
            this.myScrollBar.visible = false;
         }
      }
      
      private function onScrollBarScroll(e:ParaEvent) : void
      {
         var pScrollValue:Number = Number(e.myPara.scrollValue);
         var pPixelValue:Number = Number(e.myPara.pixelValue);
         var scrollValue:int = Math.round(pScrollValue);
         this.myScrollBar.posInPixel = pPixelValue;
         this._scrollBarPosSet = true;
         if(scrollValue > this.myTextField.maxScrollV)
         {
            this.myTextField.scrollV = this.myTextField.maxScrollV;
         }
         else if(scrollValue < FIRST_LINE)
         {
            this.myTextField.scrollV = 1;
         }
         else
         {
            this.myTextField.scrollV = scrollValue;
         }
      }
      
      private function onScrollBarStopScroll(e:ParaEvent) : void
      {
         this._scrollBarPosSet = false;
      }
      
      public function set appendMode(mode:int) : void
      {
         this._appendMode = mode;
      }
      
      public function get appendMode() : int
      {
         return this._appendMode;
      }
      
      public function set text(str:String) : void
      {
         this._prevScrollV = this.myTextField.scrollV;
         this.myTextField.text = str;
         this.refreshScrollBar();
         if(!this._inputable)
         {
            this.myScrollBar.pos = FIRST_LINE;
         }
      }
      
      public function get text() : String
      {
         return this.myTextField.text;
      }
      
      public function set htmlText(htmlText:String) : void
      {
         this._prevScrollV = this.myTextField.scrollV;
         this.myTextField.htmlText = htmlText;
         this.refreshScrollBar();
         if(!this._inputable)
         {
            this.myScrollBar.pos = FIRST_LINE;
         }
      }
      
      public function appendText(str:String) : void
      {
         this._prevScrollV = this.myTextField.scrollV;
         this.myTextField.appendText(str);
         this.postTextAppend();
      }
      
      public function appendHtmlText(htmlText:String) : void
      {
         this._prevScrollV = this.myTextField.scrollV;
         TextUtil.appendHTML(this.myTextField,htmlText);
         this.postTextAppend();
      }
      
      private function postTextAppend() : void
      {
         if(this._appendMode == ALWAYS_BOTTOM)
         {
            this.myTextField.scrollV = this.myTextField.maxScrollV;
            this.myScrollBar.pos = this.myTextField.maxScrollV;
         }
         else if(this._appendMode == ALWAYS_CURRENT_LINE)
         {
            this.myTextField.scrollV = this._prevScrollV;
            this.myScrollBar.pos = this.myTextField.scrollV;
         }
      }
      
      public function set selectable(value:Boolean) : void
      {
         this.myTextField.selectable = value;
      }
      
      public function get selectable() : Boolean
      {
         return this.myTextField.selectable;
      }
      
      public function isAtBottom() : Boolean
      {
         return this.myTextField.scrollV == this.myTextField.maxScrollV;
      }
      
      public function gotoBottom() : void
      {
         this.myTextField.scrollV = this.myScrollBar.pos = this.myTextField.maxScrollV;
      }
   }
}

