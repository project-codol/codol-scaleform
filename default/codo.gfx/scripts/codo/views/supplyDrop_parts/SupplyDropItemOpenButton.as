package codo.views.supplyDrop_parts
{
   import codo.component.Button;
   
   public class SupplyDropItemOpenButton extends Button
   {
      
      public var myCounter:SupplyDropItemOpenButtonCounter;
      
      public function SupplyDropItemOpenButton()
      {
         super();
         this.count = 0;
      }
      
      override public function set label(txt:String) : void
      {
         super.label = txt;
      }
      
      public function set count(val:uint) : void
      {
         this.myCounter.count = val;
      }
      
      public function get count() : uint
      {
         return this.myCounter.count;
      }
      
      override public function set width(w:Number) : void
      {
         mWidth = w;
         this.myCounter.x = w / 2 + 10;
         this.draw();
      }
      
      override public function draw() : void
      {
         if(null != myBackground)
         {
            myBackground.width = mWidth - BACKGROUND_SIZE_OFFSET;
            myBackground.height = mHeight - BACKGROUND_SIZE_OFFSET;
         }
         myTabAccent.x = mWidth * 0.5 - myTabAccent.width * 0.5;
         myOutline.width = mWidth;
         myOutline.height = mHeight;
         myHitArea.width = mWidth;
         myHitArea.height = mHeight;
         myLabel.width = myHitArea.width - 20;
         myLabel.height = myHitArea.height;
         myHitArea.width = mWidth;
      }
   }
}

