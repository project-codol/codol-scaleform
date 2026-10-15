package fsg.widgets
{
   import fsg.shared.popups.PopupProgressRank;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol886")]
   public dynamic class fsgProgressRank extends PopupProgressRank
   {
      
      public function fsgProgressRank()
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

