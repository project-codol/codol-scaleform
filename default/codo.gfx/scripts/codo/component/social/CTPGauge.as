package codo.component.social
{
   import codo.component.TextField;
   import codo.style.ClanGuide;
   import flash.display.MovieClip;
   import flash.text.TextFormat;
   
   public class CTPGauge extends MovieClip
   {
      
      public var myHighlight:MovieClip;
      
      public var myFill:MovieClip;
      
      public var myBg:MovieClip;
      
      public var myText:TextField;
      
      public var myLabel:TextField;
      
      private var mFillColor:Array;
      
      private var mFullWidth:Number;
      
      private var mFullHeight:Number;
      
      public function CTPGauge()
      {
         super();
         this.mFullWidth = this.myBg.width;
         this.mFullHeight = this.myBg.height;
         this.myLabel.textStyle = ClanGuide.styleCTPGaugeLabel;
         this.myText.textStyle = ClanGuide.styleCTPGaugeText;
      }
      
      public function setFillColor(color:Array) : void
      {
         this.mFillColor = color;
      }
      
      public function setLabel(label:String) : void
      {
         this.myLabel.text = label;
      }
      
      public function setValue(value:Number, full:Number, hideFull:Boolean = false) : void
      {
         var fillWidth:Number = NaN;
         if(full == 0)
         {
            return;
         }
         fillWidth = value / full * this.mFullWidth;
         if(fillWidth > this.mFullWidth)
         {
            fillWidth = this.mFullWidth;
         }
         var alphas:Array = [1,1];
         var ratio:Array = [0,255];
         this.myFill.graphics.clear();
         this.myFill.graphics.beginGradientFill("linear",this.mFillColor,alphas,ratio);
         this.myFill.graphics.drawRect(0,0,fillWidth,this.mFullHeight);
         if(fillWidth > this.myHighlight.width)
         {
            this.myHighlight.visible = true;
            this.myHighlight.x = fillWidth - this.myHighlight.width;
            this.myHighlight.y = 0;
         }
         else
         {
            this.myHighlight.visible = false;
         }
         this.setGaugeRular(value,full,hideFull);
      }
      
      public function setGaugeRular(value:Number, full:Number, hideFull:Boolean = false) : void
      {
         if(hideFull)
         {
            this.myText.text = String(value);
         }
         else
         {
            this.myText.text = String(value) + "/" + String(full);
         }
         var beginIndex:int = 0;
         var endIndex:int = String(value).length;
         this.myText.x = this.myBg.width - this.myText.textWidth;
         var tff:TextFormat = this.myText.myTextClip.getTextFormat(beginIndex,endIndex);
         tff.color = this.mFillColor[1];
         this.myText.myTextClip.setTextFormat(tff,beginIndex,endIndex);
      }
   }
}

