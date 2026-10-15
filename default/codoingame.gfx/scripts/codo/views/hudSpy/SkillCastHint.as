package codo.views.hudSpy
{
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import fsg.util.FsgImageHolder;
   
   public class SkillCastHint extends MovieClip
   {
      
      public var myText:TextField;
      
      public var myImage:FsgImageHolder;
      
      public function SkillCastHint()
      {
         super();
         this.myText.autoSize = TextFieldAutoSize.LEFT;
         this.myImage.visible = false;
         this.myText.x = 0;
      }
      
      public function setData(data:Object) : void
      {
         this.myText.text = LocalizeUtil.localize("@" + data.text);
      }
      
      override public function get width() : Number
      {
         return this.myText.x + this.myText.textWidth;
      }
   }
}

