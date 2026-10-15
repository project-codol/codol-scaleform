package
{
   import components.fsgSocialPanel_part.FsgNavArrow;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol4581")]
   public dynamic class fsgNavArrowInGame extends FsgNavArrow
   {
      
      public function fsgNavArrowInGame()
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

