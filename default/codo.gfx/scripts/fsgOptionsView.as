package
{
   import codo.views.FsgOptionsView;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol3652")]
   public dynamic class fsgOptionsView extends FsgOptionsView
   {
      
      public function fsgOptionsView()
      {
         super();
         addFrameScript(0,this.frame1,13,this.frame14);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame14() : *
      {
         stop();
      }
   }
}

