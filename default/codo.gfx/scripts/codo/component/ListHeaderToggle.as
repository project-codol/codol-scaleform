package codo.component
{
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   import flash.display.MovieClip;
   
   public class ListHeaderToggle extends ListHeader
   {
      
      private static const CLOSED_FRAME:int = 1;
      
      private static const OVER_STATE_FRAME:int = 2;
      
      private static const OPEN_FRAME:int = 3;
      
      private static const LABEL_X:Number = 35;
      
      private static const LABEL_Y:Number = 6;
      
      private static const ARROW_UNFOCUS_FRAME:int = 1;
      
      private static const ARROW_FOCUS_FRAME:int = 2;
      
      public var myCount:TextField;
      
      public var myArrow:MovieClip;
      
      private var mToggled:Boolean = false;
      
      public function ListHeaderToggle()
      {
         super();
         isInteractiveEnabled = true;
         myLabel.x = LABEL_X;
         this.myCount.x = myLabel.x - GlobalGuide.COMPONENT_PADDING;
         myLabel.y = LABEL_Y;
         this.myCount.y = LABEL_Y;
         myLabel.fontColor = GlobalGuide.CODO_BLUE_HIGHLIGHT;
         myLabel.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         this.myCount.fontColor = GlobalGuide.CODO_BLUE_HIGHLIGHT;
         this.myCount.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         this.myCount.alignment = TextStyle.HALIGN_RIGHT;
         this.myArrow.gotoAndStop(ARROW_UNFOCUS_FRAME);
         myBackground.alpha = 1;
      }
      
      public function set toggled(t:Boolean) : void
      {
         this.mToggled = t;
         if(true == this.mToggled)
         {
            myBackground.gotoAndStop(OPEN_FRAME);
            this.myArrow.gotoAndStop(ARROW_FOCUS_FRAME);
         }
         else
         {
            myBackground.gotoAndStop(CLOSED_FRAME);
            this.myArrow.gotoAndStop(ARROW_UNFOCUS_FRAME);
         }
      }
      
      public function get toggled() : Boolean
      {
         return this.mToggled;
      }
      
      override public function setData(data:*) : void
      {
         super.setData(data);
         if(null != data.count)
         {
            this.myCount.text = data.count;
            this.myCount.visible = true;
         }
         else
         {
            this.myCount.visible = false;
         }
      }
      
      override public function set width(w:Number) : void
      {
         myHitArea.width = myBackground.width = w;
         this.myCount.width = myLabel.width = myBackground.width - myLabel.x;
      }
      
      override public function get width() : Number
      {
         return myBackground.width;
      }
      
      override public function set height(h:Number) : void
      {
         myHitArea.height = myBackground.height = h;
      }
      
      override public function get height() : Number
      {
         return myBackground.height;
      }
      
      override protected function onMouseOver() : void
      {
         myBackground.gotoAndStop(OVER_STATE_FRAME);
         this.myArrow.gotoAndStop(ARROW_FOCUS_FRAME);
         myLabel.fontColor = GlobalGuide.WHITE;
      }
      
      override protected function onMouseOut() : void
      {
         if(true == this.mToggled)
         {
            myBackground.gotoAndStop(OPEN_FRAME);
         }
         else
         {
            myBackground.gotoAndStop(CLOSED_FRAME);
         }
         this.myArrow.gotoAndStop(ARROW_UNFOCUS_FRAME);
         myLabel.fontColor = GlobalGuide.CODO_BLUE_HIGHLIGHT;
      }
      
      override protected function onMouseClickUp() : void
      {
         if(myHitArea.hitTestPoint(stage.mouseX,stage.mouseY) == true)
         {
            myBackground.gotoAndStop(OVER_STATE_FRAME);
            this.toggled = !this.toggled;
         }
         else
         {
            this.onMouseOut();
         }
      }
   }
}

