package codo.views.hudDMZ
{
   import codo.utils.TextUtil;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class KeyHint extends MovieClip
   {
      
      private static const TEXT_SPACE:Number = 8;
      
      public var myKey:TextField;
      
      public var myLabel:TextField;
      
      public var myBGKey:MovieClip;
      
      public var myBGLabel:MovieClip;
      
      public function KeyHint()
      {
         super();
      }
      
      public function setHintText(keyText:String, labelText:String) : void
      {
         TextUtil.replaceEnFont(this.myKey,keyText,this.myKey.defaultTextFormat.font);
         this.myLabel.text = labelText;
      }
      
      public function expandKeyHint(keyTextWidth:Number) : void
      {
         this.myBGKey.width = keyTextWidth + TEXT_SPACE * 2;
         this.myKey.x = this.myBGKey.x + (this.myBGKey.width - this.myKey.width) * 0.5 - 0.5;
         var labelSpace:Number = this.myLabel.x - this.myBGLabel.x;
         this.myBGLabel.x = this.myBGKey.x + this.myBGKey.width;
         this.myLabel.x = this.myBGLabel.x + labelSpace;
      }
   }
}

