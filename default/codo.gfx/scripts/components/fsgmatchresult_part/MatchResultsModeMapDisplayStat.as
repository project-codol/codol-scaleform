package components.fsgmatchresult_part
{
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   public class MatchResultsModeMapDisplayStat extends Sprite
   {
      
      public var myStatNameTF:TextField;
      
      public var myStatValueTF:TextField;
      
      public function MatchResultsModeMapDisplayStat()
      {
         super();
         this.myStatNameTF.autoSize = this.myStatValueTF.autoSize = TextFieldAutoSize.LEFT;
      }
      
      public function setStatData(statName:String, statValue:*) : void
      {
         this.myStatNameTF.text = statName;
         this.myStatValueTF.text = statValue;
         this.myStatValueTF.x = this.myStatNameTF.x + this.myStatNameTF.textWidth + 5;
      }
   }
}

