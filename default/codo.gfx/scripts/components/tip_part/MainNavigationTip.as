package components.tip_part
{
   import codo.utils.LocalizeUtil;
   
   public class MainNavigationTip extends BaseTip
   {
      
      private static const PADDING:int = 4;
      
      private var mOffsetX:Number;
      
      private var mFlip:Boolean;
      
      public function MainNavigationTip()
      {
         super();
         this.mOffsetX = 0;
         this.mFlip = false;
      }
      
      override protected function onInit() : void
      {
         super.onInit();
         onStyleChangeForMatchType();
      }
      
      public function setFlipped(val:Boolean) : void
      {
         this.mFlip = val;
         myPointer.scaleY = Math.abs(myPointer.scaleY) * (this.mFlip ? -1 : 1);
         this.refresh();
      }
      
      public function offsetX(nX:Number) : void
      {
         this.mOffsetX = nX;
         this.refresh();
      }
      
      override public function set textWidth(nWidth:Number) : void
      {
         super.textWidth = nWidth;
         this.refresh();
      }
      
      override public function set data(cTxt:String) : void
      {
         this.mOffsetX = 0;
         myLabel.htmlText = LocalizeUtil.getLocalizationWithKeyBinding(cTxt);
         myLabel.width = myLabel.textWidth + 10;
         myBg.width = _labelMarginLeft + myLabel.width + _labelMarginRight;
         this.refresh();
      }
      
      private function refresh() : void
      {
         var bgHeight:Number = _labelMarginTop + myLabel.height + _labelMarginBottom;
         myLabel.x = -myLabel.width / 2 + this.mOffsetX;
         myBg.x = myLabel.x - _labelMarginLeft;
         if(!this.mFlip)
         {
            myBg.height = bgHeight;
            myBg.scaleY = Math.abs(myBg.scaleY);
            myLabel.y = PADDING;
         }
         else
         {
            myBg.height = bgHeight;
            myBg.scaleY = -Math.abs(myBg.scaleY);
            myLabel.y = -bgHeight + PADDING;
         }
         var halfPointBorderWidth:Number = (myBg.width - myPointer.myPointerBorder.width) / 2;
         myPointer.myBorderLeft.width = halfPointBorderWidth - this.mOffsetX;
         myPointer.myBorderRight.width = halfPointBorderWidth + this.mOffsetX;
      }
   }
}

