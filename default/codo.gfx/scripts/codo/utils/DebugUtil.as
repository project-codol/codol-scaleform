package codo.utils
{
   public class DebugUtil
   {
      
      public function DebugUtil()
      {
         super();
      }
      
      public static function concatenateDebugSkuInfoToString(textToAddTo:String, product:Object) : String
      {
         var numSkus:int = 0;
         var skuIndex:int = 0;
         if(product != null)
         {
            textToAddTo += " [id: " + product.id + "]";
            if(Boolean(product.SKUs))
            {
               numSkus = int(product.SKUs.length);
               if(numSkus > 0)
               {
                  textToAddTo += " [SKUS";
                  for(skuIndex = 0; skuIndex < numSkus; skuIndex++)
                  {
                     textToAddTo += ":" + product.SKUs[skuIndex].id;
                  }
                  textToAddTo += "]";
               }
            }
         }
         return textToAddTo;
      }
   }
}

