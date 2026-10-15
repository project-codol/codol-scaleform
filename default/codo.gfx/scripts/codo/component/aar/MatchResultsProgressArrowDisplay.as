package codo.component.aar
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   public class MatchResultsProgressArrowDisplay extends MovieClip
   {
      
      public var myProgressValueTF:TextField;
      
      public var myProgressValueBkg:Sprite;
      
      public var myDiv:Sprite;
      
      public var mySep:Sprite;
      
      public var myArrowClip:Sprite;
      
      public function MatchResultsProgressArrowDisplay()
      {
         super();
         this.myProgressValueTF.autoSize = TextFieldAutoSize.RIGHT;
      }
      
      public function setProgressValDisplay(currentVal:int, targetVal:int = 0, label:String = "") : void
      {
         var targetValTxt:String = "";
         if(targetVal > 0)
         {
            targetValTxt = "/ " + targetVal.toString().concat(" <font color=\'#1cc5ff\' face=\'$font_2\' size=\'14\'>" + label + "</font>");
         }
         this.myProgressValueTF.htmlText = currentVal.toString().concat(" <font color=\'#1cc5ff\' face=\'$font_2\' size=\'14\'>" + label + "</font> ",targetValTxt);
         this.myProgressValueBkg.width = this.myProgressValueTF.textWidth + 5;
      }
      
      public function hideSep() : void
      {
         this.myDiv.visible = this.mySep.visible = false;
      }
      
      public function orientLeft() : void
      {
         var offSet:Number = NaN;
         offSet = this.myArrowClip.width * 0.5;
         this.myProgressValueTF.autoSize = TextFieldAutoSize.LEFT;
         this.myProgressValueBkg.x = this.myProgressValueBkg.width - offSet;
         this.myProgressValueTF.x = -(offSet - 5);
      }
   }
}

