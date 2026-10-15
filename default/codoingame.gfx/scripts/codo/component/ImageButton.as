package codo.component
{
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   import fsg.util.FsgImageHolder;
   
   public class ImageButton extends Button
   {
      
      public var myImage:FsgImageHolder;
      
      public function ImageButton()
      {
         super();
         myLabel.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         myLabel.alignmentVertical = TextStyle.VALIGN_TOP;
      }
      
      override public function setData(data:*) : void
      {
         super.setData(data);
         this.myImage.setImage(data.imageURL);
         if(data.height != null)
         {
            height = data.height;
         }
         if(data.width != null)
         {
            width = data.width;
         }
      }
      
      override public function draw() : void
      {
         super.draw();
         myHitArea.width = myBackground.width = mWidth;
         myHitArea.height = myBackground.height = mHeight;
         var labelOffset:Number = myLabel.y + myLabel.textHeight;
         var offsetHeight:Number = mHeight - labelOffset - 40;
         var offsetWidth:Number = mWidth - 40;
         var aspectSize:int = offsetHeight > offsetWidth ? int(offsetHeight) : int(offsetWidth);
         this.myImage.width = aspectSize;
         this.myImage.height = aspectSize;
         var halfWidth:Number = mWidth * 0.5;
         var halfHeight:Number = offsetHeight * 0.5;
         this.myImage.x = halfWidth - this.myImage.width * 0.5;
         this.myImage.y = labelOffset + halfHeight - this.myImage.height * 0.5 + 15;
      }
      
      override public function get height() : Number
      {
         return myHitArea.height;
      }
      
      override public function get width() : Number
      {
         return myHitArea.width;
      }
   }
}

