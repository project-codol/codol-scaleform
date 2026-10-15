package codo.shared.hud.spy
{
   import codo.views.hudSpy.QuickChatWheelItem;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol4267")]
   public dynamic class quickChatWheelCmd8 extends QuickChatWheelItem
   {
      
      public function quickChatWheelCmd8()
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

