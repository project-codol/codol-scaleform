package codo.matchselect
{
   import codo.component.matchselect.MatchSelectBonusTab;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol5622")]
   public dynamic class bonusTab extends MatchSelectBonusTab
   {
      
      public function bonusTab()
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

