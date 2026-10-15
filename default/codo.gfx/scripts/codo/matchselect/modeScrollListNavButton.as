package codo.matchselect
{
   import codo.component.matchselect.MatchSelectModeScrollNavButton;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol5649")]
   public dynamic class modeScrollListNavButton extends MatchSelectModeScrollNavButton
   {
      
      public function modeScrollListNavButton()
      {
         super();
         addFrameScript(69,this.frame70);
      }
      
      internal function frame70() : *
      {
         gotoAndPlay(1);
      }
   }
}

