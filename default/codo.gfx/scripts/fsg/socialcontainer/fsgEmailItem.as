package fsg.socialcontainer
{
   import components.fsgSocialPanel_part.FsgEmailItem;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol6120")]
   public dynamic class fsgEmailItem extends FsgEmailItem
   {
      
      public function fsgEmailItem()
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

