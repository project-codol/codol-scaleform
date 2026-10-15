package components.fsgTrainingComplete_part
{
   import fsg.util.FsgImageHolder;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol2626")]
   public dynamic class fsgDisaplineIcons_comp extends FsgImageHolder
   {
      
      public function fsgDisaplineIcons_comp()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2,2,this.frame3);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame2() : *
      {
         stop();
      }
      
      internal function frame3() : *
      {
         stop();
      }
   }
}

