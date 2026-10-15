package codo.views.motd_parts
{
   import codo.component.filter.Filter;
   
   public class MOTDFilter extends Filter
   {
      
      private var mOverideSelectedIndex:int = -1;
      
      public function MOTDFilter()
      {
         super();
      }
      
      override protected function get filterCategoryButtonClassPath() : String
      {
         return "codo.shared.motd.MOTDFilterCategoryButton";
      }
      
      override public function get width() : Number
      {
         return 440;
      }
      
      override public function getSelectedIndex() : int
      {
         return this.mOverideSelectedIndex > -1 ? this.mOverideSelectedIndex : _selectedIndex;
      }
      
      public function reset() : void
      {
         _selectedIndex = 0;
      }
      
      public function set overrideIndex(overrideInxex:int) : void
      {
         this.mOverideSelectedIndex = overrideInxex;
      }
   }
}

