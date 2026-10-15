package codo.shared.hud.spy
{
   import codo.views.hudSpy.QuickChatWheelItem;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol4309")]
   public dynamic class quickChatWheelCmd1 extends QuickChatWheelItem
   {
      
      public function quickChatWheelCmd1()
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

