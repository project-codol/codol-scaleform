package
{
   import components.fsggamemodes_part.GameModesTutorialButton;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol535")]
   public dynamic class gameModeTutorialButton extends GameModesTutorialButton
   {
      
      public function gameModeTutorialButton()
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

