package codo.objects
{
   public class PageListSettings
   {
      
      public var itemCountPerPage:int;
      
      public var itemPadding:int;
      
      public var renderLinkName:String;
      
      public var itemClickHandler:Function;
      
      public var itemInteractiveHandler:Function;
      
      public var extraHandler:Function;
      
      public var onDataSetHandler:Function;
      
      public var onGoingToRefreshHandler:Function;
      
      public var customPageSelectorHandler:Function;
      
      public function PageListSettings()
      {
         super();
      }
   }
}

