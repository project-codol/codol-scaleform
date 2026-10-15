package codo.views.hudSpy
{
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import fsg.util.FsgImageHolder;
   
   public class FeaturedSpyHint extends MovieClip
   {
      
      private static const BG_MARGIN:int = 5;
      
      private static const IMAGE_WIDTH:int = 48;
      
      public var myText:TextField;
      
      public var myImage:FsgImageHolder;
      
      public var myTips:TextField;
      
      public var myBG:MovieClip;
      
      private var mUseImage:Boolean = true;
      
      public function FeaturedSpyHint()
      {
         super();
         this.myText.autoSize = TextFieldAutoSize.LEFT;
         this.myTips.autoSize = TextFieldAutoSize.LEFT;
      }
      
      public function setData(data:*) : void
      {
         if(Boolean(data.translated))
         {
            this.myText.text = data.text;
            this.myTips.text = data.tips;
         }
         else
         {
            LocalizeUtil.localizeTextField(this.myText,"@" + data.text);
            LocalizeUtil.localizeTextField(this.myTips,"@" + data.tips);
         }
         this.mUseImage = data.image.length > 0;
         this.myImage.visible = this.mUseImage;
         var firstRowWidth:Number = (this.mUseImage ? 0 : IMAGE_WIDTH) + this.myText.textWidth;
         if(this.mUseImage)
         {
            this.myImage.setImage(data.image);
         }
         if(firstRowWidth > this.myTips.textWidth)
         {
            this.myImage.x = 0;
            this.myText.x = this.mUseImage ? IMAGE_WIDTH : 0;
            this.myTips.x = (this.myText.x + this.myText.textWidth - this.myTips.textWidth) / 2;
         }
         else
         {
            this.myTips.x = 0;
            if(this.mUseImage)
            {
               this.myImage.x = (this.myTips.textWidth - IMAGE_WIDTH - this.myText.textWidth) / 2;
               this.myText.x = this.myImage.x + IMAGE_WIDTH;
            }
            else
            {
               this.myImage.x = this.myText.x = (this.myTips.textWidth - this.myText.textWidth) / 2;
            }
         }
         this.myBG.x = this.myImage.x - BG_MARGIN;
         this.myBG.width = this.myText.x + this.myText.textWidth + 2 * BG_MARGIN - this.myBG.x;
      }
      
      override public function get width() : Number
      {
         return Math.max((this.mUseImage ? IMAGE_WIDTH : 0) + this.myText.textWidth,this.myTips.textWidth);
      }
   }
}

