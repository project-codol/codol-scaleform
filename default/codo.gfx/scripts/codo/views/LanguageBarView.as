package codo.views
{
   import codo.base.BaseView;
   import codo.constants.DataID;
   import codo.constants.GameInfo;
   import flash.display.MovieClip;
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import ime.LangBarElement;
   import ime.StatusWindowElement;
   import scaleform.gfx.IMEEventEx;
   import scaleform.gfx.IMEEx;
   import shaui.component.core.UIComponent;
   
   public class LanguageBarView extends BaseView
   {
      
      private static const GRIP_INIT_X:int = 1700;
      
      private static const GRIP_INIT_Y:int = 1000;
      
      public var myLangBarGrip:MovieClip;
      
      public var myLangBarContainer:MovieClip;
      
      public var myStatusWindowContainer:MovieClip;
      
      public var myLangBarElement:LangBarElement;
      
      public var myStatusWindowElement:StatusWindowElement;
      
      private var _bLangBarLoaded:Boolean = false;
      
      private var _bStatusWindowLoaded:Boolean = false;
      
      private var _candidateListStyleIndex:uint = 0;
      
      private var _candidateListStyles:Array = [];
      
      private var _dragRectangle:Rectangle;
      
      public function LanguageBarView()
      {
         super();
      }
      
      override protected function onInit() : void
      {
         this.alpha = 0.85;
         var bIMEEnabled:Boolean = this.getDP(DataID.IS_IME_ENABLED);
         if(bIMEEnabled)
         {
            this.loadLangBar();
            this.loadStatusWindow();
            this.initCandidateListStyle();
         }
         this.myLangBarGrip.visible = bIMEEnabled;
         this._dragRectangle = new Rectangle();
      }
      
      override protected function showView() : void
      {
         visible = false;
      }
      
      override protected function onInitListener() : void
      {
         this.myLangBarGrip.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDownHandle);
         UIComponent.STAGE.addEventListener(FocusEvent.FOCUS_IN,this.onFocusChanged);
         UIComponent.STAGE.addEventListener(FocusEvent.FOCUS_OUT,this.onFocusChanged);
      }
      
      private function loadLangBar() : void
      {
         this._bLangBarLoaded = true;
         this.myLangBarElement = new LangBarElement();
         this.myLangBarContainer.addChild(this.myLangBarElement);
         this.myLangBarContainer.addEventListener(IMEEventEx.SET_IMENAME,this.onSetIMEName);
      }
      
      private function loadStatusWindow() : void
      {
         this._bStatusWindowLoaded = true;
         this.myStatusWindowElement = new StatusWindowElement();
         this.myStatusWindowContainer.addChild(this.myStatusWindowElement);
         this.setProperties();
      }
      
      private function onMouseDownHandle(event:MouseEvent) : void
      {
         var newWHRatio:Number = GameInfo.gameWidth / GameInfo.gameHeight;
         var oldWHRatio:Number = GameInfo.DEFAULT_WIDTH / GameInfo.DEFAULT_HEIGHT;
         this._dragRectangle.x = this._dragRectangle.y = 0;
         this._dragRectangle.width = stage.stageWidth - this.myLangBarGrip.width;
         this._dragRectangle.height = stage.stageHeight - this.myLangBarGrip.height;
         if(newWHRatio > oldWHRatio)
         {
            this._dragRectangle.width = GameInfo.gameWidth / (GameInfo.gameHeight / GameInfo.DEFAULT_HEIGHT) - this.myLangBarGrip.width;
            this._dragRectangle.x = (GameInfo.DEFAULT_WIDTH - stage.stageWidth) / 2;
         }
         else if(newWHRatio < oldWHRatio)
         {
            this._dragRectangle.height = GameInfo.gameHeight / (GameInfo.gameWidth / GameInfo.DEFAULT_WIDTH);
            this._dragRectangle.y = (GameInfo.DEFAULT_HEIGHT - stage.stageHeight) / 2;
         }
         this.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMoveHandle);
         this.stage.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUpHandle);
      }
      
      private function onMouseUpHandle(event:MouseEvent) : void
      {
         this.setPosition();
         this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMoveHandle);
         this.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUpHandle);
      }
      
      private function onMouseMoveHandle(event:MouseEvent) : void
      {
         this.setPosition();
      }
      
      private function setPosition() : void
      {
         this.myLangBarContainer.x = this.myLangBarGrip.x + this.myLangBarGrip.width;
         this.myLangBarContainer.y = this.myLangBarGrip.y;
         this.myStatusWindowContainer.x = this.myLangBarContainer.x + this.myLangBarContainer.width;
         this.myStatusWindowContainer.y = this.myLangBarContainer.y;
      }
      
      private function setInitPosition() : void
      {
         this.myLangBarGrip.x = GRIP_INIT_X;
         this.myLangBarGrip.y = GRIP_INIT_Y;
      }
      
      private function setProperties() : void
      {
         if(this._bLangBarLoaded && this._bStatusWindowLoaded)
         {
            this.setInitPosition();
            this.setPosition();
            if(this.myLangBarElement != null)
            {
               this.myLangBarElement.AddMouseDownToStage();
            }
         }
      }
      
      private function initCandidateListStyle() : void
      {
      }
      
      private function setCandidateListStyle() : void
      {
         if(this._candidateListStyleIndex < this._candidateListStyles.length - 1)
         {
            ++this._candidateListStyleIndex;
         }
         else
         {
            this._candidateListStyleIndex = 0;
         }
         IMEEx.setIMECandidateListStyle(this._candidateListStyles[this._candidateListStyleIndex]);
      }
      
      private function onSetIMEName(ev:IMEEventEx) : void
      {
         this.setPosition();
      }
      
      private function onFocusChanged(e:FocusEvent) : void
      {
         if(e.target is TextField == false)
         {
            return;
         }
         var tf:TextField = e.target as TextField;
         if(tf.type != TextFieldType.INPUT)
         {
            return;
         }
         if(e.type == FocusEvent.FOCUS_IN)
         {
            this.visible = true;
         }
         else if(e.type == FocusEvent.FOCUS_OUT)
         {
            this.visible = false;
         }
      }
   }
}

