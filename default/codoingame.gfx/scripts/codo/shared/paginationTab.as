package codo.shared
{
   import codo.component.PaginationTab;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1210")]
   public dynamic class paginationTab extends PaginationTab
   {
      
      public function paginationTab()
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

