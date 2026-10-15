package components.fsgSocialPanel_part
{
   import flash.display.MovieClip;
   import flash.display.Shape;
   
   public class FsgEmailScrollArea extends MovieClip
   {
      
      private var m_areaHeight:Number = 0;
      
      private var m_wheelArea:MovieClip;
      
      public function FsgEmailScrollArea()
      {
         super();
         var rectangle:Shape = new Shape();
         rectangle.graphics.beginFill(0,0);
         rectangle.graphics.drawRect(0,0,1,1);
         rectangle.graphics.endFill();
         this.m_wheelArea = new MovieClip();
         this.m_wheelArea.addChild(rectangle);
         this.addChild(this.m_wheelArea);
         this.m_wheelArea.width = this.width;
         this.m_wheelArea.height = this.m_areaHeight;
      }
      
      public function set scrollAreaHeight(height:Number) : void
      {
         this.m_areaHeight = height;
         this.m_wheelArea.height = this.m_areaHeight;
      }
      
      override public function get height() : Number
      {
         return this.m_areaHeight;
      }
   }
}

