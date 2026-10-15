package components.fsggamemodes_part
{
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   public class MatchSelectSharedInfoItem extends Sprite
   {
      
      public var myNameTF:TextField;
      
      public var myValueTF:TextField;
      
      public function MatchSelectSharedInfoItem()
      {
         super();
         this.myNameTF.autoSize = this.myValueTF.autoSize = TextFieldAutoSize.LEFT;
      }
      
      public function set itemName(txt:String) : void
      {
         this.myNameTF.text = txt;
      }
      
      public function set itemValue(val:String) : void
      {
         this.myValueTF.text = val;
      }
      
      public function get nameWidth() : uint
      {
         return this.myNameTF.textWidth;
      }
      
      public function set valueXPosition(xPos:uint) : void
      {
         this.myValueTF.x = xPos;
      }
   }
}

