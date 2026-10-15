package codo.objects
{
   import codo.constants.WebImgData;
   
   public class FeaturedItemsObj
   {
      
      public var tencentItems:Array = [];
      
      public var hotItems:Array = [];
      
      public var newItems:Array = [];
      
      public var recommendedItems:Array = [];
      
      public var popularItems:Array = [];
      
      public var hotAdItem:Object;
      
      public var newAdItem:Object;
      
      public var recommendAdItem:Object;
      
      public var popularAdItem:Object;
      
      public function FeaturedItemsObj()
      {
         super();
         this.tencentItems = [WebImgData.MARKET_AD1,WebImgData.MARKET_AD2,WebImgData.MARKET_AD3,WebImgData.MARKET_AD4,WebImgData.MARKET_AD5];
      }
   }
}

