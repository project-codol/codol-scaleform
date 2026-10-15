package codo.component.playerinfo_part
{
   import codo.common.CFunctionCommonContainer;
   import codo.component.core.UIInteractiveComponent;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import fsg.util.FsgImageHolder;
   
   public class StaticLoadoutIcon extends UIInteractiveComponent
   {
      
      private static const DEFAULT_WIDTH:Number = 89;
      
      private static const DEFAULT_HEIGHT:Number = 90;
      
      public var myImage:FsgImageHolder;
      
      public var myBackground:MovieClip;
      
      public var myMask:Sprite;
      
      protected var mWidth:Number = 90;
      
      protected var mHeight:Number = 89;
      
      public function StaticLoadoutIcon()
      {
         super();
         this.myMask.visible = false;
         this.alignControl();
      }
      
      override public function setData(data:*) : void
      {
         super.setData(data);
         var itemId:int = data as int;
         var item:Object = CFunctionCommonContainer.GetItemInfo(int(itemId));
         if(item.id > 0)
         {
            this.myImage.setImage(item.imageURL);
         }
         else
         {
            this.myImage.setImage("");
         }
      }
      
      public function alignControl() : void
      {
         this.myBackground.width = this.myImage.width = this.mWidth;
         this.myBackground.height = this.myImage.height = this.mHeight;
         var halfWidth:Number = this.mWidth * 0.5;
         var halfHeight:Number = this.mHeight * 0.5;
         this.myImage.x = halfWidth - this.myImage.width * 0.5;
         this.myImage.y = halfHeight - this.myImage.height * 0.5;
      }
      
      public function resetView() : void
      {
         this.myImage.setImage("");
      }
      
      public function scaleImage(scale:Number) : void
      {
         this.myImage.scaleX = scale;
         this.myImage.scaleY = scale;
         this.myImage.x = (this.mWidth - this.myImage.width) * 0.5;
         this.myImage.y = (this.mHeight - this.myImage.height) * 0.5;
         this.myMask.height = this.mHeight - 2;
         this.myMask.width = this.mWidth - 2;
         this.myMask.visible = true;
         this.myImage.mask = this.myMask;
      }
      
      override public function set width(w:Number) : void
      {
         this.mWidth = w;
         this.alignControl();
      }
      
      override public function set height(h:Number) : void
      {
         this.mHeight = h;
         this.alignControl();
      }
   }
}

