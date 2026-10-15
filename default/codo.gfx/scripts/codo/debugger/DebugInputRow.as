package codo.debugger
{
   import codo.component.Button;
   import codo.component.InputTextField;
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   
   public class DebugInputRow extends Button
   {
      
      public var myInputText:InputTextField;
      
      public function DebugInputRow()
      {
         super();
         var subLabelStyle:TextStyle = GlobalGuide.styleTextSmall;
         myLabel.textStyle = subLabelStyle;
         myLabel.height = myHitArea.height;
         myLabel.alignment = TextStyle.HALIGN_LEFT;
         myLabel.alignmentVertical = TextStyle.VALIGN_MIDDLE;
         myLabel.x = 10;
         this.myInputText.font = GlobalGuide.FONT_FACE_MEDIUM;
         this.myInputText.fontSize = GlobalGuide.FONT_SIZE_TINY;
         this.myInputText.alignment = TextStyle.HALIGN_RIGHT;
         this.myInputText.alignmentVertical = TextStyle.VALIGN_MIDDLE;
         this.myInputText.height = myHitArea.height;
         this.myInputText.x = 43;
      }
      
      override public function setData(data:*) : void
      {
         super.setData(data);
         if(null != data.inputText)
         {
            this.myInputText.text = data.inputText;
         }
         if(null != data.inputChangedCallback)
         {
            this.myInputText.registerOnInputChangeCallback(data.inputChangedCallback);
         }
      }
      
      public function get inputText() : String
      {
         return this.myInputText.text;
      }
      
      override public function draw() : void
      {
         myHitArea.width = mWidth;
         this.myInputText.width = myHitArea.width;
         this.myInputText.height = myHitArea.height;
      }
      
      override protected function onMouseOver() : void
      {
         super.onMouseOver();
         if(!mToggled)
         {
            this.myInputText.fontColor = GlobalGuide.BLACK;
         }
      }
      
      override protected function onMouseOut() : void
      {
         super.onMouseOut();
         if(!mToggled)
         {
            this.myInputText.fontColor = GlobalGuide.WHITE;
         }
      }
   }
}

