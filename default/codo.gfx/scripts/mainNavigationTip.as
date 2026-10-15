package
{
   import components.tip_part.MainNavigationTip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol3925")]
   public dynamic class mainNavigationTip extends MainNavigationTip
   {
      
      public function mainNavigationTip()
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

