package codo.debugger
{
   import codo.component.Button;
   import codo.component.TextField;
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   
   public class DebugButton extends Button
   {
      
      private static const SUB_LABEL_EDIT_OFFSET:Number = 25;
      
      private static const SUB_LABEL_DEFAULT_OFFSET:Number = 10;
      
      private static const UNFOCUS_ALPHA:Number = 0.75;
      
      public var mySubLabel:TextField;
      
      public var myEditButton:Button;
      
      private var mMouseOverCallback:Function;
      
      public function DebugButton()
      {
         var subLabelStyle:TextStyle = null;
         super();
         this.myEditButton.label = "EDIT";
         this.myEditButton.width = 80;
         this.myEditButton.height = myHitArea.height;
         this.myEditButton.visible = false;
         subLabelStyle = GlobalGuide.styleTextSmall;
         myLabel.textStyle = subLabelStyle;
         myLabel.height = myHitArea.height;
         myLabel.alignment = TextStyle.HALIGN_LEFT;
         myLabel.alignmentVertical = TextStyle.VALIGN_MIDDLE;
         myLabel.x = 10;
         this.mySubLabel.textStyle = subLabelStyle;
         this.mySubLabel.alignment = TextStyle.HALIGN_RIGHT;
         this.mySubLabel.alignmentVertical = TextStyle.VALIGN_MIDDLE;
         this.mySubLabel.height = myHitArea.height;
         myLabel.fontColor = GlobalGuide.GRAY_50;
         this.mySubLabel.fontColor = GlobalGuide.GRAY_50;
         mWidth = myHitArea.width;
         myBackground.alpha = UNFOCUS_ALPHA;
      }
      
      override public function setData(data:*) : void
      {
         super.setData(data);
         if(null != data.subLabel)
         {
            this.mySubLabel.text = data.subLabel;
         }
         else
         {
            this.mySubLabel.text = "";
         }
         if(null != data.mouseOverCallback)
         {
            this.mMouseOverCallback = data.mouseOverCallback;
         }
         var disp:MovieClip = data.clickEventData as MovieClip;
         if(null != disp && disp is DisplayObject)
         {
            this.myEditButton.visible = true;
            this.myEditButton.registerClickEvent(data.editClickCallback,this);
            this.myEditButton.x = mWidth - this.myEditButton.width - GlobalGuide.COMPONENT_PADDING;
            this.mySubLabel.x = myBackground.x + myBackground.width - this.myEditButton.width - this.mySubLabel.textWidth - SUB_LABEL_EDIT_OFFSET;
         }
         else
         {
            this.myEditButton.visible = false;
            this.mySubLabel.x = myBackground.x + myBackground.width - this.mySubLabel.textWidth - SUB_LABEL_DEFAULT_OFFSET;
         }
      }
      
      override protected function onMouseOver() : void
      {
         super.onMouseOver();
         if(null != this.mMouseOverCallback)
         {
            this.mMouseOverCallback(this);
         }
         if(!mToggled)
         {
            myLabel.fontColor = GlobalGuide.WHITE;
            this.mySubLabel.fontColor = GlobalGuide.WHITE;
            myBackground.alpha = 1;
         }
      }
      
      override protected function onMouseOut() : void
      {
         super.onMouseOut();
         if(!mToggled)
         {
            myLabel.fontColor = GlobalGuide.GRAY_50;
            this.mySubLabel.fontColor = GlobalGuide.GRAY_50;
            myBackground.alpha = UNFOCUS_ALPHA;
         }
      }
      
      override public function get width() : Number
      {
         return mWidth;
      }
      
      override public function set width(w:Number) : void
      {
         myLabel.width = myHitArea.width = mWidth = w;
         this.draw();
      }
      
      override public function draw() : void
      {
         super.draw();
         myBackground.width = mWidth;
         myBackground.height = mHeight;
         this.mySubLabel.width = myHitArea.width;
      }
   }
}

