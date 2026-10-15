package codo.objects
{
   public class UIStencilPageStencilStatusObj
   {
      
      public var pageID:String;
      
      public var allViewed:Boolean;
      
      public function UIStencilPageStencilStatusObj(pageID:String, allViewed:Boolean = false)
      {
         super();
         this.pageID = pageID;
         this.allViewed = allViewed;
      }
   }
}

