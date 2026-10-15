package components.fsgpopups_part
{
   import codo.constants.ComponentCSS;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import scaleform.gfx.TextFieldEx;
   
   public class FsgPopupBaseSubheader extends Sprite
   {
      
      public var mySubHeaderText:TextField;
      
      public var mySubHeaderBkg:Sprite;
      
      public var myErrorIcon:Sprite;
      
      public var mySubHeaderErrorBkg:Sprite;
      
      public function FsgPopupBaseSubheader()
      {
         super();
         this.mySubHeaderText.autoSize = TextFieldAutoSize.LEFT;
         TextFieldEx.setVerticalAlign(this.mySubHeaderText,TextFieldEx.VALIGN_CENTER);
         visible = this.mySubHeaderErrorBkg.visible = this.myErrorIcon.visible = false;
      }
      
      public function set subheaderText(txt:String) : void
      {
         this.mySubHeaderText.text = txt;
         visible = true;
      }
      
      public function setSize(subheadWidth:int = -1, subheadHeight:int = -1) : void
      {
         if(subheadWidth > -1)
         {
            this.mySubHeaderBkg.width = this.mySubHeaderErrorBkg.width = subheadWidth;
            this.mySubHeaderBkg.x = 0;
         }
      }
      
      public function enableErrorHeader(flag:Boolean) : void
      {
         this.mySubHeaderErrorBkg.visible = flag;
         this.myErrorIcon.visible = flag;
         if(flag)
         {
            this.mySubHeaderText.textColor = 16777215;
            this.mySubHeaderText.x = 20;
         }
         else
         {
            this.mySubHeaderText.textColor = ComponentCSS.FSG_COLOR_BLUE;
            this.mySubHeaderText.x = 0;
         }
      }
   }
}

