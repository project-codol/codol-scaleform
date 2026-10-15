package codo.component.social
{
   import codo.component.Button;
   import codo.localization.Dict;
   import codo.style.ButtonGuide;
   import codo.style.TextStyle;
   import flash.display.MovieClip;
   
   public class PageListSelectorBtn extends Button
   {
      
      private static const LABEL_PADDING:int = 20;
      
      private static const BUTTON_WIDTH:int = 140;
      
      private static const BUTTON_HEIGHT:int = 37;
      
      private static const ARROW_PADDING:int = 20;
      
      public static const PREV_BTN:int = 0;
      
      public static const NEXT_BTN:int = 1;
      
      public var myArrow:MovieClip;
      
      private var mButtonType:int = 0;
      
      private var mButtonStyle:TextStyle;
      
      public function PageListSelectorBtn()
      {
         super();
      }
      
      override protected function initStage() : void
      {
         isInteractiveEnabled = true;
         this.mButtonStyle = ButtonGuide.stylePageSelectorButton;
         width = BUTTON_WIDTH;
         height = BUTTON_HEIGHT;
         myLabel.textStyle = this.mButtonStyle;
      }
      
      public function setButtonType(buttonType:int) : void
      {
         this.mButtonType = buttonType;
         if(this.mButtonType == PREV_BTN)
         {
            myLabel.alignment = TextStyle.HALIGN_RIGHT;
            label = Dict.PREVIOUS_PAGE;
            myLabel.x = BUTTON_WIDTH - LABEL_PADDING - myLabel.width;
            this.myArrow.x = ARROW_PADDING;
            this.myArrow.y = (BUTTON_HEIGHT - this.myArrow.height) * 0.5;
         }
         else
         {
            myLabel.alignment = TextStyle.HALIGN_LEFT;
            label = Dict.NEXT_PAGE;
            myLabel.x = LABEL_PADDING;
            this.myArrow.x = BUTTON_WIDTH - ARROW_PADDING - this.myArrow.width + this.myArrow.width;
            this.myArrow.y = (BUTTON_HEIGHT - this.myArrow.height) * 0.5 + this.myArrow.height;
         }
      }
      
      override public function set enabled(value:Boolean) : void
      {
         super.enabled = value;
         if(value)
         {
            this.alpha = 1;
         }
         else
         {
            this.endHighlight();
            this.alpha = 0.5;
         }
      }
   }
}

