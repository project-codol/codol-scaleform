package fsg.popups
{
   import fsg.shared.popups.PopupCloseBtn;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1502")]
   public dynamic class fsgPopupCloseBtn extends PopupCloseBtn
   {
      
      public function fsgPopupCloseBtn()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2,22,this.frame23);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame2() : *
      {
         stop();
      }
      
      internal function frame23() : *
      {
         gotoAndPlay(3);
      }
   }
}

