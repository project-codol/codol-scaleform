package codo.component
{
   import codo.style.GlobalGuide;
   import codo.utils.ScaleformUtil;
   import flash.display.Sprite;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   import flash.text.TextFieldAutoSize;
   import fsg.util.FsgImageHolder;
   
   public class IconButton extends Button
   {
      
      public var myIcon:FsgImageHolder;
      
      public var myWarningIcon:Sprite;
      
      private var mIconColorOn:ColorTransform;
      
      private var mIconColorOff:ColorTransform;
      
      private var mIconButtonWidth:Number = 67;
      
      private var mIconButtonHeight:Number = 42;
      
      private var mLabelPadding:Number = 11;
      
      private var mIconPadding:Number = 4;
      
      private var mSwapIconAlignment:Boolean = false;
      
      public function IconButton()
      {
         super();
         this.setMarketReadyMode(false);
         this.mIconColorOn = new ColorTransform();
         this.mIconColorOn.color = GlobalGuide.BLACK;
         this.mIconColorOff = new ColorTransform();
         this.mIconColorOff.color = GlobalGuide.WHITE;
         this.myIcon.transform.colorTransform = this.mIconColorOff;
         myLabel.visible = false;
         myLabel.autoSize = TextFieldAutoSize.LEFT;
      }
      
      public function set customIconButtonSize(size:Point) : void
      {
         var TXT_OFFSET:int = 2;
         this.mIconButtonWidth = size.x;
         this.mIconButtonHeight = size.y;
         this.draw();
         myLabel.y = myBackground.y - this.mIconButtonHeight + (this.mIconButtonHeight - myLabel.textHeight) * 0.5 - TXT_OFFSET;
      }
      
      public function setImage(image:String) : void
      {
         if(!ScaleformUtil.isScaleform)
         {
            return;
         }
         this.myIcon.setImage(image);
         this.draw();
      }
      
      public function setMarketReadyMode(isReady:Boolean) : void
      {
         mClickable.setEnabled(isReady);
         this.myWarningIcon.visible = !isReady;
         this.myIcon.alpha = isReady ? 1 : 0.2;
      }
      
      public function setLabelPadding(p:Number) : void
      {
         this.mLabelPadding = p;
      }
      
      public function setIconPadding(p:Number) : void
      {
         this.mIconPadding = p;
      }
      
      public function swapIconAlignment(swap:Boolean) : void
      {
         this.mSwapIconAlignment = swap;
      }
      
      override public function set label(label:String) : void
      {
         myLabel.text = label;
         myLabel.width = myLabel.textWidth;
         myLabel.visible = true;
      }
      
      override public function setData(data:*) : void
      {
         super.setData(data);
         if(null != data.image)
         {
            this.setImage(data.image);
         }
      }
      
      override public function draw() : void
      {
         var buttonWidth:Number = NaN;
         super.draw();
         this.myIcon.y = (this.mIconButtonHeight - this.myIcon.height) / 2;
         myBackground.height = this.mIconButtonHeight - 2;
         myOutline.height = this.mIconButtonHeight;
         if(myLabel.visible)
         {
            buttonWidth = 0;
            if(!this.mSwapIconAlignment)
            {
               this.myIcon.x = myLabel.x + myLabel.textWidth + this.mIconPadding;
               buttonWidth = myLabel.textWidth + myLabel.x + this.myIcon.width + this.mLabelPadding + this.mIconPadding;
            }
            else
            {
               this.myIcon.x = 8;
               myLabel.x = this.myIcon.x + this.myIcon.width + 2;
               buttonWidth = myLabel.textWidth + this.myIcon.x + this.myIcon.width + this.mLabelPadding + this.mIconPadding - 5;
            }
            myHitArea.width = buttonWidth;
            myOutline.width = buttonWidth;
            myBackground.width = buttonWidth - 2;
            myTabAccent.x = (buttonWidth - myTabAccent.width) / 2;
         }
         else
         {
            this.myIcon.x = (this.mIconButtonWidth - this.myIcon.width) / 2;
            myHitArea.width = this.mIconButtonWidth;
            myOutline.width = this.mIconButtonWidth;
            myBackground.width = this.mIconButtonWidth - 2;
            myTabAccent.x = (this.mIconButtonWidth - myTabAccent.width) / 2;
         }
      }
      
      override protected function showHighlight() : void
      {
         super.showHighlight();
         this.myIcon.transform.colorTransform = this.mIconColorOn;
      }
      
      override protected function endHighlight() : void
      {
         super.endHighlight();
         this.myIcon.transform.colorTransform = this.mIconColorOff;
      }
   }
}

