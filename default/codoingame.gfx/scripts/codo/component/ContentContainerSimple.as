package codo.component
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class ContentContainerSimple extends Sprite
   {
      
      protected var mWidth:Number = 0;
      
      protected var mHeight:Number = 0;
      
      public var myBackground:MovieClip;
      
      public var myBackgroundNoFrame:Sprite;
      
      public function ContentContainerSimple()
      {
         super();
         this.width = this.width;
         this.height = this.height;
         this.myBackgroundNoFrame.visible = false;
      }
      
      override public function set width(value:Number) : void
      {
         scaleX = 1;
         this.myBackground.width = this.myBackgroundNoFrame.width = this.mWidth = value;
      }
      
      override public function set height(value:Number) : void
      {
         scaleY = 1;
         this.myBackground.height = this.myBackgroundNoFrame.height = this.mHeight = value;
      }
      
      public function setBackgroundColorLight() : void
      {
         this.myBackground.gotoAndStop(1);
      }
      
      public function setBackgroundColorDark() : void
      {
         this.myBackground.gotoAndStop(2);
      }
      
      public function setStyleNoFrame() : void
      {
         this.myBackground.visible = false;
         this.myBackgroundNoFrame.visible = true;
      }
   }
}

