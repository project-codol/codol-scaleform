package codo.component
{
   import codo.component.factory.ButtonFactory;
   import codo.component.popup.PopupHeader;
   import codo.localization.Dict;
   import codo.utils.LocalizeUtil;
   import com.greensock.TweenLite;
   import com.greensock.easing.Cubic;
   
   public class Popup extends ContentContainerSimple
   {
      
      private static const PADDING:uint = 24;
      
      private static const BUTTON_PADDING:uint = 5;
      
      public static const CORNER_WIDTH:uint = 14;
      
      public var myHeaderbar:PopupHeader;
      
      public var myCloseButton:CloseButton;
      
      private var mPopupButtons:Vector.<Button>;
      
      public var keepBogusHeightCode:Boolean = true;
      
      public function Popup()
      {
         super();
         this.mPopupButtons = new Vector.<Button>(0);
         setBackgroundColorLight();
      }
      
      public function get header() : PopupHeader
      {
         return this.myHeaderbar;
      }
      
      override public function set width(value:Number) : void
      {
         super.width = value;
         var OFFSET:uint = 5;
         this.myHeaderbar.width = mWidth - (this.myHeaderbar.x + CORNER_WIDTH);
         this.myCloseButton.x = value - this.myCloseButton.width + OFFSET;
         this.myCloseButton.y = -OFFSET;
      }
      
      override public function set height(value:Number) : void
      {
         var btn:Button = null;
         var newHeight:uint = value;
         if(this.hasButtons && this.keepBogusHeightCode)
         {
            newHeight += this.mPopupButtons[0].height;
         }
         super.height = newHeight;
         for each(btn in this.mPopupButtons)
         {
            btn.y = newHeight;
         }
      }
      
      public function get popupWidth() : uint
      {
         return mWidth - PADDING;
      }
      
      public function get popupHeight() : uint
      {
         return mHeight;
      }
      
      public function setErrorMode(killMethod:Function) : void
      {
         this.resetButtons();
         this.configConfirmButton(Dict.CONTINUE,killMethod);
      }
      
      public function configConfirmButton(label:String = null, clickEvent:Function = null, isPurchaseButton:Boolean = false, clickOverrideSoundID:String = null) : void
      {
         this.configButton(label,clickEvent,clickOverrideSoundID,isPurchaseButton);
      }
      
      public function configCancelButton(label:String = null, clickEvent:Function = null, clickOverrideSoundID:String = null) : void
      {
         this.configButton(label,clickEvent,clickOverrideSoundID);
      }
      
      public function configAuxiliaryButton(label:String = null, clickEvent:Function = null, clickOverrideSoundID:String = null) : void
      {
         this.configButton(label,clickEvent,clickOverrideSoundID);
      }
      
      public function getButtonByIndex(index:int) : Button
      {
         return this.mPopupButtons[index];
      }
      
      private function setClickOverride(btn:Button, SE_ID:String = null) : void
      {
         if(SE_ID == null)
         {
            return;
         }
         btn.audioRef.overrideClickAudio(SE_ID);
      }
      
      public function get hasButtons() : Boolean
      {
         return Boolean(this.mPopupButtons) && this.mPopupButtons.length > 0;
      }
      
      public function get buttonHeight() : uint
      {
         return this.mPopupButtons[0].height;
      }
      
      private function configButton(label:String, clickEvent:Function, clickOverrideSoundID:String, isPurchaseButton:Boolean = false) : Button
      {
         var btn:Button = null;
         var prevBtn:Button = null;
         var btnTxt:String = LocalizeUtil.localize(label);
         var buildMethod:Function = ButtonFactory.BUILD_POPUP_BUTTON;
         if(isPurchaseButton)
         {
            buildMethod = ButtonFactory.BUILD_CALL_TO_ACTION_BUTTON;
         }
         btn = addChild(buildMethod()) as Button;
         btn.enabled = true;
         btn.label = btnTxt;
         btn.setClickCallback(clickEvent);
         btn.visible = true;
         btn.y = myBackground.height - BUTTON_PADDING;
         btn.width = btn.myLabel.textWidth + PADDING;
         if(this.mPopupButtons.length >= 1)
         {
            prevBtn = this.mPopupButtons[this.mPopupButtons.length - 1];
            btn.x = prevBtn.x - (btn.width + BUTTON_PADDING);
         }
         else
         {
            btn.x = myBackground.x + myBackground.width - btn.width - CORNER_WIDTH;
         }
         this.mPopupButtons.push(btn);
         this.setClickOverride(btn,clickOverrideSoundID);
         return btn;
      }
      
      public function resetButtons() : void
      {
         var btn:Button = null;
         for each(btn in this.mPopupButtons)
         {
            btn.dispose();
            btn.visible = false;
         }
         this.mPopupButtons.length = 0;
      }
      
      public function disableButtons(hideBtn:Boolean = false) : void
      {
         var btn:Button = null;
         for each(btn in this.mPopupButtons)
         {
            if(hideBtn)
            {
               btn.alpha = 0;
            }
            btn.enabled = false;
         }
      }
      
      public function enableButtons(showBtn:Boolean = false) : void
      {
         var btn:Button = null;
         for each(btn in this.mPopupButtons)
         {
            if(showBtn)
            {
               TweenLite.to(btn,1,{
                  "alpha":1,
                  "ease":Cubic.easeOut
               });
            }
            btn.enabled = true;
         }
      }
   }
}

