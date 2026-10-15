package codo.shared.hud.spy
{
   import codo.views.hudSpy.QuickChatWheelItem;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol4291")]
   public dynamic class quickChatWheelCmd4 extends QuickChatWheelItem
   {
      
      public function quickChatWheelCmd4()
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

