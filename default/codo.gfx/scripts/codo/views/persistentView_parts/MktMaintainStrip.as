package codo.views.persistentView_parts
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import scaleform.gfx.TextFieldEx;
   
   public class MktMaintainStrip extends MovieClip
   {
      
      public var myText:TextField;
      
      public function MktMaintainStrip()
      {
         super();
         TextFieldEx.setVerticalAlign(this.myText,TextFieldEx.VALIGN_CENTER);
      }
      
      public function set text(value:String) : void
      {
         this.myText.text = value;
      }
   }
}

