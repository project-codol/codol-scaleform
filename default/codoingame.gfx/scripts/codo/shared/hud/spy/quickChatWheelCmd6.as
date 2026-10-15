package codo.shared.hud.spy
{
   import codo.views.hudSpy.QuickChatWheelItem;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol4279")]
   public dynamic class quickChatWheelCmd6 extends QuickChatWheelItem
   {
      
      public function quickChatWheelCmd6()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}

