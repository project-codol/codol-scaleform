package codo.views.supplyDrop_parts
{
   import codo.component.TextField;
   import codo.style.ButtonGuide;
   import flash.display.Sprite;
   
   public class SupplyDropItemOpenButtonCounter extends Sprite
   {
      
      public var myCountTF:TextField;
      
      public var myBackground:Sprite;
      
      private var mCount:uint;
      
      public function SupplyDropItemOpenButtonCounter()
      {
         super();
         this.myCountTF.textStyle = ButtonGuide.styleSupplyDropItemOpenButtonCounter;
         this.myCountTF.width = this.myBackground.width;
         this.count = 0;
      }
      
      public function set count(val:uint) : void
      {
         if(val < 100)
         {
            this.myCountTF.text = val.toString();
         }
         else
         {
            this.myCountTF.text = "99+";
         }
         this.mCount = val;
      }
      
      public function get count() : uint
      {
         return this.mCount;
      }
   }
}

