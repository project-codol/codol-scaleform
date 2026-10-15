package
{
   import components.fsgSocialPanel_part.FsgNavArrow;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol5300")]
   public dynamic class fsgNavArrow extends FsgNavArrow
   {
      
      public function fsgNavArrow()
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

