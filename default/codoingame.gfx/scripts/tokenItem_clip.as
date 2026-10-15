package
{
   import fsg.component.FsgCyborgTokenItem;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol4613")]
   public dynamic class tokenItem_clip extends FsgCyborgTokenItem
   {
      
      public function tokenItem_clip()
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

