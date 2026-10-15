package
{
   import components.fsgpersistent_part.QtCrateButton;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol4739")]
   public dynamic class qtCrateButton extends QtCrateButton
   {
      
      public function qtCrateButton()
      {
         super();
         addFrameScript(88,this.frame89,94,this.frame95,100,this.frame101);
      }
      
      internal function frame89() : *
      {
         gotoAndPlay("start");
      }
      
      internal function frame95() : *
      {
         stop();
      }
      
      internal function frame101() : *
      {
         gotoAndPlay("start");
      }
   }
}

