package fsg.shared.popups
{
   import com.greensock.TweenLite;
   import com.greensock.easing.Cubic;
   import components.fsgpopups_part.FsgPopupBaseFrameAnimated;
   import components.fsgpopups_part.FsgPopupBaseSubheader;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   public class PopupStyleBase extends Sprite
   {
      
      private static const CONTENT_PADDING:uint = 36;
      
      public var myFrameStatic:Sprite;
      
      public var myFrameAnimated:FsgPopupBaseFrameAnimated;
      
      public var myBackgroundImageHolder:Sprite;
      
      public var myHeaderText:TextField;
      
      public var mySubHeader:FsgPopupBaseSubheader;
      
      public var myPopupConfirmBtn:PopupButtonShared;
      
      public var myPopupCancelBtn:PopupButtonShared;
      
      public var myPopupAuxiliaryBtn:PopupButtonShared;
      
      public var myContentBackground:Sprite;
      
      private var mBaseWidth:uint;
      
      private var mBaseHeight:uint;
      
      private var mPopupButtons:Vector.<PopupButtonShared>;
      
      public function PopupStyleBase()
      {
         var asset:DisplayObject = null;
         super();
         this.mBaseWidth = this.myContentBackground.width;
         this.mBaseHeight = this.myContentBackground.height;
         this.myFrameAnimated.visible = this.myPopupConfirmBtn.visible = this.myPopupCancelBtn.visible = this.myPopupAuxiliaryBtn.visible = this.myHeaderText.visible = false;
         this.myHeaderText.autoSize = TextFieldAutoSize.LEFT;
         for each(asset in this)
         {
            asset.visible = false;
         }
         this.mPopupButtons = new <PopupButtonShared>[this.myPopupConfirmBtn,this.myPopupCancelBtn,this.myPopupAuxiliaryBtn];
         this.animateFrame = false;
      }
      
      public function get confirmButtonRef() : PopupButtonShared
      {
         return this.myPopupConfirmBtn;
      }
      
      public function get cancelButtonRef() : PopupButtonShared
      {
         return this.myPopupCancelBtn;
      }
      
      public function get auxiliaryButtonRef() : PopupButtonShared
      {
         return this.myPopupAuxiliaryBtn;
      }
      
      public function autosizeButtonToText() : void
      {
         if(!this.isButtonVisible)
         {
            return;
         }
         var maxWidth:uint = 0;
         var MAX:Function = Math.max;
         var PADDING:uint = 20;
         maxWidth = MAX(maxWidth,MAX(this.myPopupConfirmBtn.txtField.textWidth,MAX(this.myPopupCancelBtn.txtField.textWidth,this.myPopupAuxiliaryBtn.txtField.textWidth)));
         this.myPopupConfirmBtn.setButtonToTextWidth(maxWidth + PADDING);
         this.myPopupCancelBtn.setButtonToTextWidth(maxWidth + PADDING);
         this.myPopupAuxiliaryBtn.setButtonToTextWidth(maxWidth + PADDING);
         this.flowButtonXPos();
      }
      
      private function get isButtonVisible() : Boolean
      {
         return this.myPopupConfirmBtn.visible || this.myPopupCancelBtn.visible || this.myPopupAuxiliaryBtn.visible;
      }
      
      public function setBackgroundImage(className:Class, fitToFrame:Boolean = true) : void
      {
         var libraryImage:Bitmap = null;
         libraryImage = new Bitmap(new className(0,0));
         if(fitToFrame)
         {
            libraryImage.width = this.myFrameStatic.width;
            libraryImage.height = this.myFrameStatic.height;
         }
         this.myBackgroundImageHolder.addChild(libraryImage);
         this.myBackgroundImageHolder.visible = true;
      }
      
      public function set headerText(txt:String) : void
      {
         this.myHeaderText.text = txt;
         this.myHeaderText.visible = true;
         this.myHeaderText.y = -this.myHeaderText.textHeight;
      }
      
      public function set subheaderText(txt:String) : void
      {
         this.mySubHeader.subheaderText = txt;
         this.mySubHeader.visible = true;
      }
      
      public function set animateFrame(doAnimation:Boolean) : void
      {
         this.myFrameAnimated.visible = doAnimation;
         this.myFrameStatic.visible = !doAnimation;
      }
      
      public function get contentInnerWidth() : uint
      {
         return this.myContentBackground.width;
      }
      
      public function get contentInnerHeight() : uint
      {
         return this.myContentBackground.height;
      }
      
      public function get contentWidth() : uint
      {
         return this.myFrameStatic.width;
      }
      
      public function delayButtons() : void
      {
         var btn:PopupButtonShared = null;
         for each(btn in this.mPopupButtons)
         {
            if(btn.visible)
            {
               btn.setEnabled(false);
               btn.alpha = 0;
            }
         }
      }
      
      public function postDelayRevealButtons() : void
      {
         var btn:PopupButtonShared = null;
         var FADE_SPEED:uint = 1;
         for each(btn in this.mPopupButtons)
         {
            if(btn.visible)
            {
               btn.setEnabled(true);
               TweenLite.to(btn,FADE_SPEED,{
                  "alpha":1,
                  "ease":Cubic.easeOut
               });
            }
         }
      }
      
      public function get contentHeight() : uint
      {
         var ASSET_PADDING:uint = 10;
         var headerHeight:uint = this.myHeaderText.visible ? uint(this.myHeaderText.textHeight) : 0;
         var btnHeight:uint = this.myPopupConfirmBtn.visible || this.myPopupCancelBtn.visible ? uint(this.myPopupConfirmBtn.height + ASSET_PADDING) : 0;
         return this.myFrameStatic.height + btnHeight - headerHeight;
      }
      
      public function get contentPosition() : Point
      {
         return new Point(this.myContentBackground.x,this.myContentBackground.y);
      }
      
      private function configButton(btn:PopupButtonShared, label:String, clickEvent:Function) : void
      {
         if(clickEvent == null)
         {
            this.clearButton(btn);
            return;
         }
         btn.setEnabled(true);
         btn.setText(label);
         btn.clickCallback = clickEvent;
         btn.visible = true;
      }
      
      public function configConfirmButton(label:String = null, clickEvent:Function = null) : void
      {
         this.configButton(this.myPopupConfirmBtn,label,clickEvent);
         this.autosizeButtonToText();
      }
      
      public function configCancelButton(label:String = null, clickEvent:Function = null) : void
      {
         this.configButton(this.myPopupCancelBtn,label,clickEvent);
         this.autosizeButtonToText();
      }
      
      public function configAuxiliaryButton(label:String = null, clickEvent:Function = null) : void
      {
         this.configButton(this.myPopupAuxiliaryBtn,label,clickEvent);
         this.autosizeButtonToText();
      }
      
      public function resetButtons() : void
      {
         this.clearButton(this.myPopupConfirmBtn);
         this.clearButton(this.myPopupCancelBtn);
         this.clearButton(this.myPopupAuxiliaryBtn);
      }
      
      public function clearButton(btn:PopupButtonShared) : void
      {
         btn.clearClickEvent();
         btn.visible = false;
      }
      
      public function setSize(w:int = -1, h:int = -1) : void
      {
         var rnd:Function = Math.round;
         var BUTTON_PADDING_VERT:uint = 10;
         if(w > -1)
         {
            this.myFrameStatic.width = w;
            this.myContentBackground.scaleX = (w - CONTENT_PADDING) / this.mBaseWidth;
            this.myContentBackground.x = rnd(this.myFrameStatic.x + (this.myFrameStatic.width * 0.5 - this.myContentBackground.width * 0.5));
         }
         if(h > -1)
         {
            this.myFrameStatic.height = h;
            this.myContentBackground.scaleY = (h - CONTENT_PADDING) / this.mBaseHeight;
            this.myContentBackground.y = rnd(this.myFrameStatic.y + (this.myFrameStatic.height * 0.5 - this.myContentBackground.height * 0.5));
         }
         this.myPopupConfirmBtn.y = this.myPopupAuxiliaryBtn.y = this.myPopupCancelBtn.y = this.myFrameStatic.y + this.myFrameStatic.height + BUTTON_PADDING_VERT;
         this.mySubHeader.x = this.myContentBackground.x;
         this.mySubHeader.y = this.myContentBackground.y;
         this.mySubHeader.setSize(this.myContentBackground.width,this.myContentBackground.height);
         this.myFrameAnimated.setSize(w,h);
      }
      
      public function flowButtonXPos() : void
      {
         var BUTTON_PADDING_HORIZ:uint = 5;
         var rnd:Function = Math.round;
         var w:uint = this.myFrameStatic.width;
         this.myPopupConfirmBtn.x = rnd(w - this.myPopupConfirmBtn.width);
         this.myPopupCancelBtn.x = this.myPopupConfirmBtn.visible ? rnd(this.myPopupConfirmBtn.x - this.myPopupConfirmBtn.width) - BUTTON_PADDING_HORIZ : Number(rnd(w - this.myPopupCancelBtn.width));
         this.myPopupAuxiliaryBtn.x = rnd(this.myPopupCancelBtn.x - this.myPopupCancelBtn.width) - BUTTON_PADDING_HORIZ;
      }
   }
}

