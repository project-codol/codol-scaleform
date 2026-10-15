package codo.shared.hud.spy
{
   import codo.views.hudSpy.QuickChatWheelItem;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol4273")]
   public dynamic class quickChatWheelCmd7 extends QuickChatWheelItem
   {
      
      public function quickChatWheelCmd7()
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

