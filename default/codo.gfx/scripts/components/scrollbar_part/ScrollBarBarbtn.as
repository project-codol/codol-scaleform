package components.scrollbar_part
{
   import codo.constants.SE_ID;
   import components.CodoGrowButton;
   
   public class ScrollBarBarbtn extends CodoGrowButton
   {
      
      private var _spaceBgToTop:Number;
      
      private var _spaceBgToBottom:Number;
      
      public function ScrollBarBarbtn()
      {
         super();
      }
      
      override protected function onInit() : void
      {
         this._spaceBgToTop = this.myBgNormal.y - this.myHitArea.y;
         this._spaceBgToBottom = this.myHitArea.y + this.myHitArea.height - (this.myBgNormal.y + this.myBgNormal.height);
         super.onInit();
         this.onStyleChangeForMatchType();
      }
      
      override public function set height(value:Number) : void
      {
         super.height = value;
         this.myBgNormal.height = this.myBgFocus.height = this.myHitArea.height;
      }
      
      override protected function playSound_down() : void
      {
         if(this._isSoundOn == true)
         {
            SOUND_UTIL.playSound(SE_ID.GENERAL_SCROLLBAR_MOUSEDOWN);
         }
      }
      
      override protected function playSound_rollOver() : void
      {
         if(this._isSoundOn == true)
         {
            SOUND_UTIL.playSound(SE_ID.GENERAL_SCROLLBAR_MOUSEOVER);
         }
      }
      
      override protected function playSound_click() : void
      {
         if(this._isSoundOn == true)
         {
            SOUND_UTIL.playSound(SE_ID.GENERAL_SCROLLBAR_MOUSEUP);
         }
      }
      
      override public function onStyleChangeForMatchType() : void
      {
         this.myBgFocus.gotoAndStop(this.currentMatchType + 1);
         this.myBgNormal.gotoAndStop(this.currentMatchType + 1);
      }
      
      override protected function setToRollOver(cTween:Boolean = true) : void
      {
         super.setToRollOver(cTween);
         this.myBgFocus.gotoAndStop(this.currentMatchType + 1);
      }
   }
}

