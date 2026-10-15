package codo.home
{
   import codo.component.home.WarGodShortCut;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol3856")]
   public dynamic class wargodShortCut extends WarGodShortCut
   {
      
      public function wargodShortCut()
      {
         super();
         addFrameScript(3,this.frame4,8,this.frame9,13,this.frame14);
      }
      
      internal function frame4() : *
      {
         stop();
      }
      
      internal function frame9() : *
      {
         stop();
      }
      
      internal function frame14() : *
      {
         stop();
      }
   }
}

