package codo.debugger
{
   import codo.component.Button;
   import codo.component.TextField;
   import codo.constants.GameInfo;
   import codo.style.GlobalGuide;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.KeyboardEvent;
   import flash.geom.Rectangle;
   import flash.ui.Keyboard;
   
   public class DebugEditor extends MovieClip
   {
      
      public static const SMALL_INCREMENT:int = 1;
      
      public static const MED_INCREMENT:int = 10;
      
      public static const LG_INCREMENT:int = 100;
      
      public static const INCREMENTS:Array = [SMALL_INCREMENT,MED_INCREMENT,LG_INCREMENT];
      
      private static const PROP_POSITION:String = "Position";
      
      private static const PROP_ROTATION:String = "Rotation";
      
      private static const PROP_ALPHA:String = "Alpha";
      
      private static const TEXT_MARGIN:Number = 2;
      
      public var myEditCompleteButton:Button;
      
      public var myEditModeLabel:TextField;
      
      public var myInstructions:TextField;
      
      public var myIncrementLabel:TextField;
      
      public var myBackground:Sprite;
      
      private var mCurrentTarget:MovieClip;
      
      private var mMoveIncrement:int;
      
      private var mCurrentIncrement:int;
      
      private var mOutline:Sprite;
      
      private var mEditCompleteCallback:Function;
      
      private var mPropertyToEdit:String;
      
      private var mOriginalProperties:Object;
      
      public function DebugEditor()
      {
         super();
         this.mCurrentIncrement = 0;
         this.mMoveIncrement = INCREMENTS[this.mCurrentIncrement];
         this.mPropertyToEdit = PROP_POSITION;
         this.mOriginalProperties = new Object();
         this.myEditCompleteButton.label = "FINISH";
         this.myEditCompleteButton.registerClickEvent(this.onEditComplete);
         this.myEditModeLabel.width = this.myIncrementLabel.width = 200;
         this.myInstructions.fontSize = this.myEditModeLabel.fontSize = this.myIncrementLabel.fontSize = GlobalGuide.FONT_SIZE_TINY;
         this.myEditModeLabel.fontColor = this.myInstructions.fontColor = this.myIncrementLabel.fontColor = GlobalGuide.CODO_BLACK;
         this.myInstructions.width = GameInfo.gameWidth;
         this.myInstructions.text = "(A)lpha   (R)otation   (P)osition   (V)isibility   (NUM +/-) Increment   (ESC) Cancel   (ENTER) Complete   (H)ide";
         this.updateIncrementLabel();
         this.myBackground.width = GameInfo.gameWidth;
         this.myEditCompleteButton.x = this.myBackground.width - this.myEditCompleteButton.width - GlobalGuide.COMPONENT_PADDING;
         this.myEditCompleteButton.y = this.myBackground.height * 0.5 - this.myEditCompleteButton.height * 0.5;
         this.myInstructions.y = this.myBackground.height * 0.5 - this.myInstructions.textHeight * 0.5 - GlobalGuide.COMPONENT_PADDING;
         this.myEditModeLabel.x = this.myInstructions.x = this.myBackground.x + GlobalGuide.COMPONENT_PADDING;
         this.myIncrementLabel.y = this.myEditModeLabel.y = this.myInstructions.y + this.myInstructions.textHeight + TEXT_MARGIN;
         this.myIncrementLabel.x = this.myEditModeLabel.x + this.myEditModeLabel.textWidth;
      }
      
      public function setTarget(target:MovieClip) : void
      {
         if(null != target)
         {
            this.mCurrentTarget = target;
            this.mOriginalProperties.alpha = this.mCurrentTarget.alpha;
            this.mOriginalProperties.x = this.mCurrentTarget.x;
            this.mOriginalProperties.y = this.mCurrentTarget.y;
            this.mOriginalProperties.rotation = this.mCurrentTarget.rotation;
            this.mOriginalProperties.visible = this.mCurrentTarget.visible;
         }
      }
      
      public function registerEditEndCallback(func:Function) : void
      {
         this.mEditCompleteCallback = func;
      }
      
      public function enable() : void
      {
         this.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.handleKeyEvent);
         var bounds:Rectangle = this.mCurrentTarget.getBounds(this.mCurrentTarget);
         this.mOutline = new Sprite();
         this.mOutline.graphics.lineStyle(2,16711680);
         this.mOutline.graphics.drawRect(bounds.x,bounds.y,bounds.width,bounds.height);
         this.mOutline.graphics.endFill();
         this.mCurrentTarget.addChild(this.mOutline);
         this.updateModeLabel();
      }
      
      public function disable() : void
      {
         var disp:MovieClip = null;
         if(null != stage)
         {
            stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.handleKeyEvent);
         }
         if(null != this.mCurrentTarget)
         {
            disp = this.mCurrentTarget as MovieClip;
            disp.removeChild(this.mOutline);
         }
      }
      
      override public function get height() : Number
      {
         return this.myBackground.height;
      }
      
      private function updateModeLabel() : void
      {
         var postFix:String = "";
         switch(this.mPropertyToEdit)
         {
            case PROP_POSITION:
               postFix = "x: " + this.mCurrentTarget.x + " y: " + this.mCurrentTarget.y;
               break;
            case PROP_ROTATION:
               postFix = this.mCurrentTarget.rotation.toString();
               break;
            case PROP_ALPHA:
               postFix = this.mCurrentTarget.alpha.toString();
         }
         this.myEditModeLabel.text = this.mPropertyToEdit + " " + postFix;
         this.myIncrementLabel.x = this.myEditModeLabel.x + this.myEditModeLabel.textWidth + GlobalGuide.COMPONENT_PADDING;
      }
      
      private function handleKeyEvent(evt:KeyboardEvent) : void
      {
         var disp:MovieClip = null;
         switch(this.mPropertyToEdit)
         {
            case PROP_POSITION:
               this.handleMovementKeys(evt.keyCode);
               break;
            case PROP_ROTATION:
               this.handleRotationKeys(evt.keyCode);
               break;
            case PROP_ALPHA:
               this.handleAlphaKeys(evt.keyCode);
         }
         switch(evt.keyCode)
         {
            case Keyboard.NUMPAD_ADD:
               this.increaseIncrement();
               break;
            case Keyboard.NUMPAD_SUBTRACT:
               this.decreaseIncrement();
               break;
            case Keyboard.ESCAPE:
               this.onEditCancel();
               break;
            case Keyboard.ENTER:
               this.onEditComplete();
               break;
            case Keyboard.A:
               this.mPropertyToEdit = PROP_ALPHA;
               break;
            case Keyboard.R:
               this.mPropertyToEdit = PROP_ROTATION;
               break;
            case Keyboard.P:
               this.mPropertyToEdit = PROP_POSITION;
               break;
            case Keyboard.V:
               disp = this.mCurrentTarget as MovieClip;
               disp.visible = !disp.visible;
         }
         this.updateModeLabel();
      }
      
      private function handleMovementKeys(keyCode:uint) : void
      {
         switch(keyCode)
         {
            case Keyboard.UP:
               this.mCurrentTarget.y -= this.mMoveIncrement;
               break;
            case Keyboard.DOWN:
               this.mCurrentTarget.y += this.mMoveIncrement;
               break;
            case Keyboard.LEFT:
               this.mCurrentTarget.x -= this.mMoveIncrement;
               break;
            case Keyboard.RIGHT:
               this.mCurrentTarget.x += this.mMoveIncrement;
         }
      }
      
      private function handleRotationKeys(keyCode:uint) : void
      {
         switch(keyCode)
         {
            case Keyboard.LEFT:
               this.mCurrentTarget.rotation -= this.mMoveIncrement;
               break;
            case Keyboard.RIGHT:
               this.mCurrentTarget.rotation += this.mMoveIncrement;
         }
      }
      
      private function handleAlphaKeys(keyCode:uint) : void
      {
         var newAlpha:Number = NaN;
         switch(keyCode)
         {
            case Keyboard.UP:
               newAlpha = this.mCurrentTarget.alpha + this.mMoveIncrement * 0.1;
               if(newAlpha > 1)
               {
                  newAlpha = 1;
               }
               this.mCurrentTarget.alpha = newAlpha;
               break;
            case Keyboard.DOWN:
               newAlpha = this.mCurrentTarget.alpha - this.mMoveIncrement * 0.1;
               if(newAlpha < 0)
               {
                  newAlpha = 0;
               }
               this.mCurrentTarget.alpha = newAlpha;
         }
      }
      
      private function increaseIncrement() : void
      {
         ++this.mCurrentIncrement;
         if(this.mCurrentIncrement > INCREMENTS.length - 1)
         {
            this.mCurrentIncrement = 0;
         }
         this.mMoveIncrement = INCREMENTS[this.mCurrentIncrement];
         this.updateIncrementLabel();
      }
      
      private function decreaseIncrement() : void
      {
         --this.mCurrentIncrement;
         if(this.mCurrentIncrement < 0)
         {
            this.mCurrentIncrement = INCREMENTS.length - 1;
         }
         this.mMoveIncrement = INCREMENTS[this.mCurrentIncrement];
         this.updateIncrementLabel();
      }
      
      private function updateIncrementLabel() : void
      {
         this.myIncrementLabel.text = "Increment Size: " + this.mMoveIncrement.toString() + "px";
      }
      
      private function onEditComplete() : void
      {
         this.mEditCompleteCallback();
      }
      
      private function onEditCancel() : void
      {
         if(null != this.mCurrentTarget)
         {
            this.mCurrentTarget.alpha = this.mOriginalProperties.alpha;
            this.mCurrentTarget.x = this.mOriginalProperties.x;
            this.mCurrentTarget.y = this.mOriginalProperties.y;
            this.mCurrentTarget.rotation = this.mOriginalProperties.rotation;
            this.mCurrentTarget.visible = this.mOriginalProperties.visible;
         }
         this.mEditCompleteCallback();
      }
   }
}

