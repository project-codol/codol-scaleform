package codo.component
{
   import codo.component.core.UIInteractiveComponent;
   import codo.style.GlobalGuide;
   import flash.display.MovieClip;
   
   public class ListHeader extends UIInteractiveComponent
   {
      
      public var myLabel:TextField;
      
      public var myBackground:MovieClip;
      
      public function ListHeader()
      {
         super();
         this.myBackground.alpha = 0.1;
         this.myLabel.fontColor = GlobalGuide.CODO_BLUE_HIGHLIGHT;
         this.myLabel.fontSize = GlobalGuide.FONT_SIZE_SMALL;
         this.myLabel.x = this.myBackground.x + GlobalGuide.COMPONENT_PADDING;
         this.myLabel.width = this.myBackground.width - this.myLabel.x;
      }
      
      override public function setData(data:*) : void
      {
         super.setData(data);
         if(null != data.label)
         {
            this.myLabel.text = data.label;
         }
      }
      
      override public function set width(w:Number) : void
      {
         this.myBackground.width = w;
         this.myLabel.width = this.myBackground.width - this.myLabel.x;
      }
      
      override public function get width() : Number
      {
         return this.myBackground.width;
      }
      
      override public function set height(h:Number) : void
      {
         this.myBackground.height = h;
      }
      
      override public function get height() : Number
      {
         return this.myBackground.height;
      }
   }
}

