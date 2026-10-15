package codo.views.quit_parts
{
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class QuitGameSummaryStat extends Sprite
   {
      
      public static const FRAME_XP:int = 1;
      
      public static const FRAME_GP:int = 2;
      
      public static const FRAME_NONE:int = 3;
      
      public var myIcon:MovieClip;
      
      public var myStatLabelTF:TextField;
      
      public var myStatValueTF:TextField;
      
      public function QuitGameSummaryStat()
      {
         super();
      }
      
      public function setContent(label:String, value:String, iconFrame:int = 3) : void
      {
         var tfWidth:int = 0;
         var textColor:uint = 16777215;
         var tfLabel:TextFormat = this.myStatLabelTF.getTextFormat();
         var tfValue:TextFormat = this.myStatValueTF.getTextFormat();
         var MAX:Function = Math.max;
         this.myIcon.gotoAndStop(iconFrame);
         this.myStatLabelTF.text = LocalizeUtil.localize(label);
         this.myStatValueTF.text = value;
         tfWidth = MAX(this.myStatLabelTF.textWidth,this.myStatValueTF.textWidth) + 10;
         this.myStatLabelTF.width = this.myStatValueTF.width = tfWidth;
         switch(iconFrame)
         {
            case FRAME_XP:
               textColor = 1885695;
               tfLabel.align = tfValue.align = "left";
               break;
            case FRAME_GP:
               tfLabel.align = tfValue.align = "center";
               break;
            case FRAME_NONE:
               tfLabel.align = tfValue.align = "right";
         }
         this.myStatLabelTF.setTextFormat(tfLabel);
         this.myStatValueTF.setTextFormat(tfValue);
         this.myStatValueTF.textColor = textColor;
      }
   }
}

