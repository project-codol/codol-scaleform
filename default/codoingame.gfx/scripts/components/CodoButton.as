package components
{
   import components.interfaces.IUIComponent;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   import scaleform.gfx.TextFieldEx;
   
   public class CodoButton extends BaseButton implements IUIComponent
   {
      
      protected static const TF_ALPHA_NORMAL:Number = 1;
      
      protected static const TF_ALPHA_FOCUS:Number = 1;
      
      protected static const TF_ALPHA_DISABLE:Number = 1;
      
      public var myLabel:TextField;
      
      public var myBgNormal:MovieClip;
      
      public var myBgFocus:MovieClip;
      
      public var myBgDisable:Sprite;
      
      protected var _orgHitAreaWidth:Number;
      
      protected var _orgHitAreaHeight:Number;
      
      protected var _label:String = "label";
      
      public function CodoButton()
      {
         super();
      }
      
      override protected function onInit() : void
      {
         if(myHitArea != null)
         {
            this._orgHitAreaWidth = myHitArea.width;
            this._orgHitAreaHeight = myHitArea.height;
            if(this.myBgFocus != null)
            {
               this.myBgFocus.gotoAndStop(1);
               this.myBgFocus.mouseEnabled = false;
            }
            if(this.myBgDisable != null)
            {
               this.myBgDisable.mouseEnabled = false;
            }
            if(this.myBgNormal != null)
            {
               this.myBgNormal.mouseEnabled = false;
            }
         }
         this.resetScaleToRealSize();
         if(this.myLabel != null)
         {
            this.myLabel.mouseEnabled = false;
         }
         if(enable == true)
         {
            this.setToNormal(false);
         }
         else
         {
            this.setToDisable();
         }
         mouseEnabled = true;
         mouseChildren = true;
      }
      
      public function set label(cTxt:String) : void
      {
         this._label = cTxt;
         if(this.myLabel != null)
         {
            this.myLabel.text = this._label;
         }
      }
      
      override public function set width(value:Number) : void
      {
         super.width = value;
         this.resetScaleToRealSize();
      }
      
      override public function set height(value:Number) : void
      {
         super.height = value;
         this.resetScaleToRealSize();
      }
      
      public function vAlignToCenter() : void
      {
         if(this.myLabel != null)
         {
            TextFieldEx.setVerticalAlign(this.myLabel,TextFieldEx.VALIGN_CENTER);
         }
      }
      
      override protected function setToNormal(cTween:Boolean = true) : void
      {
         if(this.myBgNormal != null)
         {
            this.myBgNormal.visible = true;
         }
         if(this.myBgFocus != null)
         {
            this.myBgFocus.visible = false;
            this.myBgFocus.gotoAndStop(1);
         }
         if(this.myBgDisable != null)
         {
            this.myBgDisable.visible = false;
         }
         if(this.myLabel != null)
         {
            this.myLabel.alpha = TF_ALPHA_NORMAL;
         }
      }
      
      override protected function setToRollOver(cTween:Boolean = true) : void
      {
         if(this.myBgFocus != null)
         {
            this.myBgFocus.visible = true;
            this.myBgFocus.gotoAndPlay(1);
         }
         if(this.myBgNormal != null)
         {
            this.myBgNormal.visible = false;
         }
         if(this.myBgDisable != null)
         {
            this.myBgDisable.visible = false;
         }
         if(this.myLabel != null)
         {
            this.myLabel.alpha = TF_ALPHA_FOCUS;
         }
      }
      
      override protected function setToDisable() : void
      {
         this.myBgFocus.visible = false;
         if(this.myBgDisable != null)
         {
            if(this.myBgNormal != null)
            {
               this.myBgNormal.visible = false;
            }
            this.myBgDisable.visible = true;
         }
         if(this.myLabel != null)
         {
            this.myLabel.alpha = TF_ALPHA_DISABLE;
         }
      }
      
      protected function resetScaleToRealSize() : void
      {
         var targetScaleX:Number = NaN;
         var targetScaleY:Number = NaN;
         if(scaleX != 1 || scaleY != 1)
         {
            targetScaleX = scaleX;
            targetScaleY = scaleY;
            scaleX = 1;
            scaleY = 1;
            if(myHitArea != null)
            {
               myHitArea.width = this._orgHitAreaWidth * targetScaleX;
               myHitArea.height = this._orgHitAreaHeight * targetScaleY;
               this._orgHitAreaWidth = myHitArea.width;
               this._orgHitAreaHeight = myHitArea.height;
            }
            if(this.myLabel != null)
            {
               this.myLabel.width *= targetScaleX;
            }
            if(this.myBgNormal != null)
            {
               this.myBgNormal.width *= targetScaleX;
               this.myBgNormal.height *= targetScaleY;
            }
            if(this.myBgFocus != null)
            {
               this.myBgFocus.width *= targetScaleX;
               this.myBgFocus.height *= targetScaleY;
            }
            if(this.myBgDisable != null)
            {
               this.myBgDisable.width *= targetScaleX;
               this.myBgDisable.height *= targetScaleY;
            }
         }
      }
   }
}

