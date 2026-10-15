package codo.component
{
   import codo.component.core.UIInteractiveComponent;
   import codo.interfaces.ISelectable;
   import codo.style.ButtonGuide;
   import codo.utils.CursorUtil;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class Button extends UIInteractiveComponent implements ISelectable
   {
      
      public static const UP_STATE_FRAME:int = 1;
      
      protected static const OVER_STATE_FRAME:int = 2;
      
      protected static const DOWN_STATE_FRAME:int = 3;
      
      protected static const DISABLED_STATE_FRAME:int = 4;
      
      protected static const BUTTON_GUTTER:uint = 20;
      
      protected static const ACCENT_OFFSET_X:Number = 1;
      
      protected static const ACCENT_FOCUS_SHAPE_WIDTH_OFFSET:Number = 4;
      
      protected static const BACKGROUND_SIZE_OFFSET:Number = 2;
      
      public var myLabel:TextField;
      
      public var myBackground:MovieClip;
      
      public var myOutline:MovieClip;
      
      public var myTabAccent:Sprite;
      
      protected var mIndex:int = 0;
      
      protected var mWidth:Number;
      
      protected var mHeight:Number;
      
      protected var mToggled:Boolean = false;
      
      protected var mTextFocusColor:uint = 1118481;
      
      protected var mTextUnfocusColor:uint = 16777215;
      
      protected var mTextClickColor:uint = 4375548;
      
      protected var mUpStateFrame:int = 1;
      
      private var mToggleBtnIcon:Sprite;
      
      public function Button()
      {
         super();
         isInteractiveEnabled = true;
         this.initStage();
         this.draw();
      }
      
      protected function initStage() : void
      {
         if(null != this.myLabel)
         {
            this.myLabel.textStyle = ButtonGuide.styleButtonCommon;
            this.myLabel.fontColor = this.mTextUnfocusColor;
         }
         this.width = myHitArea.width;
         this.height = myHitArea.height;
      }
      
      public function set upStateFrame(f:int) : void
      {
         this.mUpStateFrame = f;
      }
      
      public function get buttonToggleIcon() : Sprite
      {
         return this.mToggleBtnIcon;
      }
      
      public function set buttonToggleIcon(icon:Sprite) : void
      {
         if(this.mToggleBtnIcon != null)
         {
            removeChild(this.mToggleBtnIcon);
         }
         this.mToggleBtnIcon = addChild(icon) as Sprite;
         this.mToggleBtnIcon.mouseEnabled = false;
      }
      
      public function set hasNoLabel(value:Boolean) : void
      {
         this.myLabel.visible = !value;
      }
      
      public function dispose() : void
      {
         mClickable.dispose();
      }
      
      override public function setData(data:*) : void
      {
         super.setData(data);
         if(data == null)
         {
            return;
         }
         if(null != data.index)
         {
            this.index = data.index;
         }
         if(null != data.label)
         {
            this.label = data.label;
         }
         if(null != data.clickEvent)
         {
            registerClickEvent(data.clickEvent,data.clickEventData);
         }
      }
      
      public function set labelFocusColor(c:Number) : void
      {
         this.mTextFocusColor = c;
      }
      
      public function set labelUnfocusColor(c:Number) : void
      {
         this.mTextUnfocusColor = c;
      }
      
      public function set labelClickColor(c:Number) : void
      {
         this.mTextClickColor = c;
      }
      
      public function set label(label:String) : void
      {
         if(this.myLabel != null)
         {
            this.myLabel.text = label;
         }
      }
      
      public function get label() : String
      {
         return this.myLabel.text;
      }
      
      public function set index(idx:int) : void
      {
         this.mIndex = idx;
      }
      
      public function get index() : int
      {
         return this.mIndex;
      }
      
      public function get toggled() : Boolean
      {
         return this.mToggled;
      }
      
      public function setToggled(toggled:Boolean) : void
      {
         this.mToggled = toggled;
         if(this.mToggled)
         {
            if(this.myLabel != null)
            {
               this.myLabel.fontColor = this.mTextFocusColor;
            }
            if(this.myBackground != null)
            {
               this.myBackground.gotoAndStop(OVER_STATE_FRAME);
            }
         }
         else
         {
            if(this.myLabel != null)
            {
               this.myLabel.fontColor = this.mTextUnfocusColor;
            }
            if(this.myBackground != null)
            {
               this.myBackground.gotoAndStop(this.mUpStateFrame);
            }
         }
         this.enabled = mClickable.isEnabled();
      }
      
      override public function set width(w:Number) : void
      {
         if(null != this.myLabel)
         {
            this.myLabel.width = myHitArea.width = this.mWidth = w;
         }
         else
         {
            myHitArea.width = this.mWidth = w;
         }
         this.draw();
      }
      
      override public function set height(h:Number) : void
      {
         this.mHeight = h;
         this.draw();
      }
      
      public function draw() : void
      {
         if(null != this.myBackground)
         {
            this.myBackground.width = this.mWidth - BACKGROUND_SIZE_OFFSET;
            this.myBackground.height = this.mHeight - BACKGROUND_SIZE_OFFSET;
         }
         if(null != this.myTabAccent)
         {
            this.myTabAccent.x = this.mWidth * 0.5 - this.myTabAccent.width * 0.5;
         }
         if(null != this.myOutline)
         {
            this.myOutline.width = this.mWidth;
            this.myOutline.height = this.mHeight;
         }
         myHitArea.width = this.mWidth;
         myHitArea.height = this.mHeight;
         if(null != this.myLabel)
         {
            this.myLabel.width = myHitArea.width;
            this.myLabel.height = myHitArea.height;
         }
         myHitArea.width = this.mWidth;
      }
      
      public function forceShowHighlight() : void
      {
         this.showHighlight();
      }
      
      public function forceEndHighlight() : void
      {
         this.endHighlight();
      }
      
      public function setLabelFontSize(size:Number) : void
      {
         this.myLabel.fontSize = size;
      }
      
      protected function shouldShowHighlight() : Boolean
      {
         return !this.mToggled;
      }
      
      protected function showHighlight() : void
      {
         if(this.hasBackgroundAsset())
         {
            this.myBackground.gotoAndStop(OVER_STATE_FRAME);
         }
         if(null != this.myLabel)
         {
            this.myLabel.fontColor = this.mTextFocusColor;
         }
      }
      
      protected function endHighlight() : void
      {
         if(this.hasBackgroundAsset())
         {
            this.myBackground.gotoAndStop(this.mUpStateFrame);
         }
         if(null != this.myLabel)
         {
            this.myLabel.fontColor = this.mTextUnfocusColor;
         }
      }
      
      protected function showClickState() : void
      {
         if(this.hasBackgroundAsset())
         {
            this.myBackground.gotoAndStop(DOWN_STATE_FRAME);
         }
         if(null != this.myLabel)
         {
            this.myLabel.fontColor = this.mTextClickColor;
         }
      }
      
      override protected function onMouseOver() : void
      {
         CursorUtil.BeginCursor(CursorUtil.CURSOR_OVER_BUTTON);
         if(this.shouldShowHighlight())
         {
            this.showHighlight();
         }
      }
      
      override protected function onMouseOut() : void
      {
         CursorUtil.EndCursor(CursorUtil.CURSOR_OVER_BUTTON);
         if(this.shouldShowHighlight())
         {
            this.endHighlight();
         }
      }
      
      override protected function onMouseClick() : void
      {
         if(this.shouldShowHighlight())
         {
            this.showClickState();
         }
      }
      
      override protected function onMouseClickUp() : void
      {
         if(this.shouldShowHighlight())
         {
            if(myHitArea.hitTestPoint(stage.mouseX,stage.mouseY) == false)
            {
               if(this.hasBackgroundAsset())
               {
                  this.myBackground.gotoAndStop(this.mUpStateFrame);
               }
            }
            else
            {
               this.showHighlight();
            }
         }
      }
      
      private function hasBackgroundAsset() : Boolean
      {
         return this.myBackground != null;
      }
      
      public function get selected() : Boolean
      {
         return this.toggled;
      }
      
      public function set selected(newSelected:Boolean) : void
      {
         this.setToggled(newSelected);
      }
      
      override public function set enabled(enabled:Boolean) : void
      {
         super.enabled = enabled;
         if(!enabled)
         {
            this.endHighlight();
         }
      }
   }
}

