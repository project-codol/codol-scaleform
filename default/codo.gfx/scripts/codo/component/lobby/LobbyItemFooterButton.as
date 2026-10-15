package codo.component.lobby
{
   import codo.component.Button;
   import codo.component.TextField;
   import codo.localization.DictMarket;
   import codo.objects.ProductObj;
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   import codo.utils.CursorUtil;
   
   public class LobbyItemFooterButton extends Button
   {
      
      public static var BUY_FRAME:int = 2;
      
      public var myTextField:TextField;
      
      private var product:ProductObj = null;
      
      private var mCallback:Function = null;
      
      public function LobbyItemFooterButton()
      {
         super();
         gotoAndStop(BUY_FRAME);
         width = 92;
         this.myTextField.width = 92;
         this.myTextField.alignment = TextStyle.HALIGN_CENTER;
         this.myTextField.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         this.myTextField.text = DictMarket.BUY;
         mTextClickColor = GlobalGuide.WHITE;
      }
      
      public function setCallback(f:Function) : void
      {
         this.mCallback = f;
      }
      
      public function setProduct(p:ProductObj) : void
      {
         this.product = p;
      }
      
      override protected function onMouseClick() : void
      {
         super.onMouseClick();
         if(this.mCallback != null)
         {
            this.mCallback(this.product);
         }
      }
      
      override protected function onMouseClickUp() : void
      {
         super.onMouseClickUp();
         this.onMouseOut();
      }
      
      override protected function onMouseOver() : void
      {
         CursorUtil.BeginCursor(CursorUtil.CURSOR_OVER_BUTTON);
         myBackground.gotoAndStop(2);
         this.myTextField.fontColor = mTextFocusColor;
      }
      
      override protected function onMouseOut() : void
      {
         CursorUtil.EndCursor(CursorUtil.CURSOR_OVER_BUTTON);
         myBackground.gotoAndStop(1);
         this.myTextField.fontColor = mTextUnfocusColor;
      }
   }
}

