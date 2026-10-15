package codo.objects
{
   import flash.geom.Point;
   
   public class QTGameCircleConfigObj
   {
      
      public var btnPos:Point;
      
      public var btnWidth:uint;
      
      public var btnHeight:uint;
      
      public var isButtonClickable:Boolean;
      
      public var isButtonHidden:Boolean;
      
      public function QTGameCircleConfigObj(btnPos:Point, btnWidth:uint, btnHeight:uint, isButtonClickable:Boolean = true, isButtonHidden:Boolean = false)
      {
         super();
         this.btnPos = btnPos;
         this.btnWidth = btnWidth;
         this.btnHeight = btnHeight;
         this.isButtonClickable = isButtonClickable;
         this.isButtonHidden = isButtonHidden;
      }
   }
}

